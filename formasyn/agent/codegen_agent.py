"""LLM codegen agent: HLSScheduleDialect -> HLS C++ artifact files."""

from __future__ import annotations

import json
import logging
import re
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path

from FormaSyn.formasyn.agent.base_agent import BaseAgent
from FormaSyn.formasyn.ir.schedule_dialect import HLSScheduleDialect, ScheduleNode

logger = logging.getLogger(__name__)

_CODEGEN_SCHEMA = """\
你是 Vitis HLS C++ 代码生成器。你会收到一个完整的 HLSScheduleDialect(JSON)。

要求：
1) 生成可综合的 HLS C++ 顶层函数和头文件。
2) 顶层函数名必须等于给定 function_name。
3) 输入输出参数必须覆盖 schedule.input_nodes 和 schedule.output_nodes。
4) 输出必须是“工具调用 JSON”，不要输出 Markdown 代码块，不要输出额外说明：
{
  "tool_calls": [
    {
      "tool": "write_file",
      "path": "kernel.cpp",
      "content": "..."
    },
    {
      "tool": "write_file",
      "path": "kernel.h",
      "content": "..."
    }
  ]
}
5) path 必须是相对路径，禁止绝对路径和 `..`。
6) kernel.cpp 需要包含:
   - #include <ap_int.h>
   - #include <ap_fixed.h>
7) kernel.h 需要包含 include guard 和函数声明。
"""


@dataclass(frozen=True)
class CodegenArtifacts:
    """In-memory code + persisted artifact paths for one variant."""

    variant_id: str
    example_name: str
    function_name: str
    model: str
    base_url: str
    output_dir: str
    kernel_cpp: str
    kernel_h: str
    kernel_cpp_path: str
    kernel_h_path: str
    metadata_path: str
    prompt_path: str


class ScheduleCodegenAgent(BaseAgent):
    """Generate HLS C++ from schedule dialect and persist artifacts."""

    def __init__(
        self,
        model: str = "claude-sonnet-4-5-20250929",
        artifact_root: str | Path = "examples",
    ) -> None:
        super().__init__(model=model)
        self._artifact_root = Path(artifact_root)

    def generate(
        self,
        schedule: HLSScheduleDialect,
        *,
        example_name: str,
        function_name: str = "kernel",
    ) -> CodegenArtifacts:
        """Generate and persist HLS artifacts for one schedule variant."""
        schedule_json = self._schedule_to_json(schedule)
        user_prompt = self._build_user_prompt(
            schedule_json=schedule_json,
            example_name=example_name,
            function_name=function_name,
        )

        try:
            raw = self._chat_completion(
                system_prompt=_CODEGEN_SCHEMA,
                user_prompt=user_prompt,
                temperature=0.1,
            )
            tool_calls = self._parse_codegen_response(raw)
        except Exception:
            logger.exception(
                "Codegen LLM failed for variant '%s', fallback to local template",
                schedule.variant_id,
            )
            tool_calls = self._fallback_codegen_tool_calls(
                schedule,
                function_name=function_name,
            )

        return self._write_artifacts(
            schedule=schedule,
            example_name=example_name,
            function_name=function_name,
            tool_calls=tool_calls,
            prompt=user_prompt,
        )

    def _build_user_prompt(
        self,
        *,
        schedule_json: str,
        example_name: str,
        function_name: str,
    ) -> str:
        return (
            f"example_name: {example_name}\n"
            f"function_name: {function_name}\n"
            "schedule_json:\n"
            f"{schedule_json}\n"
        )

    @staticmethod
    def _schedule_to_json(schedule: HLSScheduleDialect) -> str:
        nodes: dict[str, dict] = {}
        for node_id, node in schedule.nodes.items():
            assert isinstance(node, ScheduleNode)
            nodes[node_id] = asdict(node)

        payload = {
            "variant_id": schedule.variant_id,
            "input_nodes": schedule.input_nodes,
            "output_nodes": schedule.output_nodes,
            "expected_ii": schedule.expected_ii,
            "total_dsp_estimate": schedule.total_dsp_estimate,
            "total_bram_estimate": schedule.total_bram_estimate,
            "nodes": nodes,
        }
        return json.dumps(payload, ensure_ascii=False, indent=2)

    @staticmethod
    def _parse_codegen_response(raw: str) -> list[dict[str, str]]:
        text = raw.strip()
        try:
            payload = json.loads(text)
        except json.JSONDecodeError:
            match = re.search(r"\{.*\}", text, re.DOTALL)
            if match is None:
                raise ValueError("LLM codegen response is not valid JSON object")
            payload = json.loads(match.group())

        if not isinstance(payload, dict):
            raise ValueError("LLM codegen response must be a JSON object")
        tool_calls = payload.get("tool_calls")
        if not isinstance(tool_calls, list) or not tool_calls:
            raise ValueError("Missing field: tool_calls")

        parsed: list[dict[str, str]] = []
        for call in tool_calls:
            if not isinstance(call, dict):
                raise ValueError("tool_calls items must be object")
            tool = call.get("tool")
            path = call.get("path")
            content = call.get("content")
            if tool != "write_file":
                raise ValueError(f"Unsupported tool: {tool}")
            if not isinstance(path, str) or not path.strip():
                raise ValueError("tool call missing path")
            if Path(path).is_absolute() or ".." in Path(path).parts:
                raise ValueError(f"Unsafe relative path: {path}")
            if not isinstance(content, str):
                raise ValueError("tool call missing content")
            parsed.append({
                "tool": "write_file",
                "path": path,
                "content": content,
            })

        paths = {item["path"] for item in parsed}
        if "kernel.cpp" not in paths or "kernel.h" not in paths:
            raise ValueError("tool_calls must include kernel.cpp and kernel.h")
        return parsed

    def _write_artifacts(
        self,
        *,
        schedule: HLSScheduleDialect,
        example_name: str,
        function_name: str,
        tool_calls: list[dict[str, str]],
        prompt: str,
    ) -> CodegenArtifacts:
        output_dir = self._artifact_root / example_name / schedule.variant_id
        output_dir.mkdir(parents=True, exist_ok=True)

        cpp_path = output_dir / "kernel.cpp"
        h_path = output_dir / "kernel.h"
        metadata_path = output_dir / "metadata.json"
        prompt_path = output_dir / "prompt.txt"

        for call in tool_calls:
            file_path = output_dir / call["path"]
            file_path.parent.mkdir(parents=True, exist_ok=True)
            file_path.write_text(call["content"], encoding="utf-8")

        kernel_cpp = cpp_path.read_text(encoding="utf-8")
        kernel_h = h_path.read_text(encoding="utf-8")
        prompt_path.write_text(prompt, encoding="utf-8")

        metadata = {
            "variant_id": schedule.variant_id,
            "example_name": example_name,
            "function_name": function_name,
            "model": self.model,
            "base_url": self.base_url,
            "generated_at_utc": datetime.now(timezone.utc).isoformat(),
            "schedule_summary": {
                "node_count": len(schedule.nodes),
                "input_nodes": schedule.input_nodes,
                "output_nodes": schedule.output_nodes,
                "expected_ii": schedule.expected_ii,
                "total_dsp_estimate": schedule.total_dsp_estimate,
                "total_bram_estimate": schedule.total_bram_estimate,
            },
        }
        metadata_path.write_text(
            json.dumps(metadata, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )

        return CodegenArtifacts(
            variant_id=schedule.variant_id,
            example_name=example_name,
            function_name=function_name,
            model=self.model,
            base_url=self.base_url,
            output_dir=str(output_dir),
            kernel_cpp=kernel_cpp,
            kernel_h=kernel_h,
            kernel_cpp_path=str(cpp_path),
            kernel_h_path=str(h_path),
            metadata_path=str(metadata_path),
            prompt_path=str(prompt_path),
        )

    @staticmethod
    def _fallback_codegen_tool_calls(
        schedule: HLSScheduleDialect,
        *,
        function_name: str,
    ) -> list[dict[str, str]]:
        """Simple deterministic fallback if LLM API is unavailable."""
        params: list[str] = []
        for node_id in schedule.input_nodes:
            n = schedule.nodes[node_id]
            size = n.shape[0] if n.shape else 1
            params.append(f"    {n.data_type} {node_id}[{size}]")
        for node_id in schedule.output_nodes:
            n = schedule.nodes[node_id]
            size = n.shape[0] if n.shape else 1
            params.append(f"    {n.data_type} {node_id}[{size}]")
        sig = f"void {function_name}(\n" + ",\n".join(params) + "\n)"

        first_input = schedule.input_nodes[0] if schedule.input_nodes else ""
        body_lines = [f"    #pragma HLS PIPELINE II={schedule.expected_ii}"]
        for out_id in schedule.output_nodes:
            body_lines.append(f"    {out_id}[0] = {first_input}[0];")

        cpp = "\n".join([
            "#include <ap_int.h>",
            "#include <ap_fixed.h>",
            "#include <hls_stream.h>",
            "",
            sig + " {",
            *body_lines,
            "}",
            "",
        ])

        guard = f"FORMASYN_{function_name.upper()}_H"
        hdr = "\n".join([
            f"#ifndef {guard}",
            f"#define {guard}",
            "",
            "#include <ap_int.h>",
            "#include <ap_fixed.h>",
            "",
            sig + ";",
            "",
            f"#endif  // {guard}",
            "",
        ])
        return [
            {"tool": "write_file", "path": "kernel.cpp", "content": cpp},
            {"tool": "write_file", "path": "kernel.h", "content": hdr},
        ]
