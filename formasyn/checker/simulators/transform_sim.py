"""Transform Simulator: transform 类算法的质量仿真.

计算 SFDR（无杂散动态范围）和 NMSE 等指标。
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np

from FormaSyn.formasyn.checker.simulators.base import QualitySimulator
from FormaSyn.formasyn.utils.cpp_utils import extract_function_name
from FormaSyn.formasyn.utils.hls_mock import strip_hls_pragmas

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
        hls_header_code: str | None = None,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行变换质量仿真."""
        try:
            clean_code = strip_hls_pragmas(hls_cpp_code)
            func_name = extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, func_name, hls_header_code)

            outputs = self._run_so_simple(
                so_path, func_name, test_inputs, golden_outputs, csr_data,
            )
        except Exception as e:
            import traceback
            logger.warning("变换仿真编译/运行失败: %s", str(e)[:200])
            logger.debug("详细错误: %s", traceback.format_exc()[-500:])
            return {"nmse_db": 100.0}

        nmse_db = self._compute_nmse(golden_outputs, outputs)
        result = {"nmse_db": nmse_db}

        sfdr_db = self._compute_sfdr(golden_outputs, outputs)
        if sfdr_db is not None:
            result["sfdr_db"] = sfdr_db

        return result

    @staticmethod
    def _compute_sfdr(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float | None:
        """计算无杂散动态范围（SFDR）dB."""
        min_fft_len = 64

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))

            if min_len < min_fft_len:
                continue

            spectrum = np.fft.fft(a[:min_len])
            power_spectrum = np.abs(spectrum) ** 2

            if len(power_spectrum) < 2:
                continue

            fund_idx = int(np.argmax(power_spectrum[1:len(power_spectrum) // 2])) + 1
            fund_power = power_spectrum[fund_idx]

            spurious_power = 0.0
            for i, p in enumerate(power_spectrum):
                if i == 0 or abs(i - fund_idx) < 3:
                    continue
                if i > len(power_spectrum) // 2:
                    continue
                if p > spurious_power:
                    spurious_power = p

            if fund_power > 1e-30 and spurious_power > 1e-30:
                return float(10 * np.log10(fund_power / spurious_power))

        return None
