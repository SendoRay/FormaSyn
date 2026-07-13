"""Experiment orchestrator — dispatches kernel jobs, manages repetitions, collects results."""

from __future__ import annotations

import json
import logging
import time
from dataclasses import asdict
from pathlib import Path

import pandas as pd
import yaml

from .backends import ClaudeBackend, DeepSeekBackend, OpenAIBackend
from .agents import (
    LLMCodegenAgent,
    LLMParseAgent,
    LLMTransformAgent,
    MultiObjectiveRankAgent,
    ToolVerifyAgent,
)
from .pipeline import FormaFlowPipeline
from .types import KernelResult, VerifyVerdict

logger = logging.getLogger(__name__)


class Orchestrator:
    """Top-level experiment campaign manager."""

    def __init__(self, config: dict):
        self.config = config
        self.results_dir = Path(config.get("results_dir", "results"))
        self.results_dir.mkdir(parents=True, exist_ok=True)

    def _create_backend(self, backend_name: str):
        """Instantiate an LLM backend by name."""
        backends = {
            "claude": ClaudeBackend,
            "openai": OpenAIBackend,
            "deepseek": DeepSeekBackend,
        }
        if backend_name not in backends:
            raise ValueError(f"Unknown backend: {backend_name}. Choose from {list(backends)}")
        return backends[backend_name]()

    def _create_pipeline(self, llm, ablation: dict | None = None) -> FormaFlowPipeline:
        """Create a FormaFlowPipeline with the given backend and ablation config."""
        return FormaFlowPipeline(
            parse_agent=LLMParseAgent(llm),
            transform_agent=LLMTransformAgent(llm),
            codegen_agent=LLMCodegenAgent(llm),
            verify_agent=ToolVerifyAgent(llm),
            rank_agent=MultiObjectiveRankAgent(),
            config={"ablation": ablation or {}},
        )

    def _load_kernels(self, kernel_filter: list[str] | None = None) -> list[dict]:
        """Load kernel definitions from benchmark files."""
        benchmark_dir = Path(self.config.get("benchmark_dir", "benchmark"))
        kernels = []

        for cat_file in sorted(benchmark_dir.glob("cat*.md")):
            # Parse markdown kernel definitions
            content = cat_file.read_text()
            current_kernel = None

            for line in content.split("\n"):
                if line.startswith("### ") and "kernel" in line.lower():
                    if current_kernel:
                        kernels.append(current_kernel)
                    current_kernel = {
                        "kernel_id": line.strip("# ").strip(),
                        "category": cat_file.stem,
                        "latex": "",
                        "constraints": {},
                    }
                elif current_kernel and line.startswith("$$"):
                    current_kernel["latex"] = line.strip("$").strip()
                elif current_kernel and "constraint" in line.lower():
                    # Parse constraint lines
                    pass

            if current_kernel:
                kernels.append(current_kernel)

        if kernel_filter:
            kernels = [k for k in kernels if k["kernel_id"] in kernel_filter]

        logger.info(f"Loaded {len(kernels)} kernels from benchmark")
        return kernels

    def run_kernel(
        self,
        kernel_id: str,
        latex: str,
        constraints: dict,
        golden_model_path: Path,
        llm_backend_name: str,
        rep_id: int,
        ablation: dict | None = None,
    ) -> KernelResult:
        """Run a single kernel through the full pipeline."""
        llm = self._create_backend(llm_backend_name)
        pipeline = self._create_pipeline(llm, ablation)

        logger.info(f"Running kernel={kernel_id} backend={llm_backend_name} rep={rep_id}")

        result = pipeline.run(
            latex=latex,
            constraints=constraints,
            golden_model_path=golden_model_path,
            kernel_id=kernel_id,
        )

        # Save individual result
        exp_id = self.config.get("experiment_id", "default")
        result_path = self.results_dir / exp_id / f"{kernel_id}_{llm_backend_name}_{rep_id}.json"
        result_path.parent.mkdir(parents=True, exist_ok=True)
        result_path.write_text(json.dumps(self._result_to_dict(result), indent=2))

        return result

    def run_experiment(self, experiment_config: dict) -> Path:
        """Run a full experiment campaign."""
        exp_id = experiment_config.get("experiment_id", f"exp_{int(time.time())}")
        backends = experiment_config.get("backends", ["claude"])
        reps = experiment_config.get("repetitions", 5)
        kernel_filter = experiment_config.get("kernel_filter", None)
        ablation = experiment_config.get("ablation", None)

        exp_dir = self.results_dir / exp_id
        exp_dir.mkdir(parents=True, exist_ok=True)

        # Load kernels
        kernels = self._load_kernels(kernel_filter)

        # Progress tracking
        progress_path = exp_dir / "progress.json"
        completed = self._load_progress(progress_path)

        all_results = []
        total_jobs = len(kernels) * len(backends) * reps
        done = 0

        for kernel in kernels:
            for backend in backends:
                for rep in range(reps):
                    job_key = f"{kernel['kernel_id']}_{backend}_{rep}"

                    if job_key in completed:
                        done += 1
                        continue

                    try:
                        golden_path = self._get_golden_path(kernel["kernel_id"])
                        result = self.run_kernel(
                            kernel_id=kernel["kernel_id"],
                            latex=kernel["latex"],
                            constraints=kernel.get("constraints", {}),
                            golden_model_path=golden_path,
                            llm_backend_name=backend,
                            rep_id=rep,
                            ablation=ablation,
                        )
                        all_results.append(result)
                        completed[job_key] = self._result_to_dict(result)

                    except Exception as e:
                        logger.error(f"Failed {job_key}: {e}")
                        completed[job_key] = {"error": str(e)}

                    done += 1
                    if done % 10 == 0:
                        logger.info(f"Progress: {done}/{total_jobs}")
                        self._save_progress(progress_path, completed)

        # Final save
        self._save_progress(progress_path, completed)

        # Generate summary CSV
        summary_path = exp_dir / "summary.csv"
        self._generate_summary(all_results, summary_path)

        logger.info(f"Experiment {exp_id} complete. Results: {exp_dir}")
        return exp_dir

    def _get_golden_path(self, kernel_id: str) -> Path:
        """Get path to golden model output for a kernel."""
        golden_dir = Path(self.config.get("golden_dir", "golden_models"))
        return golden_dir / f"{kernel_id}_golden.csv"

    def _load_progress(self, path: Path) -> dict:
        """Load progress checkpoint."""
        if path.exists():
            return json.loads(path.read_text())
        return {}

    def _save_progress(self, path: Path, progress: dict):
        """Save progress checkpoint."""
        path.write_text(json.dumps(progress, indent=2, default=str))

    def _result_to_dict(self, result: KernelResult) -> dict:
        """Convert KernelResult to serializable dict."""
        return {
            "kernel_id": result.kernel_id,
            "llm_backend": result.llm_backend,
            "rep_id": result.rep_id,
            "num_variants": len(result.variants_generated),
            "best_variant": result.best_variant.variant_id if result.best_variant else None,
            "verdict": result.verify_result.verdict.value if result.verify_result else None,
            "iterations": result.verify_result.iterations if result.verify_result else 0,
            "synth_metrics": (
                {
                    "lut": result.verify_result.synth_metrics.lut,
                    "ff": result.verify_result.synth_metrics.ff,
                    "dsp": result.verify_result.synth_metrics.dsp,
                    "bram": result.verify_result.synth_metrics.bram,
                    "fmax_mhz": result.verify_result.synth_metrics.fmax_mhz,
                }
                if result.verify_result and result.verify_result.synth_metrics
                else None
            ),
            "wall_time_seconds": result.wall_time_seconds,
        }

    def _generate_summary(self, results: list[KernelResult], output_path: Path):
        """Generate summary CSV from results."""
        rows = [self._result_to_dict(r) for r in results]
        if rows:
            df = pd.DataFrame(rows)
            df.to_csv(output_path, index=False)
            logger.info(f"Summary written to {output_path}")
        else:
            logger.warning("No results to summarize")
