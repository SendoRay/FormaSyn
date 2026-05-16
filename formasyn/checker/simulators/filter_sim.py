"""Filter Simulator: filtering 类算法的质量仿真.

计算 NMSE、阻带衰减等滤波器指标。
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np

from .base import QualitySimulator
from ...utils.cpp_utils import extract_function_name
from ...utils.hls_mock import strip_hls_pragmas

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
        hls_header_code: str | None = None,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行滤波器质量仿真."""
        try:
            clean_code = strip_hls_pragmas(hls_cpp_code)
            func_name = extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, func_name, hls_header_code)

            outputs = self._run_so_simple(
                so_path, func_name, test_inputs, golden_outputs, csr_data,
            )
        except Exception as e:
            logger.warning("滤波器仿真编译/运行失败: %s", str(e)[:200])
            return {"nmse_db": 0.0}

        nmse_db = self._compute_nmse(golden_outputs, outputs)
        result = {"nmse_db": nmse_db}

        stopband_atten = self._compute_stopband_attenuation(golden_outputs, outputs)
        if stopband_atten is not None:
            result["stopband_atten_db"] = stopband_atten

        return result

    @staticmethod
    def _compute_stopband_attenuation(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float | None:
        """计算阻带衰减（dB）."""
        min_fft_len = 256

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))

            if min_len < min_fft_len:
                continue

            stopband_start = min_len // 2
            g_stop = g[stopband_start:]
            a_stop = a[stopband_start:]

            if len(g_stop) == 0:
                continue

            power_golden = float(np.mean(g_stop ** 2))
            power_actual = float(np.mean(a_stop ** 2))

            if power_golden > 1e-30:
                return float(10 * np.log10(power_actual / power_golden))

        return None
