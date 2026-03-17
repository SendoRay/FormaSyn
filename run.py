"""Unified entry point for built-in FormaSyn examples.

Usage::

    python run.py fir_16tap
    python run.py ldpc_cnu
    python run.py ldpc_cnu --dc 16
"""

from __future__ import annotations

import argparse
import logging
from pathlib import Path
import sys
from dataclasses import dataclass
from typing import Any, Callable

import yaml

ROOT = Path(__file__).resolve().parent
PARENT = ROOT.parent
if str(PARENT) not in sys.path:
    sys.path.insert(0, str(PARENT))

from FormaSyn.agent.dse_agent import DSEAgent, QuantSpec as AgentQuantSpec
from FormaSyn.checker.l1_checker import L1Checker
from FormaSyn.codegen.hls_codegen import HLSCodeGenerator
from FormaSyn.dsl.parser import parse
from FormaSyn.dsl.template_engine import TemplateEngine
from FormaSyn.golden.generator import GoldenModelGenerator
from FormaSyn.golden.quant_analyzer import QuantizationAnalyzer
from FormaSyn.solver.roofline_solver import ResourceOverflowError, RooflineSolver
from examples.fir_16tap.kernel import build_fir_16tap
from examples.ldpc_cnu.kernel import build_ldpc_cnu, get_test_inputs

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s: %(message)s")

EXAMPLES_DIR = ROOT / "examples"

FIR_TEST_INPUTS: dict[str, list[float]] = {
    "x_in": [
        0.1, 0.3, -0.5, 0.8, 0.2, -0.1, 0.4, 0.6,
        -0.3, 0.7, 0.0, -0.2, 0.5, -0.4, 0.9, -0.6,
    ],
}


@dataclass(frozen=True)
class ExampleSpec:
    """Per-example hooks consumed by the shared execution pipeline."""

    name: str
    build_graph: Callable[[argparse.Namespace], Any]
    get_test_inputs: Callable[[argparse.Namespace], dict[str, list[float]]]
    add_arguments: Callable[[argparse.ArgumentParser], None] | None = None
    get_csr_data: Callable[[Any], dict[str, list[int]] | None] | None = None


def _load_constraints(example_name: str) -> dict:
    with (EXAMPLES_DIR / example_name / "constraints.yaml").open() as f:
        return yaml.safe_load(f)


def _build_solver(hw: dict) -> RooflineSolver:
    return RooflineSolver(
        bram_kb=hw["hardware_constraints"]["max_bram_18k"] * 18,
        dsp_count=hw["hardware_constraints"]["max_dsp"],
        freq_mhz=hw["hardware_constraints"]["clock_target_mhz"],
    )


def _to_agent_quant_specs(quant_specs: dict) -> dict[str, AgentQuantSpec]:
    """Convert analyzer QuantSpec objects into the DSEAgent prompt format."""
    return {
        node_id: AgentQuantSpec(**spec.to_dse_format())
        for node_id, spec in quant_specs.items()
    }


def _summarize_results(intents, passed: list[str]) -> None:
    print(f"\n==> [5/5] 完成：{len(passed)}/{len(intents)} 个变体通过 L1 验证")
    if passed:
        print("    通过的变体：", ", ".join(passed))
        return

    print("    没有变体通过验证，请检查约束或调整参数")
    sys.exit(1)


def _get_kernel_type(hw: dict) -> str:
    return hw.get("algorithm_metrics", {}).get("kernel_type", "filtering")


def _run_variant_batch(
    intents,
    math_dialect,
    quant_specs,
    solver: RooflineSolver,
    engine: TemplateEngine,
    codegen: HLSCodeGenerator,
    checker: L1Checker,
    golden_outputs,
    test_inputs,
    *,
    csr_data: dict | None = None,
) -> list[str]:
    """Evaluate each variant independently and continue on per-variant failures."""
    passed: list[str] = []
    for intent in intents:
        vname = intent["variant_name"]
        algo_hw = engine.render(intent, math_dialect, quant_specs)
        try:
            schedule = solver.solve(algo_hw)
        except ResourceOverflowError as exc:
            print(f"    [SKIP] {vname}  reason={exc}")
            continue

        hls_cpp = codegen.generate(schedule)
        if csr_data is None:
            result = checker.check(hls_cpp, golden_outputs, test_inputs, vname)
        else:
            result = checker.check(
                hls_cpp, golden_outputs, test_inputs, vname, csr_data=csr_data
            )

        status = "PASS" if result.passed else "FAIL"
        print(f"    [{status}] {vname}  metrics={result.metrics}")
        if result.passed:
            passed.append(vname)

    return passed


def run_example(spec: ExampleSpec, args: argparse.Namespace) -> None:
    parse_desc = f"解析算法 {spec.name}"
    if spec.name == "ldpc_cnu":
        parse_desc += f" (dc={args.dc})"
    print(f"==> [1/5] {parse_desc} 到 Math Dialect ...")

    graph = spec.build_graph(args)
    math_dialect = parse(graph)
    test_inputs = spec.get_test_inputs(args)
    csr_data = spec.get_csr_data(graph) if spec.get_csr_data else None

    print("==> [2/5] 生成黄金参考模型并分析量化参数 ...")
    gen = GoldenModelGenerator()
    golden_cpp = gen.generate(math_dialect)
    golden_outputs = gen.compile_and_run(
        golden_cpp, test_inputs, math_dialect, csr_data=csr_data
    )
    quant_specs = QuantizationAnalyzer().analyze(
        gen, math_dialect, test_inputs, csr_data=csr_data
    )

    hw = _load_constraints(spec.name)
    hw_constraint_text = yaml.dump(hw["hardware_constraints"])

    print("==> [3/5] 调用 LLM 生成硬件变体意图 ...")
    agent = DSEAgent()
    agent_quant_specs = _to_agent_quant_specs(quant_specs)
    intents = agent.generate_intents(
        math_dialect, agent_quant_specs, hw_constraint_text,
    )
    print(f"    生成 {len(intents)} 个变体")

    print("==> [4/5] 编译并验证各变体 ...")
    engine = TemplateEngine()
    solver = _build_solver(hw)
    codegen = HLSCodeGenerator()
    checker = L1Checker(
        kernel_type=_get_kernel_type(hw),
        tolerance=hw["algorithm_metrics"]["tolerance"],
    )

    passed = _run_variant_batch(
        intents,
        math_dialect,
        quant_specs,
        solver,
        engine,
        codegen,
        checker,
        golden_outputs,
        test_inputs,
        csr_data=csr_data,
    )

    _summarize_results(intents, passed)


def _add_ldpc_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--dc", type=int, default=8, help="校验节点度数（默认 8）")


def _build_ldpc_graph(args: argparse.Namespace):
    return build_ldpc_cnu(dc=args.dc)


def _get_ldpc_inputs(args: argparse.Namespace) -> dict[str, list[float]]:
    return get_test_inputs(dc=args.dc)


def _get_ldpc_csr_data(graph) -> dict[str, list[int]]:
    h_matrix = graph.graph_data
    return {
        "row_ptr": h_matrix.indptr.tolist(),
        "col_idx": h_matrix.indices.tolist(),
    }


EXAMPLE_SPECS: dict[str, ExampleSpec] = {
    "fir_16tap": ExampleSpec(
        name="fir_16tap",
        build_graph=lambda args: build_fir_16tap(),
        get_test_inputs=lambda args: FIR_TEST_INPUTS,
    ),
    "ldpc_cnu": ExampleSpec(
        name="ldpc_cnu",
        build_graph=_build_ldpc_graph,
        get_test_inputs=_get_ldpc_inputs,
        add_arguments=_add_ldpc_args,
        get_csr_data=_get_ldpc_csr_data,
    ),
}


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Run a built-in FormaSyn example")
    subparsers = parser.add_subparsers(dest="example", required=True)

    for name, spec in EXAMPLE_SPECS.items():
        parser_i = subparsers.add_parser(name, help=f"Run the {name} example")
        if spec.add_arguments is not None:
            spec.add_arguments(parser_i)

    return parser


def main() -> None:
    args = build_parser().parse_args()
    spec = EXAMPLE_SPECS.get(args.example)
    if spec is None:
        raise ValueError(f"Unsupported example: {args.example}")
    run_example(spec, args)


if __name__ == "__main__":
    main()
