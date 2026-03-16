"""L1 Checker: second-level software verification (no EDA dependency).

Compiles the generated HLS C++ with g++, loads it via ctypes, injects
test vectors, and compares against the Golden Model output.

Metric dispatch by kernel_type:
  - channel_coding  → sign_error_rate, snr_penalty_db
  - filtering       → nmse_db
  - transform       → nmse_db
  - detection       → nmse_db
  - sync            → nmse_db
"""

from __future__ import annotations

import ctypes
import logging
import math
import os
import platform
import subprocess
import tempfile
from dataclasses import dataclass, field
from typing import Optional

import numpy as np

from FormaSyn.checker.diagnostic import (
    FailureContext,
    FailureStage,
    diagnose_compile_error,
    diagnose_numeric_error,
)

logger = logging.getLogger(__name__)


@dataclass
class L1Result:
    """Result of the L1 software verification.

    Attributes:
        variant_id: Identifier of the variant under test.
        passed: Whether all numeric checks passed.
        compile_ok: Whether g++ compilation succeeded.
        metrics: Computed quality metrics (kernel_type dependent).
        failure: Structured failure context if the check failed.
        golden_outputs: Reference output from the golden model.
        hls_outputs: Output from the generated HLS code.
    """
    variant_id: str
    passed: bool = False
    compile_ok: bool = False
    metrics: dict[str, float] = field(default_factory=dict)
    failure: Optional[FailureContext] = None
    golden_outputs: dict[str, list[float]] = field(default_factory=dict)
    hls_outputs: dict[str, list[float]] = field(default_factory=dict)


class L1Checker:
    """L1 software-only verification: g++ compile + numeric comparison.

    Args:
        kernel_type: One of 'channel_coding', 'filtering', 'transform',
            'detection', 'sync'.
        tolerance: Metric thresholds (e.g. {'sign_error_rate': 0.01}).
    """

    def __init__(
        self,
        kernel_type: str = "channel_coding",
        tolerance: Optional[dict[str, float]] = None,
    ) -> None:
        self._kernel_type = kernel_type
        self._tolerance = tolerance or {}

    def check(
        self,
        hls_cpp_code: str,
        golden_outputs: dict[str, list[float]],
        test_inputs: dict[str, list[float]],
        variant_id: str,
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> L1Result:
        """Run L1 verification on generated HLS C++ code.

        Args:
            hls_cpp_code: The generated HLS C++ source code.
            golden_outputs: Reference outputs from the golden model.
            test_inputs: Test input vectors.
            variant_id: Variant identifier for diagnostics.
            csr_data: Optional CSR data for irregular-access kernels.

        Returns:
            L1Result with pass/fail status and metrics.
        """
        result = L1Result(variant_id=variant_id, golden_outputs=golden_outputs)

        testbench = self._generate_testbench(
            hls_cpp_code, test_inputs, golden_outputs, csr_data
        )

        try:
            hls_outputs = self._compile_and_run(testbench)
        except _CompileError as e:
            result.compile_ok = False
            result.failure = diagnose_compile_error(str(e), variant_id)
            logger.warning("L1 编译失败 [%s]: %s", variant_id, str(e)[:200])
            return result

        result.compile_ok = True
        result.hls_outputs = hls_outputs

        metrics = self._compute_metrics(golden_outputs, hls_outputs)
        result.metrics = metrics

        passed = self._check_thresholds(metrics)
        result.passed = passed

        if not passed:
            result.failure = diagnose_numeric_error(
                variant_id, metrics, self._tolerance, self._kernel_type
            )
            logger.warning(
                "L1 数值验证失败 [%s]: %s", variant_id, result.failure.gap_description
            )
        else:
            logger.info("L1 通过 [%s]: metrics=%s", variant_id, metrics)

        return result

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

            sign_g = np.sign(g)
            sign_a = np.sign(a)
            sign_errors += int(np.sum(sign_g != sign_a))
            total_elements += min_len

            power_signal += float(np.sum(g ** 2))
            noise = g - a
            power_noise += float(np.sum(noise ** 2))

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
            if metric == "nmse_db":
                if actual > threshold:
                    return False
            else:
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
        """Generate a standalone C++ testbench that wraps the HLS function.

        Strips HLS-specific headers/pragmas so the code compiles with g++.
        """
        clean = self._strip_hls_specifics(hls_cpp)

        lines = [
            "#include <cmath>",
            "#include <cstdio>",
            "#include <algorithm>",
            "",
            clean,
            "",
            "int main() {",
        ]

        for name, values in inputs.items():
            arr_str = ", ".join(f"{v:.17g}" for v in values)
            lines.append(f"    double {name}[] = {{{arr_str}}};")

        for name, values in golden.items():
            size = len(values)
            lines.append(f"    double {name}[{size}] = {{0}};")

        if csr_data is not None:
            rp = ", ".join(str(x) for x in csr_data["row_ptr"])
            ci = ", ".join(str(x) for x in csr_data["col_idx"])
            lines.append(f"    int row_ptr[] = {{{rp}}};")
            lines.append(f"    int col_idx[] = {{{ci}}};")

        func_name = self._extract_function_name(clean)
        args: list[str] = list(inputs.keys())
        args.extend(golden.keys())
        if csr_data is not None:
            args.extend(["row_ptr", "col_idx"])
        lines.append(f"    {func_name}({', '.join(args)});")
        lines.append("")

        for name in golden:
            size = len(golden[name])
            lines.append(f'    printf("{name}:");')
            lines.append(f"    for (int i = 0; i < {size}; i++) {{")
            lines.append(f'        if (i > 0) printf(",");')
            lines.append(f'        printf("%.17g", (double){name}[i]);')
            lines.append("    }")
            lines.append('    printf("\\n");')

        lines.append("    return 0;")
        lines.append("}")
        return "\n".join(lines)

    @staticmethod
    def _strip_hls_specifics(code: str) -> str:
        """Remove HLS-only headers and pragmas so g++ can compile."""
        lines: list[str] = []
        for line in code.splitlines():
            stripped = line.strip()
            if stripped.startswith("#include <ap_"):
                continue
            if stripped.startswith("#include <hls_"):
                continue
            if stripped.startswith("#pragma HLS"):
                continue
            # Replace ap_int<N>/ap_fixed<N,I> types with int/double
            line = _replace_hls_types(line)
            lines.append(line)
        return "\n".join(lines)

    @staticmethod
    def _extract_function_name(code: str) -> str:
        """Extract the top-level function name from the C++ source."""
        for line in code.splitlines():
            if line.strip().startswith("void ") and "(" in line:
                name = line.split("void ")[1].split("(")[0].strip()
                return name
        return "kernel"

    @staticmethod
    def _compile_and_run(testbench: str) -> dict[str, list[float]]:
        """Compile with g++ and run, returning parsed outputs."""
        tmp_dir = tempfile.mkdtemp(prefix="formasyn_l1_")
        src = os.path.join(tmp_dir, "tb.cpp")
        exe = os.path.join(tmp_dir, "tb")
        if platform.system() == "Windows":
            exe += ".exe"

        with open(src, "w", encoding="utf-8") as f:
            f.write(testbench)

        result = subprocess.run(
            ["g++", "-O0", "-std=c++17", "-o", exe, src],
            capture_output=True, text=True,
        )
        if result.returncode != 0:
            raise _CompileError(result.stderr)

        run = subprocess.run([exe], capture_output=True, text=True)
        if run.returncode != 0:
            raise _CompileError(f"Runtime error: {run.stderr}")

        return _parse_output(run.stdout)


class _CompileError(Exception):
    pass


def _parse_output(stdout: str) -> dict[str, list[float]]:
    """Parse 'name:v0,v1,...' lines."""
    result: dict[str, list[float]] = {}
    for line in stdout.strip().splitlines():
        if ":" not in line:
            continue
        name, values_str = line.split(":", 1)
        name = name.strip()
        if not values_str.strip():
            result[name] = []
            continue
        result[name] = [float(v) for v in values_str.split(",")]
    return result


def _replace_hls_types(line: str) -> str:
    """Replace ap_int<N> and ap_fixed<N,I> types with plain C++ types."""
    import re
    line = re.sub(r'\bap_fixed<\d+,\d+>', 'double', line)
    line = re.sub(r'\bap_u?int<\d+>', 'int', line)
    line = re.sub(r'\bap_fixed_\d+_\d+_t\b', 'double', line)
    line = re.sub(r'\bap_int_\d+_t\b', 'int', line)
    line = re.sub(r'\bap_uint<\d+>', 'unsigned int', line)
    # Handle typedef lines that reference these
    line = re.sub(r'typedef\s+double\s+double;', '// (typedef elided)', line)
    return line
