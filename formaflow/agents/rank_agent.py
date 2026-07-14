"""Multi-objective ranking agent for FormaFlow variants."""

from __future__ import annotations

import logging

from formaflow.types import Variant, VerifyResult, VerifyVerdict

logger = logging.getLogger(__name__)


class MultiObjectiveRankAgent:
    """Rank verified variants using weighted multi-objective scoring.

    Scoring dimensions:
      - area_score: lower (LUT + FF) is better
      - freq_score: higher Fmax is better
      - throughput_score: higher throughput_gbps is better

    Default weights: area=0.4, freq=0.3, throughput=0.3.
    """

    DEFAULT_WEIGHTS: dict[str, float] = {
        "area": 0.4,
        "freq": 0.3,
        "throughput": 0.3,
    }

    def __init__(self, weights: dict[str, float] | None = None) -> None:
        self.weights = weights if weights is not None else dict(self.DEFAULT_WEIGHTS)
        total = sum(self.weights.values())
        if abs(total - 1.0) > 1e-6:
            logger.warning(
                "Rank weights sum to %.4f (expected 1.0); normalizing.", total
            )
            self.weights = {k: v / total for k, v in self.weights.items()}

    def rank(
        self, results: list[tuple[Variant, VerifyResult]]
    ) -> list[Variant]:
        """Rank variants by multi-objective score. Only PASS results are ranked.

        Args:
            results: List of (Variant, VerifyResult) tuples.

        Returns:
            Sorted list of Variant objects, best first.
        """
        # Filter to passing results only
        passing = [
            (variant, vr)
            for variant, vr in results
            if vr.verdict == VerifyVerdict.PASS
        ]

        if not passing:
            logger.info("No passing variants to rank.")
            return []

        logger.info("Ranking %d passing variants.", len(passing))

        # Extract raw metric values
        areas: list[float] = []
        freqs: list[float] = []
        throughputs: list[float] = []

        for _, vr in passing:
            metrics = vr.synth_metrics
            if metrics is None:
                areas.append(float("inf"))
                freqs.append(0.0)
                throughputs.append(0.0)
            else:
                areas.append(float(metrics.lut + metrics.ff))
                freqs.append(metrics.fmax_mhz)
                throughputs.append(
                    metrics.throughput_gbps if metrics.throughput_gbps is not None else 0.0
                )

        # Normalize scores to [0, 1]
        area_scores = self._normalize_lower_is_better(areas)
        freq_scores = self._normalize_higher_is_better(freqs)
        throughput_scores = self._normalize_higher_is_better(throughputs)

        # Compute weighted composite score
        scored: list[tuple[float, Variant]] = []
        for i, (variant, _) in enumerate(passing):
            score = (
                self.weights.get("area", 0.4) * area_scores[i]
                + self.weights.get("freq", 0.3) * freq_scores[i]
                + self.weights.get("throughput", 0.3) * throughput_scores[i]
            )
            scored.append((score, variant))
            logger.debug(
                "Variant %s: area=%.3f freq=%.3f tput=%.3f composite=%.3f",
                variant.variant_id,
                area_scores[i],
                freq_scores[i],
                throughput_scores[i],
                score,
            )

        # Sort descending by score (higher is better)
        scored.sort(key=lambda x: x[0], reverse=True)

        ranked = [variant for _, variant in scored]
        logger.info("Top variant: %s", ranked[0].variant_id if ranked else "N/A")
        return ranked

    @staticmethod
    def _normalize_lower_is_better(values: list[float]) -> list[float]:
        """Normalize so that the lowest value gets score 1.0."""
        if not values:
            return []
        min_val = min(values)
        max_val = max(values)
        if max_val == min_val:
            return [1.0] * len(values)
        return [(max_val - v) / (max_val - min_val) for v in values]

    @staticmethod
    def _normalize_higher_is_better(values: list[float]) -> list[float]:
        """Normalize so that the highest value gets score 1.0."""
        if not values:
            return []
        min_val = min(values)
        max_val = max(values)
        if max_val == min_val:
            return [1.0] * len(values)
        return [(v - min_val) / (max_val - min_val) for v in values]
