"""BER Simulator: channel_coding 和 demodulation 类算法的质量仿真.

计算符号错误率和 SNR 惩罚等指标。
"""

from __future__ import annotations

import logging
from typing import Optional

from .base import QualitySimulator
from ...utils.cpp_utils import extract_function_name
from ...utils.hls_mock import strip_hls_pragmas

logger = logging.getLogger(__name__)


class BERSimulator(QualitySimulator):
    """BER/符号错误率仿真器.

    适用于：
    - channel_coding: LDPC, Turbo, 卷积码等
    - demodulation: QAM/PSK 软解调等

    主要指标：
    - sign_error_rate: 符号错误率
    - snr_penalty_db: 相对于 golden 的 SNR 损失
    """

    kernel_type = "channel_coding"

    def evaluate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        hls_header_code: str | None = None,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行 BER 仿真并返回质量指标."""
        try:
            clean_code = strip_hls_pragmas(hls_cpp_code)
            func_name = extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, func_name, hls_header_code)

            outputs = self._run_so_simple(
                so_path, func_name, test_inputs, golden_outputs, csr_data,
            )
        except Exception as e:
            logger.warning("BER 仿真编译/运行失败: %s", str(e)[:200])
            return {"sign_error_rate": 1.0, "snr_penalty_db": 100.0}

        sign_error_rate, snr_penalty_db, _ = self._compute_sign_error_rate(
            golden_outputs, outputs
        )

        return {
            "sign_error_rate": sign_error_rate,
            "snr_penalty_db": snr_penalty_db,
        }
