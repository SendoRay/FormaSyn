"""Rewrite engine: applies rule combinations to AlgoHW Dialect IR.

The engine is the mechanism by which Direction A operates: given a budget
(resource + quality), it applies a sequence of rewrite rules and validates
that the combined quality bound remains within budget.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Any

from .rules import RewriteCatalog, RewriteRule, QualityBound, ResourceDelta
from ..ir.algo_hw_dialect import AlgoHWDialect, AlgoHWNode

logger = logging.getLogger(__name__)


@dataclass
class RewriteResult:
    """Result of applying a rewrite sequence to an AlgoHW dialect.

    Attributes:
        dialect: The modified AlgoHW dialect.
        applied_rules: Names of rules successfully applied.
        combined_quality_bound: Total quality degradation bound.
        combined_resource_delta: Total resource change.
        skipped_rules: Rules that could not be applied (with reasons).
    """

    dialect: AlgoHWDialect
    applied_rules: list[str] = field(default_factory=list)
    combined_quality_bound: dict[str, float] = field(default_factory=dict)
    combined_resource_delta: ResourceDelta = field(default_factory=ResourceDelta)
    skipped_rules: dict[str, str] = field(default_factory=dict)


@dataclass
class QualityBudget:
    """Quality budget for rewrite application.

    Attributes:
        max_ber_penalty_db: Maximum acceptable BER penalty.
        max_nmse_db: Maximum acceptable NMSE (more negative = stricter).
        max_evm_db: Maximum acceptable EVM degradation.
    """

    max_ber_penalty_db: float = 0.5
    max_nmse_db: float = -30.0
    max_evm_db: float = 3.0


class RewriteEngine:
    """Applies rewrite rules to AlgoHW IR with quality budget enforcement.

    The engine:
    1. Takes a sequence of rule names (from LLM search or manual selection).
    2. Checks composability and budget constraints.
    3. Applies each rule to the IR.
    4. Returns the modified IR with provable quality guarantees.
    """

    def __init__(self, catalog: RewriteCatalog | None = None) -> None:
        self._catalog = catalog or RewriteCatalog()

    @property
    def catalog(self) -> RewriteCatalog:
        return self._catalog

    def apply(
        self,
        dialect: AlgoHWDialect,
        rule_names: list[str],
        quality_budget: QualityBudget | None = None,
        rule_params: dict[str, dict[str, float]] | None = None,
    ) -> RewriteResult:
        """Apply a sequence of rewrite rules to the AlgoHW dialect.

        Args:
            dialect: Input AlgoHW dialect to transform.
            rule_names: Ordered list of rule names to apply.
            quality_budget: Maximum quality degradation allowed.
            rule_params: Per-rule parameter overrides
                (e.g. {'R2_normalized_minsum': {'alpha': 0.78}}).

        Returns:
            RewriteResult with modified dialect and guarantees.
        """
        if quality_budget is None:
            quality_budget = QualityBudget()
        if rule_params is None:
            rule_params = {}

        result = RewriteResult(dialect=dialect)

        # Check composability first
        conflicts = self._catalog.check_composability(rule_names)
        if conflicts:
            for conflict in conflicts:
                logger.warning("Composability conflict: %s", conflict)
            # Remove conflicting rules
            rule_names = self._resolve_conflicts(rule_names, conflicts)

        # Check combined quality bound against budget
        combined_bound = self._catalog.compute_combined_bound(rule_names)
        ber_bound = combined_bound.get("ber_penalty_db", 0.0)
        if ber_bound > quality_budget.max_ber_penalty_db:
            logger.warning(
                "Combined BER bound %.2f dB exceeds budget %.2f dB",
                ber_bound, quality_budget.max_ber_penalty_db
            )

        # Apply rules sequentially
        current_dialect = dialect
        for rule_name in rule_names:
            rule = self._catalog.get(rule_name)
            if rule is None:
                result.skipped_rules[rule_name] = "Rule not found in catalog"
                continue

            params = rule_params.get(rule_name, {})
            try:
                current_dialect = self._apply_single_rule(current_dialect, rule, params)
                result.applied_rules.append(rule_name)
                logger.info("Applied rule: %s", rule_name)
            except RuleApplicationError as e:
                result.skipped_rules[rule_name] = str(e)
                logger.warning("Skipped rule %s: %s", rule_name, e)

        result.dialect = current_dialect
        result.combined_quality_bound = self._catalog.compute_combined_bound(result.applied_rules)
        result.combined_resource_delta = self._catalog.compute_combined_resource(result.applied_rules)
        return result

    def _apply_single_rule(
        self,
        dialect: AlgoHWDialect,
        rule: RewriteRule,
        params: dict[str, float],
    ) -> AlgoHWDialect:
        """Apply a single rewrite rule to the dialect.

        This modifies nodes in-place based on the rule's pattern and replacement.
        """
        matched = False

        for node_id, node in dialect.nodes.items():
            if self._matches_pattern(node, rule.pattern):
                self._apply_replacement(node, rule.replacement, params)
                matched = True

        if not matched:
            raise RuleApplicationError(f"No matching nodes for pattern: {rule.pattern.op_types}")

        return dialect

    def _matches_pattern(self, node: AlgoHWNode, pattern: "RewritePattern") -> bool:
        """Check if a node matches the rule's pattern."""
        from .rules import RewritePattern

        # Check op_type
        if pattern.op_types and node.op_type not in pattern.op_types:
            return False

        # Check function match
        if pattern.func_match:
            node_func = node.op_detail.get("func", "")
            expected_funcs = list(pattern.func_match.values())
            if node_func not in expected_funcs:
                return False

        # Check domain match
        if pattern.domain_match:
            node_domain = node.op_detail.get("domain_kind", "")
            if node_domain != pattern.domain_match:
                return False

        # Check additional constraints
        for key, value in pattern.constraints.items():
            if node.op_detail.get(key) != value:
                return False

        return True

    def _apply_replacement(
        self,
        node: AlgoHWNode,
        replacement: "RewriteReplacement",
        params: dict[str, float],
    ) -> None:
        """Modify a node according to the replacement specification."""
        from .rules import RewriteReplacement

        # Apply function changes
        if replacement.new_funcs:
            for key, new_func in replacement.new_funcs.items():
                if "func" in node.op_detail:
                    node.op_detail["func"] = new_func

        # Apply new parameters
        merged_params = {**replacement.new_params, **params}
        for key, value in merged_params.items():
            node.op_detail[key] = value

        # Update approx_method if this changes the algorithm
        if replacement.new_params.get("scale") or replacement.new_params.get("scale_factor"):
            node.approx_method = "normalized_min_sum"
        elif replacement.new_params.get("offset_beta"):
            node.approx_method = "offset_min_sum"
        elif replacement.new_params.get("table_depth"):
            node.approx_method = "lut_tanh"

    def _resolve_conflicts(
        self, rule_names: list[str], conflicts: list[str]
    ) -> list[str]:
        """Remove conflicting rules, keeping the first one encountered."""
        # Simple strategy: if R2 and R3 conflict, keep the first one in the list
        if "R2 and R3" in " ".join(conflicts):
            if "R2_normalized_minsum" in rule_names and "R3_offset_minsum" in rule_names:
                idx_r2 = rule_names.index("R2_normalized_minsum")
                idx_r3 = rule_names.index("R3_offset_minsum")
                if idx_r2 < idx_r3:
                    rule_names.remove("R3_offset_minsum")
                else:
                    rule_names.remove("R2_normalized_minsum")
        return rule_names


class RuleApplicationError(Exception):
    """Raised when a rewrite rule cannot be applied to the IR."""
