"""Agent Diagnostic: 解析 HLS 报告 / Quality结果 → 高层归因文本 + 修改决策.

本模块负责：
1. 解析 HLS 报告和质量结果，生成高层归因文本（给 LLM）
2. 决定新的参数值（如何修改）
3. 决定回退到哪一层（去哪里修改）
4. 构造回退输入（给到 feedback/loop.py）

与 checker/diagnostic.py 的区别：
- checker/diagnostic.py：基础诊断函数，被 L1/L2/L3 checker 调用
- agent/diagnostic.py：Agent 诊断决策模块，被 feedback/loop.py 调用
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Optional

from FormaSyn.formasyn.checker.diagnostic import FailureContext, FailureStage

logger = logging.getLogger(__name__)


class RecoveryLayer(str, Enum):
    """回退目标层：决定将修改后的参数送回哪一层."""

    TEMPLATE_ENGINE = "template_engine"  # 量化参数调整
    ROOFLINE_SOLVER = "roofline_solver"  # 并行度/位宽调整
    MLC_BACKEND = "mlc_backend"  # BRAM tiling/bank 调整
    CODEGEN_AGENT = "codegen_agent"  # pragma 调整
    DSE_AGENT = "dse_agent"  # 触发新一轮 LLM 探索


@dataclass
class RecoveryAction:
    """恢复动作：描述如何修改 IR.

    Attributes:
        layer: 目标层（RecoveryLayer）.
        action_type: 动作类型（relax_quant, reduce_parallelism, adjust_tiling, tune_pragma）.
        params: 动作参数.
        rationale: 原因说明.
    """

    layer: RecoveryLayer
    action_type: str
    params: dict[str, Any] = field(default_factory=dict)
    rationale: str = ""


@dataclass
class DiagnosticResult:
    """诊断结果：包含归因文本和恢复动作.

    Attributes:
        failure: 原始失败上下文.
        feedback_text: 给 LLM 的归因文本.
        recovery_action: 恢复动作（决定如何修改、回退到哪一层）.
        should_deep_loop: 是否需要触发深度迭代（回 DSE Agent）.
    """

    failure: FailureContext
    feedback_text: str
    recovery_action: Optional[RecoveryAction] = None
    should_deep_loop: bool = False


class AgentDiagnostic:
    """Agent 诊断决策模块.

    根据 FailureContext 分析失败原因，决定：
    1. 如何修改（量化参数、并行度、tiling、pragma）
    2. 回退到哪一层（template_engine, roofline_solver, mlc_backend, codegen_agent, dse_agent）
    3. 是否需要深度迭代（触发 LLM 重新探索）
    """

    def diagnose(self, failure: FailureContext) -> DiagnosticResult:
        """诊断失败并生成恢复动作.

        Args:
            failure: 失败上下文.

        Returns:
            DiagnosticResult，包含反馈文本和恢复动作.
        """
        # 根据失败阶段分发到不同的诊断逻辑
        if failure.failed_at == FailureStage.L1_NUMERIC:
            return self._diagnose_l1_numeric(failure)
        elif failure.failed_at == FailureStage.L2_CSYNTH:
            return self._diagnose_l2_csynth(failure)
        elif failure.failed_at == FailureStage.L3_QUALITY:
            return self._diagnose_l3_quality(failure)
        else:
            # 编译错误等无法自动恢复的失败
            return DiagnosticResult(
                failure=failure,
                feedback_text=self._generate_compile_feedback(failure),
                should_deep_loop=True,  # 触发 LLM 重新探索
            )

    def _diagnose_l1_numeric(self, failure: FailureContext) -> DiagnosticResult:
        """诊断 L1 数值错误.

        判断是否可以通过放宽量化参数恢复，或者需要深度迭代。
        """
        # 检查符号错误率
        sign_error_rate = failure.measured_metrics.get("sign_error_rate", 0)
        nmse_db = failure.measured_metrics.get("nmse_db", 0)

        # 如果符号错误率高，可能是位宽不足
        if sign_error_rate > 0.01:
            return DiagnosticResult(
                failure=failure,
                feedback_text=self._generate_l1_feedback(failure),
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.TEMPLATE_ENGINE,
                    action_type="relax_quant",
                    params={
                        "int_bits_increment": 1,
                        "frac_bits_increment": 2,
                    },
                    rationale=f"符号错误率 {sign_error_rate:.4f} 过高，放宽量化位宽",
                ),
                should_deep_loop=False,
            )

        # 如果 NMSE 过高，但符号错误率低，可能是小数精度不足
        if nmse_db > -20:
            return DiagnosticResult(
                failure=failure,
                feedback_text=self._generate_l1_feedback(failure),
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.TEMPLATE_ENGINE,
                    action_type="relax_quant",
                    params={
                        "frac_bits_increment": 3,
                    },
                    rationale=f"NMSE {nmse_db:.2f} dB 过高，增加小数位宽",
                ),
                should_deep_loop=False,
            )

        # 轻微数值错误，尝试微调
        return DiagnosticResult(
            failure=failure,
            feedback_text=self._generate_l1_feedback(failure),
            recovery_action=RecoveryAction(
                layer=RecoveryLayer.TEMPLATE_ENGINE,
                action_type="fine_tune_quant",
                params={
                    "frac_bits_increment": 1,
                },
                rationale=f"轻微数值误差，微调量化参数",
            ),
            should_deep_loop=False,
        )

    def _diagnose_l2_csynth(self, failure: FailureContext) -> DiagnosticResult:
        """诊断 L2 综合/资源失败.

        根据超限的资源类型，决定回退到哪一层：
        - DSP 超限 → roofline_solver（降低并行度）
        - LUT 超限 → roofline_solver（降低并行度/位宽）
        - BRAM 超限 → mlc_backend（调整 tiling）
        - II 超标/时序 → codegen_agent（调整 pragma）
        """
        usage = failure.resource_usage
        budget = failure.resource_budget

        # 检查 DSP 超限
        if usage.get("dsp", 0) > budget.get("dsp", 999999):
            return DiagnosticResult(
                failure=failure,
                feedback_text=self._generate_l2_feedback(failure),
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.ROOFLINE_SOLVER,
                    action_type="reduce_parallelism",
                    params={
                        "parallelism_factor": 0.5,  # 减半
                    },
                    rationale=f"DSP 超限（{usage['dsp']} > {budget['dsp']}），降低并行度",
                ),
                should_deep_loop=False,
            )

        # 检查 LUT 超限
        if usage.get("lut", 0) > budget.get("lut", 999999):
            return DiagnosticResult(
                failure=failure,
                feedback_text=self._generate_l2_feedback(failure),
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.ROOFLINE_SOLVER,
                    action_type="reduce_parallelism_and_bitwidth",
                    params={
                        "parallelism_factor": 0.5,
                        "bitwidth_reduction": 2,
                    },
                    rationale=f"LUT 超限（{usage['lut']} > {budget['lut']}），降低并行度和位宽",
                ),
                should_deep_loop=False,
            )

        # 检查 BRAM 超限
        if usage.get("bram", 0) > budget.get("bram", 999999):
            return DiagnosticResult(
                failure=failure,
                feedback_text=self._generate_l2_feedback(failure),
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.MLC_BACKEND,
                    action_type="adjust_tiling",
                    params={
                        "tile_size_factor": 0.5,
                    },
                    rationale=f"BRAM 超限（{usage['bram']} > {budget['bram']}），调整 tiling",
                ),
                should_deep_loop=False,
            )

        # 时序/II 问题
        if "时序" in failure.summary or "II" in failure.summary:
            return DiagnosticResult(
                failure=failure,
                feedback_text=self._generate_l2_feedback(failure),
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.CODEGEN_AGENT,
                    action_type="tune_pragma",
                    params={
                        "pipeline_ii_increment": 1,
                    },
                    rationale="时序不满足，调整 pipeline pragma",
                ),
                should_deep_loop=False,
            )

        # 默认情况：触发深度迭代
        return DiagnosticResult(
            failure=failure,
            feedback_text=self._generate_l2_feedback(failure),
            should_deep_loop=True,
        )

    def _diagnose_l3_quality(self, failure: FailureContext) -> DiagnosticResult:
        """诊断 L3 质量仿真失败.

        判断是轻微质量问题（可以微调）还是严重问题（需要深度迭代）。
        """
        nmse_db = failure.measured_metrics.get("nmse_db", 0)
        sign_error_rate = failure.measured_metrics.get("sign_error_rate", 0)

        # 严重的符号错误或 NMSE - 需要深度迭代
        if sign_error_rate > 0.05 or nmse_db > -10:
            return DiagnosticResult(
                failure=failure,
                feedback_text=self._generate_l3_feedback(failure),
                should_deep_loop=True,
            )

        # 轻微质量问题 - 可以微调
        return DiagnosticResult(
            failure=failure,
            feedback_text=self._generate_l3_feedback(failure),
            recovery_action=RecoveryAction(
                layer=RecoveryLayer.TEMPLATE_ENGINE,
                action_type="fine_tune_quant",
                params={
                    "frac_bits_increment": 1,
                },
                rationale=f"轻微质量差距，微调量化参数",
            ),
            should_deep_loop=False,
        )

    def _generate_l1_feedback(self, failure: FailureContext) -> str:
        """生成 L1 失败的反馈文本."""
        parts = [
            f"## L1 数值验证失败: {failure.variant_id}",
            "",
            f"**失败原因**: {failure.summary}",
        ]
        if failure.gap_description:
            parts.append(f"**指标差距**: {failure.gap_description}")
        parts.append("")
        parts.append("**建议方向**:")
        parts.append("- 增加量化位宽（int_bits 或 frac_bits）")
        parts.append("- 使用更精确的近似方法（如 offset_min_sum 替代 min_sum）")
        parts.append("- 启用饱和保护（enable_saturation）")
        return "\n".join(parts)

    def _generate_l2_feedback(self, failure: FailureContext) -> str:
        """生成 L2 失败的反馈文本."""
        parts = [
            f"## L2 综合/资源验证失败: {failure.variant_id}",
            "",
            f"**失败原因**: {failure.summary}",
        ]
        if failure.gap_description:
            parts.append(f"**资源差距**: {failure.gap_description}")
        parts.append("")
        parts.append("**建议方向**:")
        if "DSP" in failure.gap_description:
            parts.append("- 降低并行度（parallelism）")
        if "BRAM" in failure.gap_description:
            parts.append("- 调整 tiling 策略（减少 tile_size）")
        if "时序" in failure.summary:
            parts.append("- 放宽 pipeline II 约束")
        parts.append("- 减少量化位宽")
        parts.append("- 使用更轻量的近似方法")
        return "\n".join(parts)

    def _generate_l3_feedback(self, failure: FailureContext) -> str:
        """生成 L3 失败的反馈文本."""
        parts = [
            f"## L3 质量仿真失败: {failure.variant_id}",
            "",
            f"**失败原因**: {failure.summary}",
        ]
        if failure.gap_description:
            parts.append(f"**质量差距**: {failure.gap_description}")
        parts.append("")
        parts.append("**建议方向**:")
        parts.append("- 增加量化位宽")
        parts.append("- 尝试不同的近似算法")
        parts.append("- 检查是否算法选择本身有问题")
        return "\n".join(parts)

    def _generate_compile_feedback(self, failure: FailureContext) -> str:
        """生成编译失败的反馈文本."""
        return (
            f"## 编译失败: {failure.variant_id}\n"
            f"\n"
            f"**失败原因**: {failure.summary}\n"
            f"\n"
            f"**建议**:\n"
            f"- 检查生成的 C++ 代码语法\n"
            f"- 检查数据类型定义\n"
            f"- 尝试不同的近似方法组合\n"
        )
