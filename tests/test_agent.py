"""Tests for FormaSyn LLM DSE Agent and communication knowledge prompt."""

from __future__ import annotations

import json
from typing import get_type_hints
from unittest.mock import MagicMock, patch

import pytest

from FormaSyn.agent.dse_agent import (
    DSEAgent,
    IntentJSON,
    QuantSpec,
    _VALID_APPROX_METHODS,
)
from FormaSyn.agent.knowledge_prompt import COMM_KNOWLEDGE_PROMPT
from FormaSyn.ir.math_dialect import MathDialect


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture()
def ldpc_dialect() -> MathDialect:
    return MathDialect.example_ldpc_cnu()


@pytest.fixture()
def sample_quant_specs() -> dict[str, QuantSpec]:
    return {
        "msg_in": QuantSpec("msg_in", 8, 0, 5, 16),
        "sign_map": QuantSpec("sign_map", 1, 0, 1, 1),
        "abs_map": QuantSpec("abs_map", 7, 0, 5, 8),
        "xor_reduce": QuantSpec("xor_reduce", 1, 0, 1, 1),
        "min_reduce": QuantSpec("min_reduce", 7, 0, 5, 8),
    }


@pytest.fixture()
def agent() -> DSEAgent:
    return DSEAgent(model="test-model", max_variants=4)


def _make_valid_intent(**overrides: object) -> dict:
    """Return a minimal valid intent dict, optionally overriding fields."""
    base: dict = {
        "variant_name": "min_sum_int8_p8",
        "rationale": "Min-Sum 近似，8bit 量化，全并行",
        "approx_method": "min_sum",
        "scale_factor": 1.0,
        "offset_beta": 0.0,
        "parallelism": 8,
        "quant_overrides": {},
        "enable_saturation": True,
    }
    base.update(overrides)
    return base


# ---------------------------------------------------------------------------
# COMM_KNOWLEDGE_PROMPT
# ---------------------------------------------------------------------------

class TestCommKnowledgePrompt:
    """Verify the knowledge prompt constant covers required topics."""

    def test_non_empty(self) -> None:
        assert len(COMM_KNOWLEDGE_PROMPT) > 100

    def test_contains_ldpc_approximations(self) -> None:
        for keyword in ("SPA", "Min-Sum", "Offset Min-Sum", "Normalized Min-Sum", "LUT-tanh"):
            assert keyword in COMM_KNOWLEDGE_PROMPT, f"缺少关键词: {keyword}"

    def test_contains_quantisation_knowledge(self) -> None:
        for keyword in ("LLR", "saturation", "符号位"):
            assert keyword in COMM_KNOWLEDGE_PROMPT, f"缺少关键词: {keyword}"

    def test_contains_hardware_cost_table(self) -> None:
        for keyword in ("DSP", "BRAM18", "LUT"):
            assert keyword in COMM_KNOWLEDGE_PROMPT, f"缺少关键词: {keyword}"

    def test_contains_parallelism_guidance(self) -> None:
        assert "parallelism" in COMM_KNOWLEDGE_PROMPT
        assert "II=1" in COMM_KNOWLEDGE_PROMPT


# ---------------------------------------------------------------------------
# IntentJSON TypedDict
# ---------------------------------------------------------------------------

class TestIntentJSON:
    """Verify IntentJSON has the expected fields."""

    def test_required_fields(self) -> None:
        hints = get_type_hints(IntentJSON)
        expected = {
            "variant_name", "rationale", "approx_method",
            "scale_factor", "offset_beta", "parallelism",
            "quant_overrides", "enable_saturation",
        }
        assert set(hints.keys()) == expected

    def test_can_construct(self) -> None:
        intent = IntentJSON(
            variant_name="test",
            rationale="test",
            approx_method="min_sum",
            scale_factor=1.0,
            offset_beta=0.0,
            parallelism=4,
            quant_overrides={},
            enable_saturation=True,
        )
        assert intent["variant_name"] == "test"


# ---------------------------------------------------------------------------
# QuantSpec
# ---------------------------------------------------------------------------

class TestQuantSpec:
    """Verify QuantSpec dataclass."""

    def test_construction(self) -> None:
        qs = QuantSpec("node_a", 8, 4, 6, 16)
        assert qs.node_id == "node_a"
        assert qs.recommended_int_bits == 8
        assert qs.recommended_frac_bits == 4
        assert qs.min_bits == 6
        assert qs.max_bits == 16


# ---------------------------------------------------------------------------
# DSEAgent prompt building
# ---------------------------------------------------------------------------

class TestDSEAgentPromptBuilding:
    """Verify system and user prompt assembly."""

    def test_system_prompt_contains_knowledge(self, agent: DSEAgent) -> None:
        sys_prompt = agent._build_system_prompt()
        assert "LDPC" in sys_prompt
        assert "saturation" in sys_prompt

    def test_system_prompt_contains_schema(self, agent: DSEAgent) -> None:
        sys_prompt = agent._build_system_prompt()
        assert "variant_name" in sys_prompt
        assert "approx_method" in sys_prompt
        assert "JSON 数组" in sys_prompt

    def test_system_prompt_respects_max_variants(self, agent: DSEAgent) -> None:
        sys_prompt = agent._build_system_prompt()
        assert "4" in sys_prompt

    def test_user_prompt_contains_kernel_name(
        self,
        agent: DSEAgent,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        prompt = agent._build_user_prompt(
            ldpc_dialect, sample_quant_specs, "xczu7ev",
        )
        assert "ldpc_cnu" in prompt

    def test_user_prompt_contains_node_table(
        self,
        agent: DSEAgent,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        prompt = agent._build_user_prompt(
            ldpc_dialect, sample_quant_specs, "xczu7ev",
        )
        assert "msg_in" in prompt
        assert "sign_map" in prompt
        assert "op_type" in prompt

    def test_user_prompt_contains_quant_table(
        self,
        agent: DSEAgent,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        prompt = agent._build_user_prompt(
            ldpc_dialect, sample_quant_specs, "xczu7ev",
        )
        assert "推荐整数位宽" in prompt

    def test_user_prompt_contains_hw_constraint(
        self,
        agent: DSEAgent,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        prompt = agent._build_user_prompt(
            ldpc_dialect, sample_quant_specs, "xczu7ev",
        )
        assert "xczu7ev" in prompt

    def test_user_prompt_with_feedback(
        self,
        agent: DSEAgent,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        prompt = agent._build_user_prompt(
            ldpc_dialect, sample_quant_specs, "xczu7ev",
            feedback_text="DSP 超标 200%",
        )
        assert "DSP 超标 200%" in prompt
        assert "上一轮优化失败原因" in prompt

    def test_user_prompt_without_feedback_omits_section(
        self,
        agent: DSEAgent,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        prompt = agent._build_user_prompt(
            ldpc_dialect, sample_quant_specs, "xczu7ev",
        )
        assert "上一轮优化失败原因" not in prompt

    def test_user_prompt_empty_quant_specs(
        self,
        agent: DSEAgent,
        ldpc_dialect: MathDialect,
    ) -> None:
        prompt = agent._build_user_prompt(ldpc_dialect, {}, "xczu7ev")
        assert "推荐整数位宽" not in prompt


# ---------------------------------------------------------------------------
# DSEAgent response parsing
# ---------------------------------------------------------------------------

class TestDSEAgentParsing:
    """Verify _parse_response handles various LLM output formats."""

    def test_valid_json_array(self, agent: DSEAgent) -> None:
        raw = json.dumps([_make_valid_intent()])
        result = agent._parse_response(raw)
        assert len(result) == 1
        assert result[0]["variant_name"] == "min_sum_int8_p8"

    def test_multiple_valid_intents(self, agent: DSEAgent) -> None:
        intents = [
            _make_valid_intent(variant_name="v1"),
            _make_valid_intent(variant_name="v2", approx_method="lut_tanh"),
        ]
        result = agent._parse_response(json.dumps(intents))
        assert len(result) == 2

    def test_json_wrapped_in_markdown(self, agent: DSEAgent) -> None:
        """LLM sometimes wraps JSON in markdown code blocks."""
        raw = "```json\n" + json.dumps([_make_valid_intent()]) + "\n```"
        result = agent._parse_response(raw)
        assert len(result) == 1

    def test_json_with_surrounding_text(self, agent: DSEAgent) -> None:
        raw = "以下是生成的变体：\n" + json.dumps([_make_valid_intent()]) + "\n希望以上结果有帮助。"
        result = agent._parse_response(raw)
        assert len(result) == 1

    def test_invalid_json_returns_empty(self, agent: DSEAgent) -> None:
        result = agent._parse_response("这不是 JSON")
        assert result == []

    def test_json_object_not_array_returns_empty(self, agent: DSEAgent) -> None:
        result = agent._parse_response(json.dumps({"key": "value"}))
        assert result == []

    def test_invalid_approx_method_filtered(self, agent: DSEAgent) -> None:
        raw = json.dumps([_make_valid_intent(approx_method="turbo_map")])
        result = agent._parse_response(raw)
        assert len(result) == 0

    def test_non_power_of_two_parallelism_filtered(self, agent: DSEAgent) -> None:
        raw = json.dumps([_make_valid_intent(parallelism=6)])
        result = agent._parse_response(raw)
        assert len(result) == 0

    def test_zero_parallelism_filtered(self, agent: DSEAgent) -> None:
        raw = json.dumps([_make_valid_intent(parallelism=0)])
        result = agent._parse_response(raw)
        assert len(result) == 0

    def test_normalized_min_sum_scale_factor_validation(self, agent: DSEAgent) -> None:
        good = _make_valid_intent(
            approx_method="normalized_min_sum", scale_factor=0.75,
        )
        bad = _make_valid_intent(
            variant_name="bad",
            approx_method="normalized_min_sum", scale_factor=0.5,
        )
        raw = json.dumps([good, bad])
        result = agent._parse_response(raw)
        assert len(result) == 1
        assert result[0]["scale_factor"] == 0.75

    def test_offset_min_sum_beta_validation(self, agent: DSEAgent) -> None:
        good = _make_valid_intent(
            approx_method="offset_min_sum", offset_beta=0.3,
        )
        bad = _make_valid_intent(
            variant_name="bad",
            approx_method="offset_min_sum", offset_beta=0.05,
        )
        raw = json.dumps([good, bad])
        result = agent._parse_response(raw)
        assert len(result) == 1
        assert result[0]["offset_beta"] == 0.3

    def test_max_variants_truncation(self) -> None:
        agent = DSEAgent(model="test-model", max_variants=2)
        intents = [_make_valid_intent(variant_name=f"v{i}") for i in range(5)]
        result = agent._parse_response(json.dumps(intents))
        assert len(result) == 2

    def test_missing_required_field_filtered(self, agent: DSEAgent) -> None:
        bad = {"rationale": "test", "approx_method": "min_sum", "parallelism": 4}
        raw = json.dumps([bad])
        result = agent._parse_response(raw)
        assert len(result) == 0

    def test_defaults_for_optional_fields(self, agent: DSEAgent) -> None:
        minimal = {
            "variant_name": "minimal",
            "rationale": "test",
            "approx_method": "min_sum",
            "parallelism": 4,
        }
        result = agent._parse_response(json.dumps([minimal]))
        assert len(result) == 1
        assert result[0]["scale_factor"] == 1.0
        assert result[0]["offset_beta"] == 0.0
        assert result[0]["enable_saturation"] is True
        assert result[0]["quant_overrides"] == {}


# ---------------------------------------------------------------------------
# DSEAgent.generate_intents (with mocked LLM)
# ---------------------------------------------------------------------------

class TestDSEAgentGenerateIntents:
    """End-to-end test with mocked OpenAI API."""

    def _mock_response(self, content: str) -> MagicMock:
        """Build a mock ChatCompletion response."""
        msg = MagicMock()
        msg.content = content
        choice = MagicMock()
        choice.message = msg
        resp = MagicMock()
        resp.choices = [choice]
        return resp

    def test_successful_generation(
        self,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        agent = DSEAgent(model="test-model", max_variants=4)

        intents_data = [
            _make_valid_intent(variant_name="ms_int8_p8"),
            _make_valid_intent(
                variant_name="oms_int8_p4",
                approx_method="offset_min_sum",
                offset_beta=0.3,
                parallelism=4,
            ),
        ]

        with patch.object(
            agent._client.chat.completions, "create",
            return_value=self._mock_response(json.dumps(intents_data)),
        ):
            result = agent.generate_intents(
                ldpc_dialect, sample_quant_specs, "xczu7ev",
            )

        assert len(result) == 2
        assert result[0]["variant_name"] == "ms_int8_p8"
        assert result[1]["approx_method"] == "offset_min_sum"

    def test_api_failure_returns_empty(
        self,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        agent = DSEAgent(model="test-model", max_variants=4)

        with patch.object(
            agent._client.chat.completions, "create",
            side_effect=Exception("API 连接超时"),
        ):
            result = agent.generate_intents(
                ldpc_dialect, sample_quant_specs, "xczu7ev",
            )

        assert result == []

    def test_empty_response_returns_empty(
        self,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        agent = DSEAgent(model="test-model", max_variants=4)

        with patch.object(
            agent._client.chat.completions, "create",
            return_value=self._mock_response(""),
        ):
            result = agent.generate_intents(
                ldpc_dialect, sample_quant_specs, "xczu7ev",
            )

        assert result == []

    def test_with_feedback_text(
        self,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        agent = DSEAgent(model="test-model", max_variants=4)

        intents_data = [_make_valid_intent(variant_name="retry_v1")]

        with patch.object(
            agent._client.chat.completions, "create",
            return_value=self._mock_response(json.dumps(intents_data)),
        ) as mock_create:
            result = agent.generate_intents(
                ldpc_dialect,
                sample_quant_specs,
                "xczu7ev",
                feedback_text="上轮 DSP 超出限制",
            )

        assert len(result) == 1
        call_args = mock_create.call_args
        user_msg = call_args[1]["messages"][1]["content"]
        assert "上轮 DSP 超出限制" in user_msg

    def test_llm_called_with_correct_model(
        self,
        ldpc_dialect: MathDialect,
        sample_quant_specs: dict[str, QuantSpec],
    ) -> None:
        agent = DSEAgent(model="my-custom-model", max_variants=4)

        with patch.object(
            agent._client.chat.completions, "create",
            return_value=self._mock_response(json.dumps([_make_valid_intent()])),
        ) as mock_create:
            agent.generate_intents(ldpc_dialect, sample_quant_specs, "xczu7ev")

        call_args = mock_create.call_args
        assert call_args[1]["model"] == "my-custom-model"
