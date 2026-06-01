"""RTL Schedule Dialect: third IR layer targeting Verilog/RTL code generation.

Replaces the former HLSScheduleDialect which targeted Vitis HLS C++.
RTLScheduleDialect maps AlgoHWDialect nodes onto concrete RTL scheduling
decisions: pipeline stages, latency, storage types (register/BRAM/LUTRAM),
FSM states, and port definitions that directly drive Verilog codegen.
"""

from __future__ import annotations

import dataclasses
from dataclasses import dataclass, field
from typing import Optional


@dataclass
class RTLNode:
    """A single operation scheduled for RTL implementation.

    Attributes:
        node_id: Unique identifier for this node.
        op_type: Operation type (map/reduce/delay/shift_reg/message_pass/input).
        op_detail: Operation-specific parameters (e.g. func, op, domain_kind).
        shape: Tensor shape of the output.
        input_nodes: IDs of upstream nodes this node depends on.
        data_type: Fixed-point type descriptor (e.g. "fixed<16,8>").
        approx_method: Approximation algorithm if applicable.
        parallelism: Degree of parallelism.
        saturation_guard: Whether saturation arithmetic is enabled.
        quant_int_bits: Integer part bit-width for fixed-point.
        quant_frac_bits: Fractional part bit-width for fixed-point.
        is_irregular_access: Whether this node has irregular memory access patterns.
        csr_ref: Reference to CSR matrix if applicable.
        has_feedback: Whether this node participates in a feedback loop.
        pipeline_stage: Which pipeline stage this node is assigned to.
        latency_cycles: Number of clock cycles this operation takes.
        register_output: Whether the output should be registered.
        storage_type: Storage implementation (register/bram/lutram/distributed).
        bram_ports: Number of BRAM ports allocated.
        bram_banks: Number of BRAM banks for address interleaving.
        address_width: Address bus width in bits.
        fsm_state: FSM state this node executes in, if applicable.
        exec_mode: Execution mode (combinational/pipelined/iterative).
    """

    node_id: str
    op_type: str
    op_detail: dict
    shape: list[int]
    input_nodes: list[str]
    data_type: str = "fixed<16,8>"
    approx_method: Optional[str] = None
    parallelism: int = 1
    saturation_guard: bool = False
    quant_int_bits: int = 8
    quant_frac_bits: int = 8
    is_irregular_access: bool = False
    csr_ref: Optional[str] = None
    has_feedback: bool = False
    pipeline_stage: int = 0
    latency_cycles: int = 1
    register_output: bool = False
    storage_type: str = "register"
    bram_ports: int = 1
    bram_banks: int = 0
    address_width: int = 0
    fsm_state: Optional[str] = None
    exec_mode: str = "combinational"


@dataclass
class PortDef:
    """A top-level module port definition.

    Attributes:
        name: Port signal name.
        direction: Port direction (input/output).
        width: Bit width of the port.
        is_array: Whether this port represents an array interface.
        array_depth: Depth of the array if is_array is True.
    """

    name: str
    direction: str
    width: int
    is_array: bool = False
    array_depth: Optional[int] = None


@dataclass
class RTLScheduleDialect:
    """Complete RTL schedule for a kernel variant.

    Top-level container that holds all scheduled RTL nodes, resource
    estimates, FSM description, and port definitions needed to drive
    Verilog code generation.

    Attributes:
        kernel_name: Name of the kernel being compiled.
        nodes: Mapping of node_id to scheduled RTLNode.
        clock_period_ns: Target clock period in nanoseconds.
        total_pipeline_stages: Number of pipeline stages in the design.
        total_latency_cycles: End-to-end latency in clock cycles.
        throughput_samples_per_cycle: Throughput in samples per clock cycle.
        estimated_luts: Estimated LUT usage.
        estimated_ffs: Estimated flip-flop usage.
        estimated_dsps: Estimated DSP block usage.
        estimated_brams: Estimated BRAM usage.
        fsm_states: Ordered list of FSM state names.
        fsm_transitions: State transition map (current_state -> next_state).
        input_ports: Top-level input port definitions.
        output_ports: Top-level output port definitions.
        clock_name: Clock signal name.
        reset_name: Reset signal name (active-low by convention).
        variant_id: Unique variant identifier.
        intent_json: The DSE intent that produced this variant.
        quality_bound: Quality degradation bounds from rewrite rules.
        input_nodes: Kernel input node IDs.
        output_nodes: Kernel output node IDs.
    """

    kernel_name: str
    nodes: dict[str, RTLNode]
    clock_period_ns: float = 4.0
    total_pipeline_stages: int = 1
    total_latency_cycles: int = 1
    throughput_samples_per_cycle: int = 1
    estimated_luts: int = 0
    estimated_ffs: int = 0
    estimated_dsps: int = 0
    estimated_brams: int = 0
    fsm_states: list[str] = field(default_factory=list)
    fsm_transitions: dict[str, str] = field(default_factory=dict)
    input_ports: list[PortDef] = field(default_factory=list)
    output_ports: list[PortDef] = field(default_factory=list)
    clock_name: str = "clk"
    reset_name: str = "rst_n"
    variant_id: str = ""
    intent_json: dict = field(default_factory=dict)
    quality_bound: Optional[dict] = None
    input_nodes: list[str] = field(default_factory=list)
    output_nodes: list[str] = field(default_factory=list)

    def to_json(self) -> dict:
        """Serialize the entire RTL schedule to a JSON-compatible dict."""
        return dataclasses.asdict(self)
