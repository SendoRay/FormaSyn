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

import yaml

ROOT = Path(__file__).resolve().parent
PARENT = ROOT.parent
if str(PARENT) not in sys.path:
    sys.path.insert(0, str(PARENT))

from FormaSyn.agent.dse_agent import DSEAgent
from FormaSyn.checker.l1_checker import L1Checker
from FormaSyn.codegen.hls_codegen import HLSCodeGenerator
from FormaSyn.dsl.parser import parse
from FormaSyn.dsl.template_engine import TemplateEngine
from FormaSyn.golden.generator import GoldenModelGenerator
from FormaSyn.golden.quant_analyzer import QuantizationAnalyzer
from FormaSyn.solver.roofline_solver import RooflineSolver
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


def _load_constraints(example_name: str) -> dict:
    with (EXAMPLES_DIR / example_name / "constraints.yaml").open() as f:
        return yaml.safe_load(f)


def _build_solver(hw: dict) -> RooflineSolver:
    return RooflineSolver(
        bram_kb=hw["hardware_constraints"]["max_bram_18k"] * 18,
        dsp_count=hw["hardware_constraints"]["max_dsp"],
        freq_mhz=hw["hardware_constraints"]["clock_target_mhz"],
    )


def _summarize_results(intents, passed: list[str]) -> None:
    print(f"\n==> [5/5] 完成：{len(passed)}/{len(intents)} 个变体通过 L1 验证")
    if passed:
        print("    通过的变体：", ", ".join(passed))
        return

    print("    没有变体通过验证，请检查约束或调整参数")
    sys.exit(1)


def run_fir_16tap() -> None:
    print("==> [1/5] 解析算法到 Math Dialect ...")
    graph = build_fir_16tap()
    math_dialect = parse(graph)

    print("==> [2/5] 生成黄金参考模型并分析量化参数 ...")
    gen = GoldenModelGenerator()
    golden_cpp = gen.generate(math_dialect)
    golden_outputs = gen.compile_and_run(golden_cpp, FIR_TEST_INPUTS, math_dialect)
    quant_specs = QuantizationAnalyzer().analyze(gen, math_dialect, FIR_TEST_INPUTS)

    hw = _load_constraints("fir_16tap")
    hw_constraint_text = yaml.dump(hw["hardware_constraints"])

    print("==> [3/5] 调用 LLM 生成硬件变体意图 ...")
    agent = DSEAgent()
    intents = agent.generate_intents(math_dialect, quant_specs, hw_constraint_text)
    print(f"    生成 {len(intents)} 个变体")

    print("==> [4/5] 编译并验证各变体 ...")
    engine = TemplateEngine()
    solver = _build_solver(hw)
    codegen = HLSCodeGenerator()
    checker = L1Checker(
        kernel_type="filtering",
        tolerance=hw["algorithm_metrics"]["tolerance"],
    )

    passed: list[str] = []
    for intent in intents:
        vname = intent["variant_name"]
        algo_hw = engine.render(intent, math_dialect, quant_specs)
        schedule = solver.solve(algo_hw)
        hls_cpp = codegen.generate(schedule)
        result = checker.check(hls_cpp, golden_outputs, FIR_TEST_INPUTS, vname)
        status = "PASS" if result.passed else "FAIL"
        print(f"    [{status}] {vname}  metrics={result.metrics}")
        if result.passed:
            passed.append(vname)

    _summarize_results(intents, passed)


def run_ldpc_cnu(dc: int) -> None:
    print(f"==> [1/5] 解析 LDPC CNU 算法 (dc={dc}) 到 Math Dialect ...")
    graph = build_ldpc_cnu(dc=dc)
    math_dialect = parse(graph)

    test_inputs = get_test_inputs(dc=dc)
    h_matrix = graph.graph_data
    csr_data = {
        "row_ptr": h_matrix.indptr.tolist(),
        "col_idx": h_matrix.indices.tolist(),
    }

    print("==> [2/5] 生成黄金参考模型并分析量化参数 ...")
    gen = GoldenModelGenerator()
    golden_cpp = gen.generate(math_dialect)
    golden_outputs = gen.compile_and_run(
        golden_cpp, test_inputs, math_dialect, csr_data=csr_data
    )
    quant_specs = QuantizationAnalyzer().analyze(
        gen, math_dialect, test_inputs, csr_data=csr_data
    )

    hw = _load_constraints("ldpc_cnu")
    hw_constraint_text = yaml.dump(hw["hardware_constraints"])

    print("==> [3/5] 调用 LLM 生成硬件变体意图 ...")
    agent = DSEAgent()
    intents = agent.generate_intents(math_dialect, quant_specs, hw_constraint_text)
    print(f"    生成 {len(intents)} 个变体")

    print("==> [4/5] 编译并验证各变体 ...")
    engine = TemplateEngine()
    solver = _build_solver(hw)
    codegen = HLSCodeGenerator()
    checker = L1Checker(
        kernel_type="channel_coding",
        tolerance=hw["algorithm_metrics"]["tolerance"],
    )

    passed: list[str] = []
    for intent in intents:
        vname = intent["variant_name"]
        algo_hw = engine.render(intent, math_dialect, quant_specs)
        schedule = solver.solve(algo_hw)
        hls_cpp = codegen.generate(schedule)
        result = checker.check(
            hls_cpp, golden_outputs, test_inputs, vname, csr_data=csr_data
        )
        status = "PASS" if result.passed else "FAIL"
        print(f"    [{status}] {vname}  metrics={result.metrics}")
        if result.passed:
            passed.append(vname)

    _summarize_results(intents, passed)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Run a built-in FormaSyn example")
    subparsers = parser.add_subparsers(dest="example", required=True)

    subparsers.add_parser("fir_16tap", help="Run the FIR 16-tap example")

    ldpc_parser = subparsers.add_parser("ldpc_cnu", help="Run the LDPC CNU example")
    ldpc_parser.add_argument("--dc", type=int, default=8, help="校验节点度数（默认 8）")

    return parser


def main() -> None:
    args = build_parser().parse_args()
    if args.example == "fir_16tap":
        run_fir_16tap()
        return

    if args.example == "ldpc_cnu":
        run_ldpc_cnu(dc=args.dc)
        return

    raise ValueError(f"Unsupported example: {args.example}")


if __name__ == "__main__":
    main()
