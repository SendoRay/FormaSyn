"""Run the LDPC CNU example end-to-end.

Usage::

    python examples/ldpc_cnu/run.py
    python examples/ldpc_cnu/run.py --dc 16   # 调整校验节点度数
"""

from __future__ import annotations

import argparse
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

from examples.ldpc_cnu.kernel import build_ldpc_cnu, get_test_inputs

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s: %(message)s")


def main(dc: int = 8) -> None:
    # 1. Build kernel graph and parse to Math Dialect
    print(f"==> [1/5] 解析 LDPC CNU 算法 (dc={dc}) 到 Math Dialect ...")
    graph = build_ldpc_cnu(dc=dc)
    math_dialect = parse(graph)

    # Prepare test inputs and CSR data from the graph's H-matrix
    test_inputs = get_test_inputs(dc=dc)
    H = graph.graph_data
    coo = H.tocoo()
    csr_data = {
        "row_ptr": H.indptr.tolist(),
        "col_idx": H.indices.tolist(),
    }

    # 2. Generate golden model and quantization analysis
    print("==> [2/5] 生成黄金参考模型并分析量化参数 ...")
    gen = GoldenModelGenerator()
    golden_cpp = gen.generate(math_dialect)
    golden_outputs = gen.compile_and_run(
        golden_cpp, test_inputs, math_dialect, csr_data=csr_data
    )
    quant_specs = QuantizationAnalyzer().analyze(
        gen, math_dialect, test_inputs, csr_data=csr_data
    )

    # 3. Load hardware constraints
    with open("examples/ldpc_cnu/constraints.yaml") as f:
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
    checker = L1Checker(kernel_type="channel_coding", tolerance=tolerance)

    passed = []
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

    # 6. Summary
    print(f"\n==> [5/5] 完成：{len(passed)}/{len(intents)} 个变体通过 L1 验证")
    if passed:
        print("    通过的变体：", ", ".join(passed))
    else:
        print("    没有变体通过验证，请检查约束或调整参数")
        sys.exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run LDPC CNU example")
    parser.add_argument("--dc", type=int, default=8, help="校验节点度数（默认 8）")
    args = parser.parse_args()
    main(dc=args.dc)
