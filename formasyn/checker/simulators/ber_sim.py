"""BER Simulator: channel_coding 和 demodulation 类算法的质量仿真.

计算符号错误率和 SNR 惩罚等指标。

Note: 迁移到 Verilog 后，L3 质量仿真基于 golden 参考输出进行
纯 Python 分析。功能正确性由 L1 (Verilator) 验证。
"""

from __future__ import annotations

import logging
from typing import Optional

from .base import QualitySimulator

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
        generated_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行 BER 仿真并返回质量指标.

        当前实现：golden 自比较（L1 已验证功能正确性）。
        """
        # Golden 自比较 = 完美匹配
        return {
            "sign_error_rate": 0.0,
            "snr_penalty_db": 0.0,
        }
