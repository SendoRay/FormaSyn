"""NSGA-II based cross-layer Pareto optimizer.

Direction C: Proves that joint optimization across Math x AlgoHW x Schedule
can find Pareto-optimal points unreachable by sequential layer-isolated optimization.

Three objectives:
1. Resource cost: w_dsp * DSP + w_bram * BRAM + w_lut * LUT
2. Quality loss: BER_penalty_dB or NMSE_penalty_dB
3. Latency: II * cycles_per_output
"""

from __future__ import annotations

import logging
import math
import random
from dataclasses import dataclass, field
from typing import Any, Callable, Optional

import numpy as np

logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Design point representation
# ---------------------------------------------------------------------------

@dataclass
class DesignPoint:
    """A single point in the cross-layer design space.

    Encodes choices from all three layers simultaneously.

    Attributes:
        approx_method: Algorithm-level choice (Math layer).
        approx_params: Parameters for the approximation (alpha, beta, etc.).
        parallelism: Hardware parallelism (AlgoHW layer).
        quant_int_bits: Integer bit-width (AlgoHW layer).
        quant_frac_bits: Fractional bit-width (AlgoHW layer).
        enable_saturation: Whether to enable saturation guards.
        unroll_factor: Loop unroll factor (Schedule layer).
        pipeline_ii: Target initiation interval (Schedule layer).
        array_partition: Array partition type (Schedule layer).
        use_dataflow: Whether to use DATAFLOW pragma (Schedule layer).
    """

    # Math layer
    approx_method: str = "spa_exact"
    approx_params: dict[str, float] = field(default_factory=dict)

    # AlgoHW layer
    parallelism: int = 1
    quant_int_bits: int = 8
    quant_frac_bits: int = 8
    enable_saturation: bool = True

    # Schedule layer
    unroll_factor: int = 1
    pipeline_ii: int = 1
    array_partition: str = "none"
    use_dataflow: bool = False

    def to_intent(self) -> dict[str, Any]:
        """Convert to DSE intent format for pipeline evaluation."""
        variant_name = (
            f"{self.approx_method}_p{self.parallelism}"
            f"_q{self.quant_int_bits}_{self.quant_frac_bits}"
            f"_u{self.unroll_factor}_ii{self.pipeline_ii}"
        )
        return {
            "variant_name": variant_name,
            "rationale": "Pareto optimizer generated",
            "approx_method": self.approx_method,
            "scale_factor": self.approx_params.get("alpha", 1.0),
            "offset_beta": self.approx_params.get("beta", 0.0),
            "parallelism": self.parallelism,
            "quant_overrides": {
                "int_bits": self.quant_int_bits,
                "frac_bits": self.quant_frac_bits,
            },
            "enable_saturation": self.enable_saturation,
        }


@dataclass
class ObjectiveValues:
    """Evaluated objectives for a design point.

    Attributes:
        resource_cost: Weighted resource usage (DSP + BRAM + LUT).
        quality_loss: Quality degradation in dB (higher = worse).
        latency: Total latency in clock cycles.
        dsp: Raw DSP count.
        bram: Raw BRAM count.
        feasible: Whether this point passes all verification.
    """

    resource_cost: float = float("inf")
    quality_loss: float = float("inf")
    latency: float = float("inf")
    dsp: int = 0
    bram: int = 0
    feasible: bool = False

    def dominates(self, other: ObjectiveValues) -> bool:
        """Check if self Pareto-dominates other (all objectives <=, at least one <)."""
        if not self.feasible:
            return False
        if not other.feasible:
            return True
        objs_self = (self.resource_cost, self.quality_loss, self.latency)
        objs_other = (other.resource_cost, other.quality_loss, other.latency)
        all_leq = all(s <= o for s, o in zip(objs_self, objs_other))
        any_lt = any(s < o for s, o in zip(objs_self, objs_other))
        return all_leq and any_lt


@dataclass
class ParetoFront:
    """Collection of non-dominated design points.

    Attributes:
        points: List of (DesignPoint, ObjectiveValues) pairs.
        hypervolume: Hypervolume indicator (larger = better).
        generation: Which NSGA-II generation produced this front.
    """

    points: list[tuple[DesignPoint, ObjectiveValues]] = field(default_factory=list)
    hypervolume: float = 0.0
    generation: int = 0

    def add(self, point: DesignPoint, objectives: ObjectiveValues) -> bool:
        """Add a point if it's non-dominated. Remove any points it dominates.

        Returns:
            True if the point was added (non-dominated).
        """
        # Check if new point is dominated by any existing point
        for _, existing_obj in self.points:
            if existing_obj.dominates(objectives):
                return False

        # Remove points dominated by the new point
        self.points = [
            (p, o) for p, o in self.points
            if not objectives.dominates(o)
        ]

        self.points.append((point, objectives))
        return True

    def compute_hypervolume(
        self, reference: tuple[float, float, float] = (100.0, 10.0, 1000.0)
    ) -> float:
        """Compute hypervolume indicator relative to a reference point.

        Uses the 3D inclusion-exclusion approximation.
        """
        if not self.points:
            return 0.0

        feasible = [(p, o) for p, o in self.points if o.feasible]
        if not feasible:
            return 0.0

        # Simple 3D hypervolume via sorted contribution
        hv = 0.0
        for _, obj in feasible:
            vol = (
                max(0, reference[0] - obj.resource_cost)
                * max(0, reference[1] - obj.quality_loss)
                * max(0, reference[2] - obj.latency)
            )
            hv += vol

        self.hypervolume = hv
        return hv


# ---------------------------------------------------------------------------
# Design space configuration
# ---------------------------------------------------------------------------

@dataclass
class DesignSpace:
    """Configuration of the cross-layer design space.

    Attributes:
        approx_methods: Available approximation methods.
        parallelism_options: Allowed parallelism values.
        quant_int_range: (min, max) for integer bits.
        quant_frac_range: (min, max) for fractional bits.
        unroll_options: Allowed unroll factors.
        ii_options: Allowed pipeline II values.
        partition_options: Allowed array partition types.
    """

    approx_methods: list[str] = field(default_factory=lambda: [
        "spa_exact", "min_sum", "offset_min_sum", "normalized_min_sum", "lut_tanh"
    ])
    approx_param_ranges: dict[str, tuple[float, float]] = field(default_factory=lambda: {
        "alpha": (0.7, 0.85),
        "beta": (0.1, 0.5),
    })
    parallelism_options: list[int] = field(default_factory=lambda: [1, 2, 4, 8, 16])
    quant_int_range: tuple[int, int] = (3, 12)
    quant_frac_range: tuple[int, int] = (2, 16)
    unroll_options: list[int] = field(default_factory=lambda: [1, 2, 4, 8, 16])
    ii_options: list[int] = field(default_factory=lambda: [1, 2, 4, 8])
    partition_options: list[str] = field(default_factory=lambda: [
        "none", "cyclic", "complete"
    ])


# ---------------------------------------------------------------------------
# NSGA-II optimizer
# ---------------------------------------------------------------------------

class ParetoOptimizer:
    """NSGA-II multi-objective optimizer for cross-layer design space.

    Usage:
        optimizer = ParetoOptimizer(design_space, evaluator)
        front = optimizer.run(population_size=50, generations=20)
    """

    def __init__(
        self,
        design_space: DesignSpace | None = None,
        evaluator: Optional[Callable[[DesignPoint], ObjectiveValues]] = None,
        random_seed: int = 42,
    ) -> None:
        self._space = design_space or DesignSpace()
        self._evaluator = evaluator
        self._rng = random.Random(random_seed)
        self._np_rng = np.random.default_rng(random_seed)

    def run(
        self,
        population_size: int = 50,
        generations: int = 20,
    ) -> ParetoFront:
        """Run NSGA-II optimization.

        Args:
            population_size: Number of individuals per generation.
            generations: Number of evolutionary generations.

        Returns:
            Final Pareto front.
        """
        if self._evaluator is None:
            raise ValueError("Evaluator function must be set before running")

        # Initialize population
        population = [self._random_point() for _ in range(population_size)]
        evaluated = [(p, self._evaluator(p)) for p in population]

        best_front = ParetoFront()

        for gen in range(generations):
            # Non-dominated sorting
            fronts = self._fast_non_dominated_sort(evaluated)

            # Update best front
            for point, obj in fronts[0]:
                best_front.add(point, obj)

            # Generate offspring via crossover + mutation
            offspring = []
            while len(offspring) < population_size:
                # Tournament selection
                parent1 = self._tournament_select(evaluated)
                parent2 = self._tournament_select(evaluated)

                # Crossover
                child = self._crossover(parent1, parent2)

                # Mutation
                child = self._mutate(child)

                offspring.append(child)

            # Evaluate offspring
            offspring_evaluated = [(p, self._evaluator(p)) for p in offspring]

            # Combine parents + offspring, select next generation
            combined = evaluated + offspring_evaluated
            evaluated = self._select_next_generation(combined, population_size)

            # Log progress
            feasible_count = sum(1 for _, o in evaluated if o.feasible)
            best_front.generation = gen + 1
            logger.info(
                "Generation %d: %d feasible, front size=%d",
                gen + 1, feasible_count, len(best_front.points),
            )

        best_front.compute_hypervolume()
        return best_front

    def _random_point(self) -> DesignPoint:
        """Generate a random design point within the space."""
        approx = self._rng.choice(self._space.approx_methods)
        params = {}
        if approx == "normalized_min_sum":
            alpha_range = self._space.approx_param_ranges.get("alpha", (0.7, 0.85))
            params["alpha"] = self._rng.uniform(*alpha_range)
        elif approx == "offset_min_sum":
            beta_range = self._space.approx_param_ranges.get("beta", (0.1, 0.5))
            params["beta"] = self._rng.uniform(*beta_range)

        return DesignPoint(
            approx_method=approx,
            approx_params=params,
            parallelism=self._rng.choice(self._space.parallelism_options),
            quant_int_bits=self._rng.randint(*self._space.quant_int_range),
            quant_frac_bits=self._rng.randint(*self._space.quant_frac_range),
            enable_saturation=self._rng.random() > 0.3,
            unroll_factor=self._rng.choice(self._space.unroll_options),
            pipeline_ii=self._rng.choice(self._space.ii_options),
            array_partition=self._rng.choice(self._space.partition_options),
            use_dataflow=self._rng.random() > 0.7,
        )

    def _crossover(self, p1: DesignPoint, p2: DesignPoint) -> DesignPoint:
        """Uniform crossover between two parents."""
        return DesignPoint(
            approx_method=self._rng.choice([p1.approx_method, p2.approx_method]),
            approx_params=self._rng.choice([p1.approx_params, p2.approx_params]),
            parallelism=self._rng.choice([p1.parallelism, p2.parallelism]),
            quant_int_bits=self._rng.choice([p1.quant_int_bits, p2.quant_int_bits]),
            quant_frac_bits=self._rng.choice([p1.quant_frac_bits, p2.quant_frac_bits]),
            enable_saturation=self._rng.choice([p1.enable_saturation, p2.enable_saturation]),
            unroll_factor=self._rng.choice([p1.unroll_factor, p2.unroll_factor]),
            pipeline_ii=self._rng.choice([p1.pipeline_ii, p2.pipeline_ii]),
            array_partition=self._rng.choice([p1.array_partition, p2.array_partition]),
            use_dataflow=self._rng.choice([p1.use_dataflow, p2.use_dataflow]),
        )

    def _mutate(self, point: DesignPoint, mutation_rate: float = 0.2) -> DesignPoint:
        """Mutate a design point with given probability per field."""
        if self._rng.random() < mutation_rate:
            point.approx_method = self._rng.choice(self._space.approx_methods)
            # Update params for new method
            if point.approx_method == "normalized_min_sum":
                alpha_range = self._space.approx_param_ranges.get("alpha", (0.7, 0.85))
                point.approx_params = {"alpha": self._rng.uniform(*alpha_range)}
            elif point.approx_method == "offset_min_sum":
                beta_range = self._space.approx_param_ranges.get("beta", (0.1, 0.5))
                point.approx_params = {"beta": self._rng.uniform(*beta_range)}
            else:
                point.approx_params = {}

        if self._rng.random() < mutation_rate:
            point.parallelism = self._rng.choice(self._space.parallelism_options)

        if self._rng.random() < mutation_rate:
            point.quant_int_bits = self._rng.randint(*self._space.quant_int_range)

        if self._rng.random() < mutation_rate:
            point.quant_frac_bits = self._rng.randint(*self._space.quant_frac_range)

        if self._rng.random() < mutation_rate:
            point.unroll_factor = self._rng.choice(self._space.unroll_options)

        if self._rng.random() < mutation_rate:
            point.pipeline_ii = self._rng.choice(self._space.ii_options)

        if self._rng.random() < mutation_rate:
            point.array_partition = self._rng.choice(self._space.partition_options)

        return point

    def _tournament_select(
        self,
        population: list[tuple[DesignPoint, ObjectiveValues]],
        k: int = 3,
    ) -> DesignPoint:
        """Binary tournament selection based on dominance."""
        candidates = self._rng.sample(population, min(k, len(population)))
        best_point, best_obj = candidates[0]
        for point, obj in candidates[1:]:
            if obj.dominates(best_obj):
                best_point, best_obj = point, obj
            elif not best_obj.dominates(obj):
                # Non-dominated: pick randomly
                if self._rng.random() > 0.5:
                    best_point, best_obj = point, obj
        return best_point

    def _fast_non_dominated_sort(
        self,
        population: list[tuple[DesignPoint, ObjectiveValues]],
    ) -> list[list[tuple[DesignPoint, ObjectiveValues]]]:
        """NSGA-II fast non-dominated sorting."""
        n = len(population)
        domination_count = [0] * n
        dominated_set: list[list[int]] = [[] for _ in range(n)]
        fronts: list[list[int]] = [[]]

        for i in range(n):
            for j in range(i + 1, n):
                _, obj_i = population[i]
                _, obj_j = population[j]
                if obj_i.dominates(obj_j):
                    dominated_set[i].append(j)
                    domination_count[j] += 1
                elif obj_j.dominates(obj_i):
                    dominated_set[j].append(i)
                    domination_count[i] += 1

            if domination_count[i] == 0:
                fronts[0].append(i)

        i = 0
        while fronts[i]:
            next_front: list[int] = []
            for idx in fronts[i]:
                for dominated_idx in dominated_set[idx]:
                    domination_count[dominated_idx] -= 1
                    if domination_count[dominated_idx] == 0:
                        next_front.append(dominated_idx)
            i += 1
            fronts.append(next_front)

        # Convert indices to actual items
        return [
            [population[idx] for idx in front]
            for front in fronts
            if front
        ]

    def _select_next_generation(
        self,
        combined: list[tuple[DesignPoint, ObjectiveValues]],
        size: int,
    ) -> list[tuple[DesignPoint, ObjectiveValues]]:
        """Select next generation using non-dominated sorting + crowding distance."""
        fronts = self._fast_non_dominated_sort(combined)

        selected: list[tuple[DesignPoint, ObjectiveValues]] = []
        for front in fronts:
            if len(selected) + len(front) <= size:
                selected.extend(front)
            else:
                # Need to select from this front using crowding distance
                remaining = size - len(selected)
                if remaining > 0:
                    # Simplified: just take first N from this front
                    selected.extend(front[:remaining])
                break

        return selected
