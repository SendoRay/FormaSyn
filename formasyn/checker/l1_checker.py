"""L1 Checker: Verilator / Icarus Verilog simulation + numeric verification.

Compiles generated Verilog with a SystemVerilog testbench using Verilator
(preferred) or Icarus Verilog (fallback), runs the simulation, parses
@@OUTPUT markers from stdout, and compares against golden reference outputs.

Metric dispatch by kernel_type:
  - channel_coding  -> sign_error_rate, snr_penalty_db
  - filtering       -> nmse_db
  - transform       -> nmse_db
  - detection       -> nmse_db
  - sync            -> nmse_db
"""

from __future__ import annotations

import logging
import os
import re
import shutil
import subprocess
import tempfile
from typing import Optional

from .diagnostic import diagnose_compile_error, diagnose_numeric_error
from .metrics import L1Result
from ..utils.metrics import compute_nmse, compute_sign_error_rate

logger = logging.getLogger(__name__)


class L1Checker:
    """L1 verification: Verilator/Icarus Verilog simulation + numeric comparison."""

    def __init__(
        self,
        kernel_type: str = "channel_coding",
        tolerance: Optional[dict[str, float]] = None,
    ) -> None:
        self._kernel_type = kernel_type
        self._tolerance = tolerance or {}

    def check(
        self,
        verilog_code: str,
        golden_outputs: dict[str, list[float]],
        test_inputs: dict[str, list[float]],
        variant_id: str,
        *,
        testbench_sv: str = "",
        prepared_dir: Optional[str] = None,
    ) -> L1Result:
        """Run L1 verification on generated Verilog code.

        Args:
            verilog_code: Generated Verilog source.
            golden_outputs: Golden reference outputs.
            test_inputs: Test input vectors.
            variant_id: Variant identifier.
            testbench_sv: SystemVerilog testbench source.
            prepared_dir: Pre-prepared directory with sources already written.

        Returns:
            L1Result with pass/fail status and metrics.
        """
        result = L1Result(variant_id=variant_id, golden_outputs=golden_outputs)

        has_verilator = shutil.which("verilator") is not None
        has_iverilog = shutil.which("iverilog") is not None

        if not has_verilator and not has_iverilog:
            logger.warning("L1 跳过 [%s]: verilator 和 iverilog 均不可用", variant_id)
            result.passed = True
            result.metrics = {"skipped": True}
            return result

        use_tmpdir = prepared_dir is None
        work_dir = prepared_dir if prepared_dir else tempfile.mkdtemp(prefix="formasyn_l1_")

        try:
            sim_outputs: Optional[dict[str, list[float]]] = None
            compile_error: Optional[str] = None

            if has_verilator:
                try:
                    sim_outputs = self._run_verilator(
                        verilog_code, testbench_sv, work_dir,
                    )
                except _CompileError as exc:
                    logger.warning("Verilator 失败, 尝试 iverilog: %s", str(exc)[:200])
                    compile_error = str(exc)
                    if has_iverilog:
                        try:
                            sim_outputs = self._run_iverilog(
                                verilog_code, testbench_sv, work_dir,
                            )
                            compile_error = None
                        except _CompileError as exc2:
                            compile_error = str(exc2)
            else:
                try:
                    sim_outputs = self._run_iverilog(
                        verilog_code, testbench_sv, work_dir,
                    )
                except _CompileError as exc:
                    compile_error = str(exc)

            if compile_error is not None:
                result.compile_ok = False
                result.failure = diagnose_compile_error(compile_error, variant_id)
                logger.warning("L1 编译失败 [%s]: %s", variant_id, compile_error[:200])
                return result

            assert sim_outputs is not None
            result.compile_ok = True
            result.hls_outputs = sim_outputs
            result.metrics = self._compute_metrics(golden_outputs, sim_outputs)
            result.passed = self._check_thresholds(result.metrics)

            if not result.passed:
                result.failure = diagnose_numeric_error(
                    variant_id, result.metrics, self._tolerance, self._kernel_type,
                )
                logger.warning(
                    "L1 数值验证失败 [%s]: %s",
                    variant_id, result.failure.gap_description,
                )
            else:
                logger.info("L1 通过 [%s]: metrics=%s", variant_id, result.metrics)

            return result
        finally:
            if use_tmpdir and os.path.isdir(work_dir):
                shutil.rmtree(work_dir, ignore_errors=True)

    # -- Verilator -------------------------------------------------------------

    def _run_verilator(
        self,
        verilog_code: str,
        testbench_sv: str,
        work_dir: str,
    ) -> dict[str, list[float]]:
        """Compile and run simulation with Verilator."""
        kernel_path = os.path.join(work_dir, "kernel_top.v")
        tb_path = os.path.join(work_dir, "kernel_tb.sv")
        os.makedirs(work_dir, exist_ok=True)

        with open(kernel_path, "w", encoding="utf-8") as f:
            f.write(verilog_code)
        with open(tb_path, "w", encoding="utf-8") as f:
            f.write(testbench_sv)

        tb_module = self._extract_tb_module(testbench_sv)

        compile_cmd = [
            "verilator", "--binary", "--timing", "-Wno-fatal",
            "-o", "sim",
            "kernel_top.v", "kernel_tb.sv",
            "--top-module", tb_module,
            "--Mdir", "obj_dir",
        ]
        logger.info("L1 Verilator 编译: %s", " ".join(compile_cmd))

        proc = subprocess.run(
            compile_cmd,
            capture_output=True, text=True,
            cwd=work_dir, timeout=300,
        )
        if proc.returncode != 0:
            raise _CompileError(proc.stderr.strip() or proc.stdout.strip() or "verilator compile failed")

        sim_binary = os.path.join(work_dir, "obj_dir", "sim")
        if not os.path.isfile(sim_binary):
            raise _CompileError("Verilator binary not found after compilation")

        run_proc = subprocess.run(
            [sim_binary],
            capture_output=True, text=True,
            cwd=work_dir, timeout=300,
        )
        if run_proc.returncode != 0:
            raise _CompileError(run_proc.stderr.strip() or "verilator simulation failed")

        outputs = self._parse_output(run_proc.stdout)
        if not outputs:
            raise _CompileError("Verilator simulation completed but produced no @@OUTPUT records")
        return outputs

    # -- Icarus Verilog --------------------------------------------------------

    def _run_iverilog(
        self,
        verilog_code: str,
        testbench_sv: str,
        work_dir: str,
    ) -> dict[str, list[float]]:
        """Compile and run simulation with Icarus Verilog."""
        kernel_path = os.path.join(work_dir, "kernel_top.v")
        tb_path = os.path.join(work_dir, "kernel_tb.sv")
        os.makedirs(work_dir, exist_ok=True)

        with open(kernel_path, "w", encoding="utf-8") as f:
            f.write(verilog_code)
        with open(tb_path, "w", encoding="utf-8") as f:
            f.write(testbench_sv)

        vvp_path = os.path.join(work_dir, "sim.vvp")
        compile_cmd = [
            "iverilog", "-g2012", "-o", vvp_path,
            kernel_path, tb_path,
        ]
        logger.info("L1 iverilog 编译: %s", " ".join(compile_cmd))

        proc = subprocess.run(
            compile_cmd,
            capture_output=True, text=True,
            cwd=work_dir, timeout=300,
        )
        if proc.returncode != 0:
            raise _CompileError(proc.stderr.strip() or proc.stdout.strip() or "iverilog compile failed")

        run_proc = subprocess.run(
            ["vvp", vvp_path],
            capture_output=True, text=True,
            cwd=work_dir, timeout=300,
        )
        if run_proc.returncode != 0:
            raise _CompileError(run_proc.stderr.strip() or "iverilog simulation failed")

        outputs = self._parse_output(run_proc.stdout)
        if not outputs:
            raise _CompileError("Icarus Verilog simulation completed but produced no @@OUTPUT records")
        return outputs

    # -- Output parsing --------------------------------------------------------

    @staticmethod
    def _extract_tb_module(testbench_sv: str) -> str:
        """Extract testbench module name from SystemVerilog source."""
        match = re.search(r"module\s+(\w+_tb)", testbench_sv)
        if match:
            return match.group(1)
        match = re.search(r"module\s+(\w+)", testbench_sv)
        if match:
            return match.group(1)
        return "kernel_tb"

    @staticmethod
    def _parse_output(stdout: str) -> dict[str, list[float]]:
        """Parse @@OUTPUT markers from simulation stdout.

        Supported formats:
          @@OUTPUT name[idx] = value
          @@OUTPUT name = value

        Returns:
            dict mapping signal names to lists of float values.
        """
        results: dict[str, list[float]] = {}
        indexed_pattern = re.compile(
            r"@@OUTPUT\s+(\w+)\[(\d+)\]\s*=\s*([+-]?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)"
        )
        scalar_pattern = re.compile(
            r"@@OUTPUT\s+(\w+)\s*=\s*([+-]?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)"
        )

        for line in stdout.splitlines():
            if "@@OUTPUT" not in line:
                continue

            m = indexed_pattern.search(line)
            if m:
                name, idx, value = m.group(1), int(m.group(2)), float(m.group(3))
                if name not in results:
                    results[name] = []
                while len(results[name]) <= idx:
                    results[name].append(0.0)
                results[name][idx] = value
                continue

            m = scalar_pattern.search(line)
            if m:
                name, value = m.group(1), float(m.group(2))
                if name not in results:
                    results[name] = []
                results[name].append(value)

        return results

    # -- Metrics ---------------------------------------------------------------

    def _compute_metrics(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> dict[str, float]:
        """Compute quality metrics based on kernel_type.

        Pads actual outputs with zeros if shorter than golden.
        """
        padded_actual: dict[str, list[float]] = {}
        for key, g_vals in golden.items():
            a_vals = actual.get(key, [])
            if len(a_vals) < len(g_vals):
                a_vals = list(a_vals) + [0.0] * (len(g_vals) - len(a_vals))
            padded_actual[key] = a_vals

        if self._kernel_type == "channel_coding":
            ser, snr, _ = compute_sign_error_rate(golden, padded_actual)
            return {"sign_error_rate": ser, "snr_penalty_db": snr}
        return {"nmse_db": compute_nmse(golden, padded_actual)}

    def _check_thresholds(self, metrics: dict[str, float]) -> bool:
        """Return True if all metrics are within tolerance.

        Uses default thresholds when tolerance dict does not specify a metric:
          - max_sign_error_rate: 0.1
          - max_nmse_db: -20.0
        """
        if self._kernel_type == "channel_coding":
            max_ser = self._tolerance.get("max_sign_error_rate", 0.1)
            ser = metrics.get("sign_error_rate")
            if ser is not None and ser > max_ser:
                return False
        else:
            max_nmse = self._tolerance.get("max_nmse_db", -20.0)
            nmse = metrics.get("nmse_db")
            if nmse is not None and nmse > max_nmse:
                return False
        return True


class _CompileError(Exception):
    """Internal exception for compilation/simulation failures."""
    pass
