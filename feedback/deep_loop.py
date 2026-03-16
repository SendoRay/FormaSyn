"""Deep Loop: trigger a new LLM exploration round with failure feedback.

When pragma tuning alone cannot fix a variant (e.g. the algorithmic
approximation itself causes BER degradation), this module generates
structured feedback text and routes control back to the DSE Agent for
a fresh round of variant generation.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Optional

from FormaSyn.checker.diagnostic import FailureContext, FailureStage

logger = logging.getLogger(__name__)


@dataclass
class DeepLoopFeedback:
    """Structured feedback for the DSE Agent's next iteration.

    Attributes:
        feedback_text: Natural-language description of what went wrong
            and suggested directions for the next attempt.
        failed_variants: List of variant_ids that have been tried and failed.
        failure_summaries: Per-variant failure summaries.
        suggested_directions: Concrete suggestions for the LLM.
        iteration: Current deep-loop iteration number.
    """
    feedback_text: str
    failed_variants: list[str] = field(default_factory=list)
    failure_summaries: dict[str, str] = field(default_factory=dict)
    suggested_directions: list[str] = field(default_factory=list)
    iteration: int = 0


class DeepLoopGenerator:
    """Generates feedback text from failure history for the DSE Agent.

    Tracks failure history across iterations and produces increasingly
    specific guidance to steer the LLM toward successful variants.
    """

    MAX_DEEP_ITERATIONS: int = 3

    def __init__(self) -> None:
        self._history: list[FailureContext] = []
        self._iteration: int = 0

    @property
    def iteration(self) -> int:
        return self._iteration

    @property
    def can_iterate(self) -> bool:
        return self._iteration < self.MAX_DEEP_ITERATIONS

    def generate_feedback(
        self, failures: list[FailureContext]
    ) -> DeepLoopFeedback:
        """Generate structured feedback from a batch of variant failures.

        Args:
            failures: List of FailureContexts from the latest round.

        Returns:
            DeepLoopFeedback with feedback_text for the DSE Agent.
        """
        self._history.extend(failures)
        self._iteration += 1

        failed_variants = [f.variant_id for f in failures]
        summaries = {f.variant_id: f.summary for f in failures}
        directions = self._infer_directions(failures)

        text_parts: list[str] = [
            f"## 第 {self._iteration} 轮深度迭代反馈",
            "",
            "### 失败变体汇总",
        ]

        for fc in failures:
            text_parts.append(f"- **{fc.variant_id}**: {fc.summary}")
            if fc.gap_description:
                text_parts.append(f"  差距: {fc.gap_description}")

        text_parts.append("")
        text_parts.append("### 建议方向")
        for d in directions:
            text_parts.append(f"- {d}")

        if self._iteration > 1:
            text_parts.append("")
            text_parts.append(
                f"### 历史失败记录 (共 {len(self._history)} 次失败)"
            )
            seen_methods: set[str] = set()
            for fc in self._history:
                stage = fc.failed_at.value if isinstance(fc.failed_at, FailureStage) else str(fc.failed_at)
                text_parts.append(
                    f"- [{stage}] {fc.variant_id}: {fc.summary}"
                )

        feedback_text = "\n".join(text_parts)

        return DeepLoopFeedback(
            feedback_text=feedback_text,
            failed_variants=failed_variants,
            failure_summaries=summaries,
            suggested_directions=directions,
            iteration=self._iteration,
        )

    def _infer_directions(
        self, failures: list[FailureContext]
    ) -> list[str]:
        """Infer optimization directions from failure patterns."""
        directions: list[str] = []

        has_numeric = any(
            f.failed_at in (FailureStage.L1_NUMERIC, FailureStage.L3_QUALITY)
            for f in failures
        )
        has_resource = any(
            f.failed_at == FailureStage.L2_CSYNTH
            for f in failures
        )

        if has_numeric and has_resource:
            directions.append(
                "同时存在数值精度和资源问题，建议尝试中间路线: "
                "适度量化(12-14位) + 中等并行度(4-8)"
            )
        elif has_numeric:
            directions.append(
                "数值精度不足，建议: 增加位宽、使用更精确的近似方法"
                "(如 offset_min_sum 替代 min_sum)、启用饱和保护"
            )
            sign_errors = [
                f for f in failures
                if f.measured_metrics.get("sign_error_rate", 0) > 0
            ]
            if sign_errors:
                directions.append(
                    "存在符号错误，检查是否 int_bits 不足导致溢出"
                )
        elif has_resource:
            directions.append(
                "资源超限，建议: 降低并行度、减少位宽、"
                "使用更轻量的近似方法(如 min_sum 替代 spa_exact)"
            )

        if not directions:
            directions.append("尝试不同的近似方法和并行度组合")

        return directions
