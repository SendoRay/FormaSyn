"""Feedback Loop: 反馈循环执行器.

本模块负责���
1. 拿到 agent/diagnostic.py 的归因文本
2. 拿到某一层的"原始输入"（历史快照）
3. 把归因文本注入进去，构造成"新输入"
4. 这个新输入送回那一层重新跑

整合了原 deep_loop.py 和 pragma_tuner.py 的功能：
- DeepLoop: 深度迭代，触发 LLM 重新探索
- PragmaTuner: 快速路径，仅调整 pragma 参数
"""

from __future__ import annotations

import copy
import logging
from dataclasses import dataclass, field
from typing import Any, Optional

from FormaSyn.formasyn.agent.diagnostic import AgentDiagnostic, DiagnosticResult, RecoveryLayer
from FormaSyn.formasyn.checker.diagnostic import FailureContext, FailureStage
from FormaSyn.formasyn.ir.algo_hw_dialect import AlgoHWDialect
from FormaSyn.formasyn.ir.schedule_dialect import HLSScheduleDialect

logger = logging.getLogger(__name__)


@dataclass
class LoopState:
    """反馈循环状态.

    Attributes:
        iteration: 当前迭代次数.
        max_iterations: 最大迭代次数.
        history: 历史失败记录.
        can_continue: 是否可以继续迭代.
    """

    iteration: int = 0
    max_iterations: int = 3
    history: list[FailureContext] = field(default_factory=list)

    @property
    def can_continue(self) -> bool:
        return self.iteration < self.max_iterations


@dataclass
class LoopResult:
    """反馈循环结果.

    Attributes:
        success: 是否成功恢复.
        new_ir: 调整后的 IR（可能是 AlgoHWDialect 或 HLSScheduleDialect）.
        feedback_text: 反馈文本（给 LLM 或用于日志）.
        actions_taken: 执行的动作列表.
        should_deep_loop: 是否需要深度迭代（触发 LLM）.
    """

    success: bool = False
    new_ir: Any = None
    feedback_text: str = ""
    actions_taken: list[str] = field(default_factory=list)
    should_deep_loop: bool = False


class FeedbackLoop:
    """反馈循环执行器.

    根据诊断结果调整 IR 并重新运行验证。

    支持两种恢复路径：
    1. 快速路径：仅调整 pragma/tiling/量化参数，不触发 LLM
    2. 深度路径：触发 LLM 重新探索（当快速路径无法恢复时）
    """

    def __init__(
        self,
        max_iterations: int = 3,
        enable_pragma_tuning: bool = True,
    ) -> None:
        """初始化反馈循环.

        Args:
            max_iterations: 最大迭代次数.
            enable_pragma_tuning: 是否启用 pragma 快速调整.
        """
        self._state = LoopState(max_iterations=max_iterations)
        self._diagnostic = AgentDiagnostic()
        self._enable_pragma_tuning = enable_pragma_tuning

    @property
    def iteration(self) -> int:
        return self._state.iteration

    @property
    def can_iterate(self) -> bool:
        return self._state.can_continue

    def recover(
        self,
        ir: Any,
        failure: FailureContext,
    ) -> LoopResult:
        """尝试从失败中恢复.

        Args:
            ir: 当前的 IR（AlgoHWDialect 或 HLSScheduleDialect）.
            failure: 失败上下文.

        Returns:
            LoopResult，包含调整后的 IR 和反馈信息.
        """
        # 调用诊断模块
        diag_result = self._diagnostic.diagnose(failure)

        self._state.history.append(failure)

        result = LoopResult(
            feedback_text=diag_result.feedback_text,
            should_deep_loop=diag_result.should_deep_loop,
        )

        # 如果诊断结果有恢复动作，执行它
        if diag_result.recovery_action:
            action = diag_result.recovery_action
            logger.info(
                "执行恢复动作: %s -> %s (%s)",
                action.layer, action.action_type, action.rationale
            )

            try:
                new_ir, actions = self._apply_recovery_action(ir, action)
                result.success = True
                result.new_ir = new_ir
                result.actions_taken = actions
            except Exception as e:
                logger.warning("执行恢复动作失败: %s", str(e)[:200])
                result.success = False

        return result

    def generate_feedback_for_llm(
        self,
        failures: list[FailureContext],
    ) -> str:
        """生成给 LLM 的反馈文本（深度迭代）.

        Args:
            failures: 失败上下文列表.

        Returns:
            反馈文本（Markdown 格式）.
        """
        self._state.iteration += 1
        self._state.history.extend(failures)

        parts: list[str] = [
            f"## 第 {self._state.iteration} 轮深度迭代反馈",
            "",
            "### 失败变体汇总",
        ]

        for fc in failures:
            parts.append(f"- **{fc.variant_id}**: {fc.summary}")
            if fc.gap_description:
                parts.append(f"  差距: {fc.gap_description}")

        parts.append("")
        parts.append("### 建议方向")

        # 分析失败模式，给出建议
        has_numeric = any(
            f.failed_at in (FailureStage.L1_NUMERIC, FailureStage.L3_QUALITY)
            for f in failures
        )
        has_resource = any(
            f.failed_at == FailureStage.L2_CSYNTH
            for f in failures
        )

        if has_numeric and has_resource:
            parts.append(
                "- 同时存在数值精度和资源问题，建议尝试中间路线: "
                "适度量化(12-14位) + 中等并行度(4-8)"
            )
        elif has_numeric:
            parts.append(
                "- 数值精度不足，建议: 增加位宽、使用更精确的近似方法"
                "(如 offset_min_sum 替代 min_sum)、启用饱和保护"
            )
        elif has_resource:
            parts.append(
                "- 资源超限，建议: 降低并行度、减少位宽、"
                "使用更轻量的近似方法(如 min_sum 替代 spa_exact)"
            )

        if self._state.iteration > 1:
            parts.append("")
            parts.append(
                f"### 历史失败记录 (共 {len(self._state.history)} 次失败)"
            )
            for fc in self._state.history:
                stage = fc.failed_at.value if isinstance(fc.failed_at, FailureStage) else str(fc.failed_at)
                parts.append(f"- [{stage}] {fc.variant_id}: {fc.summary}")

        return "\n".join(parts)

    def _apply_recovery_action(
        self,
        ir: Any,
        action,
    ) -> tuple[Any, list[str]]:
        """应用恢复动作到 IR.

        Args:
            ir: 输入 IR.
            action: 恢复动作.

        Returns:
            (调整后的 IR, 动作描述列表).
        """
        actions_taken: list[str] = []

        if action.layer == RecoveryLayer.TEMPLATE_ENGINE:
            # 调整量化参数（在 AlgoHWDialect 上）
            if not hasattr(ir, "nodes"):
                raise ValueError("IR 必须是 AlgoHWDialect 才能调整量化参数")
            ir = copy.deepcopy(ir)
            actions_taken = self._relax_quantization(ir, action.params)

        elif action.layer == RecoveryLayer.ROOFLINE_SOLVER:
            # 调整并行度（在 AlgoHWDialect 上）
            if not hasattr(ir, "nodes"):
                raise ValueError("IR 必须是 AlgoHWDialect 才能调整并行度")
            ir = copy.deepcopy(ir)
            actions_taken = self._reduce_parallelism(ir, action.params)

        elif action.layer == RecoveryLayer.MLC_BACKEND:
            # 调整 tiling（在 HLSScheduleDialect 上）
            if not hasattr(ir, "nodes"):
                raise ValueError("IR 必须是 HLSScheduleDialect 才能调整 tiling")
            ir = copy.deepcopy(ir)
            actions_taken = self._adjust_tiling(ir, action.params)

        elif action.layer == RecoveryLayer.CODEGEN_AGENT:
            # 调整 pragma（在 HLSScheduleDialect 上）
            if not hasattr(ir, "nodes"):
                raise ValueError("IR 必须是 HLSScheduleDialect 才能调整 pragma")
            ir = copy.deepcopy(ir)
            actions_taken = self._tune_pragma(ir, action.params)

        else:
            raise ValueError(f"不支持的恢复层: {action.layer}")

        return ir, actions_taken

    def _relax_quantization(self, ir: AlgoHWDialect, params: dict) -> list[str]:
        """放宽量化参数."""
        actions: list[str] = []
        int_inc = params.get("int_bits_increment", 0)
        frac_inc = params.get("frac_bits_increment", 2)

        for node_id, node in ir.nodes.items():
            if not hasattr(node, "data_type"):
                continue

            old_dtype = node.data_type
            new_dtype = self._adjust_dtype_width(old_dtype, int_inc, frac_inc)

            if new_dtype != old_dtype:
                node.data_type = new_dtype
                actions.append(f"放宽 {node_id} 量化位宽: {old_dtype} -> {new_dtype}")

        return actions

    def _reduce_parallelism(self, ir: AlgoHWDialect, params: dict) -> list[str]:
        """降低并行度."""
        actions: list[str] = []
        factor = params.get("parallelism_factor", 0.5)

        for node_id, node in ir.nodes.items():
            if not hasattr(node, "parallelism"):
                continue

            old_parallelism = node.parallelism
            if old_parallelism > 1:
                new_parallelism = max(1, int(old_parallelism * factor))
                # 向下取整为 2 的幂
                new_parallelism = 2 ** int(new_parallelism).bit_length() - 1
                node.parallelism = new_parallelism
                actions.append(f"降低 {node_id} 并行度: {old_parallelism} -> {new_parallelism}")

        return actions

    def _adjust_tiling(self, ir: HLSScheduleDialect, params: dict) -> list[str]:
        """调整 tiling."""
        actions: list[str] = []
        factor = params.get("tile_size_factor", 0.5)

        for node_id, node in ir.nodes.items():
            if not hasattr(node, "tile_size"):
                continue

            old_tile = node.tile_size
            if old_tile and old_tile > 1:
                new_tile = max(1, int(old_tile * factor))
                # 向下取整为 2 的幂
                new_tile = 2 ** int(new_tile).bit_length() - 1
                node.tile_size = new_tile
                actions.append(f"减小 {node_id} tile_size: {old_tile} -> {new_tile}")

        return actions

    def _tune_pragma(self, ir: HLSScheduleDialect, params: dict) -> list[str]:
        """调整 pragma."""
        actions: list[str] = []
        ii_inc = params.get("pipeline_ii_increment", 1)

        # 调整全局 pipeline II
        old_ii = getattr(ir, "expected_ii", 1)
        new_ii = old_ii + ii_inc
        ir.expected_ii = new_ii
        actions.append(f"放宽全局 pipeline II: {old_ii} -> {new_ii}")

        # 调整各节点的 pipeline II
        for node_id, node in ir.nodes.items():
            if hasattr(node, "pipeline_ii"):
                old_node_ii = node.pipeline_ii
                node.pipeline_ii = max(old_node_ii, new_ii)
                if old_node_ii != node.pipeline_ii:
                    actions.append(f"放宽 {node_id} pipeline II: {old_node_ii} -> {node.pipeline_ii}")

        return actions

    @staticmethod
    def _adjust_dtype_width(dtype: str, int_inc: int, frac_inc: int) -> str:
        """调整数据类型位宽."""
        import re

        # 处理 ap_int<N>
        int_match = re.match(r"ap_int<(\d+)>", dtype)
        if int_match:
            bits = int(int_match.group(1))
            new_bits = min(bits + int_inc + frac_inc, 64)
            return f"ap_int<{new_bits}>"

        # 处理 ap_fixed<W, I>
        fixed_match = re.match(r"ap_fixed<(\d+),\s*(\d+)>", dtype)
        if fixed_match:
            total = int(fixed_match.group(1))
            integer = int(fixed_match.group(2))
            frac = total - integer

            new_integer = integer + int_inc
            new_frac = min(frac + frac_inc, 48)
            new_total = new_integer + new_frac

            return f"ap_fixed<{new_total},{new_integer}>"

        return dtype


# 向后兼容：保留旧的 DeepLoopGenerator 别名
DeepLoopGenerator = FeedbackLoop
DeepLoopFeedback = LoopResult
