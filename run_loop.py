#!/usr/bin/env python3
"""Fixed-pipeline runner: parse -> transform -> codegen -> verify -> rank over kernels.

Usage:
    python run_loop.py --kernel complex_mult --backend deepseek
    python run_loop.py --max-kernels 5
"""

import argparse
import json
import logging
import sys
import time
from pathlib import Path

from formaflow.agents import (
    LLMCodegenAgent,
    LLMParseAgent,
    LLMTransformAgent,
    MultiObjectiveRankAgent,
    ToolVerifyAgent,
)
from formaflow.backends import make_backend
from formaflow.env import load_dotenv
from formaflow.kernels import KERNELS, generate_golden
from formaflow.pipeline import FormaFlowPipeline

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler("results/formaflow_loop.log"),
    ],
)
logger = logging.getLogger("formaflow.loop")


def run_single_kernel(kernel: dict, results_dir: Path, backend: str = "claude_code",
                      model: str | None = None) -> dict:
    """Run a single kernel through the fixed FormaFlow pipeline."""
    kid = kernel["id"]
    logger.info("=" * 70)
    logger.info("KERNEL: %s — %s", kid, kernel["name"])
    logger.info("=" * 70)

    llm = make_backend(backend, model)
    work_dir = results_dir / kid
    work_dir.mkdir(parents=True, exist_ok=True)

    pipeline = FormaFlowPipeline(
        parse_agent=LLMParseAgent(llm),
        transform_agent=LLMTransformAgent(llm),
        codegen_agent=LLMCodegenAgent(llm),
        verify_agent=ToolVerifyAgent(llm, work_dir=work_dir),
        rank_agent=MultiObjectiveRankAgent(),
        config={"kernel_id": kid, "llm_backend": llm.model_id, "rep_id": 0,
                "max_fix_iterations": 3},
    )

    golden_path = generate_golden(kernel, results_dir / "golden")

    t0 = time.time()
    try:
        result = pipeline.run(
            latex=kernel["latex"],
            constraints=kernel["constraints"],
            golden_model_path=golden_path,
            max_iterations=2,
            kernel_id=kid,
        )
        elapsed = time.time() - t0
        summary = {
            "kernel_id": kid,
            "verdict": result.verify_result.verdict.value if result.verify_result else "no_result",
            "variants_generated": len(result.variants_generated),
            "best_variant": result.best_variant.variant_id if result.best_variant else None,
            "iterations": result.verify_result.iterations if result.verify_result else 0,
            "wall_time_s": round(elapsed, 1),
            "synth": None,
        }
        if result.verify_result and result.verify_result.synth_metrics:
            m = result.verify_result.synth_metrics
            summary["synth"] = {"lut": m.lut, "ff": m.ff, "dsp": m.dsp,
                                "bram": m.bram, "fmax_mhz": m.fmax_mhz}
        logger.info("RESULT: %s → %s (%.1fs)", kid, summary["verdict"], elapsed)
        return summary
    except Exception as e:
        elapsed = time.time() - t0
        logger.error("KERNEL %s FAILED: %s (%.1fs)", kid, e, elapsed)
        return {"kernel_id": kid, "verdict": "error", "error": str(e),
                "wall_time_s": round(elapsed, 1)}


def main():
    parser = argparse.ArgumentParser(description="FormaFlow fixed-pipeline runner")
    parser.add_argument("--kernel", type=str, help="Run only this kernel ID")
    parser.add_argument("--max-kernels", type=int, default=0, help="Max kernels to run (0=all)")
    parser.add_argument("--results-dir", type=Path, default=Path("results/loop_run"))
    parser.add_argument("--backend", type=str, default="claude_code",
                        choices=["claude_code", "deepseek", "openai", "claude"])
    parser.add_argument("--model", type=str, default=None)
    args = parser.parse_args()

    load_dotenv()
    args.results_dir.mkdir(parents=True, exist_ok=True)
    logger.info("Backend: %s (model=%s)", args.backend, args.model or "default")

    kernels = KERNELS
    if args.kernel:
        kernels = [k for k in kernels if k["id"] == args.kernel]
        if not kernels:
            logger.error("Kernel '%s' not found", args.kernel)
            sys.exit(1)
    if args.max_kernels > 0:
        kernels = kernels[: args.max_kernels]

    logger.info("FormaFlow fixed-pipeline starting: %d kernels", len(kernels))
    all_results = []
    for i, kernel in enumerate(kernels, 1):
        logger.info("\n[%d/%d] Processing %s...", i, len(kernels), kernel["id"])
        all_results.append(
            run_single_kernel(kernel, args.results_dir, backend=args.backend, model=args.model)
        )
        (args.results_dir / "progress.json").write_text(json.dumps(all_results, indent=2))

    logger.info("\n" + "=" * 70)
    logger.info("FINAL SUMMARY")
    logger.info("=" * 70)
    for r in all_results:
        icon = "✓" if r.get("verdict") == "pass" else "✗"
        logger.info("  %s %s → %s (%.1fs)", icon, r["kernel_id"], r.get("verdict", "?"),
                    r["wall_time_s"])
    passed = sum(1 for r in all_results if r.get("verdict") == "pass")
    logger.info("Pass rate: %d/%d (%.0f%%)", passed, len(all_results),
                100 * passed / len(all_results) if all_results else 0)


if __name__ == "__main__":
    main()
