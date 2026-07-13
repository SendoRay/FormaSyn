"""Protocol definitions for FormaFlow pipeline agents."""

from __future__ import annotations

from pathlib import Path
from typing import Protocol, runtime_checkable

from .types import FVIR, GeneratedCode, KernelResult, Variant, VerifyResult


@runtime_checkable
class LLMBackend(Protocol):
    """Abstraction over LLM API calls."""

    @property
    def model_id(self) -> str: ...

    def complete(
        self,
        messages: list[dict],
        temperature: float = 0.7,
        max_tokens: int = 4096,
    ) -> str: ...

    def complete_structured(
        self,
        messages: list[dict],
        schema: dict,
        temperature: float = 0.7,
    ) -> dict: ...


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

    def rank(
        self, results: list[tuple[Variant, VerifyResult]]
    ) -> list[Variant]: ...


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

    def run_experiment(self, experiment_config: dict) -> Path: ...
