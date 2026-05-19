"""Rewrite rule definitions and catalog for formal approximation guarantees.

Each RewriteRule is a (Pattern -> Replacement) transformation with a provable
upper bound on signal quality degradation. The LLM searches combinations of
rules rather than generating raw HLS code.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Optional


class ProofType(str, Enum):
    """Method used to prove the quality bound."""

    ANALYTICAL = "analytical"
    INTERVAL_ANALYSIS = "interval_analysis"
    MONTE_CARLO = "monte_carlo"


class QualityMetric(str, Enum):
    """Signal quality metric type."""

    BER_PENALTY_DB = "ber_penalty_db"
    NMSE_DB = "nmse_db"
    EVM_DB = "evm_db"
    SFDR_DB = "sfdr_db"
    SNR_PENALTY_DB = "snr_penalty_db"


@dataclass(frozen=True)
class QualityBound:
    """Provable upper bound on quality degradation from a single rewrite.

    Attributes:
        metric: Which quality metric this bound applies to.
        upper_bound: Maximum degradation (e.g. 0.5 means <= 0.5 dB penalty).
        proof_type: How the bound was established.
        conditions: Conditions under which the bound holds
            (e.g. {'snr_min_db': 2.0} means valid only for Eb/N0 > 2 dB).
    """

    metric: QualityMetric
    upper_bound: float
    proof_type: ProofType
    conditions: dict[str, Any] = field(default_factory=dict)


@dataclass(frozen=True)
class ResourceDelta:
    """Expected resource change from applying a rewrite rule.

    Negative values mean resource savings.

    Attributes:
        dsp_delta: Change in DSP48 usage per node instance.
        bram_delta: Change in BRAM18 usage per node instance.
        lut_delta: Estimated change in LUT usage.
    """

    dsp_delta: int = 0
    bram_delta: int = 0
    lut_delta: int = 0


@dataclass
class RewritePattern:
    """Pattern to match in the AlgoHW IR graph.

    Attributes:
        op_types: Sequence of op_type strings to match.
        func_match: Function names to match within map nodes.
        domain_match: Domain kind to match in reduce nodes.
        constraints: Additional matching constraints.
    """

    op_types: list[str] = field(default_factory=list)
    func_match: dict[str, str] = field(default_factory=dict)
    domain_match: Optional[str] = None
    constraints: dict[str, Any] = field(default_factory=dict)


@dataclass
class RewriteReplacement:
    """Replacement specification for a matched pattern.

    Attributes:
        new_op_types: Replacement operator types.
        new_funcs: New function assignments for map nodes.
        new_params: Parameters for the replacement (e.g. scale_factor, offset).
        remove_ops: Op types to remove from the matched subgraph.
    """

    new_op_types: list[str] = field(default_factory=list)
    new_funcs: dict[str, str] = field(default_factory=dict)
    new_params: dict[str, Any] = field(default_factory=dict)
    remove_ops: list[str] = field(default_factory=list)


@dataclass
class RewriteRule:
    """A single algebraic rewrite rule with quality guarantee.

    The fundamental unit of Direction A: each rule transforms a subgraph
    pattern into an equivalent (within bounds) implementation.

    Attributes:
        name: Human-readable rule identifier (e.g. 'R1_tanh_to_minsum').
        description: What this rule does.
        pattern: What to match in the IR.
        replacement: What to substitute.
        quality_bound: Provable quality degradation upper bound.
        resource_delta: Expected resource change per application.
        applicable_kernel_types: Which kernel types this rule applies to.
        parameters: Tunable parameters with (min, max, default) ranges.
    """

    name: str
    description: str
    pattern: RewritePattern
    replacement: RewriteReplacement
    quality_bound: QualityBound
    resource_delta: ResourceDelta
    applicable_kernel_types: list[str] = field(default_factory=lambda: ["channel_coding"])
    parameters: dict[str, tuple[float, float, float]] = field(default_factory=dict)


# ---------------------------------------------------------------------------
# Built-in Rule Catalog for LDPC / Communication Algorithms
# ---------------------------------------------------------------------------

_LDPC_RULES: list[RewriteRule] = [
    RewriteRule(
        name="R1_tanh_to_minsum",
        description="Replace tanh/atanh with sign-XOR + magnitude-min (Min-Sum approximation)",
        pattern=RewritePattern(
            op_types=["map", "map"],
            func_match={"node_0": "tanh", "node_1": "atanh"},
        ),
        replacement=RewriteReplacement(
            new_funcs={"node_0": "sign", "node_0b": "abs"},
            new_op_types=["map", "map", "reduce", "reduce"],
            new_params={"scale": 0.75},
            remove_ops=["tanh", "atanh"],
        ),
        quality_bound=QualityBound(
            metric=QualityMetric.BER_PENALTY_DB,
            upper_bound=0.5,
            proof_type=ProofType.ANALYTICAL,
            conditions={"snr_min_db": 2.0},
        ),
        resource_delta=ResourceDelta(dsp_delta=-3, bram_delta=0, lut_delta=10),
    ),
    RewriteRule(
        name="R2_normalized_minsum",
        description="Apply normalization factor alpha to Min-Sum output",
        pattern=RewritePattern(
            op_types=["reduce"],
            domain_match="neighbors",
            constraints={"op": "min"},
        ),
        replacement=RewriteReplacement(
            new_params={"scale_factor": 0.75},
        ),
        quality_bound=QualityBound(
            metric=QualityMetric.BER_PENALTY_DB,
            upper_bound=0.1,
            proof_type=ProofType.MONTE_CARLO,
            conditions={"alpha_range": [0.7, 0.85]},
        ),
        resource_delta=ResourceDelta(dsp_delta=0, bram_delta=0, lut_delta=0),
        parameters={"alpha": (0.7, 0.85, 0.75)},
    ),
    RewriteRule(
        name="R3_offset_minsum",
        description="Subtract offset beta from Min-Sum result, clamp at 0",
        pattern=RewritePattern(
            op_types=["reduce"],
            domain_match="neighbors",
            constraints={"op": "min"},
        ),
        replacement=RewriteReplacement(
            new_params={"offset_beta": 0.15, "clamp_min": 0.0},
        ),
        quality_bound=QualityBound(
            metric=QualityMetric.BER_PENALTY_DB,
            upper_bound=0.15,
            proof_type=ProofType.MONTE_CARLO,
            conditions={"beta_range": [0.1, 0.5]},
        ),
        resource_delta=ResourceDelta(dsp_delta=0, bram_delta=0, lut_delta=5),
        parameters={"beta": (0.1, 0.5, 0.15)},
    ),
    RewriteRule(
        name="R4_lut_tanh",
        description="Replace tanh with lookup table",
        pattern=RewritePattern(
            op_types=["map"],
            func_match={"node_0": "tanh"},
        ),
        replacement=RewriteReplacement(
            new_funcs={"node_0": "lut"},
            new_params={"table_depth": 256},
        ),
        quality_bound=QualityBound(
            metric=QualityMetric.NMSE_DB,
            upper_bound=-40.0,
            proof_type=ProofType.INTERVAL_ANALYSIS,
            conditions={"table_depth_min": 256},
        ),
        resource_delta=ResourceDelta(dsp_delta=-3, bram_delta=1, lut_delta=-50),
        parameters={"table_depth": (64, 1024, 256)},
    ),
    RewriteRule(
        name="R5_two_min_decomposition",
        description="Replace per-edge min(all\\self) with {min1, min2} + select",
        pattern=RewritePattern(
            op_types=["reduce"],
            domain_match="neighbors",
            constraints={"op": "min", "exclude_self": True},
        ),
        replacement=RewriteReplacement(
            new_op_types=["reduce_two_min", "select"],
            new_params={"decompose": True},
        ),
        quality_bound=QualityBound(
            metric=QualityMetric.BER_PENALTY_DB,
            upper_bound=0.0,
            proof_type=ProofType.ANALYTICAL,
        ),
        resource_delta=ResourceDelta(dsp_delta=0, bram_delta=0, lut_delta=-20),
    ),
    RewriteRule(
        name="R6_bitwidth_reduction",
        description="Reduce fixed-point bit-width (requires interval analysis verification)",
        pattern=RewritePattern(
            op_types=["map", "reduce"],
        ),
        replacement=RewriteReplacement(
            new_params={"reduce_frac_bits": 2},
        ),
        quality_bound=QualityBound(
            metric=QualityMetric.BER_PENALTY_DB,
            upper_bound=0.05,
            proof_type=ProofType.INTERVAL_ANALYSIS,
            conditions={"min_total_bits": 6},
        ),
        resource_delta=ResourceDelta(dsp_delta=-1, bram_delta=0, lut_delta=-8),
        parameters={"reduce_frac_bits": (1, 4, 2)},
    ),
]

_FILTER_RULES: list[RewriteRule] = [
    RewriteRule(
        name="R7_symmetric_fir",
        description="Exploit FIR coefficient symmetry to halve multiplications",
        pattern=RewritePattern(
            op_types=["shift_reg", "map", "reduce"],
            func_match={"node_1": "multiply"},
            constraints={"symmetric_coeffs": True},
        ),
        replacement=RewriteReplacement(
            new_params={"exploit_symmetry": True},
        ),
        quality_bound=QualityBound(
            metric=QualityMetric.NMSE_DB,
            upper_bound=0.0,
            proof_type=ProofType.ANALYTICAL,
        ),
        resource_delta=ResourceDelta(dsp_delta=-8, bram_delta=0, lut_delta=4),
        applicable_kernel_types=["filtering"],
    ),
    RewriteRule(
        name="R8_coefficient_quantization",
        description="Quantize FIR coefficients to fewer bits",
        pattern=RewritePattern(
            op_types=["map"],
            func_match={"node_0": "multiply"},
        ),
        replacement=RewriteReplacement(
            new_params={"coeff_bits": 12},
        ),
        quality_bound=QualityBound(
            metric=QualityMetric.NMSE_DB,
            upper_bound=-50.0,
            proof_type=ProofType.INTERVAL_ANALYSIS,
            conditions={"min_coeff_bits": 8},
        ),
        resource_delta=ResourceDelta(dsp_delta=-1, bram_delta=0, lut_delta=0),
        applicable_kernel_types=["filtering"],
        parameters={"coeff_bits": (8, 16, 12)},
    ),
]


class RewriteCatalog:
    """Registry of all available rewrite rules.

    Provides filtering by kernel type and composability checks.
    """

    def __init__(self) -> None:
        self._rules: dict[str, RewriteRule] = {}
        # Load built-in rules
        for rule in _LDPC_RULES + _FILTER_RULES:
            self._rules[rule.name] = rule

    @property
    def all_rules(self) -> list[RewriteRule]:
        """All registered rules."""
        return list(self._rules.values())

    def get(self, name: str) -> Optional[RewriteRule]:
        """Get a rule by name."""
        return self._rules.get(name)

    def for_kernel_type(self, kernel_type: str) -> list[RewriteRule]:
        """Get rules applicable to a specific kernel type."""
        return [
            r for r in self._rules.values()
            if kernel_type in r.applicable_kernel_types
        ]

    def register(self, rule: RewriteRule) -> None:
        """Register a custom rule."""
        self._rules[rule.name] = rule

    def compute_combined_bound(
        self, rule_names: list[str]
    ) -> dict[str, float]:
        """Compute the combined quality bound for a set of rules.

        The combined bound is the sum of individual upper bounds per metric
        (conservative but safe composition).

        Returns:
            Mapping of metric name to combined upper bound.
        """
        combined: dict[str, float] = {}
        for name in rule_names:
            rule = self._rules.get(name)
            if rule is None:
                continue
            metric = rule.quality_bound.metric.value
            combined[metric] = combined.get(metric, 0.0) + rule.quality_bound.upper_bound
        return combined

    def compute_combined_resource(
        self, rule_names: list[str]
    ) -> ResourceDelta:
        """Compute combined resource delta for a rule set."""
        total_dsp = 0
        total_bram = 0
        total_lut = 0
        for name in rule_names:
            rule = self._rules.get(name)
            if rule is None:
                continue
            total_dsp += rule.resource_delta.dsp_delta
            total_bram += rule.resource_delta.bram_delta
            total_lut += rule.resource_delta.lut_delta
        return ResourceDelta(dsp_delta=total_dsp, bram_delta=total_bram, lut_delta=total_lut)

    def check_composability(self, rule_names: list[str]) -> list[str]:
        """Check if rules can be composed. Returns list of conflicts."""
        conflicts: list[str] = []
        # R2 and R3 are mutually exclusive (both modify min-sum output)
        if "R2_normalized_minsum" in rule_names and "R3_offset_minsum" in rule_names:
            conflicts.append("R2 and R3 are mutually exclusive (both post-process min-sum)")
        # R1 is prerequisite for R2, R3, R5
        minsum_deps = {"R2_normalized_minsum", "R3_offset_minsum", "R5_two_min_decomposition"}
        if minsum_deps & set(rule_names) and "R1_tanh_to_minsum" not in rule_names:
            conflicts.append("R2/R3/R5 require R1 (tanh→minsum) as prerequisite")
        return conflicts
