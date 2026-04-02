"""FIR 16-tap filter kernel definition using FormaSyn DSL.

Pure mathematical topology -- no hardware parameters, no pragmas, no bit-widths.
This file is the single source of truth for what the algorithm *does*.

Data flow::

    x_in ─► shift_reg(16 taps) ─► multiply(coeff) ─► reduce(add) ─► y_out
"""

from __future__ import annotations

import FormaSyn.formasyn.dsl as fp

COEFFS: list[float] = [
    0.003, 0.008, 0.025, 0.063,
    0.121, 0.186, 0.233, 0.250,
    0.250, 0.233, 0.186, 0.121,
    0.063, 0.025, 0.008, 0.003,
]
"""Symmetric low-pass FIR coefficients (16 taps, sum ≈ 1.0)."""


def build_fir_16tap() -> fp.FormulaGraph:
    """Construct the FIR-16 kernel as a FormulaGraph.

    Returns:
        A FormulaGraph with 3 operators: shift_reg → map(multiply) → reduce(add).
    """
    graph = fp.FormulaGraph(
        name="fir_16tap",
        inputs={"x_in": [1]},
        outputs=["y_out"],
    )

    graph.add(
        fp.shift_reg("x_in", taps=list(range(16)), output="taps")
    )

    graph.add(
        fp.map("taps", func="multiply", func_params={"coeffs": COEFFS}, output="products")
    )

    graph.add(
        fp.reduce(
            "products",
            op="add",
            domain=fp.domain.all(),
            output="y_out",
        )
    )

    return graph
