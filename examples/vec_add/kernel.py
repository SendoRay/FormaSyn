"""Vector add kernel definition using FormaSyn DSL.

Data flow::

    a ----\
           +--> map(add) --> c
    b ----/
"""

from __future__ import annotations

import FormaSyn.formasyn.dsl as fp

VEC_LEN = 16


def build_vec_add() -> fp.FormulaGraph:
    """Construct a vector-add kernel c = a + b."""
    graph = fp.FormulaGraph(
        name="vec_add",
        inputs={"a": [VEC_LEN], "b": [VEC_LEN]},
        outputs=["c"],
    )

    graph.add(
        fp.map("a", func="add", output="c", other_ref="b")
    )
    return graph


def get_test_inputs() -> dict[str, list[float]]:
    """Provide deterministic sample vectors for c = a + b."""
    a = [float(i) for i in range(VEC_LEN)]
    b = [float(2 * i - 5) for i in range(VEC_LEN)]
    return {"a": a, "b": b}

