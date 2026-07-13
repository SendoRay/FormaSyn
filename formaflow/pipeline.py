"""FormaFlow end-to-end pipeline orchestrator."""

from __future__ import annotations

import logging
import time
import uuid
from pathlib import Path
from typing import Any

from formaflow.protocols import (
    CodegenAgent,
    ParseAgent,
    RankAgent,
    TransformAgent,
    VerifyAgent,
)
from formaflow.types import (
    FVIR,
    GeneratedCode,
    KernelResult,
    Variant,
    VerifyResult,
    VerifyVerdict,
)

logger = logging.getLogger(__name__)


class FormaFlowPipeline:
    """Orchestrates the full parse-transform-codegen-verify-rank pipeline.

    Supports ablation via ``ablation_config``:
      - skip_transform: use naive variant only (bypass TransformAgent)
      - skip_verify_loop: single-pass verification (max_fix_iterations=1)
      - direct_prompt: skip FVIR parsing, generate code directly from LaTeX

    Args:
        parse_agent: Stage 1 agent (LaTeX -> FVIR).
        transform_agent: Stage 2 agent (FVIR -> variants).
        codegen_agent: Stage 3 agent (variant -> Verilog).
        verify_agent: Stage 4 agent (Verilog -> verification).
        rank_agent: Stage 5 agent (rank passing variants).
        config: General pipeline configuration dict.
    """

    def __init__(
        self,
        parse_agent: ParseAgent,
        transform_agent: TransformAgent,
        codegen_agent: CodegenAgent,
        verify_agent: VerifyAgent,
        rank_agent: RankAgent,
        config: dict[str, Any] | None = None,
    ) -> None:
        self.parse_agent = parse_agent
        self.transform_agent = transform_agent
        self.codegen_agent = codegen_agent
        self.verify_agent = verify_agent
        self.rank_agent = rank_agent
        self.config = config or {}
        self.ablation_config: dict[str, bool] = self.config.get("ablation", {})

    def run(
        self,
        latex: str,
        constraints: dict,
        golden_model_path: Path,
        max_iterations: int = 3,
        kernel_id: str | None = None,
    ) -> KernelResult:
        """Execute the full FormaFlow pipeline.

        Args:
            latex: Input LaTeX formula string.
            constraints: Resource/timing constraints dict.
            golden_model_path: Path to the golden reference model.
            max_iterations: Maximum transform-verify iterations before giving up.
            kernel_id: Optional kernel identifier; auto-generated if not provided.

        Returns:
            KernelResult summarizing the pipeline run.
        """
        start_time = time.time()
        kernel_id = kernel_id or self.config.get("kernel_id", f"kernel_{uuid.uuid4().hex[:8]}")
        llm_backend = self.config.get("llm_backend", "unknown")
        rep_id = self.config.get("rep_id", 0)

        all_variants: list[Variant] = []
        all_results: list[tuple[Variant, VerifyResult]] = []
        best_variant: Variant | None = None
        best_verify: VerifyResult | None = None
        base_fvir: FVIR | None = None
        iteration: int = 0

        skip_transform = self.ablation_config.get("skip_transform", False)
        skip_verify_loop = self.ablation_config.get("skip_verify_loop", False)
        direct_prompt = self.ablation_config.get("direct_prompt", False)

        max_fix_iters = 1 if skip_verify_loop else self.config.get("max_fix_iterations", 5)

        for iteration in range(1, max_iterations + 1):
            logger.info(
                "=== Pipeline iteration %d/%d ===", iteration, max_iterations
            )

            # --- Stage 1: Parse ---
            if not direct_prompt:
                if base_fvir is None:
                    logger.info("[Stage 1] Parsing LaTeX -> FVIR")
                    try:
                        base_fvir = self.parse_agent.parse(latex, constraints)
                        logger.info(
                            "[Stage 1] Complete: kernel_id=%s, ops=%d",
                            base_fvir.kernel_id,
                            len(base_fvir.ops),
                        )
                    except Exception as exc:
                        logger.error("[Stage 1] Parse failed: %s", exc)
                        break
            else:
                logger.info("[Stage 1] Skipped (direct_prompt ablation)")

            # --- Stage 2: Transform ---
            variants: list[Variant] = []
            if not direct_prompt and not skip_transform:
                logger.info("[Stage 2] Transforming FVIR -> variants")
                try:
                    variants = self.transform_agent.transform(base_fvir)
                    logger.info(
                        "[Stage 2] Complete: %d variants generated", len(variants)
                    )
                except Exception as exc:
                    logger.error("[Stage 2] Transform failed: %s", exc)
                    break
            elif skip_transform and base_fvir is not None:
                logger.info("[Stage 2] Skipped (skip_transform ablation); using naive variant")
                from formaflow.types import TransformType

                naive_variant = Variant(
                    variant_id=f"{base_fvir.kernel_id}_naive_{iteration}",
                    fvir=base_fvir,
                    transform_applied="identity",
                    transform_type=TransformType.NAIVE,
                    rationale="No transformation applied (ablation mode).",
                )
                variants = [naive_variant]
            elif direct_prompt:
                logger.info("[Stage 2] Skipped (direct_prompt ablation)")
                # For direct_prompt, we create a placeholder variant
                from formaflow.types import TransformType

                placeholder_fvir = FVIR(
                    kernel_id=kernel_id,
                    ops=(),
                    constraints=constraints,
                    source_latex=latex,
                    metadata={"direct_prompt": True},
                )
                variants = [
                    Variant(
                        variant_id=f"{kernel_id}_direct_{iteration}",
                        fvir=placeholder_fvir,
                        transform_applied="direct_from_latex",
                        transform_type=TransformType.NAIVE,
                        rationale="Direct code generation from LaTeX (ablation mode).",
                    )
                ]

            all_variants.extend(variants)

            # --- Stage 3 & 4: Codegen + Verify per variant ---
            iteration_results: list[tuple[Variant, VerifyResult]] = []
            for variant in variants:
                # Stage 3: Codegen
                logger.info(
                    "[Stage 3] Generating code for variant %s", variant.variant_id
                )
                try:
                    code: GeneratedCode = self.codegen_agent.generate(variant)
                    logger.info(
                        "[Stage 3] Complete: variant %s", variant.variant_id
                    )
                except Exception as exc:
                    logger.error(
                        "[Stage 3] Codegen failed for variant %s: %s",
                        variant.variant_id,
                        exc,
                    )
                    continue

                # Stage 4: Verify
                logger.info(
                    "[Stage 4] Verifying variant %s", variant.variant_id
                )
                try:
                    verify_result: VerifyResult = self.verify_agent.verify(
                        code, golden_model_path, max_fix_iterations=max_fix_iters
                    )
                    logger.info(
                        "[Stage 4] Complete: variant %s -> %s",
                        variant.variant_id,
                        verify_result.verdict.value,
                    )
                except Exception as exc:
                    logger.error(
                        "[Stage 4] Verify failed for variant %s: %s",
                        variant.variant_id,
                        exc,
                    )
                    continue

                iteration_results.append((variant, verify_result))

            all_results.extend(iteration_results)

            # --- Stage 5: Rank ---
            logger.info("[Stage 5] Ranking passing variants")
            ranked = self.rank_agent.rank(iteration_results)
            logger.info("[Stage 5] Complete: %d passing variants ranked", len(ranked))

            if ranked:
                best_variant = ranked[0]
                # Find corresponding VerifyResult for best variant
                for v, vr in iteration_results:
                    if v.variant_id == best_variant.variant_id:
                        best_verify = vr
                        break
                logger.info(
                    "Best variant found: %s (iteration %d)",
                    best_variant.variant_id,
                    iteration,
                )
                break  # Success -- no need for more iterations

            # No passing variant; retry with best-so-far as base if possible
            if iteration < max_iterations:
                logger.info(
                    "No passing variants in iteration %d; retrying.", iteration
                )
                # Use the FVIR from the least-bad variant for next iteration
                if iteration_results and not direct_prompt:
                    # Prefer compile_fail < sim_fail < synth_fail ordering
                    priority = {
                        VerifyVerdict.SYNTH_FAIL: 3,
                        VerifyVerdict.SIM_FAIL: 2,
                        VerifyVerdict.COMPILE_FAIL: 1,
                        VerifyVerdict.PASS: 4,
                    }
                    iteration_results.sort(
                        key=lambda x: priority.get(x[1].verdict, 0), reverse=True
                    )
                    base_fvir = iteration_results[0][0].fvir

        wall_time = time.time() - start_time
        logger.info("Pipeline complete in %.2fs", wall_time)

        return KernelResult(
            kernel_id=kernel_id,
            llm_backend=llm_backend,
            rep_id=rep_id,
            variants_generated=all_variants,
            best_variant=best_variant,
            verify_result=best_verify,
            wall_time_seconds=wall_time,
            metadata={
                "iterations_used": iteration if all_variants else 0,
                "total_variants_tried": len(all_results),
                "passing_count": sum(
                    1 for _, vr in all_results if vr.verdict == VerifyVerdict.PASS
                ),
                "ablation": dict(self.ablation_config),
            },
        )
