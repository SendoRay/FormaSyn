"""FormaSyn feedback loop: pragma tuning and deep iteration."""

from FormaSyn.formasyn.feedback.loop import (
    DeepLoopFeedback,
    DeepLoopGenerator,
    FeedbackLoop,
    LoopResult,
    LoopState,
)

__all__ = [
    "FeedbackLoop",
    "LoopState",
    "LoopResult",
    # 向后兼容别名
    "DeepLoopGenerator",
    "DeepLoopFeedback",
]
