"""HLS Code Generator: HLSScheduleDialect -> synthesizable Vitis HLS C++ code.

Translates the fully-scheduled IR into a .cpp / .h pair that Vitis HLS can
directly synthesise.  The generator is stateless; every method is a pure
function over the dialect data.
"""

from __future__ import annotations

import logging
import re
from typing import Optional

import networkx as nx

from FormaSyn.ir.schedule_dialect import HLSScheduleDialect, ScheduleNode

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

_FILE_BANNER = (
    "// [FormaSyn Generated Code] variant_id={variant_id}\n"
    "// DO NOT EDIT — regenerate via FormaSyn\n"
)

_INCLUDES = (
    "#include <ap_int.h>\n"
    "#include <ap_fixed.h>\n"
    "#include <hls_stream.h>\n"
    "#include <algorithm>\n"
)

_GUARD_PREFIX = "FORMASYN_{name}_H"


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------


class HLSCodeGenerator:
    """Translates HLSScheduleDialect into synthesizable Vitis HLS C++ code.

    Usage::

        gen = HLSCodeGenerator()
        cpp_code = gen.generate(schedule, function_name="ldpc_cnu")
        hdr_code = gen.generate_header(schedule, function_name="ldpc_cnu")
    """

    # -- public methods -------------------------------------------------------

    def generate(
        self,
        schedule: HLSScheduleDialect,
        function_name: str = "kernel",
    ) -> str:
        """Generate a complete synthesizable .cpp file.

        Args:
            schedule: Fully-scheduled HLS IR including all pragma parameters.
            function_name: Name of the top-level HLS kernel function.

        Returns:
            Complete C++ source string ready for Vitis HLS synthesis.
        """
        sorted_ids = self._topo_sort(schedule)

        parts: list[str] = [
            _FILE_BANNER.format(variant_id=schedule.variant_id),
            _INCLUDES,
            self._collect_typedefs(schedule),
            self._gen_function_signature(schedule, function_name) + " {",
            self._gen_function_body(schedule, sorted_ids),
            "}",
            "",
        ]
        code = "\n".join(parts)
        logger.info(
            "Generated HLS C++ for variant '%s' (%d lines)",
            schedule.variant_id,
            code.count("\n"),
        )
        return code

    def generate_header(
        self,
        schedule: HLSScheduleDialect,
        function_name: str = "kernel",
    ) -> str:
        """Generate a corresponding .h file (typedefs + function declaration).

        Args:
            schedule: The same HLSScheduleDialect used for generate().
            function_name: Must match the name passed to generate().

        Returns:
            Complete C++ header string.
        """
        guard = _GUARD_PREFIX.format(name=function_name.upper())
        parts: list[str] = [
            f"#ifndef {guard}",
            f"#define {guard}",
            "",
            _INCLUDES.rstrip("\n"),
            "",
            "// Type definitions",
            self._collect_typedefs(schedule).rstrip("\n"),
            "",
            "// Function declaration",
            self._gen_function_signature(schedule, function_name) + ";",
            "",
            f"#endif  // {guard}",
            "",
        ]
        return "\n".join(parts)

    # -- topological sort -----------------------------------------------------

    def _topo_sort(self, schedule: HLSScheduleDialect) -> list[str]:
        """Return node IDs in topological order using the dependency graph."""
        dag: nx.DiGraph = nx.DiGraph()
        for nid, node in schedule.nodes.items():
            dag.add_node(nid)
            for parent_id in node.input_nodes:
                if parent_id in schedule.nodes:
                    dag.add_edge(parent_id, nid)
        return list(nx.topological_sort(dag))

    # -- typedef collection ---------------------------------------------------

    def _collect_typedefs(self, schedule: HLSScheduleDialect) -> str:
        """Emit one typedef per unique data_type found in the schedule."""
        seen: dict[str, str] = {}  # raw_type -> alias
        for node in schedule.nodes.values():
            raw = node.data_type
            if raw not in seen:
                seen[raw] = self._dtype_to_alias(raw)

        lines = ["// Type definitions"]
        for raw, alias in seen.items():
            hls_type = self._dtype_to_hls(raw)
            if hls_type != alias:
                lines.append(f"typedef {hls_type} {alias};")
        return "\n".join(lines) + "\n"

    def _dtype_to_alias(self, data_type: str) -> str:
        """Convert a data_type string to a valid C++ identifier alias.

        Examples:
            ``ap_int<8>``     → ``ap_int_8_t``
            ``ap_fixed<16,4>``→ ``ap_fixed_16_4_t``
            ``float64``       → ``double``
        """
        if data_type == "float64":
            return "double"
        # Replace <, >, comma and spaces with underscores, then strip trailing _
        alias = re.sub(r"[<>, ]+", "_", data_type).rstrip("_")
        return alias + "_t"

    def _dtype_to_hls(self, data_type: str) -> str:
        """Map a FormaSyn data_type string to the HLS C++ type name."""
        if data_type == "float64":
            return "double"
        return data_type  # ap_int<W> and ap_fixed<W,I> are used verbatim

    # -- function signature ---------------------------------------------------

    def _gen_function_signature(
        self,
        schedule: HLSScheduleDialect,
        function_name: str,
    ) -> str:
        """Build the ``void func(params)`` signature string (no braces).

        When any node has irregular memory access, CSR pointer parameters
        (``const int* row_ptr, const int* col_idx``) are appended so that
        address-mapping snippets from the MLC backend can reference them.
        """
        params: list[str] = []

        for nid in schedule.input_nodes:
            node = schedule.nodes[nid]
            alias = self._dtype_to_alias(node.data_type)
            size = node.shape[0] if node.shape else 1
            params.append(f"    {alias} {nid}[{size}]")

        for nid in schedule.output_nodes:
            node = schedule.nodes[nid]
            alias = self._dtype_to_alias(node.data_type)
            size = node.shape[0] if node.shape else 1
            params.append(f"    {alias} {nid}[{size}]")

        needs_csr = any(
            n.is_irregular_access for n in schedule.nodes.values()
        )
        if needs_csr:
            params.append("    const int* row_ptr")
            params.append("    const int* col_idx")

        param_str = ",\n".join(params)
        return f"void {function_name}(\n{param_str}\n)"

    # -- function body --------------------------------------------------------

    def _gen_function_body(
        self,
        schedule: HLSScheduleDialect,
        sorted_ids: list[str],
    ) -> str:
        """Assemble top pragmas + variable declarations + node blocks."""
        sections: list[str] = []

        sections.append(self._gen_top_pragmas(schedule))
        sections.append(self._gen_var_declarations(schedule))

        node_blocks: list[str] = []
        for nid in sorted_ids:
            node = schedule.nodes[nid]
            if node.op_type == "input":
                continue
            block = self._gen_node_block(nid, node, schedule)
            if block:
                node_blocks.append(block)

        sections.append("\n".join(node_blocks))
        return "\n".join(s for s in sections if s)

    def _gen_top_pragmas(self, schedule: HLSScheduleDialect) -> str:
        """Emit top-level PIPELINE and ARRAY_PARTITION pragmas."""
        lines = [f"    #pragma HLS PIPELINE II={schedule.expected_ii}"]

        for nid in schedule.input_nodes:
            node = schedule.nodes[nid]
            pt = node.array_partition_type
            if pt != "none":
                lines.append(
                    f"    #pragma HLS ARRAY_PARTITION variable={nid} {pt}"
                )

        for nid in schedule.output_nodes:
            node = schedule.nodes[nid]
            pt = node.array_partition_type
            if pt != "none":
                lines.append(
                    f"    #pragma HLS ARRAY_PARTITION variable={nid} {pt}"
                )
            else:
                lines.append(
                    f"    #pragma HLS ARRAY_PARTITION variable={nid} complete"
                )

        return "\n".join(lines) + "\n"

    def _gen_var_declarations(self, schedule: HLSScheduleDialect) -> str:
        """Declare intermediate (non-input, non-output) node arrays."""
        io_ids = set(schedule.input_nodes) | set(schedule.output_nodes)
        lines: list[str] = []
        lines.append("    // Intermediate variable declarations")
        for nid, node in schedule.nodes.items():
            if nid in io_ids:
                continue
            alias = self._dtype_to_alias(node.data_type)
            size = node.shape[0] if node.shape else 1
            lines.append(f"    {alias} {nid}[{size}];")
            pt = node.array_partition_type
            if pt not in ("none", ""):
                lines.append(
                    f"    #pragma HLS ARRAY_PARTITION variable={nid} {pt}"
                )
        return "\n".join(lines) + "\n"

    # -- per-node code blocks -------------------------------------------------

    def _gen_node_block(
        self,
        node_id: str,
        node: ScheduleNode,
        schedule: HLSScheduleDialect,
    ) -> str:
        """Dispatch code generation by op_type."""
        comment = f"    // [FormaSyn Node: {node_id} — {node.op_type}"
        if node.op_detail:
            func_or_op = node.op_detail.get("func") or node.op_detail.get("op", "")
            if func_or_op:
                comment += f"/{func_or_op}"
        comment += "]"

        if node.op_type == "map":
            body = self._gen_map_block(node_id, node, schedule)
        elif node.op_type == "reduce":
            body = self._gen_reduce_block(node_id, node, schedule)
        elif node.op_type in ("delay", "shift_reg"):
            body = self._gen_shift_reg_block(node_id, node, schedule)
        elif node.op_type == "message_pass":
            body = self._gen_message_pass_block(node_id, node, schedule)
        else:
            body = f"    // [FormaSyn] Unsupported op_type: {node.op_type}"

        return comment + "\n" + body

    # -- map node -------------------------------------------------------------

    def _gen_map_block(
        self,
        node_id: str,
        node: ScheduleNode,
        schedule: HLSScheduleDialect,
    ) -> str:
        """Generate element-wise map loop."""
        func = node.op_detail.get("func", "identity")
        size = node.shape[0] if node.shape else 1
        input_id = node.input_nodes[0] if node.input_nodes else "input_0"
        alias = self._dtype_to_alias(node.data_type)

        fully_unrolled = node.unroll_factor >= size
        pragma = (
            "        #pragma HLS UNROLL"
            if fully_unrolled
            else "        #pragma HLS PIPELINE"
        )

        body_expr = self._map_func_expr(func, input_id, alias)
        lines = [
            f"    for (int i = 0; i < {size}; i++) {{",
            pragma,
            f"        {node_id}[i] = {body_expr};",
            "    }",
        ]
        return "\n".join(lines)

    def _map_func_expr(self, func: str, input_id: str, alias: str) -> str:
        """Return the RHS expression for a map function."""
        if func == "sign":
            return f"({input_id}[i] >= 0) ? ({alias})1 : ({alias})-1"
        if func == "abs":
            return f"({input_id}[i] >= 0) ? {input_id}[i] : ({alias})(-{input_id}[i])"
        if func == "negate":
            return f"({alias})(-{input_id}[i])"
        if func == "square":
            return f"({alias})({input_id}[i] * {input_id}[i])"
        # generic: identity / passthrough
        return f"({alias}){input_id}[i]"

    # -- reduce node ----------------------------------------------------------

    def _gen_reduce_block(
        self,
        node_id: str,
        node: ScheduleNode,
        schedule: HLSScheduleDialect,
    ) -> str:
        """Dispatch reduce generation based on op and approx_method."""
        op = node.op_detail.get("op", "sum")

        if op == "min" and node.approx_method == "min_sum":
            return self._gen_min_sum_value_reuse(node_id, node, schedule)
        if op == "xor":
            return self._gen_xor_reduce_block(node_id, node, schedule)
        return self._gen_generic_reduce_block(node_id, node, schedule)

    def _gen_min_sum_value_reuse(
        self,
        node_id: str,
        node: ScheduleNode,
        schedule: HLSScheduleDialect,
    ) -> str:
        """Generate the Min-Sum Value Reuse Pattern (key CNU optimisation).

        Finds the sign array and total_sign variable by inspecting sibling
        nodes in the schedule:
        - sign array  : first map node with func='sign'
        - total_sign  : first reduce node with op='xor'
        """
        mag_id = node.input_nodes[0] if node.input_nodes else "mag"
        mag_node = schedule.nodes.get(mag_id)
        dc = mag_node.shape[0] if mag_node and mag_node.shape else 8

        mag_alias = self._dtype_to_alias(node.data_type)
        # MAX_VAL based on bit-width from data_type (ap_int<7> → 127)
        max_val = self._max_val_for_type(node.data_type)

        sign_id = self._find_sign_node(schedule)
        xor_id = self._find_xor_reduce_node(schedule)
        total_sign_expr = f"{xor_id}[0]" if xor_id else "0"

        lines = [
            "    // [FormaSyn] Min-Sum Value Reuse Pattern",
            f"    {mag_alias} min1 = {max_val}, min2 = {max_val};",
            "    int   min1_idx = -1;",
            f"    for (int i = 0; i < {dc}; i++) {{",
            "        #pragma HLS UNROLL",
            f"        if ({mag_id}[i] < min1) "
            f"{{ min2 = min1; min1 = {mag_id}[i]; min1_idx = i; }}",
            f"        else if ({mag_id}[i] < min2) {{ min2 = {mag_id}[i]; }}",
            "    }",
            "    // Output reconstruction with scale approximation (0.75 ≈ 1 - (1>>2))",
            f"    for (int i = 0; i < {dc}; i++) {{",
            "        #pragma HLS UNROLL",
            f"        ap_uint<7> out_mag = (i == min1_idx) ? min2 : min1;",
            "        out_mag = out_mag - (out_mag >> 2);  // scale * 0.75",
        ]

        if sign_id and xor_id:
            lines.append(
                f"        {node_id}[i] = ({sign_id}[i] ^ {total_sign_expr}) "
                f"? ({mag_alias})(-out_mag) : ({mag_alias})(out_mag);"
            )
        else:
            lines.append(
                f"        {node_id}[i] = ({mag_alias})(out_mag);"
            )
        lines.append("    }")
        return "\n".join(lines)

    def _gen_xor_reduce_block(
        self,
        node_id: str,
        node: ScheduleNode,
        schedule: HLSScheduleDialect,
    ) -> str:
        """Generate XOR reduction loop, injecting address_mapping_code if present."""
        input_id = node.input_nodes[0] if node.input_nodes else "input_0"
        input_node = schedule.nodes.get(input_id)
        dc = input_node.shape[0] if input_node and input_node.shape else 8
        alias = self._dtype_to_alias(node.data_type)

        addr_code = node.address_mapping_code
        index_expr = "addr" if addr_code else "i"

        lines = [
            f"    {alias} {node_id}_acc = 0;",
            f"    for (int i = 0; i < {dc}; i++) {{",
            "        #pragma HLS UNROLL",
        ]
        if addr_code:
            for addr_line in addr_code.strip().splitlines():
                lines.append(f"        {addr_line.strip()}")
        lines.append(f"        {node_id}_acc ^= {input_id}[{index_expr}];")
        lines.append("    }")
        lines.append(f"    {node_id}[0] = {node_id}_acc;")
        return "\n".join(lines)

    def _gen_generic_reduce_block(
        self,
        node_id: str,
        node: ScheduleNode,
        schedule: HLSScheduleDialect,
    ) -> str:
        """Generate a generic reduction loop (sum / max / min without min_sum)."""
        op = node.op_detail.get("op", "sum")
        input_id = node.input_nodes[0] if node.input_nodes else "input_0"
        input_node = schedule.nodes.get(input_id)
        dc = input_node.shape[0] if input_node and input_node.shape else 8
        alias = self._dtype_to_alias(node.data_type)
        addr_code = node.address_mapping_code
        index_expr = "addr" if addr_code else "i"

        op_map = {"sum": "+=", "max": " = std::max(acc, ", "min": " = std::min(acc, "}
        init_map = {"sum": "0", "max": self._min_val_for_type(node.data_type),
                    "min": self._max_val_for_type(node.data_type)}

        op_sym = op_map.get(op, "+=")
        init_val = init_map.get(op, "0")

        lines = [
            f"    {alias} {node_id}_acc = {init_val};",
            f"    for (int i = 0; i < {dc}; i++) {{",
            "        #pragma HLS UNROLL",
        ]
        if addr_code:
            for addr_line in addr_code.strip().splitlines():
                lines.append(f"        {addr_line.strip()}")
        if op in ("max", "min"):
            lines.append(
                f"        {node_id}_acc = std::{op}({node_id}_acc, "
                f"{input_id}[{index_expr}]);"
            )
        else:
            lines.append(
                f"        {node_id}_acc {op_sym} {input_id}[{index_expr}];"
            )
        lines.append("    }")
        lines.append(f"    {node_id}[0] = {node_id}_acc;")
        return "\n".join(lines)

    # -- delay / shift_reg node -----------------------------------------------

    def _gen_shift_reg_block(
        self,
        node_id: str,
        node: ScheduleNode,
        schedule: HLSScheduleDialect,
    ) -> str:
        """Generate a shift-register pipeline."""
        delay = node.op_detail.get("delay", node.op_detail.get("length", 1))
        input_id = node.input_nodes[0] if node.input_nodes else "input_0"
        alias = self._dtype_to_alias(node.data_type)
        lines = [
            f"    static {alias} {node_id}_sreg[{delay}];",
            f"    #pragma HLS ARRAY_PARTITION variable={node_id}_sreg complete",
            f"    for (int i = {delay} - 1; i > 0; i--) {{",
            "        #pragma HLS UNROLL",
            f"        {node_id}_sreg[i] = {node_id}_sreg[i - 1];",
            "    }",
            f"    {node_id}_sreg[0] = {input_id}[0];",
            f"    {node_id}[0] = {node_id}_sreg[{delay} - 1];",
        ]
        return "\n".join(lines)

    # -- message_pass node ----------------------------------------------------

    def _gen_message_pass_block(
        self,
        node_id: str,
        node: ScheduleNode,
        schedule: HLSScheduleDialect,
    ) -> str:
        """Generate a message-passing loop (graph algorithm)."""
        input_id = node.input_nodes[0] if node.input_nodes else "input_0"
        input_node = schedule.nodes.get(input_id)
        dc = input_node.shape[0] if input_node and input_node.shape else 8
        alias = self._dtype_to_alias(node.data_type)
        addr_code = node.address_mapping_code
        index_expr = "addr" if addr_code else "i"

        lines = [
            f"    for (int i = 0; i < {dc}; i++) {{",
            "        #pragma HLS PIPELINE",
        ]
        if addr_code:
            for addr_line in addr_code.strip().splitlines():
                lines.append(f"        {addr_line.strip()}")
        lines.append(
            f"        {node_id}[{index_expr}] = {input_id}[{index_expr}];"
        )
        lines.append("    }")
        return "\n".join(lines)

    # -- helper utilities -----------------------------------------------------

    def _find_sign_node(self, schedule: HLSScheduleDialect) -> Optional[str]:
        """Return the node_id of the first map/sign node in the schedule."""
        for nid, node in schedule.nodes.items():
            if node.op_type == "map" and node.op_detail.get("func") == "sign":
                return nid
        return None

    def _find_xor_reduce_node(self, schedule: HLSScheduleDialect) -> Optional[str]:
        """Return the node_id of the first reduce/xor node in the schedule."""
        for nid, node in schedule.nodes.items():
            if node.op_type == "reduce" and node.op_detail.get("op") == "xor":
                return nid
        return None

    def _max_val_for_type(self, data_type: str) -> str:
        """Return a C++ MAX constant string for the given data_type."""
        match = re.search(r"ap_(?:u?int|fixed)<(\d+)", data_type)
        if match:
            bits = int(match.group(1))
            return str((1 << (bits - 1)) - 1)
        return "32767"

    def _min_val_for_type(self, data_type: str) -> str:
        """Return a C++ MIN constant string for the given data_type."""
        match = re.search(r"ap_(?:u?int|fixed)<(\d+)", data_type)
        if match:
            bits = int(match.group(1))
            return str(-(1 << (bits - 1)))
        return "-32768"
