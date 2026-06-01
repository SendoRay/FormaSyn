"""Diagnostic extractor: RTL verification reports -> high-level attribution text.

Parses raw error output from g++ compilation, Verilator simulation, and
Yosys synthesis, then produces structured failure summaries.

数据类型：FailureContext, FailureStage
辅助函数：diagnose_compile_error, diagnose_numeric_error,
         diagnose_resource_error_with_ii, diagnose_quality_error

LLM 智能诊断由 formasyn.agent.diagnostic.AgentDiagnostic 负责.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from enum import Enum

logger = logging.getLogger(__name__)


class FailureStage(str, Enum):
    """Which verification stage the failure occurred at."""
    L1_COMPILE = "l1_compile"
    L1_NUMERIC = "l1_numeric"
    L1_VERILATOR = "l1_verilator"
    L2_YOSYS = "l2_yosys"
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
        failed_at=FailureStage.L2_YOSYS,
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
