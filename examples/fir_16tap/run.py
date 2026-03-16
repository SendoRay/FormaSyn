"""Run the FIR 16-tap example end-to-end.

Usage::

    python examples/fir_16tap/run.py
"""

from __future__ import annotations

import logging
import sys
import yaml

from FormaSyn.dsl.parser import parse
from FormaSyn.golden.generator import GoldenModelGenerator
from FormaSyn.golden.quant_analyzer import QuantizationAnalyzer
from FormaSyn.agent.dse_agent import DSEAgent
from FormaSyn.dsl.template_engine import TemplateEngine
from FormaSyn.solver.roofline_solver import RooflineSolver
from FormaSyn.codegen.hls_codegen import HLSCodeGenerator
from FormaSyn.checker.l1_checker import L1Checker

from examples.fir_16tap.kernel import build_fir_16tap

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s: %(message)s")

# ---------------------------------------------------------------------------
# Test inputs: single sample (x_in scalar)
# ---------------------------------------------------------------------------
TEST_INPUTS: dict[str, list[float]] = {
    "x_in": [0.1, 0.3, -0.5, 0.8, 0.2, -0.1, 0.4, 0.6,
             -0.3, 0.7, 0.0, -0.2, 0.5, -0.4, 0.9, -0.6],
}


def main() -> None:
    # 1. Build kernel graph and parse to Math Dialect
    print("==> [1/5] 解析算法到 Math Dialect ...")
    graph = build_fir_16tap()
    math_dialect = parse(graph)

    # 2. Generate golden model and run quantization analysis
    print("==> [2/5] 生成黄金参考模型并分析量化参数 ...")
    gen = GoldenModelGenerator()
    golden_cpp = gen.generate(math_dialect)
    golden_outputs = gen.compile_and_run(golden_cpp, TEST_INPUTS, math_dialect)
    quant_specs = QuantizationAnalyzer().analyze(gen, math_dialect, TEST_INPUTS)

    # 3. Load hardware constraints
    with open("examples/fir_16tap/constraints.yaml") as f:
        hw = yaml.safe_load(f)
    hw_constraint_text = yaml.dump(hw["hardware_constraints"])

    # 4. LLM generates design variants
    print("==> [3/5] 调用 LLM 生成硬件变体意图 ...")
    agent = DSEAgent()
    intents = agent.generate_intents(math_dialect, quant_specs, hw_constraint_text)
    print(f"    生成 {len(intents)} 个变体")

    # 5. For each variant: render → solve → codegen → L1 check
    print("==> [4/5] 编译并验证各变体 ...")
    engine = TemplateEngine()
    solver = RooflineSolver(
        bram_kb=hw["hardware_constraints"]["max_bram_18k"] * 18,
        dsp_count=hw["hardware_constraints"]["max_dsp"],
        freq_mhz=hw["hardware_constraints"]["clock_target_mhz"],
    )
    codegen = HLSCodeGenerator()
    tolerance = hw["algorithm_metrics"]["tolerance"]
    checker = L1Checker(kernel_type="filtering", tolerance=tolerance)

    passed = []
    for intent in intents:
        vname = intent["variant_name"]
        algo_hw = engine.render(intent, math_dialect, quant_specs)
        schedule = solver.solve(algo_hw)
        hls_cpp = codegen.generate(schedule)
        result = checker.check(hls_cpp, golden_outputs, TEST_INPUTS, vname)
        status = "PASS" if result.passed else "FAIL"
        print(f"    [{status}] {vname}  metrics={result.metrics}")
        if result.passed:
            passed.append(vname)

    # 6. Summary
    print(f"\n==> [5/5] 完成：{len(passed)}/{len(intents)} 个变体通过 L1 验证")
    if passed:
        print("    通过的变体：", ", ".join(passed))
    else:
        print("    没有变体通过验证，请检查约束或调整参数")
        sys.exit(1)


if __name__ == "__main__":
    main()
