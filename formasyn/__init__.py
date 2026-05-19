"""FormaSyn: AI-driven compiler for communication algorithm FPGA implementation."""

from .agent import (
    AgentDiagnostic,
    BaseAgent,
    CodegenArtifacts,
    DSEAgent,
    IntentJSON,
    QuantSpec,
    ScheduleCodegenAgent,
)
from .checker import (
    L1Checker,
    L2Checker,
    L3Checker,
    PreChecker,
)
from .dsl.parser import parse
from .feedback.loop import FeedbackLoop
from .golden.generator import GoldenModelGenerator
from .ir.algo_hw_dialect import AlgoHWDialect
from .ir.math_dialect import MathDialect
from .ir.schedule_dialect import HLSScheduleDialect
from .solver.schedule_builder import ScheduleBuilder

__all__ = [
    # IR
    "MathDialect",
    "AlgoHWDialect",
    "HLSScheduleDialect",
    # DSL
    "parse",
    # Agent
    "BaseAgent",
    "DSEAgent",
    "ScheduleCodegenAgent",
    "IntentJSON",
    "QuantSpec",
    "CodegenArtifacts",
    "AgentDiagnostic",
    # Solver
    "ScheduleBuilder",
    # Checker
    "L1Checker",
    "L2Checker",
    "L3Checker",
    "PreChecker",
    # Feedback
    "FeedbackLoop",
    # Golden
    "GoldenModelGenerator",
]
