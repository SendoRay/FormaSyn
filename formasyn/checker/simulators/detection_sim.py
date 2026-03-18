"""Detection Simulator: detection 类算法的质量仿真.

计算 EVM（误差矢量幅度）等检测指标。
"""

from __future__ import annotations

import logging

import numpy as np
from typing import Optional

from FormaSyn.formasyn.checker.simulators.base import QualitySimulator

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
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行检测质量仿真."""
        try:
            clean_code = self._strip_hls_specifics(hls_cpp_code)
            function_name = self._extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, function_name)

            outputs = self._run_so_simple(
                so_path,
                function_name,
                test_inputs,
                golden_outputs,
                csr_data,
            )
        except Exception as e:
            logger.warning("检测仿真编译/运行失败: %s", str(e)[:200])
            return {"evm_percent": 100.0}

        evm_percent = self._compute_evm(golden_outputs, outputs)
        nmse_db = self._compute_nmse(golden_outputs, outputs)

        return {
            "evm_percent": evm_percent,
            "nmse_db": nmse_db,
        }

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

        try:
            func = lib[function_name]
        except AttributeError:
            func = lib

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

    def _compute_evm(
        self,
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float:
        """计算误差矢量幅度（EVM）百分比.

        EVM = sqrt(sum(|error|^2) / sum(|reference|^2)) * 100%

        常用于调制解调质量评估。
        """
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

        evm_rms = np.sqrt(error_power / ref_power)
        return float(evm_rms * 100.0)
