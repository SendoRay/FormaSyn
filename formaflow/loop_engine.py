"""Evolutionary LoopEngine — continuous Pareto search over LLM-generated RTL.

Correctness is a hard gate; PASS designs are optimised on a Pareto front (area now,
Fmax/latency once measured). The loop self-terminates on convergence (no front
improvement for `patience` generations) or an LLM-call budget backstop.

Phase 3 uses transform re-sampling as the mutation operator (no diagnostics yet);
Phase 4 will swap in parent-based, diagnostic-guided mutation.
"""

from __future__ import annotations

import dataclasses
import json
import logging
import math
import random
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

from .agents import LLMCodegenAgent, LLMParseAgent, LLMTransformAgent, ToolVerifyAgent
from .fitness import (
    Candidate,
    area_of,
    best_candidate,
    graded_score,
    improved,
    objective_vector,
    pareto_front,
    pareto_progress,
)
from .types import FVIR, VerifyResult, VerifyVerdict

logger = logging.getLogger(__name__)


class CountingBackend:
    """Wrap an LLMBackend and count completion calls (for the budget backstop)."""

    def __init__(self, inner) -> None:
        self._inner = inner
        self.calls = 0

    @property
    def model_id(self) -> str:
        return self._inner.model_id

    def complete(self, *args, **kwargs) -> str:
        self.calls += 1
        return self._inner.complete(*args, **kwargs)

    def complete_structured(self, *args, **kwargs) -> dict:
        self.calls += 1
        return self._inner.complete_structured(*args, **kwargs)


@dataclass
class EngineResult:
    kernel_id: str
    best: Optional[Candidate]
    archive: list[Candidate]
    generations: int
    llm_calls: int
    stop_reason: str  # converged | budget | max_generations
    history: list[dict] = field(default_factory=list)
    wall_time_s: float = 0.0


class LoopEngine:
    """Continuous evolutionary search driver."""

    def __init__(
        self,
        llm,
        work_dir: Path,
        *,
        budget_llm_calls: int = 150,
        patience: int = 5,
        offspring_per_gen: int = 4,
        seed_variants: int = 5,
        temperature: float = 1.0,
        max_fix_iterations: int = 3,
        max_generations: int = 100,
        seed: int = 42,
    ) -> None:
        self.llm = CountingBackend(llm)
        self.work_dir = Path(work_dir)
        self.work_dir.mkdir(parents=True, exist_ok=True)
        self.budget = budget_llm_calls
        self.patience = patience
        self.offspring_per_gen = offspring_per_gen
        self.seed_variants = seed_variants
        self.temperature = max(1e-3, temperature)
        self.max_fix_iterations = max_fix_iterations
        self.max_generations = max_generations
        self._rng = random.Random(seed)
        self._uid = 0
        self._kernel_id = "kernel"

        self.parse_agent = LLMParseAgent(self.llm)
        self.transform_agent = LLMTransformAgent(self.llm)
        self.codegen_agent = LLMCodegenAgent(self.llm)
        self.verify_agent = ToolVerifyAgent(self.llm, work_dir=self.work_dir)

    # ------------------------------------------------------------------
    def run(self, latex: str, constraints: dict, golden_model_path: Path,
            kernel_id: str) -> EngineResult:
        t0 = time.time()
        history: list[dict] = []
        self._kernel_id = kernel_id

        logger.info("[Engine] Parsing LaTeX -> FVIR")
        base_fvir = self.parse_agent.parse(latex, constraints)

        # --- Seed generation ---
        logger.info("[Engine] Seeding population (%d variants)", self.seed_variants)
        population: list[Candidate] = []
        for variant in self._fresh_variants(base_fvir, self.seed_variants, gen=0):
            population.append(self._evaluate(variant, golden_model_path, origin="seed", gen=0))

        progress = pareto_progress(population)
        stagnation = 0
        gen = 0
        stop_reason = "budget"
        history.append(self._gen_record(gen, population, progress, stagnation))
        self._persist(kernel_id, population, history)

        # --- Evolution loop ---
        while True:
            if self.llm.calls >= self.budget:
                stop_reason = "budget"
                break
            if stagnation >= self.patience:
                stop_reason = "converged"
                break
            if gen >= self.max_generations:
                stop_reason = "max_generations"
                break

            gen += 1
            offspring = self._mutate(population, base_fvir, gen, golden_model_path)
            population.extend(offspring)

            new_progress = pareto_progress(population)
            if improved(new_progress, progress):
                stagnation = 0
            else:
                stagnation += 1
            progress = new_progress

            rec = self._gen_record(gen, population, progress, stagnation)
            history.append(rec)
            self._persist(kernel_id, population, history)
            logger.info(
                "[Engine] gen %d: pop=%d pass=%d best_area=%s calls=%d/%d stagnation=%d",
                gen, len(population), rec["num_pass"], rec["best_area"],
                self.llm.calls, self.budget, stagnation,
            )

        archive = pareto_front(population)
        best = best_candidate(population)
        wall = time.time() - t0
        logger.info("[Engine] stop=%s gen=%d calls=%d archive=%d best_area=%s (%.1fs)",
                    stop_reason, gen, self.llm.calls, len(archive),
                    area_of(best) if best else None, wall)

        result = EngineResult(
            kernel_id=kernel_id, best=best, archive=archive, generations=gen,
            llm_calls=self.llm.calls, stop_reason=stop_reason, history=history,
            wall_time_s=wall,
        )
        self._persist(kernel_id, population, history, result=result)
        return result

    # ------------------------------------------------------------------
    # Mutation: diagnostic-guided refinement of sampled parents
    # ------------------------------------------------------------------
    def _mutate(self, population: list[Candidate], base_fvir: FVIR, gen: int,
                golden: Path) -> list[Candidate]:
        """Diagnostic-guided mutation of sampled parents.

        PASS parents are refined toward lower area; failing parents are repaired using
        their diagnostics. Parents without usable code fall back to a fresh transform
        variant so the structural space keeps being explored.
        """
        offspring: list[Candidate] = []
        parents = self._sample_parents(population, self.offspring_per_gen)
        for parent in parents:
            if self.llm.calls >= self.budget:
                break
            if parent.code is None or not parent.code.verilog:
                fresh = self._fresh_variants(base_fvir, 1, gen)
                if fresh:
                    offspring.append(self._evaluate(fresh[0], golden, origin="transform", gen=gen))
                continue
            goal, feedback = self._diagnostics(parent)
            child = dataclasses.replace(parent.variant, variant_id=self._new_id("r"))
            try:
                code = self.codegen_agent.refine(child, parent.code.verilog, feedback, goal)
            except Exception as exc:
                logger.warning("[Engine] refine failed for %s: %s", child.variant_id, exc)
                continue
            offspring.append(self._evaluate(child, golden, origin="refine", gen=gen, code=code))
        return offspring

    def _fresh_variants(self, base_fvir: FVIR, n: int, gen: int):
        """Sample n structural variants from the transform agent, with unique IDs."""
        try:
            variants = self.transform_agent.transform(base_fvir, max_variants=n)
        except Exception as exc:  # transform can fail on a bad LLM response
            logger.warning("[Engine] transform failed (gen %d): %s", gen, exc)
            return []
        return [dataclasses.replace(v, variant_id=self._new_id("t")) for v in variants]

    def _new_id(self, tag: str) -> str:
        self._uid += 1
        return f"{self._kernel_id}_{tag}{self._uid}"

    def _diagnostics(self, parent: Candidate) -> tuple[str, str]:
        """Build a (goal, feedback) pair for refining a parent from its verdict."""
        vr = parent.verify
        if parent.is_pass and vr and vr.synth_metrics:
            m = vr.synth_metrics
            area = int(m.lut + m.ff)
            goal = f"Reduce FPGA area below {area} (LUT+FF) with identical functionality."
            fb = (f"The design PASSES. Current synthesis: LUT={m.lut}, FF={m.ff}. "
                  "Lower resource usage by sharing/reusing multipliers and adders, removing "
                  "redundant pipeline registers, and simplifying arithmetic — WITHOUT changing "
                  "the computed results or the I/O interface.")
            return goal, fb
        if vr and vr.verdict == VerifyVerdict.SIM_FAIL:
            err = str((vr.sim_report or {}).get("error", ""))[:400]
            goal = "Fix functional mismatches so simulation matches the reference exactly."
            fb = (f"Simulation FAILED: {err}\n"
                  "The testbench applies one input vector per clock and, if the module has a "
                  "`valid_in` input, records an output only while `valid_out` is high (else it "
                  "assumes a small fixed latency). Ensure (a) signed fixed-point arithmetic is "
                  "correct, and (b) if pipelined, propagate a `valid` flag so outputs align 1:1 "
                  "with inputs at a small constant latency.")
            return goal, fb
        if vr and vr.verdict == VerifyVerdict.COMPILE_FAIL:
            errs = "\n".join(vr.compile_errors[-1:]) if vr.compile_errors else (vr.error_log or "")
            return ("Fix all compile/lint errors so Verilator builds the design.",
                    f"Compile/lint errors:\n{errs[:600]}")
        errlog = vr.error_log[:400] if vr and vr.error_log else "Regenerate a clean synthesizable design."
        return ("Fix the design so it passes compile, simulation, and synthesis.", errlog)

    def _sample_parents(self, population: list[Candidate], k: int) -> list[Candidate]:
        """Temperature-weighted softmax over graded_score (FunSearch-style)."""
        pool = [c for c in population if c.verify is not None]
        if not pool:
            return []
        scores = [graded_score(c) for c in pool]
        hi = max(scores)
        weights = [math.exp((s - hi) / self.temperature) for s in scores]
        return self._rng.choices(pool, weights=weights, k=k)

    # ------------------------------------------------------------------
    def _evaluate(self, variant, golden: Path, origin: str, gen: int, code=None) -> Candidate:
        cand = Candidate(variant=variant, origin=origin, gen=gen)
        if code is None:
            try:
                code = self.codegen_agent.generate(variant)
            except Exception as exc:
                logger.warning("[Engine] codegen failed for %s: %s", variant.variant_id, exc)
                return cand
        cand.code = code
        if not code.verilog:
            cand.verify = VerifyResult(verdict=VerifyVerdict.COMPILE_FAIL, iterations=0,
                                       error_log="empty verilog from codegen")
            return cand
        try:
            cand.verify = self.verify_agent.verify(
                code, golden, max_fix_iterations=self.max_fix_iterations
            )
        except Exception as exc:
            logger.warning("[Engine] verify crashed for %s: %s", variant.variant_id, exc)
            cand.verify = VerifyResult(verdict=VerifyVerdict.COMPILE_FAIL, iterations=0,
                                       error_log=str(exc))
        return cand

    # ------------------------------------------------------------------
    def _gen_record(self, gen: int, population: list[Candidate], progress: float,
                    stagnation: int) -> dict:
        passes = [c for c in population if c.is_pass]
        best = best_candidate(population)
        return {
            "gen": gen,
            "pop_size": len(population),
            "num_pass": len(passes),
            "best_area": area_of(best) if best else None,
            "progress": progress,
            "stagnation": stagnation,
            "llm_calls": self.llm.calls,
        }

    def _cand_summary(self, c: Candidate) -> dict:
        ov = objective_vector(c)
        return {
            "variant_id": c.variant.variant_id if c.variant else None,
            "origin": c.origin,
            "gen": c.gen,
            "verdict": c.verdict.value if c.verdict else None,
            "area": ov[0] if ov else None,
            "fmax_mhz": (-ov[1]) if ov else None,
            "graded": graded_score(c),
        }

    def _persist(self, kernel_id: str, population: list[Candidate], history: list[dict],
                 result: Optional[EngineResult] = None) -> None:
        payload = {
            "kernel_id": kernel_id,
            "llm_calls": self.llm.calls,
            "budget": self.budget,
            "history": history,
            "population": [self._cand_summary(c) for c in population],
            "archive": [self._cand_summary(c) for c in pareto_front(population)],
        }
        if result is not None:
            payload["stop_reason"] = result.stop_reason
            payload["generations"] = result.generations
            payload["wall_time_s"] = result.wall_time_s
            payload["best"] = self._cand_summary(result.best) if result.best else None
        (self.work_dir / "engine_run.json").write_text(json.dumps(payload, indent=2))
