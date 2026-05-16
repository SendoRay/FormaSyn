"""HLS 环境工具：Mock 头文件、pragma 处理和 EDA 工具检测。

在 host (g++) 仿真环境中模拟 Vitis HLS 头文件，
使得不含 EDA 工具时仍能编译和运行 HLS C++ 代码。
"""

from __future__ import annotations

import os
import subprocess


def vitis_available() -> bool:
    """检查是否有可用的 Vitis HLS 工具（vitis-run 或 v++）。"""
    return tool_available("vitis-run") or tool_available("v++")


def tool_available(tool: str) -> bool:
    """检查指定命令行工具是否可用。"""
    try:
        proc = subprocess.run(
            [tool, "--version"],
            capture_output=True,
            text=True,
            timeout=10,
        )
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False
    return proc.returncode == 0


def write_mock_headers(out_dir: str, hls_header_code: str | None = None) -> None:
    """写入最小化的 HLS 兼容头文件，用于 host 仿真。

    Args:
        out_dir: 输出目录。
        hls_header_code: 可选的 kernel.h 内容，如果提供则写入。
    """
    headers = {
        "ap_int.h": (
            "#pragma once\n"
            "#include <cstdint>\n"
            "template<int W> using ap_int = int;\n"
            "template<int W> using ap_uint = unsigned int;\n"
        ),
        "ap_fixed.h": (
            "#pragma once\n"
            "#include \"ap_int.h\"\n"
            "template<int W, int I=0> using ap_fixed = double;\n"
        ),
        "hls_stream.h": (
            "#pragma once\n"
            "template<typename T> struct hls_stream {};\n"
        ),
    }
    for name, content in headers.items():
        with open(os.path.join(out_dir, name), "w", encoding="utf-8") as f:
            f.write(content)

    if hls_header_code:
        with open(os.path.join(out_dir, "kernel.h"), "w", encoding="utf-8") as f:
            f.write(hls_header_code)


def strip_hls_pragmas(code: str) -> str:
    """移除 g++ 不支持的 ``#pragma HLS`` 指令。"""
    stripped: list[str] = []
    for line in code.splitlines():
        if line.lstrip().startswith("#pragma HLS"):
            continue
        stripped.append(line)
    return "\n".join(stripped) + "\n"
