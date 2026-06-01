"""L2 Checker: Yosys synthesis resource verification.

Runs Yosys to synthesize generated Verilog and parses resource
statistics (LUT, FF, DSP, BRAM) from the ``stat`` command output.
"""

from __future__ import annotations

import logging
import os
import re
import shutil
import subprocess
import tempfile
from typing import Optional

from .diagnostic import (
    FailureContext,
    FailureStage,
    diagnose_resource_error_with_ii,
)
from .metrics import SynthReport, L2Result

logger = logging.getLogger(__name__)

# Yosys synth command per target family.
_SYNTH_COMMANDS: dict[str, str] = {
    "xilinx": "synth_xilinx",
    "ice40": "synth_ice40",
    "gowin": "synth_gowin",
    "ecp5": "synth_ecp5",
}


class L2Checker:
    """L2 verification via Yosys synthesis.

    Args:
        hw_budget: Resource budget dict with keys ``max_dsp``, ``max_bram``,
            ``max_lut``, ``max_ff``.
        target_ii: Target initiation interval (informational; Yosys does not
            compute II).
        clock_mhz: Target clock frequency in MHz (informational).
        synth_target: FPGA target family for Yosys synth command.
    """

    def __init__(
        self,
        hw_budget: Optional[dict[str, int]] = None,
        target_ii: int = 1,
        clock_mhz: float = 250.0,
        synth_target: str = "xilinx",
    ) -> None:
        self._budget = hw_budget or {}
        self._target_ii = target_ii
        self._clock_mhz = clock_mhz
        if synth_target not in _SYNTH_COMMANDS:
            raise ValueError(
                f"Unsupported synth_target '{synth_target}'. "
                f"Choose from: {', '.join(_SYNTH_COMMANDS)}"
            )
        self._synth_target = synth_target

    def check(
        self,
        verilog_code: str,
        variant_id: str,
        *,
        top_module: str = "",
        prepared_dir: Optional[str] = None,
    ) -> L2Result:
        """Run Yosys synthesis on Verilog code and check resource budget.

        If ``yosys`` is not installed, returns a skipped result.

        Args:
            verilog_code: Generated Verilog source code.
            variant_id: Variant identifier.
            top_module: Top-level module name.  Inferred from code if empty.
            prepared_dir: Pre-prepared directory for intermediate files.
        """
        result = L2Result(variant_id=variant_id)

        if not shutil.which("yosys"):
            logger.info("yosys not found, skipping L2 check [%s]", variant_id)
            result.skipped = True
            result.passed = True
            return result

        try:
            report = self._run_yosys(
                verilog_code, variant_id,
                top_module=top_module, prepared_dir=prepared_dir,
            )
        except _YosysError as exc:
            result.failure = FailureContext(
                failed_at=FailureStage.L2_CSYNTH,
                variant_id=variant_id,
                raw_error=str(exc)[:2000],
                summary="Yosys synthesis failed",
            )
            logger.error("L2 Yosys synthesis failed [%s]: %s", variant_id, str(exc)[:200])
            return result

        result.synth_report = report
        passed, failure = self._check_budget(report, variant_id)
        if not passed:
            result.failure = failure
            logger.warning("L2 check failed [%s]: %s", variant_id, failure.gap_description)
        else:
            result.passed = True
            logger.info(
                "L2 passed [%s]: LUT=%d FF=%d DSP=%d BRAM=%d",
                variant_id, report.lut, report.ff, report.dsp, report.bram,
            )
        return result

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _run_yosys(
        self,
        verilog_code: str,
        variant_id: str,
        *,
        top_module: str = "",
        prepared_dir: Optional[str] = None,
    ) -> SynthReport:
        """Write Verilog, run Yosys synthesis, and parse the stat output."""
        work_dir = prepared_dir or tempfile.mkdtemp(prefix="formasyn_l2_")
        v_path = os.path.join(work_dir, "kernel_top.v")
        ys_path = os.path.join(work_dir, "synth.ys")

        with open(v_path, "w", encoding="utf-8") as fh:
            fh.write(verilog_code)

        if not top_module:
            top_module = self._infer_top_module(verilog_code)

        synth_cmd = _SYNTH_COMMANDS[self._synth_target]
        script = f"read_verilog {v_path}\n{synth_cmd} -top {top_module}\nstat\n"
        with open(ys_path, "w", encoding="utf-8") as fh:
            fh.write(script)

        cmd = ["yosys", "-s", ys_path]
        logger.info("L2 Yosys synthesis [%s]: %s", variant_id, " ".join(cmd))
        try:
            proc = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                cwd=work_dir,
                timeout=600,
            )
        except (FileNotFoundError, PermissionError, OSError) as exc:
            raise _YosysError(str(exc)) from exc

        if proc.returncode != 0:
            error_output = proc.stderr or proc.stdout or "yosys synthesis failed"
            raise _YosysError(error_output)

        return self._parse_stat(proc.stdout)

    @staticmethod
    def _infer_top_module(verilog_code: str) -> str:
        """Extract the first module name from Verilog source."""
        match = re.search(r"module\s+(\w+)", verilog_code)
        if match:
            return match.group(1)
        return "kernel"

    @staticmethod
    def _parse_stat(stdout: str) -> SynthReport:
        """Parse Yosys ``stat`` output for resource counts.

        Scans each line for known cell names and accumulates counts into
        the appropriate resource category (LUT, FF, DSP, BRAM).
        """
        lut = 0
        ff = 0
        dsp = 0
        bram = 0

        # Yosys stat lines look like:  "   SB_LUT4          42"
        cell_re = re.compile(r"^\s+(\S+)\s+(\d+)\s*$")

        for line in stdout.splitlines():
            m = cell_re.match(line)
            if not m:
                continue
            name = m.group(1).upper()
            count = int(m.group(2))

            if "LUT" in name:
                lut += count
            elif name in ("FDRE", "FDSE", "FDCE", "FDPE", "SB_DFF", "SB_DFFE",
                          "SB_DFFR", "SB_DFFSR", "$DFF", "TRELLIS_FF") \
                    or name.startswith("$_DFF") or name.startswith("$_SDFF"):
                ff += count
            elif "DSP" in name:
                dsp += count
            elif "BRAM" in name or "RAMB" in name or "SB_RAM" in name \
                    or "TRELLIS_RAM" in name or "DP16KD" in name:
                bram += count

        return SynthReport(
            dsp=dsp,
            bram=bram,
            lut=lut,
            ff=ff,
            achieved_ii=1,
            clock_period_ns=0.0,
            timing_met=True,
        )

    def _check_budget(
        self,
        report: SynthReport,
        variant_id: str,
    ) -> tuple[bool, Optional[FailureContext]]:
        """Compare synthesis report against hardware budget.

        Returns:
            Tuple of (passed, failure_context).  ``failure_context`` is
            ``None`` when the check passes.
        """
        if not self._budget:
            return True, None

        usage = {"dsp": report.dsp, "bram": report.bram, "lut": report.lut, "ff": report.ff}

        # Map budget keys: accept both "max_dsp" and "dsp" forms.
        budget: dict[str, int] = {}
        for key, val in self._budget.items():
            clean = key.removeprefix("max_")
            budget[clean] = val

        over = any(usage.get(r, 0) > limit for r, limit in budget.items() if limit > 0)

        if over:
            failure = diagnose_resource_error_with_ii(
                variant_id, usage, budget,
                timing_ok=True, ii_ok=True,
                achieved_ii=1, target_ii=self._target_ii,
            )
            return False, failure

        return True, None


class _YosysError(Exception):
    """Internal exception for Yosys synthesis failures."""
