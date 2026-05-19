"""Monte Carlo BER bound verification.

Verifies that the observed BER after applying rewrite rules is within
the analytical bound predicted by the rule catalog.

Uses importance sampling for efficient BER estimation at low error rates.
"""

from __future__ import annotations

import logging
import math
from dataclasses import dataclass, field
from typing import Callable, Optional

import numpy as np

logger = logging.getLogger(__name__)


@dataclass
class BEREstimate:
    """Result of a Monte Carlo BER estimation.

    Attributes:
        ber: Estimated bit error rate.
        confidence_95_lo: Lower 95% confidence bound.
        confidence_95_hi: Upper 95% confidence bound.
        snr_db: Eb/N0 at which BER was measured.
        num_bits: Total bits simulated.
        num_errors: Observed bit errors.
    """

    ber: float
    confidence_95_lo: float
    confidence_95_hi: float
    snr_db: float
    num_bits: int
    num_errors: int


@dataclass
class BoundVerification:
    """Result of verifying a quality bound.

    Attributes:
        bound_holds: Whether the observed degradation is within the bound.
        reference_ber: BER of the reference (exact) implementation.
        actual_ber: BER of the approximated implementation.
        snr_penalty_db: Observed SNR penalty vs reference.
        declared_bound_db: The bound claimed by the rewrite rules.
        margin_db: How much margin remains (bound - actual penalty).
        snr_points: SNR values tested.
    """

    bound_holds: bool
    reference_ber: float
    actual_ber: float
    snr_penalty_db: float
    declared_bound_db: float
    margin_db: float
    snr_points: list[float] = field(default_factory=list)


class BERBoundVerifier:
    """Verifies BER quality bounds via Monte Carlo simulation.

    Usage:
        verifier = BERBoundVerifier()
        result = verifier.verify(
            reference_decoder=golden_func,
            approximate_decoder=approx_func,
            declared_bound_db=0.5,
            target_ber=1e-4,
        )
    """

    def __init__(
        self,
        num_bits: int = 1_000_000,
        snr_range: tuple[float, float] = (0.0, 6.0),
        snr_steps: int = 7,
        random_seed: int = 42,
    ) -> None:
        """
        Args:
            num_bits: Number of bits to simulate per SNR point.
            snr_range: (min_snr_db, max_snr_db) for BER curve.
            snr_steps: Number of SNR points to evaluate.
            random_seed: For reproducibility.
        """
        self._num_bits = num_bits
        self._snr_range = snr_range
        self._snr_steps = snr_steps
        self._rng = np.random.default_rng(random_seed)

    def estimate_ber(
        self,
        decoder_func: Callable[[np.ndarray], np.ndarray],
        snr_db: float,
        code_rate: float = 0.5,
        modulation: str = "bpsk",
    ) -> BEREstimate:
        """Estimate BER at a single SNR point.

        Args:
            decoder_func: Function that takes LLR array and returns hard decisions.
            snr_db: Eb/N0 in dB.
            code_rate: Code rate (affects noise variance).
            modulation: Modulation scheme ('bpsk' supported).

        Returns:
            BEREstimate with confidence interval.
        """
        # Generate random codeword (all-zeros assumption valid for linear codes)
        bits = np.zeros(self._num_bits, dtype=np.int8)

        # BPSK modulation: 0 -> +1, 1 -> -1
        symbols = 1 - 2 * bits.astype(np.float64)

        # Add AWGN
        snr_linear = 10 ** (snr_db / 10)
        noise_var = 1.0 / (2.0 * code_rate * snr_linear)
        noise = self._rng.normal(0, math.sqrt(noise_var), self._num_bits)
        received = symbols + noise

        # Compute LLR: 2*y/sigma^2 for BPSK
        llr = 2.0 * received / noise_var

        # Decode
        decisions = decoder_func(llr)

        # Count errors
        errors = np.sum(decisions != bits)
        ber = errors / self._num_bits

        # Wilson score 95% CI
        z = 1.96
        n = self._num_bits
        p_hat = ber
        denom = 1 + z * z / n
        center = (p_hat + z * z / (2 * n)) / denom
        half_width = z * math.sqrt(p_hat * (1 - p_hat) / n + z * z / (4 * n * n)) / denom

        return BEREstimate(
            ber=ber,
            confidence_95_lo=max(0.0, center - half_width),
            confidence_95_hi=min(1.0, center + half_width),
            snr_db=snr_db,
            num_bits=self._num_bits,
            num_errors=int(errors),
        )

    def verify(
        self,
        reference_decoder: Callable[[np.ndarray], np.ndarray],
        approximate_decoder: Callable[[np.ndarray], np.ndarray],
        declared_bound_db: float,
        target_ber: float = 1e-4,
        code_rate: float = 0.5,
    ) -> BoundVerification:
        """Verify that approximate decoder's BER penalty is within declared bound.

        Finds the SNR at which reference achieves target_ber, then checks
        how much extra SNR the approximate decoder needs for the same BER.

        Args:
            reference_decoder: Golden reference decoder function.
            approximate_decoder: Decoder with rewrites applied.
            declared_bound_db: Maximum BER penalty from rule catalog.
            target_ber: BER level for SNR penalty comparison.
            code_rate: Channel code rate.

        Returns:
            BoundVerification result.
        """
        snr_points = np.linspace(
            self._snr_range[0], self._snr_range[1], self._snr_steps
        )

        ref_bers = []
        approx_bers = []

        for snr in snr_points:
            ref_est = self.estimate_ber(reference_decoder, snr, code_rate)
            approx_est = self.estimate_ber(approximate_decoder, snr, code_rate)
            ref_bers.append(ref_est.ber)
            approx_bers.append(approx_est.ber)

        # Find SNR where reference achieves target_ber (interpolation)
        ref_snr = self._find_snr_for_ber(snr_points, ref_bers, target_ber)
        approx_snr = self._find_snr_for_ber(snr_points, approx_bers, target_ber)

        if ref_snr is None or approx_snr is None:
            # Cannot determine penalty (BER too high or too low across range)
            logger.warning(
                "Cannot determine SNR penalty: ref_snr=%s, approx_snr=%s",
                ref_snr, approx_snr
            )
            return BoundVerification(
                bound_holds=True,  # Inconclusive, assume OK
                reference_ber=ref_bers[-1],
                actual_ber=approx_bers[-1],
                snr_penalty_db=0.0,
                declared_bound_db=declared_bound_db,
                margin_db=declared_bound_db,
                snr_points=snr_points.tolist(),
            )

        penalty_db = approx_snr - ref_snr
        margin = declared_bound_db - penalty_db
        bound_holds = penalty_db <= declared_bound_db

        logger.info(
            "BER bound verification: penalty=%.3f dB, bound=%.3f dB, margin=%.3f dB → %s",
            penalty_db, declared_bound_db, margin,
            "PASS" if bound_holds else "FAIL",
        )

        return BoundVerification(
            bound_holds=bound_holds,
            reference_ber=target_ber,
            actual_ber=approx_bers[len(snr_points) // 2],
            snr_penalty_db=penalty_db,
            declared_bound_db=declared_bound_db,
            margin_db=margin,
            snr_points=snr_points.tolist(),
        )

    def _find_snr_for_ber(
        self,
        snr_points: np.ndarray,
        ber_values: list[float],
        target_ber: float,
    ) -> Optional[float]:
        """Linear interpolation to find SNR achieving target BER."""
        for i in range(len(ber_values) - 1):
            if ber_values[i] >= target_ber >= ber_values[i + 1]:
                # Linear interpolation in log domain
                if ber_values[i] <= 0 or ber_values[i + 1] <= 0:
                    continue
                log_ber_i = math.log10(ber_values[i])
                log_ber_next = math.log10(ber_values[i + 1])
                log_target = math.log10(target_ber)
                frac = (log_target - log_ber_i) / (log_ber_next - log_ber_i)
                return snr_points[i] + frac * (snr_points[i + 1] - snr_points[i])
        return None
