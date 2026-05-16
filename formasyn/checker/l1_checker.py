"""L1 Checker: Vitis HLS C simulation + numeric verification.

Runs the generated HLS C++ through Vitis HLS C simulation (prefer
``vitis-run --mode hls --csim``; fallback to legacy ``v++ --mode hls --csim``)
with a generated testbench, then compares simulated outputs against golden.

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
import subprocess
import tempfile
from typing import Optional

from .diagnostic import (
    diagnose_compile_error,
    diagnose_numeric_error,
)
from .metrics import L1Result
from ..golden.testbench_gen import TestbenchGenerator, parse_output
from ..utils.cpp_utils import extract_function_name
from ..utils.hls_mock import (
    strip_hls_pragmas,
    tool_available,
    vitis_available,
    write_mock_headers,
)
from ..utils.metrics import compute_nmse, compute_sign_error_rate

logger = logging.getLogger(__name__)

_DEFAULT_PART = "xc7z020clg400-1"
_DEFAULT_CLOCK = "10ns"


class L1Checker:
    """L1 verification: Vitis HLS C simulation + numeric comparison."""

    def __init__(
        self,
        kernel_type: str = "channel_coding",
        tolerance: Optional[dict[str, float]] = None,
        *,
        part: str = _DEFAULT_PART,
        clock: str = _DEFAULT_CLOCK,
    ) -> None:
        self._kernel_type = kernel_type
        self._tolerance = tolerance or {}
        self._part = part
        self._clock = clock
        self._tb_gen = TestbenchGenerator()

    def check(
        self,
        hls_cpp_code: str,
        golden_outputs: dict[str, list[float]],
        test_inputs: dict[str, list[float]],
        variant_id: str,
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
        prepared_dir: Optional[str] = None,
    ) -> L1Result:
        """Run L1 verification on generated HLS C++ code.

        Args:
            hls_cpp_code: Generated HLS C++ source.
            golden_outputs: Golden reference outputs.
            test_inputs: Test input vectors.
            variant_id: Variant identifier.
            csr_data: Optional CSR data for irregular-access kernels.
            prepared_dir: Pre-prepared directory with config, testbench, etc.
        """
        result = L1Result(variant_id=variant_id, golden_outputs=golden_outputs)

        try:
            hls_outputs = self._run_csim(
                hls_cpp_code, test_inputs, golden_outputs, csr_data,
                prepared_dir=prepared_dir,
            )
        except _CompileError as exc:
            result.compile_ok = False
            result.failure = diagnose_compile_error(str(exc), variant_id)
            logger.warning("L1 CSim 失败 [%s]: %s", variant_id, str(exc)[:200])
            return result

        result.compile_ok = True
        result.hls_outputs = hls_outputs
        result.metrics = self._compute_metrics(golden_outputs, hls_outputs)
        result.passed = self._check_thresholds(result.metrics)

        if not result.passed:
            result.failure = diagnose_numeric_error(
                variant_id, result.metrics, self._tolerance, self._kernel_type
            )
            logger.warning(
                "L1 数值验证失败 [%s]: %s",
                variant_id,
                result.failure.gap_description,
            )
        else:
            logger.info("L1 通过 [%s]: metrics=%s", variant_id, result.metrics)

        return result

    # -- CSim ----------------------------------------------------------------

    def _run_csim(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
        prepared_dir: Optional[str] = None,
    ) -> dict[str, list[float]]:
        """Run HLS C simulation and parse printed output vectors."""
        if not vitis_available():
            raise _CompileError("Neither vitis-run nor v++ found on PATH")

        function_name = extract_function_name(hls_cpp_code)

        if prepared_dir:
            base_dir = prepared_dir
            src_name = f"{function_name}.cpp"
            tb_name = f"{function_name}_tb.cpp"
            cfg_name = "hls_config.cfg"
            work_dir = os.path.join(base_dir, "work")
            src_path = os.path.join(base_dir, src_name)
            tb_path = os.path.join(base_dir, tb_name)
            cfg_path = os.path.join(base_dir, cfg_name)
        else:
            base_dir = tempfile.mkdtemp(prefix="formasyn_l1_")
            src_name = f"{function_name}.cpp"
            tb_name = f"{function_name}_tb.cpp"
            cfg_name = "hls_config.cfg"
            work_dir = os.path.join(base_dir, "work")
            src_path = os.path.join(base_dir, src_name)
            tb_path = os.path.join(base_dir, tb_name)
            cfg_path = os.path.join(base_dir, cfg_name)

        if not os.path.exists(src_path):
            with open(src_path, "w", encoding="utf-8") as f:
                f.write(hls_cpp_code)

        if not os.path.exists(tb_path):
            testbench = self._tb_gen.generate(
                hls_cpp_code, test_inputs, golden_outputs, csr_data=csr_data,
            )
            with open(tb_path, "w", encoding="utf-8") as f:
                f.write(testbench)

        if not os.path.exists(os.path.join(base_dir, "kernel.h")):
            _ensure_local_kernel_header(hls_cpp_code, base_dir)

        if not os.path.exists(cfg_path):
            with open(cfg_path, "w", encoding="utf-8") as f:
                f.write(self._tb_gen.generate_hls_config(
                    function_name, src_name, tb_name,
                    part=self._part, clock=self._clock,
                ))

        cmd = self._build_csim_cmd(cfg_path, work_dir)
        logger.info("L1 CSim 开始执行 [%s]: %s (timeout=600s)", function_name, " ".join(cmd))
        proc = subprocess.run(
            cmd, capture_output=True, text=True, cwd=base_dir, timeout=600,
        )
        logger.info("L1 CSim 执行完成 [%s]: returncode=%d", function_name, proc.returncode)

        combined = "\n".join(
            chunk for chunk in (proc.stdout, proc.stderr) if chunk
        ).strip()
        report_text = _read_csim_report(work_dir, function_name)
        parse_text = "\n".join(chunk for chunk in (combined, report_text) if chunk)

        if proc.returncode != 0:
            raise _CompileError(parse_text or "HLS csim failed")

        outputs = parse_output(parse_text)
        if not outputs:
            raise _CompileError("CSim completed but produced no @@OUTPUT records")
        return outputs

    def _build_csim_cmd(self, cfg_path: str, work_dir: str) -> list[str]:
        """Build a command for HLS C simulation across Vitis versions."""
        if tool_available("vitis-run"):
            return [
                "vitis-run", "--mode", "hls", "--csim",
                "--config", cfg_path, "--work_dir", work_dir,
            ]
        return [
            "v++", "-c", "--mode", "hls",
            "--config", cfg_path, "--work_dir", work_dir, "--csim",
        ]

    # -- Host simulation (fallback) ------------------------------------------

    def _run_host_sim(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, list[float]]:
        """Run host-only simulation via g++ with lightweight HLS header mocks."""
        if not _gpp_available():
            raise _CompileError("v++ not found and g++ not found on PATH")

        clean = strip_hls_pragmas(hls_cpp_code)
        testbench = self._tb_gen.generate(
            clean, test_inputs, golden_outputs, csr_data=csr_data,
        )
        stdout = self._compile_and_run(clean, testbench)
        outputs = parse_output(stdout)
        if not outputs:
            raise _CompileError("Host simulation completed but produced no @@OUTPUT records")
        return outputs

    def _compile_and_run(self, hls_cpp_code: str, testbench_code: str) -> str:
        """Compile kernel + testbench with g++ and return stdout."""
        with tempfile.TemporaryDirectory(prefix="formasyn_hostsim_") as tmpdir:
            kernel_path = os.path.join(tmpdir, "kernel.cpp")
            tb_path = os.path.join(tmpdir, "kernel_tb.cpp")
            exe_path = os.path.join(tmpdir, "sim.out")

            with open(kernel_path, "w", encoding="utf-8") as f:
                f.write(hls_cpp_code)
            with open(tb_path, "w", encoding="utf-8") as f:
                f.write(testbench_code)

            write_mock_headers(tmpdir)

            try:
                proc = subprocess.run(
                    ["g++", "-std=c++14", "-O2", f"-I{tmpdir}", kernel_path, tb_path, "-o", exe_path],
                    capture_output=True, text=True,
                )
            except FileNotFoundError as exc:
                raise _CompileError("g++ not found on PATH") from exc
            if proc.returncode != 0:
                raise _CompileError(proc.stderr.strip() or "g++ compile failed")

            try:
                run_proc = subprocess.run([exe_path], capture_output=True, text=True)
            except FileNotFoundError as exc:
                raise _CompileError("host simulator binary not found") from exc
            if run_proc.returncode != 0:
                raise _CompileError(run_proc.stderr.strip() or "host simulation failed")

            return run_proc.stdout

    # -- 指标计算 (委托给共享工具模块) -----------------------------------------

    def _compute_metrics(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> dict[str, float]:
        """Compute quality metrics based on kernel_type."""
        if self._kernel_type == "channel_coding":
            ser, snr, _ = compute_sign_error_rate(golden, actual)
            return {"sign_error_rate": ser, "snr_penalty_db": snr}
        return {"nmse_db": compute_nmse(golden, actual)}

    def _check_thresholds(self, metrics: dict[str, float]) -> bool:
        """Return True if all metrics are within tolerance."""
        for metric, threshold in self._tolerance.items():
            actual = metrics.get(metric)
            if actual is None:
                continue
            if actual > threshold:
                return False
        return True


# -- 模块级工具函数 ------------------------------------------------------------

class _CompileError(Exception):
    pass


def _ensure_local_kernel_header(hls_cpp_code: str, out_dir: str) -> None:
    """Generate ``kernel.h`` when source/testbench includes it."""
    if '#include "kernel.h"' not in hls_cpp_code:
        return

    from ..utils.cpp_utils import extract_function_signature

    signature = extract_function_signature(hls_cpp_code)
    header_lines = [
        "#pragma once",
        "",
        "#include <ap_int.h>",
        "#include <ap_fixed.h>",
        "",
        signature + ";",
        "",
    ]
    header = "\n".join(header_lines)
    with open(os.path.join(out_dir, "kernel.h"), "w", encoding="utf-8") as f:
        f.write(header)


def _read_csim_report(work_dir: str, function_name: str) -> str:
    """Read the csim report log when it exists."""
    report_path = os.path.join(
        work_dir, "hls", "csim", "report", f"{function_name}_csim.log"
    )
    if not os.path.isfile(report_path):
        return ""
    with open(report_path, "r", encoding="utf-8") as f:
        return f.read()


def _gpp_available() -> bool:
    """Check if g++ is available."""
    import shutil
    return shutil.which("g++") is not None
