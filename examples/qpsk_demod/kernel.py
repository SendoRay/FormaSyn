"""QPSK Soft Demapper kernel definition using FormaSyn DSL.

Pure mathematical topology -- no hardware parameters, no pragmas, no bit-widths.

Computes log-likelihood ratios (LLRs) from received QPSK constellation points.
For QPSK with Gray coding, the soft demapping simplifies to scaled I/Q values:
  LLR_bit0 = 2 * symbol_re / noise_variance
  LLR_bit1 = 2 * symbol_im / noise_variance

Data flow::

    symbols_re -> soft_demapper -> llr_re
    symbols_im -> soft_demapper -> llr_im
"""

from __future__ import annotations

import formasyn.dsl as fp

NUM_SYMBOLS = 8


def build_qpsk_demod() -> fp.FormulaGraph:
    """Construct a QPSK soft demapper as a FormulaGraph.

    Returns:
        A FormulaGraph that maps I/Q symbols to LLR values.
    """
    graph = fp.FormulaGraph(
        name="qpsk_demod",
        inputs={"symbols_re": [NUM_SYMBOLS], "symbols_im": [NUM_SYMBOLS]},
        outputs=["llr_re", "llr_im"],
    )

    # Soft demapping: scale I component to get LLR for bit 0
    graph.add(
        fp.map(
            "symbols_re",
            func="soft_demapper",
            output="llr_re",
            modulation="qpsk",
            component="real",
        )
    )

    # Soft demapping: scale Q component to get LLR for bit 1
    graph.add(
        fp.map(
            "symbols_im",
            func="soft_demapper",
            output="llr_im",
            modulation="qpsk",
            component="imag",
        )
    )

    return graph
