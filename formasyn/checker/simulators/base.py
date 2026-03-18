"""质量仿真基类.

本模块定义了所有 Quality Simulator 的基类接口，
L3b 质量仿真根据 kernel_type 分发到具体的 Simulator 实现。
"""

from __future__ import annotations

import logging
import os
import platform
import subprocess
import tempfile
from abc import ABC, abstractmethod
from typing import Optional

import numpy as np

logger = logging.getLogger(__name__)


class QualitySimulator(ABC):
    """质量仿真基类.

    所有具体的 Simulator（BERSimulator, FilterSimulator 等）都必须继承此类
    并实现 evaluate() 方法。

    子类需要：
    1. 实现 kernel_type 类属性，指定适用的算法类别
    2. 实现 evaluate() 方法，运行仿真并返回质量指标
    3. 可选：实现 _compile_to_so() 方法，自定义编译逻辑
    """

    kernel_type: str = ""

    @abstractmethod
    def evaluate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行仿真并返回质量指标.

        Args:
            hls_cpp_code: HLS C++ 源码.
            test_inputs: 测试输入数据.
            golden_outputs: Golden 参考输出.
            csr_data: 可选的 CSR 格式稀疏矩阵数据.

        Returns:
            质量指标字典，如 {'nmse_db': -45.3, 'sfdr_db': 65.2}
        """

    @staticmethod
    def _strip_hls_specifics(code: str) -> str:
        """移除 g++ 不支持的 HLS 特定 pragma."""
        stripped: list[str] = []
        for line in code.splitlines():
            if line.lstrip().startswith("#pragma HLS"):
                continue
            stripped.append(line)
        return "\n".join(stripped) + "\n"

    @staticmethod
    def _write_mock_hls_headers(out_dir: str) -> None:
        """写入最小化的 HLS 兼容头文件，用于 host 仿真."""
        headers = {
            "ap_int.h": (
                "#pragma once\n"
                "#include <cstdint>\n"
                "template<int W> using ap_int = int;\n"
                "template<int W> using ap_uint = unsigned int;\n"
            ),
            "ap_fixed.h": (
                "#pragma once\n"
                "#include \"ap_int.h\"\n"
                "template<int W, int I=0> using ap_fixed = double;\n"
            ),
            "hls_stream.h": (
                "#pragma once\n"
                "template<typename T> struct hls_stream {};\n"
            ),
        }
        for name, content in headers.items():
            with open(os.path.join(out_dir, name), "w", encoding="utf-8") as f:
                f.write(content)

    @staticmethod
    def _compile_to_so(
        hls_cpp_code: str,
        function_name: str = "kernel",
    ) -> str:
        """将 HLS C++ 代码编译为 .so 动态库.

        Args:
            hls_cpp_code: HLS C++ 源码（已移除 HLS pragma）.
            function_name: 顶层函数名.

        Returns:
            编译生成的 .so 文件路径.

        Raises:
            RuntimeError: 如果编译失败.
        """
        tmp_dir = tempfile.mkdtemp(prefix="formasyn_so_")
        src_path = os.path.join(tmp_dir, f"{function_name}.cpp")
        so_path = os.path.join(tmp_dir, f"{function_name}.so")

        with open(src_path, "w", encoding="utf-8") as f:
            f.write(hls_cpp_code)

        QualitySimulator._write_mock_hls_headers(tmp_dir)

        # 编译为 .so
        cmd = [
            "g++",
            "-std=c++14",
            "-O2",
            "-fPIC",
            "-shared",
            f"-I{tmp_dir}",
            src_path,
            "-o",
            so_path,
        ]

        try:
            proc = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=60,
            )
        except FileNotFoundError:
            raise RuntimeError("g++ not found on PATH")
        except subprocess.TimeoutExpired:
            raise RuntimeError("g++ compilation timed out")

        if proc.returncode != 0:
            raise RuntimeError(f"g++ compilation failed:\n{proc.stderr}")

        return so_path

    @staticmethod
    def _compute_nmse(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float:
        """计算归一化均方误差（NMSE）dB.

        Args:
            golden: Golden 参考输出.
            actual: 实际输出.

        Returns:
            NMSE in dB.
        """
        power_signal = 0.0
        power_noise = 0.0

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))
            g, a = g[:min_len], a[:min_len]

            power_signal += float(np.sum(g ** 2))
            power_noise += float(np.sum((g - a) ** 2))

        if power_signal < 1e-30:
            return 0.0
        return 10 * np.log10(max(power_noise, 1e-30) / power_signal)

    @staticmethod
    def _compute_sign_error_rate(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> tuple[float, float, float]:
        """计算符号错误率和 SNR 惩罚.

        Args:
            golden: Golden 参考输出.
            actual: 实际输出.

        Returns:
            (sign_error_rate, snr_penalty_db, power_signal)
        """
        import math

        sign_errors = 0
        total_elements = 0
        power_signal = 0.0
        power_noise = 0.0

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))
            g, a = g[:min_len], a[:min_len]

            sign_errors += int(np.sum(np.sign(g) != np.sign(a)))
            total_elements += min_len
            power_signal += float(np.sum(g ** 2))
            power_noise += float(np.sum((g - a) ** 2))

        sign_error_rate = sign_errors / max(total_elements, 1)

        if power_noise > 0 and power_signal > 0:
            snr_golden = 10 * math.log10(power_signal / 1e-10)
            snr_actual = 10 * math.log10(power_signal / max(power_noise, 1e-30))
            snr_penalty_db = max(0.0, snr_golden - snr_actual)
        else:
            snr_penalty_db = 0.0

        return sign_error_rate, snr_penalty_db, power_signal


def get_simulator(kernel_type: str) -> type[QualitySimulator]:
    """根据 kernel_type 获取对应的 Simulator 类.

    Args:
        kernel_type: 算法类别.

    Returns:
        对应的 Simulator 类.

    Raises:
        ValueError: 如果 kernel_type 不支持.
    """
    from FormaSyn.formasyn.checker.simulators.ber_sim import BERSimulator
    from FormaSyn.formasyn.checker.simulators.detection_sim import DetectionSimulator
    from FormaSyn.formasyn.checker.simulators.filter_sim import FilterSimulator
    from FormaSyn.formasyn.checker.simulators.sync_sim import SyncSimulator
    from FormaSyn.formasyn.checker.simulators.transform_sim import TransformSimulator

    sim_map: dict[str, type[QualitySimulator]] = {
        "channel_coding": BERSimulator,
        "demodulation": BERSimulator,
        "filtering": FilterSimulator,
        "transform": TransformSimulator,
        "detection": DetectionSimulator,
        "synchronization": SyncSimulator,
    }

    sim_class = sim_map.get(kernel_type)
    if sim_class is None:
        raise ValueError(f"Unsupported kernel_type: {kernel_type}")
    return sim_class
