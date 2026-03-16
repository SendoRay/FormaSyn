"""Pragma Tuner: fast-path iteration that only adjusts HLS pragma parameters.

Used when a variant fails L2 (resource/timing) but the algorithmic
approximation is fine. Adjusts array_partition, unroll_factor, pipeline II,
and dataflow pragmas without re-running the LLM.
"""

from __future__ import annotations

import copy
import logging
from dataclasses import dataclass
from typing import Optional

from FormaSyn.checker.diagnostic import FailureContext
from FormaSyn.ir.schedule_dialect import HLSScheduleDialect, ScheduleNode

logger = logging.getLogger(__name__)


@dataclass
class PragmaTuneAction:
    """A single pragma adjustment action.

    Attributes:
        node_id: Which node to adjust (or '__global__' for top-level).
        parameter: Which parameter to change.
        old_value: Previous value.
        new_value: Adjusted value.
        rationale: Why this adjustment was made.
    """
    node_id: str
    parameter: str
    old_value: object
    new_value: object
    rationale: str = ""


class PragmaTuner:
    """Fast-path pragma tuner that adjusts scheduling parameters.

    Given a failure context (typically L2 resource overflow or timing
    violation), applies conservative adjustments to the HLS-Schedule
    Dialect without changing the algorithm or quantization.
    """

    MAX_RETRIES: int = 3

    def tune(
        self,
        schedule: HLSScheduleDialect,
        failure: FailureContext,
    ) -> tuple[HLSScheduleDialect, list[PragmaTuneAction]]:
        """Apply pragma adjustments based on the failure diagnosis.

        Args:
            schedule: Current HLS-Schedule Dialect to adjust.
            failure: Structured failure context from the checker.

        Returns:
            A tuple of (adjusted schedule, list of actions taken).
        """
        schedule = copy.deepcopy(schedule)
        actions: list[PragmaTuneAction] = []

        resource_usage = failure.resource_usage
        resource_budget = failure.resource_budget

        if resource_usage.get("dsp", 0) > resource_budget.get("dsp", 999999):
            new_actions = self._reduce_unroll_factors(schedule)
            actions.extend(new_actions)

        if resource_usage.get("bram", 0) > resource_budget.get("bram", 999999):
            new_actions = self._reduce_array_partitions(schedule)
            actions.extend(new_actions)

        if "时序" in failure.summary or not failure.resource_budget:
            new_actions = self._relax_pipeline_ii(schedule)
            actions.extend(new_actions)

        self._recompute_estimates(schedule)

        logger.info(
            "PragmaTuner 完成 %d 项调整 [%s]",
            len(actions), schedule.variant_id,
        )
        return schedule, actions

    def _reduce_unroll_factors(
        self, schedule: HLSScheduleDialect
    ) -> list[PragmaTuneAction]:
        """Halve unroll factors on compute-heavy nodes."""
        actions: list[PragmaTuneAction] = []
        for nid, node in schedule.nodes.items():
            if node.op_type in ("map", "reduce") and node.unroll_factor > 1:
                old_uf = node.unroll_factor
                node.unroll_factor = max(1, old_uf // 2)
                actions.append(PragmaTuneAction(
                    node_id=nid,
                    parameter="unroll_factor",
                    old_value=old_uf,
                    new_value=node.unroll_factor,
                    rationale="DSP 超限，减半 unroll factor",
                ))
        return actions

    def _reduce_array_partitions(
        self, schedule: HLSScheduleDialect
    ) -> list[PragmaTuneAction]:
        """Downgrade array partition from complete to cyclic or none."""
        actions: list[PragmaTuneAction] = []
        for nid, node in schedule.nodes.items():
            if node.array_partition_type == "complete":
                old = node.array_partition_type
                node.array_partition_type = "cyclic"
                actions.append(PragmaTuneAction(
                    node_id=nid,
                    parameter="array_partition_type",
                    old_value=old,
                    new_value="cyclic",
                    rationale="BRAM 超限，降级 partition 为 cyclic",
                ))
        return actions

    def _relax_pipeline_ii(
        self, schedule: HLSScheduleDialect
    ) -> list[PragmaTuneAction]:
        """Increase pipeline II to relax timing."""
        old_ii = schedule.expected_ii
        schedule.expected_ii = old_ii + 1
        for node in schedule.nodes.values():
            node.pipeline_ii = max(node.pipeline_ii, schedule.expected_ii)
        return [PragmaTuneAction(
            node_id="__global__",
            parameter="expected_ii",
            old_value=old_ii,
            new_value=schedule.expected_ii,
            rationale="时序不满足，放宽 pipeline II",
        )]

    @staticmethod
    def _recompute_estimates(schedule: HLSScheduleDialect) -> None:
        """Recompute aggregate resource estimates after adjustments."""
        total_dsp = 0
        for node in schedule.nodes.values():
            op = node.op_detail.get("op") or node.op_detail.get("func", "")
            if op in ("mul", "multiply"):
                total_dsp += 2 * node.unroll_factor
        schedule.total_dsp_estimate = total_dsp
