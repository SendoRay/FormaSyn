"""LLM-based Parse Agent: LaTeX formula -> FVIR."""

from __future__ import annotations

import hashlib
import logging
from typing import Any

from formaflow.protocols import LLMBackend
from formaflow.types import FVIR, FVIROp, OpType

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Prompt template
# ---------------------------------------------------------------------------

PARSE_SYSTEM_PROMPT = """\
You are an expert hardware-design compiler that decomposes mathematical \
formulas into FVIR (Formula-to-Verilog Intermediate Representation) operations.

FVIR has exactly 5 operation types:
  1. elementwise — point-to-point arithmetic (add, sub, mul, div, exp, log, abs, shift, etc.)
  2. reduce      — accumulation across a dimension (sum, max, min, dot-product, etc.)
  3. memory      — buffer/register/FIFO operations (load, store, delay, circular buffer)
  4. control     — mux, demux, enable, loop counter, state-machine transition
  5. constraint  — non-functional annotation (@width, @throughput, @freq, @resource_limit)

Each operation is a dict with:
  - op_type: one of "elementwise", "reduce", "memory", "control", "constraint"
  - name: a short descriptive identifier (e.g. "mul_ab", "acc_sum")
  - inputs: list of variable/signal names consumed
  - outputs: list of variable/signal names produced
  - params: optional dict of parameters (bit-width, depth, etc.)

Decompose the formula into the minimal set of ordered ops that faithfully \
represent its computation graph. Preserve mathematical equivalence.
"""

PARSE_USER_TEMPLATE = """\
Decompose the following LaTeX formula into FVIR operations.

Formula:
{latex}

Design constraints:
{constraints}

Return the ops list as JSON conforming to the provided schema.
"""

# ---------------------------------------------------------------------------
# JSON schema for structured output
# ---------------------------------------------------------------------------

FVIR_RESPONSE_SCHEMA: dict[str, Any] = {
    "type": "object",
    "properties": {
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
                    "inputs": {"type": "array", "items": {"type": "string"}},
                    "outputs": {"type": "array", "items": {"type": "string"}},
                    "params": {"type": "object"},
                },
                "required": ["op_type", "name", "inputs", "outputs"],
                "additionalProperties": False,
            },
        },
    },
    "required": ["ops"],
    "additionalProperties": False,
}


# ---------------------------------------------------------------------------
# Agent implementation
# ---------------------------------------------------------------------------


class LLMParseAgent:
    """Parses a LaTeX formula into FVIR using an LLM backend."""

    def __init__(self, llm: LLMBackend) -> None:
        self._llm = llm

    def parse(self, latex: str, constraints: dict) -> FVIR:
        """Parse a LaTeX formula string into an FVIR dataclass.

        Args:
            latex: The LaTeX formula to decompose.
            constraints: Design constraints (e.g. bit-width, throughput target).

        Returns:
            An FVIR instance representing the formula's computation graph.
        """
        kernel_id = self._generate_kernel_id(latex)
        logger.info(
            "Parsing formula into FVIR (kernel_id=%s, model=%s)",
            kernel_id,
            self._llm.model_id,
        )

        messages = [
            {"role": "system", "content": PARSE_SYSTEM_PROMPT},
            {
                "role": "user",
                "content": PARSE_USER_TEMPLATE.format(
                    latex=latex,
                    constraints=self._format_constraints(constraints),
                ),
            },
        ]

        response = self._llm.complete_structured(
            messages=messages,
            schema=FVIR_RESPONSE_SCHEMA,
            temperature=0.2,
        )

        ops = self._build_ops(response)

        fvir = FVIR(
            kernel_id=kernel_id,
            ops=tuple(ops),
            constraints=constraints,
            source_latex=latex,
            metadata={"llm_model": self._llm.model_id},
        )

        logger.info(
            "Parsed %d ops for kernel %s", len(fvir.ops), kernel_id
        )
        return fvir

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------

    @staticmethod
    def _generate_kernel_id(latex: str) -> str:
        """Deterministic kernel ID derived from the formula text."""
        digest = hashlib.sha256(latex.encode()).hexdigest()[:12]
        return f"k_{digest}"

    @staticmethod
    def _format_constraints(constraints: dict) -> str:
        """Pretty-print constraints for the prompt."""
        if not constraints:
            return "(none specified)"
        lines = [f"  {k}: {v}" for k, v in constraints.items()]
        return "\n".join(lines)

    @staticmethod
    def _build_ops(response: dict) -> list[FVIROp]:
        """Convert the raw LLM response dict into a list of FVIROp instances."""
        ops: list[FVIROp] = []
        raw_ops = response.get("ops", [])

        for idx, raw in enumerate(raw_ops):
            try:
                op_type = OpType(raw["op_type"])
                op = FVIROp(
                    op_type=op_type,
                    name=raw["name"],
                    inputs=list(raw.get("inputs", [])),
                    outputs=list(raw.get("outputs", [])),
                    params=dict(raw.get("params") or {}),
                )
                ops.append(op)
            except (KeyError, ValueError) as exc:
                logger.warning(
                    "Skipping malformed op at index %d: %s (raw=%r)",
                    idx,
                    exc,
                    raw,
                )
                continue

        if not ops:
            raise ValueError(
                "LLM returned no valid ops — cannot construct FVIR"
            )

        return ops
