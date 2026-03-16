"""LLM Design-Space Exploration Agent for FormaSyn.

Uses a large language model to generate algorithm variant intents (IntentJSON)
given a MathDialect kernel description, quantisation recommendations, and
hardware constraints.  The LLM is guided by domain-specific knowledge from
COMM_KNOWLEDGE_PROMPT and produces structured JSON that downstream modules
(template_engine, Roofline Solver) can consume deterministically.
"""

from __future__ import annotations

import json
import logging
import re
from dataclasses import dataclass
from typing import Optional, TypedDict

from openai import OpenAI

from FormaSyn.agent.knowledge_prompt import COMM_KNOWLEDGE_PROMPT
from FormaSyn.ir.math_dialect import MathDialect

logger = logging.getLogger(__name__)

_VALID_APPROX_METHODS = frozenset({
    "spa_exact",
    "min_sum",
    "offset_min_sum",
    "normalized_min_sum",
    "lut_tanh",
})


# ---------------------------------------------------------------------------
# Data structures
# ---------------------------------------------------------------------------

@dataclass
class QuantSpec:
    """Per-node quantisation recommendation from golden-model analysis.

    Attributes:
        node_id: MathNode identifier this spec applies to.
        recommended_int_bits: Suggested integer-part bit-width.
        recommended_frac_bits: Suggested fractional-part bit-width.
        min_bits: Minimum total bit-width that avoids severe BER degradation.
        max_bits: Maximum useful bit-width (beyond this gains are negligible).
    """

    node_id: str
    recommended_int_bits: int
    recommended_frac_bits: int
    min_bits: int
    max_bits: int


class IntentJSON(TypedDict):
    """Structured variant intent produced by the DSE Agent."""

    variant_name: str
    rationale: str
    approx_method: str
    scale_factor: float
    offset_beta: float
    parallelism: int
    quant_overrides: dict[str, int]
    enable_saturation: bool


# ---------------------------------------------------------------------------
# Intent schema description (injected into system prompt)
# ---------------------------------------------------------------------------

_INTENT_SCHEMA_TEXT = """\
你必须输出一个 JSON 数组，数组中每个元素是一个变体意图对象，结构如下：

{{
  "variant_name": "string — 变体名，如 min_sum_int8_p8",
  "rationale": "string — 自然语言解释为什么选这个策略",
  "approx_method": "string — 枚举值，只能是以下之一: spa_exact, min_sum, offset_min_sum, normalized_min_sum, lut_tanh",
  "scale_factor": "float — 仅 normalized_min_sum 使用，范围 [0.6, 0.9]；其他方法填 1.0",
  "offset_beta": "float — 仅 offset_min_sum 使用，范围 [0.1, 0.5]；其他方法填 0.0",
  "parallelism": "int — 并行度，必须是 2 的幂次（1, 2, 4, 8, ...），不超过 domain_size",
  "quant_overrides": "object — node_id 到 int_bits 的映射，只写需要覆盖推荐值的节点",
  "enable_saturation": "bool — 是否启用饱和保护"
}}

输出要求：
- 直接输出 JSON 数组，不要包含任何 Markdown 代码块标记（如 ```json）
- 不要在 JSON 之前或之后添加任何解释文字
- 数组长度不超过 {max_variants} 个变体
- 变体之间应覆盖不同的权衡策略（精度 vs 资源、高并行 vs 低并行等）
"""


# ---------------------------------------------------------------------------
# DSEAgent
# ---------------------------------------------------------------------------

class DSEAgent:
    """LLM-based design-space exploration agent.

    Builds structured prompts from MathDialect + QuantSpec, calls an LLM via
    the OpenAI-compatible API, and returns validated IntentJSON variants.
    """

    def __init__(
        self,
        model: str = "claude-sonnet-4-5-20250929",
        max_variants: int = 8,
    ) -> None:
        self._model = model
        self._max_variants = max_variants
        self._client = OpenAI(
            api_key="sk-fgiM17i17hA5lYtIhuPf9MGMkEN27dJA4SVE2CsXWxtNovU4",
            base_url="https://api.tryallai.com/v1",
        )

    # -- Prompt builders -----------------------------------------------------

    def _build_system_prompt(self) -> str:
        schema_section = _INTENT_SCHEMA_TEXT.format(
            max_variants=self._max_variants,
        )
        return f"{COMM_KNOWLEDGE_PROMPT}\n\n{schema_section}"

    def _build_user_prompt(
        self,
        dialect: MathDialect,
        quant_specs: dict[str, QuantSpec],
        hw_constraint: str,
        feedback_text: Optional[str] = None,
    ) -> str:
        lines: list[str] = []

        lines.append(f"## 待优化的算法 Kernel: {dialect.kernel_name}")
        lines.append(f"目标优化指标: {dialect.target_metric}")
        lines.append("")

        lines.append("### 节点描述")
        lines.append(
            "| node_id | op_type | op_detail | shape |"
        )
        lines.append(
            "|---------|---------|-----------|-------|"
        )
        for nid, node in dialect.nodes.items():
            detail_str = json.dumps(node.op_detail, ensure_ascii=False)
            shape_str = str(node.shape)
            lines.append(
                f"| {nid} | {node.op_type} | {detail_str} | {shape_str} |"
            )
        lines.append("")

        if quant_specs:
            lines.append("### 量化推荐")
            lines.append(
                "| node_id | 推荐整数位宽 | 推荐小数位宽 | 最小总位宽 | 最大总位宽 |"
            )
            lines.append(
                "|---------|-------------|-------------|-----------|-----------|"
            )
            for nid, spec in quant_specs.items():
                lines.append(
                    f"| {spec.node_id} | {spec.recommended_int_bits} "
                    f"| {spec.recommended_frac_bits} "
                    f"| {spec.min_bits} | {spec.max_bits} |"
                )
            lines.append("")

        lines.append(f"### 硬件约束\n{hw_constraint}")
        lines.append("")

        if feedback_text is not None:
            lines.append("### 上一轮优化失败原因")
            lines.append(feedback_text)
            lines.append("")
            lines.append(
                "请根据以上失败原因调整策略，避免重复之前的错误。"
            )

        return "\n".join(lines)

    # -- Response parsing ----------------------------------------------------

    def _parse_response(self, raw: str) -> list[IntentJSON]:
        """Extract and validate IntentJSON array from LLM response text."""
        raw = raw.strip()

        try:
            parsed = json.loads(raw)
        except json.JSONDecodeError:
            match = re.search(r"\[.*\]", raw, re.DOTALL)
            if match is None:
                logger.error("无法从 LLM 响应中提取 JSON 数组: %s", raw[:200])
                return []
            try:
                parsed = json.loads(match.group())
            except json.JSONDecodeError:
                logger.error(
                    "正则提取后 JSON 解析仍然失败: %s", match.group()[:200],
                )
                return []

        if not isinstance(parsed, list):
            logger.error("LLM 返回的 JSON 不是数组: %s", type(parsed))
            return []

        validated: list[IntentJSON] = []
        for idx, item in enumerate(parsed):
            if not isinstance(item, dict):
                logger.warning("变体 #%d 不是对象，跳过", idx)
                continue

            issues = self._validate_intent(item, idx)
            if issues:
                for issue in issues:
                    logger.warning("变体 #%d 校验失败: %s", idx, issue)
                continue

            validated.append(IntentJSON(
                variant_name=item["variant_name"],
                rationale=item["rationale"],
                approx_method=item["approx_method"],
                scale_factor=float(item.get("scale_factor", 1.0)),
                offset_beta=float(item.get("offset_beta", 0.0)),
                parallelism=int(item["parallelism"]),
                quant_overrides=item.get("quant_overrides", {}),
                enable_saturation=bool(item.get("enable_saturation", True)),
            ))

        return validated[: self._max_variants]

    @staticmethod
    def _validate_intent(item: dict, idx: int) -> list[str]:
        """Return a list of validation error messages (empty means valid)."""
        errors: list[str] = []

        for required in ("variant_name", "rationale", "approx_method", "parallelism"):
            if required not in item:
                errors.append(f"缺少必填字段 '{required}'")

        if errors:
            return errors

        method = item["approx_method"]
        if method not in _VALID_APPROX_METHODS:
            errors.append(
                f"approx_method='{method}' 不在合法枚举 {sorted(_VALID_APPROX_METHODS)} 中"
            )

        p = item["parallelism"]
        if not isinstance(p, int) or p < 1:
            errors.append(f"parallelism={p} 必须是正整数")
        elif p & (p - 1) != 0:
            errors.append(f"parallelism={p} 不是 2 的幂次")

        if method == "normalized_min_sum":
            sf = float(item.get("scale_factor", 1.0))
            if not (0.6 <= sf <= 0.9):
                errors.append(
                    f"normalized_min_sum 的 scale_factor={sf} 不在 [0.6, 0.9] 范围"
                )

        if method == "offset_min_sum":
            ob = float(item.get("offset_beta", 0.0))
            if not (0.1 <= ob <= 0.5):
                errors.append(
                    f"offset_min_sum 的 offset_beta={ob} 不在 [0.1, 0.5] 范围"
                )

        return errors

    # -- Main entry point ----------------------------------------------------

    def generate_intents(
        self,
        dialect: MathDialect,
        quant_specs: dict[str, QuantSpec],
        hw_constraint: str,
        feedback_text: Optional[str] = None,
    ) -> list[IntentJSON]:
        """Call the LLM and return validated variant intents.

        Args:
            dialect: MathDialect describing the kernel to optimise.
            quant_specs: Per-node quantisation recommendations.
            hw_constraint: Free-text hardware constraint description.
            feedback_text: Optional failure feedback from previous iteration.

        Returns:
            A list of validated IntentJSON dicts (at most max_variants).
        """
        system_prompt = self._build_system_prompt()
        user_prompt = self._build_user_prompt(
            dialect, quant_specs, hw_constraint, feedback_text,
        )

        logger.info(
            "调用 LLM 生成变体意图 (model=%s, kernel=%s)",
            self._model,
            dialect.kernel_name,
        )

        try:
            response = self._client.chat.completions.create(
                model=self._model,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_prompt},
                ],
            )
        except Exception:
            logger.exception("LLM API 调用失败")
            return []

        raw = response.choices[0].message.content or ""
        logger.debug("LLM 原始响应 (%d chars): %s", len(raw), raw[:500])

        intents = self._parse_response(raw)
        logger.info(
            "成功解析 %d 个变体意图 (kernel=%s)",
            len(intents),
            dialect.kernel_name,
        )
        return intents
