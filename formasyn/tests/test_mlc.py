"""Tests for FormaSyn MLC frontend and backend."""

import os

import numpy as np
import pytest

from FormaSyn.formasyn.dsl.operators import FormulaGraph, MapOp, ReduceOp, Domain
from FormaSyn.formasyn.ir.math_dialect import MathDialect, MathNode
from FormaSyn.formasyn.ir.schedule_dialect import HLSScheduleDialect, ScheduleNode
from FormaSyn.formasyn.mlc import MLCFrontend, MLCBackend, MissingGraphDataError


# ---------------------------------------------------------------------------
# Shared fixtures
# ---------------------------------------------------------------------------

def _make_h_matrix_3x6() -> np.ndarray:
    """Hand-crafted 3x6 dense H-matrix (3 check nodes, 6 variable nodes).

    Row 0: connected to columns 0, 1, 3       (degree 3)
    Row 1: connected to columns 1, 2, 4, 5    (degree 4)
    Row 2: connected to columns 0, 2, 3, 5    (degree 4)
    """
    H = np.array([
        [1, 1, 0, 1, 0, 0],
        [0, 1, 1, 0, 1, 1],
        [1, 0, 1, 1, 0, 1],
    ], dtype=np.float64)
    return H


def _make_ldpc_graph(h_matrix: np.ndarray) -> FormulaGraph:
    """Build a minimal LDPC CNU FormulaGraph with the given H-matrix."""
    graph = FormulaGraph(
        name="ldpc_cnu_test",
        inputs={"msg_in": [6]},
        outputs=["cnu_out"],
        graph_data=h_matrix,
    )
    graph.add(MapOp(input_ref="msg_in", func="sign", output_ref="sign_bits"))
    graph.add(MapOp(input_ref="msg_in", func="abs", output_ref="mag_bits"))
    graph.add(ReduceOp(
        input_ref="mag_bits", op="min",
        domain=Domain(kind="neighbors", graph_ref="H", exclude_self=True),
        output_ref="min_mag",
    ))
    graph.add(ReduceOp(
        input_ref="sign_bits", op="xor",
        domain=Domain(kind="neighbors", graph_ref="H", exclude_self=True),
        output_ref="xor_sign",
    ))
    return graph


def _make_math_dialect_with_neighbors() -> MathDialect:
    """MathDialect whose reduce nodes use domain_kind='neighbors'."""
    nodes = {
        "msg_in": MathNode(
            node_id="msg_in", op_type="input", shape=[6],
        ),
        "sign_map": MathNode(
            node_id="sign_map", op_type="map",
            op_detail={"func": "sign"}, shape=[6],
            input_nodes=["msg_in"],
        ),
        "abs_map": MathNode(
            node_id="abs_map", op_type="map",
            op_detail={"func": "abs"}, shape=[6],
            input_nodes=["msg_in"],
        ),
        "xor_reduce": MathNode(
            node_id="xor_reduce", op_type="reduce",
            op_detail={"op": "xor", "domain_kind": "neighbors",
                       "exclude_self": True},
            shape=[1], input_nodes=["sign_map"],
        ),
        "min_reduce": MathNode(
            node_id="min_reduce", op_type="reduce",
            op_detail={"op": "min", "domain_kind": "neighbors",
                       "exclude_self": True},
            shape=[1], input_nodes=["abs_map"],
        ),
    }
    return MathDialect(
        kernel_name="ldpc_cnu_test",
        nodes=nodes,
        input_nodes=["msg_in"],
        output_nodes=["xor_reduce", "min_reduce"],
    )


def _make_schedule_dialect(unroll_factor: int = 8) -> HLSScheduleDialect:
    """Build an HLSScheduleDialect with irregular-access reduce nodes."""
    nodes = {
        "msg_in": ScheduleNode(
            node_id="msg_in", op_type="input", shape=[6],
            data_type="ap_int<8>", unroll_factor=unroll_factor,
            pipeline_ii=1, array_partition_type="complete",
        ),
        "sign_map": ScheduleNode(
            node_id="sign_map", op_type="map",
            op_detail={"func": "sign"}, shape=[6],
            input_nodes=["msg_in"],
            data_type="ap_int<1>", unroll_factor=unroll_factor,
        ),
        "abs_map": ScheduleNode(
            node_id="abs_map", op_type="map",
            op_detail={"func": "abs"}, shape=[6],
            input_nodes=["msg_in"],
            data_type="ap_int<7>", unroll_factor=unroll_factor,
        ),
        "xor_reduce": ScheduleNode(
            node_id="xor_reduce", op_type="reduce",
            op_detail={"op": "xor", "domain_kind": "neighbors",
                       "exclude_self": True},
            shape=[1], input_nodes=["sign_map"],
            is_irregular_access=True, csr_ref="H_csr",
            data_type="ap_int<1>", unroll_factor=unroll_factor,
        ),
        "min_reduce": ScheduleNode(
            node_id="min_reduce", op_type="reduce",
            op_detail={"op": "min", "domain_kind": "neighbors",
                       "exclude_self": True},
            shape=[1], input_nodes=["abs_map"],
            is_irregular_access=True, csr_ref="H_csr",
            data_type="ap_int<7>", unroll_factor=unroll_factor,
        ),
    }
    return HLSScheduleDialect(
        variant_id="test_variant",
        nodes=nodes,
        input_nodes=["msg_in"],
        output_nodes=["xor_reduce", "min_reduce"],
        total_dsp_estimate=0,
        total_bram_estimate=0,
        expected_ii=1,
    )


# ===================================================================
# MLCFrontend tests
# ===================================================================


class TestMLCFrontendAnnotation:
    """Verify is_irregular_access annotation on neighbor-domain nodes."""

    def test_irregular_access_flagged_on_reduce_neighbors(self) -> None:
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        dialect = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend()

        result = frontend.analyze(graph, dialect)

        assert result.nodes["xor_reduce"].is_irregular_access is True
        assert result.nodes["min_reduce"].is_irregular_access is True

    def test_regular_ops_not_flagged(self) -> None:
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        dialect = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend()

        result = frontend.analyze(graph, dialect)

        assert result.nodes["msg_in"].is_irregular_access is False
        assert result.nodes["sign_map"].is_irregular_access is False
        assert result.nodes["abs_map"].is_irregular_access is False

    def test_bram_bank_count_remains_none(self) -> None:
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        dialect = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend()

        result = frontend.analyze(graph, dialect)

        assert result.bram_bank_count is None


class TestMLCFrontendCSR:
    """Verify CSR .npz generation and content."""

    def test_npz_file_created(self) -> None:
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        dialect = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend()

        frontend.analyze(graph, dialect)

        csr_ref = dialect.nodes["xor_reduce"].csr_ref
        assert csr_ref is not None
        assert os.path.isfile(csr_ref)

    def test_npz_contains_row_ptr_and_col_idx(self) -> None:
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        dialect = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend()

        frontend.analyze(graph, dialect)

        data = np.load(dialect.nodes["xor_reduce"].csr_ref)
        assert "row_ptr" in data
        assert "col_idx" in data

    def test_row_ptr_shape(self) -> None:
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        dialect = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend()

        frontend.analyze(graph, dialect)

        data = np.load(dialect.nodes["min_reduce"].csr_ref)
        row_ptr = data["row_ptr"]
        assert row_ptr.shape == (3 + 1,)  # num_check_nodes + 1

    def test_col_idx_values(self) -> None:
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        dialect = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend()

        frontend.analyze(graph, dialect)

        data = np.load(dialect.nodes["xor_reduce"].csr_ref)
        col_idx = data["col_idx"]
        assert 0 in col_idx
        assert 1 in col_idx
        total_ones = int(H.sum())
        assert len(col_idx) == total_ones

    def test_custom_output_dir(self, tmp_path: str) -> None:
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        dialect = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend(output_dir=str(tmp_path))

        frontend.analyze(graph, dialect)

        csr_ref = dialect.nodes["xor_reduce"].csr_ref
        assert str(tmp_path) in csr_ref


class TestMLCFrontendErrors:
    """Verify error handling."""

    def test_missing_graph_data_raises(self) -> None:
        graph = FormulaGraph(
            name="bad_kernel",
            inputs={"msg_in": [6]},
            outputs=["out"],
            graph_data=None,
        )
        dialect = MathDialect(
            kernel_name="bad_kernel",
            nodes={
                "mp_node": MathNode(
                    node_id="mp_node", op_type="message_pass",
                    shape=[1],
                ),
            },
            input_nodes=[],
            output_nodes=["mp_node"],
        )
        frontend = MLCFrontend()

        with pytest.raises(MissingGraphDataError, match="graph_data"):
            frontend.analyze(graph, dialect)

    def test_no_error_when_no_irregular_nodes(self) -> None:
        graph = FormulaGraph(
            name="fir_filter",
            inputs={"x_in": [1]},
            outputs=["y_out"],
            graph_data=None,
        )
        dialect = MathDialect(
            kernel_name="fir_filter",
            nodes={
                "x_in": MathNode(node_id="x_in", op_type="input", shape=[1]),
                "add_reduce": MathNode(
                    node_id="add_reduce", op_type="reduce",
                    op_detail={"op": "add", "domain_kind": "all"},
                    shape=[1], input_nodes=["x_in"],
                ),
            },
            input_nodes=["x_in"],
            output_nodes=["add_reduce"],
        )
        frontend = MLCFrontend()
        result = frontend.analyze(graph, dialect)

        assert result.nodes["add_reduce"].is_irregular_access is False


# ===================================================================
# MLCBackend tests
# ===================================================================


class TestMLCBackendBRAMBanks:
    """Verify BRAM bank computation from unroll factors."""

    def test_uf8_gives_4_banks(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=8)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        # ceil(8/2) = 4, already power of 2
        assert result.nodes["xor_reduce"].bram_banks == 4
        assert result.nodes["min_reduce"].bram_banks == 4

    def test_uf6_gives_4_banks(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=6)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        # ceil(6/2) = 3, next power of 2 = 4
        assert result.nodes["xor_reduce"].bram_banks == 4
        assert result.nodes["min_reduce"].bram_banks == 4

    def test_uf1_gives_1_bank(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=1)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        # ceil(1/2) = 1, power of 2 = 1
        assert result.nodes["xor_reduce"].bram_banks == 1

    def test_uf4_gives_2_banks(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=4)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        # ceil(4/2) = 2, already power of 2
        assert result.nodes["xor_reduce"].bram_banks == 2

    def test_uf16_gives_8_banks(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=16)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        # ceil(16/2) = 8, already power of 2
        assert result.nodes["xor_reduce"].bram_banks == 8


class TestMLCBackendAddressMappingCode:
    """Verify generated C++ address-mapping code snippets."""

    def test_code_contains_row_ptr_and_col_idx(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=8)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        code = result.nodes["xor_reduce"].address_mapping_code
        assert code is not None
        assert "row_ptr" in code
        assert "col_idx" in code

    def test_code_contains_node_id(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=8)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        code = result.nodes["xor_reduce"].address_mapping_code
        assert "xor_reduce" in code

    def test_code_contains_exclude_self(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=8)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        code = result.nodes["xor_reduce"].address_mapping_code
        assert "exclude_self" in code

    def test_regular_node_has_no_mapping_code(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=8)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        assert result.nodes["msg_in"].address_mapping_code is None
        assert result.nodes["sign_map"].address_mapping_code is None

    def test_code_with_csr_metadata(self) -> None:
        """When csr_ref points to a real .npz, the code uses actual shapes."""
        H = _make_h_matrix_3x6()
        graph = _make_ldpc_graph(H)
        math_d = _make_math_dialect_with_neighbors()
        frontend = MLCFrontend()
        frontend.analyze(graph, math_d)

        schedule = _make_schedule_dialect(unroll_factor=8)
        for nid, node in schedule.nodes.items():
            if node.is_irregular_access:
                node.csr_ref = math_d.nodes[nid].csr_ref

        backend = MLCBackend()
        result = backend.compile(schedule, math_d)

        code = result.nodes["xor_reduce"].address_mapping_code
        assert "row_ptr[3+1]" in code
        total_ones = int(H.sum())
        assert f"col_idx[{total_ones}]" in code


class TestMLCBackendBRAMEstimate:
    """Verify total_bram_estimate accumulation."""

    def test_total_bram_updated(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=8)
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        assert schedule.total_bram_estimate == 0

        result = backend.compile(schedule, math_d)

        # 2 irregular nodes x 4 banks each = 8
        assert result.total_bram_estimate == 8

    def test_total_bram_accumulates_on_existing(self) -> None:
        schedule = _make_schedule_dialect(unroll_factor=8)
        schedule.total_bram_estimate = 10
        math_d = _make_math_dialect_with_neighbors()
        backend = MLCBackend()

        result = backend.compile(schedule, math_d)

        # 10 existing + 2*4 = 18
        assert result.total_bram_estimate == 18
