"""Tool-based verification agent: compile, simulate, and synthesize Verilog."""

from __future__ import annotations

import csv
import logging
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

from ..protocols import LLMBackend
from ..types import GeneratedCode, SynthMetrics, VerifyResult, VerifyVerdict

logger = logging.getLogger(__name__)

_COMPILE_TIMEOUT = 60  # seconds
_SIM_TIMEOUT = 120
_SYNTH_TIMEOUT = 120

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

# Verilator lint flags: suppress noisy warnings that waste LLM fix iterations
_LINT_FLAGS = ["-Wall", "-Wno-EOFNEWLINE", "-Wno-UNUSEDSIGNAL", "-Wno-DECLFILENAME", "-Wno-WIDTHTRUNC"]


def _extract_module_name(verilog: str) -> str:
    """Extract the top-level module name from Verilog source."""
    match = re.search(r"module\s+(\w+)", verilog)
    return match.group(1) if match else "design"


def _extract_ports(verilog: str) -> list[dict]:
    """Extract port declarations from Verilog module.

    Returns list of dicts: {name, direction, width, signed}
    """
    ports = []
    # Match port declarations like: input wire signed [15:0] a,
    port_re = re.compile(
        r"(input|output)\s+(?:wire|reg)?\s*(signed)?\s*"
        r"(?:\[(\d+):(\d+)\])?\s*(\w+)",
        re.MULTILINE,
    )
    for m in port_re.finditer(verilog):
        direction = m.group(1)
        signed = m.group(2) is not None
        msb = int(m.group(3)) if m.group(3) else 0
        lsb = int(m.group(4)) if m.group(4) else 0
        name = m.group(5)
        width = msb - lsb + 1
        ports.append({
            "name": name,
            "direction": direction,
            "width": width,
            "signed": signed,
        })
    return ports


def _generate_testbench(
    mod_name: str,
    ports: list[dict],
    golden_path: Path,
    num_vectors: int = 200,
) -> str:
    """Auto-generate a C++ Verilator testbench from port info + golden CSV.

    The testbench:
    1. Reads golden CSV for input values and expected outputs
    2. Drives the DUT clock/reset
    3. Applies input vectors and collects outputs
    4. Writes output.csv for comparison by the verify agent
    """
    # Classify ports
    clk_port = next((p["name"] for p in ports if "clk" in p["name"].lower()), None)
    rst_port = next((p["name"] for p in ports if "rst" in p["name"].lower()), None)
    valid_in = next((p["name"] for p in ports if p["direction"] == "input" and "valid" in p["name"].lower()), None)
    valid_out = next((p["name"] for p in ports if p["direction"] == "output" and "valid" in p["name"].lower()), None)

    input_ports = [p for p in ports if p["direction"] == "input"
                   and p["name"] != clk_port and p["name"] != rst_port
                   and p["name"] != valid_in]
    output_ports = [p for p in ports if p["direction"] == "output"
                    and p["name"] != valid_out]

    # Read golden CSV to get column mapping
    golden_cols = []
    try:
        with open(golden_path) as f:
            reader = csv.DictReader(f)
            golden_cols = reader.fieldnames or []
    except Exception:
        pass

    input_cols = [c for c in golden_cols if not c.startswith("expected_")]
    expected_cols = [c for c in golden_cols if c.startswith("expected_")]
    output_col_names = [c.removeprefix("expected_") for c in expected_cols]

    # Build C++ testbench
    tb = f'''#include "V{mod_name}.h"
#include "verilated.h"
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

struct TestVector {{
    {chr(10).join(f"    int64_t {c};" for c in input_cols)}
    {chr(10).join(f"    int64_t expected_{c};" for c in output_col_names)}
}};

std::vector<TestVector> load_golden(const char* path) {{
    std::vector<TestVector> vecs;
    std::ifstream f(path);
    std::string line;
    std::getline(f, line); // skip header
    while (std::getline(f, line)) {{
        TestVector tv;
        std::istringstream ss(line);
        std::string val;
'''

    # Parse each CSV column
    all_cols = input_cols + expected_cols
    for i, col in enumerate(all_cols):
        field = col if not col.startswith("expected_") else col
        tb += f'        std::getline(ss, val, \',\'); tv.{field} = std::stoll(val);\n'

    tb += '''        vecs.push_back(tv);
    }
    return vecs;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
'''
    tb += f'    V{mod_name}* dut = new V{mod_name};\n'
    tb += f'    auto vecs = load_golden("{golden_path.resolve()}");\n'
    tb += f'''
    // Open output CSV
    FILE* fout = fopen("output.csv", "w");
    fprintf(fout, "{",".join(output_col_names)}\\n");

    // Reset
'''
    if clk_port:
        tb += f'    dut->{clk_port} = 0;\n'
    if rst_port:
        active_high = "rst" in rst_port and "n" not in rst_port.lower()
        rst_active = "1" if active_high else "0"
        rst_inactive = "0" if active_high else "1"
        tb += f'    dut->{rst_port} = {rst_active};\n'
    if valid_in:
        tb += f'    dut->{valid_in} = 0;\n'
    tb += '    for (int i = 0; i < 10; i++) {\n'
    if clk_port:
        tb += f'        dut->{clk_port} = !dut->{clk_port}; dut->eval();\n'
    tb += '    }\n'
    if rst_port:
        tb += f'    dut->{rst_port} = {rst_inactive};\n'

    tb += f'''
    // Drive inputs and collect outputs
    int out_idx = 0;
    int pipeline_depth = 5; // generous pipeline assumption
    int total = (int)vecs.size();

    for (int i = 0; i < total + pipeline_depth; i++) {{
'''
    if clk_port:
        tb += f'        dut->{clk_port} = 1;\n'

    tb += '        if (i < total) {\n'
    if valid_in:
        tb += f'            dut->{valid_in} = 1;\n'

    # Map golden CSV input columns to DUT ports
    for col in input_cols:
        # Find matching port
        matching_port = next((p for p in input_ports if p["name"] == col
                              or col in p["name"] or p["name"] in col), None)
        if matching_port:
            tb += f'            dut->{matching_port["name"]} = vecs[i].{col};\n'

    tb += '        } else {\n'
    if valid_in:
        tb += f'            dut->{valid_in} = 0;\n'
    tb += '        }\n'
    tb += '        dut->eval();\n'

    if clk_port:
        tb += f'        dut->{clk_port} = 0;\n'
        tb += '        dut->eval();\n'

    # Collect outputs when valid
    tb += '\n        // Collect output\n'
    if valid_out:
        tb += f'        if (dut->{valid_out} && out_idx < total) {{\n'
    else:
        tb += f'        if (i >= 2 && out_idx < total) {{ // assume 2-cycle latency\n'

    out_fmt_parts = []
    out_val_parts = []
    for col in output_col_names:
        matching_port = next((p for p in output_ports if p["name"] == col
                              or col in p["name"] or p["name"] in col
                              or col.replace("_", "") in p["name"].replace("_", "")), None)
        if matching_port:
            if matching_port["signed"]:
                out_fmt_parts.append("%lld")
                out_val_parts.append(f"(long long)(int32_t)dut->{matching_port['name']}")
            else:
                out_fmt_parts.append("%lld")
                out_val_parts.append(f"(long long)dut->{matching_port['name']}")
        else:
            out_fmt_parts.append("0")

    fmt_str = ",".join(out_fmt_parts)
    val_str = ", ".join(out_val_parts) if out_val_parts else ""

    if val_str:
        tb += f'            fprintf(fout, "{fmt_str}\\n", {val_str});\n'
    else:
        tb += f'            fprintf(fout, "0\\n");\n'
    tb += '            out_idx++;\n'
    tb += '        }\n'
    tb += '    }\n'

    tb += f'''
    fclose(fout);
    printf("Simulation complete: %d vectors processed\\n", out_idx);
    delete dut;
    return 0;
}}
'''
    return tb


class ToolVerifyAgent:
    """Verifies generated Verilog through compile, simulation, and synthesis stages.

    Auto-generates a standardized C++ testbench from the Verilog module ports
    and golden CSV, ensuring consistent simulation comparison.
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
        variant_dir = self._work_dir / code.variant_id
        variant_dir.mkdir(parents=True, exist_ok=True)

        current_verilog = code.verilog
        compile_errors: list[str] = []
        iteration = 0

        # --- Step 4a: Compile ---
        for iteration in range(1, max_fix_iterations + 1):
            vtext = current_verilog if current_verilog.endswith("\n") else current_verilog + "\n"
            mod_name = _extract_module_name(vtext)
            verilog_path = variant_dir / f"{mod_name}.v"
            verilog_path.write_text(vtext, encoding="utf-8")

            # Auto-generate testbench from Verilog ports + golden CSV
            ports = _extract_ports(vtext)
            tb_code = _generate_testbench(mod_name, ports, golden_model_path)
            tb_path = variant_dir / f"tb_{mod_name}.cpp"
            tb_path.write_text(tb_code, encoding="utf-8")

            success, error_msg = self._run_verilator_compile(verilog_path, tb_path)
            if success:
                logger.info("Compile passed on iteration %d", iteration)
                break

            compile_errors.append(error_msg)
            logger.warning("Compile failed (iteration %d/%d): %s",
                           iteration, max_fix_iterations, error_msg[:200])

            if iteration < max_fix_iterations:
                current_verilog = self._ask_llm_fix(current_verilog, error_msg)
        else:
            return VerifyResult(
                verdict=VerifyVerdict.COMPILE_FAIL,
                iterations=iteration,
                compile_errors=compile_errors,
                error_log="\n---\n".join(compile_errors),
            )

        # --- Step 4b: Simulate ---
        binary_path = (variant_dir / "obj_dir" / f"V{mod_name}").resolve()

        for sim_iter in range(1, max_fix_iterations + 1):
            success, sim_report = self._run_verilator_sim(binary_path, golden_model_path)
            if success:
                logger.info("Simulation passed on iteration %d", sim_iter)
                break

            mismatch_desc = sim_report.get("error", "Simulation mismatch")
            logger.warning("Sim failed (iteration %d/%d): %s",
                           sim_iter, max_fix_iterations, mismatch_desc[:200])

            if sim_iter < max_fix_iterations:
                current_verilog = self._ask_llm_fix(current_verilog, mismatch_desc)
                vtext = current_verilog if current_verilog.endswith("\n") else current_verilog + "\n"
                verilog_path.write_text(vtext, encoding="utf-8")
                # Regenerate testbench with updated ports
                ports = _extract_ports(vtext)
                mod_name = _extract_module_name(vtext)
                tb_code = _generate_testbench(mod_name, ports, golden_model_path)
                tb_path.write_text(tb_code, encoding="utf-8")
                recompile_ok, recompile_err = self._run_verilator_compile(verilog_path, tb_path)
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

    def _run_verilator_compile(self, verilog_path: Path, tb_path: Path) -> tuple[bool, str]:
        work = verilog_path.parent.resolve()
        vname = verilog_path.name
        tbname = tb_path.name
        obj_dir = work / "obj_dir"
        # Always rebuild from scratch: a cached obj_dir can pin a removed
        # VERILATOR_ROOT (e.g. after a Verilator upgrade), which makes every
        # subsequent `make` fail on missing verilated.cpp/.h.
        if obj_dir.exists():
            shutil.rmtree(obj_dir, ignore_errors=True)

        # Lint
        lint_cmd = ["verilator", "--lint-only"] + _LINT_FLAGS + [vname]
        try:
            result = subprocess.run(lint_cmd, capture_output=True, text=True,
                                    timeout=_COMPILE_TIMEOUT, cwd=str(work))
            if result.returncode != 0:
                return False, f"Lint errors:\n{result.stderr or result.stdout}"
        except subprocess.TimeoutExpired:
            return False, "Verilator lint timed out."
        except FileNotFoundError:
            return False, "verilator binary not found on PATH."

        # Compile
        compile_cmd = (["verilator", "--cc", "--exe", "--build", "-j", "0"]
                       + _LINT_FLAGS + ["--trace", vname, tbname, "--Mdir", str(obj_dir)])
        try:
            result = subprocess.run(compile_cmd, capture_output=True, text=True,
                                    timeout=_COMPILE_TIMEOUT, cwd=str(work))
            if result.returncode != 0:
                return False, f"Compile errors:\n{result.stderr or result.stdout}"
        except subprocess.TimeoutExpired:
            return False, "Verilator compilation timed out."
        except FileNotFoundError:
            return False, "verilator binary not found on PATH."

        return True, ""

    def _run_verilator_sim(self, binary_path: Path, golden_path: Path) -> tuple[bool, dict]:
        if not binary_path.exists():
            return False, {"error": f"Simulation binary not found: {binary_path}"}

        sim_dir = binary_path.parent.parent
        output_csv = sim_dir / "output.csv"

        # Remove stale output
        if output_csv.exists():
            output_csv.unlink()

        # Read golden for comparison
        try:
            golden_rows = []
            with open(golden_path, "r", encoding="utf-8") as f:
                reader = csv.DictReader(f)
                fieldnames = reader.fieldnames or []
                expected_fields = [c for c in fieldnames if c.startswith("expected_")]
                for row in reader:
                    golden_rows.append(row)
        except (OSError, KeyError) as e:
            return False, {"error": f"Failed to read golden model: {e}"}

        # Run
        try:
            result = subprocess.run([str(binary_path)], capture_output=True, text=True,
                                    timeout=_SIM_TIMEOUT, cwd=str(sim_dir))
            if result.returncode != 0:
                return False, {"error": f"Simulation crashed: {result.stderr or result.stdout}"}
        except subprocess.TimeoutExpired:
            return False, {"error": "Simulation timed out."}

        if not output_csv.exists():
            return False, {"error": f"Simulation did not produce output.csv. Stdout: {result.stdout[:500]}"}

        # Read output
        try:
            with open(output_csv, "r", encoding="utf-8") as f:
                sim_rows = list(csv.DictReader(f))
        except OSError as e:
            return False, {"error": f"Failed to read simulation output: {e}"}

        if len(sim_rows) != len(golden_rows):
            return False, {
                "error": f"Row count mismatch: sim={len(sim_rows)}, golden={len(golden_rows)}",
            }

        # Compare — integer exact match for fixed-point
        mismatches = []
        for i, (sim_row, golden_row) in enumerate(zip(sim_rows, golden_rows)):
            for field in expected_fields:
                out_name = field.removeprefix("expected_")
                if out_name not in sim_row:
                    mismatches.append({"row": i, "field": out_name, "reason": "missing"})
                    continue
                exp_val = golden_row.get(field)
                got_val = sim_row.get(out_name)
                if exp_val is None or got_val is None:
                    mismatches.append({"row": i, "field": out_name, "reason": "null_value"})
                    continue
                try:
                    exp = int(exp_val)
                    got = int(got_val)
                    if exp != got:
                        mismatches.append({
                            "row": i, "field": out_name,
                            "expected": exp, "actual": got,
                        })
                except (ValueError, TypeError):
                    if str(exp_val).strip() != str(got_val).strip():
                        mismatches.append({
                            "row": i, "field": out_name,
                            "expected": exp_val,
                            "actual": got_val,
                        })

        if mismatches:
            return False, {
                "error": f"{len(mismatches)} mismatches. First 3: {mismatches[:3]}",
                "mismatches": mismatches,
            }

        return True, {"status": "pass", "rows_checked": len(golden_rows)}

    def _run_yosys_synth(self, verilog_path: Path) -> SynthMetrics | None:
        mod_name = _extract_module_name(verilog_path.read_text())
        synth_script = f"read_verilog {verilog_path.name}; synth_ice40 -top {mod_name}; stat"
        try:
            result = subprocess.run(["yosys", "-p", synth_script], capture_output=True,
                                    text=True, timeout=_SYNTH_TIMEOUT,
                                    cwd=str(verilog_path.parent))
        except (subprocess.TimeoutExpired, FileNotFoundError) as e:
            logger.error("Yosys error: %s", e)
            return None

        if result.returncode != 0:
            logger.error("Yosys synthesis failed: %s", result.stderr[:500])
            return None

        output = result.stdout
        stat_section = self._extract_final_stat(output)
        lut = self._parse_stat(stat_section, r"(\d+)\s+SB_LUT4")
        ff = self._parse_stat(stat_section, r"(\d+)\s+SB_DFF\w*", sum_all=True)
        dsp = self._parse_stat(stat_section, r"(\d+)\s+SB_MAC16")
        bram = self._parse_stat(stat_section, r"(\d+)\s+SB_RAM\w*")

        if lut == 0:
            lut = self._parse_stat(output, r"Number of cells:\s+(\d+)")
        if ff == 0:
            ff = self._parse_stat(output, r"\$_(?:DFF|SDFF)\w*\s+(\d+)")

        fmax_mhz = 0.0
        critical_path_ns = 0.0
        return SynthMetrics(lut=lut, ff=ff, dsp=dsp, bram=bram,
                            fmax_mhz=fmax_mhz, critical_path_ns=critical_path_ns)

    def _ask_llm_fix(self, code: str, error: str) -> str:
        prompt = _FIX_PROMPT_TEMPLATE.format(code=code, error=error)
        messages = [
            {"role": "system", "content": "You are a Verilog debugging expert. Fix the code. Return ONLY corrected Verilog in a single ```verilog code fence."},
            {"role": "user", "content": prompt},
        ]
        logger.info("Asking LLM to fix Verilog (error: %s...)", error[:80])
        response = self._llm.complete(messages, temperature=0.2, max_tokens=8192)
        match = re.search(r"```(?:verilog|sv|systemverilog)?\s*\n(.*?)```", response, re.DOTALL)
        if match:
            return match.group(1).strip()
        logger.warning("No code fence in LLM fix response; using raw response.")
        return response.strip()

    @staticmethod
    def _extract_final_stat(output: str) -> str:
        """Extract only the final 'Printing statistics' section from Yosys output."""
        idx = output.rfind("Printing statistics")
        if idx >= 0:
            return output[idx:]
        return output

    @staticmethod
    def _parse_stat(output: str, pattern: str, sum_all: bool = False) -> int:
        matches = re.findall(pattern, output)
        if not matches:
            return 0
        if sum_all:
            return sum(int(m) for m in matches)
        return int(matches[-1])
