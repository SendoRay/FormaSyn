"""LLM-based Transform Agent: FVIR -> list of Variant FVIRs."""

from __future__ import annotations

import json
import logging
from typing import Any

from formaflow.protocols import LLMBackend
from formaflow.types import FVIR, FVIROp, OpType, TransformType, Variant

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Prompt templates
# ---------------------------------------------------------------------------

TRANSFORM_SYSTEM_PROMPT = """\
You are an expert hardware-design optimizer. Given an FVIR (Formula-to-Verilog \
Intermediate Representation) computation graph, propose mathematically \
equivalent or well-bounded approximate transformations that may reduce \
hardware cost (LUTs, DSPs, BRAM) or improve throughput/frequency.

Transformation categories to consider:
  - symmetry         : exploit input symmetry to halve multipliers (e.g. pre-addition in FIR)
  - factorization    : decompose large operations into smaller stages (Horner, CSD, Booth)
  - CORDIC           : replace trig/hyperbolic with iterative shift-add (exact or truncated)
  - LUT-based        : replace costly functions with ROM lookup + interpolation
  - min-sum          : approximate check-node in LDPC-style graphs (abs-min + sign)
  - strength-reduce  : replace mul/div with shifts/adds where constants allow
  - pipelining       : insert registers to break critical path (same throughput, higher Fmax)
  - resource-share   : time-multiplex operators at lower throughput

For each transform you propose:
  1. Give it a short snake_case identifier (e.g. "cordic_sin_approx").
  2. Classify it as "exact" or "approximate".
  3. Provide the modified ops list (same schema as input).
  4. Write a 1-2 sentence rationale.

Only propose transforms that are meaningful for the given computation. \
Quality over quantity.
"""

TRANSFORM_USER_TEMPLATE = """\
Here is the FVIR to transform:

kernel_id: {kernel_id}
source_latex: {source_latex}
constraints: {constraints}

ops (JSON):
{ops_json}

Propose up to {max_suggestions} alternative implementations. \
Return them as JSON conforming to the provided schema.
"""

# ---------------------------------------------------------------------------
# JSON schema for structured output
# ---------------------------------------------------------------------------

TRANSFORM_RESPONSE_SCHEMA: dict[str, Any] = {
    "type": "object",
    "properties": {
        "transforms": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "transform_id": {"type": "string"},
                    "transform_type": {
                        "type": "string",
                        "enum": ["exact", "approximate"],
                    },
                    "rationale": {"type": "string"},
                    "ops": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "op_type": {
                                    "type": "string",
                                    "enum": [
                                        "elementwise",
                                        "reduce",
                                        "memory",
                                        "control",
                                        "constraint",
                                    ],
                                },
                                "name": {"type": "string"},
                                "inputs": {
                                    "type": "array",
                                    "items": {"type": "string"},
                                },
                                "outputs": {
                                    "type": "array",
                                    "items": {"type": "string"},
                                },
                                "params": {"type": "object"},
                            },
                            "required": ["op_type", "name", "inputs", "outputs"],
                            "additionalProperties": False,
                        },
                    },
                },
                "required": [
                    "transform_id",
                    "transform_type",
                    "rationale",
                    "ops",
                ],
                "additionalProperties": False,
            },
        },
    },
    "required": ["transforms"],
    "additionalProperties": False,
}


# ---------------------------------------------------------------------------
# Agent implementation
# ---------------------------------------------------------------------------


class LLMTransformAgent:
    """Generates FVIR variants using an LLM backend."""

    def __init__(self, llm: LLMBackend) -> None:
        self._llm = llm

    def transform(self, fvir: FVIR, max_variants: int = 5) -> list[Variant]:
        """Generate transformed variants of the input FVIR.

        Always includes the naive (identity) variant as variant_0.
        Additional variants are proposed by the LLM.

        Args:
            fvir: The input FVIR to transform.
            max_variants: Maximum number of variants to return (including naive).

        Returns:
            A list of Variant instances, starting with the naive variant.
        """
        logger.info(
            "Generating up to %d variants for kernel %s (model=%s)",
            max_variants,
            fvir.kernel_id,
            self._llm.model_id,
        )

        # Always include the naive (identity) variant.
        naive_variant = Variant(
            variant_id=f"{fvir.kernel_id}_v0",
            fvir=fvir,
            transform_applied="identity",
            transform_type=TransformType.NAIVE,
            rationale="Original FVIR with no transformation applied.",
        )
        variants: list[Variant] = [naive_variant]

        if max_variants <= 1:
            return variants

        # Ask the LLM for transform suggestions.
        max_suggestions = max_variants - 1  # reserve slot 0 for naive
        llm_variants = self._request_transforms(fvir, max_suggestions)
        variants.extend(llm_variants)

        logger.info(
            "Produced %d total variants for kernel %s",
            len(variants),
            fvir.kernel_id,
        )
        return variants

    # ------------------------------------------------------------------
    # Internal
    # ------------------------------------------------------------------

    def _request_transforms(
        self, fvir: FVIR, max_suggestions: int
    ) -> list[Variant]:
        """Call the LLM and parse its response into Variant objects."""
        ops_dicts = [
            {
                "op_type": op.op_type.value,
                "name": op.name,
                "inputs": op.inputs,
                "outputs": op.outputs,
                "params": op.params,
            }
            for op in fvir.ops
        ]

        messages = [
            {"role": "system", "content": TRANSFORM_SYSTEM_PROMPT},
            {
                "role": "user",
                "content": TRANSFORM_USER_TEMPLATE.format(
                    kernel_id=fvir.kernel_id,
                    source_latex=fvir.source_latex,
                    constraints=json.dumps(fvir.constraints, indent=2),
                    ops_json=json.dumps(ops_dicts, indent=2),
                    max_suggestions=max_suggestions,
                ),
            },
        ]

        response = self._llm.complete_structured(
            messages=messages,
            schema=TRANSFORM_RESPONSE_SCHEMA,
            temperature=0.7,
        )

        return self._build_variants(fvir, response, max_suggestions)

    def _build_variants(
        self, base_fvir: FVIR, response: dict, max_count: int
    ) -> list[Variant]:
        """Parse the LLM response into a list of Variant instances."""
        variants: list[Variant] = []
        raw_transforms = response.get("transforms", [])

        for idx, raw in enumerate(raw_transforms):
            if len(variants) >= max_count:
                break

            try:
                variant = self._build_single_variant(base_fvir, raw, idx + 1)
                variants.append(variant)
            except (KeyError, ValueError, TypeError) as exc:
                logger.warning(
                    "Skipping malformed transform at index %d: %s (raw=%r)",
                    idx,
                    exc,
                    raw,
                )
                continue

        return variants

    def _build_single_variant(
        self, base_fvir: FVIR, raw: dict, variant_num: int
    ) -> Variant:
        """Construct a single Variant from a raw transform dict."""
        transform_id: str = raw["transform_id"]
        transform_type_str: str = raw["transform_type"]
        rationale: str = raw["rationale"]
        raw_ops: list[dict] = raw["ops"]

        # Map string to enum.
        transform_type = TransformType(transform_type_str)

        # Build the modified ops list.
        ops = self._parse_ops(raw_ops)

        # Construct a new FVIR with the transformed ops.
        new_fvir = FVIR(
            kernel_id=base_fvir.kernel_id,
            ops=tuple(ops),
            constraints=base_fvir.constraints,
            source_latex=base_fvir.source_latex,
            metadata={
                **base_fvir.metadata,
                "transform": transform_id,
                "llm_model": self._llm.model_id,
            },
        )

        variant_id = f"{base_fvir.kernel_id}_v{variant_num}"

        return Variant(
            variant_id=variant_id,
            fvir=new_fvir,
            transform_applied=transform_id,
            transform_type=transform_type,
            rationale=rationale,
        )

    @staticmethod
    def _parse_ops(raw_ops: list[dict]) -> list[FVIROp]:
        """Convert raw op dicts into FVIROp instances."""
        ops: list[FVIROp] = []

        for raw_op in raw_ops:
            op_type = OpType(raw_op["op_type"])
            op = FVIROp(
                op_type=op_type,
                name=raw_op["name"],
                inputs=list(raw_op.get("inputs", [])),
                outputs=list(raw_op.get("outputs", [])),
                params=dict(raw_op.get("params") or {}),
            )
            ops.append(op)

        if not ops:
            raise ValueError("Transform produced an empty ops list")

        return ops
