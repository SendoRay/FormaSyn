"""Golden Model Generator: MathDialect -> float64 serial C++ reference code.

Generates a naive, unoptimised C++ program that computes the exact
floating-point results for a given algorithm kernel.  The output serves as
the ground-truth reference for quantisation analysis and BER verification.
"""

from __future__ import annotations

import logging
import os
import platform
import subprocess
import tempfile
from typing import Optional

import networkx as nx

from FormaSyn.ir.math_dialect import MathDialect, MathNode

logger = logging.getLogger(__name__)


class GoldenCompileError(Exception):
    """Raised when g++ fails to compile the generated golden C++ code.

    Attributes:
        stderr: Raw stderr output from the compiler.
    """

    def __init__(self, stderr: str) -> None:
        self.stderr = stderr
        super().__init__(f"g++ compilation failed:\n{stderr}")


class GoldenModelGenerator:
    """Generates and runs float64 serial C++ golden models from MathDialect."""

    _FILE_HEADER = (
        "// [FormaSyn Golden Model] Auto-generated float64 reference."
        " DO NOT EDIT.\n"
        "#include <cmath>\n"
        "#include <algorithm>\n"
        "#include <cstdio>\n"
        "#include <vector>\n"
        "#include <cstdlib>\n\n"
    )

    # -- public API -----------------------------------------------------------

    def generate(
        self,
        dialect: MathDialect,
        function_name: str = "golden",
    ) -> str:
        """Generate float64 C++ source code for the given MathDialect.

        Args:
            dialect: Math Dialect IR describing the algorithm kernel.
            function_name: Name of the generated C function.

        Returns:
            Complete C++ source string (without ``main``).
        """
        dag = dialect.to_dag()
        sorted_ids = list(nx.topological_sort(dag))

        needs_csr = any(
            n.is_irregular_access for n in dialect.nodes.values()
        )

        params = self._build_params(dialect, needs_csr)
        declarations = self._build_declarations(dialect, sorted_ids)
        body_lines = self._build_body(dialect, sorted_ids)

        lines = [self._FILE_HEADER]
        lines.append(f"void {function_name}(")
        lines.append(f"    {(',{nl}    '.format(nl=chr(10))).join(params)}")
        lines.append(") {")
        lines.extend(f"    {d}" for d in declarations)
        if declarations:
            lines.append("")
        lines.extend(f"    {b}" for b in body_lines)
        lines.append("}")
        lines.append("")

        code = "\n".join(lines)
        logger.info(
            "Generated golden C++ for '%s' (%d lines)",
            dialect.kernel_name,
            code.count("\n"),
        )
        return code

    def compile_and_run(
        self,
        cpp_code: str,
        input_data: dict[str, list[float]],
        dialect: Optional[MathDialect] = None,
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, list[float]]:
        """Compile and run the golden model with concrete input data.

        Args:
            cpp_code: C++ source from ``generate()``.
            input_data: Mapping of input node_id to float arrays.
            dialect: MathDialect used for output shape inference.  When
                *None*, output sizes are inferred from input sizes.
            csr_data: Optional CSR arrays (``row_ptr``, ``col_idx``).

        Returns:
            Mapping of output node_id to result float arrays.

        Raises:
            GoldenCompileError: If g++ compilation fails.
        """
        output_info = self._infer_outputs(cpp_code, input_data, dialect)

        if csr_data is not None and dialect is not None:
            num_rows = len(csr_data["row_ptr"]) - 1
            for nid in list(output_info):
                if nid in dialect.nodes and dialect.nodes[nid].is_irregular_access:
                    output_info[nid] = num_rows

        main_code = self._generate_main(
            cpp_code, input_data, output_info, csr_data,
        )
        return self._compile_run(main_code)

    # -- parameter / declaration builders ------------------------------------

    def _build_params(
        self,
        dialect: MathDialect,
        needs_csr: bool,
    ) -> list[str]:
        """Build the C++ function parameter list."""
        params: list[str] = []
        for nid in dialect.input_nodes:
            node = dialect.nodes[nid]
            size = self._flat_size(node)
            params.append(f"double* {nid}, int size_{nid}")

        for nid in dialect.output_nodes:
            node = dialect.nodes[nid]
            params.append(f"double* {nid}_out, int size_{nid}_out")

        if needs_csr:
            params.append("int* row_ptr, int row_ptr_len")
            params.append("int* col_idx, int col_idx_len")

        return params

    def _build_declarations(
        self,
        dialect: MathDialect,
        sorted_ids: list[str],
    ) -> list[str]:
        """Declare intermediate double arrays for non-input, non-output nodes."""
        decls: list[str] = []
        for nid in sorted_ids:
            if nid in dialect.input_nodes:
                continue
            if nid in dialect.output_nodes:
                continue
            node = dialect.nodes[nid]
            size = self._flat_size(node)
            decls.append(f"double {nid}[{size}];")
        return decls

    # -- body code generation ------------------------------------------------

    def _build_body(
        self,
        dialect: MathDialect,
        sorted_ids: list[str],
    ) -> list[str]:
        """Generate the computation body for each node in topological order."""
        lines: list[str] = []
        for nid in sorted_ids:
            node = dialect.nodes[nid]
            if node.op_type == "input":
                continue

            dest = f"{nid}_out" if nid in dialect.output_nodes else nid
            src_nodes = [dialect.nodes[s] for s in node.input_nodes]

            emitter = self._EMITTERS.get(node.op_type)
            if emitter is None:
                logger.warning("Unknown op_type '%s' for node '%s'", node.op_type, nid)
                continue

            snippet = emitter(self, node, dest, src_nodes, dialect)
            lines.extend(snippet)

        return lines

    # -- per-operator emitters -----------------------------------------------

    def _emit_map(
        self,
        node: MathNode,
        dest: str,
        sources: list[MathNode],
        dialect: MathDialect,
    ) -> list[str]:
        src = sources[0]
        src_name = self._src_ref(src, dialect)
        size = self._flat_size(node)
        func = node.op_detail.get("func", "")
        if func == "add":
            params = node.op_detail.get("func_params", {})
            other_expr = "0.0"
            if len(sources) > 1:
                other_expr = f"{self._src_ref(sources[1], dialect)}[i]"
            elif isinstance(params.get("other_ref"), str):
                other_expr = f"{params['other_ref']}[i]"
            elif "coeff" in params:
                other_expr = str(params["coeff"])
            expr = f"{src_name}[i] + {other_expr}"
        else:
            expr = self._map_expr(func, node.op_detail, f"{src_name}[i]")

        return [
            f"for (int i = 0; i < {size}; i++) {{",
            f"    {dest}[i] = {expr};",
            "}",
        ]

    def _emit_reduce(
        self,
        node: MathNode,
        dest: str,
        sources: list[MathNode],
        dialect: MathDialect,
    ) -> list[str]:
        op = node.op_detail.get("op", "add")
        domain_kind = node.op_detail.get("domain_kind", "all")

        if domain_kind == "neighbors":
            return self._emit_reduce_neighbors(node, dest, sources, dialect, op)

        return self._emit_reduce_all(node, dest, sources, dialect, op)

    def _emit_reduce_all(
        self,
        node: MathNode,
        dest: str,
        sources: list[MathNode],
        dialect: MathDialect,
        op: str,
    ) -> list[str]:
        src = sources[0]
        src_name = self._src_ref(src, dialect)
        size = self._flat_size(src)
        lines: list[str] = []

        if op == "add":
            lines.append(f"{dest}[0] = 0.0;")
            lines.append(f"for (int i = 0; i < {size}; i++) {{")
            lines.append(f"    {dest}[0] += {src_name}[i];")
            lines.append("}")
        elif op == "mul":
            lines.append(f"{dest}[0] = 1.0;")
            lines.append(f"for (int i = 0; i < {size}; i++) {{")
            lines.append(f"    {dest}[0] *= {src_name}[i];")
            lines.append("}")
        elif op == "min":
            lines.append(f"{dest}[0] = {src_name}[0];")
            lines.append(f"int {dest}_min_idx = 0;")
            lines.append(f"for (int i = 1; i < {size}; i++) {{")
            lines.append(f"    if ({src_name}[i] < {dest}[0]) {{")
            lines.append(f"        {dest}[0] = {src_name}[i];")
            lines.append(f"        {dest}_min_idx = i;")
            lines.append("    }")
            lines.append("}")
        elif op == "max":
            lines.append(f"{dest}[0] = {src_name}[0];")
            lines.append(f"for (int i = 1; i < {size}; i++) {{")
            lines.append(f"    if ({src_name}[i] > {dest}[0]) {{")
            lines.append(f"        {dest}[0] = {src_name}[i];")
            lines.append("    }")
            lines.append("}")
        elif op == "xor":
            lines.append(f"int {dest}_xor_acc = ({src_name}[0] < 0) ? 1 : 0;")
            lines.append(f"for (int i = 1; i < {size}; i++) {{")
            lines.append(f"    {dest}_xor_acc ^= ({src_name}[i] < 0) ? 1 : 0;")
            lines.append("}")
            lines.append(f"{dest}[0] = ({dest}_xor_acc == 1) ? -1.0 : 1.0;")

        return lines

    def _emit_reduce_neighbors(
        self,
        node: MathNode,
        dest: str,
        sources: list[MathNode],
        dialect: MathDialect,
        op: str,
    ) -> list[str]:
        """Generate CSR-based neighbor reduction loop."""
        src = sources[0]
        src_name = self._src_ref(src, dialect)
        src_size = self._flat_size(src)
        exclude_self = node.op_detail.get("exclude_self", False)

        lines: list[str] = [
            "for (int row = 0; row < (row_ptr_len - 1); row++) {",
        ]

        if op == "add":
            lines.append(f"    double acc = 0.0;")
        elif op == "mul":
            lines.append(f"    double acc = 1.0;")
        elif op == "min":
            lines.append(f"    double acc = 1e300;")
            lines.append(f"    int best_idx = -1;")
        elif op == "max":
            lines.append(f"    double acc = -1e300;")
        elif op == "xor":
            lines.append(f"    int xor_acc = 0;")

        lines.append(f"    for (int idx = row_ptr[row]; idx < row_ptr[row+1]; idx++) {{")
        lines.append(f"        int col = col_idx[idx];")

        if exclude_self:
            lines.append(f"        if (col == row) continue;")

        if op == "add":
            lines.append(f"        acc += {src_name}[col];")
        elif op == "mul":
            lines.append(f"        acc *= {src_name}[col];")
        elif op == "min":
            lines.append(f"        if ({src_name}[col] < acc) {{")
            lines.append(f"            acc = {src_name}[col];")
            lines.append(f"            best_idx = col;")
            lines.append(f"        }}")
        elif op == "max":
            lines.append(f"        if ({src_name}[col] > acc) acc = {src_name}[col];")
        elif op == "xor":
            lines.append(f"        xor_acc ^= ({src_name}[col] < 0) ? 1 : 0;")

        lines.append(f"    }}")

        if op == "xor":
            lines.append(f"    {dest}[row] = (xor_acc == 1) ? -1.0 : 1.0;")
        else:
            lines.append(f"    {dest}[row] = acc;")

        lines.append("}")
        return lines

    def _emit_delay(
        self,
        node: MathNode,
        dest: str,
        sources: list[MathNode],
        dialect: MathDialect,
    ) -> list[str]:
        src = sources[0]
        src_name = self._src_ref(src, dialect)
        size = self._flat_size(node)
        return [
            f"for (int i = 0; i < {size}; i++) {{",
            f"    {dest}[i] = {src_name}[i];",
            "}",
        ]

    def _emit_shift_reg(
        self,
        node: MathNode,
        dest: str,
        sources: list[MathNode],
        dialect: MathDialect,
    ) -> list[str]:
        src = sources[0]
        src_name = self._src_ref(src, dialect)
        taps = node.op_detail.get("taps", [])
        lines: list[str] = []
        for i, tap in enumerate(taps):
            lines.append(f"{dest}[{i}] = {src_name}[{tap}];")
        return lines

    def _emit_message_pass(
        self,
        node: MathNode,
        dest: str,
        sources: list[MathNode],
        dialect: MathDialect,
    ) -> list[str]:
        src = sources[0]
        src_name = self._src_ref(src, dialect)
        src_size = self._flat_size(src)

        fwd_map_func = node.op_detail.get("forward_map_func", "")
        fwd_reduce_op = node.op_detail.get("forward_reduce_op", "add")

        inner_expr = self._map_expr(fwd_map_func, node.op_detail, f"{src_name}[col]") if fwd_map_func else f"{src_name}[col]"

        lines: list[str] = [
            f"for (int row = 0; row < size_{dialect.input_nodes[0]}; row++) {{",
        ]

        if fwd_reduce_op == "add":
            lines.append("    double acc = 0.0;")
        elif fwd_reduce_op == "min":
            lines.append("    double acc = 1e300;")
        elif fwd_reduce_op == "xor":
            lines.append("    int xor_acc = 0;")
        else:
            lines.append("    double acc = 0.0;")

        lines.append("    for (int idx = row_ptr[row]; idx < row_ptr[row+1]; idx++) {")
        lines.append("        int col = col_idx[idx];")

        if fwd_reduce_op == "xor":
            lines.append(f"        xor_acc ^= ({inner_expr} < 0) ? 1 : 0;")
        elif fwd_reduce_op == "min":
            lines.append(f"        double val = {inner_expr};")
            lines.append(f"        if (val < acc) acc = val;")
        else:
            lines.append(f"        acc += {inner_expr};")

        lines.append("    }")

        if fwd_reduce_op == "xor":
            lines.append(f"    {dest}[row] = (xor_acc == 1) ? -1.0 : 1.0;")
        else:
            lines.append(f"    {dest}[row] = acc;")

        lines.append("}")
        return lines

    _EMITTERS: dict = {
        "map": _emit_map,
        "reduce": _emit_reduce,
        "delay": _emit_delay,
        "shift_reg": _emit_shift_reg,
        "message_pass": _emit_message_pass,
    }

    # -- map expression helper -----------------------------------------------

    @staticmethod
    def _map_expr(func: str, detail: dict, var: str) -> str:
        """Return a C++ expression for a map function applied to *var*."""
        if func == "tanh":
            return f"std::tanh({var})"
        if func == "atanh":
            return f"std::atanh({var})"
        if func == "sign":
            return f"({var} >= 0) ? 1.0 : -1.0"
        if func == "abs":
            return f"std::abs({var})"
        if func == "multiply":
            coeff = detail.get("func_params", {}).get("coeff", detail.get("coeff", 1.0))
            return f"{var} * {coeff}"
        if func == "clamp":
            params = detail.get("func_params", {})
            lo = params.get("lo", -1.0)
            hi = params.get("hi", 1.0)
            return f"std::max({lo}, std::min({hi}, {var}))"
        if func == "lut":
            target = detail.get("func_params", {}).get("target_func", "tanh")
            return GoldenModelGenerator._map_expr(target, detail, var)
        return var

    # -- compile / run helpers -----------------------------------------------

    def _infer_outputs(
        self,
        cpp_code: str,
        input_data: dict[str, list[float]],
        dialect: Optional[MathDialect],
    ) -> dict[str, int]:
        """Return mapping of output_name -> size.

        When a dialect is available we use its output_nodes and shapes.
        Otherwise we fall back to scanning the C++ parameter list.
        """
        outputs: dict[str, int] = {}
        if dialect is not None:
            for nid in dialect.output_nodes:
                node = dialect.nodes[nid]
                size = self._flat_size(node)
                outputs[nid] = size
            return outputs

        for line in cpp_code.splitlines():
            if "_out," in line or "_out)" in line:
                parts = line.strip().rstrip(",)").split()
                for p in parts:
                    if p.endswith("_out"):
                        name = p.lstrip("*")
                        base = name.removesuffix("_out")
                        first_input_size = next(
                            len(v) for v in input_data.values()
                        )
                        outputs[base] = first_input_size
        return outputs

    def _generate_main(
        self,
        cpp_code: str,
        input_data: dict[str, list[float]],
        output_info: dict[str, int],
        csr_data: Optional[dict[str, list[int]]],
    ) -> str:
        """Generate a complete C++ file with ``main`` that drives the golden function."""
        lines: list[str] = [cpp_code, "", "int main() {"]

        for name, values in input_data.items():
            arr = ", ".join(f"{v:.17g}" for v in values)
            lines.append(f"    double {name}[] = {{{arr}}};")
            lines.append(f"    int size_{name} = {len(values)};")

        for name, size in output_info.items():
            lines.append(f"    double {name}_out[{size}];")
            lines.append(f"    int size_{name}_out = {size};")

        if csr_data is not None:
            rp = ", ".join(str(x) for x in csr_data["row_ptr"])
            ci = ", ".join(str(x) for x in csr_data["col_idx"])
            lines.append(f"    int row_ptr[] = {{{rp}}};")
            lines.append(f"    int row_ptr_len = {len(csr_data['row_ptr'])};")
            lines.append(f"    int col_idx[] = {{{ci}}};")
            lines.append(f"    int col_idx_len = {len(csr_data['col_idx'])};")

        func_name = "golden"
        for line in cpp_code.splitlines():
            if line.startswith("void ") and "(" in line:
                func_name = line.split("void ")[1].split("(")[0].strip()
                break

        args: list[str] = []
        for name in input_data:
            args.append(name)
            args.append(f"size_{name}")
        for name in output_info:
            args.append(f"{name}_out")
            args.append(f"size_{name}_out")
        if csr_data is not None:
            args.extend(["row_ptr", "row_ptr_len", "col_idx", "col_idx_len"])

        lines.append(f"    {func_name}({', '.join(args)});")
        lines.append("")

        for name, size in output_info.items():
            lines.append(f'    printf("{name}:");')
            lines.append(f"    for (int i = 0; i < {size}; i++) {{")
            lines.append(f'        if (i > 0) printf(",");')
            lines.append(f'        printf("%.17g", {name}_out[i]);')
            lines.append("    }")
            lines.append('    printf("\\n");')

        lines.append("    return 0;")
        lines.append("}")
        lines.append("")
        return "\n".join(lines)

    def _compile_run(self, full_cpp: str) -> dict[str, list[float]]:
        """Write, compile, execute, and parse output."""
        tmp_dir = tempfile.mkdtemp(prefix="formasyn_golden_")
        src_path = os.path.join(tmp_dir, "golden.cpp")
        exe_path = os.path.join(tmp_dir, "golden")

        if platform.system() == "Windows":
            exe_path += ".exe"

        with open(src_path, "w", encoding="utf-8") as f:
            f.write(full_cpp)

        compile_result = subprocess.run(
            ["g++", "-O0", "-std=c++17", "-o", exe_path, src_path],
            capture_output=True,
            text=True,
        )
        if compile_result.returncode != 0:
            raise GoldenCompileError(compile_result.stderr)

        run_result = subprocess.run(
            [exe_path],
            capture_output=True,
            text=True,
        )
        if run_result.returncode != 0:
            raise GoldenCompileError(
                f"Runtime error (exit {run_result.returncode}):\n"
                f"{run_result.stderr}"
            )

        return self._parse_output(run_result.stdout)

    # -- helpers -------------------------------------------------------------

    @staticmethod
    def _parse_output(stdout: str) -> dict[str, list[float]]:
        """Parse ``name:v0,v1,...`` lines from stdout."""
        result: dict[str, list[float]] = {}
        for line in stdout.strip().splitlines():
            if ":" not in line:
                continue
            name, values_str = line.split(":", 1)
            name = name.strip()
            if not values_str.strip():
                result[name] = []
                continue
            result[name] = [float(v) for v in values_str.split(",")]
        return result

    @staticmethod
    def _flat_size(node: MathNode) -> int:
        """Total element count from shape (product of dimensions)."""
        if not node.shape:
            return 1
        size = 1
        for dim in node.shape:
            size *= dim
        return size

    @staticmethod
    def _src_ref(node: MathNode, dialect: MathDialect) -> str:
        """Return the C++ variable name for a source node's data."""
        if node.node_id in dialect.output_nodes:
            return f"{node.node_id}_out"
        return node.node_id
