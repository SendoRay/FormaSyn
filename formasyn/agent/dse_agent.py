"""DSE (Design Space Exploration) Agent: 根据算法描述、量化建议和硬件约束生成优化变体配置.

DSE Agent 是 FormaSyn 中负责设计空间探索的 LLM Agent。

工作流程:
    输入                          DSE Agent                          输出
    ────────────────────────────────────────────────────────────────────────
    MathDialect          ──>  LLM 调用  ──>  IntentJSON[]
    量化推荐                     (生成策略)
    硬件约束

IntentJSON 结构:
    {
        "variant_name": "变体名称",
        "rationale": "设计思路说明",
        "approx_method": "近似方法 (spa_exact, min_sum, ...)",
        "scale_factor": "归一化因子",
        "offset_beta": "偏移量",
        "parallelism": "并行度 (1,2,4,8...)",
        "quant_overrides": "位宽覆盖",
        "enable_saturation": "是否饱和"
    }
"""

from __future__ import annotations

import json
import logging
import re
from dataclasses import dataclass, field
from typing import Any

from .base_agent import BaseAgent
from ..ir.math_dialect import MathDialect

logger = logging.getLogger(__name__)

_VALID_APPROX_METHODS = frozenset({
    "spa_exact",
    "min_sum",
    "offset_min_sum",
    "normalized_min_sum",
    "lut_tanh",
})


# ---------------------------------------------------------------------------
# 数据结构定义
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class QuantSpec:
    """量化规格：每个节点的定点位宽推荐.

    Attributes:
        node_id: MathNode 标识符.
        recommended_int_bits: 推荐整数部分位宽（含符号位）.
        recommended_frac_bits: 推荐小数部分位宽.
        min_bits: 最小总位宽.
        max_bits: 最大总位宽.
    """

    node_id: str
    recommended_int_bits: int
    recommended_frac_bits: int
    min_bits: int = 4
    max_bits: int = 32


# IntentJSON 类型别名（用于类型标注）
IntentJSON = dict[str, Any]


# ---------------------------------------------------------------------------
# 系统提示词
# ---------------------------------------------------------------------------

_DSE_SYSTEM_PROMPT = """你是 FormaSyn 设计空间探索（DSE）专家。

你的任务是根据算法描述、量化分析和硬件约束，生成多个优化的硬件实现变体配置。

**关键原则**:
1. 变体数量要合理（通常 2-6 个），覆盖不同的优化方向
2. 每个变体必须有明确的设计意图（rationale）
3. 变体之间要有显著差异，避免重复探索
4. 考虑硬件资源约束（DSP、BRAM）和性能目标

**近似方法选项**:
- `spa_exact`: 精确计算，无近似，适合高精度需求
- `min_sum`: Min-Sum 近似，适合 LDPC 解码等通信算法
- `offset_min_sum`: 带偏移的 Min-Sum，精度略优于 min_sum
- `normalized_min_sum`: 归一化 Min-Sum，可调节缩放因子
- `lut_tanh`: 用查找表替代 tanh，适合需要非线性变换的算法

**并行度选择**:
- 根据硬件 DSP/BRAM 约束选择 1, 2, 4, 8, 16 等
- 高并行度增加资源消耗但提高吞吐
- 低并行度节省资源适合面积受限场景

**量化策略**:
- 位宽越低资源越少，但精度损失越大
- 需要根据量化分析推荐的位宽范围调整
- 启用饱和（saturation）防止溢出

**输出格式**:
返回 JSON 数组，每个元素是一个变体配置:
```json
[
  {
    "variant_name": "描述性名称如 high_perf_int16_p8",
    "rationale": "简要说明设计思路",
    "approx_method": "spa_exact",
    "scale_factor": 1.0,
    "offset_beta": 0.0,
    "parallelism": 8,
    "quant_overrides": {},
    "enable_saturation": true
  }
]
```

**注意**: 每个变体必须包含 `variant_name`、`approx_method`、`parallelism` 和 `enable_saturation` 字段，缺一不可。\n**重要**: 只输出纯 JSON 数组，不要包含任何其他文字或 markdown 标记。
"""


# ---------------------------------------------------------------------------
# DSE Agent 实现
# ---------------------------------------------------------------------------

class DSEAgent(BaseAgent):
    """设计空间探索 Agent: 生成多个优化变体配置.

    核心功能:
        - 根据算法特性选择合适的近似方法
        - 平衡资源使用和性能目标
        - 生成多样化的变体配置供后续验证

    使用示例:
        agent = DSEAgent(kernel_type="filtering")
        intents = agent.generate_intents(
            math_dialect,
            quant_specs,
            hw_constraints,
            max_variants=4,
        )
    """

    # 支持的 kernel 类型及其推荐策略
    KERNEL_STRATEGIES = {
        "filtering": {
            "default_approx": "spa_exact",
            "parallelism_range": [1, 2, 4, 8, 16],
            "quant_focus": "保持精度",
        },
        "elementwise": {
            "default_approx": "spa_exact",
            "parallelism_range": [1, 2, 4, 8, 16],
            "quant_focus": "向量元素位宽",
        },
        "ldpc": {
            "default_approx": "min_sum",
            "parallelism_range": [1, 2, 4, 8],
            "quant_focus": "消息位宽",
        },
        "detection": {
            "default_approx": "spa_exact",
            "parallelism_range": [1, 2, 4],
            "quant_focus": "检测阈值精度",
        },
        "transform": {
            "default_approx": "spa_exact",
            "parallelism_range": [1, 2, 4, 8],
            "quant_focus": "变换系数精度",
        },
    }

    def __init__(
        self,
        model: str | None = None,
        kernel_type: str = "filtering",
        max_variants: int = 6,
    ) -> None:
        """初始化 DSE Agent.

        Args:
            model: LLM 模型名称（可选，默认使用配置中的模型）.
            kernel_type: kernel 类型，影响推荐的策略.
            max_variants: 最大变体数量.
        """
        super().__init__(model=model)
        self._kernel_type = kernel_type
        self._max_variants = max_variants

        # 获取 kernel 类型的推荐策略
        self._strategy = self.KERNEL_STRATEGIES.get(
            kernel_type,
            self.KERNEL_STRATEGIES["filtering"],
        )

    def generate_intents(
        self,
        math_dialect: MathDialect,
        quant_specs: dict[str, QuantSpec],
        hw_constraints: str,
        *,
        feedback_text: str | None = None,
        max_variants: int | None = None,
    ) -> list[IntentJSON]:
        """生成优化变体配置列表.

        Args:
            math_dialect: 数学方言 IR，描述算法结构.
            quant_specs: 量化规格字典（node_id -> QuantSpec）.
            hw_constraints: 硬件约束 YAML 字符串.
            feedback_text: 反馈文本（来自上一轮验证失败）.
            max_variants: 本次生成的最大变体数（可选）.

        Returns:
            IntentJSON 列表，每个元素是一个变体配置.
        """
        if max_variants is None:
            max_variants = self._max_variants

        user_prompt = self._build_user_prompt(
            math_dialect=math_dialect,
            quant_specs=quant_specs,
            hw_constraints=hw_constraints,
            feedback_text=feedback_text,
            max_variants=max_variants,
        )

        logger.info(
            "调用 LLM 生成变体意图 (model=%s, kernel=%s)",
            self.model,
            math_dialect.kernel_name,
        )

        current_user_prompt = user_prompt

        for attempt in range(2):
            try:
                raw_response = self._chat_completion(
                    system_prompt=_DSE_SYSTEM_PROMPT,
                    user_prompt=current_user_prompt,
                    temperature=0.4,
                    timeout=60.0,
                    response_format={"type": "json_object"},
                )
            except Exception as e:
                logger.warning("LLM 调用失败: %s", str(e)[:100])
                break

            intents = self._parse_response(raw_response)

            valid_intents = []
            error_msgs = []
            for intent in intents:
                if self._validate_intent(intent, math_dialect):
                    valid_intents.append(intent)
                else:
                    vn = intent.get("variant_name", "unknown")
                    missing = [
                        f for f in ("variant_name", "approx_method", "parallelism", "enable_saturation")
                        if f not in intent
                    ]
                    if missing:
                        error_msgs.append(f"变体 '{vn}' 缺少必需字段: {', '.join(missing)}")
                    else:
                        error_msgs.append(f"变体 '{vn}' 字段值不合法")
                    logger.warning("跳过无效 intent: %s", vn)

            if valid_intents:
                logger.info(
                    "成功解析 %d 个变体意图 (kernel=%s)",
                    len(valid_intents),
                    math_dialect.kernel_name,
                )
                return valid_intents

            # 第一次全部无效且能定位到具体错误时，给 LLM 一次修正机会
            if attempt == 0 and error_msgs:
                logger.info("LLM 输出格式有误，准备反馈后重试")
                current_user_prompt = (
                    current_user_prompt
                    + "\n\n## 上一次输出格式错误:\n"
                    + "\n".join(error_msgs)
                    + "\n\n请修正以上所有错误，重新输出完整且合法的 JSON 数组。"
                )
                continue

            break

        logger.warning(
            "未能从 LLM 响应中提取有效变体意图 (kernel=%s)",
            math_dialect.kernel_name,
        )
        return []

    def _build_user_prompt(
        self,
        *,
        math_dialect: MathDialect,
        quant_specs: dict[str, QuantSpec],
        hw_constraints: str,
        feedback_text: str | None,
        max_variants: int,
    ) -> str:
        """构建用户提示词，包含当前 kernel 的具体信息."""

        # 构建 MathDialect 概要
        nodes_summary = []
        for nid, node in math_dialect.nodes.items():
            nodes_summary.append(
                f"  - {nid}: op_type={node.op_type}, shape={node.shape}, "
                f"inputs={node.input_nodes}"
            )

        # 构建量化概要
        quant_summary = []
        for nid, spec in quant_specs.items():
            quant_summary.append(
                f"  - {nid}: int_bits={spec.recommended_int_bits}, "
                f"frac_bits={spec.recommended_frac_bits}, "
                f"range=[{spec.min_bits}, {spec.max_bits}]"
            )

        # 构建提示词
        prompt_parts = [
            f"## Kernel: {math_dialect.kernel_name}",
            f"类型: {self._kernel_type}",
            f"优化目标: {math_dialect.target_metric}",
            "",
            "## 算法结构 (MathDialect):",
            *nodes_summary,
            "",
            f"输入节点: {math_dialect.input_nodes}",
            f"输出节点: {math_dialect.output_nodes}",
            "",
            "## 量化分析推荐:",
            *(quant_summary if quant_summary else ["  (无量化数据)"]),
            "",
            "## 硬件约束:",
            hw_constraints,
            "",
            f"## 生成要求:",
            f"- 生成 {max_variants} 个不同的变体配置",
            f"- 每个变体必须包含以下字段，缺一不可: variant_name, approx_method, parallelism, enable_saturation",
            f"- variant_name 必须是有意义的描述性名称（如 high_perf_int16_p8），不能省略",
            f"- kernel 类型 '{self._kernel_type}' 的默认近似方法: {self._strategy['default_approx']}",
            f"- 推荐并行度范围: {self._strategy['parallelism_range']}",
            f"- 量化策略: {self._strategy['quant_focus']}",
        ]

        # 如果有反馈，添加反馈信息
        if feedback_text:
            prompt_parts.extend([
                "",
                "## 上一轮验证反馈:",
                feedback_text,
                "",
                "请根据反馈调整设计策略。",
            ])

        prompt_parts.extend([
            "",
            "请输出 JSON 数组格式的变体配置。",
        ])

        return "\n".join(prompt_parts)

    def _parse_response(self, raw: str) -> list[IntentJSON]:
        """解析 LLM 返回的 JSON 响应."""
        text = raw.strip()

        # 移除可能的 markdown 包装
        if text.startswith("```"):
            text = re.sub(r"^```(?:json)?\s*", "", text, flags=re.DOTALL)
            text = re.sub(r"\s*```$", "", text, flags=re.DOTALL)
            text = text.strip()

        # 尝试直接解析 JSON
        try:
            payload = json.loads(text)
        except json.JSONDecodeError:
            # 尝试从文本中提取 JSON 数组
            match = re.search(r"\[.*\]", text, re.DOTALL)
            if match is None:
                logger.warning("无法从响应中提取 JSON: %s", text[:200])
                return []
            payload = json.loads(match.group())

        # 确保是数组
        if isinstance(payload, dict):
            # 单个 intent，包装成数组
            payload = [payload]

        if not isinstance(payload, list):
            logger.warning("响应不是 JSON 数组: %s", type(payload))
            return []

        return payload

    def _validate_intent(
        self,
        intent: IntentJSON,
        math_dialect: MathDialect,
    ) -> bool:
        """校验单个 intent 配置的合法性."""
        required_fields = [
            "variant_name",
            "approx_method",
            "parallelism",
            "enable_saturation",
        ]

        # 检查必需字段
        for field in required_fields:
            if field not in intent:
                logger.warning("Intent 缺少必需字段: %s", field)
                return False

        # 检查 variant_name 格式
        name = intent["variant_name"]
        if not isinstance(name, str) or not name.strip():
            logger.warning("variant_name 无效: %s", name)
            return False

        # 检查 approx_method
        approx = intent["approx_method"]
        if approx not in _VALID_APPROX_METHODS:
            logger.warning("未知的 approx_method: %s", approx)
            return False

        # 检查 parallelism
        par = intent["parallelism"]
        if not isinstance(par, int) or par < 1 or par > 128:
            logger.warning("parallelism 无效: %s", par)
            return False

        # 检查 enable_saturation
        sat = intent["enable_saturation"]
        if not isinstance(sat, bool):
            logger.warning("enable_saturation 必须是 bool: %s", sat)
            return False

        # 可选字段类型检查
        if "scale_factor" in intent:
            sf = intent["scale_factor"]
            if not isinstance(sf, (int, float)):
                logger.warning("scale_factor 必须是数值: %s", sf)
                return False

        if "offset_beta" in intent:
            ob = intent["offset_beta"]
            if not isinstance(ob, (int, float)):
                logger.warning("offset_beta 必须是数值: %s", ob)
                return False

        if "quant_overrides" in intent:
            qo = intent["quant_overrides"]
            if not isinstance(qo, dict):
                logger.warning("quant_overrides 必须是 dict: %s", qo)
                return False

        return True

    def _fallback_intent(
        self,
        math_dialect: MathDialect,
        quant_specs: dict[str, QuantSpec],
    ) -> IntentJSON:
        """生成 fallback 配置（当 LLM 调用失败时）."""
        # 根据量化推荐选择合理的位宽
        quant_overrides = {}
        if quant_specs:
            for nid, spec in quant_specs.items():
                quant_overrides[nid] = spec.recommended_int_bits

        return {
            "variant_name": f"{self._strategy['default_approx']}_baseline_p1",
            "rationale": "Fallback 配置：保守的资源使用",
            "approx_method": self._strategy["default_approx"],
            "scale_factor": 1.0,
            "offset_beta": 0.0,
            "parallelism": 1,
            "quant_overrides": quant_overrides,
            "enable_saturation": True,
        }