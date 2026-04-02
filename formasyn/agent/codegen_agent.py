"""LLM codegen agent: HLSScheduleDialect -> HLS C++ artifact files."""

from __future__ import annotations

import json
import logging
import re
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path

from .base_agent import BaseAgent, _LOADED_MODEL
from ..ir.schedule_dialect import HLSScheduleDialect, ScheduleNode

logger = logging.getLogger(__name__)

_CODEGEN_SCHEMA = """You are a Vitis HLS C++ code generator.

[CRITICAL] Output ONLY raw JSON. No markdown, no explanations, no extra text!

Input: HLSScheduleDialect (JSON)
Output: Pure JSON object (no ```json wrapper)

Format:
{
  "tool_calls": [
    {"tool": "write_file", "path": "kernel.cpp", "content": "..."},
    {"tool": "write_file", "path": "kernel.h", "content": "..."}
  ]
}

Code requirements:
- function_name: from input
- I/O params: cover schedule.input_nodes and schedule.output_nodes
- kernel.cpp: include <ap_int.h> and <ap_fixed.h>
- kernel.h: include guard and function declaration
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
        model: str | None = None,
        artifact_root: str | Path = "examples",
    ) -> None:
        if model is None:
            model = _LOADED_MODEL
        super().__init__(model=model)
        self._artifact_root = Path(artifact_root)

    def generate(
        self,
        schedule: HLSScheduleDialect,
        *,
        example_name: str,
        function_name: str = "kernel",
        force_fallback: bool = False,
    ) -> CodegenArtifacts:
        """Generate and persist HLS artifacts for one schedule variant."""
        schedule_json = self._schedule_to_json(schedule)
        user_prompt = self._build_user_prompt(
            schedule_json=schedule_json,
            example_name=example_name,
            function_name=function_name,
        )

        if force_fallback:
            logger.info("强制使用 fallback 代码生成")
            tool_calls = self._fallback_codegen_tool_calls(
                schedule,
                function_name=function_name,
            )
        else:
            try:
                raw = self._chat_completion(
                    system_prompt=_CODEGEN_SCHEMA,
                    user_prompt=user_prompt,
                    temperature=0.1,
                    timeout=10.0,  # 10秒超时
                )
                tool_calls = self._parse_codegen_response(raw)
            except Exception as e:
                logger.warning(
                    "Codegen LLM failed for variant '%s' (error: %s), fallback to local template",
                    schedule.variant_id,
                    str(e)[:100],
                )
                tool_calls = self._fallback_codegen_tool_calls(
                    schedule,
                    function_name=function_name,
                )

        # 额外检查：如果 tool_calls 为空，强制使用 fallback
        if not tool_calls:
            logger.warning("LLM returned empty tool_calls, using fallback")
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

        # 移除 Markdown 代码块标记
        if text.startswith("```"):
            # 移除开头的 ```json 或 ```
            text = re.sub(r"^```(?:json)?\s*", "", text, flags=re.DOTALL)
            # 移除结尾的 ```
            text = re.sub(r"\s*```$", "", text, flags=re.DOTALL)
            text = text.strip()

        try:
            payload = json.loads(text)
        except json.JSONDecodeError:
            # 尝试从文本中提取 JSON 对象
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
        """Deterministic fallback codegen with pattern-aware logic."""
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

        body_lines: list[str] = []
        body_lines.append(f"    #pragma HLS PIPELINE II={schedule.expected_ii}")

        # 分析节点拓扑来推断代码模式
        nodes = schedule.nodes
        input_nodes = schedule.input_nodes
        output_nodes = schedule.output_nodes

        # DEBUG: 打印节点信息
        with open("/tmp/formasyn_codegen_debug.log", "a") as f:
            f.write(f"=== {schedule.variant_id} ===\n")
            f.write(f"input_nodes: {input_nodes}\n")
            f.write(f"output_nodes: {output_nodes}\n")
            for nid, n in nodes.items():
                f.write(f"{nid}: op_type={n.op_type}, op_detail={n.op_detail}, data_type={n.data_type}\n")

        # 检查是否有 FIR 模式: shift_reg -> map(multiply) -> reduce(add)
        has_shift_reg = any(
            nodes[nid].op_type == "shift_reg" for nid in nodes
        )
        has_map_multiply = any(
            nodes[nid].op_type == "map" and
            nodes[nid].op_detail.get("func") == "multiply"
            for nid in nodes
        )
        has_reduce_add = any(
            nodes[nid].op_type == "reduce" and
            nodes[nid].op_detail.get("op") == "add"
            for nid in nodes
        )

        with open("/tmp/formasyn_codegen_debug.log", "a") as f:
            f.write(f"FIR detection: has_shift_reg={has_shift_reg}, has_map_multiply={has_map_multiply}, has_reduce_add={has_reduce_add}\n")

        if has_shift_reg and has_map_multiply and has_reduce_add:
            # FIR 滤波器模式
            # 提取系数（处理可能的嵌套结构）
            coeffs = []
            for nid, n in nodes.items():
                if n.op_type == "map" and n.op_detail.get("func") == "multiply":
                    # 尝试多种路径获取系数
                    fp = n.op_detail.get("func_params", {})
                    coeffs = fp.get("coeffs", [])
                    if not coeffs:
                        # 处理嵌套情况 {'func_params': {'func_params': {'coeffs': [...]}}}
                        fp2 = fp.get("func_params", {})
                        coeffs = fp2.get("coeffs", [])
                    if coeffs:
                        break

            if coeffs:
                # 生成 FIR 代码
                coeff_strs = [f"static const ap_fixed<16,4> coeffs[{len(coeffs)}] = {{"
                              + ", ".join(f"{c:.6f}" for c in coeffs) + "};"]
                body_lines.extend(coeff_strs)

                input_id = input_nodes[0] if input_nodes else "x_in"
                output_id = output_nodes[0] if output_nodes else "y_out"
                tap_count = len(coeffs)

                # FIR 滤波器：处理整个输入数组（使用 tap_count 作为默认大小）
                input_size = nodes[input_nodes[0]].shape[0] if nodes[input_nodes[0]].shape and nodes[input_nodes[0]].shape[0] > 1 else tap_count
                body_lines.append(f"    static ap_fixed<16,4> shift_reg[{tap_count}] = {{0}};")
                body_lines.append(f"    #pragma HLS ARRAY_PARTITION variable=shift_reg complete")
                body_lines.append("")
                body_lines.append(f"    for (int n = 0; n < {input_size}; n++) {{")
                body_lines.append(f"        #pragma HLS PIPELINE II=1")
                body_lines.append(f"        ap_fixed<32,8> acc = 0;")
                body_lines.append("")
                body_lines.append(f"        for (int i = {tap_count-1}; i > 0; i--) {{")
                body_lines.append(f"            #pragma HLS UNROLL")
                body_lines.append(f"            shift_reg[i] = shift_reg[i-1];")
                body_lines.append(f"        }}")
                body_lines.append(f"        shift_reg[0] = (ap_fixed<16,4>){input_id}[n];")
                body_lines.append("")
                body_lines.append(f"        for (int i = 0; i < {tap_count}; i++) {{")
                body_lines.append(f"            #pragma HLS UNROLL")
                body_lines.append(f"            acc += shift_reg[i] * coeffs[i];")
                body_lines.append(f"        }}")
                body_lines.append(f"        {output_id}[n] = acc;")
                body_lines.append(f"    }}")
            else:
                # 没有系数，使用简单复制
                ScheduleCodegenAgent._generate_simple_copy(body_lines, input_nodes, output_nodes)

        elif len(input_nodes) == 2 and len(output_nodes) == 1:
            # 二元运算 (如 vec_add)
            a_id, b_id = input_nodes[0], input_nodes[1]
            c_id = output_nodes[0]
            size = nodes[input_nodes[0]].shape[0] if nodes[input_nodes[0]].shape else 16
            body_lines.append(f"    for (int i = 0; i < {size}; i++) {{")
            body_lines.append(f"        #pragma HLS UNROLL")
            body_lines.append(f"        {c_id}[i] = {a_id}[i] + {b_id}[i];")
            body_lines.append(f"    }}")

        elif len(input_nodes) == 1 and len(output_nodes) == 1:
            # 单输入单输出
            ScheduleCodegenAgent._generate_simple_copy(body_lines, input_nodes, output_nodes)

        else:
            ScheduleCodegenAgent._generate_simple_copy(body_lines, input_nodes, output_nodes)

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

    @staticmethod
    def _generate_simple_copy(
        body_lines: list[str],
        input_nodes: list[str],
        output_nodes: list[str],
    ) -> None:
        """生成简单的复制逻辑."""
        first_input = input_nodes[0] if input_nodes else "x_in"
        for out_id in output_nodes:
            body_lines.append(f"    for (int i = 0; i < 16; i++) {{")
            body_lines.append(f"        {out_id}[i] = {first_input}[i];")
            body_lines.append(f"    }}")
