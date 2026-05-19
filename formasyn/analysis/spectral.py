"""Spectral degradation diagnosis for Direction B: Co-Sim feedback-driven IR repair.

When L3 detects quality degradation, this module analyzes the spectral
characteristics to identify which IR node is responsible and propose
a targeted fix.
"""

from __future__ import annotations

import logging
import math
from dataclasses import dataclass, field
from typing import Optional

import numpy as np

from ..ir.math_dialect import MathDialect, MathNode

logger = logging.getLogger(__name__)


class DegradationPattern:
    """Known degradation patterns and their probable root causes."""

    BER_FLOOR = "ber_floor"
    NARROWBAND_SPUR = "narrowband_spur"
    PASSBAND_DROOP = "passband_droop"
    PHASE_NOISE_PEDESTAL = "phase_noise_pedestal"
    CONSTELLATION_SPREAD = "constellation_spread"
    WIDEBAND_NOISE_RISE = "wideband_noise_rise"


@dataclass
class SpectralDiagnostic:
    """Diagnostic result from spectral analysis.

    Attributes:
        pattern: Identified degradation pattern.
        severity_db: How severe the degradation is (in dB).
        suspect_nodes: Ranked list of IR nodes likely causing the issue.
        recommended_fix: Suggested repair action.
        spectral_data: Raw spectral data for visualization.
    """

    pattern: str
    severity_db: float
    suspect_nodes: list[str]
    recommended_fix: dict[str, any] = field(default_factory=dict)
    spectral_data: Optional[np.ndarray] = None


@dataclass
class RepairAction:
    """A targeted IR repair action.

    Attributes:
        target_node: IR node to modify.
        action_type: Type of fix ('increase_bits', 'enable_saturation', etc.).
        params: Fix parameters.
        expected_improvement_db: Expected quality improvement.
    """

    target_node: str
    action_type: str
    params: dict[str, any] = field(default_factory=dict)
    expected_improvement_db: float = 0.0


# ---------------------------------------------------------------------------
# Spectral analysis functions
# ---------------------------------------------------------------------------

def compute_power_spectrum(signal: np.ndarray) -> np.ndarray:
    """Compute power spectral density using Welch's method approximation."""
    n = len(signal)
    if n < 16:
        return np.abs(np.fft.fft(signal, n=16)) ** 2

    # Use Hanning window + FFT
    window = np.hanning(n)
    windowed = signal * window
    spectrum = np.abs(np.fft.fft(windowed)) ** 2
    # Normalize
    spectrum = spectrum / (np.sum(window ** 2))
    return spectrum[:n // 2]


def compute_error_spectrum(
    golden: np.ndarray, actual: np.ndarray
) -> np.ndarray:
    """Compute spectrum of the error signal (golden - actual)."""
    error = golden - actual
    return compute_power_spectrum(error)


def detect_degradation_pattern(
    golden: np.ndarray,
    actual: np.ndarray,
    kernel_type: str,
) -> SpectralDiagnostic:
    """Analyze golden vs actual to identify the degradation pattern.

    Args:
        golden: Reference signal (float64).
        actual: Approximated signal from HLS.
        kernel_type: Algorithm category for context-aware diagnosis.

    Returns:
        SpectralDiagnostic with pattern identification and severity.
    """
    error = golden - actual
    error_power = np.mean(error ** 2)
    signal_power = np.mean(golden ** 2)

    if signal_power == 0:
        return SpectralDiagnostic(
            pattern=DegradationPattern.WIDEBAND_NOISE_RISE,
            severity_db=0.0,
            suspect_nodes=[],
        )

    nmse_db = 10 * math.log10(error_power / signal_power)

    # Compute error spectrum
    error_spec = compute_error_spectrum(golden, actual)
    n_bins = len(error_spec)

    if n_bins < 4:
        return SpectralDiagnostic(
            pattern=DegradationPattern.WIDEBAND_NOISE_RISE,
            severity_db=nmse_db,
            suspect_nodes=[],
            spectral_data=error_spec,
        )

    # Analyze spectral shape
    total_error_power = np.sum(error_spec)
    if total_error_power == 0:
        return SpectralDiagnostic(
            pattern=DegradationPattern.WIDEBAND_NOISE_RISE,
            severity_db=0.0,
            suspect_nodes=[],
        )

    # Check for narrowband spurs (energy concentrated in < 10% of bins)
    sorted_spec = np.sort(error_spec)[::-1]
    top_10_pct = int(max(1, n_bins * 0.1))
    spur_ratio = np.sum(sorted_spec[:top_10_pct]) / total_error_power

    if spur_ratio > 0.8:
        return SpectralDiagnostic(
            pattern=DegradationPattern.NARROWBAND_SPUR,
            severity_db=nmse_db,
            suspect_nodes=[],
            spectral_data=error_spec,
        )

    # Check for passband droop (high-frequency error dominance)
    low_half = np.sum(error_spec[: n_bins // 2])
    high_half = np.sum(error_spec[n_bins // 2:])
    if high_half > 3 * low_half:
        return SpectralDiagnostic(
            pattern=DegradationPattern.PASSBAND_DROOP,
            severity_db=nmse_db,
            suspect_nodes=[],
            spectral_data=error_spec,
        )

    # Check for BER floor (for channel coding)
    if kernel_type == "channel_coding":
        # BER floor manifests as consistent non-zero error regardless of SNR
        error_variance = np.var(np.abs(error))
        if error_variance < 0.1 * error_power:
            return SpectralDiagnostic(
                pattern=DegradationPattern.BER_FLOOR,
                severity_db=nmse_db,
                suspect_nodes=[],
                spectral_data=error_spec,
            )

    # Default: wideband noise rise (quantization noise)
    return SpectralDiagnostic(
        pattern=DegradationPattern.WIDEBAND_NOISE_RISE,
        severity_db=nmse_db,
        suspect_nodes=[],
        spectral_data=error_spec,
    )


# ---------------------------------------------------------------------------
# Root cause identification
# ---------------------------------------------------------------------------

# Mapping: degradation pattern → likely node characteristics
_PATTERN_TO_NODE_TRAITS: dict[str, dict[str, any]] = {
    DegradationPattern.BER_FLOOR: {
        "trait": "smallest_bitwidth",
        "description": "Quantization overflow causing error floor",
    },
    DegradationPattern.NARROWBAND_SPUR: {
        "trait": "multiply_with_const",
        "description": "Twiddle factor or coefficient truncation",
    },
    DegradationPattern.PASSBAND_DROOP: {
        "trait": "multiply_coefficients",
        "description": "FIR/IIR coefficient quantization in high-frequency taps",
    },
    DegradationPattern.PHASE_NOISE_PEDESTAL: {
        "trait": "feedback_path",
        "description": "Loop filter truncation in feedback path",
    },
    DegradationPattern.CONSTELLATION_SPREAD: {
        "trait": "soft_decision",
        "description": "Decision threshold rounding",
    },
    DegradationPattern.WIDEBAND_NOISE_RISE: {
        "trait": "smallest_bitwidth",
        "description": "General quantization noise (uniform degradation)",
    },
}


def identify_suspect_nodes(
    diagnostic: SpectralDiagnostic,
    dialect: MathDialect,
) -> list[str]:
    """Rank IR nodes by likelihood of causing the observed degradation.

    Args:
        diagnostic: Spectral analysis result with pattern identification.
        dialect: MathDialect IR to search for suspect nodes.

    Returns:
        Ordered list of node_ids (most suspect first).
    """
    traits = _PATTERN_TO_NODE_TRAITS.get(diagnostic.pattern, {})
    trait = traits.get("trait", "smallest_bitwidth")

    suspects: list[tuple[str, float]] = []

    for node_id, node in dialect.nodes.items():
        if node.op_type == "input":
            continue

        score = _score_node_for_trait(node, trait)
        if score > 0:
            suspects.append((node_id, score))

    # Sort by score (highest = most likely culprit)
    suspects.sort(key=lambda x: x[1], reverse=True)
    return [node_id for node_id, _ in suspects]


def _score_node_for_trait(node: MathNode, trait: str) -> float:
    """Score a node's likelihood of matching a degradation trait."""
    if trait == "smallest_bitwidth":
        # Nodes with fewer bits are more likely to cause quantization issues
        # Use shape as proxy (smaller shape = more reduction = less precision)
        shape_size = node.shape[0] if node.shape else 1
        return 1.0 / max(shape_size, 1)

    elif trait == "multiply_with_const":
        if node.op_type == "map" and node.op_detail.get("func") == "multiply":
            return 2.0
        return 0.0

    elif trait == "multiply_coefficients":
        if node.op_type == "map" and node.op_detail.get("func") == "multiply":
            return 1.5
        if node.op_type == "shift_reg":
            return 1.0
        return 0.0

    elif trait == "feedback_path":
        if node.has_feedback:
            return 3.0
        if node.op_type == "cycle":
            return 3.0
        return 0.0

    elif trait == "soft_decision":
        func = node.op_detail.get("func", "")
        if func in ("soft_demapper", "quantize", "clamp"):
            return 2.0
        return 0.0

    return 0.0


def propose_repair(
    diagnostic: SpectralDiagnostic,
    suspect_nodes: list[str],
    dialect: MathDialect,
) -> list[RepairAction]:
    """Propose minimal targeted fixes for the identified degradation.

    Args:
        diagnostic: The spectral diagnosis.
        suspect_nodes: Ranked suspect node list.
        dialect: MathDialect for context.

    Returns:
        List of RepairAction (apply in order until quality passes).
    """
    repairs: list[RepairAction] = []
    pattern = diagnostic.pattern

    for node_id in suspect_nodes[:3]:  # Try top 3 suspects
        node = dialect.nodes.get(node_id)
        if node is None:
            continue

        if pattern == DegradationPattern.BER_FLOOR:
            repairs.append(RepairAction(
                target_node=node_id,
                action_type="increase_frac_bits",
                params={"delta": 2},
                expected_improvement_db=6.0,
            ))

        elif pattern == DegradationPattern.NARROWBAND_SPUR:
            repairs.append(RepairAction(
                target_node=node_id,
                action_type="increase_frac_bits",
                params={"delta": 3},
                expected_improvement_db=9.0,
            ))

        elif pattern == DegradationPattern.PASSBAND_DROOP:
            repairs.append(RepairAction(
                target_node=node_id,
                action_type="increase_coeff_bits",
                params={"delta": 2},
                expected_improvement_db=6.0,
            ))

        elif pattern == DegradationPattern.PHASE_NOISE_PEDESTAL:
            repairs.append(RepairAction(
                target_node=node_id,
                action_type="increase_frac_bits",
                params={"delta": 2},
                expected_improvement_db=4.0,
            ))

        elif pattern == DegradationPattern.CONSTELLATION_SPREAD:
            repairs.append(RepairAction(
                target_node=node_id,
                action_type="enable_saturation",
                params={},
                expected_improvement_db=3.0,
            ))

        else:
            # Wideband noise: just add bits to the most suspect node
            repairs.append(RepairAction(
                target_node=node_id,
                action_type="increase_frac_bits",
                params={"delta": 2},
                expected_improvement_db=6.0,
            ))

    return repairs
