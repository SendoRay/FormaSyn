"""BER Simulator: channel_coding 和 demodulation 类算法的质量仿真.

计算符号错误率和 SNR 惩罚等指标。
"""

from __future__ import annotations

import logging
from typing import Optional

from FormaSyn.formasyn.checker.simulators.base import QualitySimulator

logger = logging.getLogger(__name__)


class BERSimulator(QualitySimulator):
    """BER/符号错误率仿真器.

    适用于：
    - channel_coding: LDPC, Turbo, 卷积码等
    - demodulation: QAM/PSK 软解调等

    主要指标：
    - sign_error_rate: 符号错误率
    - snr_penalty_db: 相对于 golden 的 SNR 损失
    """

    kernel_type = "channel_coding"

    def evaluate(
        self,
        hls_cpp_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        hls_header_code: str | None = None,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行 BER 仿真并返回质量指标.

        对于 channel_coding 类算法，我们通过编译 HLS 代码为 .so，
        然后用 ctypes 调用来计算实际输出，最后与 golden 比较计算符号错误率。
        """
        try:
            clean_code = self._strip_hls_specifics(hls_cpp_code)
            function_name = self._extract_function_name(hls_cpp_code)
            so_path = self._compile_to_so(clean_code, function_name, hls_header_code)

            outputs = self._run_so(
                so_path,
                function_name,
                test_inputs,
                golden_outputs,
                csr_data,
            )
        except Exception as e:
            logger.warning("BER 仿真编译/运行失败: %s", str(e)[:200])
            return {
                "sign_error_rate": 1.0,
                "snr_penalty_db": 100.0,
            }

        sign_error_rate, snr_penalty_db, _ = self._compute_sign_error_rate(
            golden_outputs, outputs
        )

        return {
            "sign_error_rate": sign_error_rate,
            "snr_penalty_db": snr_penalty_db,
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
    def _run_so(
        so_path: str,
        function_name: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        csr_data: Optional[dict[str, list[int]]],
    ) -> dict[str, list[float]]:
        """运行编译好的 .so 并解析输出."""
        import ctypes

        # 加载 .so
        lib = ctypes.CDLL(so_path)

        # 获取函数
        func = getattr(lib, function_name, None)
        if func is None:
            raise RuntimeError(f"Function '{function_name}' not found")

        # 准备输入输出数组
        outputs = {}
        for key in golden_outputs:
            out_len = len(golden_outputs[key])
            out_array = (ctypes.c_double * out_len)()
            outputs[key] = list(out_array)

        # 准备输入参数
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

        # 调用函数
        func(*args)

        # 读取输出
        result = {}
        for key, out_array in zip(golden_outputs.keys(), args[2 * len(test_inputs)::2]):
            result[key] = list(out_array)

        return result
