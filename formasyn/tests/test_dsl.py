"""Tests for FormaSyn DSL operators and FormulaGraph."""

import pytest

import FormaSyn.formasyn.dsl as fp
from FormaSyn.formasyn.dsl.operators import (
    DelayOp,
    Domain,
    MapOp,
    MessagePassOp,
    ReduceOp,
    ShiftRegOp,
)


class TestLDPCCnuGraph:
    """Verify that an LDPC Min-Sum CNU kernel can be expressed via the DSL."""

    def setup_method(self) -> None:
        self.graph = fp.FormulaGraph(
            name="ldpc_cnu",
            inputs={"msg_in": [8]},
            outputs=["cnu_out"],
        )
        self.graph.add(fp.map("msg_in", func="sign", output="sign_bits"))
        self.graph.add(fp.map("msg_in", func="abs", output="mag_bits"))
        self.graph.add(
            fp.reduce(
                "mag_bits",
                op="min",
                domain=fp.domain.neighbors("H", exclude_self=True),
                output="min_mag",
            )
        )
        self.graph.add(
            fp.reduce(
                "sign_bits",
                op="xor",
                domain=fp.domain.neighbors("H", exclude_self=True),
                output="xor_sign",
            )
        )

    def test_ops_count(self) -> None:
        assert len(self.graph.ops) == 4

    def test_ops_types(self) -> None:
        expected = [MapOp, MapOp, ReduceOp, ReduceOp]
        actual = [type(op) for op in self.graph.ops]
        assert actual == expected

    def test_graph_name(self) -> None:
        assert self.graph.name == "ldpc_cnu"

    def test_input_shape(self) -> None:
        assert self.graph.inputs["msg_in"] == [8]

    def test_reduce_domain(self) -> None:
        reduce_op = self.graph.ops[2]
        assert isinstance(reduce_op, ReduceOp)
        assert reduce_op.domain.kind == "neighbors"
        assert reduce_op.domain.graph_ref == "H"
        assert reduce_op.domain.exclude_self is True


class TestFIRGraph:
    """Verify that an FIR filter kernel can be expressed via the DSL."""

    def setup_method(self) -> None:
        self.graph = fp.FormulaGraph(
            name="fir_filter",
            inputs={"x_in": [1]},
            outputs=["y_out"],
        )
        self.graph.add(
            fp.shift_reg("x_in", taps=[0, 1, 2, 3], output="taps")
        )
        self.graph.add(
            fp.map("taps", func="multiply", output="products", coeff=0.25)
        )
        self.graph.add(
            fp.reduce(
                "products",
                op="add",
                domain=fp.domain.all(),
                output="y_out",
            )
        )

    def test_ops_count(self) -> None:
        assert len(self.graph.ops) == 3

    def test_ops_types(self) -> None:
        expected = [ShiftRegOp, MapOp, ReduceOp]
        actual = [type(op) for op in self.graph.ops]
        assert actual == expected

    def test_shift_reg_taps(self) -> None:
        sr = self.graph.ops[0]
        assert isinstance(sr, ShiftRegOp)
        assert sr.taps == [0, 1, 2, 3]

    def test_map_func_params(self) -> None:
        m = self.graph.ops[1]
        assert isinstance(m, MapOp)
        assert m.func == "multiply"
        assert m.func_params["coeff"] == 0.25

    def test_reduce_domain_all(self) -> None:
        r = self.graph.ops[2]
        assert isinstance(r, ReduceOp)
        assert r.domain.kind == "all"


class TestDomainValidation:
    """Domain __post_init__ guards."""

    def test_neighbors_requires_graph_ref(self) -> None:
        with pytest.raises(ValueError, match="graph_ref is required"):
            Domain(kind="neighbors")

    def test_window_requires_size(self) -> None:
        with pytest.raises(ValueError, match="window_size is required"):
            Domain(kind="window")

    def test_invalid_kind(self) -> None:
        with pytest.raises(ValueError, match="Invalid domain kind"):
            Domain(kind="invalid")

    def test_valid_neighbors(self) -> None:
        d = Domain(kind="neighbors", graph_ref="H")
        assert d.graph_ref == "H"

    def test_valid_window(self) -> None:
        d = Domain(kind="window", window_size=4, window_stride=2)
        assert d.window_size == 4
        assert d.window_stride == 2


class TestMapFuncValidation:
    """MapOp __post_init__ guards."""

    def test_invalid_func_raises(self) -> None:
        with pytest.raises(ValueError, match="Invalid map func"):
            MapOp(input_ref="x", func="nonexistent", output_ref="y")

    def test_valid_funcs(self) -> None:
        for fn in ("sign", "abs", "multiply", "tanh", "atanh",
                    "lut", "clamp", "quantize", "xor_reduce"):
            op = MapOp(input_ref="x", func=fn, output_ref="y")
            assert op.func == fn


class TestReduceOpValidation:
    """ReduceOp __post_init__ guards."""

    def test_invalid_op_raises(self) -> None:
        with pytest.raises(ValueError, match="Invalid reduce op"):
            ReduceOp(input_ref="x", op="median", output_ref="y")

    def test_valid_ops(self) -> None:
        for op_name in ("add", "mul", "min", "max", "xor"):
            op = ReduceOp(input_ref="x", op=op_name, output_ref="y")
            assert op.op == op_name


class TestDelayOp:
    """DelayOp construction."""

    def test_default_steps(self) -> None:
        op = fp.delay("x", output="x_d")
        assert isinstance(op, DelayOp)
        assert op.steps == 1

    def test_custom_steps(self) -> None:
        op = fp.delay("x", steps=3, output="x_d3")
        assert op.steps == 3


class TestMessagePassOp:
    """MessagePassOp construction and validation."""

    def test_valid_construction(self) -> None:
        fwd_map = fp.map("msg", func="sign", output="s")
        fwd_red = fp.reduce(
            "s", op="xor",
            domain=fp.domain.neighbors("H", exclude_self=True),
            output="agg",
        )
        op = fp.message_pass(
            graph_ref="H",
            node_type="check_node",
            forward_map=fwd_map,
            forward_reduce=fwd_red,
            output="mp_out",
        )
        assert isinstance(op, MessagePassOp)
        assert op.schedule == "flooding"

    def test_invalid_node_type(self) -> None:
        with pytest.raises(ValueError, match="Invalid node_type"):
            MessagePassOp(
                graph_ref="H",
                node_type="bad_type",
                output_ref="out",
            )

    def test_invalid_schedule(self) -> None:
        with pytest.raises(ValueError, match="Invalid schedule"):
            MessagePassOp(
                graph_ref="H",
                node_type="check_node",
                schedule="unknown",
                output_ref="out",
            )
