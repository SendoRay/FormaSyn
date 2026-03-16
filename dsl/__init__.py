"""FormaSyn DSL: User-facing API for describing communication algorithm kernels.

Usage::

    import FormaSyn.dsl as fp

    graph = fp.FormulaGraph(name="ldpc_cnu",
                            inputs={"msg_in": [8]},
                            outputs=["cnu_out"])
    graph.add(fp.map("msg_in", func="sign", output="sign_bits"))
    graph.add(fp.map("msg_in", func="abs", output="mag_bits"))
    graph.add(fp.reduce("mag_bits", op="min",
                        domain=fp.domain.neighbors("H", exclude_self=True),
                        output="min_mag"))
"""

from __future__ import annotations

from typing import Any

from FormaSyn.dsl.operators import (
    AnyOp,
    DelayOp,
    Domain,
    FormulaGraph,
    MapOp,
    MessagePassOp,
    ReduceOp,
    ShiftRegOp,
)


# ---------------------------------------------------------------------------
# Domain builder namespace
# ---------------------------------------------------------------------------


class _DomainNS:
    """Namespace providing factory methods for Domain construction."""

    @staticmethod
    def all() -> Domain:
        """Reduce over all elements."""
        return Domain(kind="all")

    @staticmethod
    def neighbors(graph_ref: str, exclude_self: bool = False) -> Domain:
        """Reduce over graph neighbors (e.g. LDPC H-matrix connectivity)."""
        return Domain(kind="neighbors", graph_ref=graph_ref,
                      exclude_self=exclude_self)

    @staticmethod
    def window(size: int, stride: int = 1) -> Domain:
        """Reduce over a sliding window."""
        return Domain(kind="window", window_size=size, window_stride=stride)


domain = _DomainNS()


# ---------------------------------------------------------------------------
# Operator factory functions
# ---------------------------------------------------------------------------


def map(input_ref: str, *, func: str, output: str,
        **func_params: Any) -> MapOp:
    """Create a MapOp (element-wise mapping)."""
    return MapOp(
        input_ref=input_ref,
        func=func,
        func_params=func_params,
        output_ref=output,
    )


def reduce(input_ref: str, *, op: str, domain: Domain,
           output: str) -> ReduceOp:
    """Create a ReduceOp (reduction over a domain)."""
    return ReduceOp(
        input_ref=input_ref,
        op=op,
        domain=domain,
        output_ref=output,
    )


def delay(input_ref: str, *, steps: int = 1, output: str) -> DelayOp:
    """Create a DelayOp (single-step delay)."""
    return DelayOp(input_ref=input_ref, steps=steps, output_ref=output)


def shift_reg(input_ref: str, *, taps: list[int],
              output: str) -> ShiftRegOp:
    """Create a ShiftRegOp (tap delay line)."""
    return ShiftRegOp(input_ref=input_ref, taps=taps, output_ref=output)


def message_pass(
    graph_ref: str,
    *,
    node_type: str,
    forward_map: MapOp,
    forward_reduce: ReduceOp,
    schedule: str = "flooding",
    output: str,
) -> MessagePassOp:
    """Create a MessagePassOp (graph message-passing)."""
    return MessagePassOp(
        graph_ref=graph_ref,
        node_type=node_type,
        forward_map=forward_map,
        forward_reduce=forward_reduce,
        schedule=schedule,
        output_ref=output,
    )


__all__ = [
    "FormulaGraph",
    "MapOp",
    "ReduceOp",
    "DelayOp",
    "ShiftRegOp",
    "MessagePassOp",
    "Domain",
    "AnyOp",
    "domain",
    "map",
    "reduce",
    "delay",
    "shift_reg",
    "message_pass",
]
