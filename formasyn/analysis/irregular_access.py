"""Irregular-access analysis: detect message-passing ops and convert H-matrix to CSR.

This is the analysis/frontend half of the former ``formasyn.mlc.memory_layout``
module.  It runs *before* the schedule builder and only tags nodes + exports
CSR data — it does **not** allocate BRAM banks.
"""

from __future__ import annotations

import copy
import logging
import os
from typing import Optional

import numpy as np
from scipy import sparse

from ..dsl.operators import FormulaGraph
from ..ir.math_dialect import MathDialect, MathNode

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _needs_irregular_access(node: MathNode) -> bool:
    """Return True if *node* involves topology-dependent irregular access."""
    if node.op_type == "message_pass":
        return True
    if node.op_detail.get("domain_kind") == "neighbors":
        return True
    return False


def _convert_to_csr(graph: FormulaGraph, output_dir: str) -> str:
    """Convert ``graph.graph_data`` to CSR ``.npz`` and return the absolute path."""
    csr = sparse.csr_matrix(graph.graph_data)
    os.makedirs(output_dir, exist_ok=True)
    npz_path = os.path.join(output_dir, f"{graph.name}_csr.npz")
    np.savez(npz_path, row_ptr=np.asarray(csr.indptr), col_idx=np.asarray(csr.indices))
    logger.info("CSR saved to %s", npz_path)
    return npz_path


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def analyze_irregular_access(
    graph: FormulaGraph,
    dialect: MathDialect,
    output_dir: Optional[str] = None,
) -> MathDialect:
    """Tag irregular-access nodes and optionally convert H-matrix to CSR.

    Returns a deep copy of *dialect* with ``is_irregular_access = True`` set
    on every node whose ``op_type`` is ``"message_pass"`` (or whose
    ``domain_kind`` is ``"neighbors"``).  If ``graph.graph_data`` exists and
    *output_dir* is provided, the graph data is converted to CSR ``.npz``
    format and ``csr_ref`` is set on each tagged node.

    Args:
        graph: The parsed ``FormulaGraph`` (may contain ``graph_data``).
        dialect: The ``MathDialect`` to annotate.
        output_dir: Directory for storing generated ``.npz`` CSR files.
            When *None*, CSR conversion is skipped.

    Returns:
        A new ``MathDialect`` instance with annotations applied.
    """
    dialect = copy.deepcopy(dialect)

    has_irregular = False
    for node in dialect.nodes.values():
        if _needs_irregular_access(node):
            node.is_irregular_access = True
            has_irregular = True

    if not has_irregular:
        return dialect

    csr_path: Optional[str] = None
    if graph.graph_data is not None and output_dir is not None:
        csr_path = _convert_to_csr(graph, output_dir)

    if csr_path is not None:
        for node in dialect.nodes.values():
            if node.is_irregular_access:
                node.csr_ref = csr_path

    return dialect
