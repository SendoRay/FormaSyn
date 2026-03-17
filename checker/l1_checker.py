"""L1 Checker: second-level verification via Vitis HLS C simulation.

Runs the generated HLS C++ through ``v++ --mode hls --csim`` with a generated
testbench, then compares the simulated outputs against the golden model.

Metric dispatch by kernel_type:
  - channel_coding  -> sign_error_rate, snr_penalty_db
  - filtering       -> nmse_db
  - transform       -> nmse_db
  - detection       -> nmse_db
  - sync            -> nmse_db
"""

from __future__ import annotations

import logging
import math
import os
import re
import subprocess
import tempfile
from dataclasses import dataclass, field
from typing import Optional

import numpy as np

from FormaSyn.checker.diagnostic import (
    FailureContext,
    diagnose_compile_error,
    diagnose_numeric_error,
)

logger = logging.getLogger(__name__)

_DEFAULT_PART = "xc7z020clg400-1"
_DEFAULT_CLOCK = "10ns"
_OUTPUT_PREFIX = "@@OUTPUT "


@dataclass
class L1Result:
    """Result of the L1 csim verification."""

    variant_id: str
    passed: bool = False
    compile_ok: bool = False
    metrics: dict[str, float] = field(default_factory=dict)
    failure: Optional[FailureContext] = None
    golden_outputs: dict[str, list[float]] = field(default_factory=dict)
    hls_outputs: dict[str, list[float]] = field(default_factory=dict)


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

    def check(
        self,
        hls_cpp_code: str,
        golden_outputs: dict[str, list[float]],
        test_inputs: dict[str, list[float]],
        variant_id: str,
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> L1Result:
        """Run L1 verification on generated HLS C++ code."""
        result = L1Result(variant_id=variant_id, golden_outputs=golden_outputs)

        try:
            hls_outputs = self._run_csim(
                hls_cpp_code, test_inputs, golden_outputs, csr_data
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

    def _run_csim(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, list[float]]:
        """Run ``v++ --csim`` and parse printed output vectors."""
        if not self._vitis_available():
            raise _CompileError("v++ not found on PATH")

        function_name = self._extract_function_name(hls_cpp_code)
        testbench = self._generate_testbench(
            hls_cpp_code, test_inputs, golden_outputs, csr_data
        )

        tmp_dir = tempfile.mkdtemp(prefix="formasyn_l1_")
        src_name = f"{function_name}.cpp"
        tb_name = f"{function_name}_tb.cpp"
        cfg_name = "hls_config.cfg"
        work_dir = os.path.join(tmp_dir, "work")
        src_path = os.path.join(tmp_dir, src_name)
        tb_path = os.path.join(tmp_dir, tb_name)
        cfg_path = os.path.join(tmp_dir, cfg_name)

        with open(src_path, "w", encoding="utf-8") as f:
            f.write(hls_cpp_code)
        with open(tb_path, "w", encoding="utf-8") as f:
            f.write(testbench)
        with open(cfg_path, "w", encoding="utf-8") as f:
            f.write(self._generate_hls_config(function_name, src_name, tb_name))

        proc = subprocess.run(
            [
                "v++",
                "-c",
                "--mode",
                "hls",
                "--config",
                cfg_path,
                "--work_dir",
                work_dir,
                "--csim",
            ],
            capture_output=True,
            text=True,
            cwd=tmp_dir,
            timeout=600,
        )

        combined = "\n".join(
            chunk for chunk in (proc.stdout, proc.stderr) if chunk
        ).strip()
        report_text = self._read_csim_report(work_dir, function_name)
        parse_text = "\n".join(chunk for chunk in (combined, report_text) if chunk)

        if proc.returncode != 0:
            raise _CompileError(parse_text or "v++ csim failed")

        outputs = _parse_output(parse_text)
        if not outputs:
            raise _CompileError("CSim completed but produced no @@OUTPUT records")
        return outputs

    @staticmethod
    def _vitis_available() -> bool:
        try:
            proc = subprocess.run(
                ["v++", "--version"],
                capture_output=True,
                text=True,
                timeout=10,
            )
        except (FileNotFoundError, subprocess.TimeoutExpired):
            return False
        return proc.returncode == 0

    def _compute_metrics(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> dict[str, float]:
        """Compute quality metrics based on kernel_type."""
        if self._kernel_type == "channel_coding":
            return self._channel_coding_metrics(golden, actual)
        return self._nmse_metrics(golden, actual)

    def _channel_coding_metrics(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> dict[str, float]:
        """Compute sign_error_rate and snr_penalty_db."""
        sign_errors = 0
        total_elements = 0
        power_signal = 0.0
        power_noise = 0.0

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))
            g, a = g[:min_len], a[:min_len]

            sign_errors += int(np.sum(np.sign(g) != np.sign(a)))
            total_elements += min_len
            power_signal += float(np.sum(g ** 2))
            power_noise += float(np.sum((g - a) ** 2))

        sign_error_rate = sign_errors / max(total_elements, 1)

        if power_noise > 0 and power_signal > 0:
            snr_golden = 10 * math.log10(power_signal / 1e-10)
            snr_actual = 10 * math.log10(power_signal / max(power_noise, 1e-30))
            snr_penalty_db = max(0.0, snr_golden - snr_actual)
        else:
            snr_penalty_db = 0.0

        return {
            "sign_error_rate": sign_error_rate,
            "snr_penalty_db": snr_penalty_db,
        }

    def _nmse_metrics(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> dict[str, float]:
        """Compute NMSE in dB for filtering/transform/detection/sync."""
        power_signal = 0.0
        power_noise = 0.0

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))
            g, a = g[:min_len], a[:min_len]

            power_signal += float(np.sum(g ** 2))
            power_noise += float(np.sum((g - a) ** 2))

        if power_signal < 1e-30:
            nmse_db = 0.0
        else:
            nmse_db = 10 * math.log10(max(power_noise, 1e-30) / power_signal)
        return {"nmse_db": nmse_db}

    def _check_thresholds(self, metrics: dict[str, float]) -> bool:
        """Return True if all metrics are within tolerance."""
        for metric, threshold in self._tolerance.items():
            actual = metrics.get(metric)
            if actual is None:
                continue
            if actual > threshold:
                return False
        return True

    def _generate_testbench(
        self,
        hls_cpp: str,
        inputs: dict[str, list[float]],
        golden: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> str:
        """Generate a standalone Vitis HLS csim testbench."""
        preamble = self._extract_preamble(hls_cpp)
        signature = self._extract_function_signature(hls_cpp)
        param_types = self._extract_param_types(signature)

        lines = [
            "#include <cstdio>",
            "#include <cmath>",
            preamble.rstrip(),
            "",
            signature + ";",
            "",
            "int main() {",
        ]

        for name, values in inputs.items():
            dtype = param_types.get(name, "double")
            arr_str = ", ".join(self._format_literal(v, dtype) for v in values)
            lines.append(f"    {dtype} {name}[] = {{{arr_str}}};")

        for name, values in golden.items():
            dtype = param_types.get(name, "double")
            arr_str = ", ".join(self._format_literal(v, "double") for v in values)
            lines.append(f"    double golden_{name}[] = {{{arr_str}}};")
            lines.append(f"    {dtype} {name}[{len(values)}] = {{0}};")

        if csr_data is not None:
            rp = ", ".join(str(x) for x in csr_data["row_ptr"])
            ci = ", ".join(str(x) for x in csr_data["col_idx"])
            lines.append(f"    int row_ptr[] = {{{rp}}};")
            lines.append(f"    int col_idx[] = {{{ci}}};")

        args: list[str] = list(inputs.keys()) + list(golden.keys())
        if csr_data is not None:
            args.extend(["row_ptr", "col_idx"])
        lines.append(f"    {self._extract_function_name(hls_cpp)}({', '.join(args)});")
        lines.append("")
        lines.append("    int mismatch_count = 0;")

        for name, values in golden.items():
            lines.append(f'    printf("{_OUTPUT_PREFIX}{name}:");')
            lines.append(f"    for (int i = 0; i < {len(values)}; i++) {{")
            lines.append("        if (i > 0) printf(\",\");")
            lines.append(f'        printf("%.17g", (double){name}[i]);')
            lines.append(
                f"        mismatch_count += (std::fabs((double){name}[i] - golden_{name}[i]) > 1e-9);"
            )
            lines.append("    }")
            lines.append('    printf("\\n");')

        lines.append('    printf("@@MISMATCH %d\\n", mismatch_count);')
        lines.append("    return 0;")
        lines.append("}")
        return "\n".join(lines) + "\n"

    def _generate_hls_config(
        self,
        function_name: str,
        src_name: str,
        tb_name: str,
    ) -> str:
        """Generate the ``v++ --mode hls`` config file used for csim."""
        return (
            f"part={self._part}\n\n"
            "[hls]\n"
            f"clock={self._clock}\n"
            "flow_target=vitis\n"
            f"syn.top={function_name}\n"
            f"syn.file={src_name}\n"
            f"tb.file={tb_name}\n"
        )

    @staticmethod
    def _read_csim_report(work_dir: str, function_name: str) -> str:
        """Read the csim report log when it exists."""
        report_path = os.path.join(
            work_dir, "hls", "csim", "report", f"{function_name}_csim.log"
        )
        if not os.path.isfile(report_path):
            return ""
        with open(report_path, "r", encoding="utf-8") as f:
            return f.read()

    @staticmethod
    def _extract_function_name(code: str) -> str:
        """Extract the top-level function name from the C++ source."""
        match = re.search(r"\bvoid\s+([A-Za-z_]\w*)\s*\(", code)
        if match:
            return match.group(1)
        return "kernel"

    @staticmethod
    def _extract_function_signature(code: str) -> str:
        """Extract the complete top-level function signature."""
        match = re.search(r"(void\s+[A-Za-z_]\w*\s*\([\s\S]*?\))\s*\{", code)
        if not match:
            raise _CompileError("Unable to extract function signature from HLS C++")
        return match.group(1).strip()

    @staticmethod
    def _extract_preamble(code: str) -> str:
        """Return the includes/typedef section before the function body."""
        signature = L1Checker._extract_function_signature(code)
        idx = code.find(signature)
        if idx == -1:
            raise _CompileError("Unable to extract HLS preamble")
        return code[:idx].rstrip()

    @staticmethod
    def _extract_param_types(signature: str) -> dict[str, str]:
        """Map parameter names to their declared types."""
        params_str = signature[signature.find("(") + 1: signature.rfind(")")]
        params = L1Checker._split_params(params_str)
        param_types: dict[str, str] = {}
        for param in params:
            array_match = re.match(r"(.+?)\s+([A-Za-z_]\w*)\s*\[\s*\d+\s*\]$", param)
            if array_match:
                param_types[array_match.group(2)] = array_match.group(1).strip()
                continue
            ptr_match = re.match(r"(.+?)\s+([A-Za-z_]\w*)$", param)
            if ptr_match:
                param_types[ptr_match.group(2)] = ptr_match.group(1).strip()
        return param_types

    @staticmethod
    def _split_params(params_str: str) -> list[str]:
        """Split parameters while preserving template commas."""
        params: list[str] = []
        current: list[str] = []
        depth = 0

        for ch in params_str:
            if ch == "<":
                depth += 1
            elif ch == ">" and depth > 0:
                depth -= 1

            if ch == "," and depth == 0:
                param = "".join(current).strip()
                if param:
                    params.append(param)
                current = []
                continue
            current.append(ch)

        tail = "".join(current).strip()
        if tail:
            params.append(tail)
        return params

    @staticmethod
    def _format_literal(value: float, dtype: str) -> str:
        """Format a literal for inclusion in the generated testbench."""
        if dtype in {"double", "float"}:
            return f"{value:.17g}"
        if float(value).is_integer():
            return f"({dtype}){int(value)}"
        return f"({dtype})({value:.17g})"


class _CompileError(Exception):
    pass


def _parse_output(stdout: str) -> dict[str, list[float]]:
    """Parse ``@@OUTPUT name:v0,v1,...`` lines."""
    result: dict[str, list[float]] = {}
    for line in stdout.strip().splitlines():
        line = line.strip()
        if not line.startswith(_OUTPUT_PREFIX):
            continue
        payload = line[len(_OUTPUT_PREFIX):]
        if ":" not in payload:
            continue
        name, values_str = payload.split(":", 1)
        name = name.strip()
        if not values_str.strip():
            result[name] = []
            continue
        result[name] = [float(v) for v in values_str.split(",") if v]
    return result
