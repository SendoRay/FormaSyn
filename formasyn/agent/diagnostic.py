"""Agent Diagnostic: LLM 智能诊断与回退决策中心.

核心职责：
1. 接收所有验证阶段的失败信息 (FailureContext)
2. 调用 LLM 智能分析失败原因
3. 由 LLM 决策回退到哪一层 (template_engine, roofline_solver, mlc_backend, codegen_agent, dse_agent)
4. 输出结构化的恢复动作 (RecoveryAction)

架构优势：
- 单一入口：所有报错都送到这里
- 智能决策：LLM 根据完整上下文决定最优回退策略
- 完全利用 Agent 能力：不硬编码规则，让 LLM 灵活判断
"""

from __future__ import annotations

import json
import logging
import re
from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Optional

from .base_agent import BaseAgent, _LOADED_MODEL
from ..checker.diagnostic import FailureContext, FailureStage

logger = logging.getLogger(__name__)


class RecoveryLayer(str, Enum):
    """回退目标层：决定将修改后的参数送回哪一层."""

    TEMPLATE_ENGINE = "template_engine"  # 量化参数、approx_method 调整
    ROOFLINE_SOLVER = "roofline_solver"  # 并行度、调度参数调整
    MLC_BACKEND = "mlc_backend"  # BRAM tiling/bank 调整
    CODEGEN_AGENT = "codegen_agent"  # pragma 调整
    DSE_AGENT = "dse_agent"  # 触发新一轮 LLM 探索 (深度迭代)


@dataclass
class RecoveryAction:
    """恢复动作：描述如何修改 IR.

    Attributes:
        layer: 目标层（RecoveryLayer）- 由 LLM 智能决策
        action_type: 动作类型（relax_quant, reduce_parallelism, adjust_tiling, tune_pragma, explore_new）
        params: 动作参数 - 由 LLM 根据错误类型智能生成
        rationale: LLM 给出的决策原因说明
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
        feedback_text: 给 LLM 的归因文本（用于下一轮深度迭代）.
        recovery_action: 恢复动作（包含 LLM 决策的回退层和修改参数）.
        should_deep_loop: 是否需要触发深度迭代（回退到 DSE_AGENT）.
    """

    failure: FailureContext
    feedback_text: str
    recovery_action: Optional[RecoveryAction] = None
    should_deep_loop: bool = False


# ---------------------------------------------------------------------------
# LLM Prompt 设计
# ---------------------------------------------------------------------------

_DIAGNOSTIC_SYSTEM_PROMPT = """You are an expert FPGA/HLS diagnostic and recovery decision agent.

Your task is to analyze verification failures and decide:
1. **WHY** it failed (root cause analysis)
2. **WHERE** to go back to fix it (which layer)
3. **HOW** to fix it (specific action and parameters)

## Available Recovery Layers (where to go back)

1. `template_engine` - Algorithm-hardware mapping layer
   - Adjust: quantization bit-width (int_bits, frac_bits)
   - Adjust: approximation method (approx_method)
   - Adjust: saturation protection (enable_saturation)
   - Use when: numerical accuracy issues, wrong algorithm choice

2. `roofline_solver` - Scheduling layer
   - Adjust: parallelism degree (1, 2, 4, 8, 16...)
   - Adjust: unroll factors
   - Adjust: tile sizes
   - Use when: resource overflow (DSP/LUT), timing issues from parallelism

3. `mlc_backend` - Memory banking layer  
   - Adjust: BRAM bank allocation
   - Adjust: memory tiling strategy
   - Use when: BRAM overflow, irregular access port conflicts

4. `codegen_agent` - Code generation layer
   - Adjust: pipeline II pragma
   - Adjust: array partition type (none/cyclic/complete)
   - Use when: timing closure issues, II not met

5. `dse_agent` - High-level exploration layer
   - Trigger: new design space exploration
   - Use when: fundamental architecture mismatch, or quick fixes failed multiple times

## Decision Guidelines

**Numerical Failures (L1_NUMERIC)**:
- Sign error rate > 1% → relax quantization → `template_engine`
- NMSE too high but sign OK → increase frac_bits → `template_engine`  
- Severe numerical issues → try different approx_method → `template_engine` or `dse_agent`

**Resource Failures (L2_CSYNTH)**:
- DSP overflow → reduce parallelism → `roofline_solver`
- LUT overflow → reduce parallelism + bitwidth → `roofline_solver`
- BRAM overflow → reduce tile_size or banks → `mlc_backend`
- Timing/II not met → relax pragma → `codegen_agent`
- Multiple resource violations → `dse_agent`

**Quality Failures (L3_QUALITY)**:
- Minor gap → fine-tune quantization → `template_engine`
- Major gap → `dse_agent` for new architecture exploration

**Compilation Failures (L1_COMPILE)**:
- Syntax errors → `codegen_agent` to regenerate
- Type mismatches → `template_engine` to adjust data types
- Fundamental issues → `dse_agent`

## Output Format

Return ONLY a JSON object (no markdown, no explanations outside JSON):

```json
{
  "summary": "One-line diagnosis in Chinese",
  "gap_description": "Detailed explanation of what failed",
  "root_cause": "technical_root_cause_category",
  "recovery_decision": {
    "target_layer": "template_engine|roofline_solver|mlc_backend|codegen_agent|dse_agent",
    "action_type": "relax_quant|reduce_parallelism|adjust_tiling|tune_pragma|explore_new|regenerate_code",
    "params": {
      // Parameters specific to the action_type
      // e.g., for relax_quant: {"int_bits_increment": 2, "frac_bits_increment": 2}
      // e.g., for reduce_parallelism: {"parallelism_factor": 0.5}
      // e.g., for adjust_tiling: {"tile_size_factor": 0.5}
      // e.g., for tune_pragma: {"pipeline_ii_increment": 1, "relax_array_partition": true}
      // e.g., for explore_new: {"suggestion": "Try min_sum instead of offset_min_sum"}
    },
    "rationale": "Detailed reasoning for this decision"
  },
  "should_deep_loop": false,
  "alternative_actions": [
    // Optional: if primary action fails, try these alternatives
    {"target_layer": "...", "action_type": "...", "rationale": "..."}
  ]
}
```

## Key Decision Principles

1. **Prefer local fixes**: If a quick fix at a lower layer is likely to work, prefer it over going back to dse_agent
2. **Escalate when needed**: If you've seen similar failures multiple times, or the gap is large, go to dse_agent
3. **Consider dependencies**: Changing approx_method requires going through template_engine, which then flows through roofline_solver and codegen_agent
4. **Resource vs Quality trade-off**: Be aggressive in reducing resources if quality is good; be conservative if quality is already marginal
"""


class AgentDiagnostic(BaseAgent):
    """LLM 智能诊断决策 Agent.

    核心方法 `diagnose()` 接收 FailureContext，调用 LLM 做智能决策：
    1. 分析失败原因
    2. 决定回退到哪一层 (RecoveryLayer)
    3. 生成具体的恢复动作参数
    """

    def __init__(
        self,
        model: str | None = None,
        enable_rule_fallback: bool = True,
    ) -> None:
        """Initialize diagnostic agent.

        Args:
            model: LLM model name. Uses default if None.
            enable_rule_fallback: Whether to use rule-based fallback when LLM fails.
        """
        if model is None:
            model = _LOADED_MODEL
        super().__init__(model=model)
        self._enable_rule_fallback = enable_rule_fallback

    def diagnose(self, failure: FailureContext) -> DiagnosticResult:
        """智能诊断：调用 LLM 决策回退策略.

        Args:
            failure: 失败上下文，包含所有错误信息.

        Returns:
            DiagnosticResult，包含 LLM 决策的恢复动作.
        """
        # 首先尝试 LLM 智能诊断
        try:
            return self._llm_diagnose(failure)
        except Exception as e:
            logger.warning(f"LLM diagnosis failed: {e}")
            if self._enable_rule_fallback:
                logger.info("Falling back to rule-based diagnosis")
                return self._rule_based_diagnose(failure)
            raise

    def _llm_diagnose(self, failure: FailureContext) -> DiagnosticResult:
        """调用 LLM 进行智能诊断."""
        user_prompt = self._build_diagnostic_prompt(failure)

        raw_response = self._chat_completion(
            system_prompt=_DIAGNOSTIC_SYSTEM_PROMPT,
            user_prompt=user_prompt,
            temperature=0.2,  # Slightly creative for decision making
            timeout=10.0,  # 10秒超时
        )
        
        decision = self._parse_llm_decision(raw_response)
        
        # 构建 RecoveryAction
        recovery_action = RecoveryAction(
            layer=RecoveryLayer(decision["recovery_decision"]["target_layer"]),
            action_type=decision["recovery_decision"]["action_type"],
            params=decision["recovery_decision"].get("params", {}),
            rationale=decision["recovery_decision"].get("rationale", ""),
        )
        
        # 检查是否是深度迭代
        should_deep_loop = decision.get("should_deep_loop", False)
        if recovery_action.layer == RecoveryLayer.DSE_AGENT:
            should_deep_loop = True
        
        return DiagnosticResult(
            failure=failure,
            feedback_text=self._build_feedback_text(failure, decision),
            recovery_action=recovery_action,
            should_deep_loop=should_deep_loop,
        )

    def _build_diagnostic_prompt(self, failure: FailureContext) -> str:
        """构建 LLM 诊断输入."""
        parts = [
            "# Failure Diagnostic Request",
            "",
            f"## Failure Stage: {failure.failed_at.value}",
            f"## Variant ID: {failure.variant_id}",
            f"## Summary: {failure.summary}",
        ]
        
        if failure.gap_description:
            parts.extend([
                "",
                "## Gap Description",
                failure.gap_description,
            ])
        
        if failure.measured_metrics:
            parts.extend([
                "",
                "## Measured Metrics",
                json.dumps(failure.measured_metrics, indent=2, ensure_ascii=False),
            ])
        
        if failure.target_metrics:
            parts.extend([
                "",
                "## Target Metrics",
                json.dumps(failure.target_metrics, indent=2, ensure_ascii=False),
            ])
        
        if failure.resource_usage:
            parts.extend([
                "",
                "## Resource Usage",
                json.dumps(failure.resource_usage, indent=2, ensure_ascii=False),
            ])
        
        if failure.resource_budget:
            parts.extend([
                "",
                "## Resource Budget",
                json.dumps(failure.resource_budget, indent=2, ensure_ascii=False),
            ])
        
        if failure.raw_error:
            parts.extend([
                "",
                "## Raw Error Log",
                "```",
                failure.raw_error[:3000],  # Limit length
                "```",
            ])
        
        parts.extend([
            "",
            "## Decision Task",
            "Based on the above failure information, analyze the root cause and decide:",
            "1. Which layer should we go back to for fixing?",
            "2. What specific action should be taken?",
            "3. What parameters should be adjusted?",
            "",
            "Return your decision in the specified JSON format.",
        ])
        
        return "\n".join(parts)

    def _parse_llm_decision(self, raw: str) -> dict:
        """解析 LLM 决策响应."""
        text = raw.strip()
        
        # 移除 Markdown 代码块
        if text.startswith("```"):
            text = re.sub(r"^```(?:json)?\s*", "", text, flags=re.DOTALL)
            text = re.sub(r"\s*```$", "", text, flags=re.DOTALL)
            text = text.strip()
        
        try:
            data = json.loads(text)
        except json.JSONDecodeError:
            # 尝试提取 JSON 对象
            match = re.search(r"\{[\s\S]*\}", text)
            if match:
                data = json.loads(match.group())
            else:
                raise ValueError("Cannot parse LLM decision response")
        
        # 验证必要字段
        if "recovery_decision" not in data:
            raise ValueError("LLM response missing recovery_decision")
        
        rd = data["recovery_decision"]
        if "target_layer" not in rd or "action_type" not in rd:
            raise ValueError("recovery_decision missing target_layer or action_type")
        
        return data

    def _build_feedback_text(self, failure: FailureContext, decision: dict) -> str:
        """构建给下一轮深度迭代的反馈文本."""
        lines = [
            f"## 诊断报告: {failure.variant_id}",
            "",
            f"**失败阶段**: {failure.failed_at.value}",
            f"**失败摘要**: {decision.get('summary', failure.summary)}",
            "",
            "**根因分析**:",
            decision.get('gap_description', failure.gap_description or '未提供'),
            "",
            "**决策**:",
            f"- 回退层: `{decision['recovery_decision']['target_layer']}`",
            f"- 动作类型: `{decision['recovery_decision']['action_type']}`",
            f"- 决策理由: {decision['recovery_decision'].get('rationale', 'N/A')}",
        ]
        
        if decision['recovery_decision'].get('params'):
            lines.extend([
                "",
                "**调整参数**:",
                "```json",
                json.dumps(decision['recovery_decision']['params'], indent=2, ensure_ascii=False),
                "```",
            ])
        
        # 如果有替代方案，也加上
        alts = decision.get('alternative_actions', [])
        if alts:
            lines.extend([
                "",
                "**备选方案**:",
            ])
            for i, alt in enumerate(alts[:2], 1):  # 最多显示2个
                lines.append(f"{i}. {alt.get('target_layer')} - {alt.get('action_type')}: {alt.get('rationale', 'N/A')}")
        
        return "\n".join(lines)

    def _rule_based_diagnose(self, failure: FailureContext) -> DiagnosticResult:
        """基于规则的备用诊断（当 LLM 失败时使用）."""
        # 根据失败阶段分发
        if failure.failed_at == FailureStage.L1_NUMERIC:
            return self._rule_diagnose_l1(failure)
        elif failure.failed_at == FailureStage.L2_CSYNTH:
            return self._rule_diagnose_l2(failure)
        elif failure.failed_at == FailureStage.L3_QUALITY:
            return self._rule_diagnose_l3(failure)
        else:
            # 编译错误等，默认触发深度迭代
            return DiagnosticResult(
                failure=failure,
                feedback_text=f"编译/L2仿真失败: {failure.summary}\n建议: 触发深度迭代",
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.DSE_AGENT,
                    action_type="explore_new",
                    params={"suggestion": "Fix compilation or CSIM issues"},
                    rationale="编译/L2仿真失败，需要重新探索",
                ),
                should_deep_loop=True,
            )

    def _rule_diagnose_l1(self, failure: FailureContext) -> DiagnosticResult:
        """规则诊断 L1 数值错误."""
        sign_error_rate = failure.measured_metrics.get("sign_error_rate", 0)
        nmse_db = failure.measured_metrics.get("nmse_db", 0)
        
        if sign_error_rate > 0.01:
            return DiagnosticResult(
                failure=failure,
                feedback_text=f"L1 数值失败: 符号错误率 {sign_error_rate:.4f} 过高",
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.TEMPLATE_ENGINE,
                    action_type="relax_quant",
                    params={"int_bits_increment": 1, "frac_bits_increment": 2},
                    rationale="符号错误率高，需要增加量化位宽",
                ),
                should_deep_loop=False,
            )
        
        if nmse_db > -20:
            return DiagnosticResult(
                failure=failure,
                feedback_text=f"L1 数值失败: NMSE {nmse_db:.2f} dB 过高",
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.TEMPLATE_ENGINE,
                    action_type="relax_quant",
                    params={"frac_bits_increment": 3},
                    rationale="NMSE 过高，增加小数位宽",
                ),
                should_deep_loop=False,
            )
        
        return DiagnosticResult(
            failure=failure,
            feedback_text="L1 数值失败: 轻微误差",
            recovery_action=RecoveryAction(
                layer=RecoveryLayer.TEMPLATE_ENGINE,
                action_type="fine_tune_quant",
                params={"frac_bits_increment": 1},
                rationale="轻微数值误差，微调量化",
            ),
            should_deep_loop=False,
        )

    def _rule_diagnose_l2(self, failure: FailureContext) -> DiagnosticResult:
        """规则诊断 L2 资源错误."""
        usage = failure.resource_usage
        budget = failure.resource_budget
        
        # 检查各类资源超限
        if usage.get("dsp", 0) > budget.get("dsp", 999999):
            return DiagnosticResult(
                failure=failure,
                feedback_text=f"L2 资源失败: DSP 超限 ({usage['dsp']} > {budget['dsp']})",
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.ROOFLINE_SOLVER,
                    action_type="reduce_parallelism",
                    params={"parallelism_factor": 0.5},
                    rationale="DSP 超限，降低并行度",
                ),
                should_deep_loop=False,
            )
        
        if usage.get("bram", 0) > budget.get("bram", 999999):
            return DiagnosticResult(
                failure=failure,
                feedback_text=f"L2 资源失败: BRAM 超限 ({usage['bram']} > {budget['bram']})",
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.MLC_BACKEND,
                    action_type="adjust_tiling",
                    params={"tile_size_factor": 0.5},
                    rationale="BRAM 超限，调整 tiling",
                ),
                should_deep_loop=False,
            )
        
        # 时序/II 问题
        if "时序" in failure.summary or "II" in failure.summary:
            return DiagnosticResult(
                failure=failure,
                feedback_text="L2 时序失败: II 或时序不满足",
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.CODEGEN_AGENT,
                    action_type="tune_pragma",
                    params={"pipeline_ii_increment": 1},
                    rationale="时序不满足，放宽 pipeline",
                ),
                should_deep_loop=False,
            )
        
        # 默认触发深度迭代
        return DiagnosticResult(
            failure=failure,
            feedback_text=f"L2 失败: {failure.summary}",
            recovery_action=RecoveryAction(
                layer=RecoveryLayer.DSE_AGENT,
                action_type="explore_new",
                params={},
                rationale="复杂 L2 失败，需要深度迭代",
            ),
            should_deep_loop=True,
        )

    def _rule_diagnose_l3(self, failure: FailureContext) -> DiagnosticResult:
        """规则诊断 L3 质量错误."""
        sign_error_rate = failure.measured_metrics.get("sign_error_rate", 0)
        nmse_db = failure.measured_metrics.get("nmse_db", 0)
        
        # 严重问题触发深度迭代
        if sign_error_rate > 0.05 or nmse_db > -10:
            return DiagnosticResult(
                failure=failure,
                feedback_text=f"L3 质量失败: 严重 ({sign_error_rate:.4f} SER, {nmse_db:.2f} NMSE)",
                recovery_action=RecoveryAction(
                    layer=RecoveryLayer.DSE_AGENT,
                    action_type="explore_new",
                    params={"suggestion": "Try different approx_method or higher precision"},
                    rationale="严重质量问题，需要重新探索架构",
                ),
                should_deep_loop=True,
            )
        
        # 轻微问题尝试微调
        return DiagnosticResult(
            failure=failure,
            feedback_text="L3 质量失败: 轻微差距",
            recovery_action=RecoveryAction(
                layer=RecoveryLayer.TEMPLATE_ENGINE,
                action_type="fine_tune_quant",
                params={"frac_bits_increment": 1},
                rationale="轻微质量差距，微调量化",
            ),
            should_deep_loop=False,
        )
