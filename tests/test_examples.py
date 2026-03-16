"""End-to-end example test: FIR 16-tap kernel through all three Dialect levels.

Run with ``pytest -s`` to see the pretty-printed Dialect snapshots.
"""

from __future__ import annotations

import json
import textwrap
from dataclasses import asdict

import networkx as nx
import pytest

from FormaSyn.dsl.parser import parse
from FormaSyn.examples.fir_16tap.kernel import COEFFS, build_fir_16tap
from FormaSyn.ir.algo_hw_dialect import AlgoHWDialect, AlgoHWNode
from FormaSyn.ir.math_dialect import MathDialect, MathNode
from FormaSyn.ir.schedule_dialect import HLSScheduleDialect, ScheduleNode


# ── helpers ───────────────────────────────────────────────────────────────


def _pretty_json(obj: object) -> str:
    """Compact but readable JSON dump of a dataclass tree."""
    return json.dumps(asdict(obj), indent=2, default=str)  # type: ignore[arg-type]


def _section(title: str) -> None:
    width = 72
    print(f"\n{'=' * width}")
    print(f"  {title}")
    print(f"{'=' * width}")


# ── lowering helpers (simulated, will be replaced by Solver / MLC) ────────


def _lower_math_to_algohw(
    md: MathDialect,
    *,
    data_type: str = "ap_fixed<16,4>",
    parallelism: int = 16,
    quant_int: int = 4,
    quant_frac: int = 12,
) -> AlgoHWDialect:
    """Simulate the Math → Algo-HW lowering for a FIR kernel.

    In the real system this is driven by LLM intent JSON + Roofline Solver.
    Here we hard-code a single "full-parallel, 16-bit fixed-point" variant.
    """
    nodes: dict[str, AlgoHWNode] = {}
    for nid, mn in md.nodes.items():
        nodes[nid] = AlgoHWNode(
            node_id=mn.node_id,
            op_type=mn.op_type,
            op_detail=dict(mn.op_detail),
            shape=list(mn.shape),
            input_nodes=list(mn.input_nodes),
            is_irregular_access=mn.is_irregular_access,
            csr_ref=mn.csr_ref,
            data_type=data_type,
            approx_method=None,
            parallelism=parallelism,
            saturation_guard=True,
            quant_int_bits=quant_int,
            quant_frac_bits=quant_frac,
        )
    return AlgoHWDialect(
        variant_id=f"fir16_fix{quant_int + quant_frac}_p{parallelism}",
        parent_kernel_name=md.kernel_name,
        nodes=nodes,
        intent_json={
            "quantization": {"int_bits": quant_int, "frac_bits": quant_frac},
            "parallelism": parallelism,
            "symmetric_folding": False,
        },
        input_nodes=list(md.input_nodes),
        output_nodes=list(md.output_nodes),
        estimated_dsp=parallelism,
        estimated_bram=0,
    )


def _lower_algohw_to_schedule(ahd: AlgoHWDialect) -> HLSScheduleDialect:
    """Simulate the Algo-HW → HLS-Schedule lowering.

    In the real system this is driven by Roofline Solver + MLC backend.
    """
    nodes: dict[str, ScheduleNode] = {}
    for nid, an in ahd.nodes.items():
        part_type = "none"
        if an.op_type == "shift_reg":
            part_type = "complete"
        elif an.op_type in ("map", "reduce"):
            part_type = "complete" if an.parallelism >= 8 else "cyclic"

        nodes[nid] = ScheduleNode(
            node_id=an.node_id,
            op_type=an.op_type,
            op_detail=dict(an.op_detail),
            shape=list(an.shape),
            input_nodes=list(an.input_nodes),
            is_irregular_access=an.is_irregular_access,
            csr_ref=an.csr_ref,
            data_type=an.data_type,
            approx_method=an.approx_method,
            parallelism=an.parallelism,
            saturation_guard=an.saturation_guard,
            quant_int_bits=an.quant_int_bits,
            quant_frac_bits=an.quant_frac_bits,
            tile_size=None,
            unroll_factor=an.parallelism,
            pipeline_ii=1,
            array_partition_type=part_type,
            bram_banks=0,
            address_mapping_code=None,
        )

    total_dsp = ahd.estimated_dsp or 0
    return HLSScheduleDialect(
        variant_id=ahd.variant_id,
        nodes=nodes,
        input_nodes=list(ahd.input_nodes),
        output_nodes=list(ahd.output_nodes),
        total_dsp_estimate=total_dsp,
        total_bram_estimate=0,
        expected_ii=1,
    )


# ── tests ─────────────────────────────────────────────────────────────────


class TestFIR16TapPipeline:
    """Build the FIR-16 kernel from DSL, lower it through all three dialects,
    and verify + pretty-print each stage."""

    # ---- Stage 0: DSL ----

    def test_00_dsl_construction(self) -> None:
        graph = build_fir_16tap()
        assert graph.name == "fir_16tap"
        assert len(graph.ops) == 3

        _section("Stage 0: DSL FormulaGraph")
        print(f"  kernel  : {graph.name}")
        print(f"  inputs  : {graph.inputs}")
        print(f"  outputs : {graph.outputs}")
        print(f"  #ops    : {len(graph.ops)}")
        for i, op in enumerate(graph.ops):
            print(f"  op[{i}]   : {type(op).__name__:16s} "
                  f"in={getattr(op, 'input_ref', 'N/A'):12s} "
                  f"out={op.output_ref}")

    # ---- Stage 1: Math Dialect ----

    def test_01_math_dialect(self) -> None:
        graph = build_fir_16tap()
        md = parse(graph)

        assert md.kernel_name == "fir_16tap"
        assert len(md.nodes) == 4  # x_in + 3 ops
        dag = md.to_dag()
        assert nx.is_directed_acyclic_graph(dag)
        assert dag.number_of_edges() == 3

        _section("Stage 1: Math Dialect  (pure math, no HW info)")
        print(_pretty_json(md))
        print()
        print("  DAG edges:")
        for u, v in dag.edges():
            print(f"    {u} --> {v}")

    # ---- Stage 2: Algo-HW Dialect ----

    def test_02_algo_hw_dialect(self) -> None:
        graph = build_fir_16tap()
        md = parse(graph)
        ahd = _lower_math_to_algohw(md)

        assert ahd.variant_id == "fir16_fix16_p16"
        assert ahd.estimated_dsp == 16
        for node in ahd.nodes.values():
            assert node.data_type == "ap_fixed<16,4>"

        _section("Stage 2: Algo-HW Dialect  (+ data types & parallelism)")
        print(_pretty_json(ahd))

    # ---- Stage 3: HLS-Schedule Dialect ----

    def test_03_schedule_dialect(self) -> None:
        graph = build_fir_16tap()
        md = parse(graph)
        ahd = _lower_math_to_algohw(md)
        hsd = _lower_algohw_to_schedule(ahd)

        assert hsd.expected_ii == 1
        assert hsd.total_dsp_estimate == 16
        assert hsd.nodes["taps"].array_partition_type == "complete"
        assert hsd.nodes["products"].unroll_factor == 16

        _section("Stage 3: HLS-Schedule Dialect  (+ pragmas & partition)")
        print(_pretty_json(hsd))

    # ---- Variant: Symmetric Folding (half DSP) ----

    def test_04_symmetric_folding_variant(self) -> None:
        """Show what happens when LLM discovers symmetric coefficients
        and proposes half-parallelism (8 DSPs instead of 16)."""
        graph = build_fir_16tap()
        md = parse(graph)
        ahd_folded = _lower_math_to_algohw(md, parallelism=8)
        ahd_folded.variant_id = "fir16_fix16_p8_symm"
        ahd_folded.intent_json["symmetric_folding"] = True
        ahd_folded.estimated_dsp = 8
        hsd_folded = _lower_algohw_to_schedule(ahd_folded)

        assert hsd_folded.total_dsp_estimate == 8
        assert hsd_folded.nodes["products"].unroll_factor == 8

        _section("Stage 3 (variant): Symmetric Folding  (8 DSPs)")
        print(_pretty_json(hsd_folded))

    # ---- Summary comparison ----

    def test_05_variant_comparison(self) -> None:
        """Side-by-side comparison of full-parallel vs symmetric-folded."""
        graph = build_fir_16tap()
        md = parse(graph)

        full = _lower_algohw_to_schedule(_lower_math_to_algohw(md, parallelism=16))
        folded_ahd = _lower_math_to_algohw(md, parallelism=8)
        folded_ahd.estimated_dsp = 8
        folded = _lower_algohw_to_schedule(folded_ahd)

        _section("Variant Comparison")
        header = f"{'':20s} {'Full Parallel':>16s}  {'Sym Folded':>16s}"
        print(header)
        print("-" * len(header))
        print(f"{'variant_id':20s} {full.variant_id:>16s}  {folded_ahd.variant_id:>16s}")
        print(f"{'DSP estimate':20s} {full.total_dsp_estimate:>16d}  {folded.total_dsp_estimate:>16d}")
        print(f"{'BRAM estimate':20s} {full.total_bram_estimate:>16d}  {folded.total_bram_estimate:>16d}")
        print(f"{'expected II':20s} {full.expected_ii:>16d}  {folded.expected_ii:>16d}")
        print(f"{'unroll(products)':20s} "
              f"{full.nodes['products'].unroll_factor:>16d}  "
              f"{folded.nodes['products'].unroll_factor:>16d}")
        print(f"{'partition(taps)':20s} "
              f"{full.nodes['taps'].array_partition_type:>16s}  "
              f"{folded.nodes['taps'].array_partition_type:>16s}")
