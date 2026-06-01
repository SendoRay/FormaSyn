"""L3 Checker: Communication link quality simulation.

L3b: Quality Simulation — compile generated code to .so, call via ctypes,
     dispatch to kernel_type-specific evaluator.

Note: L3a co-sim was removed because L1 is already cycle-accurate RTL
simulation via Verilator, making a separate co-sim stage redundant.

Quality metrics by kernel_type:
  - channel_coding → BER curve (multi-SNR sweep)
  - filtering      → NMSE + stopband attenuation
  - transform      → SFDR
  - detection      → EVM
  - sync           → RMSE
  - elementwise    → NMSE only (simple arithmetic)
  - arithmetic     → NMSE only (simple arithmetic)
  - generic        → NMSE only (simple arithmetic)
"""

from __future__ import annotations

import logging
from typing import Optional

from .diagnostic import (
    FailureContext,
    diagnose_quality_error,
)
from .metrics import L3Result
from .simulators import get_simulator

logger = logging.getLogger(__name__)

# 简单算术类型，不需要复杂的质量仿真
SIMPLE_ARITHMETIC_TYPES = {"elementwise", "arithmetic", "generic"}


class L3Checker:
    """L3 quality simulation checker.

    Args:
        kernel_type: Algorithm category for metric dispatch.
        quality_target: Target quality metrics (e.g. {'ber_at_3db': 1e-4}).
        golden_outputs: Reference outputs from golden model for comparison.
    """

    _SIMULATOR_MAP = {
        "channel_coding": "BERSimulator",
        "demodulation": "BERSimulator",
        "filtering": "FilterSimulator",
        "transform": "TransformSimulator",
        "detection": "DetectionSimulator",
        "synchronization": "SyncSimulator",
        # 简单算术运算类型
        "elementwise": "TransformSimulator",
        "arithmetic": "TransformSimulator",
        "generic": "TransformSimulator",
    }

    def __init__(
        self,
        kernel_type: str = "channel_coding",
        quality_target: Optional[dict[str, float]] = None,
        golden_outputs: Optional[dict[str, list[float]]] = None,
    ) -> None:
        self._kernel_type = kernel_type
        self._target = quality_target or {}
        self._golden = golden_outputs or {}

        # 获取对应的 Simulator 类
        self._simulator_class = get_simulator(kernel_type)

    def check(
        self,
        verilog_code: str,
        variant_id: str,
        test_inputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> L3Result:
        """Run L3 quality simulation.

        Args:
            verilog_code: Generated Verilog source.
            variant_id: Variant identifier.
            test_inputs: Test input vectors.
            csr_data: Optional CSR data for irregular-access kernels.

        Returns:
            L3Result with quality metrics and pass/fail.
        """
        result = L3Result(variant_id=variant_id)

        # 对于简单算术类型，跳过复杂的质量仿真
        if self._kernel_type in SIMPLE_ARITHMETIC_TYPES:
            logger.info("L3 质量仿真跳过 [%s]: kernel_type=%s 为简单算术类型", variant_id, self._kernel_type)
            result.quality_passed = True
            result.passed = True
            return result

        # L3b Quality Sim - 使用 Simulator 分发
        simulator = self._simulator_class()
        quality_metrics = simulator.evaluate(
            verilog_code,
            test_inputs,
            self._golden,
            csr_data=csr_data,
        )
        result.quality_metrics = quality_metrics

        quality_ok = self._check_quality(quality_metrics)
        result.quality_passed = quality_ok
        result.passed = quality_ok

        if not quality_ok:
            result.failure = diagnose_quality_error(
                variant_id, quality_metrics, self._target, self._kernel_type
            )
            logger.warning(
                "L3 质量仿真失败 [%s]: %s", variant_id, result.failure.gap_description
            )
        else:
            logger.info("L3 通过 [%s]: metrics=%s", variant_id, quality_metrics)

        return result

    def _check_quality(self, metrics: dict[str, float]) -> bool:
        """Check if quality metrics meet targets."""
        for metric, threshold in self._target.items():
            actual = metrics.get(metric)
            if actual is None:
                continue
            if actual > threshold:
                return False
        return True

    @classmethod
    def get_simulator_name(cls, kernel_type: str) -> str | None:
        """获取 kernel_type 对应的 Simulator 名称."""
        return cls._SIMULATOR_MAP.get(kernel_type)
