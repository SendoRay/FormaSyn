"""Core data types for the FormaFlow pipeline."""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum


class OpType(Enum):
    """FVIR operation types."""

    ELEMENTWISE = "elementwise"
    REDUCE = "reduce"
    MEMORY = "memory"
    CONTROL = "control"
    CONSTRAINT = "constraint"


class TransformType(Enum):
    """Type of formula transformation."""

    NAIVE = "naive"
    EXACT = "exact"
    APPROXIMATE = "approximate"


class VerifyVerdict(Enum):
    """Outcome of the verification loop."""

    COMPILE_FAIL = "compile_fail"
    SIM_FAIL = "sim_fail"
    SYNTH_FAIL = "synth_fail"
    PASS = "pass"


@dataclass(frozen=True)
class FVIROp:
    """A single FVIR operation."""

    op_type: OpType
    name: str
    inputs: list[str]
    outputs: list[str]
    params: dict = field(default_factory=dict)


@dataclass(frozen=True)
class FVIR:
    """Agent-Aware IR representation of a kernel."""

    kernel_id: str
    ops: tuple[FVIROp, ...]
    constraints: dict  # @width, @throughput, @freq, @resource_limit
    source_latex: str
    metadata: dict = field(default_factory=dict)


@dataclass(frozen=True)
class Variant:
    """A transformed FVIR variant."""

    variant_id: str
    fvir: FVIR
    transform_applied: str  # e.g., "symmetry_preaddition", "cordic_approx"
    transform_type: TransformType
    rationale: str


@dataclass(frozen=True)
class GeneratedCode:
    """Verilog output from codegen."""

    variant_id: str
    verilog: str
    testbench: str
    generation_metadata: dict = field(default_factory=dict)


@dataclass(frozen=True)
class SynthMetrics:
    """FPGA synthesis resource/timing metrics."""

    lut: int
    ff: int
    dsp: int
    bram: int
    fmax_mhz: float
    critical_path_ns: float
    throughput_gbps: float | None = None


@dataclass(frozen=True)
class VerifyResult:
    """Result from the verification loop."""

    verdict: VerifyVerdict
    iterations: int
    compile_errors: list[str] = field(default_factory=list)
    sim_report: dict | None = None  # mismatch details if SIM_FAIL
    synth_metrics: SynthMetrics | None = None
    error_log: str = ""


@dataclass(frozen=True)
class KernelResult:
    """Final result for one kernel × one LLM × one repetition."""

    kernel_id: str
    llm_backend: str
    rep_id: int
    variants_generated: list[Variant]
    best_variant: Variant | None
    verify_result: VerifyResult | None
    wall_time_seconds: float
    metadata: dict = field(default_factory=dict)
