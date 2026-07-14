#!/usr/bin/env python3
"""Drive the evolutionary LoopEngine on a single kernel.

Usage:
    python run_engine.py --kernel complex_mult --backend deepseek --budget 150
"""

import argparse
import logging
import sys
from pathlib import Path

from formaflow.backends import make_backend
from formaflow.env import load_dotenv
from formaflow.fitness import area_of, objective_vector
from formaflow.kernels import KERNELS, generate_golden, get_kernel
from formaflow.loop_engine import LoopEngine

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("formaflow.engine.cli")


def main() -> int:
    ap = argparse.ArgumentParser(description="FormaFlow evolutionary LoopEngine runner")
    ap.add_argument("--kernel", default="complex_mult", help="Kernel ID (see formaflow.kernels.KERNELS)")
    ap.add_argument("--backend", default="deepseek",
                    choices=["claude_code", "deepseek", "openai", "claude"])
    ap.add_argument("--model", default=None)
    ap.add_argument("--budget", type=int, default=150, help="Max total LLM calls (backstop)")
    ap.add_argument("--patience", type=int, default=5,
                    help="Stop after N generations without Pareto-front improvement")
    ap.add_argument("--offspring", type=int, default=4, help="Offspring per generation")
    ap.add_argument("--seed-variants", type=int, default=5)
    ap.add_argument("--max-generations", type=int, default=100)
    ap.add_argument("--results-dir", type=Path, default=Path("results/engine_run"))
    args = ap.parse_args()

    load_dotenv()
    kernel = get_kernel(args.kernel)
    if kernel is None:
        logger.error("Kernel '%s' not found. Available: %s", args.kernel, [k["id"] for k in KERNELS])
        return 1

    golden = generate_golden(kernel, args.results_dir / "golden")
    llm = make_backend(args.backend, args.model)
    logger.info("Engine on %s | backend=%s model=%s | budget=%d patience=%d",
                args.kernel, args.backend, args.model or "default", args.budget, args.patience)

    engine = LoopEngine(
        llm,
        work_dir=args.results_dir / args.kernel,
        budget_llm_calls=args.budget,
        patience=args.patience,
        offspring_per_gen=args.offspring,
        seed_variants=args.seed_variants,
        max_generations=args.max_generations,
    )
    res = engine.run(kernel["latex"], kernel["constraints"], golden, kernel_id=args.kernel)

    logger.info("=" * 60)
    logger.info("ENGINE DONE: stop=%s generations=%d llm_calls=%d",
                res.stop_reason, res.generations, res.llm_calls)
    logger.info("Pareto archive (%d):", len(res.archive))
    for c in sorted(res.archive, key=lambda c: objective_vector(c) or (0, 0)):
        logger.info("  %s  area=%s  fmax=%.1f", c.variant.variant_id,
                    area_of(c), -(objective_vector(c)[1]))
    if res.best:
        logger.info("BEST: %s  area=%s  verdict=%s", res.best.variant.variant_id,
                    area_of(res.best), res.best.verdict.value if res.best.verdict else None)
    else:
        logger.warning("No best candidate (nothing evaluated?).")
    logger.info("Artifacts: %s/engine_run.json", args.results_dir / args.kernel)
    return 0 if res.best and res.best.is_pass else 1


if __name__ == "__main__":
    sys.exit(main())
