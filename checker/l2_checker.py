"""L2 Checker: Vitis HLS csynth resource/timing verification.

Uses the same flow as ``vitis_hls_test``:
``v++ -c --mode hls --config hls_config.cfg --work_dir work``.
"""

from __future__ import annotations

import logging
import os
import re
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from dataclasses import dataclass
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
    """L2 verification via Vitis HLS csynth.

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
        """Run Vitis HLS csynth on the generated code.

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
            logger.info("v++ 不可用，跳过 L2 验证 [%s]", variant_id)
            result.skipped = True
            result.passed = True
            return result

        try:
            synth = self._run_csynth(
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
        """Check if v++ command is on PATH."""
        try:
            subprocess.run(
                ["v++", "--version"],
                capture_output=True, text=True, timeout=10,
            )
            return True
        except (
            FileNotFoundError,
            NotADirectoryError,
            PermissionError,
            subprocess.TimeoutExpired,
            OSError,
        ):
            return False

    def _run_csynth(
        self,
        cpp_code: str,
        header_code: str,
        function_name: str,
        variant_id: str,
    ) -> SynthReport:
        """Run ``v++ --mode hls`` csynth and parse the synthesis report."""
        work_dir = tempfile.mkdtemp(prefix="formasyn_l2_")
        src_path = os.path.join(work_dir, f"{function_name}.cpp")
        hdr_path = os.path.join(work_dir, f"{function_name}.h")
        cfg_path = os.path.join(work_dir, "hls_config.cfg")
        vpp_work_dir = os.path.join(work_dir, "work")

        with open(src_path, "w", encoding="utf-8") as f:
            f.write(cpp_code)
        with open(hdr_path, "w", encoding="utf-8") as f:
            f.write(header_code)
        with open(cfg_path, "w", encoding="utf-8") as f:
            f.write(self._generate_hls_config(function_name, src_path))

        cmd = [
            "v++",
            "-c",
            "--mode",
            "hls",
            "--config",
            cfg_path,
            "--work_dir",
            vpp_work_dir,
        ]
        try:
            proc = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                cwd=work_dir,
                timeout=1200,
            )
        except (FileNotFoundError, NotADirectoryError, PermissionError, OSError) as exc:
            raise _VitisError(str(exc)) from exc
        if proc.returncode != 0:
            raise _VitisError(proc.stderr or proc.stdout or "v++ csynth failed")

        return self._parse_csynth_report(vpp_work_dir)

    def _generate_hls_config(
        self,
        function_name: str,
        src_path: str,
    ) -> str:
        """Generate ``hls_config.cfg`` for the v++ HLS flow."""
        clock_ns = round(1000.0 / self._clock_mhz, 2)
        return (
            "part=xc7z020clg400-1\n\n"
            "[hls]\n"
            f"clock={clock_ns}ns\n"
            "flow_target=vitis\n"
            f"syn.top={function_name}\n"
            f"syn.file={src_path}\n"
        )

    @staticmethod
    def _parse_csynth_report(work_dir: str) -> SynthReport:
        """Parse csynth XML report from ``work/hls/syn/report``."""
        report = SynthReport()
        rpt_dir = os.path.join(work_dir, "hls", "syn", "report")
        xml_path = os.path.join(rpt_dir, "csynth.xml")
        txt_path = os.path.join(rpt_dir, "csynth.rpt")

        if os.path.isfile(xml_path):
            try:
                tree = ET.parse(xml_path)
                root = tree.getroot()
                report.bram = int(root.findtext(".//AreaEstimates/Resources/BRAM_18K", "0"))
                report.dsp = int(root.findtext(".//AreaEstimates/Resources/DSP", "0"))
                report.ff = int(root.findtext(".//AreaEstimates/Resources/FF", "0"))
                report.lut = int(root.findtext(".//AreaEstimates/Resources/LUT", "0"))
                report.achieved_ii = int(
                    root.findtext(".//PerformanceEstimates/SummaryOfOverallLatency/Interval-max", "1")
                )
                report.clock_period_ns = float(
                    root.findtext(".//PerformanceEstimates/SummaryOfTimingAnalysis/EstimatedClockPeriod", "0.0")
                )
                return report
            except (ET.ParseError, ValueError) as exc:
                logger.warning("解析 csynth.xml 失败，回退到文本报告: %s", exc)

        if not os.path.isfile(txt_path):
            logger.warning("综合报告不存在: %s", txt_path)
            return report

        with open(txt_path, "r", encoding="utf-8") as f:
            content = f.read()

        dsp_match = re.search(r"\|\s*\+\s*kernel\s*\|.*?\|\s*(\d+|-)\s*\|", content)
        if dsp_match and dsp_match.group(1).isdigit():
            report.dsp = int(dsp_match.group(1))

        bram_match = re.search(r"\|\s*\+\s*kernel\s*\|.*?\|\s*(\d+|-)\s*\|\s*(\d+|-)\s*\|", content)
        if bram_match and bram_match.group(1).isdigit():
            report.bram = int(bram_match.group(1))

        ii_match = re.search(r"\|\s*\+\s*kernel\s*\|.*?\|\s*(\d+)\s*\|", content)
        if ii_match:
            report.achieved_ii = int(ii_match.group(1))

        return report


class _VitisError(Exception):
    pass
