"""DSL Parser: FormulaGraph → Math Dialect AST.

Walks the ordered operator list inside a FormulaGraph and emits a
MathDialect whose nodes mirror the DSL topology one-to-one.
"""

from __future__ import annotations

import logging
from dataclasses import asdict
from typing import Any

from FormaSyn.dsl.operators import (
    AnyOp,
    DelayOp,
    FormulaGraph,
    MapOp,
    MessagePassOp,
    ReduceOp,
    ShiftRegOp,
)
from FormaSyn.ir.math_dialect import MathDialect, MathNode

logger = logging.getLogger(__name__)

_OP_TYPE_MAP: dict[type, str] = {
    MapOp: "map",
    ReduceOp: "reduce",
    DelayOp: "delay",
    ShiftRegOp: "shift_reg",
    MessagePassOp: "message_pass",
}


def _extract_op_detail(op: AnyOp) -> dict[str, Any]:
    """Build the op_detail dict from an operator's domain-specific fields."""
    if isinstance(op, MapOp):
        detail: dict[str, Any] = {"func": op.func}
        if op.func_params:
            detail["func_params"] = dict(op.func_params)
        return detail

    if isinstance(op, ReduceOp):
        detail = {"op": op.op, "domain_kind": op.domain.kind}
        if op.domain.graph_ref:
            detail["graph_ref"] = op.domain.graph_ref
        if op.domain.exclude_self:
            detail["exclude_self"] = True
        if op.domain.window_size is not None:
            detail["window_size"] = op.domain.window_size
            detail["window_stride"] = op.domain.window_stride
        return detail

    if isinstance(op, DelayOp):
        return {"steps": op.steps}

    if isinstance(op, ShiftRegOp):
        return {"taps": list(op.taps)}

    if isinstance(op, MessagePassOp):
        return {
            "graph_ref": op.graph_ref,
            "node_type": op.node_type,
            "forward_map": _extract_op_detail(op.forward_map),
            "forward_reduce": _extract_op_detail(op.forward_reduce),
            "schedule": op.schedule,
        }

    raise TypeError(f"Unknown operator type: {type(op)}")


def _infer_shape(op: AnyOp, known_shapes: dict[str, list[int]]) -> list[int]:
    """Heuristic shape inference based on operator semantics."""
    input_shape = known_shapes.get(op.input_ref if hasattr(op, "input_ref") else "", [1])

    if isinstance(op, ShiftRegOp):
        return [len(op.taps)]

    if isinstance(op, ReduceOp):
        if op.domain.kind == "all":
            return [1]
        return input_shape

    if isinstance(op, DelayOp):
        return list(input_shape)

    if isinstance(op, MapOp):
        return list(input_shape)

    if isinstance(op, MessagePassOp):
        return list(input_shape)

    return [1]


def _resolve_input_ref(op: AnyOp) -> str:
    """Extract the input_ref name used to look up the upstream node."""
    if isinstance(op, MessagePassOp):
        return op.graph_ref
    return getattr(op, "input_ref", "")


def parse(graph: FormulaGraph) -> MathDialect:
    """Convert a FormulaGraph into a MathDialect IR.

    Each DSL operator becomes one MathNode.  The dependency edges are
    inferred from the signal names (output_ref → input_ref links).

    Args:
        graph: The user-constructed FormulaGraph.

    Returns:
        A MathDialect instance ready for downstream lowering.
    """
    signal_to_node: dict[str, str] = {}
    known_shapes: dict[str, list[int]] = {}
    nodes: dict[str, MathNode] = {}

    for sig_name, shape in graph.inputs.items():
        node_id = sig_name
        nodes[node_id] = MathNode(
            node_id=node_id,
            op_type="input",
            shape=list(shape),
        )
        signal_to_node[sig_name] = node_id
        known_shapes[sig_name] = list(shape)

    for op in graph.ops:
        node_id = op.output_ref
        op_type = _OP_TYPE_MAP[type(op)]
        op_detail = _extract_op_detail(op)
        shape = _infer_shape(op, known_shapes)

        input_ref = _resolve_input_ref(op)
        input_nodes: list[str] = []
        if input_ref and input_ref in signal_to_node:
            input_nodes.append(signal_to_node[input_ref])
        if isinstance(op, MapOp):
            other_ref = op.func_params.get("other_ref")
            if (
                isinstance(other_ref, str)
                and other_ref in signal_to_node
                and signal_to_node[other_ref] not in input_nodes
            ):
                input_nodes.append(signal_to_node[other_ref])

        is_irregular = False
        csr_ref = None
        if isinstance(op, ReduceOp) and op.domain.kind == "neighbors":
            is_irregular = True
            csr_ref = f"{op.domain.graph_ref}_csr" if op.domain.graph_ref else None
        if isinstance(op, MessagePassOp):
            is_irregular = True
            csr_ref = f"{op.graph_ref}_csr"

        nodes[node_id] = MathNode(
            node_id=node_id,
            op_type=op_type,
            op_detail=op_detail,
            shape=shape,
            input_nodes=input_nodes,
            is_irregular_access=is_irregular,
            csr_ref=csr_ref,
        )
        signal_to_node[op.output_ref] = node_id
        known_shapes[op.output_ref] = shape

    logger.info(
        "Parsed FormulaGraph '%s' → MathDialect with %d nodes",
        graph.name, len(nodes),
    )

    return MathDialect(
        kernel_name=graph.name,
        nodes=nodes,
        input_nodes=list(graph.inputs.keys()),
        output_nodes=list(graph.outputs),
    )
