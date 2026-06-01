"""Feedback Loop: three-level nested iteration controller.

Three nested retry levels:
  - Inner:  codegen retries (CODEGEN_AGENT failures)
  - Middle: schedule retries (RTL_SCHEDULER / MEMORY_LAYOUT failures)
  - Outer:  DSE retries     (TEMPLATE_ENGINE / DSE_AGENT failures)

run.py reads LoopResult.target_layer / should_retry_* flags to decide
which pipeline stage to re-enter.
"""

from __future__ import annotations

import copy
import logging
from dataclasses import dataclass, field
from typing import Any, Optional

from ..agent.diagnostic import (
    AgentDiagnostic,
    RecoveryAction,
    RecoveryLayer,
)
from ..checker.diagnostic import FailureContext

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Data classes
# ---------------------------------------------------------------------------

@dataclass
class LoopState:
    """Per-run iteration counters and history."""

    codegen_round: int = 0
    schedule_round: int = 0
    dse_round: int = 0
    history: list[FailureContext] = field(default_factory=list)
    recovery_history: list[RecoveryAction] = field(default_factory=list)


@dataclass
class LoopResult:
    """Returned by diagnose_and_recover(); tells run.py what to do next."""

    success: bool = False
    new_ir: object | None = None
    feedback_text: str = ""
    actions_taken: list[str] = field(default_factory=list)
    should_retry_dse: bool = False
    should_retry_schedule: bool = False
    target_layer: Optional[str] = None


# ---------------------------------------------------------------------------
# FeedbackLoop
# ---------------------------------------------------------------------------

class FeedbackLoop:
    """Three-level nested feedback controller.

    Limits are independently configurable per level:
      max_codegen  – inner-loop retries  (codegen re-generation)
      max_schedule – middle-loop retries (schedule / memory layout)
      max_dse      – outer-loop retries  (DSE re-exploration)
    """

    def __init__(
        self,
        max_codegen: int = 3,
        max_schedule: int = 3,
        max_dse: int = 3,
    ) -> None:
        self._max_codegen = max_codegen
        self._max_schedule = max_schedule
        self._max_dse = max_dse
        self._state = LoopState()
        self._diagnostic = AgentDiagnostic()

    # -- public API ---------------------------------------------------------

    @property
    def state(self) -> LoopState:
        return self._state

    def diagnose_and_recover(
        self,
        ir: Any,
        failure: FailureContext,
    ) -> LoopResult:
        """Diagnose a failure and return a LoopResult for run.py.

        Steps:
          1. Call AgentDiagnostic.diagnose() to get LLM (or rule-based) decision.
          2. Map RecoveryLayer to the three-level retry model.
          3. Apply recovery action to a deep-copied IR.
          4. Return LoopResult with retry flags.
        """
        self._state.history.append(failure)

        diag = self._diagnostic.diagnose(failure)

        result = LoopResult(feedback_text=diag.feedback_text)

        if not diag.recovery_action:
            logger.warning("Agent returned no recovery action")
            return result

        action = diag.recovery_action
        self._state.recovery_history.append(action)

        logger.info(
            "Recovery decision: layer=%s action=%s reason=%.100s",
            action.layer.value,
            action.action_type,
            action.rationale,
        )

        # --- determine retry level from RecoveryLayer ---
        layer = action.layer

        if layer == RecoveryLayer.CODEGEN_AGENT:
            self._state.codegen_round += 1
            if self._state.codegen_round > self._max_codegen:
                logger.warning("Codegen retry limit reached (%d)", self._max_codegen)
                return result
            result.target_layer = "codegen"

        elif layer in (RecoveryLayer.RTL_SCHEDULER, RecoveryLayer.MEMORY_LAYOUT):
            self._state.schedule_round += 1
            self._state.codegen_round = 0  # reset inner counter
            if self._state.schedule_round > self._max_schedule:
                logger.warning("Schedule retry limit reached (%d)", self._max_schedule)
                return result
            result.should_retry_schedule = True
            result.target_layer = "schedule"

        elif layer in (RecoveryLayer.TEMPLATE_ENGINE, RecoveryLayer.DSE_AGENT):
            self._state.dse_round += 1
            self._state.schedule_round = 0
            self._state.codegen_round = 0
            if self._state.dse_round > self._max_dse:
                logger.warning("DSE retry limit reached (%d)", self._max_dse)
                return result
            result.should_retry_dse = True
            result.target_layer = "dse"

        else:
            logger.warning("Unknown RecoveryLayer: %s", layer)
            return result

        # --- apply action to IR ---
        try:
            new_ir = self._apply_action(ir, action)
            result.success = True
            result.new_ir = new_ir
            result.actions_taken = [
                f"[{action.layer.value}] {action.action_type}"
            ]
        except Exception as exc:
            logger.warning("Failed to apply recovery action: %.200s", str(exc))

        return result

    def generate_feedback_for_dse(self) -> str:
        """Markdown summary of recent failures for DSE re-exploration."""
        recent = self._state.history[-3:]
        parts: list[str] = [
            "## DSE Feedback (recent failures)",
            "",
        ]

        if not recent:
            parts.append("No recorded failures.")
            return "\n".join(parts)

        parts.append("### Failure summary")
        for fc in recent:
            parts.append(f"- **{fc.variant_id}**: {fc.summary}")
            if fc.gap_description:
                parts.append(f"  Gap: {fc.gap_description}")

        recent_actions = self._state.recovery_history[-3:]
        if recent_actions:
            parts.extend(["", "### Recovery attempts"])
            for i, act in enumerate(recent_actions, 1):
                parts.append(
                    f"{i}. [{act.layer.value}] {act.action_type}: "
                    f"{act.rationale[:80]}"
                )

        parts.extend([
            "",
            f"### Stats: {len(self._state.history)} total failures, "
            f"{len(self._state.recovery_history)} recovery attempts",
            "",
            "Avoid repeating strategies that already failed.",
        ])
        return "\n".join(parts)

    def reset(self) -> None:
        """Clear all state for a fresh run."""
        self._state = LoopState()

    # -- private helpers ----------------------------------------------------

    def _apply_action(self, ir: Any, action: RecoveryAction) -> object:
        """Deep-copy *ir* and apply the recovery action in-place."""
        if action.layer == RecoveryLayer.DSE_AGENT:
            return ir  # no local modification needed

        ir = copy.deepcopy(ir)
        action_type = action.action_type
        params = action.params

        if action_type in ("relax_quant", "fine_tune_quant"):
            self._act_relax_quant(ir, params, fine=(action_type == "fine_tune_quant"))
        elif action_type == "reduce_parallelism":
            self._act_reduce_parallelism(ir, params)
        elif action_type == "change_approx_method":
            self._act_change_approx(ir, params)
        elif action_type == "toggle_saturation":
            self._act_toggle_saturation(ir, params)
        else:
            logger.info("No specific handler for action_type=%s; returning IR unchanged", action_type)

        return ir

    # -- action implementations ---------------------------------------------

    @staticmethod
    def _act_relax_quant(ir: Any, params: dict, *, fine: bool = False) -> None:
        if not hasattr(ir, "nodes"):
            return
        int_inc = params.get("int_bits_increment", 0)
        frac_inc = params.get("frac_bits_increment", 1 if fine else 2)
        for node in ir.nodes.values():
            if hasattr(node, "quant_int_bits"):
                node.quant_int_bits += int_inc
            if hasattr(node, "quant_frac_bits"):
                node.quant_frac_bits = min(node.quant_frac_bits + frac_inc, 48)

    @staticmethod
    def _act_reduce_parallelism(ir: Any, params: dict) -> None:
        if not hasattr(ir, "nodes"):
            return
        factor = params.get("parallelism_factor", 0.5)
        for node in ir.nodes.values():
            if not hasattr(node, "parallelism"):
                continue
            old = node.parallelism
            if old > 1:
                new = max(1, int(old * factor))
                new = 2 ** (new.bit_length() - 1) if new > 1 else 1
                node.parallelism = new

    @staticmethod
    def _act_change_approx(ir: Any, params: dict) -> None:
        if not hasattr(ir, "nodes"):
            return
        new_method = params.get("approx_method", "min_sum")
        for node in ir.nodes.values():
            if hasattr(node, "approx_method"):
                node.approx_method = new_method

    @staticmethod
    def _act_toggle_saturation(ir: Any, params: dict) -> None:
        if not hasattr(ir, "nodes"):
            return
        enable = params.get("enable_saturation", True)
        for node in ir.nodes.values():
            if hasattr(node, "saturation_guard"):
                node.saturation_guard = enable
