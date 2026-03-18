"""Transform Simulator: transform 类算法的质量仿真.

计算 SFDR（无杂散动态范围）和 NMSE 等指标。
"""

from __future__ import annotations

import logging

import numpy as np
from typing import Optional

from FormaSyn.formasyn.checker.simulators.base import QualitySimulator

logger = logging.getLogger(__name__)


class TransformSimulator(QualitySimulator):
    """变换类算法质量仿真器.

    适用于：
    - transform: FFT, DCT, DFT 等变换

    主要指标：
    - sfdr_db: 无杂散动态范围
    - nmse_db: 归一化均方误差
    """

    kernel_type = "transform"

    def evaluate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行变换质量仿真."""
        try:
            clean_code = self._strip_hls_specifics(hls_cpp_code)
            function_name = self._extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, function_name)

            outputs = self._run_so_simple(
                so_path,
                function_name,
                test_inputs,
                golden_outputs,
                csr_data,
            )
        except Exception as e:
            logger.warning("变换仿真编译/运行失败: %s", str(e)[:200])
            return {"nmse_db": 0.0}

        nmse_db = self._compute_nmse(golden_outputs, outputs)

        result = {"nmse_db": nmse_db}

        # 尝试计算 SFDR
        sfdr_db = self._compute_sfdr(golden_outputs, outputs)
        if sfdr_db is not None:
            result["sfdr_db"] = sfdr_db

        return result

    @staticmethod
    def _extract_function_name(code: str) -> str:
        """从 C++ 代码中提取函数名."""
        import re

        match = re.search(r"\bvoid\s+([A-Za-z_]\w*)\s*\(", code)
        if match:
            return match.group(1)
        return "kernel"

    @staticmethod
    def _run_so_simple(
        so_path: str,
        function_name: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, list[float]]:
        """简化版 .so 调用."""
        import ctypes

        lib = ctypes.CDLL(so_path)

        try:
            func = lib[function_name]
        except AttributeError:
            func = lib

        outputs = {}
        for key in golden_outputs:
            out_len = len(golden_outputs[key])
            out_array = (ctypes.c_double * out_len)()
            outputs[key] = list(out_array)

        # 准备参数
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

    def _compute_sfdr(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float | None:
        """计算无杂散动态范围（SFDR）dB.

        SFDR = 10 * log10(基波功率 / 最大杂散功率)

        需要 FFT 分析，如果输出太短则返回 None。
        """
        min_fft_len = 64

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))

            if min_len < min_fft_len:
                continue

            # 对实际输出进行 FFT
            spectrum = np.fft.fft(a[:min_len])
            power_spectrum = np.abs(spectrum) ** 2

            # 找到基波（DC 之后的最大值）
            # 假设 DC 是 index 0，基波在 index 1 或附近
            if len(power_spectrum) < 2:
                continue

            # 跳过 DC，找最大峰值作为基波
            fund_idx = int(np.argmax(power_spectrum[1:len(power_spectrum) // 2])) + 1
            fund_power = power_spectrum[fund_idx]

            # 找最大杂散（排除 DC 和基波附近）
            spurious_power = 0.0
            for i, p in enumerate(power_spectrum):
                if i == 0 or abs(i - fund_idx) < 3:
                    continue
                if i > len(power_spectrum) // 2:
                    continue
                if p > spurious_power:
                    spurious_power = p

            if fund_power > 1e-30 and spurious_power > 1e-30:
                sfdr = 10 * np.log10(fund_power / spurious_power)
                return float(sfdr)

        return None
