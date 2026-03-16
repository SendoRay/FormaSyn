"""Tests for the three-level FormaSyn IR data structures."""

import networkx as nx

from FormaSyn.ir.math_dialect import MathDialect, MathNode
from FormaSyn.ir.algo_hw_dialect import AlgoHWDialect, AlgoHWNode
from FormaSyn.ir.schedule_dialect import HLSScheduleDialect, ScheduleNode


class TestMathDialect:
    """MathDialect construction, example, and DAG conversion."""

    def test_example_nodes_non_empty(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        assert len(md.nodes) > 0

    def test_example_kernel_name(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        assert md.kernel_name == "ldpc_cnu"

    def test_example_has_five_nodes(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        assert len(md.nodes) == 5

    def test_example_input_output_nodes(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        assert "msg_in" in md.input_nodes
        assert "xor_reduce" in md.output_nodes
        assert "min_reduce" in md.output_nodes

    def test_to_dag_returns_digraph(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        dag = md.to_dag()
        assert isinstance(dag, nx.DiGraph)

    def test_to_dag_has_edges(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        dag = md.to_dag()
        assert dag.number_of_edges() > 0

    def test_to_dag_edge_count(self) -> None:
        """msg_in->sign_map, msg_in->abs_map, sign_map->xor_reduce,
        abs_map->min_reduce => 4 edges."""
        md = MathDialect.example_ldpc_cnu()
        dag = md.to_dag()
        assert dag.number_of_edges() == 4

    def test_to_dag_is_dag(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        dag = md.to_dag()
        assert nx.is_directed_acyclic_graph(dag)

    def test_irregular_access_flags(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        assert md.nodes["xor_reduce"].is_irregular_access is True
        assert md.nodes["min_reduce"].is_irregular_access is True
        assert md.nodes["msg_in"].is_irregular_access is False


class TestAlgoHWDialect:
    """AlgoHWDialect construction and example."""

    def test_example_instantiation(self) -> None:
        ahd = AlgoHWDialect.example_ldpc_cnu()
        assert ahd is not None

    def test_example_variant_id(self) -> None:
        ahd = AlgoHWDialect.example_ldpc_cnu()
        assert ahd.variant_id == "min_sum_int8_p8"
        assert len(ahd.variant_id) > 0

    def test_example_parent_kernel(self) -> None:
        ahd = AlgoHWDialect.example_ldpc_cnu()
        assert ahd.parent_kernel_name == "ldpc_cnu"

    def test_example_nodes_are_algo_hw(self) -> None:
        ahd = AlgoHWDialect.example_ldpc_cnu()
        for node in ahd.nodes.values():
            assert isinstance(node, AlgoHWNode)

    def test_example_data_types(self) -> None:
        ahd = AlgoHWDialect.example_ldpc_cnu()
        assert ahd.nodes["sign_map"].data_type == "ap_int<1>"
        assert ahd.nodes["abs_map"].data_type == "ap_int<7>"

    def test_example_parallelism(self) -> None:
        ahd = AlgoHWDialect.example_ldpc_cnu()
        for node in ahd.nodes.values():
            assert node.parallelism == 8

    def test_example_resource_estimates(self) -> None:
        ahd = AlgoHWDialect.example_ldpc_cnu()
        assert ahd.estimated_dsp is not None
        assert ahd.estimated_bram is not None

    def test_example_intent_json(self) -> None:
        ahd = AlgoHWDialect.example_ldpc_cnu()
        assert "approx" in ahd.intent_json
        assert ahd.intent_json["approx"] == "min_sum"

    def test_node_inheritance(self) -> None:
        """AlgoHWNode inherits MathNode fields."""
        ahd = AlgoHWDialect.example_ldpc_cnu()
        node = ahd.nodes["sign_map"]
        assert hasattr(node, "node_id")
        assert hasattr(node, "op_type")
        assert hasattr(node, "shape")
        assert isinstance(node, MathNode)


class TestHLSScheduleDialect:
    """HLSScheduleDialect construction and example."""

    def test_example_instantiation(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        assert hsd is not None

    def test_example_expected_ii(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        assert hsd.expected_ii > 0

    def test_example_variant_id(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        assert len(hsd.variant_id) > 0

    def test_example_nodes_are_schedule_nodes(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        for node in hsd.nodes.values():
            assert isinstance(node, ScheduleNode)

    def test_example_unroll_factors(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        for node in hsd.nodes.values():
            assert node.unroll_factor == 8

    def test_example_bram_banks(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        assert hsd.nodes["xor_reduce"].bram_banks == 8
        assert hsd.nodes["min_reduce"].bram_banks == 8

    def test_example_array_partition(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        assert hsd.nodes["xor_reduce"].array_partition_type == "cyclic"
        assert hsd.nodes["msg_in"].array_partition_type == "complete"

    def test_example_address_mapping_code(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        assert hsd.nodes["xor_reduce"].address_mapping_code is not None
        assert hsd.nodes["msg_in"].address_mapping_code is None

    def test_node_inheritance_chain(self) -> None:
        """ScheduleNode -> AlgoHWNode -> MathNode."""
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        node = hsd.nodes["sign_map"]
        assert isinstance(node, ScheduleNode)
        assert isinstance(node, AlgoHWNode)
        assert isinstance(node, MathNode)

    def test_total_resource_estimates(self) -> None:
        hsd = HLSScheduleDialect.example_ldpc_cnu()
        assert hsd.total_dsp_estimate > 0
        assert hsd.total_bram_estimate > 0
