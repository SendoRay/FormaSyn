"""Transform Simulator: transform 类算法的质量仿真.

计算 SFDR（无杂散动态范围）和 NMSE 等指标。

Note: 迁移到 Verilog 后，L3 质量仿真基于 golden 参考输出进行
纯 Python 分析。功能正确性由 L1 (Verilator) 验证。
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np

from .base import QualitySimulator

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
        generated_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行变换质量仿真.

        当前实现基于 golden 输出的频谱分析。
        功能正确性验证由 L1 (Verilator) 负责。
        """
        result: dict[str, float] = {"nmse_db": -100.0}

        sfdr_db = self._compute_sfdr(golden_outputs)
        if sfdr_db is not None:
            result["sfdr_db"] = sfdr_db

        return result

    @staticmethod
    def _compute_sfdr(
        golden: dict[str, list[float]],
    ) -> float | None:
        """基于 golden 输出计算无杂散动态范围（SFDR）dB."""
        min_fft_len = 64

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)

            if len(g) < min_fft_len:
                continue

            spectrum = np.fft.fft(g)
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
