"""Schedule Builder: coarse resource estimation and HLS pragma assignment.

Transforms an AlgoHWDialect into an HLSScheduleDialect by computing
tile sizes, unroll factors, pipeline IIs, array partitioning, and
resource estimates. Acts as the first gate to filter obviously
infeasible design points before expensive Vitis HLS synthesis.
"""

from __future__ import annotations

import logging
import math
import re
from dataclasses import asdict
from typing import ClassVar

from ..ir.algo_hw_dialect import AlgoHWDialect, AlgoHWNode
from ..ir.schedule_dialect import HLSScheduleDialect, ScheduleNode

logger = logging.getLogger(__name__)


class ResourceOverflowError(Exception):
    """Raised when estimated resource usage exceeds the hardware budget."""


_DSP_COST: dict[str, int] = {
    "mul": 2,
    "add": 0,
    "sub": 0,
    "min": 0,
    "max": 0,
    "xor": 0,
    "sign": 0,
    "abs": 0,
}

_BITS_RE = re.compile(r"<\s*(\d+)")
_FIXED_RE = re.compile(r"<\s*(\d+)\s*,\s*(\d+)")


def _parse_total_bits(node: AlgoHWNode) -> int:
    """Extract total bit-width from *data_type* string.

    Supports ``ap_int<W>``, ``ap_fixed<W,I>``, and ``float64`` (mapped to 64).
    For ``ap_fixed<W,I>`` the total bits is W (int_bits + frac_bits combined).
    Falls back to ``quant_int_bits + quant_frac_bits`` when the string cannot
    be parsed.
    """
    dt = node.data_type
    if dt == "float64":
        return 64

    m_fixed = _FIXED_RE.search(dt)
    if m_fixed:
        return int(m_fixed.group(1))

    m_int = _BITS_RE.search(dt)
    if m_int:
        return int(m_int.group(1))

    return node.quant_int_bits + node.quant_frac_bits


def _floor_pow2(n: int) -> int:
    """Return the largest power-of-2 <= *n* (minimum 1)."""
    if n <= 1:
        return 1
    return 1 << (n.bit_length() - 1)


def _op_key(node: AlgoHWNode) -> str:
    """Extract the single operation keyword from *op_detail*."""
    detail = node.op_detail
    return detail.get("op") or detail.get("func") or ""


class ScheduleBuilder:
    """Coarse HLS resource estimator and schedule generator.

    Args:
        bram_kb: Total on-chip BRAM capacity in KiB.
        dsp_count: Number of DSP slices on the target device.
        freq_mhz: Target clock frequency in MHz.
        ddr_bw_gbps: Off-chip DDR bandwidth in GB/s (reserved for future).
    """

    BRAM18_BITS: ClassVar[int] = 18_000

    def __init__(
        self,
        bram_kb: int = 4096,
        dsp_count: int = 1728,
        freq_mhz: int = 250,
        ddr_bw_gbps: float = 19.2,
        enforce_budget: bool = False,
    ) -> None:
        self.bram_kb = bram_kb
        self.dsp_count = dsp_count
        self.freq_mhz = freq_mhz
        self.ddr_bw_gbps = ddr_bw_gbps
        # Roadmap mode: keep schedule generation but skip hard resource gating.
        self.enforce_budget = enforce_budget

    # ------------------------------------------------------------------
    # Internal estimation helpers
    # ------------------------------------------------------------------

    def _compute_tile_size(self, node: AlgoHWNode) -> int:
        """Ping-pong-aware tile size bounded by BRAM capacity."""
        total_bits = _parse_total_bits(node)
        dim0 = node.shape[0] if node.shape else 1
        denominator = 2 * total_bits * dim0
        if denominator == 0:
            return 1
        max_tile = (self.bram_kb * 1024 * 8) // denominator
        return max(_floor_pow2(max_tile), 1)

    def _compute_unroll_factor(self, node: AlgoHWNode) -> int:
        """DSP-budget-aware unroll factor."""
        key = _op_key(node)
        dsp_per_op = _DSP_COST.get(key, 0)
        budget = self.dsp_count // max(1, dsp_per_op)
        uf = min(node.parallelism, budget)
        return max(_floor_pow2(uf), 1)

    def _compute_pipeline_ii(
        self, node: AlgoHWNode, unroll: int,
    ) -> int:
        """Estimated initiation interval.

        Irregular-access nodes get a 2x conservative penalty to account
        for potential BRAM port conflicts not modelled here.
        """
        dim0 = node.shape[0] if node.shape else 1
        if unroll >= dim0:
            ii = 1
        else:
            ii = math.ceil(dim0 / unroll)
        if node.is_irregular_access:
            ii *= 2
        return max(ii, 1)

    def _compute_array_partition(
        self, node: AlgoHWNode, unroll: int,
    ) -> str:
        dim0 = node.shape[0] if node.shape else 1
        if unroll >= dim0:
            return "complete"
        if unroll > 1:
            return "cyclic"
        return "none"

    def _estimate_dsp(self, node: AlgoHWNode, unroll: int) -> int:
        key = _op_key(node)
        cost = _DSP_COST.get(key, 0)
        return cost * unroll

    def _estimate_bram(self, node: AlgoHWNode, tile_size: int) -> int:
        total_bits = _parse_total_bits(node)
        return math.ceil(tile_size * total_bits / self.BRAM18_BITS)

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def solve(self, dialect: AlgoHWDialect) -> HLSScheduleDialect:
        """Transform an AlgoHWDialect into an HLSScheduleDialect.

        Raises:
            ResourceOverflowError: If the estimated DSP or BRAM usage
                exceeds the device budget (with safety margins).
        """
        schedule_nodes: dict[str, ScheduleNode] = {}
        total_dsp = 0
        total_bram = 0
        max_ii = 1

        for nid, node in dialect.nodes.items():
            tile = self._compute_tile_size(node)
            uf = self._compute_unroll_factor(node)
            ii = self._compute_pipeline_ii(node, uf)
            part = self._compute_array_partition(node, uf)
            dsp = self._estimate_dsp(node, uf)
            bram = self._estimate_bram(node, tile)

            base = asdict(node)
            base.pop("quant_int_bits", None)
            base.pop("quant_frac_bits", None)
            base.pop("saturation_guard", None)

            sn = ScheduleNode(
                node_id=node.node_id,
                op_type=node.op_type,
                op_detail=node.op_detail,
                shape=list(node.shape),
                input_nodes=list(node.input_nodes),
                is_irregular_access=node.is_irregular_access,
                csr_ref=node.csr_ref,
                data_type=node.data_type,
                approx_method=node.approx_method,
                parallelism=node.parallelism,
                saturation_guard=node.saturation_guard,
                quant_int_bits=node.quant_int_bits,
                quant_frac_bits=node.quant_frac_bits,
                tile_size=tile,
                unroll_factor=uf,
                pipeline_ii=ii,
                array_partition_type=part,
            )
            schedule_nodes[nid] = sn

            total_dsp += dsp
            total_bram += bram
            max_ii = max(max_ii, ii)

            logger.debug(
                "Node %-16s  UF=%d  II=%d  DSP=%d  BRAM=%d  part=%s",
                nid, uf, ii, dsp, bram, part,
            )

        max_bram18 = (self.bram_kb * 1024 * 8) // self.BRAM18_BITS
        if self.enforce_budget:
            if total_dsp > self.dsp_count * 0.9:
                raise ResourceOverflowError(
                    f"DSP 超限: 估算 {total_dsp}, "
                    f"预算 {int(self.dsp_count * 0.9)} (90% of {self.dsp_count})"
                )
            if total_bram > max_bram18 * 0.8:
                raise ResourceOverflowError(
                    f"BRAM 超限: 估算 {total_bram} 块, "
                    f"预算 {int(max_bram18 * 0.8)} 块 (80% of {max_bram18})"
                )

        schedule = HLSScheduleDialect(
            variant_id=dialect.variant_id,
            nodes=schedule_nodes,
            input_nodes=list(dialect.input_nodes),
            output_nodes=list(dialect.output_nodes),
            total_dsp_estimate=total_dsp,
            total_bram_estimate=total_bram,
            expected_ii=max_ii,
        )

        logger.info(
            "Roofline solved %s: DSP=%d  BRAM=%d  II=%d",
            dialect.variant_id, total_dsp, total_bram, max_ii,
        )
        return schedule

    def report(self, schedule: HLSScheduleDialect) -> str:
        """Generate a Vivado-style text resource report."""
        hdr = f"FormaSyn Roofline Report — {schedule.variant_id}"
        sep = "=" * len(hdr)

        col = (
            f"{'Node':<17}| {'Type':<9}| {'II':>2} "
            f"| {'Unroll':>6} | {'DSP':>3} | {'BRAM':>4} | Partition"
        )
        row_sep = (
            "-" * 17 + "+"
            + "-" * 10 + "+"
            + "-" * 4 + "+"
            + "-" * 8 + "+"
            + "-" * 5 + "+"
            + "-" * 6 + "+"
            + "-" * 10
        )

        rows: list[str] = []
        for nid, sn in schedule.nodes.items():
            dsp = self._estimate_dsp(sn, sn.unroll_factor)
            bram = self._estimate_bram(sn, sn.tile_size or 0)
            rows.append(
                f"{nid:<17}| {sn.op_type:<9}| {sn.pipeline_ii:>2} "
                f"| {sn.unroll_factor:>6} | {dsp:>3} | {bram:>4} "
                f"| {sn.array_partition_type}"
            )

        lines = [
            hdr,
            sep,
            col,
            row_sep,
            *rows,
            row_sep,
            (
                f"{'TOTAL':<17}  {'':9}  {'':>2} "
                f"  {'':>6} | {schedule.total_dsp_estimate:>3} "
                f"| {schedule.total_bram_estimate:>4}"
            ),
            f"Expected II: {schedule.expected_ii}",
        ]
        return "\n".join(lines)
