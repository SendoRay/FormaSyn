"""Filter Simulator: filtering 类算法的质量仿真.

计算 NMSE、阻带衰减等滤波器指标。
"""

from __future__ import annotations

import logging
import numpy as np
from typing import Optional

from FormaSyn.formasyn.checker.simulators.base import QualitySimulator

logger = logging.getLogger(__name__)


class FilterSimulator(QualitySimulator):
    """滤波器质量仿真器.

    适用于：
    - filtering: FIR, IIR, CIC, halfband, RRC 等滤波器

    主要指标：
    - nmse_db: 归一化均方误差
    - stopband_atten_db: 阻带衰减（需要频谱分析）
    """

    kernel_type = "filtering"

    def evaluate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行滤波器质量仿真."""
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
            logger.warning("滤波器仿真编译/运行失败: %s", str(e)[:200])
            return {"nmse_db": 0.0}

        nmse_db = self._compute_nmse(golden_outputs, outputs)

        result = {"nmse_db": nmse_db}

        # 尝试计算阻带衰减（需要足够长的输出）
        stopband_atten = self._compute_stopband_attenuation(
            golden_outputs, outputs
        )
        if stopband_atten is not None:
            result["stopband_atten_db"] = stopband_atten

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
        """简化版 .so 调用（假设简单输入输出结构）."""
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

    def _compute_stopband_attenuation(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float | None:
        """计算阻带衰减（dB）.

        需要输出足够长才能进行 FFT 分析。
        """
        min_fft_len = 256

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))

            if min_len < min_fft_len:
                continue

            # 取后半部分作为阻带（假设低通滤波器）
            stopband_start = min_len // 2
            g_stop = g[stopband_start:]
            a_stop = a[stopband_start:]

            if len(g_stop) == 0:
                continue

            power_golden = float(np.mean(g_stop ** 2))
            power_actual = float(np.mean(a_stop ** 2))

            if power_golden > 1e-30:
                atten = 10 * np.log10(power_actual / power_golden)
                return float(atten)

        return None
