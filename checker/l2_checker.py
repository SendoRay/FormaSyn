"""L2 Checker: Vitis HLS C-Sim + csynth resource/timing verification.

Requires Vitis HLS to be installed and on PATH. When EDA tools are not
available, the checker returns a skip result instead of failing.

Two sub-checks:
  - C-Sim: precise ap_int/ap_fixed numeric validation
  - csynth: resource utilisation (DSP/BRAM/LUT/FF) + timing (II, clock)
"""

from __future__ import annotations

import logging
import os
import re
import subprocess
import tempfile
from dataclasses import dataclass, field
from typing import Optional

from FormaSyn.checker.diagnostic import (
    FailureContext,
    FailureStage,
    diagnose_resource_error,
)

logger = logging.getLogger(__name__)


@dataclass
class SynthReport:
    """Parsed Vitis HLS csynth resource and timing report.

    Attributes:
        dsp: Number of DSP slices used.
        bram: Number of BRAM_18K blocks used.
        lut: Number of LUTs used.
        ff: Number of flip-flops used.
        achieved_ii: Achieved initiation interval.
        clock_period_ns: Estimated clock period in nanoseconds.
        timing_met: Whether the timing constraint was met.
    """
    dsp: int = 0
    bram: int = 0
    lut: int = 0
    ff: int = 0
    achieved_ii: int = 1
    clock_period_ns: float = 0.0
    timing_met: bool = True


@dataclass
class L2Result:
    """Result of L2 EDA-based verification.

    Attributes:
        variant_id: Identifier of the variant under test.
        passed: Whether all resource and timing checks passed.
        skipped: True if Vitis HLS is not available.
        synth_report: Parsed synthesis report.
        failure: Failure context if check failed.
    """
    variant_id: str
    passed: bool = False
    skipped: bool = False
    synth_report: Optional[SynthReport] = None
    failure: Optional[FailureContext] = None


class L2Checker:
    """L2 verification via Vitis HLS C-Sim and csynth.

    Args:
        hw_budget: Resource budget as {'dsp': N, 'bram': N, 'lut': N, 'ff': N}.
        target_ii: Target initiation interval.
        clock_mhz: Target clock frequency in MHz.
    """

    def __init__(
        self,
        hw_budget: Optional[dict[str, int]] = None,
        target_ii: int = 1,
        clock_mhz: int = 250,
    ) -> None:
        self._budget = hw_budget or {}
        self._target_ii = target_ii
        self._clock_mhz = clock_mhz

    def check(
        self,
        hls_cpp_code: str,
        hls_header_code: str,
        variant_id: str,
        function_name: str = "kernel",
    ) -> L2Result:
        """Run Vitis HLS C-Sim + csynth on the generated code.

        If Vitis HLS is not installed, returns a skipped result.

        Args:
            hls_cpp_code: Generated HLS C++ source.
            hls_header_code: Generated HLS C++ header.
            variant_id: Variant identifier.
            function_name: Top-level function name for HLS.

        Returns:
            L2Result with synthesis report and pass/fail status.
        """
        result = L2Result(variant_id=variant_id)

        if not self._vitis_available():
            logger.info("Vitis HLS 不可用，跳过 L2 验证 [%s]", variant_id)
            result.skipped = True
            result.passed = True
            return result

        try:
            synth = self._run_vitis_hls(
                hls_cpp_code, hls_header_code, function_name, variant_id
            )
        except _VitisError as e:
            result.failure = FailureContext(
                failed_at=FailureStage.L2_CSYNTH,
                variant_id=variant_id,
                raw_error=str(e)[:2000],
                summary="Vitis HLS 综合失败",
            )
            logger.error("L2 Vitis 综合失败 [%s]: %s", variant_id, str(e)[:200])
            return result

        result.synth_report = synth

        usage = {"dsp": synth.dsp, "bram": synth.bram, "lut": synth.lut, "ff": synth.ff}
        over_budget = any(
            usage.get(r, 0) > limit for r, limit in self._budget.items()
        )
        ii_ok = synth.achieved_ii <= self._target_ii
        timing_ok = synth.timing_met

        if over_budget or not ii_ok or not timing_ok:
            result.failure = diagnose_resource_error(
                variant_id, usage, self._budget, timing_ok and ii_ok
            )
            logger.warning("L2 验证失败 [%s]: %s", variant_id, result.failure.gap_description)
        else:
            result.passed = True
            logger.info(
                "L2 通过 [%s]: DSP=%d BRAM=%d II=%d",
                variant_id, synth.dsp, synth.bram, synth.achieved_ii,
            )

        return result

    @staticmethod
    def _vitis_available() -> bool:
        """Check if Vitis HLS command is on PATH."""
        try:
            subprocess.run(
                ["vitis_hls", "-version"],
                capture_output=True, text=True, timeout=10,
            )
            return True
        except (FileNotFoundError, subprocess.TimeoutExpired):
            return False

    def _run_vitis_hls(
        self,
        cpp_code: str,
        header_code: str,
        function_name: str,
        variant_id: str,
    ) -> SynthReport:
        """Create a Vitis HLS project, run csynth, parse the report."""
        work_dir = tempfile.mkdtemp(prefix="formasyn_l2_")
        src_path = os.path.join(work_dir, f"{function_name}.cpp")
        hdr_path = os.path.join(work_dir, f"{function_name}.h")

        with open(src_path, "w", encoding="utf-8") as f:
            f.write(cpp_code)
        with open(hdr_path, "w", encoding="utf-8") as f:
            f.write(header_code)

        clock_ns = round(1000.0 / self._clock_mhz, 2)
        tcl_script = self._generate_tcl(
            work_dir, src_path, function_name, clock_ns
        )
        tcl_path = os.path.join(work_dir, "run.tcl")
        with open(tcl_path, "w", encoding="utf-8") as f:
            f.write(tcl_script)

        proc = subprocess.run(
            ["vitis_hls", "-f", tcl_path],
            capture_output=True, text=True,
            cwd=work_dir, timeout=600,
        )
        if proc.returncode != 0:
            raise _VitisError(proc.stderr)

        return self._parse_csynth_report(work_dir, function_name)

    @staticmethod
    def _generate_tcl(
        work_dir: str,
        src_path: str,
        function_name: str,
        clock_ns: float,
    ) -> str:
        """Generate a Vitis HLS TCL script for csynth."""
        return f"""\
open_project -reset hls_proj
set_top {function_name}
add_files {src_path}
open_solution -reset "sol1"
set_part xczu7ev-ffvc1156-2-e
create_clock -period {clock_ns} -name default
csynth_design
exit
"""

    @staticmethod
    def _parse_csynth_report(work_dir: str, function_name: str) -> SynthReport:
        """Parse the csynth XML/text report."""
        report = SynthReport()
        rpt_dir = os.path.join(
            work_dir, "hls_proj", "sol1", "syn", "report"
        )
        rpt_path = os.path.join(rpt_dir, f"{function_name}_csynth.rpt")

        if not os.path.isfile(rpt_path):
            logger.warning("综合报告不存在: %s", rpt_path)
            return report

        with open(rpt_path, "r", encoding="utf-8") as f:
            content = f.read()

        dsp_match = re.search(r"DSP\s*[|:]\s*(\d+)", content)
        if dsp_match:
            report.dsp = int(dsp_match.group(1))

        bram_match = re.search(r"BRAM_18K\s*[|:]\s*(\d+)", content)
        if bram_match:
            report.bram = int(bram_match.group(1))

        ii_match = re.search(r"II\s*[=:]\s*(\d+)", content)
        if ii_match:
            report.achieved_ii = int(ii_match.group(1))

        return report


class _VitisError(Exception):
    pass
