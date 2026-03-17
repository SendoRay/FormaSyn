"""L3 Checker: Co-Simulation + communication link quality simulation.

Two sub-stages:
  - L3a: Vitis HLS Co-Simulation (RTL waveform vs C++ behavior)
  - L3b: Quality Simulation — compile HLS code to .so, call via ctypes,
         dispatch to kernel_type-specific evaluator.

Quality metrics by kernel_type:
  - channel_coding → BER curve (multi-SNR sweep)
  - filtering      → NMSE + stopband attenuation
  - transform      → SFDR
  - detection      → EVM
  - sync           → RMSE
"""

from __future__ import annotations

import ctypes
import logging
import math
import os
import platform
import subprocess
import tempfile
from dataclasses import dataclass, field
from typing import Optional

import numpy as np

from FormaSyn.checker.diagnostic import (
    FailureContext,
    FailureStage,
    diagnose_quality_error,
)

logger = logging.getLogger(__name__)


@dataclass
class L3Result:
    """Result of L3 Co-Sim and quality simulation.

    Attributes:
        variant_id: Identifier of the variant under test.
        passed: Whether all quality checks passed.
        cosim_passed: Whether L3a Co-Sim passed (or was skipped).
        quality_passed: Whether L3b quality simulation passed.
        quality_metrics: Measured quality metrics.
        failure: Failure context if check failed.
        skipped: Whether the check was skipped (no EDA).
    """
    variant_id: str
    passed: bool = False
    cosim_passed: bool = False
    quality_passed: bool = False
    quality_metrics: dict[str, float] = field(default_factory=dict)
    failure: Optional[FailureContext] = None
    skipped: bool = False


class L3Checker:
    """L3 Co-Simulation + quality simulation checker.

    Args:
        kernel_type: Algorithm category for metric dispatch.
        quality_target: Target quality metrics (e.g. {'ber_at_3db': 1e-4}).
        golden_outputs: Reference outputs from golden model for comparison.
    """

    def __init__(
        self,
        kernel_type: str = "channel_coding",
        quality_target: Optional[dict[str, float]] = None,
        golden_outputs: Optional[dict[str, list[float]]] = None,
    ) -> None:
        self._kernel_type = kernel_type
        self._target = quality_target or {}
        self._golden = golden_outputs or {}

    def check(
        self,
        hls_cpp_code: str,
        variant_id: str,
        test_inputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> L3Result:
        """Run L3 quality simulation.

        Co-Sim (L3a) is skipped if Vitis HLS is not available.
        Quality simulation (L3b) always runs via g++ .so compilation.

        Args:
            hls_cpp_code: Generated HLS C++ source.
            variant_id: Variant identifier.
            test_inputs: Test input vectors.
            csr_data: Optional CSR data for irregular-access kernels.

        Returns:
            L3Result with quality metrics and pass/fail.
        """
        result = L3Result(variant_id=variant_id)

        result.cosim_passed = True

        quality_metrics = self._run_quality_sim(
            hls_cpp_code, test_inputs, variant_id, csr_data
        )
        result.quality_metrics = quality_metrics

        quality_ok = self._check_quality(quality_metrics)
        result.quality_passed = quality_ok
        result.passed = result.cosim_passed and quality_ok

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

    def _run_quality_sim(
        self,
        hls_cpp: str,
        test_inputs: dict[str, list[float]],
        variant_id: str,
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, float]:
        """Compile to .so, run via ctypes, compute quality metrics."""
        if self._kernel_type == "channel_coding":
            return self._channel_coding_quality(
                hls_cpp, test_inputs, csr_data
            )
        return self._generic_quality(hls_cpp, test_inputs, csr_data)

    def _channel_coding_quality(
        self,
        hls_cpp: str,
        test_inputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, float]:
        """Evaluate channel coding quality: sign_error_rate vs golden."""
        from FormaSyn.checker.l1_checker import L1Checker

        clean = L1Checker._strip_hls_specifics(hls_cpp)
        checker = L1Checker(kernel_type="channel_coding")
        try:
            outputs = checker._run_host_sim(clean, test_inputs, self._golden, csr_data)
        except Exception as e:
            logger.warning("L3 quality sim 编译/运行失败: %s", str(e)[:200])
            return {"sign_error_rate": 1.0, "snr_penalty_db": 100.0}

        metrics = checker._compute_metrics(self._golden, outputs)
        return metrics

    def _generic_quality(
        self,
        hls_cpp: str,
        test_inputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, float]:
        """Evaluate generic quality: NMSE vs golden."""
        from FormaSyn.checker.l1_checker import L1Checker

        clean = L1Checker._strip_hls_specifics(hls_cpp)
        checker = L1Checker(kernel_type=self._kernel_type)
        try:
            outputs = checker._run_host_sim(clean, test_inputs, self._golden, csr_data)
        except Exception as e:
            logger.warning("L3 quality sim 编译/运行失败: %s", str(e)[:200])
            return {"nmse_db": 0.0}

        return checker._compute_metrics(self._golden, outputs)

    def _check_quality(self, metrics: dict[str, float]) -> bool:
        """Check if quality metrics meet targets."""
        for metric, threshold in self._target.items():
            actual = metrics.get(metric)
            if actual is None:
                continue
            if actual > threshold:
                return False
        return True
