#!/usr/bin/env python3
"""FormaFlow self-loop runner — drives the full pipeline using claude CLI as LLM backend.

Usage:
    python run_loop.py                    # Run all kernels sequentially
    python run_loop.py --kernel fir_sym   # Run a single kernel
    python run_loop.py --max-kernels 5    # Run first 5 kernels
"""

import argparse
import json
import logging
import sys
import time
from pathlib import Path

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler("results/formaflow_loop.log"),
    ],
)
logger = logging.getLogger("formaflow.loop")

# ── Kernel definitions (extracted from benchmark) ──────────────────────
KERNELS = [
    {
        "id": "complex_mult",
        "name": "16-bit Complex Multiplier (Karatsuba)",
        "latex": r"(a+jb)(c+jd) = (ac-bd) + j(ad+bc)",
        "constraints": {"input_width": 16, "output_width": 32},
        "category": "cat01_basic_math",
    },
    {
        "id": "cordic_rotate",
        "name": "CORDIC Rotation Mode (12 iterations, 16-bit)",
        "latex": r"x[i+1]=x[i]-\sigma_i y[i] 2^{-i},\ y[i+1]=y[i]+\sigma_i x[i] 2^{-i},\ z[i+1]=z[i]-\sigma_i \arctan(2^{-i})",
        "constraints": {"iterations": 12, "data_width": 16},
        "category": "cat01_basic_math",
    },
    {
        "id": "fir_symmetric",
        "name": "Symmetric FIR Filter (16 taps, 16-bit)",
        "latex": r"y[n] = \sum_{k=0}^{N-1} h[k] \cdot x[n-k],\ h[k]=h[N-1-k]",
        "constraints": {"taps": 16, "data_width": 16, "coeff_width": 16},
        "category": "cat02_filters",
    },
    {
        "id": "crc24",
        "name": "CRC-24 (polynomial 0x864CFB)",
        "latex": r"G(x) = x^{24}+x^{23}+x^{18}+x^{17}+x^{14}+x^{11}+x^{10}+x^{7}+x^{6}+x^{5}+x^{4}+x^{3}+x+1,\; \text{poly}=\texttt{0x864CFB}",
        "constraints": {"data_width": 8, "crc_width": 24, "polynomial": "0x864CFB", "init": "0xB704CE"},
        "category": "cat01_basic_math",
    },
    {
        "id": "nco",
        "name": "Numerically Controlled Oscillator",
        "latex": r"\theta[n+1] = (\theta[n] + \Delta\theta) \mod 2\pi,\ \text{output} = \sin(\theta[n])",
        "constraints": {"phase_width": 32, "output_width": 16},
        "category": "cat06_sync_estimation",
    },
]


def generate_golden_model(kernel: dict, golden_dir: Path) -> Path:
    """Generate golden model test vectors for a kernel."""
    import csv
    import random

    golden_path = golden_dir / f"{kernel['id']}_golden.csv"
    if golden_path.exists():
        return golden_path

    golden_dir.mkdir(parents=True, exist_ok=True)
    random.seed(42)

    kid = kernel["id"]
    width = kernel["constraints"].get("data_width", kernel["constraints"].get("input_width", 16))
    max_val = 2 ** (width - 1) - 1
    min_val = -(2 ** (width - 1))

    with open(golden_path, "w", newline="") as f:
        if kid == "complex_mult":
            writer = csv.writer(f)
            writer.writerow(["a", "b", "c", "d", "expected_real", "expected_imag"])
            for _ in range(200):
                a, b = random.randint(min_val, max_val), random.randint(min_val, max_val)
                c, d = random.randint(min_val, max_val), random.randint(min_val, max_val)
                writer.writerow([a, b, c, d, a * c - b * d, a * d + b * c])
        elif kid == "crc24":
            # CRC-24 (RFC 4880/OpenPGP): poly=0x864CFB, init=0xB704CE
            # Byte-at-a-time, MSB-first, cumulative CRC state
            POLY = 0x1864CFB  # full 25-bit poly with x^24 term
            CRC_INIT = 0xB704CE
            writer = csv.writer(f)
            writer.writerow(["data", "expected_crc"])
            crc = CRC_INIT
            for _ in range(200):
                byte = random.randint(0, 255)
                crc ^= byte << 16
                for _bit in range(8):
                    crc <<= 1
                    if crc & 0x1000000:
                        crc ^= POLY
                crc &= 0xFFFFFF
                writer.writerow([byte, crc])
        else:
            writer = csv.writer(f)
            writer.writerow(["input", "expected_output"])
            for _ in range(200):
                x = random.randint(min_val, max_val)
                writer.writerow([x, x])  # placeholder

    logger.info("Golden model generated: %s", golden_path)
    return golden_path


def run_single_kernel(kernel: dict, results_dir: Path) -> dict:
    """Run a single kernel through the full FormaFlow pipeline."""
    from formaflow.backends.claude_code import ClaudeCodeBackend
    from formaflow.agents.parse_agent import LLMParseAgent
    from formaflow.agents.transform_agent import LLMTransformAgent
    from formaflow.agents.codegen_agent import LLMCodegenAgent
    from formaflow.agents.verify_agent import ToolVerifyAgent
    from formaflow.agents.rank_agent import MultiObjectiveRankAgent
    from formaflow.pipeline import FormaFlowPipeline

    kid = kernel["id"]
    logger.info("=" * 70)
    logger.info("KERNEL: %s — %s", kid, kernel["name"])
    logger.info("=" * 70)

    # Setup
    llm = ClaudeCodeBackend()
    work_dir = results_dir / kid
    work_dir.mkdir(parents=True, exist_ok=True)

    pipeline = FormaFlowPipeline(
        parse_agent=LLMParseAgent(llm),
        transform_agent=LLMTransformAgent(llm),
        codegen_agent=LLMCodegenAgent(llm),
        verify_agent=ToolVerifyAgent(llm, work_dir=work_dir),
        rank_agent=MultiObjectiveRankAgent(),
        config={
            "kernel_id": kid,
            "llm_backend": llm.model_id,
            "rep_id": 0,
            "max_fix_iterations": 3,
        },
    )

    golden_dir = results_dir / "golden"
    golden_path = generate_golden_model(kernel, golden_dir)

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
            summary["synth"] = {
                "lut": m.lut, "ff": m.ff, "dsp": m.dsp,
                "bram": m.bram, "fmax_mhz": m.fmax_mhz,
            }

        logger.info("RESULT: %s → %s (%.1fs)", kid, summary["verdict"], elapsed)
        return summary

    except Exception as e:
        elapsed = time.time() - t0
        logger.error("KERNEL %s FAILED: %s (%.1fs)", kid, e, elapsed)
        return {
            "kernel_id": kid,
            "verdict": "error",
            "error": str(e),
            "wall_time_s": round(elapsed, 1),
        }


def main():
    parser = argparse.ArgumentParser(description="FormaFlow self-loop runner")
    parser.add_argument("--kernel", type=str, help="Run only this kernel ID")
    parser.add_argument("--max-kernels", type=int, default=0, help="Max kernels to run (0=all)")
    parser.add_argument("--results-dir", type=Path, default=Path("results/loop_run"))
    args = parser.parse_args()

    args.results_dir.mkdir(parents=True, exist_ok=True)

    kernels = KERNELS
    if args.kernel:
        kernels = [k for k in kernels if k["id"] == args.kernel]
        if not kernels:
            logger.error("Kernel '%s' not found", args.kernel)
            sys.exit(1)
    if args.max_kernels > 0:
        kernels = kernels[: args.max_kernels]

    logger.info("FormaFlow self-loop starting: %d kernels", len(kernels))

    all_results = []
    for i, kernel in enumerate(kernels, 1):
        logger.info("\n[%d/%d] Processing %s...", i, len(kernels), kernel["id"])
        result = run_single_kernel(kernel, args.results_dir)
        all_results.append(result)

        # Save progress after each kernel
        progress_path = args.results_dir / "progress.json"
        progress_path.write_text(json.dumps(all_results, indent=2))

    # Final summary
    logger.info("\n" + "=" * 70)
    logger.info("FINAL SUMMARY")
    logger.info("=" * 70)
    for r in all_results:
        verdict = r.get("verdict", "?")
        icon = "✓" if verdict == "pass" else "✗"
        logger.info("  %s %s → %s (%.1fs)", icon, r["kernel_id"], verdict, r["wall_time_s"])

    passed = sum(1 for r in all_results if r.get("verdict") == "pass")
    logger.info("Pass rate: %d/%d (%.0f%%)", passed, len(all_results),
                100 * passed / len(all_results) if all_results else 0)


if __name__ == "__main__":
    main()
