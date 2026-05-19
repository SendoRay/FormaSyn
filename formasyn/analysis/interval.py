"""Interval analysis engine for automatic bit-width sizing.

Propagates value ranges through the AlgoHW DAG to determine minimum safe
bit-widths for each node. Replaces the heuristic in quant_analyzer.py with
a sound, deterministic approach.

Key idea:
- Start with known input ranges (e.g. LLR in [-4, 4])
- Topologically sort the DAG
- For each node, compute output range from input ranges + operation semantics
- Derive minimum int_bits and frac_bits to avoid overflow
"""

from __future__ import annotations

import logging
import math
from dataclasses import dataclass, field
from typing import Optional

import numpy as np

from ..ir.math_dialect import MathDialect, MathNode

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class Interval:
    """Closed interval [lo, hi] representing a value range.

    Attributes:
        lo: Lower bound (inclusive).
        hi: Upper bound (inclusive).
    """

    lo: float
    hi: float

    @property
    def magnitude(self) -> float:
        """Maximum absolute value in this interval."""
        return max(abs(self.lo), abs(self.hi))

    @property
    def width(self) -> float:
        """Interval width (hi - lo)."""
        return self.hi - self.lo

    def __contains__(self, value: float) -> bool:
        return self.lo <= value <= self.hi

    def union(self, other: Interval) -> Interval:
        return Interval(min(self.lo, other.lo), max(self.hi, other.hi))

    def intersect(self, other: Interval) -> Optional[Interval]:
        lo = max(self.lo, other.lo)
        hi = min(self.hi, other.hi)
        if lo > hi:
            return None
        return Interval(lo, hi)


@dataclass
class BitWidthRecommendation:
    """Recommended bit-width for a single IR node.

    Attributes:
        node_id: IR node identifier.
        int_bits: Minimum integer bits (including sign bit).
        frac_bits: Minimum fractional bits for target precision.
        total_bits: int_bits + frac_bits.
        range_used: The value interval this recommendation covers.
        precision_target_db: Target quantization NMSE (dB).
    """

    node_id: str
    int_bits: int
    frac_bits: int
    total_bits: int
    range_used: Interval
    precision_target_db: float = -40.0


# ---------------------------------------------------------------------------
# Interval arithmetic for each operation type
# ---------------------------------------------------------------------------

def _interval_add(a: Interval, b: Interval) -> Interval:
    return Interval(a.lo + b.lo, a.hi + b.hi)


def _interval_subtract(a: Interval, b: Interval) -> Interval:
    return Interval(a.lo - b.hi, a.hi - b.lo)


def _interval_multiply(a: Interval, b: Interval) -> Interval:
    products = [a.lo * b.lo, a.lo * b.hi, a.hi * b.lo, a.hi * b.hi]
    return Interval(min(products), max(products))


def _interval_multiply_const(a: Interval, c: float) -> Interval:
    if c >= 0:
        return Interval(a.lo * c, a.hi * c)
    return Interval(a.hi * c, a.lo * c)


def _interval_abs(a: Interval) -> Interval:
    if a.lo >= 0:
        return a
    if a.hi <= 0:
        return Interval(-a.hi, -a.lo)
    return Interval(0.0, max(-a.lo, a.hi))


def _interval_sign(a: Interval) -> Interval:
    lo = -1.0 if a.lo < 0 else (0.0 if a.lo == 0 else 1.0)
    hi = 1.0 if a.hi > 0 else (0.0 if a.hi == 0 else -1.0)
    return Interval(lo, hi)


def _interval_min(intervals: list[Interval]) -> Interval:
    return Interval(
        min(iv.lo for iv in intervals),
        min(iv.hi for iv in intervals),
    )


def _interval_max(intervals: list[Interval]) -> Interval:
    return Interval(
        max(iv.lo for iv in intervals),
        max(iv.hi for iv in intervals),
    )


def _interval_tanh(a: Interval) -> Interval:
    return Interval(math.tanh(a.lo), math.tanh(a.hi))


def _interval_clamp(a: Interval, lo: float, hi: float) -> Interval:
    return Interval(max(a.lo, lo), min(a.hi, hi))


def _interval_reduce_add(a: Interval, count: int) -> Interval:
    """Range of summing `count` values from interval `a`."""
    return Interval(a.lo * count, a.hi * count)


def _interval_reduce_xor(a: Interval) -> Interval:
    """XOR of sign bits: result is -1 or +1."""
    return Interval(-1.0, 1.0)


# ---------------------------------------------------------------------------
# Main engine
# ---------------------------------------------------------------------------

class IntervalAnalyzer:
    """Propagates value intervals through a MathDialect DAG.

    Usage:
        analyzer = IntervalAnalyzer()
        results = analyzer.analyze(math_dialect, input_ranges)
    """

    def __init__(self, precision_target_db: float = -40.0) -> None:
        """
        Args:
            precision_target_db: Target quantization NMSE in dB.
                More negative = stricter precision requirement.
        """
        self._precision_target_db = precision_target_db

    def analyze(
        self,
        dialect: MathDialect,
        input_ranges: dict[str, tuple[float, float]],
    ) -> list[BitWidthRecommendation]:
        """Analyze the entire DAG and recommend bit-widths.

        Args:
            dialect: MathDialect IR to analyze.
            input_ranges: Known value ranges for input nodes.
                E.g. {'msg_in': (-4.0, 4.0)} for LLR inputs.

        Returns:
            List of BitWidthRecommendation for each node.
        """
        # Initialize intervals for input nodes
        node_intervals: dict[str, Interval] = {}
        for node_id, (lo, hi) in input_ranges.items():
            node_intervals[node_id] = Interval(lo, hi)

        # Topological sort
        try:
            dag = dialect.to_dag()
            import networkx as nx
            topo_order = list(nx.topological_sort(dag))
        except Exception:
            topo_order = list(dialect.nodes.keys())

        # Propagate intervals
        for node_id in topo_order:
            if node_id in node_intervals:
                continue
            node = dialect.nodes.get(node_id)
            if node is None:
                continue

            input_intervals = [
                node_intervals.get(inp, Interval(-1.0, 1.0))
                for inp in node.input_nodes
            ]

            if not input_intervals:
                node_intervals[node_id] = Interval(-1.0, 1.0)
                continue

            interval = self._propagate_node(node, input_intervals)
            node_intervals[node_id] = interval

        # Compute bit-width recommendations
        recommendations = []
        for node_id, interval in node_intervals.items():
            node = dialect.nodes.get(node_id)
            if node is None or node.op_type == "input":
                continue
            rec = self._recommend_bitwidth(node_id, interval)
            recommendations.append(rec)

        logger.info(
            "Interval analysis complete: %d nodes analyzed, %d recommendations",
            len(node_intervals), len(recommendations),
        )
        return recommendations

    def _propagate_node(
        self, node: MathNode, input_intervals: list[Interval]
    ) -> Interval:
        """Compute output interval for a single node."""
        inp = input_intervals[0] if input_intervals else Interval(-1.0, 1.0)

        if node.op_type == "map":
            return self._propagate_map(node, inp)
        elif node.op_type == "reduce":
            return self._propagate_reduce(node, inp)
        elif node.op_type == "shift_reg":
            return inp  # Same range as input, just delayed
        elif node.op_type == "delay":
            return inp
        elif node.op_type == "cycle":
            # Conservative: assume feedback can double the range
            return Interval(inp.lo * 2, inp.hi * 2)
        elif node.op_type == "iteration":
            # For pipelined stages, range accumulates
            count = node.op_detail.get("count", 1)
            return Interval(inp.lo * count, inp.hi * count)

        return inp

    def _propagate_map(self, node: MathNode, inp: Interval) -> Interval:
        """Propagate interval through a map operation."""
        func = node.op_detail.get("func", "")

        if func == "sign":
            return _interval_sign(inp)
        elif func == "abs":
            return _interval_abs(inp)
        elif func == "tanh":
            return _interval_tanh(inp)
        elif func == "atanh":
            # atanh is only defined on (-1, 1); clamp input
            clamped = _interval_clamp(inp, -0.999, 0.999)
            return Interval(math.atanh(clamped.lo), math.atanh(clamped.hi))
        elif func == "multiply":
            coeff = node.op_detail.get("func_params", {}).get("coeff", 1.0)
            if isinstance(coeff, (int, float)):
                return _interval_multiply_const(inp, coeff)
            return _interval_multiply(inp, Interval(-abs(coeff), abs(coeff)))
        elif func == "add":
            return _interval_add(inp, inp)
        elif func == "negate":
            return Interval(-inp.hi, -inp.lo)
        elif func == "clamp":
            lo = node.op_detail.get("func_params", {}).get("lo", inp.lo)
            hi = node.op_detail.get("func_params", {}).get("hi", inp.hi)
            return _interval_clamp(inp, lo, hi)
        elif func == "lut":
            # LUT output bounded by table contents; approximate as tanh range
            return Interval(-1.0, 1.0)
        elif func in ("xor_reduce", "gf2_multiply"):
            return Interval(-1.0, 1.0)
        elif func == "cordic":
            return Interval(-1.0, 1.0)
        elif func in ("butterfly", "conj"):
            # Butterfly can grow by sqrt(2); conj preserves magnitude
            return Interval(inp.lo * 1.42, inp.hi * 1.42)

        # Default: preserve range
        return inp

    def _propagate_reduce(self, node: MathNode, inp: Interval) -> Interval:
        """Propagate interval through a reduce operation."""
        op = node.op_detail.get("op", "add")
        shape = node.shape[0] if node.shape else 1

        if op == "add":
            return _interval_reduce_add(inp, shape)
        elif op == "min":
            return inp  # min of N values is still in [lo, hi]
        elif op == "max":
            return inp  # max of N values is still in [lo, hi]
        elif op == "xor":
            return _interval_reduce_xor(inp)
        elif op == "mul":
            # Product of N values in [lo, hi]
            mag = inp.magnitude
            return Interval(-(mag ** shape), mag ** shape)

        return inp

    def _recommend_bitwidth(
        self, node_id: str, interval: Interval
    ) -> BitWidthRecommendation:
        """Derive minimum bit-width from value interval and precision target."""
        magnitude = interval.magnitude
        if magnitude == 0:
            magnitude = 1.0

        # Integer bits: ceil(log2(max_abs + 1)) + 1 for sign
        int_bits = math.ceil(math.log2(magnitude + 1)) + 1
        int_bits = max(int_bits, 2)

        # Fractional bits: from precision target
        # NMSE = -6.02 * frac_bits (approx), so frac_bits = -target / 6.02
        frac_bits = math.ceil(-self._precision_target_db / 6.02)
        frac_bits = max(frac_bits, 2)

        # Cap total at 32 bits
        total = int_bits + frac_bits
        if total > 32:
            frac_bits = 32 - int_bits

        return BitWidthRecommendation(
            node_id=node_id,
            int_bits=int_bits,
            frac_bits=frac_bits,
            total_bits=int_bits + frac_bits,
            range_used=interval,
            precision_target_db=self._precision_target_db,
        )
