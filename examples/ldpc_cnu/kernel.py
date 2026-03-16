"""LDPC Min-Sum Check Node Update (CNU) kernel definition using FormaSyn DSL.

Pure mathematical topology -- no hardware parameters, no pragmas, no bit-widths.

The CNU computes outgoing check-to-variable messages by:
  1. Extracting sign bits (sign) and magnitudes (abs) from incoming messages.
  2. XOR-reducing signs across neighbors (exclude self) to get parity.
  3. MIN-reducing magnitudes across neighbors (exclude self) to get reliability.

Data flow::

    msg_in ──┬─► map(sign)  ─► reduce(xor, neighbors, exclude_self) ─► sign_out
             └─► map(abs)   ─► reduce(min, neighbors, exclude_self) ─► min_out

The H-matrix (parity-check matrix) defines the bipartite graph topology.
"""

from __future__ import annotations

from typing import Any

import numpy as np
from scipy import sparse

import FormaSyn.dsl as fp


def build_ldpc_cnu(dc: int = 8) -> fp.FormulaGraph:
    """Construct the LDPC Min-Sum CNU kernel as a FormulaGraph.

    Args:
        dc: Check node degree (number of connected variable nodes).
            Determines the shape of the input message array.

    Returns:
        A FormulaGraph with 4 operators describing the CNU algorithm,
        plus a small synthetic H-matrix as graph_data.
    """
    H = _build_synthetic_h_matrix(dc=dc, num_checks=4, num_vars=dc)

    graph = fp.FormulaGraph(
        name="ldpc_cnu",
        inputs={"msg_in": [dc]},
        outputs=["sign_out", "min_out"],
        graph_data=H,
    )

    graph.add(fp.map("msg_in", func="sign", output="sign_bits"))
    graph.add(fp.map("msg_in", func="abs", output="mag_bits"))

    graph.add(
        fp.reduce(
            "sign_bits",
            op="xor",
            domain=fp.domain.neighbors("H", exclude_self=True),
            output="sign_out",
        )
    )

    graph.add(
        fp.reduce(
            "mag_bits",
            op="min",
            domain=fp.domain.neighbors("H", exclude_self=True),
            output="min_out",
        )
    )

    return graph


def _build_synthetic_h_matrix(
    dc: int, num_checks: int, num_vars: int
) -> Any:
    """Build a small synthetic LDPC parity-check matrix for testing.

    Creates a regular H-matrix where each check node connects to ``dc``
    variable nodes with a cyclic shift pattern.

    Returns:
        A scipy CSR sparse matrix.
    """
    rows, cols = [], []
    for c in range(num_checks):
        for j in range(dc):
            v = (c + j) % num_vars
            rows.append(c)
            cols.append(v)

    data = np.ones(len(rows), dtype=np.int32)
    H = sparse.csr_matrix(
        (data, (rows, cols)), shape=(num_checks, num_vars)
    )
    return H


def get_test_inputs(dc: int = 8) -> dict[str, list[float]]:
    """Return representative test inputs for the LDPC CNU kernel.

    Generates LLR-like values (log-likelihood ratios) in the range [-5, 5].
    """
    rng = np.random.default_rng(seed=2024)
    msg_in = rng.uniform(-5.0, 5.0, size=dc).tolist()
    return {"msg_in": msg_in}
