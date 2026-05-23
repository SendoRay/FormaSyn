"""Matched Filter (correlation detector) kernel definition using FormaSyn DSL.

Pure mathematical topology -- no hardware parameters, no pragmas, no bit-widths.

A matched filter correlates the received signal against a known reference
sequence (e.g., Barker-13 code) to detect signal presence/timing. Structurally
identical to FIR but semantically used for detection (peak finding).

Data flow::

    rx_in -> shift_reg(13 taps) -> multiply(reference) -> reduce(add) -> corr_out
"""

from __future__ import annotations

import formasyn.dsl as fp

# Barker-13 code: well-known sequence with good autocorrelation properties
BARKER_13: list[float] = [
    1.0, 1.0, 1.0, 1.0, 1.0,
    -1.0, -1.0, 1.0, 1.0, -1.0,
    1.0, -1.0, 1.0,
]

NUM_TAPS = len(BARKER_13)


def build_matched_filter() -> fp.FormulaGraph:
    """Construct a Barker-13 matched filter as a FormulaGraph.

    Returns:
        A FormulaGraph with 3 operators: shift_reg -> map(multiply) -> reduce(add).
    """
    graph = fp.FormulaGraph(
        name="matched_filter",
        inputs={"rx_in": [1]},
        outputs=["corr_out"],
    )

    # Tap delay line to hold the last 13 samples
    graph.add(
        fp.shift_reg("rx_in", taps=list(range(NUM_TAPS)), output="taps")
    )

    # Multiply each tap by the conjugate of the reference sequence
    graph.add(
        fp.map(
            "taps",
            func="multiply",
            output="products",
            func_params={"coeffs": BARKER_13},
        )
    )

    # Sum all products to get correlation value
    graph.add(
        fp.reduce(
            "products",
            op="add",
            domain=fp.domain.all(),
            output="corr_out",
        )
    )

    return graph
