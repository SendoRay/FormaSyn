"""Detection Simulator: detection 类算法的质量仿真.

计算 EVM（误差矢量幅度）等检测指标。
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np

from FormaSyn.formasyn.checker.simulators.base import QualitySimulator
from FormaSyn.formasyn.utils.cpp_utils import extract_function_name
from FormaSyn.formasyn.utils.hls_mock import strip_hls_pragmas

logger = logging.getLogger(__name__)


class DetectionSimulator(QualitySimulator):
    """检测类算法质量仿真器.

    适用于：
    - detection: 均衡器、信道估计、符号检测等

    主要指标：
    - evm_percent: 误差矢量幅度（百分比）
    - nmse_db: 归一化均方误差
    """

    kernel_type = "detection"

    def evaluate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        hls_header_code: str | None = None,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行检测质量仿真."""
        try:
            clean_code = strip_hls_pragmas(hls_cpp_code)
            func_name = extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, func_name, hls_header_code)

            outputs = self._run_so_simple(
                so_path, func_name, test_inputs, golden_outputs, csr_data,
            )
        except Exception as e:
            logger.warning("检测仿真编译/运行失败: %s", str(e)[:200])
            return {"evm_percent": 100.0}

        return {
            "evm_percent": self._compute_evm(golden_outputs, outputs),
            "nmse_db": self._compute_nmse(golden_outputs, outputs),
        }

    @staticmethod
    def _compute_evm(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float:
        """计算误差矢量幅度（EVM）百分比."""
        error_power = 0.0
        ref_power = 0.0
        total_samples = 0

        for key in golden:
            g = np.array(golden[key], dtype=np.float64)
            a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
            min_len = min(len(g), len(a))
            g, a = g[:min_len], a[:min_len]

            error = g - a
            error_power += float(np.sum(error ** 2))
            ref_power += float(np.sum(g ** 2))
            total_samples += min_len

        if ref_power < 1e-30 or total_samples == 0:
            return 100.0

        return float(np.sqrt(error_power / ref_power) * 100.0)
