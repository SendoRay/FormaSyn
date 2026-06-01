"""LLM-driven Verilog code generation agent.

Takes an RTLScheduleDialect plus scaffold code, sends them to an LLM,
and returns synthesisable Verilog.  Falls back to scaffold-only output
when the LLM is unavailable or returns invalid code.
"""

from __future__ import annotations

import json
import logging
import re
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

from formasyn.agent.base_agent import BaseAgent
from formasyn.agent.knowledge_prompt import COMM_KNOWLEDGE_PROMPT
from formasyn.codegen.scaffold import generate_scaffold
from formasyn.ir.rtl_dialect import RTLScheduleDialect

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# System prompt
# ---------------------------------------------------------------------------

_VERILOG_SYSTEM_PROMPT: str = """\
You are a synthesisable Verilog RTL code generator for FPGA targets.

Given an RTL schedule (JSON) and a Verilog scaffold, produce a COMPLETE
Verilog module that implements the described datapath.  Output ONLY the
raw Verilog source code — no markdown fences, no explanations.

Design rules you MUST follow:
1. Fixed-point arithmetic: use explicit bit-width declarations everywhere.
   Multiply results must be wide enough to hold the full product
   (width_a + width_b) before truncation/rounding.
2. Pipeline stages: insert registered pipeline boundaries exactly where
   the schedule's pipeline_stage field dictates.  Use `always @(posedge clk)`
   blocks for registered stages.
3. FSM: if fsm_states are provided, implement a synchronous state machine
   with a default IDLE reset state.  Transitions follow fsm_transitions.
4. Explicit bit widths: every wire, reg, and port MUST have an explicit
   [MSB:LSB] range (no implicit 1-bit signals except single-bit control).
5. Saturation guards: when saturation_guard is true for a node, clamp
   the result to the representable range instead of wrapping.
6. Reset: use active-low synchronous reset (rst_n).  On reset, all
   registers and outputs go to zero, FSM returns to the first state.
7. All signals are signed unless explicitly marked unsigned.
8. No latches — every reg must be assigned in every branch of its
   always block, or use a default assignment at the top.
9. Use `assign` for purely combinational paths and `always @(posedge clk)`
   for sequential paths.  Never mix blocking and non-blocking assignments
   in the same always block.
10. Preserve the module name and port list from the scaffold exactly.

""" + COMM_KNOWLEDGE_PROMPT


# ---------------------------------------------------------------------------
# Artifacts dataclass
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class VerilogArtifacts:
    """In-memory Verilog source and persisted artifact paths for one variant."""

    variant_id: str
    example_name: str
    output_dir: str
    kernel_v: str
    kernel_v_path: str
    metadata_path: str


# ---------------------------------------------------------------------------
# Agent
# ---------------------------------------------------------------------------

class VerilogCodegenAgent(BaseAgent):
    """Generate synthesisable Verilog from an RTLScheduleDialect via LLM."""

    def __init__(
        self,
        model: str | None = None,
        artifact_root: str = "examplesbk",
    ) -> None:
        super().__init__(model=model)
        self._artifact_root = Path(artifact_root)

    # -- public API ---------------------------------------------------------

    def generate(
        self,
        schedule: RTLScheduleDialect,
        *,
        example_name: str,
        golden_behavior: str = "",
        force_fallback: bool = False,
    ) -> VerilogArtifacts:
        """Generate and persist Verilog artifacts for one schedule variant.

        Args:
            schedule: A fully populated RTLScheduleDialect.
            example_name: Human-readable name of the example/kernel.
            golden_behavior: Optional natural-language description of the
                expected golden-model behaviour (fed to the LLM for context).
            force_fallback: When True, skip the LLM entirely and emit the
                scaffold with a FALLBACK marker.

        Returns:
            A ``VerilogArtifacts`` with paths to written files.
        """
        scaffold = generate_scaffold(schedule)
        schedule_json = json.dumps(schedule.to_json(), ensure_ascii=False, indent=2)

        verilog_src: str | None = None

        if not force_fallback:
            try:
                verilog_src = self._llm_generate(schedule_json, scaffold, golden_behavior)
            except Exception as exc:
                logger.warning(
                    "LLM Verilog generation failed for variant '%s' (%s), "
                    "falling back to scaffold-only output.",
                    schedule.variant_id,
                    str(exc)[:120],
                )

        if verilog_src is None:
            verilog_src = scaffold.replace(
                "// ===== DATAPATH LOGIC (LLM generates below) =====",
                "// ===== DATAPATH LOGIC (FALLBACK: scaffold-only) =====",
            )

        return self._write_artifacts(
            schedule=schedule,
            example_name=example_name,
            verilog_src=verilog_src,
        )

    # -- LLM interaction ----------------------------------------------------

    def _llm_generate(
        self,
        schedule_json: str,
        scaffold: str,
        golden_behavior: str,
    ) -> str:
        """Call the LLM and return validated Verilog source code.

        Raises:
            ValueError: If the LLM response does not contain a valid
                Verilog module definition.
        """
        user_parts = [
            "## RTL Schedule (JSON)\n",
            schedule_json,
            "\n\n## Verilog Scaffold\n",
            scaffold,
        ]
        if golden_behavior:
            user_parts.append("\n\n## Golden Model Behaviour\n")
            user_parts.append(golden_behavior)

        user_prompt = "".join(user_parts)

        raw = self._chat_completion(
            system_prompt=_VERILOG_SYSTEM_PROMPT,
            user_prompt=user_prompt,
            temperature=0.2,
            timeout=120.0,
        )

        code = _strip_markdown_fences(raw)

        if "module " not in code:
            raise ValueError(
                "LLM response does not contain a Verilog module definition"
            )

        return code

    # -- artifact persistence -----------------------------------------------

    def _write_artifacts(
        self,
        *,
        schedule: RTLScheduleDialect,
        example_name: str,
        verilog_src: str,
    ) -> VerilogArtifacts:
        """Write Verilog source and metadata JSON to disk."""
        variant_id = schedule.variant_id or "v0"
        kernel_name = schedule.kernel_name or "kernel"

        output_dir = self._artifact_root / example_name / variant_id
        output_dir.mkdir(parents=True, exist_ok=True)

        v_path = output_dir / f"{kernel_name}_top.v"
        metadata_path = output_dir / "metadata.json"

        v_path.write_text(verilog_src, encoding="utf-8")

        metadata = {
            "variant_id": variant_id,
            "example_name": example_name,
            "kernel_name": kernel_name,
            "backend": "verilog",
            "model": self.model,
            "base_url": self.base_url,
            "generated_at_utc": datetime.now(timezone.utc).isoformat(),
            "resource_estimates": {
                "estimated_luts": schedule.estimated_luts,
                "estimated_ffs": schedule.estimated_ffs,
                "estimated_dsps": schedule.estimated_dsps,
                "estimated_brams": schedule.estimated_brams,
            },
            "schedule_summary": {
                "node_count": len(schedule.nodes),
                "input_nodes": schedule.input_nodes,
                "output_nodes": schedule.output_nodes,
                "total_pipeline_stages": schedule.total_pipeline_stages,
                "total_latency_cycles": schedule.total_latency_cycles,
                "clock_period_ns": schedule.clock_period_ns,
            },
        }
        metadata_path.write_text(
            json.dumps(metadata, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )

        return VerilogArtifacts(
            variant_id=variant_id,
            example_name=example_name,
            output_dir=str(output_dir),
            kernel_v=verilog_src,
            kernel_v_path=str(v_path),
            metadata_path=str(metadata_path),
        )


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _strip_markdown_fences(text: str) -> str:
    """Remove optional markdown code fences wrapping the response."""
    text = text.strip()
    if text.startswith("```"):
        text = re.sub(r"^```(?:verilog|v)?\s*\n?", "", text, count=1)
        text = re.sub(r"\n?```\s*$", "", text, count=1)
    return text.strip()
