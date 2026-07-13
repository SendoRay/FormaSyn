#!/usr/bin/env python3
"""Smoke test: run FormaFlow pipeline on a single kernel end-to-end."""

import logging
import sys
import time
from pathlib import Path

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("smoke_test")

# ── Setup ──────────────────────────────────────────────────────────────
from formaflow.backends.claude import ClaudeBackend
from formaflow.agents.parse_agent import LLMParseAgent
from formaflow.agents.transform_agent import LLMTransformAgent
from formaflow.agents.codegen_agent import LLMCodegenAgent
from formaflow.agents.verify_agent import ToolVerifyAgent
from formaflow.agents.rank_agent import MultiObjectiveRankAgent
from formaflow.pipeline import FormaFlowPipeline

# Use Claude as the LLM backend
llm = ClaudeBackend(model="claude-sonnet-4-20250514")
logger.info("LLM backend: %s", llm.model_id)

# Build pipeline
pipeline = FormaFlowPipeline(
    parse_agent=LLMParseAgent(llm),
    transform_agent=LLMTransformAgent(llm),
    codegen_agent=LLMCodegenAgent(llm),
    verify_agent=ToolVerifyAgent(llm, work_dir=Path("results/smoke_test")),
    rank_agent=MultiObjectiveRankAgent(),
    config={
        "kernel_id": "complex_mult_karatsuba",
        "llm_backend": llm.model_id,
        "rep_id": 0,
        "max_fix_iterations": 3,
    },
)

# ── Kernel definition ──────────────────────────────────────────────────
LATEX = r"(a+jb)(c+jd) = (ac-bd) + j(ad+bc)"
CONSTRAINTS = {
    "input_width": 16,
    "output_width": 32,
    "pipeline": True,
}

# ── Golden model (generate inline for smoke test) ──────────────────────
golden_dir = Path("results/smoke_test/golden")
golden_dir.mkdir(parents=True, exist_ok=True)
golden_csv = golden_dir / "complex_mult_golden.csv"

if not golden_csv.exists():
    import csv
    import random
    random.seed(42)
    logger.info("Generating golden model test vectors...")
    with open(golden_csv, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["a", "b", "c", "d", "expected_real", "expected_imag"])
        for _ in range(200):
            a = random.randint(-32768, 32767)
            b = random.randint(-32768, 32767)
            c = random.randint(-32768, 32767)
            d = random.randint(-32768, 32767)
            real = a * c - b * d
            imag = a * d + b * c
            writer.writerow([a, b, c, d, real, imag])
    logger.info("Golden model: %s (200 vectors)", golden_csv)

# ── Run pipeline ───────────────────────────────────────────────────────
logger.info("=" * 60)
logger.info("STARTING SMOKE TEST: complex_mult_karatsuba")
logger.info("=" * 60)

t0 = time.time()
result = pipeline.run(
    latex=LATEX,
    constraints=CONSTRAINTS,
    golden_model_path=golden_csv,
    max_iterations=2,
    kernel_id="complex_mult_karatsuba",
)
elapsed = time.time() - t0

# ── Report ─────────────────────────────────────────────────────────────
logger.info("=" * 60)
logger.info("SMOKE TEST RESULT")
logger.info("=" * 60)
logger.info("Kernel: %s", result.kernel_id)
logger.info("LLM: %s", result.llm_backend)
logger.info("Variants generated: %d", len(result.variants_generated))
logger.info("Best variant: %s", result.best_variant.variant_id if result.best_variant else "NONE")

if result.verify_result:
    logger.info("Verdict: %s", result.verify_result.verdict.value)
    logger.info("Iterations: %d", result.verify_result.iterations)
    if result.verify_result.synth_metrics:
        m = result.verify_result.synth_metrics
        logger.info("Synth: LUT=%d FF=%d DSP=%d BRAM=%d Fmax=%.1fMHz",
                     m.lut, m.ff, m.dsp, m.bram, m.fmax_mhz)
    if result.verify_result.compile_errors:
        logger.warning("Compile errors encountered: %d", len(result.verify_result.compile_errors))
else:
    logger.warning("No verify result — pipeline may have failed early")

logger.info("Wall time: %.1fs", elapsed)
logger.info("Metadata: %s", result.metadata)

# Save best Verilog if available
if result.best_variant:
    verilog_path = Path("results/smoke_test") / f"{result.best_variant.variant_id}.v"
    if verilog_path.exists():
        logger.info("Best Verilog saved: %s", verilog_path)

# Exit code based on result
if result.verify_result and result.verify_result.verdict.value == "pass":
    logger.info("✅ SMOKE TEST PASSED")
    sys.exit(0)
else:
    logger.warning("⚠️  SMOKE TEST: pipeline completed but did not reach PASS verdict")
    sys.exit(1)
