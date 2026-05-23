"""8-point Radix-2 DIT FFT kernel definition using FormaSyn DSL.

Pure mathematical topology -- no hardware parameters, no pragmas, no bit-widths.

The FFT is expressed as log2(N)=3 stages of butterfly operations applied
iteratively. Each stage processes pairs of elements with twiddle factors.

Data flow::

    x_re, x_im -> bit_reverse -> IterationOp(3 stages, butterfly body) -> X_re, X_im
"""

from __future__ import annotations

import formasyn.dsl as fp
from formasyn.dsl.operators import IterationOp

N = 8
NUM_STAGES = 3  # log2(8)


def build_fft_radix2() -> fp.FormulaGraph:
    """Construct an 8-point Radix-2 DIT FFT as a FormulaGraph.

    Returns:
        A FormulaGraph with bit-reverse permutation followed by
        a 3-stage IterationOp of butterfly computations.
    """
    graph = fp.FormulaGraph(
        name="fft_radix2",
        inputs={"x_re": [N], "x_im": [N]},
        outputs=["X_re", "X_im"],
    )

    # Step 1: Bit-reverse permutation on input indices
    graph.add(
        fp.map("x_re", func="bit_reverse", output="br_re", num_bits=NUM_STAGES)
    )
    graph.add(
        fp.map("x_im", func="bit_reverse", output="br_im", num_bits=NUM_STAGES)
    )

    # Step 2: 3-stage butterfly iteration
    # Each stage applies butterfly operations on pairs with increasing stride.
    # The IterationOp body describes ONE stage; count=3 means repeat 3 times.
    butterfly_body = [
        fp.MapOp(
            input_ref="stage_re",
            func="butterfly",
            func_params={"component": "real", "n_points": N},
            output_ref="next_re",
        ),
        fp.MapOp(
            input_ref="stage_im",
            func="butterfly",
            func_params={"component": "imag", "n_points": N},
            output_ref="next_im",
        ),
    ]

    graph.add(
        IterationOp(
            body=butterfly_body,
            count=NUM_STAGES,
            carry=[("next_re", "stage_re"), ("next_im", "stage_im")],
            output_ref="X_re",
        )
    )

    return graph
