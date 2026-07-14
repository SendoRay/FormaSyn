"""Fitness & Pareto machinery for the evolutionary LoopEngine.

Correctness (compile+sim PASS) is a hard gate. Among PASS candidates we optimise
a Pareto front over PPA objectives (area now; Fmax/latency once measured). Non-PASS
candidates get a graded penalty score so the search can climb toward feasibility.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional

from .types import GeneratedCode, Variant, VerifyResult, VerifyVerdict

# Weight applied to Fmax so it competes with area in the scalar progress metric.
_FMAX_WEIGHT = 1.0e4


@dataclass
class Candidate:
    """A single design point: variant + generated code + verification outcome."""

    variant: Variant
    code: Optional[GeneratedCode] = None
    verify: Optional[VerifyResult] = None
    origin: str = "seed"  # seed | transform | repair | refine
    gen: int = 0
    metadata: dict = field(default_factory=dict)

    @property
    def verdict(self) -> Optional[VerifyVerdict]:
        return self.verify.verdict if self.verify else None

    @property
    def is_pass(self) -> bool:
        return self.verify is not None and self.verify.verdict == VerifyVerdict.PASS


def objective_vector(c: Candidate) -> Optional[tuple[float, float]]:
    """PPA objectives in MINIMISE convention: (area, -fmax).

    Returns None unless the candidate PASSed and has synthesis metrics, since PPA
    is only meaningful for correct designs.
    """
    if not c.is_pass or c.verify is None or c.verify.synth_metrics is None:
        return None
    m = c.verify.synth_metrics
    area = float(m.lut + m.ff)
    return (area, -float(m.fmax_mhz))


def area_of(c: Candidate) -> Optional[float]:
    v = objective_vector(c)
    return None if v is None else v[0]


def _sim_fail_score(sim_report: Optional[dict]) -> float:
    """Map a SIM_FAIL report to [0.1, 0.4): closer to all-correct scores higher."""
    if not sim_report:
        return 0.25
    err = str(sim_report.get("error", ""))
    # Structural failure (wrong number of outputs) — barely better than compile_fail.
    if "Row count mismatch" in err:
        return 0.1
    num = sim_report.get("num_mismatches")
    total = sim_report.get("num_comparisons")
    if isinstance(num, int) and isinstance(total, int) and total > 0:
        ratio = min(1.0, num / total)
        return 0.1 + 0.3 * (1.0 - ratio)
    # Fallback: count the (possibly truncated) mismatch list if present.
    mism = sim_report.get("mismatches")
    if isinstance(mism, list) and mism:
        return 0.2
    return 0.25


def graded_score(c: Candidate) -> float:
    """Continuous fitness over ALL candidates (used for parent selection / climbing).

    compile_fail < sim_fail < synth_fail < pass. PASS candidates are further
    separated by Pareto rank elsewhere; here they all score 1.0.
    """
    v = c.verify
    if v is None:
        return 0.0
    if v.verdict == VerifyVerdict.PASS:
        return 1.0
    if v.verdict == VerifyVerdict.SYNTH_FAIL:
        return 0.5
    if v.verdict == VerifyVerdict.SIM_FAIL:
        return _sim_fail_score(v.sim_report)
    return 0.0  # COMPILE_FAIL


def dominates(a: Candidate, b: Candidate) -> bool:
    """Pareto domination over objective_vector (both must be feasible/PASS)."""
    va, vb = objective_vector(a), objective_vector(b)
    if va is None or vb is None:
        return False
    le = all(x <= y for x, y in zip(va, vb))
    lt = any(x < y for x, y in zip(va, vb))
    return le and lt


def pareto_front(cands: list[Candidate]) -> list[Candidate]:
    """Non-dominated feasible (PASS) candidates."""
    feas = [c for c in cands if objective_vector(c) is not None]
    front: list[Candidate] = []
    for c in feas:
        if not any(dominates(o, c) for o in feas if o is not c):
            front.append(c)
    return front


def best_candidate(cands: list[Candidate]) -> Optional[Candidate]:
    """Single 'best' for reporting: min-area PASS (tie: higher Fmax); else best graded."""
    feas = [c for c in cands if objective_vector(c) is not None]
    if feas:
        return min(feas, key=lambda c: objective_vector(c))  # (area, -fmax) lexicographic
    if not cands:
        return None
    return max(cands, key=graded_score)


def pareto_progress(cands: list[Candidate]) -> float:
    """Scalar convergence signal; strictly increases when the front improves.

    Feasible: -min_area + W*max_fmax (lower area or higher Fmax both raise it).
    No feasible yet: large-negative offset + best graded_score, so the first PASS
    is always an improvement over any infeasible population.
    """
    feas = [objective_vector(c) for c in cands if objective_vector(c) is not None]
    if not feas:
        best_graded = max((graded_score(c) for c in cands), default=0.0)
        return -1.0e9 + best_graded
    min_area = min(v[0] for v in feas)
    min_negf = min(v[1] for v in feas)  # = -max_fmax
    return -min_area - _FMAX_WEIGHT * min_negf


def improved(new: float, old: float, eps: float = 1e-6) -> bool:
    return new > old + eps
