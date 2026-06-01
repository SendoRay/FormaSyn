"""Verilog module skeleton generator.

Produces a structural Verilog scaffold (ports, clocking, wire/reg declarations,
BRAM instances, FSM state registers) from an RTLScheduleDialect.  The scaffold
is then handed to an LLM which fills in the datapath logic.
"""

from __future__ import annotations

import math
from typing import Optional

from formasyn.ir.rtl_dialect import PortDef, RTLNode, RTLScheduleDialect


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _verilog_type(port: PortDef, direction: str) -> str:
    """Return a Verilog port declaration string for *port*.

    Examples:
        input wire signed [15:0] x
        output reg signed [7:0] y
    """
    kind = "wire" if direction == "input" else "reg"
    if port.width > 1:
        return f"{direction} {kind} signed [{port.width - 1}:0]"
    return f"{direction} {kind}"


def _wire_decl(node: RTLNode) -> str:
    """Return a Verilog internal signal declaration for *node*.

    Uses ``reg`` when the node output is registered, ``wire`` otherwise.
    """
    width = node.quant_int_bits + node.quant_frac_bits
    kind = "reg" if node.register_output else "wire"
    if width > 1:
        return f"    {kind} signed [{width - 1}:0] {node.node_id};"
    return f"    {kind} signed {node.node_id};"


def _bits_for_value(n: int) -> int:
    """Return the minimum number of bits to represent *n* distinct values."""
    if n <= 1:
        return 1
    return math.ceil(math.log2(n))


# ---------------------------------------------------------------------------
# Port list expansion (handles arrays)
# ---------------------------------------------------------------------------

def _expand_port_lines(port: PortDef, direction: str) -> list[str]:
    """Expand a single PortDef into one or more Verilog port declaration lines.

    Array ports are flattened to ``name_0, name_1, ...`` because plain Verilog
    does not support array ports.
    """
    type_str = _verilog_type(port, direction)
    if port.is_array and port.array_depth is not None and port.array_depth > 1:
        return [f"    {type_str} {port.name}_{i}" for i in range(port.array_depth)]
    return [f"    {type_str} {port.name}"]


# ---------------------------------------------------------------------------
# Main entry point
# ---------------------------------------------------------------------------

def generate_scaffold(schedule: RTLScheduleDialect) -> str:
    """Generate a Verilog module skeleton from an ``RTLScheduleDialect``.

    The returned string is a syntactically valid (though functionally empty)
    Verilog module that contains:

    * module header with clock, reset, start/done, and data ports
    * internal wire / reg declarations for intermediate nodes
    * pipeline stage comments (when ``total_pipeline_stages > 1``)
    * FSM state register and ``localparam`` definitions
    * BRAM memory declarations
    * a ``TODO`` marker where the LLM should insert datapath logic

    Args:
        schedule: A fully populated ``RTLScheduleDialect`` instance.

    Returns:
        A ``str`` containing the complete Verilog scaffold.
    """
    lines: list[str] = []

    # ---- module header ----------------------------------------------------
    lines.append(f"module {schedule.kernel_name} (")

    # Standard control ports
    port_lines: list[str] = [
        f"    input wire {schedule.clock_name}",
        f"    input wire {schedule.reset_name}",
        "    input wire start",
        "    output reg done",
    ]

    # Data ports
    for port in schedule.input_ports:
        port_lines.extend(_expand_port_lines(port, "input"))
    for port in schedule.output_ports:
        port_lines.extend(_expand_port_lines(port, "output"))

    # Emit port list (last line without trailing comma)
    for i, pl in enumerate(port_lines):
        suffix = "," if i < len(port_lines) - 1 else ""
        lines.append(pl + suffix)

    lines.append(");")
    lines.append("")

    # ---- pipeline stage comment -------------------------------------------
    if schedule.total_pipeline_stages > 1:
        lines.append(f"    // Pipeline: {schedule.total_pipeline_stages} stages, "
                      f"latency = {schedule.total_latency_cycles} cycles")
        lines.append("")

    # ---- FSM state register -----------------------------------------------
    if schedule.fsm_states:
        state_bits = _bits_for_value(len(schedule.fsm_states))
        lines.append(f"    reg [{state_bits - 1}:0] state;")
        for idx, state_name in enumerate(schedule.fsm_states):
            lines.append(f"    localparam {state_name} = {state_bits}'d{idx};")
        lines.append("")

    # ---- internal wire/reg declarations -----------------------------------
    # Collect IDs that are top-level ports so we skip them.
    input_ids = set(schedule.input_nodes)
    output_ids = set(schedule.output_nodes)
    port_names = {p.name for p in schedule.input_ports} | {p.name for p in schedule.output_ports}

    internal_decls: list[str] = []
    for node in schedule.nodes.values():
        if node.node_id in port_names or node.node_id in input_ids or node.node_id in output_ids:
            continue
        if node.op_type == "input":
            continue
        internal_decls.append(_wire_decl(node))

    if internal_decls:
        lines.append("    // ----- internal signals -----")
        lines.extend(internal_decls)
        lines.append("")

    # ---- BRAM declarations ------------------------------------------------
    bram_lines: list[str] = []
    for node in schedule.nodes.values():
        if node.storage_type != "bram":
            continue
        width = node.quant_int_bits + node.quant_frac_bits
        depth = 1 << node.address_width if node.address_width > 0 else max(1, *node.shape)
        if node.bram_banks > 1:
            for bank in range(node.bram_banks):
                bram_lines.append(
                    f"    reg [{width - 1}:0] {node.node_id}_bank{bank} [0:{depth - 1}];"
                )
        else:
            bram_lines.append(
                f"    reg [{width - 1}:0] {node.node_id}_mem [0:{depth - 1}];"
            )

    if bram_lines:
        lines.append("    // ----- BRAM memories -----")
        lines.extend(bram_lines)
        lines.append("")

    # ---- TODO marker ------------------------------------------------------
    lines.append("    // ===== DATAPATH LOGIC (LLM generates below) =====")
    lines.append("")

    # ---- endmodule --------------------------------------------------------
    lines.append("endmodule")
    lines.append("")

    return "\n".join(lines)
