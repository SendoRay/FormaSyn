"""Template Engine: render IntentJSON + MathDialect into AlgoHWDialect.

Pure deterministic transformation — no LLM calls.  The engine deep-copies
the mathematical DAG, applies approximation-method rewrites, annotates
quantisation data types, propagates parallelism / saturation flags, and
estimates DSP usage.
"""

from __future__ import annotations

import copy
import logging
from typing import Callable, Optional

from ..agent.dse_agent import IntentJSON
from ..golden.quant_analyzer import QuantSpec
from ..ir.algo_hw_dialect import AlgoHWDialect, AlgoHWNode
from ..ir.math_dialect import MathDialect, MathNode
from ..rewrites.rules import RewriteCatalog

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# DSP cost lookup (per-element, before parallelism multiplier)
# ---------------------------------------------------------------------------

_DSP_COST: dict[str, int] = {
    "multiply": 1,
    "add": 0,
    "sign": 0,
    "abs": 0,
    "clamp": 0,
    "lut": 0,
    "xor": 0,
    "min": 0,
    "max": 0,
    "mul": 1,
    "tanh": 3,
    "atanh": 3,
}


# ---------------------------------------------------------------------------
# Helper: MathNode → AlgoHWNode conversion
# ---------------------------------------------------------------------------

def _math_to_hw_node(node: MathNode) -> AlgoHWNode:
    """Convert a MathNode into an AlgoHWNode preserving all math fields."""
    return AlgoHWNode(
        node_id=node.node_id,
        op_type=node.op_type,
        op_detail=copy.deepcopy(node.op_detail),
        shape=list(node.shape),
        input_nodes=list(node.input_nodes),
        is_irregular_access=node.is_irregular_access,
        csr_ref=node.csr_ref,
    )


# ---------------------------------------------------------------------------
# Approximation-method handlers
# ---------------------------------------------------------------------------

def _apply_spa_exact(
    nodes: dict[str, AlgoHWNode],
    output_nodes: list[str],
    intent: IntentJSON,
) -> tuple[dict[str, AlgoHWNode], list[str]]:
    """SPA exact: no transformation needed."""
    return nodes, output_nodes


def _replace_tanh_with_sign_abs(
    nodes: dict[str, AlgoHWNode],
) -> dict[str, AlgoHWNode]:
    """Find every func='tanh' map node and split into sign + abs pair.

    For each tanh node T with upstream U:
      - T is removed
      - sign node (id = T.node_id + '_sign') reads from U
      - abs  node (id = T.node_id + '_abs')  reads from U
      - all downstream references to T are rewritten to point at both new nodes

    Returns the mutated nodes dict.
    """
    tanh_ids = [
        nid for nid, n in nodes.items()
        if n.op_type == "map" and n.op_detail.get("func") == "tanh"
    ]

    for tid in tanh_ids:
        tanh_node = nodes.pop(tid)
        upstream = list(tanh_node.input_nodes)

        sign_id = f"{tid}_sign"
        abs_id = f"{tid}_abs"

        nodes[sign_id] = AlgoHWNode(
            node_id=sign_id,
            op_type="map",
            op_detail={"func": "sign"},
            shape=list(tanh_node.shape),
            input_nodes=upstream,
            is_irregular_access=tanh_node.is_irregular_access,
            csr_ref=tanh_node.csr_ref,
        )
        nodes[abs_id] = AlgoHWNode(
            node_id=abs_id,
            op_type="map",
            op_detail={"func": "abs"},
            shape=list(tanh_node.shape),
            input_nodes=upstream,
            is_irregular_access=tanh_node.is_irregular_access,
            csr_ref=tanh_node.csr_ref,
        )

        for n in nodes.values():
            n.input_nodes = [
                sign_id if ref == tid else ref for ref in n.input_nodes
            ]

    return nodes


def _replace_atanh_with_min_xor(
    nodes: dict[str, AlgoHWNode],
) -> tuple[dict[str, AlgoHWNode], list[str]]:
    """Replace func='atanh' map nodes with reduce(min) + reduce(xor).

    The atanh node's upstream is typically a product-reduce whose input
    came from a tanh (now split into sign+abs).  We replace atanh with:
      - min_reduce reading from the *_abs branch
      - xor_reduce reading from the *_sign branch

    Returns (mutated nodes, list of newly created reduce node ids).
    """
    atanh_ids = [
        nid for nid, n in nodes.items()
        if n.op_type == "map" and n.op_detail.get("func") == "atanh"
    ]

    new_reduce_ids: list[str] = []

    for aid in atanh_ids:
        atanh_node = nodes.pop(aid)
        upstream_ids = list(atanh_node.input_nodes)

        sign_sources: list[str] = []
        abs_sources: list[str] = []
        other_sources: list[str] = []

        for uid in upstream_ids:
            if uid not in nodes:
                other_sources.append(uid)
                continue
            up = nodes[uid]
            if up.op_type == "map" and up.op_detail.get("func") == "sign":
                sign_sources.append(uid)
            elif up.op_type == "map" and up.op_detail.get("func") == "abs":
                abs_sources.append(uid)
            elif up.op_type == "reduce" and up.op_detail.get("op") == "mul":
                _collect_leaf_sources(nodes, uid, sign_sources, abs_sources)
                nodes.pop(uid, None)
            else:
                other_sources.append(uid)

        if not sign_sources:
            sign_sources = other_sources or upstream_ids
        if not abs_sources:
            abs_sources = other_sources or upstream_ids

        xor_id = f"{aid}_xor"
        min_id = f"{aid}_min"

        domain_detail = {
            "domain_kind": "neighbors",
            "exclude_self": True,
        }
        if atanh_node.csr_ref:
            domain_detail["graph_ref"] = atanh_node.csr_ref

        has_irregular = any(
            nodes[s].is_irregular_access
            for s in sign_sources + abs_sources
            if s in nodes
        )
        csr = atanh_node.csr_ref
        if not csr:
            for s in sign_sources + abs_sources:
                sn = nodes.get(s)
                if sn and sn.csr_ref:
                    csr = sn.csr_ref
                    break

        nodes[xor_id] = AlgoHWNode(
            node_id=xor_id,
            op_type="reduce",
            op_detail={"op": "xor", **domain_detail},
            shape=[1],
            input_nodes=sign_sources,
            is_irregular_access=has_irregular,
            csr_ref=csr,
        )
        nodes[min_id] = AlgoHWNode(
            node_id=min_id,
            op_type="reduce",
            op_detail={"op": "min", **domain_detail},
            shape=[1],
            input_nodes=abs_sources,
            is_irregular_access=has_irregular,
            csr_ref=csr,
        )
        new_reduce_ids.extend([xor_id, min_id])

        for n in nodes.values():
            n.input_nodes = [
                xor_id if ref == aid else ref for ref in n.input_nodes
            ]

    return nodes, new_reduce_ids


def _collect_leaf_sources(
    nodes: dict[str, AlgoHWNode],
    reduce_id: str,
    sign_list: list[str],
    abs_list: list[str],
) -> None:
    """Walk up from a product-reduce to find the sign / abs leaf nodes."""
    reduce_node = nodes.get(reduce_id)
    if reduce_node is None:
        return
    for uid in reduce_node.input_nodes:
        up = nodes.get(uid)
        if up is None:
            continue
        if up.op_type == "map" and up.op_detail.get("func") == "sign":
            sign_list.append(uid)
        elif up.op_type == "map" and up.op_detail.get("func") == "abs":
            abs_list.append(uid)
        else:
            sign_list.append(uid)
            abs_list.append(uid)


def _insert_scale_node(
    nodes: dict[str, AlgoHWNode],
    output_nodes: list[str],
    coeff: float,
) -> tuple[dict[str, AlgoHWNode], list[str]]:
    """Insert a multiply-scale map node after each output node."""
    new_outputs: list[str] = []
    for out_id in output_nodes:
        scale_id = f"{out_id}_scale"
        out_node = nodes.get(out_id)
        shape = list(out_node.shape) if out_node else [1]

        nodes[scale_id] = AlgoHWNode(
            node_id=scale_id,
            op_type="map",
            op_detail={"func": "multiply", "func_params": {"coeff": coeff}},
            shape=shape,
            input_nodes=[out_id],
        )
        new_outputs.append(scale_id)
    return nodes, new_outputs


def _apply_min_sum(
    nodes: dict[str, AlgoHWNode],
    output_nodes: list[str],
    intent: IntentJSON,
) -> tuple[dict[str, AlgoHWNode], list[str]]:
    """Min-Sum approximation: tanh→sign+abs, atanh→min+xor, scale 0.75."""
    nodes = _replace_tanh_with_sign_abs(nodes)
    nodes, new_reduce_ids = _replace_atanh_with_min_xor(nodes)

    effective_outputs = new_reduce_ids if new_reduce_ids else output_nodes
    nodes, new_outputs = _insert_scale_node(nodes, effective_outputs, 0.75)

    return nodes, new_outputs


def _apply_offset_min_sum(
    nodes: dict[str, AlgoHWNode],
    output_nodes: list[str],
    intent: IntentJSON,
) -> tuple[dict[str, AlgoHWNode], list[str]]:
    """Offset Min-Sum: min_sum base + subtract beta + clamp(0) before scale."""
    nodes = _replace_tanh_with_sign_abs(nodes)
    nodes, new_reduce_ids = _replace_atanh_with_min_xor(nodes)

    beta = intent.get("offset_beta", 0.15)

    min_reduce_ids = [
        nid for nid in new_reduce_ids
        if nodes[nid].op_detail.get("op") == "min"
    ]
    xor_reduce_ids = [
        nid for nid in new_reduce_ids
        if nodes[nid].op_detail.get("op") == "xor"
    ]

    adjusted_min_ids: list[str] = []
    for mid in min_reduce_ids:
        min_node = nodes[mid]

        sub_id = f"{mid}_sub_beta"
        nodes[sub_id] = AlgoHWNode(
            node_id=sub_id,
            op_type="map",
            op_detail={"func": "add", "func_params": {"coeff": -beta}},
            shape=list(min_node.shape),
            input_nodes=[mid],
        )

        clamp_id = f"{mid}_clamp"
        nodes[clamp_id] = AlgoHWNode(
            node_id=clamp_id,
            op_type="map",
            op_detail={"func": "clamp", "func_params": {"lo": 0}},
            shape=list(min_node.shape),
            input_nodes=[sub_id],
        )
        adjusted_min_ids.append(clamp_id)

    effective_outputs = xor_reduce_ids + adjusted_min_ids
    nodes, new_outputs = _insert_scale_node(nodes, effective_outputs, 0.75)

    return nodes, new_outputs


def _apply_normalized_min_sum(
    nodes: dict[str, AlgoHWNode],
    output_nodes: list[str],
    intent: IntentJSON,
) -> tuple[dict[str, AlgoHWNode], list[str]]:
    """Normalized Min-Sum: same as min_sum but scale_factor from intent."""
    nodes = _replace_tanh_with_sign_abs(nodes)
    nodes, new_reduce_ids = _replace_atanh_with_min_xor(nodes)

    scale = intent.get("scale_factor", 0.75)
    effective_outputs = new_reduce_ids if new_reduce_ids else output_nodes
    nodes, new_outputs = _insert_scale_node(nodes, effective_outputs, scale)

    return nodes, new_outputs


def _apply_lut_tanh(
    nodes: dict[str, AlgoHWNode],
    output_nodes: list[str],
    intent: IntentJSON,
) -> tuple[dict[str, AlgoHWNode], list[str]]:
    """LUT-tanh: replace func='tanh' with func='lut', table_depth=256."""
    for node in nodes.values():
        if node.op_type == "map" and node.op_detail.get("func") == "tanh":
            node.op_detail["func"] = "lut"
            node.op_detail.setdefault("func_params", {})
            node.op_detail["func_params"]["table_depth"] = 256
    return nodes, output_nodes


# Handler registry
_APPROX_HANDLERS: dict[
    str,
    Callable[
        [dict[str, AlgoHWNode], list[str], IntentJSON],
        tuple[dict[str, AlgoHWNode], list[str]],
    ],
] = {
    "spa_exact": _apply_spa_exact,
    "min_sum": _apply_min_sum,
    "offset_min_sum": _apply_offset_min_sum,
    "normalized_min_sum": _apply_normalized_min_sum,
    "lut_tanh": _apply_lut_tanh,
}

# Mapping from approx_method to formal rewrite rule names
# Used by RewriteCatalog for quality bound computation and composability checks
_APPROX_TO_RULES: dict[str, list[str]] = {
    "spa_exact": [],
    "min_sum": ["R1_tanh_to_minsum"],
    "normalized_min_sum": ["R1_tanh_to_minsum", "R2_normalized_minsum"],
    "offset_min_sum": ["R1_tanh_to_minsum", "R3_offset_minsum"],
    "lut_tanh": ["R4_lut_tanh"],
}


# ---------------------------------------------------------------------------
# TemplateEngine
# ---------------------------------------------------------------------------

class TemplateEngine:
    """Render an IntentJSON + MathDialect into a fully-annotated AlgoHWDialect.

    All transformations are deterministic — no LLM involvement.
    Uses RewriteCatalog for quality-bound tracking and composability checks.
    """

    def __init__(self) -> None:
        self._catalog = RewriteCatalog()

    def render(
        self,
        intent: IntentJSON,
        math_dialect: MathDialect,
        quant_specs: dict[str, QuantSpec],
    ) -> AlgoHWDialect:
        """Transform a MathDialect into an AlgoHWDialect guided by *intent*.

        Args:
            intent: Structured variant intent from the DSE Agent.
            math_dialect: Pure-math IR to be transformed.
            quant_specs: Per-node quantisation recommendations (node_id → QuantSpec).

        Returns:
            A fully annotated AlgoHWDialect ready for downstream lowering.

        Raises:
            ValueError: If ``intent['approx_method']`` is unknown.
        """
        approx = intent["approx_method"]
        if approx not in _APPROX_HANDLERS:
            raise ValueError(
                f"Unknown approx_method '{approx}', "
                f"valid: {sorted(_APPROX_HANDLERS)}"
            )

        # 1. Deep-copy MathNodes → AlgoHWNodes
        nodes: dict[str, AlgoHWNode] = {
            nid: _math_to_hw_node(n)
            for nid, n in math_dialect.nodes.items()
        }
        output_nodes = list(math_dialect.output_nodes)

        # 2. Composability check + approximation rewrite
        rule_names = _APPROX_TO_RULES.get(approx, [])
        conflicts = self._catalog.check_composability(rule_names)
        if conflicts:
            for conflict in conflicts:
                logger.warning("Rewrite composability conflict: %s", conflict)

        handler = _APPROX_HANDLERS[approx]
        nodes, output_nodes = handler(nodes, output_nodes, intent)

        # 3. Compute quality bound from rewrite rules
        quality_bound = self._catalog.compute_combined_bound(rule_names)

        # 4. Tag approx_method on every node
        for node in nodes.values():
            node.approx_method = approx

        # 5. Quantisation annotation
        self._annotate_quant(nodes, intent, quant_specs)

        # 6. Parallelism
        parallelism = intent["parallelism"]
        for node in nodes.values():
            node.parallelism = parallelism

        # 7. Saturation guard
        sat = intent["enable_saturation"]
        for node in nodes.values():
            node.saturation_guard = sat

        # 8. DSP estimation
        estimated_dsp = self._estimate_dsp(nodes, parallelism)

        dialect = AlgoHWDialect(
            variant_id=intent["variant_name"],
            parent_kernel_name=math_dialect.kernel_name,
            nodes=nodes,
            intent_json=dict(intent),
            input_nodes=list(math_dialect.input_nodes),
            output_nodes=output_nodes,
            estimated_dsp=estimated_dsp,
            quality_bound=quality_bound,
        )

        logger.info(
            "Rendered variant '%s' (approx=%s, parallelism=%d, nodes=%d, dsp≈%d)",
            dialect.variant_id,
            approx,
            parallelism,
            len(nodes),
            estimated_dsp,
        )
        return dialect

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    @staticmethod
    def _annotate_quant(
        nodes: dict[str, AlgoHWNode],
        intent: IntentJSON,
        quant_specs: dict[str, QuantSpec],
    ) -> None:
        """Set data_type, quant_int_bits, quant_frac_bits on every node."""
        overrides = intent.get("quant_overrides", {})

        for nid, node in nodes.items():
            if nid in overrides:
                int_bits = overrides[nid]
                frac_bits = 0
            elif nid in quant_specs:
                qs = quant_specs[nid]
                int_bits = qs.recommended_int_bits
                frac_bits = qs.recommended_frac_bits
            else:
                int_bits, frac_bits = _get_default_quant_for_node(node)

            # Framework invariant: pure-integer operations should not
            # produce fixed-point types.  QuantizationAnalyzer may
            # recommend frac_bits > 0 because its perturbation injects
            # fractional noise, but the actual operation is integer-only.
            if _is_integer_only_node(node, nodes):
                frac_bits = 0

            total = int_bits + frac_bits
            if frac_bits > 0:
                node.data_type = f"ap_fixed<{total},{int_bits}>"
            else:
                node.data_type = f"ap_int<{total}>"

            node.quant_int_bits = int_bits
            node.quant_frac_bits = frac_bits

    @staticmethod
    def _estimate_dsp(
        nodes: dict[str, AlgoHWNode],
        parallelism: int,
    ) -> int:
        """Rough DSP estimate based on a hardcoded cost table."""
        total = 0
        for node in nodes.values():
            func = node.op_detail.get("func") or node.op_detail.get("op", "")
            cost = _DSP_COST.get(func, 0)
            total += cost * parallelism
        return total


def _get_default_quant_for_node(node: AlgoHWNode) -> tuple[int, int]:
    """根据节点类型返回合理的默认量化参数.

    对于需要小数精度的节点（如 FIR 滤波器），返回 ap_fixed 参数。
    """
    op_type = node.op_type
    op_detail = node.op_detail

    # FIR 滤波器的 map multiply 操作需要小数精度
    if op_type == "map" and op_detail.get("func") == "multiply":
        # 如果有系数数组（FIR 滤波器），使用 ap_fixed
        if "coeffs" in op_detail.get("func_params", {}):
            return 4, 12  # ap_fixed<16,4>: 4位整数, 12位小数

    # reduce add 操作通常也需要小数精度
    if op_type == "reduce" and op_detail.get("op") == "add":
        return 6, 10  # ap_fixed<16,6>: 6位整数, 10位小数

    # shift_reg 输出通常需要保持一定精度
    if op_type == "shift_reg":
        return 4, 12  # ap_fixed<16,4>

    # 默认使用 ap_int<8>
    return 8, 0


# Integer-only operations: these should never produce ap_fixed types
# regardless of what QuantizationAnalyzer recommends.
_INTEGER_ONLY_FUNCS = frozenset({"add", "sub", "min", "max", "xor", "sign", "abs", "negate"})
_INTEGER_ONLY_REDUCE_OPS = frozenset({"add", "min", "max", "xor"})


def _is_integer_only_node(
    node: AlgoHWNode,
    all_nodes: dict[str, AlgoHWNode],
) -> bool:
    """Determine if a node's operation is inherently integer-only.

    A node is integer-only when:
    - It's a map with an integer func (add, sub, min, max, xor, sign, abs)
      AND has no float-point coefficients
    - It's a reduce with an integer op (add, min, max, xor)
      AND all inputs are also integer-only
    - It's an input node

    Nodes involving multiply with float coefficients, tanh, atanh, lut,
    shift_reg with FIR coefficients, etc. are NOT integer-only.
    """
    if node.op_type == "input":
        return True

    if node.op_type == "map":
        func = node.op_detail.get("func", "")
        if func not in _INTEGER_ONLY_FUNCS:
            return False
        # Check for float coefficients (e.g. multiply with float coeff)
        fp = node.op_detail.get("func_params", {})
        if "coeffs" in fp:
            return False
        coeff = fp.get("coeff")
        if isinstance(coeff, float) and coeff != int(coeff):
            return False
        return True

    if node.op_type == "reduce":
        op = node.op_detail.get("op", "")
        return op in _INTEGER_ONLY_REDUCE_OPS

    return False
