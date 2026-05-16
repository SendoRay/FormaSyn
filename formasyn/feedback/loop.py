"""Feedback Loop: 智能反馈循环执行器.

本模块职责：
1. 接收 AgentDiagnostic 的诊断结果 (DiagnosticResult)
2. 执行 RecoveryAction 中指定的恢复动作
3. 将修改应用到对应的 IR 层

架构原则：
- 单一决策入口：所有决策来自 AgentDiagnostic (LLM)
- 无硬编码规则：不根据失败阶段做判断，完全遵循 Agent 的决策
- 灵活回退：可以回退到任意层 (template_engine, roofline_solver, mlc_backend, codegen_agent, dse_agent)
"""

from __future__ import annotations

import copy
import logging
from dataclasses import dataclass, field
from typing import Any, Optional

from ..agent.diagnostic import (
    AgentDiagnostic,
    DiagnosticResult,
    RecoveryAction,
    RecoveryLayer,
)
from ..checker.diagnostic import FailureContext, FailureStage
from ..ir.algo_hw_dialect import AlgoHWDialect
from ..ir.schedule_dialect import HLSScheduleDialect

logger = logging.getLogger(__name__)


@dataclass
class LoopState:
    """反馈循环状态.

    Attributes:
        iteration: 当前迭代次数.
        max_iterations: 最大迭代次数.
        history: 历史失败记录.
        recovery_history: 历史恢复动作记录.
    """

    iteration: int = 0
    max_iterations: int = 3
    history: list[FailureContext] = field(default_factory=list)
    recovery_history: list[RecoveryAction] = field(default_factory=list)

    @property
    def can_continue(self) -> bool:
        return self.iteration < self.max_iterations


@dataclass
class LoopResult:
    """反馈循环结果.

    Attributes:
        success: 是否成功恢复.
        new_ir: 调整后的 IR（AlgoHWDialect 或 HLSScheduleDialect）.
        feedback_text: 反馈文本（给 LLM 或用于日志）.
        actions_taken: 执行的动作列表.
        should_deep_loop: 是否需要深度迭代（触发 DSE Agent）.
        target_layer: Agent 决策的回退目标层.
    """

    success: bool = False
    new_ir: Any = None
    feedback_text: str = ""
    actions_taken: list[str] = field(default_factory=list)
    should_deep_loop: bool = False
    target_layer: Optional[RecoveryLayer] = None


class FeedbackLoop:
    """智能反馈循环执行器.

    完全遵循 AgentDiagnostic 的决策，执行相应的恢复动作.
    支持回退到任意层：
    - TEMPLATE_ENGINE: 调整量化、approx_method
    - ROOFLINE_SOLVER: 调整并行度、调度
    - MLC_BACKEND: 调整 BRAM tiling
    - CODEGEN_AGENT: 调整 pragma
    - DSE_AGENT: 触发深度迭代
    """

    def __init__(
        self,
        max_iterations: int = 3,
    ) -> None:
        """初始化反馈循环.

        Args:
            max_iterations: 最大迭代次数.
        """
        self._state = LoopState(max_iterations=max_iterations)
        self._diagnostic = AgentDiagnostic()

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
        """执行智能恢复.

        流程：
        1. 调用 AgentDiagnostic 进行诊断和决策
        2. 根据 Agent 决策的 target_layer 执行对应恢复动作
        3. 返回调整后的 IR 和结果

        Args:
            ir: 当前的 IR（AlgoHWDialect 或 HLSScheduleDialect）.
            failure: 失败上下文.

        Returns:
            LoopResult，包含调整后的 IR 和执行信息.
        """
        # Step 1: Agent 智能诊断决策
        diag_result = self._diagnostic.diagnose(failure)
        
        self._state.history.append(failure)
        
        result = LoopResult(
            feedback_text=diag_result.feedback_text,
            should_deep_loop=diag_result.should_deep_loop,
            target_layer=diag_result.recovery_action.layer if diag_result.recovery_action else None,
        )
        
        # Step 2: 执行 Agent 决策的恢复动作
        if not diag_result.recovery_action:
            logger.warning("Agent 未提供恢复动作")
            return result
        
        action = diag_result.recovery_action
        self._state.recovery_history.append(action)
        
        logger.info(
            "Agent 决策: 回退到 %s, 动作 %s, 原因: %s",
            action.layer.value,
            action.action_type,
            action.rationale[:100],
        )
        
        # Step 3: 根据目标层执行恢复
        try:
            new_ir, actions = self._apply_recovery_action(ir, action)
            result.success = True
            result.new_ir = new_ir
            result.actions_taken = actions
            logger.info("恢复动作执行成功: %s", actions)
        except Exception as e:
            logger.warning("执行恢复动作失败: %s", str(e)[:200])
            result.success = False
        
        return result

    def generate_feedback_for_llm(
        self,
        failures: list[FailureContext],
    ) -> str:
        """生成给 DSE Agent 的深度迭代反馈文本.

        Args:
            failures: 本轮所有失败上下文.

        Returns:
            结构化反馈文本（Markdown 格式）.
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
        
        # 分析历史恢复动作，给 DSE Agent 提供上下文
        if self._state.recovery_history:
            parts.extend([
                "",
                "### 已尝试的本地修复",
            ])
            for i, action in enumerate(self._state.recovery_history[-5:], 1):  # 最近5个
                parts.append(
                    f"{i}. [{action.layer.value}] {action.action_type}: {action.rationale[:80]}"
                )
        
        parts.extend([
            "",
            "### 建议探索方向",
            "基于上述失败和已尝试的修复，建议：",
        ])
        
        # 智能分析失败模式
        has_numeric = any(
            f.failed_at.value.startswith("l1_") for f in failures
        )
        has_resource = any(
            f.failed_at == FailureStage.L2_CSYNTH for f in failures
        )
        has_quality = any(
            f.failed_at == FailureStage.L3_QUALITY for f in failures
        )
        
        if has_numeric and has_resource:
            parts.append("- 探索折中方案: 中等位宽(12-14bit) + 中等并行度(4-8)")
            parts.append("- 考虑使用 Offset Min-Sum 替代 Min-Sum 以提升精度")
        elif has_numeric:
            parts.append("- 增加量化位宽至 10-12bit")
            parts.append("- 尝试 LUT-tanh 近似以获得更好的精度")
        elif has_resource:
            parts.append("- 降低并行度至 2-4")
            parts.append("- 使用 Min-Sum 替代 SPA 以减少 DSP 消耗")
        elif has_quality:
            parts.append("- 检查近似算法参数（offset_beta, scale_factor）")
            parts.append("- 确保饱和保护已启用")
        
        if self._state.iteration > 1:
            parts.extend([
                "",
                f"### 历史记录 (共 {len(self._state.history)} 次失败, {len(self._state.recovery_history)} 次修复尝试)",
                "避免重复之前失败的策略。",
            ])
        
        return "\n".join(parts)

    def _apply_recovery_action(
        self,
        ir: Any,
        action: RecoveryAction,
    ) -> tuple[Any, list[str]]:
        """应用 Agent 决策的恢复动作到 IR.

        Args:
            ir: 输入 IR.
            action: Agent 决策的恢复动作.

        Returns:
            (调整后的 IR, 动作描述列表).
        """
        layer = action.layer
        action_type = action.action_type
        params = action.params
        
        actions_taken: list[str] = []
        
        # 深度迭代不需要本地修改
        if layer == RecoveryLayer.DSE_AGENT:
            return ir, ["触发深度迭代 (DSE_AGENT)"]
        
        # 深拷贝 IR 进行修改
        ir = copy.deepcopy(ir)
        
        # 根据目标层和动作类型执行恢复
        if layer == RecoveryLayer.TEMPLATE_ENGINE:
            actions_taken = self._apply_template_engine_action(ir, action_type, params)
        
        elif layer == RecoveryLayer.ROOFLINE_SOLVER:
            actions_taken = self._apply_roofline_action(ir, action_type, params)
        
        elif layer == RecoveryLayer.MLC_BACKEND:
            actions_taken = self._apply_mlc_action(ir, action_type, params)
        
        elif layer == RecoveryLayer.CODEGEN_AGENT:
            actions_taken = self._apply_codegen_action(ir, action_type, params)
        
        else:
            raise ValueError(f"不支持的恢复层: {layer}")
        
        return ir, actions_taken

    def _apply_template_engine_action(
        self,
        ir: AlgoHWDialect,
        action_type: str,
        params: dict,
    ) -> list[str]:
        """应用 Template Engine 层的恢复动作 (量化、approx_method)."""
        actions: list[str] = []
        
        if not hasattr(ir, "nodes"):
            raise ValueError("IR must be AlgoHWDialect for template_engine actions")
        
        if action_type in ("relax_quant", "fine_tune_quant"):
            int_inc = params.get("int_bits_increment", 0)
            frac_inc = params.get("frac_bits_increment", 2 if action_type == "relax_quant" else 1)
            
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "data_type"):
                    continue
                
                old_dtype = node.data_type
                new_dtype = self._adjust_dtype_width(old_dtype, int_inc, frac_inc)
                
                if new_dtype != old_dtype:
                    node.data_type = new_dtype
                    # 同步更新 quant bits
                    self._update_quant_bits(node, int_inc, frac_inc)
                    actions.append(f"{node_id}: {old_dtype} -> {new_dtype}")
        
        elif action_type == "change_approx_method":
            new_method = params.get("approx_method", "min_sum")
            old_method = None
            
            for node in ir.nodes.values():
                if hasattr(node, "approx_method"):
                    if old_method is None:
                        old_method = node.approx_method
                    node.approx_method = new_method
            
            if old_method:
                actions.append(f"approx_method: {old_method} -> {new_method}")
        
        elif action_type == "toggle_saturation":
            enable = params.get("enable_saturation", True)
            for node in ir.nodes.values():
                if hasattr(node, "saturation_guard"):
                    node.saturation_guard = enable
            actions.append(f"saturation_guard: -> {enable}")
        
        else:
            actions.append(f"未知动作类型: {action_type}，跳过")
        
        return actions

    def _apply_roofline_action(
        self,
        ir: AlgoHWDialect,
        action_type: str,
        params: dict,
    ) -> list[str]:
        """应用 Roofline Solver 层的恢复动作 (并行度、调度)."""
        actions: list[str] = []
        
        if not hasattr(ir, "nodes"):
            raise ValueError("IR must be AlgoHWDialect for roofline_solver actions")
        
        if action_type == "reduce_parallelism":
            factor = params.get("parallelism_factor", 0.5)
            
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "parallelism"):
                    continue
                
                old_p = node.parallelism
                if old_p > 1:
                    new_p = max(1, int(old_p * factor))
                    # Round down to power of 2
                    new_p = 2 ** (new_p.bit_length() - 1) if new_p > 1 else 1
                    node.parallelism = new_p
                    actions.append(f"{node_id} parallelism: {old_p} -> {new_p}")
        
        elif action_type == "reduce_parallelism_and_bitwidth":
            # Combined action
            para_actions = self._apply_roofline_action(ir, "reduce_parallelism", params)
            quant_actions = self._apply_template_engine_action(
                ir, "relax_quant", 
                {"int_bits_increment": 0, "frac_bits_increment": params.get("bitwidth_reduction", 2)}
            )
            actions.extend(para_actions)
            actions.extend(quant_actions)
        
        elif action_type == "increase_parallelism":
            factor = params.get("parallelism_factor", 2.0)
            
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "parallelism"):
                    continue
                
                old_p = node.parallelism
                new_p = int(old_p * factor)
                # Round up to power of 2
                new_p = 2 ** (new_p - 1).bit_length() if new_p > 1 else 1
                node.parallelism = new_p
                actions.append(f"{node_id} parallelism: {old_p} -> {new_p}")
        
        else:
            actions.append(f"未知动作类型: {action_type}，跳过")
        
        return actions

    def _apply_mlc_action(
        self,
        ir: HLSScheduleDialect,
        action_type: str,
        params: dict,
    ) -> list[str]:
        """应用 MLC Backend 层的恢复动作 (BRAM tiling)."""
        actions: list[str] = []
        
        if not hasattr(ir, "nodes"):
            raise ValueError("IR must be HLSScheduleDialect for mlc_backend actions")
        
        if action_type == "adjust_tiling":
            factor = params.get("tile_size_factor", 0.5)
            
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "tile_size"):
                    continue
                
                old_tile = node.tile_size
                if old_tile and old_tile > 1:
                    new_tile = max(1, int(old_tile * factor))
                    # Round down to power of 2
                    new_tile = 2 ** (new_tile.bit_length() - 1) if new_tile > 1 else 1
                    node.tile_size = new_tile
                    actions.append(f"{node_id} tile_size: {old_tile} -> {new_tile}")
        
        elif action_type == "reduce_bram_banks":
            factor = params.get("bank_factor", 0.5)
            
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "bram_banks"):
                    continue
                
                old_banks = node.bram_banks
                if old_banks > 1:
                    new_banks = max(1, int(old_banks * factor))
                    # Round down to power of 2
                    new_banks = 2 ** (new_banks.bit_length() - 1) if new_banks > 1 else 1
                    node.bram_banks = new_banks
                    actions.append(f"{node_id} bram_banks: {old_banks} -> {new_banks}")
        
        else:
            actions.append(f"未知动作类型: {action_type}，跳过")
        
        return actions

    def _apply_codegen_action(
        self,
        ir: HLSScheduleDialect,
        action_type: str,
        params: dict,
    ) -> list[str]:
        """应用 Codegen Agent 层的恢复动作 (pragma)."""
        actions: list[str] = []
        
        if not hasattr(ir, "nodes"):
            raise ValueError("IR must be HLSScheduleDialect for codegen_agent actions")
        
        if action_type == "tune_pragma":
            ii_inc = params.get("pipeline_ii_increment", 1)
            
            # Adjust global expected II
            old_ii = getattr(ir, "expected_ii", 1)
            new_ii = old_ii + ii_inc
            ir.expected_ii = new_ii
            actions.append(f"expected_ii: {old_ii} -> {new_ii}")
            
            # Adjust per-node pipeline II
            for node_id, node in ir.nodes.items():
                if hasattr(node, "pipeline_ii"):
                    old_node_ii = node.pipeline_ii
                    node.pipeline_ii = max(old_node_ii, new_ii)
                    if old_node_ii != node.pipeline_ii:
                        actions.append(f"{node_id} pipeline_ii: {old_node_ii} -> {node.pipeline_ii}")
            
            # Adjust array partition if requested
            if params.get("relax_array_partition"):
                for node_id, node in ir.nodes.items():
                    if getattr(node, "array_partition_type", None) == "complete":
                        node.array_partition_type = "cyclic"
                        actions.append(f"{node_id} partition: complete -> cyclic")
        
        elif action_type == "reduce_unroll":
            for node_id, node in ir.nodes.items():
                if hasattr(node, "unroll_factor") and node.unroll_factor > 1:
                    old_uf = node.unroll_factor
                    node.unroll_factor = max(1, old_uf // 2)
                    actions.append(f"{node_id} unroll_factor: {old_uf} -> {node.unroll_factor}")
        
        elif action_type == "regenerate_code":
            # This is a marker action - actual regeneration happens in pipeline
            actions.append("标记: 需要重新生成代码")
        
        else:
            actions.append(f"未知动作类型: {action_type}，跳过")
        
        return actions

    @staticmethod
    def _adjust_dtype_width(dtype: str, int_inc: int, frac_inc: int) -> str:
        """调整数据类型位宽."""
        import re
        
        # ap_int<N>
        int_match = re.match(r"ap_int<(\d+)>", dtype)
        if int_match:
            bits = int(int_match.group(1))
            new_bits = min(bits + int_inc + frac_inc, 64)
            return f"ap_int<{new_bits}>"
        
        # ap_fixed<W, I>
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

    @staticmethod
    def _update_quant_bits(node: Any, int_inc: int, frac_inc: int) -> None:
        """更新节点的 quant bits 属性."""
        if hasattr(node, "quant_int_bits"):
            node.quant_int_bits += int_inc
        if hasattr(node, "quant_frac_bits"):
            node.quant_frac_bits = min(node.quant_frac_bits + frac_inc, 48)
