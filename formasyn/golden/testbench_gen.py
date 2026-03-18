"""Testbench 生成器：从 Golden 输出生成 HLS testbench.cpp.

本模块将 Golden Model 的输出数据转换为完整的 Vitis HLS 兼容 testbench.cpp，
供 L1 csim 和 L3a cosim 复用。

主要功能：
- 解析 HLS C++ 函数签名
- 生成包含输入数据和 golden 参考输出的 testbench
- 生成 Vitis HLS 配置文件
- 自动生成 kernel.h 头文件（如需要）
"""

from __future__ import annotations

import logging
import os
import re
from dataclasses import dataclass
from typing import Optional

logger = logging.getLogger(__name__)

_OUTPUT_PREFIX = "@@OUTPUT "


@dataclass
class TestbenchSpec:
    """Testbench 生成规范.

    Attributes:
        hls_cpp_code: HLS C++ 源码.
        test_inputs: 测试输入数据.
        golden_outputs: Golden 参考输出.
        csr_data: CSR 格式的稀疏矩阵数据（可选）.
        function_name: 顶层函数名（自动提取）.
        part: FPGA 部件型号.
        clock: 时钟周期字符串.
    """

    hls_cpp_code: str
    test_inputs: dict[str, list[float]]
    golden_outputs: dict[str, list[float]]
    csr_data: dict[str, list[int]] | None = None
    function_name: str = ""
    part: str = "xc7z020clg400-1"
    clock: str = "10ns"


@dataclass
class TestbundleArtifacts:
    """生成的 Testbench 文件集合.

    Attributes:
        testbench_code: testbench.cpp 源码.
        hls_config: hls_config.cfg 内容.
        kernel_header: kernel.h 内容（如果需要）.
        function_name: 提取的函数名.
    """

    testbench_code: str
    hls_config: str
    kernel_header: str = ""
    function_name: str = ""


class TestbenchGenerator:
    """从 Golden 输出生成 HLS testbench.cpp.

    这个类将 L1Checker 中的 testbench 生成逻辑提取出来，
    使 L1 和 L3 可以复用同一份 testbench 生成代码。
    """

    DEFAULT_PART = "xc7z020clg400-1"
    DEFAULT_CLOCK = "10ns"

    def generate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: dict[str, list[int]] | None = None,
        part: str = DEFAULT_PART,
        clock: str = DEFAULT_CLOCK,
    ) -> str:
        """生成完整的 testbench.cpp 源码.

        Args:
            hls_cpp_code: HLS C++ 源码.
            test_inputs: 测试输入数据.
            golden_outputs: Golden 参考输出.
            csr_data: 可选的 CSR 数据（用于不规则访存 kernel）.
            part: FPGA 部件型号.
            clock: 时钟周期字符串.

        Returns:
            完整的 testbench.cpp 源码字符串.
        """
        preamble = self._extract_preamble(hls_cpp_code)
        signature = self._extract_function_signature(hls_cpp_code)
        param_specs = self._extract_param_specs(signature)

        lines = [
            "#include <cstdio>",
            "#include <cmath>",
            preamble.rstrip(),
            "",
            signature + ";",
            "",
            "int main() {",
        ]

        golden_keys = list(golden_outputs.keys())
        unmatched_golden = [k for k in golden_keys]
        output_bindings: list[dict[str, object]] = []

        for spec in param_specs:
            name = spec["name"]
            dtype = spec["dtype"]
            decl_type = spec["decl_type"]
            is_array = bool(spec["is_array"])
            array_len = int(spec["array_len"])

            if name in test_inputs:
                values = test_inputs[name]
                if is_array:
                    arr_str = ", ".join(
                        self._format_literal(v, dtype) for v in values
                    )
                    lines.append(f"    {decl_type} {name}[] = {{{arr_str}}};")
                else:
                    value = values[0] if values else 0.0
                    lines.append(
                        f"    {decl_type} {name} = {self._format_literal(value, dtype)};"
                    )
                continue

            golden_name = name if name in golden_outputs else None
            if golden_name is None and unmatched_golden:
                golden_name = unmatched_golden[0]
            if golden_name is None:
                continue
            if golden_name in unmatched_golden:
                unmatched_golden.remove(golden_name)

            values = golden_outputs[golden_name]
            arr_str = ", ".join(self._format_literal(v, "double") for v in values)
            lines.append(f"    double golden_{golden_name}[] = {{{arr_str}}};")

            if is_array:
                alloc_len = len(values)
                if array_len > 0:
                    alloc_len = array_len
                lines.append(f"    {decl_type} {name}[{alloc_len}] = {{0}};")
                output_bindings.append(
                    {
                        "golden_name": golden_name,
                        "var_name": name,
                        "length": len(values),
                        "is_scalar": False,
                    }
                )
            else:
                lines.append(f"    {decl_type} {name} = 0;")
                output_bindings.append(
                    {
                        "golden_name": golden_name,
                        "var_name": name,
                        "length": 1,
                        "is_scalar": True,
                    }
                )

        if csr_data is not None:
            rp = ", ".join(str(x) for x in csr_data["row_ptr"])
            ci = ", ".join(str(x) for x in csr_data["col_idx"])
            lines.append(f"    int row_ptr[] = {{{rp}}};")
            lines.append(f"    int col_idx[] = {{{ci}}};")

        args: list[str] = [spec["name"] for spec in param_specs]
        if csr_data is not None:
            args.extend(["row_ptr", "col_idx"])
        lines.append(f"    {self._extract_function_name(hls_cpp_code)}({', '.join(args)});")
        lines.append("")
        lines.append("    int mismatch_count = 0;")

        for binding in output_bindings:
            gname = str(binding["golden_name"])
            var = str(binding["var_name"])
            length = int(binding["length"])
            is_scalar = bool(binding["is_scalar"])
            lines.append(f'    printf("{_OUTPUT_PREFIX}{gname}:");')
            lines.append(f"    for (int i = 0; i < {length}; i++) {{")
            lines.append("        if (i > 0) printf(\",\");")
            if is_scalar:
                lines.append(f'        printf("%.17g", (double){var});')
                lines.append(
                    f"        mismatch_count += (std::fabs((double){var} - golden_{gname}[i]) > 1e-9);"
                )
            else:
                lines.append(f'        printf("%.17g", (double){var}[i]);')
                lines.append(
                    f"        mismatch_count += (std::fabs((double){var}[i] - golden_{gname}[i]) > 1e-9);"
                )
            lines.append("    }")
            lines.append('    printf("\\n");')

        lines.append('    printf("@@MISMATCH %d\\n", mismatch_count);')
        lines.append("    return 0;")
        lines.append("}")
        return "\n".join(lines) + "\n"

    def generate_hls_config(
        self,
        function_name: str,
        src_name: str,
        tb_name: str,
        *,
        part: str = DEFAULT_PART,
        clock: str = DEFAULT_CLOCK,
    ) -> str:
        """生成 v++ --mode hls 配置文件.

        Args:
            function_name: 顶层函数名.
            src_name: 源文件名.
            tb_name: testbench 文件名.
            part: FPGA 部件型号.
            clock: 时钟周期字符串.

        Returns:
            hls_config.cfg 文件内容.
        """
        return (
            f"part={part}\n\n"
            "[hls]\n"
            f"clock={clock}\n"
            "flow_target=vitis\n"
            f"syn.top={function_name}\n"
            f"syn.file={src_name}\n"
            f"tb.file={tb_name}\n"
        )

    def generate_kernel_header(self, hls_cpp_code: str) -> str:
        """生成 kernel.h 头文件（当源码包含 #include "kernel.h" 时）.

        Args:
            hls_cpp_code: HLS C++ 源码.

        Returns:
            kernel.h 文件内容，如果不需要则返回空字符串.
        """
        if '#include "kernel.h"' not in hls_cpp_code:
            return ""

        signature = self._extract_function_signature(hls_cpp_code)
        preamble = self._extract_preamble(hls_cpp_code)

        preamble_lines: list[str] = []
        for raw in preamble.splitlines():
            line = raw.strip()
            if line.startswith("#include") and '"kernel.h"' in line:
                continue
            preamble_lines.append(raw.rstrip())

        header_lines = ["#pragma once"]
        if preamble_lines:
            header_lines.append("")
            header_lines.extend(preamble_lines)
        header_lines.append("")
        header_lines.append(signature + ";")
        header_lines.append("")
        return "\n".join(header_lines)

    def generate_bundle(
        self,
        spec: TestbenchSpec,
    ) -> TestbundleArtifacts:
        """生成完整的 testbench 文件集合.

        Args:
            spec: Testbench 生成规范.

        Returns:
            包含所有生成内容的 TestbundleArtifacts.
        """
        function_name = self._extract_function_name(spec.hls_cpp_code)
        src_name = f"{function_name}.cpp"
        tb_name = f"{function_name}_tb.cpp"

        testbench_code = self.generate(
            spec.hls_cpp_code,
            spec.test_inputs,
            spec.golden_outputs,
            csr_data=spec.csr_data,
        )
        hls_config = self.generate_hls_config(
            function_name,
            src_name,
            tb_name,
            part=spec.part,
            clock=spec.clock,
        )
        kernel_header = self.generate_kernel_header(spec.hls_cpp_code)

        return TestbundleArtifacts(
            testbench_code=testbench_code,
            hls_config=hls_config,
            kernel_header=kernel_header,
            function_name=function_name,
        )

    @staticmethod
    def _extract_function_name(code: str) -> str:
        """从 C++ 源码中提取顶层函数名."""
        match = re.search(r"\bvoid\s+([A-Za-z_]\w*)\s*\(", code)
        if match:
            return match.group(1)
        return "kernel"

    @staticmethod
    def _extract_function_signature(code: str) -> str:
        """从 C++ 源码中提取完整的顶层函数签名."""
        match = re.search(r"(void\s+[A-Za-z_]\w*\s*\([\s\S]*?\))\s*\{", code)
        if not match:
            raise ValueError("Unable to extract function signature from HLS C++")
        return match.group(1).strip()

    @staticmethod
    def _extract_preamble(code: str) -> str:
        """返回函数体之前的 includes/typedef 部分."""
        signature = TestbenchGenerator._extract_function_signature(code)
        idx = code.find(signature)
        if idx == -1:
            raise ValueError("Unable to extract HLS preamble")
        return code[:idx].rstrip()

    @staticmethod
    def _extract_param_specs(signature: str) -> list[dict[str, object]]:
        """从函数签名中提取有序的参数规范."""
        params_str = signature[signature.find("(") + 1: signature.rfind(")")]
        params = TestbenchGenerator._split_params(params_str)
        specs: list[dict[str, object]] = []

        for param in params:
            p = param.strip()
            if not p:
                continue

            array_match = re.match(
                r"(.+?)\s+([A-Za-z_]\w*)\s*\[\s*(\d+)\s*\]$",
                p,
            )
            if array_match:
                dtype = array_match.group(1).strip()
                specs.append(
                    {
                        "name": array_match.group(2),
                        "dtype": dtype,
                        "decl_type": dtype.replace("&", "").strip(),
                        "is_array": True,
                        "array_len": int(array_match.group(3)),
                    }
                )
                continue

            ref_match = re.match(r"(.+?)\s*&\s*([A-Za-z_]\w*)$", p)
            if ref_match:
                dtype = (ref_match.group(1).strip() + "&").strip()
                specs.append(
                    {
                        "name": ref_match.group(2),
                        "dtype": dtype,
                        "decl_type": ref_match.group(1).strip(),
                        "is_array": False,
                        "array_len": 1,
                    }
                )
                continue

            ptr_match = re.match(r"(.+?)\s+([A-Za-z_]\w*)$", p)
            if ptr_match:
                dtype = ptr_match.group(1).strip()
                specs.append(
                    {
                        "name": ptr_match.group(2),
                        "dtype": dtype,
                        "decl_type": dtype.replace("&", "").strip(),
                        "is_array": False,
                        "array_len": 1,
                    }
                )

        return specs

    @staticmethod
    def _split_params(params_str: str) -> list[str]:
        """分割参数列表，保留模板中的逗号."""
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
        """格式化字面量用于生成的 testbench."""
        if dtype in {"double", "float"}:
            return f"{value:.17g}"
        if float(value).is_integer():
            return f"({dtype}){int(value)}"
        return f"({dtype})({value:.17g})"


def parse_output(stdout: str, prefix: str = _OUTPUT_PREFIX) -> dict[str, list[float]]:
    """解析 testbench 输出的 ``@@OUTPUT name:v0,v1,...`` 行.

    Args:
        stdout: testbench 程序的标准输出.
        prefix: 输出前缀字符串.

    Returns:
        解析后的输出名称到值列表的映射.
    """
    result: dict[str, list[float]] = {}
    for line in stdout.strip().splitlines():
        line = line.strip()
        if not line.startswith(prefix):
            continue
        payload = line[len(prefix):]
        if ":" not in payload:
            continue
        name, values_str = payload.split(":", 1)
        name = name.strip()
        if not values_str.strip():
            result[name] = []
            continue
        result[name] = [float(v) for v in values_str.split(",") if v]
    return result
