"""FormaSyn: AI-driven compiler for communication algorithm FPGA implementation."""

from .agent import (
    AgentDiagnostic,
    BaseAgent,
    DSEAgent,
    IntentJSON,
    QuantSpec,
)
from .checker import (
    L1Checker,
    L2Checker,
    L3Checker,
)
from .dsl.parser import parse
from .feedback.loop import FeedbackLoop
from .golden.generator import GoldenModelGenerator
from .ir.algo_hw_dialect import AlgoHWDialect
from .ir.math_dialect import MathDialect
from .ir.rtl_dialect import RTLScheduleDialect

__all__ = [
    # IR
    "MathDialect",
    "AlgoHWDialect",
    "RTLScheduleDialect",
    # DSL
    "parse",
    # Agent
    "BaseAgent",
    "DSEAgent",
    "IntentJSON",
    "QuantSpec",
    "AgentDiagnostic",
    # Checker
    "L1Checker",
    "L2Checker",
    "L3Checker",
    # Feedback
    "FeedbackLoop",
    # Golden
    "GoldenModelGenerator",
]
