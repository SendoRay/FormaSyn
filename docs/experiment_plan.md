# FormaFlow Full-Sweep Experiment Plan

## Material Passport

- Origin Skill: experiment-agent
- Origin Mode: plan
- Origin Date: 2026-06-03
- Verification Status: UNVERIFIED
- Version Label: code_plan_v1

## Experiment Overview

- **Title**: FormaFlow End-to-End Evaluation — Full CommFormaBench Sweep
- **Objective**: Evaluate whether LLM-driven formula-to-hardware synthesis (FormaFlow) produces correct, resource-efficient Verilog from mathematical formulas, and quantify the contributions of FVIR, transform discovery, and iterative verification.
- **Hypothesis**: FormaFlow achieves >70% end-to-end pass rate on CommFormaBench, outperforms HLS in parallelism (ILP), and FVIR provides ≥20% accuracy improvement over pure-prompt baselines.
- **Type**: simulation (LLM generation + EDA tool verification)

## Setup

- **Language/Framework**: Python 3.11+, with agent orchestration layer
- **Entry Command**: `python -m formaflow.orchestrator run --config experiments/full_sweep.yaml`
- **Working Directory**: `/Users/chengzhy/formasyn/`
- **Dependencies**: See `requirements.txt` (anthropic SDK, openai SDK, deepseek API client, verilator, yosys, sympy, numpy, scipy, pandas)
- **Environment**:
  - LLM APIs: Claude Sonnet 4, GPT-4o, DeepSeek-Coder-V2
  - EDA: Verilator ≥5.x, Yosys ≥0.35
  - HLS reference: Vivado HLS 2023.2 (for Exp-5 only)
  - FPGA target: Xilinx Artix-7 (xc7a200t) for HLS comparison

## Agent Interface Architecture

### Layered Design

```
┌─────────────────────────────────────────────────┐
│          ExperimentOrchestrator                  │
│  (dispatches kernel jobs, tracks progress,      │
│   manages repetitions, collects results)        │
├─────────────────────────────────────────────────┤
│          FormaFlowPipeline                      │
│  (sequences stages, handles backtracking)       │
├─────┬─────────┬──────────┬──────────┬──────────┤
│Parse│Transform│ Codegen  │ Verify   │  Rank    │
│Agent│  Agent  │  Agent   │  Agent   │  Agent   │
└─────┴─────────┴──────────┴──────────┴──────────┘
         │            │           │
         ▼            ▼           ▼
┌─────────────────────────────────────────────────┐
│            LLMBackend (abstract)                 │
│  Claude / GPT-4o / DeepSeek adapters            │
└─────────────────────────────────────────────────┘
```

### Python Protocols

```python
from typing import Protocol, runtime_checkable
from dataclasses import dataclass
from enum import Enum
from pathlib import Path

# === Data Types ===

@dataclass(frozen=True)
class FVIR:
    """Agent-Aware IR representation."""
    kernel_id: str
    ops: list[dict]          # ELEMENTWISE, REDUCE, MEMORY, CONTROL, CONSTRAINT
    constraints: dict        # @width, @throughput, @freq, @resource_limit
    source_latex: str
    metadata: dict

@dataclass(frozen=True)
class Variant:
    """A transformed FVIR variant."""
    variant_id: str
    fvir: FVIR
    transform_applied: str   # e.g., "symmetry_preaddition", "cordic_approx"
    transform_type: str      # "exact" | "approximate" | "naive"
    rationale: str

@dataclass(frozen=True)
class GeneratedCode:
    """Verilog output from codegen."""
    variant_id: str
    verilog: str
    testbench: str
    generation_metadata: dict  # model, tokens, latency

class VerifyVerdict(Enum):
    COMPILE_FAIL = "compile_fail"
    SIM_FAIL = "sim_fail"
    SYNTH_FAIL = "synth_fail"
    PASS = "pass"

@dataclass(frozen=True)
class VerifyResult:
    """Result from verification loop."""
    verdict: VerifyVerdict
    iterations: int
    compile_errors: list[str]
    sim_report: dict | None      # mismatch details if SIM_FAIL
    synth_report: dict | None    # LUT/FF/DSP/BRAM/Fmax if PASS or SYNTH_FAIL
    error_log: str

@dataclass(frozen=True)
class KernelResult:
    """Final result for one kernel × one LLM × one rep."""
    kernel_id: str
    llm_backend: str
    rep_id: int
    variants_generated: list[Variant]
    best_variant: Variant | None
    verify_result: VerifyResult | None
    synth_metrics: dict | None   # LUT, FF, DSP, BRAM, Fmax, throughput
    wall_time_seconds: float


# === Agent Protocols ===

@runtime_checkable
class ParseAgent(Protocol):
    """Stage 1: LaTeX formula → FVIR."""
    def parse(self, latex: str, constraints: dict) -> FVIR: ...

@runtime_checkable
class TransformAgent(Protocol):
    """Stage 2: naive FVIR → N variant FVIRs."""
    def transform(self, fvir: FVIR, max_variants: int = 5) -> list[Variant]: ...

@runtime_checkable
class CodegenAgent(Protocol):
    """Stage 3: FVIR variant → synthesizable Verilog + testbench."""
    def generate(self, variant: Variant) -> GeneratedCode: ...

@runtime_checkable
class VerifyAgent(Protocol):
    """Stage 4: Verilog → compile → simulate → synthesize."""
    def verify(
        self,
        code: GeneratedCode,
        golden_model_path: Path,
        max_fix_iterations: int = 5,
    ) -> VerifyResult: ...

@runtime_checkable
class RankAgent(Protocol):
    """Stage 5: Rank verified variants by resource/performance."""
    def rank(self, results: list[tuple[Variant, VerifyResult]]) -> list[Variant]: ...

@runtime_checkable
class LLMBackend(Protocol):
    """Abstraction over LLM API calls."""
    @property
    def model_id(self) -> str: ...
    def complete(self, messages: list[dict], temperature: float = 0.7) -> str: ...
    def complete_structured(self, messages: list[dict], schema: dict) -> dict: ...


# === Orchestrator Protocol ===

@runtime_checkable
class ExperimentOrchestrator(Protocol):
    """Top-level campaign manager."""
    def run_kernel(
        self,
        kernel_id: str,
        latex: str,
        constraints: dict,
        golden_model_path: Path,
        llm_backend: LLMBackend,
        rep_id: int,
    ) -> KernelResult: ...

    def run_experiment(self, experiment_config: dict) -> Path:
        """Run a full experiment, return path to results CSV."""
        ...
```

### Ablation Support

The layered design directly enables Exp-8 ablation:

| Ablation | Implementation |
|----------|---------------|
| Remove Transform Agent | Replace `TransformAgent` with `PassthroughTransform` (returns only naive variant) |
| Remove FVIR (pure prompt) | Replace `ParseAgent` + `CodegenAgent` with `DirectPromptCodegen` (LaTeX → Verilog directly) |
| Remove Verify Loop | Replace `VerifyAgent` with `SinglePassVerify` (compile+sim once, no fix iterations) |
| Remove multi-variant | Set `max_variants=1` in `TransformAgent.transform()` |

## Inputs

| Input | Path | Description |
|-------|------|-------------|
| CommFormaBench kernels | `benchmark/cat01_basic_math.md` … `cat14_sdr_common.md` | 217 kernels with LaTeX formulas, parameters, constraints |
| Transform Library | `transform_library/` (to be created) | Rewrite rules for equivalence/approximation transforms |
| Golden Models | `golden_models/` (auto-generated) | Python/SymPy reference implementations per kernel |
| Experiment configs | `experiments/*.yaml` | Per-experiment configuration (which kernels, which LLMs, which ablations) |

## Expected Outputs

| Output | Path | Format | Success Criterion |
|--------|------|--------|------------------|
| Per-kernel results | `results/{exp_id}/{kernel_id}_{llm}_{rep}.json` | JSON | File exists with valid KernelResult schema |
| Experiment summary | `results/{exp_id}/summary.csv` | CSV | All kernels × reps × LLMs accounted for |
| Verilog artifacts | `results/{exp_id}/rtl/{kernel_id}_{variant_id}.v` | Verilog | Verilator-compilable |
| Synth reports | `results/{exp_id}/synth/{kernel_id}_{variant_id}.json` | JSON | Contains LUT/FF/DSP/BRAM/Fmax |
| Transform logs | `results/{exp_id}/transforms/{kernel_id}.json` | JSON | All explored transforms and outcomes |
| Statistical analysis | `results/{exp_id}/analysis.md` | Markdown | Significance tests + effect sizes |
| Figures | `results/{exp_id}/figures/` | PNG/PDF | Publication-ready plots |

## Experiment Execution Order

### Phase 1: Infrastructure (Weeks 1–4)

| Task | Description | Deliverable |
|------|-------------|-------------|
| 1.1 | Implement agent protocols + LLM backend adapters | `formaflow/agents/`, `formaflow/backends/` |
| 1.2 | Implement Formula Parser (LaTeX → FVIR) | `formaflow/agents/parse_agent.py` |
| 1.3 | Build Golden Model generator (SymPy-based) | `formaflow/golden/generator.py` |
| 1.4 | Implement Verify Agent (Verilator + Yosys wrappers) | `formaflow/agents/verify_agent.py` |
| 1.5 | Implement Orchestrator + result collection | `formaflow/orchestrator.py` |
| 1.6 | Validate pipeline on 3 trivial kernels (FIR, NCO, CRC) | End-to-end smoke test |

### Phase 2: Core Experiments (Weeks 5–14)

| Week | Experiment | Kernels | LLMs | Notes |
|------|-----------|---------|------|-------|
| 5–6 | **Exp-4**: FVIR vs Pure Prompt | 20 kernels (across difficulties) | All 3 | Validates FVIR value early |
| 7–8 | **Exp-2**: Sequential Bias | 10 focus kernels | All 3 | Needs ILP extraction tool |
| 8–9 | **Exp-3**: Transform Discovery | 20 kernels (known optimizations) | All 3 | Needs Transform Library complete |
| 10–12 | **Exp-1**: Full Benchmark Sweep | All 217 kernels | All 3 | Longest experiment |
| 12–13 | **Exp-7**: Iteration Convergence | Subset from Exp-1 (re-analysis) | All 3 | Derived from Exp-1 logs |
| 13–14 | **Exp-8**: Ablation | 30 representative kernels | Claude Sonnet 4 | 4 ablation conditions |

### Phase 3: Baseline Comparisons (Weeks 15–20)

| Week | Experiment | Kernels | Notes |
|------|-----------|---------|-------|
| 15–17 | **Exp-5**: vs HLS (Vivado) | 15 kernels (3 difficulty × 5) | Requires Vivado HLS license + manual C input |
| 18–20 | **Exp-6**: vs Hand-designed | Kernels with OpenCores equivalents | Source from open-source repos |

### Phase 4: Analysis & Writing (Weeks 21–24)

| Task | Description |
|------|-------------|
| Statistical analysis | Wilcoxon/Friedman (decide based on distribution), Wilson CI, effect sizes |
| Visualization | Pass-rate heatmaps, resource radar charts, convergence curves |
| Failure analysis | Categorize failed kernels by failure mode |
| Validity threat assessment | Check Exp-1 results against stated threats |

## Monitoring Configuration

- **Timeout per kernel**: 30 min (LLM generation + 5 fix iterations + compile + sim + synth)
- **Timeout per experiment**: None (orchestrator-managed, can resume)
- **Monitor files**: `results/{exp_id}/progress.json` — updated after each kernel completes
- **Metric file**: `results/{exp_id}/summary.csv` — running aggregation
- **Stall detection**: If no kernel completes in 60 min, flag as stalled
- **Checkpoint**: Results saved per-kernel; pipeline is restartable from any kernel

## Analysis Plan

- **Primary metrics**: Compile pass rate, simulation pass rate, end-to-end pass rate (Exp-1)
- **Secondary metrics**: ILP improvement (Exp-2), transform discovery rate (Exp-3), resource efficiency vs HLS (Exp-5)
- **Success thresholds**:
  - Exp-1: End-to-end pass rate > 50% (ambitious target: > 70%)
  - Exp-2: ILP(FVIR) > ILP(C-code) with p < 0.05
  - Exp-3: ≥1 novel transform (not in textbooks) discovered
  - Exp-4: FVIR pass rate > prompt pass rate with p < 0.05
  - Exp-5: Resource within 1.5× of HLS for ≥60% of kernels
- **Statistical tests**: Defer specific test selection to after observing data distributions. Candidates: Wilcoxon signed-rank (paired), Friedman (3+ conditions), Mann-Whitney U (independent groups). Multiple comparison correction: Bonferroni or Holm-Bonferroni.
- **Reporting**: mean ± std across 5 reps; Wilson score CI for proportions; effect size (Cohen's d or rank-biserial correlation)

## Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| LLM API rate limits | Exponential backoff + parallel kernel dispatch across models |
| Verilator compilation hangs | Per-process timeout (60s compile, 120s sim) |
| Golden Model errors | Cross-validate with known reference implementations for focus kernels |
| Result storage bloat | Compress Verilog artifacts; keep only best variant per kernel in summary |
| Model deprecation during campaign | Pin exact model versions (snapshot IDs); note API dates |
| Transform Library incompleteness | Track FVIR coverage metric; extend as needed during Phase 2 |

## Reproducibility

- **LLM temperature**: 0.7 (as specified in methodology)
- **Random seed**: Not applicable to LLM APIs; instead: 5× repetition provides statistical robustness
- **Verilator/Yosys versions**: Pinned in `requirements.txt`
- **Test vectors**: Fixed seed for random test vector generation (seed=42 per kernel)
- **All prompts versioned**: Prompt templates stored in `formaflow/prompts/` with git tracking
- **Results archive**: Full JSON results (not just summaries) preserved for audit
