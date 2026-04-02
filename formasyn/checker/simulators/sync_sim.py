"""Sync Simulator: synchronization 类算法的质量仿真.

计算 RMSE（均方根误��）、估计偏差等同步指标。
"""

from __future__ import annotations

import logging

import numpy as np
from typing import Optional

from FormaSyn.formasyn.checker.simulators.base import QualitySimulator

logger = logging.getLogger(__name__)


class SyncSimulator(QualitySimulator):
    """同步类算法质量仿真器.

    适用于：
    - synchronization: 频偏估计、定时同步、功率检测等

    主要指标：
    - rmse: 均方根误差
    - bias_db: 估计偏差（dB）
    - nmse_db: 归一化均方误差
    """

    kernel_type = "synchronization"

    def evaluate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        hls_header_code: str | None = None,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行同步质量仿真."""
        try:
            clean_code = self._strip_hls_specifics(hls_cpp_code)
            function_name = self._extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, function_name, hls_header_code)

            outputs = self._run_so_simple(
                so_path,
                function_name,
                test_inputs,
                golden_outputs,
                csr_data,
            )
        except Exception as e:
            logger.warning("同步仿真编译/运行失败: %s", str(e)[:200])
            return {"rmse": 1.0}

        rmse = self._compute_rmse(golden_outputs, outputs)
        bias_db = self._compute_bias_db(golden_outputs, outputs)
        nmse_db = self._compute_nmse(golden_outputs, outputs)

        result = {
            "rmse": rmse,
            "nmse_db": nmse_db,
        }

        if bias_db is not None:
            result["bias_db"] = bias_db

        return result

    @staticmethod
    def _extract_function_name(code: str) -> str:
        """从 C++ 代码中提取函数名."""
        import re

        match = re.search(r"\bvoid\s+([A-Za-z_]\w*)\s*\(", code)
        if match:
            return match.group(1)
        return "kernel"

    @staticmethod
    def _run_so_simple(
        so_path: str,
        function_name: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, list[float]]:
        """简化版 .so 调用."""
        import ctypes

        lib = ctypes.CDLL(so_path)

        func = getattr(lib, function_name, None)
        if func is None:
            raise RuntimeError(f"Function '{function_name}' not found")

        outputs = {}
        for key in golden_outputs:
            out_len = len(golden_outputs[key])
            out_array = (ctypes.c_double * out_len)()
            outputs[key] = list(out_array)

        # 准备参数
        args = []
        for key, values in test_inputs.items():
            arr = (ctypes.c_double * len(values))(*values)
            args.append(arr)
            args.append(ctypes.c_int(len(values)))

        for key in golden_outputs:
            out_len = len(golden_outputs[key])
            out_array = (ctypes.c_double * out_len)()
            args.append(out_array)
            args.append(ctypes.c_int(out_len))

        if csr_data is not None:
            rp_arr = (ctypes.c_int * len(csr_data["row_ptr"]))(*csr_data["row_ptr"])
            ci_arr = (ctypes.c_int * len(csr_data["col_idx"]))(*csr_data["col_idx"])
            args.append(rp_arr)
            args.append(ctypes.c_int(len(csr_data["row_ptr"])))
            args.append(ci_arr)
            args.append(ctypes.c_int(len(csr_data["col_idx"])))

        func(*args)

        result = {}
        for key, out_array in zip(golden_outputs.keys(), args[2 * len(test_inputs)::2]):
            result[key] = list(out_array)

        return result

    def _compute_rmse(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float:
        """计算均方根误差."""
        sum_squared_error = 0.0
        total_samples = 0

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))
            g, a = g[:min_len], a[:min_len]

            error = g - a
            sum_squared_error += float(np.sum(error ** 2))
            total_samples += min_len

        if total_samples == 0:
            return 1.0

        return float(np.sqrt(sum_squared_error / total_samples))

    def _compute_bias_db(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float | None:
        """计算估计偏差（dB）.

        bias_db = 20 * log10(mean(actual) / mean(golden))
        """
        sum_golden = 0.0
        sum_actual = 0.0
        total_samples = 0

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))
            g, a = g[:min_len], a[:min_len]

            sum_golden += float(np.sum(g))
            sum_actual += float(np.sum(a))
            total_samples += min_len

        if total_samples == 0:
            return None

        mean_golden = sum_golden / total_samples
        mean_actual = sum_actual / total_samples

        if mean_golden < 1e-30 or mean_actual < 1e-30:
            return None

        bias_db = 20 * np.log10(mean_actual / mean_golden)
        return float(bias_db)
