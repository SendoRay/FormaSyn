from __future__ import annotations

import os
import subprocess
import tempfile

from FormaSyn.checker.l1_checker import L1Checker, _parse_output


_SIMPLE_HLS = """\
#include <ap_int.h>
#include <ap_fixed.h>

typedef double data_t;

void kernel(
    data_t x[2],
    data_t y[2]
) {
    #pragma HLS PIPELINE II=1
    for (int i = 0; i < 2; i++) {
        y[i] = x[i] * 2;
    }
}
"""


def test_generate_hls_config_contains_csim_inputs() -> None:
    checker = L1Checker()
    cfg = checker._generate_hls_config("kernel", "kernel.cpp", "kernel_tb.cpp")

    assert "flow_target=vitis" in cfg
    assert "syn.top=kernel" in cfg
    assert "syn.file=kernel.cpp" in cfg
    assert "tb.file=kernel_tb.cpp" in cfg


def test_generate_testbench_uses_output_marker_and_golden() -> None:
    checker = L1Checker()
    tb = checker._generate_testbench(
        _SIMPLE_HLS,
        {"x": [1.0, -2.0]},
        {"y": [2.0, -4.0]},
        None,
    )

    assert "@@OUTPUT y:" in tb
    assert "double golden_y[]" in tb
    assert "kernel(x, y);" in tb


def test_parse_output_reads_only_marked_lines() -> None:
    parsed = _parse_output(
        "INFO: [SIM] start\n@@OUTPUT y:2,-4\nnoise:ignore\n@@OUTPUT z:1\n"
    )

    assert parsed == {"y": [2.0, -4.0], "z": [1.0]}


def test_extract_param_types_handles_template_commas() -> None:
    signature = """void kernel(
        ap_fixed<16,4> x[2],
        ap_int<8> y[2],
        const int* row_ptr
    )"""

    parsed = L1Checker._extract_param_types(signature)

    assert parsed["x"] == "ap_fixed<16,4>"
    assert parsed["y"] == "ap_int<8>"
    assert parsed["row_ptr"] == "const int*"


def test_check_runs_hls_csim(monkeypatch) -> None:
    checker = L1Checker(kernel_type="filtering", tolerance={"nmse_db": -60.0})
    calls: list[list[str]] = []

    def fake_run(cmd, capture_output, text, timeout=None, cwd=None):
        calls.append(cmd)
        if cmd == ["vitis-run", "--version"]:
            return subprocess.CompletedProcess(
                cmd, 0, stdout="vitis-run 2025.1", stderr=""
            )
        if cmd == ["v++", "--version"]:
            return subprocess.CompletedProcess(cmd, 0, stdout="v++ 2025.1", stderr="")
        if cmd[:5] == ["vitis-run", "--mode", "hls", "--csim", "--config"]:
            return subprocess.CompletedProcess(
                cmd,
                0,
                stdout="INFO: [SIM] start\n@@OUTPUT y:2,-4\n",
                stderr="",
            )
        raise AssertionError(f"Unexpected command: {cmd}")

    monkeypatch.setattr("FormaSyn.checker.l1_checker.subprocess.run", fake_run)

    result = checker.check(
        _SIMPLE_HLS,
        {"y": [2.0, -4.0]},
        {"x": [1.0, -2.0]},
        "variant_0",
    )

    assert result.compile_ok is True
    assert result.passed is True
    assert result.hls_outputs == {"y": [2.0, -4.0]}
    assert any(
        cmd[:4] == ["vitis-run", "--mode", "hls", "--csim"] for cmd in calls
    )


def test_build_csim_cmd_falls_back_to_vpp(monkeypatch) -> None:
    checker = L1Checker()

    def fake_tool_available(tool: str) -> bool:
        return tool == "v++"

    monkeypatch.setattr(checker, "_tool_available", fake_tool_available)
    cmd = checker._build_csim_cmd("hls_config.cfg", "work")

    assert cmd[:4] == ["v++", "-c", "--mode", "hls"]
    assert "--csim" in cmd


def test_ensure_local_kernel_header_generates_stub() -> None:
    checker = L1Checker()
    source = """\
#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> x[2],
    ap_int<8> y[2]
) {
    for (int i = 0; i < 2; ++i) {
        y[i] = x[i];
    }
}
"""
    with tempfile.TemporaryDirectory() as tmpdir:
        checker._ensure_local_kernel_header(source, tmpdir)
        header_path = os.path.join(tmpdir, "kernel.h")

        assert os.path.exists(header_path)
        content = open(header_path, "r", encoding="utf-8").read()
        assert "#pragma once" in content
        assert "#include <ap_int.h>" in content
        assert "void kernel(" in content


def test_check_reports_missing_hls_tools(monkeypatch) -> None:
    checker = L1Checker()

    def fake_run(cmd, capture_output, text, timeout=None, cwd=None):
        raise FileNotFoundError

    monkeypatch.setattr("FormaSyn.checker.l1_checker.subprocess.run", fake_run)

    result = checker.check(
        _SIMPLE_HLS,
        {"y": [2.0, -4.0]},
        {"x": [1.0, -2.0]},
        "variant_missing_vpp",
    )

    assert result.compile_ok is False
    assert result.failure is not None
    assert "Neither vitis-run nor v++ found" in result.failure.raw_error
