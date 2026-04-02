"""FormaSyn verification pipeline: L1/L2/L3 checkers and diagnostic agent."""

# L1/L2/L3 Checkers
from FormaSyn.formasyn.checker.l1_checker import L1Checker
from FormaSyn.formasyn.checker.l2_checker import L2Checker
from FormaSyn.formasyn.checker.l3_checker import L3Checker

# Diagnostic (LLM-based + rule-based fallback)
from FormaSyn.formasyn.checker.diagnostic import (
    DiagnosticAgent,
    FailureContext,
    FailureStage,
    diagnose_compile_error,
    diagnose_numeric_error,
    diagnose_quality_error,
    diagnose_resource_error,
)

# Metrics (unified data structures)
from FormaSyn.formasyn.checker.metrics import (
    HardwareBudget,
    L1Result,
    L2Result,
    L3Result,
    PreCheckResult,
    QualityThresholds,
    SynthReport,
)

# Pre-checker
from FormaSyn.formasyn.checker.pre_checker import PreChecker

__all__ = [
    # Checkers
    "L1Checker",
    "L2Checker",
    "L3Checker",
    # Diagnostic Agent
    "DiagnosticAgent",
    "FailureContext",
    "FailureStage",
    "diagnose_compile_error",
    "diagnose_numeric_error",
    "diagnose_quality_error",
    "diagnose_resource_error",
    # Metrics
    "HardwareBudget",
    "L1Result",
    "L2Result",
    "L3Result",
    "PreCheckResult",
    "QualityThresholds",
    "SynthReport",
    # Pre-checker
    "PreChecker",
]
