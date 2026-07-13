"""Tool-based verification agent: compile, simulate, and synthesize Verilog."""

from __future__ import annotations

import csv
import logging
import re
import subprocess
import tempfile
from pathlib import Path

from ..protocols import LLMBackend
from ..types import GeneratedCode, SynthMetrics, VerifyResult, VerifyVerdict

logger = logging.getLogger(__name__)

_COMPILE_TIMEOUT = 60  # seconds
_SIM_TIMEOUT = 120
_SYNTH_TIMEOUT = 60

_FIX_PROMPT_TEMPLATE = """\
The following Verilog code failed with the error shown below. Fix the code so it compiles \
and simulates correctly. Return ONLY the corrected Verilog inside a single ```verilog code \
fence. Do not explain.

## Current Code
```verilog
{code}
```

## Error
```
{error}
```
"""


class ToolVerifyAgent:
    """Verifies generated Verilog through compile, simulation, and synthesis stages.

    Uses Verilator for compilation and simulation, and Yosys for synthesis
    resource estimation. When a stage fails, asks the LLM to fix the code
    and retries up to max_fix_iterations.
    """

    def __init__(self, llm: LLMBackend, work_dir: Path | None = None) -> None:
        self._llm = llm
        if work_dir is not None:
            self._work_dir = Path(work_dir)
            self._work_dir.mkdir(parents=True, exist_ok=True)
        else:
            self._work_dir = Path(tempfile.mkdtemp(prefix="formaflow_verify_"))
        logger.info("ToolVerifyAgent work_dir: %s", self._work_dir)

    def verify(
        self,
        code: GeneratedCode,
        golden_model_path: Path,
        max_fix_iterations: int = 5,
    ) -> VerifyResult:
        """Run full verification pipeline: compile -> simulate -> synthesize.

        Args:
            code: Generated Verilog and testbench.
            golden_model_path: Path to CSV with test vectors and expected outputs.
            max_fix_iterations: Maximum LLM fix attempts per failing stage.

        Returns:
            VerifyResult with the appropriate verdict and metadata.
        """
        variant_dir = self._work_dir / code.variant_id
        variant_dir.mkdir(parents=True, exist_ok=True)

        verilog_path = variant_dir / "design.v"
        tb_path = variant_dir / "testbench.sv"

        current_verilog = code.verilog
        current_tb = code.testbench

        compile_errors: list[str] = []
        iteration = 0

        # --- Step 4a: Compile ---
        for iteration in range(1, max_fix_iterations + 1):
            verilog_path.write_text(current_verilog, encoding="utf-8")
            tb_path.write_text(current_tb, encoding="utf-8")

            success, error_msg = self._run_verilator_compile(verilog_path, tb_path)
            if success:
                logger.info("Compile passed on iteration %d", iteration)
                break

            compile_errors.append(error_msg)
            logger.warning(
                "Compile failed (iteration %d/%d): %s",
                iteration,
                max_fix_iterations,
                error_msg[:200],
            )

            if iteration < max_fix_iterations:
                current_verilog = self._ask_llm_fix(current_verilog, error_msg)
        else:
            # All iterations exhausted without success
            return VerifyResult(
                verdict=VerifyVerdict.COMPILE_FAIL,
                iterations=iteration,
                compile_errors=compile_errors,
                error_log="\n---\n".join(compile_errors),
            )

        # --- Step 4b: Simulate ---
        binary_path = variant_dir / "obj_dir" / f"V{verilog_path.stem}"

        for sim_iter in range(1, max_fix_iterations + 1):
            success, sim_report = self._run_verilator_sim(binary_path, golden_model_path)
            if success:
                logger.info("Simulation passed on iteration %d", sim_iter)
                break

            mismatch_desc = sim_report.get("error", "Simulation mismatch")
            logger.warning(
                "Sim failed (iteration %d/%d): %s",
                sim_iter,
                max_fix_iterations,
                mismatch_desc[:200],
            )

            if sim_iter < max_fix_iterations:
                current_verilog = self._ask_llm_fix(current_verilog, mismatch_desc)
                verilog_path.write_text(current_verilog, encoding="utf-8")

                # Recompile after fix
                recompile_ok, recompile_err = self._run_verilator_compile(
                    verilog_path, tb_path
                )
                if not recompile_ok:
                    sim_report = {"error": f"Recompile failed after fix: {recompile_err}"}
                    continue
        else:
            return VerifyResult(
                verdict=VerifyVerdict.SIM_FAIL,
                iterations=iteration + sim_iter,
                compile_errors=compile_errors,
                sim_report=sim_report,
                error_log=sim_report.get("error", ""),
            )

        total_iterations = iteration + sim_iter - 1

        # --- Step 4c: Synthesize ---
        synth_metrics = self._run_yosys_synth(verilog_path)

        if synth_metrics is None:
            return VerifyResult(
                verdict=VerifyVerdict.SYNTH_FAIL,
                iterations=total_iterations,
                compile_errors=compile_errors,
                sim_report=sim_report,
                error_log="Yosys synthesis failed to produce metrics.",
            )

        return VerifyResult(
            verdict=VerifyVerdict.PASS,
            iterations=total_iterations,
            compile_errors=compile_errors,
            sim_report=sim_report,
            synth_metrics=synth_metrics,
        )

    # ------------------------------------------------------------------
    # Helper methods
    # ------------------------------------------------------------------

    def _run_verilator_compile(
        self, verilog_path: Path, tb_path: Path
    ) -> tuple[bool, str]:
        """Run Verilator lint check then full compilation.

        Returns (success, error_message).
        """
        obj_dir = verilog_path.parent / "obj_dir"

        # Lint pass first
        lint_cmd = [
            "verilator",
            "--lint-only",
            "-Wall",
            str(verilog_path),
        ]
        try:
            result = subprocess.run(
                lint_cmd,
                capture_output=True,
                text=True,
                timeout=_COMPILE_TIMEOUT,
                cwd=str(verilog_path.parent),
            )
            if result.returncode != 0:
                error = result.stderr or result.stdout
                return False, f"Lint errors:\n{error}"
        except subprocess.TimeoutExpired:
            return False, "Verilator lint timed out."
        except FileNotFoundError:
            return False, "verilator binary not found on PATH."

        # Full compile
        compile_cmd = [
            "verilator",
            "--cc",
            "--exe",
            "--build",
            "-j", "0",
            "-Wall",
            "--trace",
            str(verilog_path),
            str(tb_path),
            "--Mdir", str(obj_dir),
        ]
        try:
            result = subprocess.run(
                compile_cmd,
                capture_output=True,
                text=True,
                timeout=_COMPILE_TIMEOUT,
                cwd=str(verilog_path.parent),
            )
            if result.returncode != 0:
                error = result.stderr or result.stdout
                return False, f"Compile errors:\n{error}"
        except subprocess.TimeoutExpired:
            return False, "Verilator compilation timed out."
        except FileNotFoundError:
            return False, "verilator binary not found on PATH."

        return True, ""

    def _run_verilator_sim(
        self, binary_path: Path, golden_path: Path
    ) -> tuple[bool, dict]:
        """Run the compiled simulation and compare against golden model.

        The golden model is a CSV file with columns for inputs and expected outputs.
        Returns (success, report_dict).
        """
        if not binary_path.exists():
            return False, {"error": f"Simulation binary not found: {binary_path}"}

        # Copy golden input to working directory as input.csv
        sim_dir = binary_path.parent.parent
        input_csv = sim_dir / "input.csv"
        output_csv = sim_dir / "output.csv"

        # Extract input vectors from golden CSV (all columns except those starting with 'expected_')
        try:
            golden_rows = []
            with open(golden_path, "r", encoding="utf-8") as f:
                reader = csv.DictReader(f)
                fieldnames = reader.fieldnames or []
                input_fields = [c for c in fieldnames if not c.startswith("expected_")]
                expected_fields = [c for c in fieldnames if c.startswith("expected_")]
                for row in reader:
                    golden_rows.append(row)

            # Write input stimulus
            with open(input_csv, "w", encoding="utf-8", newline="") as f:
                writer = csv.DictWriter(f, fieldnames=input_fields)
                writer.writeheader()
                for row in golden_rows:
                    writer.writerow({k: row[k] for k in input_fields})
        except (OSError, KeyError) as e:
            return False, {"error": f"Failed to read golden model: {e}"}

        # Run simulation
        try:
            result = subprocess.run(
                [str(binary_path)],
                capture_output=True,
                text=True,
                timeout=_SIM_TIMEOUT,
                cwd=str(sim_dir),
            )
            if result.returncode != 0:
                return False, {
                    "error": f"Simulation crashed: {result.stderr or result.stdout}"
                }
        except subprocess.TimeoutExpired:
            return False, {"error": "Simulation timed out."}
        except FileNotFoundError:
            return False, {"error": f"Binary not found: {binary_path}"}

        # Compare outputs
        if not output_csv.exists():
            return False, {"error": "Simulation did not produce output.csv"}

        try:
            with open(output_csv, "r", encoding="utf-8") as f:
                sim_reader = csv.DictReader(f)
                sim_rows = list(sim_reader)
        except OSError as e:
            return False, {"error": f"Failed to read simulation output: {e}"}

        if len(sim_rows) != len(golden_rows):
            return False, {
                "error": (
                    f"Row count mismatch: simulation produced {len(sim_rows)} rows, "
                    f"golden has {len(golden_rows)} rows."
                ),
                "mismatches": [],
            }

        # Determine fractional bits from golden metadata or default to 16
        frac_bits = 16  # default; could be overridden by constraints
        tolerance = 2 ** (-frac_bits + 1)

        mismatches = []
        for i, (sim_row, golden_row) in enumerate(zip(sim_rows, golden_rows)):
            for field in expected_fields:
                output_field = field.removeprefix("expected_")
                if output_field not in sim_row:
                    mismatches.append(
                        {"row": i, "field": output_field, "reason": "missing in output"}
                    )
                    continue
                try:
                    expected_val = float(golden_row[field])
                    actual_val = float(sim_row[output_field])
                    if abs(expected_val - actual_val) > tolerance:
                        mismatches.append({
                            "row": i,
                            "field": output_field,
                            "expected": expected_val,
                            "actual": actual_val,
                            "diff": abs(expected_val - actual_val),
                        })
                except (ValueError, TypeError):
                    # Integer comparison fallback
                    if str(golden_row[field]).strip() != str(sim_row[output_field]).strip():
                        mismatches.append({
                            "row": i,
                            "field": output_field,
                            "expected": golden_row[field],
                            "actual": sim_row.get(output_field, "MISSING"),
                        })

        if mismatches:
            error_summary = (
                f"{len(mismatches)} output mismatches (tolerance={tolerance}).\n"
                f"First 5: {mismatches[:5]}"
            )
            return False, {"error": error_summary, "mismatches": mismatches}

        return True, {"status": "pass", "rows_checked": len(golden_rows)}

    def _run_yosys_synth(self, verilog_path: Path) -> SynthMetrics | None:
        """Run Yosys synthesis and parse resource statistics.

        Returns SynthMetrics or None if synthesis fails.
        """
        synth_script = f"read_verilog {verilog_path}; synth; stat"

        try:
            result = subprocess.run(
                ["yosys", "-p", synth_script],
                capture_output=True,
                text=True,
                timeout=_SYNTH_TIMEOUT,
                cwd=str(verilog_path.parent),
            )
        except subprocess.TimeoutExpired:
            logger.error("Yosys synthesis timed out.")
            return None
        except FileNotFoundError:
            logger.error("yosys binary not found on PATH.")
            return None

        if result.returncode != 0:
            logger.error("Yosys synthesis failed: %s", result.stderr[:500])
            return None

        output = result.stdout

        # Parse stats from yosys output
        lut = self._parse_yosys_stat(output, r"\$lut\s*(\d+)")
        ff = self._parse_yosys_stat(output, r"(?:SB_DFF|\\$dff)\s*(\d+)")
        dsp = self._parse_yosys_stat(output, r"(?:DSP|\\$mul)\s*(\d+)")
        bram = self._parse_yosys_stat(output, r"(?:BRAM|\\$mem)\s*(\d+)")

        # Fallback: parse from "Number of cells" style output
        if lut == 0:
            lut = self._parse_yosys_stat(output, r"Number of cells:\s*(\d+)")
        if ff == 0:
            ff = self._parse_yosys_stat(
                output, r"Number of (?:flip-flops|FF):\s*(\d+)"
            )

        # Parse critical path / fmax if available (from ABC output or stat)
        fmax_mhz = 0.0
        critical_path_ns = 0.0

        fmax_match = re.search(r"Fmax\s*[:=]\s*([\d.]+)\s*MHz", output)
        if fmax_match:
            fmax_mhz = float(fmax_match.group(1))
            critical_path_ns = 1000.0 / fmax_mhz if fmax_mhz > 0 else 0.0

        cp_match = re.search(r"critical path\s*[:=]\s*([\d.]+)\s*ns", output, re.IGNORECASE)
        if cp_match:
            critical_path_ns = float(cp_match.group(1))
            if critical_path_ns > 0 and fmax_mhz == 0.0:
                fmax_mhz = 1000.0 / critical_path_ns

        return SynthMetrics(
            lut=lut,
            ff=ff,
            dsp=dsp,
            bram=bram,
            fmax_mhz=fmax_mhz,
            critical_path_ns=critical_path_ns,
        )

    def _ask_llm_fix(self, code: str, error: str) -> str:
        """Ask the LLM to fix Verilog code given an error message.

        Returns the corrected Verilog source.
        """
        prompt = _FIX_PROMPT_TEMPLATE.format(code=code, error=error)

        messages = [
            {
                "role": "system",
                "content": (
                    "You are a Verilog debugging expert. Fix the code to resolve the "
                    "error. Return ONLY corrected Verilog in a single code fence."
                ),
            },
            {"role": "user", "content": prompt},
        ]

        logger.info("Asking LLM to fix Verilog (error: %s...)", error[:80])
        response = self._llm.complete(messages, temperature=0.2, max_tokens=8192)

        # Extract code from response
        match = re.search(r"```(?:verilog|sv|systemverilog)?\s*\n(.*?)```", response, re.DOTALL)
        if match:
            return match.group(1).strip()

        # If no code fence, assume the entire response is the fixed code
        logger.warning("No code fence in LLM fix response; using raw response.")
        return response.strip()

    @staticmethod
    def _parse_yosys_stat(output: str, pattern: str) -> int:
        """Extract an integer stat from yosys output using a regex pattern."""
        match = re.search(pattern, output)
        if match:
            return int(match.group(1))
        return 0
