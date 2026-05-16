"""质量仿真基类.

本模块定义了所有 Quality Simulator 的基类接口，
L3b 质量仿真根据 kernel_type 分发到具体的 Simulator 实现。
"""

from __future__ import annotations

import ctypes
import logging
import os
import subprocess
import tempfile
from abc import ABC, abstractmethod
from typing import Optional

from FormaSyn.formasyn.utils.cpp_utils import extract_function_name
from FormaSyn.formasyn.utils.hls_mock import strip_hls_pragmas, write_mock_headers
from FormaSyn.formasyn.utils.metrics import compute_nmse, compute_sign_error_rate

logger = logging.getLogger(__name__)


class QualitySimulator(ABC):
    """质量仿真基类.

    所有具体的 Simulator（BERSimulator, FilterSimulator 等）都必须继承此类
    并实现 evaluate() 方法。

    子类需要：
    1. 实现 kernel_type 类属性，指定适用的算法类别
    2. 实现 evaluate() 方法，运行仿真并返回质量指标
    """

    kernel_type: str = ""

    @abstractmethod
    def evaluate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        hls_header_code: str | None = None,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行仿真并返回质量指标.

        Args:
            hls_cpp_code: HLS C++ 源码.
            test_inputs: 测试输入数据.
            golden_outputs: Golden 参考输出.
            hls_header_code: 可选的 kernel.h 内容.
            csr_data: 可选的 CSR 格式稀疏矩阵数据.

        Returns:
            质量指标字典，如 {'nmse_db': -45.3, 'sfdr_db': 65.2}
        """

    # -- 编译工具方法 ---------------------------------------------------------

    @staticmethod
    def _compile_to_so(
        hls_cpp_code: str,
        function_name: str = "kernel",
        hls_header_code: str | None = None,
    ) -> str:
        """将 HLS C++ 代码编译为 .so 动态库.

        Args:
            hls_cpp_code: HLS C++ 源码（已移除 HLS pragma）.
            function_name: 顶层函数名.
            hls_header_code: 可选的 kernel.h 内容.

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

        write_mock_headers(tmp_dir, hls_header_code)

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

    # -- SO 调用 ---------------------------------------------------------------

    @staticmethod
    def _run_so_simple(
        so_path: str,
        function_name: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, list[float]]:
        """通过 ctypes 调用编译好的 .so 并返回输出.

        假定函数签名形式为: void kernel(..., output[], int output_len, ...)
        """
        lib = ctypes.CDLL(so_path)

        func = getattr(lib, function_name, None)
        if func is None:
            raise RuntimeError(f"Function '{function_name}' not found in {so_path}")

        args = []
        for key, values in test_inputs.items():
            arr = (ctypes.c_double * len(values))(*values)
            args.append(arr)
            args.append(ctypes.c_int(len(values)))

        for key in golden_outputs:
            out_len = len(golden_outputs[key])
            out_array = (ctypes.c_double * out_len)()
            args.append(out_array)
            args.append(ctypes.c_int(out_len))

        if csr_data is not None:
            rp_arr = (ctypes.c_int * len(csr_data["row_ptr"]))(*csr_data["row_ptr"])
            ci_arr = (ctypes.c_int * len(csr_data["col_idx"]))(*csr_data["col_idx"])
            args.append(rp_arr)
            args.append(ctypes.c_int(len(csr_data["row_ptr"])))
            args.append(ci_arr)
            args.append(ctypes.c_int(len(csr_data["col_idx"])))

        func(*args)

        result = {}
        for key, out_array in zip(golden_outputs.keys(), args[2 * len(test_inputs)::2]):
            result[key] = list(out_array)

        return result

    # -- 指标计算 (委托给共享工具模块) -----------------------------------------

    @staticmethod
    def _compute_nmse(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float:
        """计算归一化均方误差（NMSE）dB."""
        return compute_nmse(golden, actual)

    @staticmethod
    def _compute_sign_error_rate(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> tuple[float, float, float]:
        """计算符号错误率和 SNR 惩罚."""
        return compute_sign_error_rate(golden, actual)


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
        "elementwise": TransformSimulator,
        "arithmetic": TransformSimulator,
        "generic": TransformSimulator,
    }

    sim_class = sim_map.get(kernel_type)
    if sim_class is None:
        raise ValueError(f"Unsupported kernel_type: {kernel_type}")
    return sim_class
