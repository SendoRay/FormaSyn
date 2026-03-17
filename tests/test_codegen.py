"""Tests for ScheduleCodegenAgent: HLSScheduleDialect -> artifact files."""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import tempfile
from unittest.mock import MagicMock, patch

import pytest

from FormaSyn.agent.codegen_agent import ScheduleCodegenAgent
from FormaSyn.ir.schedule_dialect import HLSScheduleDialect


@pytest.fixture
def ldpc_schedule() -> HLSScheduleDialect:
    return HLSScheduleDialect.example_ldpc_cnu()


@pytest.fixture
def artifact_root() -> str:
    with tempfile.TemporaryDirectory() as tmpdir:
        yield tmpdir


@pytest.fixture
def codegen_agent(artifact_root: str) -> ScheduleCodegenAgent:
    return ScheduleCodegenAgent(model="test-model", artifact_root=artifact_root)


def _mock_response(content: str) -> MagicMock:
    msg = MagicMock()
    msg.content = content
    choice = MagicMock()
    choice.message = msg
    resp = MagicMock()
    resp.choices = [choice]
    return resp


def _sample_codegen_json() -> str:
    payload = {
        "tool_calls": [
            {
                "tool": "write_file",
                "path": "kernel.cpp",
                "content": (
                    "#include <ap_int.h>\n"
                    "#include <ap_fixed.h>\n"
                    "#include <hls_stream.h>\n\n"
                    "void kernel(ap_int<8> msg_in[8], ap_int<1> xor_reduce[1], ap_int<7> min_reduce[1]) {\n"
                    "  #pragma HLS PIPELINE II=1\n"
                    "  xor_reduce[0] = msg_in[0] & 1;\n"
                    "  min_reduce[0] = msg_in[0] & 127;\n"
                    "}\n"
                ),
            },
            {
                "tool": "write_file",
                "path": "kernel.h",
                "content": (
                    "#ifndef FORMASYN_KERNEL_H\n"
                    "#define FORMASYN_KERNEL_H\n"
                    "#include <ap_int.h>\n"
                    "#include <ap_fixed.h>\n"
                    "void kernel(ap_int<8> msg_in[8], ap_int<1> xor_reduce[1], ap_int<7> min_reduce[1]);\n"
                    "#endif  // FORMASYN_KERNEL_H\n"
                ),
            },
        ],
    }
    return json.dumps(payload, ensure_ascii=False)


class TestScheduleCodegenAgent:
    def test_generate_writes_artifacts(
        self,
        codegen_agent: ScheduleCodegenAgent,
        ldpc_schedule: HLSScheduleDialect,
    ) -> None:
        with patch.object(
            codegen_agent._client.chat.completions,
            "create",
            return_value=_mock_response(_sample_codegen_json()),
        ):
            artifacts = codegen_agent.generate(
                ldpc_schedule,
                example_name="ldpc_cnu",
                function_name="kernel",
            )

        assert os.path.isdir(artifacts.output_dir)
        assert os.path.isfile(artifacts.kernel_cpp_path)
        assert os.path.isfile(artifacts.kernel_h_path)
        assert os.path.isfile(artifacts.metadata_path)
        assert os.path.isfile(artifacts.prompt_path)

        metadata = json.loads(
            open(artifacts.metadata_path, encoding="utf-8").read()
        )
        assert metadata["variant_id"] == "min_sum_int8_p8"
        assert metadata["example_name"] == "ldpc_cnu"
        assert metadata["function_name"] == "kernel"
        assert metadata["model"] == "test-model"
        assert metadata["schedule_summary"]["expected_ii"] == 1

    def test_generate_calls_llm_with_model(
        self,
        codegen_agent: ScheduleCodegenAgent,
        ldpc_schedule: HLSScheduleDialect,
    ) -> None:
        with patch.object(
            codegen_agent._client.chat.completions,
            "create",
            return_value=_mock_response(_sample_codegen_json()),
        ) as mock_create:
            codegen_agent.generate(ldpc_schedule, example_name="ldpc_cnu")

        assert mock_create.call_args[1]["model"] == "test-model"

    def test_generate_overwrites_fixed_variant_dir(
        self,
        codegen_agent: ScheduleCodegenAgent,
        ldpc_schedule: HLSScheduleDialect,
    ) -> None:
        first = {
            "tool_calls": [
                {
                    "tool": "write_file",
                    "path": "kernel.cpp",
                    "content": "#include <ap_int.h>\n#include <ap_fixed.h>\n#include <hls_stream.h>\nvoid kernel(ap_int<8> in0[8], ap_int<1> out0[1], ap_int<7> out1[1]){out0[0]=0;out1[0]=0;}\n",
                },
                {
                    "tool": "write_file",
                    "path": "kernel.h",
                    "content": "#ifndef FORMASYN_KERNEL_H\n#define FORMASYN_KERNEL_H\nvoid kernel(ap_int<8> in0[8], ap_int<1> out0[1], ap_int<7> out1[1]);\n#endif  // FORMASYN_KERNEL_H\n",
                },
            ],
        }
        second = {
            "tool_calls": [
                {
                    "tool": "write_file",
                    "path": "kernel.cpp",
                    "content": "#include <ap_int.h>\n#include <ap_fixed.h>\n#include <hls_stream.h>\nvoid kernel(ap_int<8> in0[8], ap_int<1> out0[1], ap_int<7> out1[1]){out0[0]=1;out1[0]=1;}\n",
                },
                {
                    "tool": "write_file",
                    "path": "kernel.h",
                    "content": "#ifndef FORMASYN_KERNEL_H\n#define FORMASYN_KERNEL_H\nvoid kernel(ap_int<8> in0[8], ap_int<1> out0[1], ap_int<7> out1[1]);\n#endif  // FORMASYN_KERNEL_H\n",
                },
            ],
        }

        with patch.object(
            codegen_agent._client.chat.completions,
            "create",
            return_value=_mock_response(json.dumps(first)),
        ):
            artifacts = codegen_agent.generate(ldpc_schedule, example_name="ldpc_cnu")

        with patch.object(
            codegen_agent._client.chat.completions,
            "create",
            return_value=_mock_response(json.dumps(second)),
        ):
            codegen_agent.generate(ldpc_schedule, example_name="ldpc_cnu")

        new_cpp = open(artifacts.kernel_cpp_path, encoding="utf-8").read()
        assert "out0[0]=1;" in new_cpp

    def test_fallback_when_api_fails(
        self,
        codegen_agent: ScheduleCodegenAgent,
        ldpc_schedule: HLSScheduleDialect,
    ) -> None:
        with patch.object(
            codegen_agent._client.chat.completions,
            "create",
            side_effect=Exception("api down"),
        ):
            artifacts = codegen_agent.generate(ldpc_schedule, example_name="ldpc_cnu")

        assert "#include <ap_int.h>" in artifacts.kernel_cpp
        assert "void kernel(" in artifacts.kernel_cpp
        assert os.path.isfile(artifacts.kernel_cpp_path)
        assert os.path.isfile(artifacts.kernel_h_path)


_MOCK_AP_INT_H = """\
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


@pytest.mark.skipif(shutil.which("g++") is None, reason="g++ not found on PATH")
def test_generated_cpp_syntax_check(
    codegen_agent: ScheduleCodegenAgent,
    ldpc_schedule: HLSScheduleDialect,
) -> None:
    with patch.object(
        codegen_agent._client.chat.completions,
        "create",
        return_value=_mock_response(_sample_codegen_json()),
    ):
        artifacts = codegen_agent.generate(ldpc_schedule, example_name="ldpc_cnu")

    with tempfile.TemporaryDirectory() as tmpdir:
        for fname, content in [
            ("ap_int.h", _MOCK_AP_INT_H),
            ("ap_fixed.h", _MOCK_AP_FIXED_H),
            ("hls_stream.h", _MOCK_HLS_STREAM_H),
        ]:
            with open(os.path.join(tmpdir, fname), "w", encoding="utf-8") as f:
                f.write(content)

        src_path = os.path.join(tmpdir, "kernel.cpp")
        with open(src_path, "w", encoding="utf-8") as f:
            f.write(artifacts.kernel_cpp)

        result = subprocess.run(
            ["g++", "-std=c++14", "-fsyntax-only", f"-I{tmpdir}", src_path],
            capture_output=True,
            text=True,
        )
        assert result.returncode == 0, (
            f"g++ syntax check failed:\n{result.stderr}"
        )
