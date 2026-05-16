"""MLC Backend: BRAM bank allocation and address-mapping code generation.

Runs *after* the Roofline Solver has determined unroll factors.  For each
irregular-access node in the HLS-Schedule Dialect, this pass:

1. Computes the required number of BRAM banks (rounded to a power of two).
2. Generates a C++ address-mapping code snippet using the CSR layout.
3. Updates the aggregate BRAM resource estimate on the schedule.
"""

from __future__ import annotations

import logging
import math
import os
import textwrap
from typing import Optional

import numpy as np

from ..ir.math_dialect import MathDialect
from ..ir.schedule_dialect import HLSScheduleDialect, ScheduleNode

logger = logging.getLogger(__name__)


def _next_power_of_two(n: int) -> int:
    """Round *n* up to the nearest power of two (minimum 1)."""
    if n <= 1:
        return 1
    return 1 << (n - 1).bit_length()


def _load_csr_shape(csr_ref: Optional[str]) -> tuple[int, int]:
    """Load CSR .npz and return (num_rows, nnz).

    If the file cannot be loaded (e.g. path is a symbolic name rather
    than a real file), fall back to placeholder values.
    """
    if csr_ref is None:
        return 0, 0
    try:
        if os.path.isfile(csr_ref) or os.path.isfile(csr_ref + ".npz"):
            path = csr_ref if csr_ref.endswith(".npz") else csr_ref + ".npz"
            data = np.load(path)
            row_ptr = data["row_ptr"]
            col_idx = data["col_idx"]
            num_rows = len(row_ptr) - 1
            nnz = len(col_idx)
            return num_rows, nnz
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

    code = textwrap.dedent(f"""\
        // [FormaSyn MLC] Irregular access mapping for {node.node_id}
        // CSR format: row_ptr[{num_rows_str}+1], col_idx[{nnz_str}]
        for (int idx = row_ptr[m]; idx < row_ptr[m+1]; idx++) {{
            int n_prime = col_idx[idx];
            if (n_prime == n) continue;  // {exclude_comment}
            // Bank {node.bram_banks}: cyclic partition
        }}""")
    return code


class MLCBackend:
    """MLC backend pass: BRAM bank decisions and address-mapping codegen.

    This pass is stateless — all information comes from the
    ``HLSScheduleDialect`` and ``MathDialect`` arguments.
    """

    def compile(
        self,
        schedule: HLSScheduleDialect,
        math_dialect: MathDialect,
    ) -> HLSScheduleDialect:
        """Allocate BRAM banks and generate address-mapping code.

        Args:
            schedule: HLS-Schedule Dialect with unroll factors already set.
            math_dialect: The annotated Math Dialect (provides CSR refs).

        Returns:
            The same ``HLSScheduleDialect`` with ``bram_banks``,
            ``address_mapping_code``, and ``total_bram_estimate`` updated.
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
            logger.info(
                "Node '%s': unroll=%d → bram_banks=%d",
                node_id,
                sched_node.unroll_factor,
                sched_node.bram_banks,
            )

        schedule.total_bram_estimate += added_bram
        logger.info(
            "Total BRAM estimate updated: +%d → %d",
            added_bram,
            schedule.total_bram_estimate,
        )
        return schedule
