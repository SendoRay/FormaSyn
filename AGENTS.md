# Repository Guidelines

## Project Structure & Module Organization
FormaSyn is a Python package organized by compilation stages.
- Core modules: `dsl/` (graph ops + parser), `ir/` (Math/Algo-HW/Schedule dialects), `agent/` (LLM DSE), `solver/` (roofline/resource decisions), `codegen/` (HLS C++ output), `checker/` (L1 validation), `golden/` (reference model + quant analysis), `mlc/` (backend transforms), `feedback/` (iteration strategies).
- Examples: `examples/fir_16tap/` and `examples/ldpc_cnu/` each contain `kernel.py` + `constraints.yaml`.
- Entry point: `run.py` unified runner (`python run.py <example>`).
- Tests: `tests/test_*.py` mirror module boundaries.
- Vitis workflow samples/artifacts: `vitis_hls_test/`.

## Build, Test, and Development Commands
- Install dependencies: `pip install numpy scipy networkx openai pyyaml pytest`
- Run all unit tests: `pytest -q`
- Run verbose pipeline tests: `pytest -s tests/test_examples.py`
- Run a single module test: `pytest -q tests/test_codegen.py`
- Execute built-in examples:
  - `python run.py fir_16tap`
  - `python run.py ldpc_cnu --dc 16`

## Coding Style & Naming Conventions
- Python style: 4-space indentation, type hints for public APIs, dataclasses for structured payloads.
- Naming: `snake_case` for functions/variables/files, `PascalCase` for classes, UPPER_CASE for constants.
- Keep stage boundaries explicit: parser/IR/solver/codegen/checker should stay loosely coupled and pass typed objects.
- Prefer small pure helpers; isolate subprocess/tool invocations (see `checker/l1_checker.py`).

## Testing Guidelines
- Framework: `pytest` with files named `tests/test_<module>.py`.
- Add tests with each behavior change; include success and failure-path assertions.
- Hardware-tool-dependent logic should be mocked when possible (existing tests mock `v++`), so CI/local runs remain deterministic.

## Commit & Pull Request Guidelines
- Follow existing commit style: short imperative subject lines (for example: `Unify example runner entrypoint`, `Switch L1 checker to Vitis HLS csim workflow`).
- Keep commits focused to one logical change.
- PRs should include:
  - clear summary of behavior change,
  - impacted modules/paths,
  - test evidence (`pytest` command + result),
  - sample `run.py` output if pipeline behavior changes.

## Security & Configuration Tips
- Do not commit secrets or provider keys.
- Prefer environment-based credentials for LLM providers and local toolchain configuration (`v++`, `g++`) via PATH.
