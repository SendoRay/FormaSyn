"""LLM-based code generation agent: FVIR variant -> synthesizable Verilog + testbench."""

from __future__ import annotations

import logging
import re
from datetime import datetime, timezone

from ..protocols import LLMBackend
from ..types import GeneratedCode, Variant

logger = logging.getLogger(__name__)

_SYSTEM_PROMPT = """\
You are a hardware design expert specializing in synthesizable Verilog RTL for FPGA targets.

Rules:
- Generate ONLY synthesizable constructs. No `initial` blocks, no `#delay`, no `$display` \
in the design module.
- Use synchronous reset (active-high `rst`).
- All signals must be fully specified (no inferred latches).
- Fixed-point arithmetic uses the bit-widths specified in the constraints.
- Module name must be `kernel_{kernel_id}`.
- Include a clock (`clk`) and reset (`rst`) port.
- All I/O widths must match the FVIR constraints.
"""

_CODEGEN_PROMPT_TEMPLATE = """\
Generate synthesizable Verilog RTL and a Verilator-compatible testbench for the following \
hardware kernel.

## Kernel ID
{kernel_id}

## FVIR Operations
{ops_description}

## Constraints
{constraints}

## Transform Applied
- Name: {transform_applied}
- Type: {transform_type}
- Rationale: {rationale}

## Source Formula (LaTeX)
{source_latex}

## Requirements
1. The Verilog module must be named `kernel_{kernel_id}`.
2. Produce a self-contained Verilator-compatible testbench (C++ or SystemVerilog wrapper) \
that reads stimulus from `input.csv` and writes results to `output.csv`.
3. The testbench must drive all inputs, toggle clock, assert reset for 5 cycles, then apply \
test vectors.

Return your answer with exactly two fenced code blocks:

```verilog
// ... design RTL here ...
```

```testbench
// ... testbench here ...
```
"""


def _format_ops(ops: tuple) -> str:
    """Format FVIR ops into a readable description for the prompt."""
    lines = []
    for i, op in enumerate(ops):
        params_str = ", ".join(f"{k}={v}" for k, v in op.params.items()) if op.params else ""
        lines.append(
            f"  {i + 1}. [{op.op_type.value}] {op.name}: "
            f"inputs={op.inputs} -> outputs={op.outputs}"
            f"{f' ({params_str})' if params_str else ''}"
        )
    return "\n".join(lines)


def _format_constraints(constraints: dict) -> str:
    """Format constraints dict into readable text."""
    lines = []
    for key, value in constraints.items():
        lines.append(f"  - {key}: {value}")
    return "\n".join(lines)


def _extract_code_blocks(response: str) -> tuple[str, str]:
    """Extract Verilog and testbench from fenced code blocks.

    Looks for ```verilog ... ``` and ```testbench ... ``` markers.
    Falls back to first two code blocks if specific markers not found.
    """
    # Try specific markers first
    verilog_match = re.search(
        r"```verilog\s*\n(.*?)```", response, re.DOTALL
    )
    testbench_match = re.search(
        r"```testbench\s*\n(.*?)```", response, re.DOTALL
    )

    if verilog_match and testbench_match:
        return verilog_match.group(1).strip(), testbench_match.group(1).strip()

    # Fallback: grab any code blocks
    all_blocks = re.findall(r"```(?:\w*)\s*\n(.*?)```", response, re.DOTALL)
    if len(all_blocks) >= 2:
        return all_blocks[0].strip(), all_blocks[1].strip()
    if len(all_blocks) == 1:
        logger.warning("Only one code block found; using it as Verilog, testbench empty.")
        return all_blocks[0].strip(), ""

    logger.error("No code blocks found in LLM response.")
    return response.strip(), ""


class LLMCodegenAgent:
    """Generates synthesizable Verilog RTL + testbench from an FVIR Variant using an LLM."""

    def __init__(self, llm: LLMBackend) -> None:
        self._llm = llm

    def generate(self, variant: Variant) -> GeneratedCode:
        """Generate Verilog RTL and testbench for the given variant.

        Constructs a detailed prompt from the FVIR representation and asks the
        LLM to produce synthesizable Verilog and a Verilator-compatible testbench.
        """
        fvir = variant.fvir

        prompt_body = _CODEGEN_PROMPT_TEMPLATE.format(
            kernel_id=fvir.kernel_id,
            ops_description=_format_ops(fvir.ops),
            constraints=_format_constraints(fvir.constraints),
            transform_applied=variant.transform_applied,
            transform_type=variant.transform_type.value,
            rationale=variant.rationale,
            source_latex=fvir.source_latex,
        )

        messages = [
            {"role": "system", "content": _SYSTEM_PROMPT},
            {"role": "user", "content": prompt_body},
        ]

        logger.info(
            "Generating code for variant %s (kernel=%s, transform=%s)",
            variant.variant_id,
            fvir.kernel_id,
            variant.transform_applied,
        )

        response = self._llm.complete(messages, temperature=0.4, max_tokens=8192)

        verilog, testbench = _extract_code_blocks(response)

        if not verilog:
            logger.error("Empty Verilog generated for variant %s", variant.variant_id)

        timestamp = datetime.now(timezone.utc).isoformat()

        return GeneratedCode(
            variant_id=variant.variant_id,
            verilog=verilog,
            testbench=testbench,
            generation_metadata={
                "model_id": self._llm.model_id,
                "timestamp": timestamp,
                "temperature": 0.4,
                "transform_applied": variant.transform_applied,
            },
        )
