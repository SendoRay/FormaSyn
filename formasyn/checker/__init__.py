"""FormaSyn verification pipeline: L1/L2/L3 checkers and diagnostic agent."""

# L1/L2/L3 Checkers
from .l1_checker import L1Checker
from .l2_checker import L2Checker
from .l3_checker import L3Checker

# Diagnostic (rule-based helpers + data types)
from .diagnostic import (
    FailureContext,
    FailureStage,
    diagnose_compile_error,
    diagnose_numeric_error,
    diagnose_quality_error,
    diagnose_resource_error_with_ii,
)

# Metrics (unified data structures)
from .metrics import (
    HardwareBudget,
    L1Result,
    L2Result,
    L3Result,
    PreCheckResult,
    QualityThresholds,
    SynthReport,
)

__all__ = [
    # Checkers
    "L1Checker",
    "L2Checker",
    "L3Checker",
    # Diagnostic
    "FailureContext",
    "FailureStage",
    "diagnose_compile_error",
    "diagnose_numeric_error",
    "diagnose_quality_error",
    "diagnose_resource_error_with_ii",
    # Metrics
    "HardwareBudget",
    "L1Result",
    "L2Result",
    "L3Result",
    "PreCheckResult",
    "QualityThresholds",
    "SynthReport",
]
