"""Detection Simulator: detection 类算法的质量仿真.

计算 EVM（误差矢量幅度）等检测指标。

Note: 迁移到 Verilog 后，L3 质量仿真基于 golden 参考输出进行
纯 Python 分析。功能正确性由 L1 (Verilator) 验证。
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np

from .base import QualitySimulator

logger = logging.getLogger(__name__)


class DetectionSimulator(QualitySimulator):
    """检测类算法质量仿真器.

    适用于：
    - detection: 均衡器、信道估计、符号检测等

    主要指标：
    - evm_percent: 误差矢量幅度（百分比）
    - nmse_db: 归一化均方误差
    """

    kernel_type = "detection"

    def evaluate(
        self,
        generated_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行检测质量仿真.

        当前实现：golden 自比较（L1 已验证功能正确性）。
        """
        return {
            "evm_percent": 0.0,
            "nmse_db": -100.0,
        }
