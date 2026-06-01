"""Memory layout lowering: assign BRAM banks and address widths for irregular-access nodes.

This is the backend/lowering half of the former ``formasyn.mlc.memory_layout``
module.  It runs *after* the schedule builder and assigns concrete BRAM
parameters to ``RTLScheduleDialect`` nodes that were tagged as irregular-access
during the analysis phase.
"""

from __future__ import annotations

import logging
import math
import os
from typing import Optional

import numpy as np

from ..ir.rtl_dialect import RTLScheduleDialect
from ..ir.math_dialect import MathDialect

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _next_power_of_two(n: int) -> int:
    """Round *n* up to the nearest power of two (minimum 1)."""
    if n <= 1:
        return 1
    return 1 << (n - 1).bit_length()


def _load_csr_shape(csr_ref: Optional[str]) -> tuple[int, int]:
    """Load CSR ``.npz`` and return ``(num_rows, nnz)``."""
    if csr_ref is None:
        return 0, 0
    try:
        path = csr_ref if csr_ref.endswith(".npz") else csr_ref + ".npz"
        if os.path.isfile(path):
            data = np.load(path)
            return len(data["row_ptr"]) - 1, len(data["col_idx"])
    except Exception:
        logger.warning("Could not load CSR from '%s', using placeholders", csr_ref)
    return 0, 0


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def assign_memory_layout(
    schedule: RTLScheduleDialect,
    math_dialect: MathDialect,
) -> RTLScheduleDialect:
    """Assign BRAM banks, ports, and address widths to irregular-access nodes.

    For each node in *schedule* whose corresponding ``MathDialect`` node has
    ``is_irregular_access == True`` and a ``csr_ref``, this function:

    * Loads the CSR ``.npz`` to determine ``(num_rows, nnz)``.
    * Sets ``storage_type = "bram"``.
    * Computes ``bram_banks`` as the next power of two of the node's
      ``parallelism`` (minimum 2).
    * Sets ``bram_ports = 2`` (dual-port).
    * Computes ``address_width`` as ``ceil(log2(depth_per_bank + 1))``.

    Args:
        schedule: The ``RTLScheduleDialect`` to annotate (modified in-place
            and returned).
        math_dialect: The ``MathDialect`` that was previously annotated by
            ``analyze_irregular_access``.

    Returns:
        The same *schedule* object with BRAM fields populated.
    """
    added_bram = 0

    for node_id, rtl_node in schedule.nodes.items():
        math_node = math_dialect.nodes.get(node_id)
        if math_node is None or not math_node.is_irregular_access:
            continue

        csr_ref = math_node.csr_ref
        num_rows, nnz = _load_csr_shape(csr_ref)

        # Storage type
        rtl_node.storage_type = "bram"

        # Bank count: next power of two of parallelism, at least 2
        banks = _next_power_of_two(rtl_node.parallelism) if rtl_node.parallelism > 2 else 2
        rtl_node.bram_banks = banks

        # Dual-port BRAM
        rtl_node.bram_ports = 2

        # Address width: accommodate nnz spread across banks
        depth_per_bank = max(nnz // banks, num_rows) if banks > 0 else max(nnz, num_rows)
        rtl_node.address_width = math.ceil(math.log2(depth_per_bank + 1)) if depth_per_bank > 0 else 1

        rtl_node.is_irregular_access = True
        added_bram += banks

    schedule.estimated_brams += added_bram
    return schedule
