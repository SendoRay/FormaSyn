"""Tests for the golden model generator and quantisation analyser."""

import math

import pytest

from FormaSyn.golden.generator import GoldenCompileError, GoldenModelGenerator
from FormaSyn.golden.quant_analyzer import QuantizationAnalyzer, QuantSpec
from FormaSyn.ir.math_dialect import MathDialect


# -- Small H-matrix CSR for testing ----------------------------------------
# 4x8 parity-check matrix (4 check nodes, 8 variable nodes):
#   [[1,1,1,0,1,0,0,0],
#    [0,1,0,1,0,1,1,0],
#    [1,0,0,1,0,0,1,1],
#    [0,0,1,0,1,1,0,1]]
# Each row has 4 nonzeros → row_ptr increments by 4.
_ROW_PTR = [0, 4, 8, 12, 16]
_COL_IDX = [0, 1, 2, 4, 1, 3, 5, 6, 0, 3, 6, 7, 2, 4, 5, 7]

# The example_ldpc_cnu has shape [8] for msg_in, but the reduce nodes have
# domain_kind="neighbors" which iterates over rows of the H-matrix.  We
# build a modified dialect with shape [4] on the output nodes (num check nodes)
# and shape [8] on intermediate nodes to match the 4x8 H-matrix above.


def _ldpc_dialect_for_test() -> MathDialect:
    """Return an LDPC CNU MathDialect sized to match the 4x8 test H-matrix."""
    from FormaSyn.ir.math_dialect import MathNode

    nodes = {
        "msg_in": MathNode(
            node_id="msg_in",
            op_type="input",
            shape=[8],
            input_nodes=[],
        ),
        "sign_map": MathNode(
            node_id="sign_map",
            op_type="map",
            op_detail={"func": "sign"},
            shape=[8],
            input_nodes=["msg_in"],
        ),
        "abs_map": MathNode(
            node_id="abs_map",
            op_type="map",
            op_detail={"func": "abs"},
            shape=[8],
            input_nodes=["msg_in"],
        ),
        "xor_reduce": MathNode(
            node_id="xor_reduce",
            op_type="reduce",
            op_detail={"op": "xor", "domain_kind": "neighbors",
                       "exclude_self": True},
            shape=[8],
            input_nodes=["sign_map"],
            is_irregular_access=True,
            csr_ref="H_csr",
        ),
        "min_reduce": MathNode(
            node_id="min_reduce",
            op_type="reduce",
            op_detail={"op": "min", "domain_kind": "neighbors",
                       "exclude_self": True},
            shape=[8],
            input_nodes=["abs_map"],
            is_irregular_access=True,
            csr_ref="H_csr",
        ),
    }
    return MathDialect(
        kernel_name="ldpc_cnu",
        nodes=nodes,
        input_nodes=["msg_in"],
        output_nodes=["xor_reduce", "min_reduce"],
        target_metric="throughput",
        hw_constraint="xczu7ev",
    )


_TEST_CSR = {"row_ptr": _ROW_PTR, "col_idx": _COL_IDX}
_TEST_INPUT = {"msg_in": [1.2, -0.8, 2.1, -1.5, 0.9, -2.3, 1.7, -0.6]}


class TestGoldenGenerate:
    """Verify C++ code generation from MathDialect."""

    def test_contains_std_abs(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        code = gen.generate(md)
        assert "std::abs" in code

    def test_contains_sign_ternary(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        code = gen.generate(md)
        assert ">= 0" in code

    def test_output_params_present(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        code = gen.generate(md)
        assert "xor_reduce_out" in code
        assert "min_reduce_out" in code

    def test_csr_params_present(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        code = gen.generate(md)
        assert "row_ptr" in code
        assert "col_idx" in code


class TestGoldenCompileAndRun:
    """Verify compilation and execution of the golden model."""

    def test_output_length(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        code = gen.generate(md)
        result = gen.compile_and_run(
            code, _TEST_INPUT, md, csr_data=_TEST_CSR,
        )
        num_check_nodes = len(_ROW_PTR) - 1
        assert "xor_reduce" in result
        assert "min_reduce" in result
        assert len(result["xor_reduce"]) == num_check_nodes
        assert len(result["min_reduce"]) == num_check_nodes

    def test_no_nan_inf(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        code = gen.generate(md)
        result = gen.compile_and_run(
            code, _TEST_INPUT, md, csr_data=_TEST_CSR,
        )
        for name, values in result.items():
            for v in values:
                assert math.isfinite(v), (
                    f"{name} contains non-finite value: {v}"
                )

    def test_min_reduce_values_positive(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        code = gen.generate(md)
        result = gen.compile_and_run(
            code, _TEST_INPUT, md, csr_data=_TEST_CSR,
        )
        for v in result["min_reduce"]:
            assert v >= 0.0, "min of abs values must be non-negative"

    def test_xor_reduce_values_are_sign(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        code = gen.generate(md)
        result = gen.compile_and_run(
            code, _TEST_INPUT, md, csr_data=_TEST_CSR,
        )
        for v in result["xor_reduce"]:
            assert v in (1.0, -1.0), f"XOR sign must be +/-1, got {v}"


class TestQuantizationAnalyzer:
    """Verify quantisation analysis produces valid recommendations."""

    def test_recommended_int_bits_at_least_one(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        analyzer = QuantizationAnalyzer(target_total_bits=16)
        specs = analyzer.analyze(
            gen, md, _TEST_INPUT, n_trials=5, csr_data=_TEST_CSR,
        )
        for node_id, spec in specs.items():
            assert spec.recommended_int_bits >= 1, (
                f"{node_id}: int_bits={spec.recommended_int_bits} < 1"
            )

    def test_all_output_nodes_covered(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        analyzer = QuantizationAnalyzer(target_total_bits=16)
        specs = analyzer.analyze(
            gen, md, _TEST_INPUT, n_trials=5, csr_data=_TEST_CSR,
        )
        for nid in md.output_nodes:
            assert nid in specs, f"Missing QuantSpec for output node {nid}"

    def test_bit_widths_sum_to_target(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        analyzer = QuantizationAnalyzer(target_total_bits=16)
        specs = analyzer.analyze(
            gen, md, _TEST_INPUT, n_trials=5, csr_data=_TEST_CSR,
        )
        for node_id, spec in specs.items():
            total = spec.recommended_int_bits + spec.recommended_frac_bits
            assert total <= 16, (
                f"{node_id}: int+frac={total} > 16"
            )

    def test_min_max_int_bits_range(self) -> None:
        gen = GoldenModelGenerator()
        md = _ldpc_dialect_for_test()
        analyzer = QuantizationAnalyzer(target_total_bits=16)
        specs = analyzer.analyze(
            gen, md, _TEST_INPUT, n_trials=5, csr_data=_TEST_CSR,
        )
        for node_id, spec in specs.items():
            assert spec.min_int_bits == spec.recommended_int_bits - 1
            assert spec.max_int_bits == spec.recommended_int_bits + 2

    def test_to_dse_format(self) -> None:
        spec = QuantSpec(
            node_id="test",
            recommended_int_bits=3,
            recommended_frac_bits=13,
            min_int_bits=2,
            max_int_bits=5,
            max_abs_observed=4.2,
        )
        dse = spec.to_dse_format()
        assert dse["node_id"] == "test"
        assert dse["recommended_int_bits"] == 3
        assert dse["recommended_frac_bits"] == 13
