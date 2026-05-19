"""MLC (Memory Layout Compiler): irregular-access analysis + BRAM allocation.

Two-phase pass run at different points in the pipeline:

1. ``analyze()`` — runs *before* the ScheduleBuilder.
   Tags nodes with irregular access patterns, converts H-matrix → CSR .npz.

2. ``compile()`` — runs *after* the ScheduleBuilder.
   Assigns BRAM banks (needs ``unroll_factor``), generates address-mapping C++.
"""

from __future__ import annotations

import logging
import math
import os
import tempfile
import textwrap
from pathlib import Path
from typing import Optional

import numpy as np
from scipy import sparse

from ..dsl.operators import FormulaGraph
from ..ir.math_dialect import MathDialect, MathNode
from ..ir.schedule_dialect import HLSScheduleDialect, ScheduleNode

logger = logging.getLogger(__name__)


class MissingGraphDataError(Exception):
    """Raised when a MessagePassOp exists but FormulaGraph.graph_data is None."""


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _needs_irregular_access(node: MathNode) -> bool:
    """Return True if the node involves topology-dependent irregular access."""
    if node.op_type == "message_pass":
        return True
    if node.op_detail.get("domain_kind") == "neighbors":
        return True
    return False


def _next_power_of_two(n: int) -> int:
    """Round *n* up to the nearest power of two (minimum 1)."""
    if n <= 1:
        return 1
    return 1 << (n - 1).bit_length()


def _load_csr_shape(csr_ref: Optional[str]) -> tuple[int, int]:
    """Load CSR .npz and return (num_rows, nnz)."""
    if csr_ref is None:
        return 0, 0
    try:
        if os.path.isfile(csr_ref) or os.path.isfile(csr_ref + ".npz"):
            path = csr_ref if csr_ref.endswith(".npz") else csr_ref + ".npz"
            data = np.load(path)
            return len(data["row_ptr"]) - 1, len(data["col_idx"])
    except Exception:
        logger.warning("Could not load CSR from '%s', using placeholders", csr_ref)
    return 0, 0


def _generate_address_mapping(
    node: ScheduleNode, num_rows: int, nnz: int
) -> str:
    """Generate C++ address-mapping code for an irregular-access node."""
    exclude_self = node.op_detail.get("exclude_self", False)
    exclude_comment = "exclude_self" if exclude_self else "include_self"
    num_rows_str = str(num_rows) if num_rows > 0 else "NUM_ROWS"
    nnz_str = str(nnz) if nnz > 0 else "NNZ"

    return textwrap.dedent(f"""\
        // [FormaSyn MLC] Irregular access mapping for {node.node_id}
        // CSR format: row_ptr[{num_rows_str}+1], col_idx[{nnz_str}]
        for (int idx = row_ptr[m]; idx < row_ptr[m+1]; idx++) {{
            int n_prime = col_idx[idx];
            if (n_prime == n) continue;  // {exclude_comment}
            // Bank {node.bram_banks}: cyclic partition
        }}""")


# ---------------------------------------------------------------------------
# Unified pass
# ---------------------------------------------------------------------------

class MemoryLayoutPass:
    """MLC: irregular-access analysis + BRAM bank allocation.

    Usage::

        mlc = MemoryLayoutPass()
        math_dialect = mlc.analyze(graph, math_dialect)   # before solver
        schedule = mlc.compile(schedule, math_dialect)     # after solver

    Args:
        output_dir: Directory for storing generated .npz CSR files.
            When *None*, a temporary directory is created automatically.
    """

    def __init__(self, output_dir: Optional[str] = None) -> None:
        if output_dir is None:
            self._output_dir = Path(tempfile.mkdtemp(prefix="formasyn_csr_"))
        else:
            self._output_dir = Path(output_dir)
            self._output_dir.mkdir(parents=True, exist_ok=True)

    @property
    def output_dir(self) -> Path:
        return self._output_dir

    # -- Phase 1: Pre-solver analysis --

    def analyze(
        self, graph: FormulaGraph, dialect: MathDialect
    ) -> MathDialect:
        """Tag irregular-access nodes and convert H-matrix to CSR.

        Runs before the ScheduleBuilder. Sets ``is_irregular_access`` and
        ``csr_ref`` on relevant nodes. Does NOT determine BRAM bank counts.

        Raises:
            MissingGraphDataError: If graph-neighbor ops exist but
                ``graph.graph_data`` is None.
        """
        has_irregular = False
        for node in dialect.nodes.values():
            if _needs_irregular_access(node):
                node.is_irregular_access = True
                has_irregular = True

        if has_irregular and graph.graph_data is None:
            raise MissingGraphDataError(
                f"Kernel '{graph.name}' contains message-passing or "
                f"neighbor-domain operators but graph_data (H-matrix) "
                f"is not provided."
            )

        csr_path: Optional[str] = None
        if graph.graph_data is not None and has_irregular:
            csr_path = self._convert_to_csr(graph)

        if csr_path is not None:
            for node in dialect.nodes.values():
                if node.is_irregular_access:
                    node.csr_ref = csr_path

        return dialect

    # -- Phase 2: Post-solver BRAM allocation --

    def compile(
        self,
        schedule: HLSScheduleDialect,
        math_dialect: MathDialect,
    ) -> HLSScheduleDialect:
        """Assign BRAM banks and generate address-mapping C++ code.

        Runs after the ScheduleBuilder has set ``unroll_factor`` on each node.
        For non-irregular kernels this is a no-op.
        """
        added_bram = 0

        for node_id, sched_node in schedule.nodes.items():
            if not sched_node.is_irregular_access:
                continue

            required = math.ceil(sched_node.unroll_factor / 2)
            sched_node.bram_banks = _next_power_of_two(required)

            math_node = math_dialect.nodes.get(node_id)
            csr_ref = math_node.csr_ref if math_node else sched_node.csr_ref
            num_rows, nnz = _load_csr_shape(csr_ref)

            sched_node.address_mapping_code = _generate_address_mapping(
                sched_node, num_rows, nnz
            )
            added_bram += sched_node.bram_banks

        schedule.total_bram_estimate += added_bram
        return schedule

    # -- Internal --

    def _convert_to_csr(self, graph: FormulaGraph) -> str:
        """Convert graph_data to CSR .npz, return absolute path."""
        csr = sparse.csr_matrix(graph.graph_data)
        npz_path = os.path.join(str(self._output_dir), f"{graph.name}_csr.npz")
        np.savez(npz_path, row_ptr=np.asarray(csr.indptr), col_idx=np.asarray(csr.indices))
        logger.info("CSR saved to %s", npz_path)
        return npz_path
