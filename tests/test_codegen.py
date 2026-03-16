"""Tests for HLSCodeGenerator: HLSScheduleDialect → Vitis HLS C++ code."""

from __future__ import annotations

import shutil
import subprocess
import tempfile
import os

import pytest

from FormaSyn.codegen.hls_codegen import HLSCodeGenerator
from FormaSyn.ir.schedule_dialect import HLSScheduleDialect, ScheduleNode


# ---------------------------------------------------------------------------
# Shared fixture
# ---------------------------------------------------------------------------

@pytest.fixture
def ldpc_schedule() -> HLSScheduleDialect:
    """Return the built-in LDPC Min-Sum CNU example schedule."""
    return HLSScheduleDialect.example_ldpc_cnu()


@pytest.fixture
def generator() -> HLSCodeGenerator:
    return HLSCodeGenerator()


# ---------------------------------------------------------------------------
# generate() — structural checks
# ---------------------------------------------------------------------------

class TestGenerate:
    def test_returns_string(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert isinstance(code, str)
        assert len(code) > 0

    def test_contains_banner(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "[FormaSyn Generated Code]" in code
        assert "variant_id=min_sum_int8_p8" in code

    def test_contains_includes(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "#include <ap_int.h>" in code
        assert "#include <ap_fixed.h>" in code

    def test_contains_typedef(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "typedef" in code

    def test_function_name_default(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "void kernel(" in code

    def test_function_name_custom(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule, function_name="ldpc_cnu")
        assert "void ldpc_cnu(" in code

    def test_contains_input_param(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "msg_in[8]" in code

    def test_contains_output_params(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "xor_reduce[1]" in code
        assert "min_reduce[1]" in code


# ---------------------------------------------------------------------------
# Pragma checks (required by spec)
# ---------------------------------------------------------------------------

class TestPragmas:
    def test_pipeline_ii_pragma(self, generator, ldpc_schedule):
        """Spec requirement: output must contain '#pragma HLS PIPELINE II=1'."""
        code = generator.generate(ldpc_schedule)
        assert "#pragma HLS PIPELINE II=1" in code

    def test_array_partition_input(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "ARRAY_PARTITION variable=msg_in complete" in code

    def test_unroll_pragma_in_map(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "#pragma HLS UNROLL" in code


# ---------------------------------------------------------------------------
# Value Reuse Pattern checks (required by spec)
# ---------------------------------------------------------------------------

class TestMinSumValueReuse:
    def test_contains_min1_idx(self, generator, ldpc_schedule):
        """Spec requirement: output must contain 'min1_idx'."""
        code = generator.generate(ldpc_schedule)
        assert "min1_idx" in code

    def test_contains_out_mag_shift(self, generator, ldpc_schedule):
        """Spec requirement: output must contain 'out_mag >> 2'."""
        code = generator.generate(ldpc_schedule)
        assert "out_mag >> 2" in code

    def test_contains_min1_min2(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "min1" in code
        assert "min2" in code

    def test_value_reuse_comment(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "Min-Sum Value Reuse Pattern" in code

    def test_scale_comment(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "scale * 0.75" in code


# ---------------------------------------------------------------------------
# XOR reduce checks
# ---------------------------------------------------------------------------

class TestXorReduce:
    def test_xor_operator_present(self, generator, ldpc_schedule):
        code = generator.generate(ldpc_schedule)
        assert "^=" in code

    def test_address_mapping_injected(self, generator, ldpc_schedule):
        """The address_mapping_code snippet must appear inside the loop."""
        code = generator.generate(ldpc_schedule)
        assert "col_idx" in code


# ---------------------------------------------------------------------------
# generate_header()
# ---------------------------------------------------------------------------

class TestGenerateHeader:
    def test_returns_string(self, generator, ldpc_schedule):
        hdr = generator.generate_header(ldpc_schedule, "kernel")
        assert isinstance(hdr, str)

    def test_include_guard(self, generator, ldpc_schedule):
        hdr = generator.generate_header(ldpc_schedule, "kernel")
        assert "#ifndef FORMASYN_KERNEL_H" in hdr
        assert "#define FORMASYN_KERNEL_H" in hdr
        assert "#endif" in hdr

    def test_function_declaration(self, generator, ldpc_schedule):
        hdr = generator.generate_header(ldpc_schedule, "kernel")
        assert "void kernel(" in hdr
        assert hdr.rstrip().endswith(f"#endif  // FORMASYN_KERNEL_H")

    def test_contains_typedefs(self, generator, ldpc_schedule):
        hdr = generator.generate_header(ldpc_schedule, "kernel")
        assert "typedef" in hdr

    def test_no_function_body(self, generator, ldpc_schedule):
        """Header must have declaration (ending with ;), not a definition."""
        hdr = generator.generate_header(ldpc_schedule, "kernel")
        assert ");" in hdr
        # Must not contain opening brace of a function body
        # (exclude the #ifndef/#define lines which don't have braces)
        lines_with_brace = [
            l for l in hdr.splitlines()
            if "{" in l and not l.strip().startswith("#")
        ]
        assert len(lines_with_brace) == 0


# ---------------------------------------------------------------------------
# dtype helpers
# ---------------------------------------------------------------------------

class TestDtypeHelpers:
    def test_ap_int_alias(self, generator):
        assert generator._dtype_to_alias("ap_int<8>") == "ap_int_8_t"

    def test_ap_int_1_alias(self, generator):
        assert generator._dtype_to_alias("ap_int<1>") == "ap_int_1_t"

    def test_ap_fixed_alias(self, generator):
        assert generator._dtype_to_alias("ap_fixed<16,4>") == "ap_fixed_16_4_t"

    def test_float64_alias(self, generator):
        assert generator._dtype_to_alias("float64") == "double"

    def test_float64_hls(self, generator):
        assert generator._dtype_to_hls("float64") == "double"

    def test_ap_int_hls_passthrough(self, generator):
        assert generator._dtype_to_hls("ap_int<8>") == "ap_int<8>"


# ---------------------------------------------------------------------------
# Topological ordering
# ---------------------------------------------------------------------------

class TestTopoSort:
    def test_input_node_first(self, generator, ldpc_schedule):
        order = generator._topo_sort(ldpc_schedule)
        msg_in_idx = order.index("msg_in")
        sign_map_idx = order.index("sign_map")
        abs_map_idx = order.index("abs_map")
        assert msg_in_idx < sign_map_idx
        assert msg_in_idx < abs_map_idx

    def test_reduce_after_map(self, generator, ldpc_schedule):
        order = generator._topo_sort(ldpc_schedule)
        sign_map_idx = order.index("sign_map")
        xor_reduce_idx = order.index("xor_reduce")
        assert sign_map_idx < xor_reduce_idx


# ---------------------------------------------------------------------------
# Optional: g++ syntax check with mock headers
# ---------------------------------------------------------------------------

_MOCK_AP_INT_H = """\
// Minimal mock of Vitis HLS ap_int.h for syntax-only checking.
// Uses native integer aliases so all arithmetic/bitwise operators work.
#pragma once
#include <cstdint>
template<int W> using ap_int  = int;
template<int W> using ap_uint = unsigned int;
"""

_MOCK_AP_FIXED_H = """\
#pragma once
#include "ap_int.h"
template<int W, int I=0> using ap_fixed = float;
"""

_MOCK_HLS_STREAM_H = """\
#pragma once
template<typename T> struct hls_stream {};
"""


@pytest.mark.skipif(
    shutil.which("g++") is None,
    reason="g++ not found on PATH",
)
def test_syntax_check_with_gpp(generator, ldpc_schedule):
    """Compile-check with g++ using mock HLS headers (no real Vitis HLS needed)."""
    code = generator.generate(ldpc_schedule, function_name="kernel")

    with tempfile.TemporaryDirectory() as tmpdir:
        # Write mock headers
        for fname, content in [
            ("ap_int.h",     _MOCK_AP_INT_H),
            ("ap_fixed.h",   _MOCK_AP_FIXED_H),
            ("hls_stream.h", _MOCK_HLS_STREAM_H),
        ]:
            with open(os.path.join(tmpdir, fname), "w") as f:
                f.write(content)

        # Write generated code
        src_path = os.path.join(tmpdir, "kernel.cpp")
        with open(src_path, "w") as f:
            f.write(code)

        result = subprocess.run(
            ["g++", "-std=c++14", "-fsyntax-only", f"-I{tmpdir}", src_path],
            capture_output=True,
            text=True,
        )
        assert result.returncode == 0, (
            f"g++ syntax check failed:\n{result.stderr}"
        )
