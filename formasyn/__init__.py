"""FormaSyn: AI-driven compiler for communication algorithm FPGA implementation."""

from FormaSyn.formasyn.agent import (
    AgentDiagnostic,
    BaseAgent,
    CodegenArtifacts,
    DSEAgent,
    IntentJSON,
    QuantSpec,
    ScheduleCodegenAgent,
)
from FormaSyn.formasyn.checker import (
    L1Checker,
    L2Checker,
    L3Checker,
    PreChecker,
)
from FormaSyn.formasyn.dsl.parser import parse
from FormaSyn.formasyn.feedback.loop import FeedbackLoop
from FormaSyn.formasyn.golden.generator import GoldenModelGenerator
from FormaSyn.formasyn.ir.algo_hw_dialect import AlgoHWDialect
from FormaSyn.formasyn.ir.math_dialect import MathDialect
from FormaSyn.formasyn.ir.schedule_dialect import HLSScheduleDialect
from FormaSyn.formasyn.solver.roofline_solver import RooflineSolver

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
    "RooflineSolver",
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
