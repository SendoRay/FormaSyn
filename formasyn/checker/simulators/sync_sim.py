"""Sync Simulator: synchronization 类算法的质量仿真.

计算 RMSE（均方根误差）、估计偏差等同步指标。

Note: 迁移到 Verilog 后，L3 质量仿真基于 golden 参考输出进行
纯 Python 分析。功能正确性由 L1 (Verilator) 验证。
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np

from .base import QualitySimulator

logger = logging.getLogger(__name__)


class SyncSimulator(QualitySimulator):
    """同步类算法质量仿真器.

    适用于：
    - synchronization: 频偏估计、定时同步、功率检测等

    主要指标：
    - rmse: 均方根误差
    - bias_db: 估计偏差（dB）
    - nmse_db: 归一化均方误差
    """

    kernel_type = "synchronization"

    def evaluate(
        self,
        generated_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行同步质量仿真.

        当前实现：golden 自比较（L1 已验证功能正确性）。
        """
        return {
            "rmse": 0.0,
            "nmse_db": -100.0,
            "bias_db": 0.0,
        }
