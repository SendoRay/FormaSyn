"""SystemVerilog testbench generator for Verilator simulation.

Produces a self-contained ``_tb.sv`` that drives the DUT with fixed-point
test inputs and captures outputs via ``@@OUTPUT`` markers (same protocol
as the golden testbench so the existing parser can consume results).
"""

from __future__ import annotations

import math
import os
from typing import Optional

from formasyn.ir.rtl_dialect import PortDef, RTLScheduleDialect


def _format_fixed_point(value: float, int_bits: int, frac_bits: int) -> str:
    """Convert a float to a fixed-point integer literal string.

    Scales *value* by ``2 ** frac_bits``, clamps to the representable
    range of a signed ``(int_bits + frac_bits)``-bit integer, and returns
    a Verilog decimal literal of the form ``{total}'d{value}``.

    Negative values are emitted as ``-{total}'d{abs}``.

    Args:
        value: The floating-point number to convert.
        int_bits: Integer part bit-width (including sign bit).
        frac_bits: Fractional part bit-width.

    Returns:
        A Verilog-compatible literal string.
    """
    total = int_bits + frac_bits
    scaled = round(value * (1 << frac_bits))
    lo = -(1 << (total - 1))
    hi = (1 << (total - 1)) - 1
    clamped = max(lo, min(hi, scaled))
    if clamped < 0:
        return f"-{total}'d{abs(clamped)}"
    return f"{total}'d{clamped}"


def _find_node_quant(schedule: RTLScheduleDialect, port_name: str) -> tuple[int, int]:
    """Look up quant_int_bits / quant_frac_bits for a port by name.

    Falls back to scanning all nodes whose ``node_id`` starts with
    *port_name* (to handle the flattened array convention ``name_0``,
    ``name_1``, ...).  If nothing matches, returns ``(8, 8)`` as default.
    """
    if port_name in schedule.nodes:
        n = schedule.nodes[port_name]
        return n.quant_int_bits, n.quant_frac_bits

    # Try to match the base name of an array port.
    for nid, n in schedule.nodes.items():
        if nid == port_name or nid.startswith(port_name + "_"):
            return n.quant_int_bits, n.quant_frac_bits

    # Fallback: scan input_nodes / output_nodes for a match.
    for nid in schedule.input_nodes + schedule.output_nodes:
        if nid == port_name or nid.startswith(port_name):
            if nid in schedule.nodes:
                node = schedule.nodes[nid]
                return node.quant_int_bits, node.quant_frac_bits

    return 8, 8


class VerilogTestbenchGenerator:
    """Generate a SystemVerilog testbench targeting Verilator."""

    def generate_sv_testbench(
        self,
        schedule: RTLScheduleDialect,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
    ) -> str:
        """Generate the full SystemVerilog testbench source.

        Args:
            schedule: A fully populated ``RTLScheduleDialect``.
            test_inputs: Mapping of input port name to list of float values.
            golden_outputs: Mapping of output port name to list of float values
                (used only for sizing; the testbench prints actual DUT outputs).

        Returns:
            A ``str`` containing the complete ``.sv`` source.
        """
        kernel = schedule.kernel_name
        lines: list[str] = []

        lines.append("`timescale 1ns / 1ps")
        lines.append("")
        lines.append(f"module {kernel}_tb;")
        lines.append("")

        # ---- clock generation ------------------------------------------------
        lines.append("    // Clock: 250 MHz (period = 4 ns)")
        lines.append("    reg clk = 0;")
        lines.append("    always #2 clk = ~clk;")
        lines.append("")

        # ---- reset / start signals -------------------------------------------
        lines.append(f"    reg {schedule.reset_name} = 0;")
        lines.append("    reg start = 0;")
        lines.append("    wire done;")
        lines.append("")

        # ---- DUT port signals ------------------------------------------------
        # Inputs: reg;  Outputs: wire.
        input_signal_lines: list[str] = []
        output_signal_lines: list[str] = []

        for port in schedule.input_ports:
            width_spec = f"signed [{port.width - 1}:0] " if port.width > 1 else ""
            if port.is_array and port.array_depth is not None and port.array_depth > 1:
                for i in range(port.array_depth):
                    input_signal_lines.append(f"    reg {width_spec}{port.name}_{i};")
            else:
                input_signal_lines.append(f"    reg {width_spec}{port.name};")

        for port in schedule.output_ports:
            width_spec = f"signed [{port.width - 1}:0] " if port.width > 1 else ""
            if port.is_array and port.array_depth is not None and port.array_depth > 1:
                for i in range(port.array_depth):
                    output_signal_lines.append(f"    wire {width_spec}{port.name}_{i};")
            else:
                output_signal_lines.append(f"    wire {width_spec}{port.name};")

        if input_signal_lines:
            lines.append("    // ----- DUT inputs -----")
            lines.extend(input_signal_lines)
            lines.append("")
        if output_signal_lines:
            lines.append("    // ----- DUT outputs -----")
            lines.extend(output_signal_lines)
            lines.append("")

        # ---- DUT instantiation -----------------------------------------------
        lines.append(f"    // ----- DUT instantiation -----")
        lines.append(f"    {kernel} dut (")

        conn_lines: list[str] = []
        conn_lines.append(f"        .{schedule.clock_name}({schedule.clock_name})")
        conn_lines.append(f"        .{schedule.reset_name}({schedule.reset_name})")
        conn_lines.append("        .start(start)")
        conn_lines.append("        .done(done)")

        for port in schedule.input_ports:
            if port.is_array and port.array_depth is not None and port.array_depth > 1:
                for i in range(port.array_depth):
                    conn_lines.append(f"        .{port.name}_{i}({port.name}_{i})")
            else:
                conn_lines.append(f"        .{port.name}({port.name})")

        for port in schedule.output_ports:
            if port.is_array and port.array_depth is not None and port.array_depth > 1:
                for i in range(port.array_depth):
                    conn_lines.append(f"        .{port.name}_{i}({port.name}_{i})")
            else:
                conn_lines.append(f"        .{port.name}({port.name})")

        for i, cl in enumerate(conn_lines):
            suffix = "," if i < len(conn_lines) - 1 else ""
            lines.append(cl + suffix)

        lines.append("    );")
        lines.append("")

        # ---- initial block ---------------------------------------------------
        lines.append("    initial begin")

        # Reset sequence
        lines.append(f"        {schedule.reset_name} = 0;")
        lines.append("        start = 0;")
        # Initialize all input signals to 0
        for port in schedule.input_ports:
            if port.is_array and port.array_depth is not None and port.array_depth > 1:
                for i in range(port.array_depth):
                    lines.append(f"        {port.name}_{i} = 0;")
            else:
                lines.append(f"        {port.name} = 0;")
        lines.append("")
        lines.append("        // Reset sequence")
        lines.append("        #20;")
        lines.append(f"        {schedule.reset_name} = 1;")
        lines.append("        #10;")
        lines.append("")

        # Apply test inputs
        lines.append("        // Apply test inputs")
        for port in schedule.input_ports:
            int_bits, frac_bits = _find_node_quant(schedule, port.name)
            values = test_inputs.get(port.name, [])
            if port.is_array and port.array_depth is not None and port.array_depth > 1:
                for i in range(port.array_depth):
                    val = values[i] if i < len(values) else 0.0
                    literal = _format_fixed_point(val, int_bits, frac_bits)
                    lines.append(f"        {port.name}_{i} = {literal};")
            else:
                val = values[0] if values else 0.0
                literal = _format_fixed_point(val, int_bits, frac_bits)
                lines.append(f"        {port.name} = {literal};")
        lines.append("")

        # Assert start for one cycle
        lines.append("        // Assert start for one cycle")
        lines.append("        @(posedge clk);")
        lines.append("        start = 1;")
        lines.append("        @(posedge clk);")
        lines.append("        start = 0;")
        lines.append("")

        # Wait for completion
        wait_cycles = schedule.total_latency_cycles + 10
        lines.append(f"        // Wait for completion ({schedule.total_latency_cycles} + 10 margin)")
        lines.append(f"        repeat ({wait_cycles}) @(posedge clk);")
        lines.append("")

        # Print outputs with @@OUTPUT markers
        lines.append("        // Capture outputs")
        for port in schedule.output_ports:
            if port.is_array and port.array_depth is not None and port.array_depth > 1:
                for i in range(port.array_depth):
                    lines.append(
                        f'        $display("@@OUTPUT {port.name}[%0d] = %0d", {i}, {port.name}_{i});'
                    )
            else:
                lines.append(
                    f'        $display("@@OUTPUT {port.name} = %0d", {port.name});'
                )
        lines.append("")

        lines.append("        $finish;")
        lines.append("    end")
        lines.append("")
        lines.append("endmodule")
        lines.append("")

        return "\n".join(lines)

    def write_testbench(
        self,
        schedule: RTLScheduleDialect,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        output_dir: str,
    ) -> str:
        """Generate and write a testbench file.

        Args:
            schedule: A fully populated ``RTLScheduleDialect``.
            test_inputs: Mapping of input port name to list of float values.
            golden_outputs: Mapping of output port name to list of float values.
            output_dir: Directory to write the ``.sv`` file into.

        Returns:
            The absolute path of the written file.
        """
        content = self.generate_sv_testbench(schedule, test_inputs, golden_outputs)
        os.makedirs(output_dir, exist_ok=True)
        path = os.path.join(output_dir, f"{schedule.kernel_name}_tb.sv")
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        return path
