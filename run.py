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

from FormaSyn.agent.codegen_agent import ScheduleCodegenAgent
from FormaSyn.agent.dse_agent import DSEAgent, QuantSpec as AgentQuantSpec
from FormaSyn.checker.diagnostic import FailureContext, FailureStage
from FormaSyn.checker.l1_checker import L1Checker
from FormaSyn.checker.l2_checker import L2Checker
from FormaSyn.checker.l3_checker import L3Checker
from FormaSyn.dsl.parser import parse
from FormaSyn.dsl.template_engine import TemplateEngine
from FormaSyn.feedback.deep_loop import DeepLoopGenerator
from FormaSyn.feedback.pragma_tuner import PragmaTuner
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
        enforce_budget=False,
    )


def _build_l2_checker(hw: dict) -> L2Checker:
    h = hw["hardware_constraints"]
    budget = {
        "dsp": h["max_dsp"],
        "bram": h["max_bram_18k"],
    }
    return L2Checker(
        hw_budget=budget,
        target_ii=h.get("target_ii", 1),
        clock_mhz=h.get("clock_target_mhz", 250),
    )


def _build_l3_checker(hw: dict, golden_outputs: dict[str, list[float]]) -> L3Checker:
    return L3Checker(
        kernel_type=_get_kernel_type(hw),
        quality_target=hw.get("algorithm_metrics", {}).get("tolerance", {}),
        golden_outputs=golden_outputs,
    )


def _to_agent_quant_specs(quant_specs: dict) -> dict[str, AgentQuantSpec]:
    """Convert analyzer QuantSpec objects into the DSEAgent prompt format."""
    return {
        node_id: AgentQuantSpec(**spec.to_dse_format())
        for node_id, spec in quant_specs.items()
    }


def _get_kernel_type(hw: dict) -> str:
    return hw.get("algorithm_metrics", {}).get("kernel_type", "filtering")


def _default_failure(stage: FailureStage, variant_id: str, summary: str) -> FailureContext:
    return FailureContext(failed_at=stage, variant_id=variant_id, summary=summary)


def _fallback_intents() -> list[dict[str, object]]:
    """Deterministic local intents when LLM client is unavailable."""
    return [
        {
            "variant_name": "fallback_spa_p1",
            "rationale": "local fallback",
            "approx_method": "spa_exact",
            "scale_factor": 1.0,
            "offset_beta": 0.0,
            "parallelism": 1,
            "quant_overrides": {},
            "enable_saturation": True,
        },
        {
            "variant_name": "fallback_minsum_p4",
            "rationale": "local fallback",
            "approx_method": "min_sum",
            "scale_factor": 1.0,
            "offset_beta": 0.0,
            "parallelism": 4,
            "quant_overrides": {},
            "enable_saturation": True,
        },
        {
            "variant_name": "fallback_offset_p8",
            "rationale": "local fallback",
            "approx_method": "offset_min_sum",
            "scale_factor": 1.0,
            "offset_beta": 0.2,
            "parallelism": 8,
            "quant_overrides": {},
            "enable_saturation": True,
        },
    ]


def _evaluate_variant(
    intent,
    math_dialect,
    quant_specs,
    solver: RooflineSolver,
    engine: TemplateEngine,
    codegen_agent: ScheduleCodegenAgent,
    l1: L1Checker,
    l2: L2Checker,
    l3: L3Checker,
    tuner: PragmaTuner,
    golden_outputs,
    test_inputs,
    *,
    example_name: str,
    csr_data: dict | None = None,
) -> tuple[bool, list[FailureContext]]:
    """Run one variant through L1/L2/L3 and feedback fast-loop."""
    failures: list[FailureContext] = []
    vname = intent["variant_name"]

    algo_hw = engine.render(intent, math_dialect, quant_specs)
    try:
        schedule = solver.solve(algo_hw)
    except ResourceOverflowError as exc:
        print(f"    [FAIL] {vname}  stage=roofline  reason={exc}")
        failures.append(_default_failure(FailureStage.L2_CSYNTH, vname, str(exc)))
        return False, failures

    artifacts = codegen_agent.generate(
        schedule,
        example_name=example_name,
    )
    hls_cpp = artifacts.kernel_cpp
    hls_hdr = artifacts.kernel_h
    print(f"    [ARTIFACT] {vname}  dir={artifacts.output_dir}")

    l1_result = l1.check(
        hls_cpp,
        golden_outputs,
        test_inputs,
        vname,
        csr_data=csr_data,
    )
    if not l1_result.passed:
        print(f"    [FAIL] {vname}  stage=L1  metrics={l1_result.metrics}")
        failures.append(
            l1_result.failure
            or _default_failure(FailureStage.L1_NUMERIC, vname, "L1 failed")
        )
        return False, failures

    l2_result = l2.check(hls_cpp, hls_hdr, vname)
    if not l2_result.passed:
        failure = l2_result.failure
        tuned_schedule = schedule
        retries = 0

        while (
            failure is not None
            and retries < tuner.MAX_RETRIES
        ):
            tuned_schedule, actions = tuner.tune(tuned_schedule, failure)
            if not actions:
                break
            retries += 1
            print(f"    [TUNE] {vname}  retry={retries}  actions={len(actions)}")

            artifacts = codegen_agent.generate(
                tuned_schedule,
                example_name=example_name,
            )
            hls_cpp = artifacts.kernel_cpp
            hls_hdr = artifacts.kernel_h
            print(f"    [ARTIFACT] {vname}  dir={artifacts.output_dir}")
            l2_result = l2.check(hls_cpp, hls_hdr, vname)
            if l2_result.passed:
                break
            failure = l2_result.failure

        if not l2_result.passed:
            print(f"    [FAIL] {vname}  stage=L2")
            failures.append(
                l2_result.failure
                or _default_failure(FailureStage.L2_CSYNTH, vname, "L2 failed")
            )
            return False, failures

    l3_result = l3.check(
        hls_cpp,
        vname,
        test_inputs,
        csr_data=csr_data,
    )
    if not l3_result.passed:
        print(f"    [FAIL] {vname}  stage=L3  metrics={l3_result.quality_metrics}")
        failures.append(
            l3_result.failure
            or _default_failure(FailureStage.L3_QUALITY, vname, "L3 failed")
        )
        return False, failures

    print(
        f"    [PASS] {vname}  "
        f"l1={l1_result.metrics} l3={l3_result.quality_metrics}"
    )
    return True, failures


def _run_with_feedback(
    agent: DSEAgent | None,
    math_dialect,
    quant_specs,
    hw_constraint_text: str,
    solver: RooflineSolver,
    engine: TemplateEngine,
    codegen_agent: ScheduleCodegenAgent,
    l1: L1Checker,
    l2: L2Checker,
    l3: L3Checker,
    golden_outputs,
    test_inputs,
    *,
    example_name: str,
    csr_data: dict | None = None,
) -> tuple[list[str], int, int]:
    """Run intents in iterative deep-loop mode until pass or iteration cap."""
    deep_loop = DeepLoopGenerator()
    tuner = PragmaTuner()
    feedback_text: str | None = None

    passed_variants: list[str] = []
    total_variants = 0
    rounds = 0

    while True:
        rounds += 1
        if agent is None:
            intents = _fallback_intents()
        else:
            intents = agent.generate_intents(
                math_dialect,
                _to_agent_quant_specs(quant_specs),
                hw_constraint_text,
                feedback_text=feedback_text,
            )
        print(f"    Round {rounds}: 生成 {len(intents)} 个变体")
        if not intents:
            break

        round_failures: list[FailureContext] = []
        for intent in intents:
            total_variants += 1
            ok, failures = _evaluate_variant(
                intent,
                math_dialect,
                quant_specs,
                solver,
                engine,
                codegen_agent,
                l1,
                l2,
                l3,
                tuner,
                golden_outputs,
                test_inputs,
                example_name=example_name,
                csr_data=csr_data,
            )
            if ok:
                passed_variants.append(intent["variant_name"])
            else:
                round_failures.extend(failures)

        if passed_variants:
            break

        if agent is None or not round_failures or not deep_loop.can_iterate:
            break

        feedback = deep_loop.generate_feedback(round_failures)
        feedback_text = feedback.feedback_text
        print(
            f"    [DEEP] 进入第 {feedback.iteration} 轮反馈迭代，"
            f"失败样本={len(feedback.failed_variants)}"
        )

    return passed_variants, total_variants, rounds


def _summarize_results(total_variants: int, passed: list[str], rounds: int) -> None:
    print(
        f"\n==> [5/5] 完成：{len(passed)}/{total_variants} 个变体通过"
        f"（rounds={rounds}）"
    )
    if passed:
        print("    通过的变体：", ", ".join(passed))
        return

    print("    没有变体通过验证，请检查约束或调整参数")
    sys.exit(1)


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
    try:
        agent: DSEAgent | None = DSEAgent()
    except Exception as exc:
        print(f"    [WARN] LLM 客户端不可用，使用本地 fallback intents: {exc}")
        agent = None

    print("==> [4/5] 编译并验证各变体（L1/L2/L3 + feedback）...")
    engine = TemplateEngine()
    solver = _build_solver(hw)
    codegen_agent = ScheduleCodegenAgent(artifact_root=EXAMPLES_DIR)
    l1 = L1Checker(
        kernel_type=_get_kernel_type(hw),
        tolerance=hw["algorithm_metrics"]["tolerance"],
    )
    l2 = _build_l2_checker(hw)
    l3 = _build_l3_checker(hw, golden_outputs)

    passed, total_variants, rounds = _run_with_feedback(
        agent,
        math_dialect,
        quant_specs,
        hw_constraint_text,
        solver,
        engine,
        codegen_agent,
        l1,
        l2,
        l3,
        golden_outputs,
        test_inputs,
        example_name=spec.name,
        csr_data=csr_data,
    )

    _summarize_results(total_variants, passed, rounds)


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
