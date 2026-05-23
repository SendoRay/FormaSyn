"""Early-Late Gate Timing Recovery kernel definition using FormaSyn DSL.

Pure mathematical topology -- no hardware parameters, no pragmas, no bit-widths.

Implements a first-order timing recovery loop:
  1. Compute early and late samples from the oversampled input.
  2. Timing error = |late|^2 - |early|^2 (Mueller-Muller style).
  3. Loop filter: phase_acc += gain * timing_error (feedback).

Data flow::

    rx_samples -> [CycleOp body]:
        subtract(early, late) -> multiply(gain) -> accumulate(phase)
                                                        |
                                                feedback_edge
                                                        |
                                                   timing_error

Uses CycleOp to express the feedback loop (phase accumulator).
"""

from __future__ import annotations

import formasyn.dsl as fp
from formasyn.dsl.operators import CycleOp, FeedbackEdge

OVERSAMPLING = 4  # samples per symbol


def build_timing_recovery() -> fp.FormulaGraph:
    """Construct an early-late gate timing recovery loop as a FormulaGraph.

    Returns:
        A FormulaGraph with a CycleOp expressing the feedback timing loop.
    """
    graph = fp.FormulaGraph(
        name="timing_recovery",
        inputs={"rx_samples": [OVERSAMPLING]},
        outputs=["timing_error"],
    )

    # CycleOp body: one iteration of the timing recovery loop
    # 1. Compute timing error from early/late difference
    # 2. Scale by loop gain
    # 3. Accumulate into phase (feedback)
    body = [
        # Subtract early from late sample to get raw error
        fp.MapOp(
            input_ref="rx_samples",
            func="subtract",
            func_params={"early_idx": 0, "late_idx": OVERSAMPLING - 1},
            output_ref="raw_error",
        ),
        # Scale error by loop gain
        fp.MapOp(
            input_ref="raw_error",
            func="multiply",
            func_params={"coeffs": [0.01]},
            output_ref="scaled_error",
        ),
        # Accumulate: phase_next = phase_prev + scaled_error
        fp.MapOp(
            input_ref="scaled_error",
            func="add",
            func_params={"other_ref": "phase_prev"},
            output_ref="phase_acc",
        ),
    ]

    graph.add(
        CycleOp(
            body=body,
            feedback_edges=[
                FeedbackEdge(src="phase_acc", dst="phase_prev", delay=1),
            ],
            init_values={"phase_prev": 0.0},
            output_ref="timing_error",
        )
    )

    return graph
