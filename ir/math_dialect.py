"""Math Dialect: the first IR layer capturing pure mathematical semantics.

Each MathNode maps 1-to-1 with a DSL operator and retains only the
mathematical specification (no hardware or scheduling information).
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Optional

import networkx as nx

logger = logging.getLogger(__name__)


@dataclass
class MathNode:
    """A single node in the Math Dialect DAG.

    Attributes:
        node_id: Unique identifier within the kernel.
        op_type: DSL operator type
            ('map', 'reduce', 'delay', 'shift_reg', 'message_pass').
        op_detail: Complete operator parameters dictionary.
        shape: Tensor shape of this node's output.
        input_nodes: node_ids of upstream dependencies.
        is_irregular_access: Whether this node involves topology-dependent
            irregular memory access (flagged by MLC frontend).
        csr_ref: CSR data structure variable name when is_irregular_access
            is True.
    """

    node_id: str
    op_type: str
    op_detail: dict = field(default_factory=dict)
    shape: list[int] = field(default_factory=list)
    input_nodes: list[str] = field(default_factory=list)
    is_irregular_access: bool = False
    csr_ref: Optional[str] = None


@dataclass
class MathDialect:
    """Top-level container for the Math Dialect IR.

    Attributes:
        kernel_name: Name of the algorithm kernel.
        nodes: Mapping of node_id to MathNode.
        input_nodes: node_ids that are kernel inputs.
        output_nodes: node_ids that are kernel outputs.
        target_metric: Optimisation target (e.g. 'throughput', 'latency').
        hw_constraint: Hardware constraint string (e.g. 'xczu7ev').
        bram_bank_count: Filled later by MLC backend.
    """

    kernel_name: str
    nodes: dict[str, MathNode] = field(default_factory=dict)
    input_nodes: list[str] = field(default_factory=list)
    output_nodes: list[str] = field(default_factory=list)
    target_metric: str = "throughput"
    hw_constraint: str = ""
    bram_bank_count: Optional[int] = None

    def to_dag(self) -> nx.DiGraph:
        """Build a NetworkX directed acyclic graph from the node dependencies."""
        dag = nx.DiGraph()
        for nid, node in self.nodes.items():
            dag.add_node(nid, op_type=node.op_type, shape=node.shape)
            for parent_id in node.input_nodes:
                dag.add_edge(parent_id, nid)
        return dag

    @classmethod
    def example_ldpc_cnu(cls) -> MathDialect:
        """Return a hand-crafted LDPC Min-Sum CNU example.

        DAG topology::

            msg_in
            /    \\
        sign_map  abs_map
            |        |
        xor_reduce  min_reduce
        """
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
                shape=[1],
                input_nodes=["sign_map"],
                is_irregular_access=True,
                csr_ref="H_csr",
            ),
            "min_reduce": MathNode(
                node_id="min_reduce",
                op_type="reduce",
                op_detail={"op": "min", "domain_kind": "neighbors",
                           "exclude_self": True},
                shape=[1],
                input_nodes=["abs_map"],
                is_irregular_access=True,
                csr_ref="H_csr",
            ),
        }
        return cls(
            kernel_name="ldpc_cnu",
            nodes=nodes,
            input_nodes=["msg_in"],
            output_nodes=["xor_reduce", "min_reduce"],
            target_metric="throughput",
            hw_constraint="xczu7ev",
        )
