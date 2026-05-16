"""C++ 函数签名解析工具函数。

从 HLS C++ 源码中提取函数名、签名、参数规范等，
供 TestbenchGenerator、L1Checker、Simulator 等模块共享使用。
"""

from __future__ import annotations

import re
from typing import Any


def extract_function_name(code: str) -> str:
    """从 C++ 源码中提取顶层函数名。"""
    match = re.search(r"\bvoid\s+([A-Za-z_]\w*)\s*\(", code)
    if match:
        return match.group(1)
    return "kernel"


def extract_function_signature(code: str) -> str:
    """从 C++ 源码中提取完整的顶层函数签名。"""
    match = re.search(r"(void\s+[A-Za-z_]\w*\s*\([\s\S]*?\))\s*\{", code)
    if not match:
        raise ValueError("Unable to extract function signature from HLS C++")
    return match.group(1).strip()


def extract_preamble(code: str) -> str:
    """返回函数体之前的 includes/typedef 部分。"""
    signature = extract_function_signature(code)
    idx = code.find(signature)
    if idx == -1:
        raise ValueError("Unable to extract HLS preamble")
    return code[:idx].rstrip()


def split_params(params_str: str) -> list[str]:
    """分割参数列表，保留模板中的逗号（如 ``ap_fixed<16,8>``）。"""
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


def extract_param_specs(signature: str) -> list[dict[str, Any]]:
    """从函数签名中提取有序的参数规范。

    返回列表，每个元素包含:
      - name: 参数名
      - dtype: 完整类型声明（含 &）
      - decl_type: 变量声明用的类型（不含 &）
      - is_array: 是否为数组参数
      - array_len: 数组长度（非数组为 1）
    """
    params_str = signature[signature.find("(") + 1: signature.rfind(")")]
    params = split_params(params_str)
    specs: list[dict[str, Any]] = []

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
            specs.append({
                "name": array_match.group(2),
                "dtype": dtype,
                "decl_type": dtype.replace("&", "").strip(),
                "is_array": True,
                "array_len": int(array_match.group(3)),
            })
            continue

        ref_match = re.match(r"(.+?)\s*&\s*([A-Za-z_]\w*)$", p)
        if ref_match:
            dtype = (ref_match.group(1).strip() + "&").strip()
            specs.append({
                "name": ref_match.group(2),
                "dtype": dtype,
                "decl_type": ref_match.group(1).strip(),
                "is_array": False,
                "array_len": 1,
            })
            continue

        ptr_match = re.match(r"(.+?)\s+([A-Za-z_]\w*)$", p)
        if ptr_match:
            dtype = ptr_match.group(1).strip()
            specs.append({
                "name": ptr_match.group(2),
                "dtype": dtype,
                "decl_type": dtype.replace("&", "").strip(),
                "is_array": False,
                "array_len": 1,
            })

    return specs


def extract_param_types(signature: str) -> dict[str, str]:
    """将参数名映射到其声明的类型。"""
    params_str = signature[signature.find("(") + 1: signature.rfind(")")]
    params = split_params(params_str)
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


def format_literal(value: float, dtype: str) -> str:
    """格式化字面量用于生成的 testbench。"""
    if dtype in {"double", "float"}:
        return f"{value:.17g}"
    if float(value).is_integer():
        return f"({dtype}){int(value)}"
    return f"({dtype})({value:.17g})"
