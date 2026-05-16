"""FormaSyn Feedback 模块.

负责失败后的智能恢复循环.
"""

from .loop import FeedbackLoop, LoopResult, LoopState

__all__ = [
    "FeedbackLoop",
    "LoopResult",
    "LoopState",
]
