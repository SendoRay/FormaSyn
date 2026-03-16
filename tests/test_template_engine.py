"""Tests for dsl.template_engine – TemplateEngine.render()."""

from __future__ import annotations

import pytest

from FormaSyn.agent.dse_agent import IntentJSON
from FormaSyn.dsl.template_engine import TemplateEngine
from FormaSyn.golden.quant_analyzer import QuantSpec
from FormaSyn.ir.math_dialect import MathDialect, MathNode


# ---------------------------------------------------------------------------
# Fixtures: SPA-exact LDPC CNU MathDialect (with tanh / atanh nodes)
# ---------------------------------------------------------------------------

def _build_spa_exact_ldpc_cnu() -> MathDialect:
    """SPA-exact CNU topology::

        msg_in → tanh_map → prod_reduce(mul, neighbors) → atanh_map → output
    """
    nodes = {
        "msg_in": MathNode(
            node_id="msg_in",
            op_type="input",
            shape=[8],
            input_nodes=[],
        ),
        "tanh_map": MathNode(
            node_id="tanh_map",
            op_type="map",
            op_detail={"func": "tanh"},
            shape=[8],
            input_nodes=["msg_in"],
        ),
        "prod_reduce": MathNode(
            node_id="prod_reduce",
            op_type="reduce",
            op_detail={"op": "mul", "domain_kind": "neighbors",
                       "exclude_self": True},
            shape=[1],
            input_nodes=["tanh_map"],
            is_irregular_access=True,
            csr_ref="H_csr",
        ),
        "atanh_map": MathNode(
            node_id="atanh_map",
            op_type="map",
            op_detail={"func": "atanh"},
            shape=[1],
            input_nodes=["prod_reduce"],
        ),
    }
    return MathDialect(
        kernel_name="ldpc_cnu",
        nodes=nodes,
        input_nodes=["msg_in"],
        output_nodes=["atanh_map"],
        target_metric="throughput",
        hw_constraint="xczu7ev",
    )


def _make_quant_specs() -> dict[str, QuantSpec]:
    """QuantSpecs for every node in the SPA-exact CNU."""
    specs: dict[str, QuantSpec] = {}
    for nid in ("msg_in", "tanh_map", "prod_reduce", "atanh_map"):
        specs[nid] = QuantSpec(
            node_id=nid,
            recommended_int_bits=4,
            recommended_frac_bits=4,
            min_int_bits=3,
            max_int_bits=6,
            max_abs_observed=7.5,
        )
    return specs


def _make_min_sum_intent() -> IntentJSON:
    return IntentJSON(
        variant_name="min_sum_int8_p8",
        rationale="Min-Sum approximation for low-complexity CNU",
        approx_method="min_sum",
        scale_factor=1.0,
        offset_beta=0.0,
        parallelism=8,
        quant_overrides={},
        enable_saturation=True,
    )


# ---------------------------------------------------------------------------
# Test class
# ---------------------------------------------------------------------------

class TestTemplateEngineMinSum:
    """Min-Sum approximation rendering tests."""

    @pytest.fixture(autouse=True)
    def _setup(self) -> None:
        self.engine = TemplateEngine()
        self.math_dialect = _build_spa_exact_ldpc_cnu()
        self.quant_specs = _make_quant_specs()
        self.intent = _make_min_sum_intent()
        self.result = self.engine.render(
            self.intent, self.math_dialect, self.quant_specs,
        )

    def test_min_sum_no_tanh(self) -> None:
        """After min_sum render, no func='tanh' nodes should remain."""
        for node in self.result.nodes.values():
            assert node.op_detail.get("func") != "tanh", (
                f"Node {node.node_id} still has func='tanh'"
            )

    def test_min_sum_no_atanh(self) -> None:
        """After min_sum render, no func='atanh' nodes should remain."""
        for node in self.result.nodes.values():
            assert node.op_detail.get("func") != "atanh", (
                f"Node {node.node_id} still has func='atanh'"
            )

    def test_min_sum_has_sign_and_abs(self) -> None:
        """Min-sum must produce sign and abs map nodes."""
        funcs = {
            n.op_detail.get("func")
            for n in self.result.nodes.values()
            if n.op_type == "map"
        }
        assert "sign" in funcs, "Missing sign map node"
        assert "abs" in funcs, "Missing abs map node"

    def test_min_sum_has_xor_and_min_reduce(self) -> None:
        """Min-sum must produce xor-reduce and min-reduce."""
        reduce_ops = {
            n.op_detail.get("op")
            for n in self.result.nodes.values()
            if n.op_type == "reduce"
        }
        assert "xor" in reduce_ops, "Missing xor reduce"
        assert "min" in reduce_ops, "Missing min reduce"

    def test_min_sum_has_scale_multiply(self) -> None:
        """Min-sum must insert a multiply(coeff=0.75) scale node."""
        scale_nodes = [
            n for n in self.result.nodes.values()
            if (n.op_type == "map"
                and n.op_detail.get("func") == "multiply"
                and n.op_detail.get("func_params", {}).get("coeff") == 0.75)
        ]
        assert len(scale_nodes) > 0, "Missing scale multiply node"

    def test_all_nodes_have_data_type(self) -> None:
        """Every node must have a non-empty, non-float64 data_type."""
        for nid, node in self.result.nodes.items():
            assert node.data_type, f"Node {nid} has empty data_type"
            assert node.data_type != "float64", (
                f"Node {nid} still has default float64"
            )

    def test_variant_id(self) -> None:
        """variant_id must equal intent['variant_name']."""
        assert self.result.variant_id == "min_sum_int8_p8"

    def test_parallelism_propagated(self) -> None:
        """All nodes must have parallelism == 8."""
        for nid, node in self.result.nodes.items():
            assert node.parallelism == 8, (
                f"Node {nid} parallelism={node.parallelism}, expected 8"
            )

    def test_saturation_guard(self) -> None:
        """All nodes must have saturation_guard == True."""
        for nid, node in self.result.nodes.items():
            assert node.saturation_guard is True, (
                f"Node {nid} saturation_guard is False"
            )

    def test_estimated_dsp(self) -> None:
        """DSP estimate must be a non-negative integer."""
        assert self.result.estimated_dsp is not None
        assert self.result.estimated_dsp >= 0


class TestTemplateEngineSpaExact:
    """SPA-exact passthrough tests."""

    def test_spa_exact_preserves_tanh(self) -> None:
        """spa_exact must keep tanh / atanh nodes unchanged."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="spa_exact_fp16",
            rationale="Exact SPA for reference BER",
            approx_method="spa_exact",
            scale_factor=1.0,
            offset_beta=0.0,
            parallelism=4,
            quant_overrides={},
            enable_saturation=False,
        )
        result = engine.render(intent, dialect, _make_quant_specs())

        funcs = {
            n.op_detail.get("func")
            for n in result.nodes.values()
            if n.op_type == "map"
        }
        assert "tanh" in funcs, "spa_exact should preserve tanh"
        assert "atanh" in funcs, "spa_exact should preserve atanh"

    def test_spa_exact_node_count(self) -> None:
        """spa_exact must not add or remove nodes."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="spa_exact_fp16",
            rationale="Exact SPA",
            approx_method="spa_exact",
            scale_factor=1.0,
            offset_beta=0.0,
            parallelism=1,
            quant_overrides={},
            enable_saturation=False,
        )
        result = engine.render(intent, dialect, _make_quant_specs())
        assert len(result.nodes) == len(dialect.nodes)


class TestTemplateEngineOffsetMinSum:
    """Offset Min-Sum tests."""

    def test_offset_min_sum_has_clamp(self) -> None:
        """offset_min_sum must insert a clamp node."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="offset_ms_int8_p4",
            rationale="Offset min-sum with beta=0.15",
            approx_method="offset_min_sum",
            scale_factor=1.0,
            offset_beta=0.15,
            parallelism=4,
            quant_overrides={},
            enable_saturation=True,
        )
        result = engine.render(intent, dialect, _make_quant_specs())

        clamp_nodes = [
            n for n in result.nodes.values()
            if n.op_detail.get("func") == "clamp"
        ]
        assert len(clamp_nodes) > 0, "Missing clamp node in offset_min_sum"

    def test_offset_min_sum_has_sub_beta(self) -> None:
        """offset_min_sum must insert an add(coeff=-beta) node."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="offset_ms_int8_p4",
            rationale="Offset min-sum",
            approx_method="offset_min_sum",
            scale_factor=1.0,
            offset_beta=0.25,
            parallelism=4,
            quant_overrides={},
            enable_saturation=True,
        )
        result = engine.render(intent, dialect, _make_quant_specs())

        add_nodes = [
            n for n in result.nodes.values()
            if (n.op_detail.get("func") == "add"
                and n.op_detail.get("func_params", {}).get("coeff") == -0.25)
        ]
        assert len(add_nodes) > 0, "Missing add(coeff=-beta) node"


class TestTemplateEngineNormalizedMinSum:
    """Normalized Min-Sum tests."""

    def test_normalized_min_sum_custom_scale(self) -> None:
        """normalized_min_sum must use intent['scale_factor'] for multiply."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="nms_int8_p8",
            rationale="Normalized min-sum, scale=0.8",
            approx_method="normalized_min_sum",
            scale_factor=0.8,
            offset_beta=0.0,
            parallelism=8,
            quant_overrides={},
            enable_saturation=True,
        )
        result = engine.render(intent, dialect, _make_quant_specs())

        scale_nodes = [
            n for n in result.nodes.values()
            if (n.op_detail.get("func") == "multiply"
                and n.op_detail.get("func_params", {}).get("coeff") == 0.8)
        ]
        assert len(scale_nodes) > 0, (
            "Missing multiply(coeff=0.8) in normalized_min_sum"
        )


class TestTemplateEngineLutTanh:
    """LUT-tanh tests."""

    def test_lut_tanh_replacement(self) -> None:
        """lut_tanh must replace tanh with lut and add table_depth."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="lut_tanh_int8_p4",
            rationale="LUT-based tanh approximation",
            approx_method="lut_tanh",
            scale_factor=1.0,
            offset_beta=0.0,
            parallelism=4,
            quant_overrides={},
            enable_saturation=False,
        )
        result = engine.render(intent, dialect, _make_quant_specs())

        lut_nodes = [
            n for n in result.nodes.values()
            if n.op_detail.get("func") == "lut"
        ]
        assert len(lut_nodes) > 0, "Missing lut node"
        assert lut_nodes[0].op_detail["func_params"]["table_depth"] == 256

        tanh_nodes = [
            n for n in result.nodes.values()
            if n.op_detail.get("func") == "tanh"
        ]
        assert len(tanh_nodes) == 0, "tanh nodes should be replaced"


class TestTemplateEngineQuant:
    """Quantisation annotation tests."""

    def test_quant_overrides_applied(self) -> None:
        """quant_overrides must take precedence over quant_specs."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="spa_override",
            rationale="Test quant overrides",
            approx_method="spa_exact",
            scale_factor=1.0,
            offset_beta=0.0,
            parallelism=1,
            quant_overrides={"msg_in": 16},
            enable_saturation=False,
        )
        result = engine.render(intent, dialect, _make_quant_specs())

        msg_node = result.nodes["msg_in"]
        assert msg_node.data_type == "ap_int<16>"
        assert msg_node.quant_int_bits == 16
        assert msg_node.quant_frac_bits == 0

    def test_quant_specs_used_when_no_override(self) -> None:
        """When no override exists, quant_specs recommendations are used."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="spa_qs",
            rationale="Test quant specs",
            approx_method="spa_exact",
            scale_factor=1.0,
            offset_beta=0.0,
            parallelism=1,
            quant_overrides={},
            enable_saturation=False,
        )
        specs = _make_quant_specs()
        result = engine.render(intent, dialect, specs)

        msg_node = result.nodes["msg_in"]
        assert msg_node.data_type == "ap_fixed<8,4>"
        assert msg_node.quant_int_bits == 4
        assert msg_node.quant_frac_bits == 4

    def test_default_quant_for_unknown_node(self) -> None:
        """Nodes not in overrides or specs get default int8."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="spa_default",
            rationale="Test defaults",
            approx_method="spa_exact",
            scale_factor=1.0,
            offset_beta=0.0,
            parallelism=1,
            quant_overrides={},
            enable_saturation=False,
        )
        result = engine.render(intent, dialect, {})

        for node in result.nodes.values():
            assert node.data_type == "ap_int<8>"
            assert node.quant_int_bits == 8
            assert node.quant_frac_bits == 0


class TestTemplateEngineIntentJson:
    """Intent JSON preservation test."""

    def test_intent_json_stored(self) -> None:
        """The original intent must be stored verbatim in the dialect."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = _make_min_sum_intent()
        result = engine.render(intent, dialect, _make_quant_specs())

        assert result.intent_json["approx_method"] == "min_sum"
        assert result.intent_json["parallelism"] == 8
        assert result.intent_json["variant_name"] == "min_sum_int8_p8"

    def test_parent_kernel_name(self) -> None:
        """parent_kernel_name must come from the MathDialect."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = _make_min_sum_intent()
        result = engine.render(intent, dialect, _make_quant_specs())

        assert result.parent_kernel_name == "ldpc_cnu"


class TestTemplateEngineInvalidApprox:
    """Error handling tests."""

    def test_unknown_approx_raises(self) -> None:
        """An unknown approx_method must raise ValueError."""
        engine = TemplateEngine()
        dialect = _build_spa_exact_ldpc_cnu()
        intent = IntentJSON(
            variant_name="bad",
            rationale="Invalid",
            approx_method="turbo_magic",
            scale_factor=1.0,
            offset_beta=0.0,
            parallelism=1,
            quant_overrides={},
            enable_saturation=False,
        )
        with pytest.raises(ValueError, match="turbo_magic"):
            engine.render(intent, dialect, {})
