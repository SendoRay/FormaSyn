"""Diagnostic extractor: HLS/Co-Sim reports -> high-level attribution text.

Parses raw error output from g++ compilation, Vitis HLS synthesis, and
Co-Simulation, then produces structured failure summaries that the
RepairAgent can act upon.

包含：
1. 规则基础诊断函数 (向后兼容)
2. DiagnosticAgent - LLM 智能诊断
"""

from __future__ import annotations

import json
import logging
import re
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional

from FormaSyn.formasyn.agent.base_agent import BaseAgent, _LOADED_MODEL

logger = logging.getLogger(__name__)


class FailureStage(str, Enum):
    """Which verification stage the failure occurred at."""
    L1_COMPILE = "l1_compile"
    L1_NUMERIC = "l1_numeric"
    L2_CSIM = "l2_csim"
    L2_CSYNTH = "l2_csynth"
    L3_COSIM = "l3_cosim"
    L3_QUALITY = "l3_quality"


@dataclass
class FailureContext:
    """Structured failure report for the RepairAgent.

    Attributes:
        failed_at: Which stage in the verification funnel triggered failure.
        variant_id: The variant that failed.
        raw_error: Unprocessed error text from the tool.
        summary: One-line human-readable diagnosis.
        measured_metrics: Actual measured values (e.g. sign_error_rate).
        target_metrics: Target thresholds the variant needed to meet.
        gap_description: Concise description of how far off the metrics are.
        resource_usage: Reported DSP/BRAM/LUT/FF usage (L2 only).
        resource_budget: Hardware budget constraints (L2 only).
    """
    failed_at: FailureStage
    variant_id: str
    raw_error: str = ""
    summary: str = ""
    measured_metrics: dict[str, float] = field(default_factory=dict)
    target_metrics: dict[str, float] = field(default_factory=dict)
    gap_description: str = ""
    resource_usage: dict[str, int] = field(default_factory=dict)
    resource_budget: dict[str, int] = field(default_factory=dict)


def diagnose_compile_error(stderr: str, variant_id: str) -> FailureContext:
    """Extract high-level cause from a g++ compile error."""
    summary = "编译失败"
    if "undeclared identifier" in stderr or "was not declared" in stderr:
        summary = "编译失败: 存在未声明的标识符"
    elif "expected" in stderr:
        summary = "编译失败: 语法错误"
    elif "cannot convert" in stderr or "invalid conversion" in stderr:
        summary = "编译失败: 类型转换错误"

    return FailureContext(
        failed_at=FailureStage.L1_COMPILE,
        variant_id=variant_id,
        raw_error=stderr[:2000],
        summary=summary,
    )


def diagnose_numeric_error(
    variant_id: str,
    measured: dict[str, float],
    target: dict[str, float],
    kernel_type: str,
) -> FailureContext:
    """Build a FailureContext from L1 numeric check failure."""
    gaps: list[str] = []
    for metric, threshold in target.items():
        actual = measured.get(metric, float("inf"))
        if actual > threshold:
            gaps.append(f"{metric}: 实测 {actual:.6f}, 目标 < {threshold}")

    return FailureContext(
        failed_at=FailureStage.L1_NUMERIC,
        variant_id=variant_id,
        summary=f"L1 数值验证失败 ({kernel_type})",
        measured_metrics=measured,
        target_metrics=target,
        gap_description="; ".join(gaps) if gaps else "指标超限",
    )


def diagnose_resource_error(
    variant_id: str,
    usage: dict[str, int],
    budget: dict[str, int],
    timing_ok: bool,
) -> FailureContext:
    """Build a FailureContext from L2 resource/timing failure."""
    gaps: list[str] = []
    for res, limit in budget.items():
        used = usage.get(res, 0)
        if used > limit:
            gaps.append(f"{res}: 使用 {used}, 预算 {limit}")

    summary = "L2 资源超限"
    if not timing_ok:
        summary = "L2 时序约束不满足"
        gaps.append("时序约束不满足")

    return FailureContext(
        failed_at=FailureStage.L2_CSYNTH,
        variant_id=variant_id,
        summary=summary,
        gap_description="; ".join(gaps) if gaps else "验证未通过",
        resource_usage=usage,
        resource_budget=budget,
    )


def diagnose_resource_error_with_ii(
    variant_id: str,
    usage: dict[str, int],
    budget: dict[str, int],
    timing_ok: bool,
    ii_ok: bool,
    achieved_ii: int,
    target_ii: int,
) -> FailureContext:
    """Build a FailureContext from L2 resource/timing/II failure."""
    gaps: list[str] = []
    for res, limit in budget.items():
        used = usage.get(res, 0)
        if used > limit:
            gaps.append(f"{res}: 使用 {used}, 预算 {limit}")

    summary = "L2 资源超限"
    if not timing_ok:
        summary = "L2 时序约束不满足"
        gaps.append("时序约束不满足")
    elif not ii_ok:
        summary = "L2 启动间隔(II)不满足"
        gaps.append(f"II: 实测 {achieved_ii}, 目标 {target_ii}")

    return FailureContext(
        failed_at=FailureStage.L2_CSYNTH,
        variant_id=variant_id,
        summary=summary,
        gap_description="; ".join(gaps) if gaps else "验证未通过",
        resource_usage=usage,
        resource_budget=budget,
    )


def diagnose_quality_error(
    variant_id: str,
    measured: dict[str, float],
    target: dict[str, float],
    kernel_type: str,
) -> FailureContext:
    """Build a FailureContext from L3 quality simulation failure."""
    gaps: list[str] = []
    for metric, threshold in target.items():
        actual = measured.get(metric, float("inf"))
        if actual > threshold:
            gaps.append(f"{metric}: 实测 {actual:.6f}, 目标 < {threshold}")

    return FailureContext(
        failed_at=FailureStage.L3_QUALITY,
        variant_id=variant_id,
        summary=f"L3 质量仿真失败 ({kernel_type})",
        measured_metrics=measured,
        target_metrics=target,
        gap_description="; ".join(gaps) if gaps else "质量指标超限",
    )


# ---------------------------------------------------------------------------
# LLM-based Diagnostic Agent
# ---------------------------------------------------------------------------

_DIAGNOSTIC_SCHEMA = """You are an FPGA/HLS error diagnosis expert.

Analyze the error log and output a JSON diagnosis. No markdown, no explanations.

Output format:
{
  "summary": "one-line diagnosis in Chinese",
  "gap_description": "what failed and why",
  "measured_metrics": {"nmse_db": 0.0},
  "target_metrics": {"nmse_db": -80.0},
  "suggested_action": "tune_pragma|relax_quant|adjust_tiling|reduce_parallelism"
}

Suggested actions:
- tune_pragma: Adjust pipeline/unroll pragmas for timing
- relax_quant: Increase bit-width for numerical accuracy
- adjust_tiling: Change array partitioning/tiling for memory
- reduce_parallelism: Lower parallelism to meet resource/timing
"""


class DiagnosticAgent(BaseAgent):
    """LLM-based diagnostic agent for HLS verification failures."""

    def __init__(
        self,
        model: str | None = None,
    ) -> None:
        if model is None:
            model = _LOADED_MODEL
        super().__init__(model=model)

    def diagnose(
        self,
        error_log: str,
        variant_id: str,
        stage: FailureStage,
        target_metrics: dict[str, float] | None = None,
        resource_budget: dict[str, int] | None = None,
    ) -> FailureContext:
        """Analyze error log with LLM and generate structured diagnosis.

        Args:
            error_log: Raw error output.
            variant_id: Variant identifier.
            stage: Failure stage.
            target_metrics: Target thresholds (L1/L3).
            resource_budget: Resource budget (L2).

        Returns:
            FailureContext with structured diagnosis.
        """
        # Quick rule-based diagnosis for simple errors
        quick_result = self._quick_diagnose(error_log, variant_id, stage)
        if quick_result:
            return quick_result

        # Use LLM for complex errors
        try:
            user_prompt = self._build_prompt(
                error_log, variant_id, stage, target_metrics, resource_budget
            )
            raw = self._chat_completion(
                system_prompt=_DIAGNOSTIC_SCHEMA,
                user_prompt=user_prompt,
                temperature=0.1,
            )
            return self._parse_llm_response(raw, variant_id, stage, error_log, target_metrics, resource_budget)
        except Exception as e:
            logger.warning(f"LLM diagnosis failed: {e}, using fallback")
            return self._fallback_diagnose(error_log, variant_id, stage, target_metrics, resource_budget)

    def _quick_diagnose(
        self,
        error_log: str,
        variant_id: str,
        stage: FailureStage,
    ) -> FailureContext | None:
        """Quick rule-based diagnosis for simple errors."""
        if stage == FailureStage.L1_COMPILE:
            if "undeclared" in error_log or "was not declared" in error_log:
                return FailureContext(
                    failed_at=stage,
                    variant_id=variant_id,
                    raw_error=error_log[:2000],
                    summary="编译失败: 未声明标识符",
                )
            if "expected" in error_log:
                return FailureContext(
                    failed_at=stage,
                    variant_id=variant_id,
                    raw_error=error_log[:2000],
                    summary="编译失败: 语法错误",
                )
        return None

    def _build_prompt(
        self,
        error_log: str,
        variant_id: str,
        stage: FailureStage,
        target_metrics: dict[str, float] | None,
        resource_budget: dict[str, int] | None,
    ) -> str:
        """Build LLM input prompt."""
        parts = [
            f"Variant ID: {variant_id}",
            f"Error Stage: {stage.value}",
        ]

        if target_metrics:
            parts.append(f"Target Metrics: {target_metrics}")
        if resource_budget:
            parts.append(f"Resource Budget: {resource_budget}")

        parts.append(f"\nError Log:\n{error_log[:5000]}")
        return "\n".join(parts)

    def _parse_llm_response(
        self,
        raw: str,
        variant_id: str,
        stage: FailureStage,
        raw_error: str,
        target_metrics: dict[str, float] | None,
        resource_budget: dict[str, int] | None,
    ) -> FailureContext:
        """Parse LLM response into FailureContext."""
        text = raw.strip()
        # Remove markdown
        if text.startswith("```"):
            text = re.sub(r"^```(?:json)?\s*", "", text, flags=re.DOTALL)
            text = re.sub(r"\s*```$", "", text, flags=re.DOTALL)
            text = text.strip()

        try:
            data = json.loads(text)
        except json.JSONDecodeError:
            match = re.search(r"\{.*\}", text, re.DOTALL)
            if match:
                data = json.loads(match.group())
            else:
                raise ValueError("Cannot parse LLM response")

        return FailureContext(
            failed_at=stage,
            variant_id=variant_id,
            raw_error=raw_error[:2000],
            summary=data.get("summary", "LLM diagnosis failed"),
            gap_description=data.get("gap_description", ""),
            measured_metrics=data.get("measured_metrics", {}),
            target_metrics=target_metrics or {},
            resource_budget=resource_budget or {},
        )

    def _fallback_diagnose(
        self,
        error_log: str,
        variant_id: str,
        stage: FailureStage,
        target_metrics: dict[str, float] | None,
        resource_budget: dict[str, int] | None,
    ) -> FailureContext:
        """Rule-based fallback diagnosis."""
        summary = f"{stage.value} 验证失败"
        gaps: list[str] = []

        if stage == FailureStage.L1_NUMERIC and target_metrics:
            for metric, threshold in target_metrics.items():
                gaps.append(f"{metric}: 目标 < {threshold}")
            summary = "L1 数值验证失败"

        elif stage == FailureStage.L2_CSYNTH and resource_budget:
            for res, limit in resource_budget.items():
                gaps.append(f"{res}: 预算 {limit}")
            summary = "L2 时序约束不满足"

        elif stage == FailureStage.L3_QUALITY and target_metrics:
            for metric, threshold in target_metrics.items():
                gaps.append(f"{metric}: 目标 < {threshold}")
            summary = "L3 质量验证失败"

        return FailureContext(
            failed_at=stage,
            variant_id=variant_id,
            raw_error=error_log[:2000],
            summary=summary,
            gap_description="; ".join(gaps) if gaps else "验证未通过",
            target_metrics=target_metrics or {},
            resource_budget=resource_budget or {},
        )
