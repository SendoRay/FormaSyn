"""FormaSyn 主入口：串联所有模块执行 DSE 流水线。

按照 formasyn.md 定义的流程：
1. 输入阶段：命令行参数 + constraints.yaml + test_data.yaml
2. DSL 到算法 IR：parser.py → MathDialect
3. Golden 基线与量化建议：generator.py + quant_analyzer.py
4. LLM 设计空间探索：dse_agent.py → IntentJSON[]
5. 模板渲染与硬件映射：template_engine.py + roofline_solver.py + mlc_frontend/backend.py
6. 代码生成：codegen_agent.py → HLS C++
7. 三层验证：L1/L2/L3 checker
8. 失败反馈：diagnostic.py + loop.py

Usage::

    python run.py fir_16tap
    python run.py ldpc_cnu --dc 16
    python run.py vec_add
"""

from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path
from dataclasses import dataclass
from typing import Any, Callable

import yaml

ROOT = Path(__file__).resolve().parent

from formasyn.agent.codegen_agent import ScheduleCodegenAgent
from formasyn.agent.diagnostic import RecoveryLayer
from formasyn.agent.dse_agent import DSEAgent
from formasyn.checker.diagnostic import FailureContext, FailureStage
from formasyn.checker.l1_checker import L1Checker
from formasyn.checker.l2_checker import L2Checker
from formasyn.checker.l3_checker import L3Checker
from formasyn.checker.pre_checker import PreChecker
from formasyn.dsl.parser import parse
from formasyn.dsl.template_engine import TemplateEngine
from formasyn.feedback.loop import FeedbackLoop
from formasyn.golden.generator import GoldenModelGenerator
from formasyn.golden.quant_analyzer import QuantizationAnalyzer
from formasyn.mlc import MemoryLayoutPass
from formasyn.solver import ResourceOverflowError, ScheduleBuilder

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s: %(message)s")
logger = logging.getLogger(__name__)

EXAMPLES_DIR = ROOT / "examplesbk"


# ---------------------------------------------------------------------------
# 配置加载
# ---------------------------------------------------------------------------

@dataclass
class ExampleConfig:
    """示例配置：从 constraints.yaml 和 test_data.yaml 加载。"""

    name: str
    constraints: dict
    test_data: dict[str, list[float]]

    @property
    def hardware_constraints(self) -> dict:
        return self.constraints.get("hardware_constraints", {})

    @property
    def algorithm_metrics(self) -> dict:
        return self.constraints.get("algorithm_metrics", {})

    @property
    def kernel_type(self) -> str:
        return self.algorithm_metrics.get("kernel_type", "filtering")

    @property
    def tolerance(self) -> dict:
        return self.algorithm_metrics.get("tolerance", {})


def load_example_config(example_name: str) -> ExampleConfig:
    """加载示例的 constraints.yaml 和 test_data.yaml。"""
    # 加载 constraints.yaml
    constraints_path = EXAMPLES_DIR / example_name / "constraints.yaml"
    if not constraints_path.exists():
        raise FileNotFoundError(f"未找到约束文件: {constraints_path}")

    with constraints_path.open() as f:
        constraints = yaml.safe_load(f)

    # 加载 test_data.yaml
    test_data_path = EXAMPLES_DIR / example_name / "test_data.yaml"
    if not test_data_path.exists():
        raise FileNotFoundError(f"未找到测试数据文件: {test_data_path}")

    with test_data_path.open() as f:
        test_data = yaml.safe_load(f)

    # 处理 test_data 中的场景（如果有）
    if isinstance(test_data, dict) and "test_scenarios" in test_data:
        # 使用默认场景
        for scenario in test_data["test_scenarios"]:
            if scenario.get("scenario") == "default":
                test_data = {k: v for k, v in scenario.items() if k != "scenario"}
                break
        else:
            # 使用第一个场景
            test_data = {k: v for k, v in test_data["test_scenarios"][0].items() if k != "scenario"}

    return ExampleConfig(
        name=example_name,
        constraints=constraints,
        test_data=test_data,
    )


# ---------------------------------------------------------------------------
# Checker 构建
# ---------------------------------------------------------------------------

def build_l1_checker(config: ExampleConfig) -> L1Checker:
    """构建 L1 Checker。"""
    return L1Checker(
        kernel_type=config.kernel_type,
        tolerance=config.tolerance,
    )


def build_l2_checker(config: ExampleConfig) -> L2Checker:
    """构建 L2 Checker。"""
    hw = config.hardware_constraints
    budget = {
        "dsp": hw.get("max_dsp", 999999),
        "bram": hw.get("max_bram_18k", 999999),
    }
    clock_mhz = hw.get("clock_target_mhz", 200)
    return L2Checker(
        hw_budget=budget,
        target_ii=hw.get("target_ii", 1),
        clock_mhz=clock_mhz,
    )


def build_l3_checker(config: ExampleConfig, golden_outputs: dict[str, list[float]]) -> L3Checker:
    """构建 L3 Checker。"""
    return L3Checker(
        kernel_type=config.kernel_type,
        quality_target=config.tolerance,
        golden_outputs=golden_outputs,
    )


# ---------------------------------------------------------------------------
# 主流水线
# ---------------------------------------------------------------------------

@dataclass
class PipelineResult:
    """流水线执行结果。"""

    passed_variants: list[str]
    total_variants: int
    rounds: int
    all_failures: list[FailureContext]


class FormaSynPipeline:
    """FormaSyn DSE 流水线。

    按照 formasyn.md 定义的流程执行：
    1. DSL → MathDialect
    2. MathDialect → Golden + QuantSpec
    3. MathDialect + QuantSpec → IntentJSON[] (via DSEAgent)
    4. IntentJSON → AlgoHWDialect → ScheduleDialect
    5. ScheduleDialect → HLS C++
    6. HLS C++ → L1/L2/L3 验证
    7. 失败 → Diagnostic + Loop 反馈
    """

    def __init__(
        self,
        config: ExampleConfig,
        graph: Any,
        *,
        max_rounds: int = 3,
        use_dse: bool = True,
        force_fallback: bool = False,
    ) -> None:
        """初始化流水线。

        Args:
            config: 示例配置。
            graph: FormulaGraph 输入。
            max_rounds: 最大反馈轮数。
            use_dse: 是否启用 DSE（设计空间探索），False 时仅运行 baseline。
            force_fallback: 强制使用本地模板代码生成（跳过 LLM）。
        """
        self.config = config
        self.graph = graph
        self.max_rounds = max_rounds
        self.use_dse = use_dse
        self.force_fallback = force_fallback

        # 初始化模块
        # 从 constraints 中提取时钟配置
        clock_mhz = config.hardware_constraints.get("clock_target_mhz", 200)
        clock_ns = f"{round(1000.0 / clock_mhz, 2)}ns"
        part = config.hardware_constraints.get("target_device", "xc7z020clg400-1")

        self.pre_checker = PreChecker(
            examples_root=EXAMPLES_DIR,
            part=part,
            clock=clock_ns,
        )
        self.engine = TemplateEngine()
        self.solver = ScheduleBuilder(
            bram_kb=config.hardware_constraints.get("max_bram_18k", 32) * 18,
            dsp_count=config.hardware_constraints.get("max_dsp", 64),
            freq_mhz=config.hardware_constraints.get("clock_target_mhz", 250),
            enforce_budget=False,
        )
        self.mlc = MemoryLayoutPass()
        self.codegen_agent = ScheduleCodegenAgent(artifact_root=EXAMPLES_DIR)

        # 初始化 DSE Agent（如果启用 DSE）
        self.dse_agent: DSEAgent | None = None
        if use_dse:
            try:
                self.dse_agent = DSEAgent(kernel_type=config.kernel_type)
            except Exception as e:
                logger.warning(f"LLM 客户端不可用: {e}，将使用最小可行配置")

    def run(self) -> PipelineResult:
        """执行完整的 DSE 流水线。"""
        logger.info(f"==> [1/7] 解析算法 {self.config.name} 到 Math Dialect ...")
        math_dialect = parse(self.graph)

        # MLC Frontend: 标注不规则访问节点并生成 CSR
        math_dialect = self.mlc.analyze(self.graph, math_dialect)

        # 提取 CSR 数据（如果有）
        csr_data = self._extract_csr_data()

        logger.info("==> [2/7] 生成黄金参考模型并分析量化参数 ...")
        gen = GoldenModelGenerator()
        golden_cpp = gen.generate(math_dialect)
        golden_outputs = gen.compile_and_run(
            golden_cpp, self.config.test_data, math_dialect, csr_data=csr_data
        )
        quant_specs = QuantizationAnalyzer().analyze(
            gen, math_dialect, self.config.test_data, csr_data=csr_data
        )

        logger.info("==> [3/7] 初始化验证流水线 ...")
        l1 = build_l1_checker(self.config)
        l2 = build_l2_checker(self.config)
        l3 = build_l3_checker(self.config, golden_outputs)

        logger.info("==> [4/7] 开始设计空间探索与验证 ...")
        passed_variants: list[str] = []
        all_failures: list[FailureContext] = []
        total_variants = 0
        rounds = 0

        feedback_loop = FeedbackLoop(max_iterations=self.max_rounds)
        feedback_text: str | None = None

        while rounds < self.max_rounds:
            rounds += 1
            logger.info(f"=== Round {rounds} ===")

            intents = self._generate_intents(math_dialect, quant_specs, feedback_text)
            if not intents:
                logger.warning("没有生成任何变体意图，结束流程")
                break

            logger.info(f"生成了 {len(intents)} 个变体意图")

            round_failures: list[FailureContext] = []
            for intent in intents:
                total_variants += 1
                variant_name = intent["variant_name"]
                logger.info(f"  评估变体: {variant_name}")

                success, failure = self._evaluate_variant(
                    intent, math_dialect, quant_specs,
                    l1, l2, l3, feedback_loop,
                    golden_outputs, csr_data,
                )

                if success:
                    passed_variants.append(variant_name)
                    logger.info(f"    [PASS] {variant_name}")
                else:
                    round_failures.append(failure)
                    logger.info(f"    [FAIL] {variant_name}: {failure.summary}")

            all_failures.extend(round_failures)

            if passed_variants:
                break

            if not feedback_loop.can_iterate or self.dse_agent is None:
                break

            feedback_text = feedback_loop.generate_feedback_for_llm(round_failures)
            logger.info("  生成反馈文本，准备下一轮迭代")

        return PipelineResult(
            passed_variants=passed_variants,
            total_variants=total_variants,
            rounds=rounds,
            all_failures=all_failures,
        )

    def _extract_csr_data(self) -> dict[str, list[int]] | None:
        """从 FormulaGraph 中提取 CSR 数据（如果有）。"""
        if hasattr(self.graph, 'graph_data') and self.graph.graph_data is not None:
            h_matrix = self.graph.graph_data
            if hasattr(h_matrix, 'indptr') and hasattr(h_matrix, 'indices'):
                return {
                    "row_ptr": h_matrix.indptr.tolist(),
                    "col_idx": h_matrix.indices.tolist(),
                }
        return None

    def _generate_intents(
        self,
        math_dialect,
        quant_specs,
        feedback_text: str | None = None,
    ) -> list[dict]:
        """生成变体意图。"""
        hw_constraint_text = yaml.dump(self.config.hardware_constraints)

        if self.dse_agent is None:
            return self._get_fallback_intents()

        try:
            intents = self.dse_agent.generate_intents(
                math_dialect,
                quant_specs,
                hw_constraint_text,
                feedback_text=feedback_text,
                max_variants=4,
            )
            if intents:
                return intents
        except Exception as e:
            logger.warning(f"LLM 调用失败: {e}")

        return self._get_fallback_intents()

    def _get_fallback_intents(self) -> list[dict]:
        """LLM 不可用时的确定性变体生成：覆盖多种并行度。"""
        hw = self.config.hardware_constraints
        max_dsp = hw.get("max_dsp", 64)
        # 根据 DSP 预算生成合理的并行度序列
        parallelism_options = [p for p in [1, 2, 4, 8, 16] if p <= max_dsp]

        intents = []
        for p in parallelism_options:
            intents.append({
                "variant_name": f"spa_exact_p{p}",
                "rationale": f"确定性搜索: parallelism={p}",
                "approx_method": "spa_exact",
                "scale_factor": 1.0,
                "offset_beta": 0.0,
                "parallelism": p,
                "quant_overrides": {},
                "enable_saturation": True,
            })
        return intents

    def _evaluate_variant(
        self,
        intent: dict,
        math_dialect,
        quant_specs,
        l1: L1Checker,
        l2: L2Checker,
        l3: L3Checker,
        feedback_loop: FeedbackLoop,
        golden_outputs: dict[str, list[float]],
        csr_data: dict[str, list[int]] | None,
    ) -> tuple[bool, FailureContext | None]:
        """评估单个变体，支持 LLM 智能回退到任意层。"""
        variant_name = intent["variant_name"]
        ir_state: dict = {"intent": intent}

        try:
            success, failure = self._execute_full_flow(
                ir_state, math_dialect, quant_specs,
                l1, l2, l3, golden_outputs, csr_data, variant_name,
            )
            if success:
                return True, None

            # LLM 驱动的恢复循环
            max_recover_attempts = 3
            for attempt in range(max_recover_attempts):
                current_ir = self._get_recovery_ir(ir_state, failure.failed_at)
                loop_result = feedback_loop.recover(current_ir, failure)

                if loop_result.should_deep_loop:
                    logger.info("Agent 决策: 触发深度迭代")
                    return False, failure

                if not loop_result.success or not loop_result.target_layer:
                    logger.warning(f"恢复尝试 {attempt + 1} 失败")
                    return False, failure

                logger.info(
                    "Agent 决策: 从 %s 层恢复，动作: %s",
                    loop_result.target_layer.value,
                    loop_result.actions_taken,
                )

                success, failure = self._re_execute_from(
                    ir_state, loop_result, math_dialect,
                    l1, l2, l3, golden_outputs, csr_data, variant_name,
                )
                if success:
                    logger.info(f"从 {loop_result.target_layer.value} 恢复成功")
                    return True, None

            logger.warning(f"达到最大恢复次数 {max_recover_attempts}")
            return False, failure

        except Exception as e:
            logger.exception(f"评估变体 {variant_name} 时发生异常")
            return False, FailureContext(
                failed_at=FailureStage.L1_COMPILE,
                variant_id=variant_name,
                summary=f"评估异常: {str(e)[:200]}",
            )

    def _get_recovery_ir(self, ir_state: dict, failed_at: FailureStage):
        """根据失败阶段确定应该传递哪个 IR 给 Agent."""
        if failed_at in (FailureStage.L1_COMPILE, FailureStage.L1_NUMERIC):
            return ir_state.get("algo_hw")
        if failed_at == FailureStage.L2_CSYNTH:
            return ir_state.get("schedule") or ir_state.get("algo_hw")
        return ir_state.get("schedule")

    def _execute_full_flow(
        self,
        ir_state: dict,
        math_dialect,
        quant_specs,
        l1: L1Checker,
        l2: L2Checker,
        l3: L3Checker,
        golden_outputs: dict,
        csr_data: dict | None,
        variant_name: str,
    ) -> tuple[bool, FailureContext | None]:
        """执行完整的 template → solver → mlc → codegen → verify 流程."""
        intent = ir_state["intent"]

        # 1. 渲染 AlgoHWDialect
        algo_hw = self.engine.render(intent, math_dialect, quant_specs)
        ir_state["algo_hw"] = algo_hw

        # 2. 求解 ScheduleDialect
        try:
            schedule = self.solver.solve(algo_hw)
        except ResourceOverflowError as exc:
            return False, FailureContext(
                failed_at=FailureStage.L2_CSYNTH,
                variant_id=variant_name,
                summary=f"Roofline 求解失败: {exc}",
            )

        # 2.5. MLC Backend
        schedule = self.mlc.compile(schedule, math_dialect)
        ir_state["schedule"] = schedule

        # 3. 生成 HLS 代码 + 准备环境
        prep_ok, prep_failure = self._codegen_and_prepare(
            ir_state, golden_outputs, csr_data, variant_name,
        )
        if not prep_ok:
            return False, prep_failure

        # 4. L1 → L2 → L3
        return self._verify(ir_state, l1, l2, l3, golden_outputs, csr_data, variant_name)

    def _codegen_and_prepare(
        self,
        ir_state: dict,
        golden_outputs: dict,
        csr_data: dict | None,
        variant_name: str,
        *,
        force_fallback: bool | None = None,
    ) -> tuple[bool, FailureContext | None]:
        """生成 HLS 代码并准备验证环境."""
        schedule = ir_state["schedule"]
        if force_fallback is None:
            force_fallback = self.force_fallback

        artifacts = self.codegen_agent.generate(
            schedule,
            example_name=self.config.name,
            force_fallback=force_fallback,
        )
        ir_state["hls_cpp"] = artifacts.kernel_cpp
        ir_state["hls_hdr"] = artifacts.kernel_h

        pre_result = self.pre_checker.prepare_environment(
            example_name=self.config.name,
            variant_id=variant_name,
            hls_cpp_code=artifacts.kernel_cpp,
            golden_outputs=golden_outputs,
            test_inputs=self.config.test_data,
            csr_data=csr_data,
        )
        if not pre_result.ready:
            return False, FailureContext(
                failed_at=FailureStage.L1_COMPILE,
                variant_id=variant_name,
                summary=f"环境准备失败: {pre_result.error}",
            )
        ir_state["prepared_dir"] = pre_result.output_dir
        return True, None

    def _verify(
        self,
        ir_state: dict,
        l1: L1Checker,
        l2: L2Checker,
        l3: L3Checker,
        golden_outputs: dict,
        csr_data: dict | None,
        variant_name: str,
    ) -> tuple[bool, FailureContext | None]:
        """运行 L1 → L2 → L3 验证流水线."""
        hls_cpp = ir_state["hls_cpp"]
        hls_hdr = ir_state["hls_hdr"]
        prepared_dir = ir_state["prepared_dir"]

        l1_result = l1.check(
            hls_cpp, golden_outputs, self.config.test_data, variant_name,
            csr_data=csr_data, prepared_dir=prepared_dir,
        )
        if not l1_result.passed:
            return False, l1_result.failure or FailureContext(
                failed_at=FailureStage.L1_NUMERIC,
                variant_id=variant_name,
                summary="L1 数值验证失败",
            )

        l2_result = l2.check(hls_cpp, hls_hdr, variant_name, prepared_dir=prepared_dir)
        if not l2_result.passed:
            return False, l2_result.failure or FailureContext(
                failed_at=FailureStage.L2_CSYNTH,
                variant_id=variant_name,
                summary="L2 综合失败",
            )

        l3_result = l3.check(
            hls_cpp, variant_name, self.config.test_data,
            hls_header_code=hls_hdr, csr_data=csr_data,
        )
        if not l3_result.passed:
            return False, l3_result.failure or FailureContext(
                failed_at=FailureStage.L3_QUALITY,
                variant_id=variant_name,
                summary="L3 质量验证失败",
            )

        return True, None

    def _re_execute_from(
        self,
        ir_state: dict,
        loop_result,
        math_dialect,
        l1: L1Checker,
        l2: L2Checker,
        l3: L3Checker,
        golden_outputs: dict,
        csr_data: dict | None,
        variant_name: str,
    ) -> tuple[bool, FailureContext | None]:
        """从指定层重新执行: solver → mlc → codegen → verify."""
        target = loop_result.target_layer
        new_ir = loop_result.new_ir

        try:
            if target in (RecoveryLayer.TEMPLATE_ENGINE, RecoveryLayer.ROOFLINE_SOLVER):
                # 需要重新求解 schedule
                ir_state["algo_hw"] = new_ir
                schedule = self.solver.solve(new_ir)
                schedule = self.mlc.compile(schedule, math_dialect)
                ir_state["schedule"] = schedule
            else:
                # MLC_BACKEND / CODEGEN_AGENT: Agent 已修改 schedule
                ir_state["schedule"] = new_ir

            # 重新生成代码 + 准备环境
            prep_ok, prep_failure = self._codegen_and_prepare(
                ir_state, golden_outputs, csr_data, variant_name,
                force_fallback=False,
            )
            if not prep_ok:
                return False, prep_failure

            return self._verify(ir_state, l1, l2, l3, golden_outputs, csr_data, variant_name)

        except ResourceOverflowError as exc:
            return False, FailureContext(
                failed_at=FailureStage.L2_CSYNTH,
                variant_id=variant_name,
                summary=f"Roofline 求解失败: {exc}",
            )
        except Exception as e:
            logger.exception(f"从 {target.value} 恢复时发生异常")
            return False, FailureContext(
                failed_at=FailureStage.L1_COMPILE,
                variant_id=variant_name,
                summary=f"恢复异常: {str(e)[:200]}",
            )


def summarize_results(result: PipelineResult) -> None:
    """汇总并打印结果。"""
    print(f"\n==> [7/7] 完成：{len(result.passed_variants)}/{result.total_variants} 个变体通过 (rounds={result.rounds})")

    if result.passed_variants:
        print("    通过的变体：", ", ".join(result.passed_variants))
        return

    print("    没有变体通过验证")
    if result.all_failures:
        print("\n    失败汇总：")
        for failure in result.all_failures[:5]:  # 只显示前5个
            print(f"      - [{failure.failed_at.value}] {failure.variant_id}: {failure.summary}")
        if len(result.all_failures) > 5:
            print(f"      ... 还有 {len(result.all_failures) - 5} 个失败")

    sys.exit(1)


# ---------------------------------------------------------------------------
# 命令行接口
# ---------------------------------------------------------------------------

def _add_ldpc_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--dc", type=int, default=8, help="校验节点度数（默认 8）")


def _import_and_build(example_name: str, func_name: str, **kwargs) -> Any:
    """动态导入并调用示例的 build 函数。"""
    module = __import__(
        f"examples.{example_name}.kernel",
        fromlist=[func_name],
    )
    func = getattr(module, func_name)
    return func(**kwargs)


@dataclass(frozen=True)
class ExampleSpec:
    """示例规格。"""

    name: str
    build_graph: Callable[[argparse.Namespace], Any]
    add_arguments: Callable[[argparse.ArgumentParser], None] | None = None


EXAMPLE_SPECS: dict[str, ExampleSpec] = {
    "fir_16tap": ExampleSpec(
        name="fir_16tap",
        build_graph=lambda args: _import_and_build("fir_16tap", "build_fir_16tap"),
    ),
    "ldpc_cnu": ExampleSpec(
        name="ldpc_cnu",
        build_graph=lambda args: _import_and_build("ldpc_cnu", "build_ldpc_cnu", dc=args.dc),
        add_arguments=_add_ldpc_args,
    ),
    "vec_add": ExampleSpec(
        name="vec_add",
        build_graph=lambda args: _import_and_build("vec_add", "build_vec_add"),
    ),
    "fft_radix2": ExampleSpec(
        name="fft_radix2",
        build_graph=lambda args: _import_and_build("fft_radix2", "build_fft_radix2"),
    ),
    "qpsk_demod": ExampleSpec(
        name="qpsk_demod",
        build_graph=lambda args: _import_and_build("qpsk_demod", "build_qpsk_demod"),
    ),
    "matched_filter": ExampleSpec(
        name="matched_filter",
        build_graph=lambda args: _import_and_build("matched_filter", "build_matched_filter"),
    ),
    "timing_recovery": ExampleSpec(
        name="timing_recovery",
        build_graph=lambda args: _import_and_build("timing_recovery", "build_timing_recovery"),
    ),
}


def build_parser() -> argparse.ArgumentParser:
    """构建命令行参数解析器。"""
    parser = argparse.ArgumentParser(description="FormaSyn FPGA 编译器")
    parser.add_argument(
        "--baseline",
        action="store_true",
        help="仅运行 baseline 配置，不进行设计空间探索",
    )
    parser.add_argument(
        "--max-rounds",
        type=int,
        default=3,
        help="最大反馈迭代轮数（默认 3）",
    )
    parser.add_argument(
        "--force-fallback",
        action="store_true",
        help="强制使用本地模板代码生成（跳过 LLM）",
    )

    subparsers = parser.add_subparsers(dest="example", required=True)

    for name, spec in EXAMPLE_SPECS.items():
        parser_i = subparsers.add_parser(name, help=f"运行 {name} 示例")
        if spec.add_arguments is not None:
            spec.add_arguments(parser_i)

    return parser


def main() -> None:
    """主入口。"""
    args = build_parser().parse_args()
    spec = EXAMPLE_SPECS.get(args.example)
    if spec is None:
        raise ValueError(f"不支持的示例: {args.example}")

    # 加载配置
    config = load_example_config(spec.name)

    # 构建 FormulaGraph
    graph = spec.build_graph(args)

    # 运行流水线
    pipeline = FormaSynPipeline(
        config=config,
        graph=graph,
        max_rounds=args.max_rounds,
        use_dse=not args.baseline,
        force_fallback=args.force_fallback,
    )

    result = pipeline.run()
    summarize_results(result)


if __name__ == "__main__":
    main()
