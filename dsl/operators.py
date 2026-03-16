"""DSL operator definitions for FormaSyn.

Provides five operator primitives (MapOp, ReduceOp, DelayOp, ShiftRegOp,
MessagePassOp) and a FormulaGraph container that users compose to describe
communication algorithm kernels.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Any, Optional, Union

logger = logging.getLogger(__name__)

VALID_MAP_FUNCS: set[str] = {
    "multiply", "tanh", "atanh", "sign", "abs",
    "lut", "clamp", "quantize", "xor_reduce",
}

VALID_REDUCE_OPS: set[str] = {"add", "mul", "min", "max", "xor"}

VALID_DOMAIN_KINDS: set[str] = {"all", "neighbors", "window"}

VALID_NODE_TYPES: set[str] = {"variable_node", "check_node"}

VALID_SCHEDULES: set[str] = {"flooding", "layered"}


@dataclass
class Domain:
    """Describes the reduction scope for a ReduceOp.

    Attributes:
        kind: One of 'all', 'neighbors', 'window'.
        graph_ref: Required when kind='neighbors'; names the H-matrix variable.
        exclude_self: Whether to exclude the current node (needed for LDPC CNU).
        window_size: Required when kind='window'; sliding-window length.
        window_stride: Stride of the sliding window (defaults to 1).
    """

    kind: str
    graph_ref: Optional[str] = None
    exclude_self: bool = False
    window_size: Optional[int] = None
    window_stride: Optional[int] = None

    def __post_init__(self) -> None:
        if self.kind not in VALID_DOMAIN_KINDS:
            raise ValueError(
                f"Invalid domain kind '{self.kind}', "
                f"must be one of {VALID_DOMAIN_KINDS}"
            )
        if self.kind == "neighbors" and self.graph_ref is None:
            raise ValueError("graph_ref is required when kind='neighbors'")
        if self.kind == "window" and self.window_size is None:
            raise ValueError("window_size is required when kind='window'")


@dataclass
class OpBase:
    """Marker base class shared by all DSL operators."""

    output_ref: str


@dataclass
class MapOp(OpBase):
    """Element-wise mapping operator.

    Attributes:
        input_ref: Name of the input signal.
        func: Function name (e.g. 'sign', 'abs', 'multiply').
        func_params: Extra parameters keyed by the function
            (e.g. {'coeff': 0.5} for 'multiply').
        output_ref: Name of the output signal.
    """

    input_ref: str = ""
    func: str = ""
    func_params: dict[str, Any] = field(default_factory=dict)

    def __post_init__(self) -> None:
        if self.func and self.func not in VALID_MAP_FUNCS:
            raise ValueError(
                f"Invalid map func '{self.func}', "
                f"must be one of {VALID_MAP_FUNCS}"
            )


@dataclass
class ReduceOp(OpBase):
    """Reduction operator over a domain.

    Attributes:
        input_ref: Name of the input signal.
        op: Reduction operation ('add', 'mul', 'min', 'max', 'xor').
        domain: A Domain describing the reduction scope.
        output_ref: Name of the output signal.
    """

    input_ref: str = ""
    op: str = ""
    domain: Domain = field(default_factory=lambda: Domain(kind="all"))

    def __post_init__(self) -> None:
        if self.op and self.op not in VALID_REDUCE_OPS:
            raise ValueError(
                f"Invalid reduce op '{self.op}', "
                f"must be one of {VALID_REDUCE_OPS}"
            )


@dataclass
class DelayOp(OpBase):
    """Single-step delay operator.

    Attributes:
        input_ref: Name of the input signal.
        steps: Number of delay cycles (default 1).
        output_ref: Name of the output signal.
    """

    input_ref: str = ""
    steps: int = 1


@dataclass
class ShiftRegOp(OpBase):
    """Shift-register (tap delay line) operator.

    Attributes:
        input_ref: Name of the input signal.
        taps: List of tap indices to output
            (e.g. [0, 3, 7] for current, 3-ago, 7-ago).
        output_ref: Output vector whose length equals len(taps).
    """

    input_ref: str = ""
    taps: list[int] = field(default_factory=list)


@dataclass
class MessagePassOp(OpBase):
    """Graph message-passing operator (e.g. LDPC belief propagation).

    Attributes:
        graph_ref: Variable name of the H-matrix.
        node_type: 'variable_node' or 'check_node'.
        forward_map: MapOp applied to each incoming message.
        forward_reduce: ReduceOp that aggregates transformed messages.
        schedule: 'flooding' or 'layered'.
        output_ref: Name of the output signal.
    """

    graph_ref: str = ""
    node_type: str = "check_node"
    forward_map: MapOp = field(default_factory=lambda: MapOp(output_ref=""))
    forward_reduce: ReduceOp = field(
        default_factory=lambda: ReduceOp(output_ref="")
    )
    schedule: str = "flooding"

    def __post_init__(self) -> None:
        if self.node_type and self.node_type not in VALID_NODE_TYPES:
            raise ValueError(
                f"Invalid node_type '{self.node_type}', "
                f"must be one of {VALID_NODE_TYPES}"
            )
        if self.schedule not in VALID_SCHEDULES:
            raise ValueError(
                f"Invalid schedule '{self.schedule}', "
                f"must be one of {VALID_SCHEDULES}"
            )


AnyOp = Union[MapOp, ReduceOp, DelayOp, ShiftRegOp, MessagePassOp]


@dataclass
class FormulaGraph:
    """Container that holds the ordered sequence of DSL operators
    describing a communication algorithm kernel.

    Attributes:
        name: Kernel name (e.g. 'ldpc_cnu', 'fir_filter').
        inputs: Mapping of input signal names to their shapes.
        outputs: List of output signal names.
        ops: Ordered list of DSL operators.
        graph_data: Optional adjacency / H-matrix data
            (scipy.sparse.csr_matrix or numpy 2-D array).
    """

    name: str
    inputs: dict[str, list[int]] = field(default_factory=dict)
    outputs: list[str] = field(default_factory=list)
    ops: list[AnyOp] = field(default_factory=list)
    graph_data: Optional[Any] = None

    def add(self, op: AnyOp) -> None:
        """Append an operator to the pipeline."""
        self.ops.append(op)
        logger.debug("Added %s to graph '%s'", type(op).__name__, self.name)
