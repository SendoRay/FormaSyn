"""Quantisation Analyzer: run the golden model to recommend fixed-point widths.

Adds random perturbations to test inputs, runs the golden model many times,
and computes per-node statistics (max absolute value) to recommend integer
and fractional bit-widths for fixed-point quantisation.
"""

from __future__ import annotations

import copy
import logging
import math
from dataclasses import dataclass
from typing import Optional

import numpy as np

from .generator import GoldenModelGenerator
from ..ir.math_dialect import MathDialect

logger = logging.getLogger(__name__)


@dataclass
class QuantSpec:
    """Per-node fixed-point quantisation recommendation.

    Attributes:
        node_id: MathNode identifier.
        recommended_int_bits: Suggested integer-part bit-width (including sign).
        recommended_frac_bits: Suggested fractional-part bit-width.
        min_int_bits: Minimum integer bits (recommended - 1).
        max_int_bits: Maximum integer bits (recommended + 2).
        max_abs_observed: Largest absolute value seen across all trials.
        min_bits: Minimum total bit-width that avoids severe BER degradation.
        max_bits: Maximum useful bit-width.
    """

    node_id: str
    recommended_int_bits: int
    recommended_frac_bits: int
    min_int_bits: int
    max_int_bits: int
    max_abs_observed: float

    @property
    def min_bits(self) -> int:
        """Minimum total bit-width."""
        return max(self.min_int_bits + self.recommended_frac_bits, 4)

    @property
    def max_bits(self) -> int:
        """Maximum total bit-width."""
        return self.max_int_bits + self.recommended_frac_bits

    def to_dse_format(self) -> dict:
        """Return a dict compatible with ``dse_agent.QuantSpec`` constructor kwargs."""
        return {
            "node_id": self.node_id,
            "recommended_int_bits": self.recommended_int_bits,
            "recommended_frac_bits": self.recommended_frac_bits,
            "min_bits": self.min_bits,
            "max_bits": self.max_bits,
        }


class QuantizationAnalyzer:
    """Runs the golden model with perturbed inputs to recommend bit-widths."""

    def __init__(self, target_total_bits: int = 16) -> None:
        self._target_total_bits = target_total_bits

    def analyze(
        self,
        generator: GoldenModelGenerator,
        dialect: MathDialect,
        test_inputs: dict[str, list[float]],
        n_trials: int = 100,
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, QuantSpec]:
        """Run the golden model *n_trials* times and recommend bit-widths.

        Args:
            generator: A ``GoldenModelGenerator`` instance.
            dialect: MathDialect describing the kernel.
            test_inputs: Baseline input data per input node.
            n_trials: Number of perturbed runs.
            csr_data: CSR data for kernels with irregular access.

        Returns:
            Mapping of output node_id to ``QuantSpec``.
        """
        cpp_code = generator.generate(dialect)

        all_outputs: dict[str, list[float]] = {}
        rng = np.random.default_rng(seed=42)

        for trial in range(n_trials):
            perturbed = self._perturb_inputs(test_inputs, rng)
            result = generator.compile_and_run(
                cpp_code, perturbed, dialect, csr_data=csr_data,
            )
            for key, values in result.items():
                all_outputs.setdefault(key, []).extend(values)

        specs: dict[str, QuantSpec] = {}
        for node_id, values in all_outputs.items():
            arr = np.array(values, dtype=np.float64)

            arr_finite = arr[np.isfinite(arr)]
            if len(arr_finite) == 0:
                max_abs = 1.0
            else:
                max_abs = float(np.max(np.abs(arr_finite)))

            max_abs = max(max_abs, 1e-10)

            int_bits = math.ceil(math.log2(max_abs + 1)) + 1
            int_bits = max(int_bits, 1)
            frac_bits = self._target_total_bits - int_bits
            frac_bits = max(frac_bits, 0)

            specs[node_id] = QuantSpec(
                node_id=node_id,
                recommended_int_bits=int_bits,
                recommended_frac_bits=frac_bits,
                min_int_bits=int_bits - 1,
                max_int_bits=int_bits + 2,
                max_abs_observed=max_abs,
            )

        logger.info(
            "Quantisation analysis complete for '%s': %d output nodes analysed "
            "over %d trials",
            dialect.kernel_name,
            len(specs),
            n_trials,
        )
        return specs

    @staticmethod
    def _perturb_inputs(
        inputs: dict[str, list[float]],
        rng: np.random.Generator,
    ) -> dict[str, list[float]]:
        """Add Gaussian noise (sigma = 0.1 * std) to each input array."""
        perturbed: dict[str, list[float]] = {}
        for name, values in inputs.items():
            arr = np.array(values, dtype=np.float64)
            std = float(np.std(arr))
            sigma = 0.1 * std if std > 0 else 0.01
            noise = rng.normal(0.0, sigma, size=arr.shape)
            perturbed[name] = (arr + noise).tolist()
        return perturbed
