"""MLC Frontend: topology analysis and CSR conversion pass.

Analyzes the FormulaGraph and MathDialect to identify nodes with
irregular memory access patterns (graph-dependent neighbor traversals),
converts the H-matrix to CSR format, and serializes it as a .npz file.

This pass does NOT determine BRAM bank counts — that is deferred to
MLCBackend after the Roofline Solver computes unroll factors.
"""

from __future__ import annotations

import logging
import os
import tempfile
from pathlib import Path
from typing import Optional

import numpy as np
from scipy import sparse

from FormaSyn.formasyn.dsl.operators import FormulaGraph
from FormaSyn.formasyn.ir.math_dialect import MathDialect, MathNode

logger = logging.getLogger(__name__)


class MissingGraphDataError(Exception):
    """Raised when a MessagePassOp exists but FormulaGraph.graph_data is None.

    The user must supply an H-matrix (or equivalent adjacency data)
    for any kernel that contains graph-based message-passing operators.
    """


def _needs_irregular_access(node: MathNode) -> bool:
    """Return True if the node involves topology-dependent irregular access."""
    if node.op_type == "message_pass":
        return True
    if node.op_detail.get("domain_kind") == "neighbors":
        return True
    return False


class MLCFrontend:
    """MLC frontend pass: topology analysis without bank decisions.

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
        """Directory where .npz CSR files are stored."""
        return self._output_dir

    def analyze(
        self, graph: FormulaGraph, dialect: MathDialect
    ) -> MathDialect:
        """Annotate irregular-access nodes and convert H-matrix to CSR.

        Args:
            graph: The DSL-level formula graph (may contain graph_data).
            dialect: The Math Dialect IR to annotate.

        Returns:
            The same MathDialect instance with ``is_irregular_access`` and
            ``csr_ref`` fields populated on relevant nodes.  The field
            ``bram_bank_count`` is intentionally left as *None*.

        Raises:
            MissingGraphDataError: If any node requires graph topology
                (``message_pass`` op or ``neighbors`` domain) but
                ``graph.graph_data`` is *None*.
        """
        has_irregular = False
        for node in dialect.nodes.values():
            if _needs_irregular_access(node):
                node.is_irregular_access = True
                has_irregular = True
                logger.debug(
                    "Node '%s' marked as irregular access", node.node_id
                )

        if has_irregular and graph.graph_data is None:
            raise MissingGraphDataError(
                f"Kernel '{graph.name}' contains message-passing or "
                f"neighbor-domain operators but graph_data (H-matrix) "
                f"is not provided. Please supply graph_data to the "
                f"FormulaGraph."
            )

        csr_path: Optional[str] = None
        if graph.graph_data is not None and has_irregular:
            csr_path = self._convert_to_csr(graph)

        if csr_path is not None:
            for node in dialect.nodes.values():
                if node.is_irregular_access:
                    node.csr_ref = csr_path

        return dialect

    def _convert_to_csr(self, graph: FormulaGraph) -> str:
        """Convert graph_data to CSR and persist as .npz.

        Returns:
            Absolute path to the saved .npz file.
        """
        csr = sparse.csr_matrix(graph.graph_data)
        row_ptr = np.asarray(csr.indptr)
        col_idx = np.asarray(csr.indices)

        npz_path = os.path.join(
            str(self._output_dir), f"{graph.name}_csr.npz"
        )
        np.savez(npz_path, row_ptr=row_ptr, col_idx=col_idx)
        logger.info(
            "CSR data for '%s' saved to %s  "
            "(row_ptr shape=%s, col_idx shape=%s)",
            graph.name,
            npz_path,
            row_ptr.shape,
            col_idx.shape,
        )
        return npz_path
