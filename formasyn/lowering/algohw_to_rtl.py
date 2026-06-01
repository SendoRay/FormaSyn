"""Lowering pass: AlgoHWDialect → RTLScheduleDialect.

RTLScheduler performs ASAP pipeline-stage assignment, storage decisions,
FSM generation, and resource estimation to produce an RTLScheduleDialect
that directly drives Verilog code generation.
"""

from __future__ import annotations

import logging
import math
from typing import Optional

import networkx as nx

from formasyn.ir.algo_hw_dialect import AlgoHWDialect, AlgoHWNode
from formasyn.ir.rtl_dialect import PortDef, RTLNode, RTLScheduleDialect

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Latency & cost tables
# ---------------------------------------------------------------------------

_OP_LATENCY: dict[str, int] = {
    "mul": 3,
    "multiply": 3,
    "add": 1,
    "sub": 1,
    "div": 10,
    "tanh": 4,
    "atanh": 4,
    "lut_tanh": 2,
    "lut_atanh": 2,
    "input": 0,
}

_DSP_COST: dict[str, int] = {
    "mul": 2,
    "multiply": 2,
    "div": 4,
}

_DEFAULT_LUT_COST_PER_OP = 50


class RTLScheduler:
    """Lower AlgoHWDialect into RTLScheduleDialect.

    Performs four main steps:
        1. Build a dependency DAG from ``AlgoHWDialect.nodes``.
        2. ASAP scheduling — topological sort, assign pipeline stages.
        3. Decide storage types, execution modes, and FSM states.
        4. Estimate resource usage (DSP, LUT, FF, BRAM).

    Args:
        clock_period_ns: Target clock period in nanoseconds.
        bram_depth_threshold: Storage depths above this use BRAM.
        lutram_depth_threshold: Storage depths above ``bram_depth_threshold``
            but at or below this use LUTRAM.  (Depths ≤ ``bram_depth_threshold``
            use registers.)
    """

    def __init__(
        self,
        clock_period_ns: float = 4.0,
        bram_depth_threshold: int = 64,
        lutram_depth_threshold: int = 256,
    ) -> None:
        self.clock_period_ns = clock_period_ns
        self.bram_depth_threshold = bram_depth_threshold
        self.lutram_depth_threshold = lutram_depth_threshold

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def lower(self, algo_hw: AlgoHWDialect, constraints: dict | None = None) -> RTLScheduleDialect:
        """Lower an AlgoHWDialect to an RTLScheduleDialect.

        Args:
            algo_hw: The algorithm-hardware dialect to schedule.
            constraints: Optional resource / timing constraints (reserved
                for future use).

        Returns:
            A fully-populated ``RTLScheduleDialect``.
        """
        dag = self._build_dag(algo_hw)
        stage_map = self._asap_schedule(dag, algo_hw)

        rtl_nodes: dict[str, RTLNode] = {}
        for nid, ahw_node in algo_hw.nodes.items():
            rtl_nodes[nid] = self._lower_node(ahw_node, stage_map)

        fsm_states, fsm_transitions = self._generate_fsm(rtl_nodes)
        input_ports = self._derive_ports(algo_hw, direction="input")
        output_ports = self._derive_ports(algo_hw, direction="output")

        total_stages = max((n.pipeline_stage for n in rtl_nodes.values()), default=0) + 1
        total_latency = max(
            (n.pipeline_stage + n.latency_cycles for n in rtl_nodes.values()),
            default=1,
        )

        est_dsps, est_luts, est_ffs, est_brams = self._estimate_resources(rtl_nodes)

        return RTLScheduleDialect(
            kernel_name=algo_hw.parent_kernel_name,
            nodes=rtl_nodes,
            clock_period_ns=self.clock_period_ns,
            total_pipeline_stages=total_stages,
            total_latency_cycles=total_latency,
            throughput_samples_per_cycle=1,
            estimated_luts=est_luts,
            estimated_ffs=est_ffs,
            estimated_dsps=est_dsps,
            estimated_brams=est_brams,
            fsm_states=fsm_states,
            fsm_transitions=fsm_transitions,
            input_ports=input_ports,
            output_ports=output_ports,
            variant_id=algo_hw.variant_id,
            intent_json=algo_hw.intent_json,
            quality_bound=algo_hw.quality_bound if algo_hw.quality_bound else None,
            input_nodes=list(algo_hw.input_nodes),
            output_nodes=list(algo_hw.output_nodes),
        )

    # ------------------------------------------------------------------
    # DAG construction
    # ------------------------------------------------------------------

    def _build_dag(self, algo_hw: AlgoHWDialect) -> nx.DiGraph:
        """Build a networkx DAG from AlgoHWDialect node dependencies."""
        dag = nx.DiGraph()
        for nid, node in algo_hw.nodes.items():
            dag.add_node(nid)
            for pred in node.input_nodes:
                if pred in algo_hw.nodes:
                    dag.add_edge(pred, nid)
        return dag

    # ------------------------------------------------------------------
    # ASAP scheduling
    # ------------------------------------------------------------------

    def _asap_schedule(self, dag: nx.DiGraph, algo_hw: AlgoHWDialect) -> dict[str, int]:
        """Assign each node the earliest possible pipeline stage (ASAP).

        A node's stage = max(pred_stage + pred_latency) over all predecessors.
        Nodes without predecessors start at stage 0.

        Returns:
            Mapping of node_id → pipeline_stage.
        """
        stage_map: dict[str, int] = {}
        for nid in nx.topological_sort(dag):
            node = algo_hw.nodes[nid]
            pred_stages = [
                stage_map[p] + self._op_latency(algo_hw.nodes[p])
                for p in dag.predecessors(nid)
            ]
            stage_map[nid] = max(pred_stages, default=0)
        return stage_map

    # ------------------------------------------------------------------
    # Per-node lowering
    # ------------------------------------------------------------------

    def _lower_node(self, ahw: AlgoHWNode, stage_map: dict[str, int]) -> RTLNode:
        """Convert a single AlgoHWNode into an RTLNode."""
        op_name = self._extract_op_name(ahw)
        latency = self._op_latency(ahw)
        storage_size = self._storage_size(ahw)
        storage_type = self._decide_storage(storage_size)
        exec_mode = self._decide_exec_mode(ahw)
        total_bits = ahw.quant_int_bits + ahw.quant_frac_bits
        data_type = f"fixed<{total_bits},{ahw.quant_frac_bits}>"

        needs_register = latency > 0 or storage_type != "register"
        bram_banks = self._bram_banks(ahw) if storage_type == "bram" else 0
        addr_width = math.ceil(math.log2(max(storage_size, 1))) if storage_type == "bram" else 0

        fsm_state: str | None = None
        if exec_mode == "iterative":
            fsm_state = "RUN"

        return RTLNode(
            node_id=ahw.node_id,
            op_type=ahw.op_type,
            op_detail=dict(ahw.op_detail),
            shape=list(ahw.shape),
            input_nodes=list(ahw.input_nodes),
            data_type=data_type,
            approx_method=ahw.approx_method,
            parallelism=ahw.parallelism,
            saturation_guard=ahw.saturation_guard,
            quant_int_bits=ahw.quant_int_bits,
            quant_frac_bits=ahw.quant_frac_bits,
            is_irregular_access=ahw.is_irregular_access,
            csr_ref=ahw.csr_ref,
            has_feedback=ahw.has_feedback,
            pipeline_stage=stage_map.get(ahw.node_id, 0),
            latency_cycles=latency,
            register_output=needs_register,
            storage_type=storage_type,
            bram_ports=2 if storage_type == "bram" else 1,
            bram_banks=bram_banks,
            address_width=addr_width,
            fsm_state=fsm_state,
            exec_mode=exec_mode,
        )

    # ------------------------------------------------------------------
    # Operation helpers
    # ------------------------------------------------------------------

    @staticmethod
    def _extract_op_name(node: AlgoHWNode) -> str:
        """Derive a canonical operation name from op_detail / op_type.

        Lookup order: op_detail["func"] → op_detail["op"] → node.op_type.
        """
        detail = node.op_detail
        if "func" in detail:
            return detail["func"]
        if "op" in detail:
            return detail["op"]
        return node.op_type

    def _op_latency(self, node: AlgoHWNode) -> int:
        """Return the latency in clock cycles for *node*."""
        if node.op_type == "input":
            return 0
        op_name = self._extract_op_name(node)
        return _OP_LATENCY.get(op_name, 1)

    # ------------------------------------------------------------------
    # Storage decisions
    # ------------------------------------------------------------------

    @staticmethod
    def _storage_size(node: AlgoHWNode) -> int:
        """Compute the total number of elements stored by *node*."""
        size = 1
        for dim in node.shape:
            size *= dim
        return size

    def _decide_storage(self, size: int) -> str:
        """Choose storage type based on element count thresholds."""
        if size <= self.bram_depth_threshold:
            return "register"
        if size <= self.lutram_depth_threshold:
            return "lutram"
        return "bram"

    @staticmethod
    def _bram_banks(node: AlgoHWNode) -> int:
        """Compute BRAM bank count — at least 1, up to parallelism."""
        return max(1, node.parallelism)

    # ------------------------------------------------------------------
    # Execution mode
    # ------------------------------------------------------------------

    @staticmethod
    def _decide_exec_mode(node: AlgoHWNode) -> str:
        """Determine exec_mode from node semantics.

        - ``iteration`` op_type → ``"iterative"``
        - ``cycle`` op_type or ``has_feedback`` → ``"pipelined"``
        - everything else → ``"combinational"``
        """
        if node.op_type == "iteration":
            return "iterative"
        if node.op_type == "cycle" or node.has_feedback:
            return "pipelined"
        return "combinational"

    # ------------------------------------------------------------------
    # Port derivation
    # ------------------------------------------------------------------

    def _derive_ports(self, algo_hw: AlgoHWDialect, direction: str) -> list[PortDef]:
        """Derive top-level port definitions from input/output node lists."""
        node_ids = algo_hw.input_nodes if direction == "input" else algo_hw.output_nodes
        ports: list[PortDef] = []
        for nid in node_ids:
            node = algo_hw.nodes.get(nid)
            if node is None:
                continue
            total_bits = node.quant_int_bits + node.quant_frac_bits
            size = self._storage_size(node)
            is_array = size > 1
            ports.append(PortDef(
                name=nid,
                direction=direction,
                width=total_bits,
                is_array=is_array,
                array_depth=size if is_array else None,
            ))
        return ports

    # ------------------------------------------------------------------
    # Resource estimation
    # ------------------------------------------------------------------

    def _estimate_resources(
        self,
        rtl_nodes: dict[str, RTLNode],
    ) -> tuple[int, int, int, int]:
        """Estimate DSP, LUT, FF, and BRAM usage.

        Returns:
            (estimated_dsps, estimated_luts, estimated_ffs, estimated_brams)
        """
        total_dsps = 0
        total_luts = 0
        total_ffs = 0
        total_brams = 0

        for node in rtl_nodes.values():
            op_name = self._extract_op_name_from_rtl(node)
            par = node.parallelism

            # DSP
            dsp_per = _DSP_COST.get(op_name, 0)
            total_dsps += dsp_per * par

            # LUT — every non-input op costs some LUTs
            if node.op_type != "input":
                total_luts += _DEFAULT_LUT_COST_PER_OP * par

            # FF — registered outputs contribute width * parallelism
            if node.register_output:
                width = node.quant_int_bits + node.quant_frac_bits
                total_ffs += width * par

            # BRAM — count 18 Kb blocks
            if node.storage_type == "bram":
                depth = 1
                for d in node.shape:
                    depth *= d
                width = node.quant_int_bits + node.quant_frac_bits
                bits = depth * width
                bram_18k = math.ceil(bits / 18_432)
                total_brams += bram_18k * max(1, node.bram_banks)

        return total_dsps, total_luts, total_ffs, total_brams

    @staticmethod
    def _extract_op_name_from_rtl(node: RTLNode) -> str:
        """Extract canonical op name from an RTLNode (same logic as AlgoHWNode)."""
        detail = node.op_detail
        if "func" in detail:
            return detail["func"]
        if "op" in detail:
            return detail["op"]
        return node.op_type

    # ------------------------------------------------------------------
    # FSM generation
    # ------------------------------------------------------------------

    @staticmethod
    def _generate_fsm(rtl_nodes: dict[str, RTLNode]) -> tuple[list[str], dict[str, str]]:
        """Generate FSM states and transitions for iterative nodes.

        If no iterative nodes exist, returns empty lists. Otherwise creates
        a simple IDLE → RUN → DONE → IDLE state machine.

        Returns:
            (fsm_states, fsm_transitions)
        """
        has_iterative = any(n.exec_mode == "iterative" for n in rtl_nodes.values())
        if not has_iterative:
            return [], {}

        states = ["IDLE", "RUN", "DONE"]
        transitions = {
            "IDLE": "RUN",
            "RUN": "DONE",
            "DONE": "IDLE",
        }
        return states, transitions
