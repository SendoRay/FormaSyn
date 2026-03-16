"""Algo-HW Dialect: second IR layer adding hardware-oriented parameters.

Extends MathNode with data types, approximation methods, parallelism,
and quantisation settings that describe *how* the algorithm is mapped
onto hardware without yet specifying scheduling / pragma details.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Optional

from FormaSyn.ir.math_dialect import MathNode

logger = logging.getLogger(__name__)


@dataclass
class AlgoHWNode(MathNode):
    """Math node enriched with algorithm-hardware mapping parameters.

    Attributes:
        data_type: HLS data type string (e.g. 'ap_int<8>', 'ap_fixed<16,4>').
        approx_method: Approximation algorithm if applicable
            (e.g. 'min_sum', 'offset_min_sum', 'lut_tanh').
        parallelism: Degree of parallelism (default 1).
        saturation_guard: Whether saturation arithmetic is enabled.
        quant_int_bits: Integer part bit-width for fixed-point.
        quant_frac_bits: Fractional part bit-width for fixed-point.
    """

    data_type: str = "float64"
    approx_method: Optional[str] = None
    parallelism: int = 1
    saturation_guard: bool = False
    quant_int_bits: int = 8
    quant_frac_bits: int = 0


@dataclass
class AlgoHWDialect:
    """Top-level container for the Algo-HW Dialect IR.

    Attributes:
        variant_id: Unique variant identifier
            (e.g. 'min_sum_int8_p8').
        parent_kernel_name: Original kernel name from MathDialect.
        nodes: Mapping of node_id to AlgoHWNode.
        intent_json: The LLM design-space-exploration intent that produced
            this variant (stored verbatim for traceability).
        input_nodes: Kernel input node ids.
        output_nodes: Kernel output node ids.
        estimated_dsp: Rough DSP usage estimate (filled by Roofline Solver).
        estimated_bram: Rough BRAM usage estimate.
    """

    variant_id: str
    parent_kernel_name: str
    nodes: dict[str, AlgoHWNode] = field(default_factory=dict)
    intent_json: dict = field(default_factory=dict)
    input_nodes: list[str] = field(default_factory=list)
    output_nodes: list[str] = field(default_factory=list)
    estimated_dsp: Optional[int] = None
    estimated_bram: Optional[int] = None

    @classmethod
    def example_ldpc_cnu(cls) -> AlgoHWDialect:
        """Return a hand-crafted LDPC Min-Sum CNU Algo-HW variant."""
        nodes = {
            "msg_in": AlgoHWNode(
                node_id="msg_in",
                op_type="input",
                shape=[8],
                data_type="ap_int<8>",
                parallelism=8,
            ),
            "sign_map": AlgoHWNode(
                node_id="sign_map",
                op_type="map",
                op_detail={"func": "sign"},
                shape=[8],
                input_nodes=["msg_in"],
                data_type="ap_int<1>",
                approx_method="min_sum",
                parallelism=8,
            ),
            "abs_map": AlgoHWNode(
                node_id="abs_map",
                op_type="map",
                op_detail={"func": "abs"},
                shape=[8],
                input_nodes=["msg_in"],
                data_type="ap_int<7>",
                approx_method="min_sum",
                parallelism=8,
            ),
            "xor_reduce": AlgoHWNode(
                node_id="xor_reduce",
                op_type="reduce",
                op_detail={"op": "xor", "domain_kind": "neighbors",
                           "exclude_self": True},
                shape=[1],
                input_nodes=["sign_map"],
                is_irregular_access=True,
                csr_ref="H_csr",
                data_type="ap_int<1>",
                approx_method="min_sum",
                parallelism=8,
            ),
            "min_reduce": AlgoHWNode(
                node_id="min_reduce",
                op_type="reduce",
                op_detail={"op": "min", "domain_kind": "neighbors",
                           "exclude_self": True},
                shape=[1],
                input_nodes=["abs_map"],
                is_irregular_access=True,
                csr_ref="H_csr",
                data_type="ap_int<7>",
                approx_method="min_sum",
                parallelism=8,
            ),
        }
        intent = {
            "approx": "min_sum",
            "quantization": {"int_bits": 8, "frac_bits": 0},
            "parallelism": 8,
        }
        return cls(
            variant_id="min_sum_int8_p8",
            parent_kernel_name="ldpc_cnu",
            nodes=nodes,
            intent_json=intent,
            input_nodes=["msg_in"],
            output_nodes=["xor_reduce", "min_reduce"],
            estimated_dsp=16,
            estimated_bram=4,
        )
