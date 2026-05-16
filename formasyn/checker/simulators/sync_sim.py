"""Sync Simulator: synchronization 类算法的质量仿真.

计算 RMSE（均方根误差）、估计偏差等同步指标。
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np

from FormaSyn.formasyn.checker.simulators.base import QualitySimulator
from FormaSyn.formasyn.utils.cpp_utils import extract_function_name
from FormaSyn.formasyn.utils.hls_mock import strip_hls_pragmas

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
            clean_code = strip_hls_pragmas(hls_cpp_code)
            func_name = extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, func_name, hls_header_code)

            outputs = self._run_so_simple(
                so_path, func_name, test_inputs, golden_outputs, csr_data,
            )
        except Exception as e:
            logger.warning("同步仿真编译/运行失败: %s", str(e)[:200])
            return {"rmse": 1.0}

        rmse = self._compute_rmse(golden_outputs, outputs)
        result = {
            "rmse": rmse,
            "nmse_db": self._compute_nmse(golden_outputs, outputs),
        }

        bias_db = self._compute_bias_db(golden_outputs, outputs)
        if bias_db is not None:
            result["bias_db"] = bias_db

        return result

    @staticmethod
    def _compute_rmse(
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

    @staticmethod
    def _compute_bias_db(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float | None:
        """计算估计偏差（dB）."""
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

        return float(20 * np.log10(mean_actual / mean_golden))
