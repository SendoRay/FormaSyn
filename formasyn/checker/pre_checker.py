"""验证前环境准备：配置文件、目录结构、golden 数据验证.

本模块在调用 L1Checker 之前统一处理环境准备逻辑：
- 创建输出目录结构
- 生成 hls_config.cfg
- 准备 kernel.h（如需要）
- 验证 golden 数据格式
"""

from __future__ import annotations

import logging
import os
from pathlib import Path
from typing import Optional

from .metrics import PreCheckResult
from ..golden.testbench_gen import TestbenchGenerator, TestbenchSpec

logger = logging.getLogger(__name__)


class PreChecker:
    """验证前环境准备：配置文件、目录结构、golden 数据.

    这个类负责在运行 L1/L2/L3 验证之前准备好所有必要的环境，
    包括目录结构、配置文件和测试数据。
    """

    DEFAULT_PART = "xc7z020clg400-1"
    DEFAULT_CLOCK = "10ns"

    def __init__(
        self,
        *,
        part: str = DEFAULT_PART,
        clock: str = DEFAULT_CLOCK,
        output_root: str | Path = "/tmp/formasyn_checker",
        examples_root: str | Path | None = None,
    ) -> None:
        """初始化 PreChecker.

        Args:
            part: FPGA 部件型号.
            clock: 时钟周期字符串.
            output_root: 输出根目录（用于兼容旧代码）.
            examples_root: 示例根目录，中间文件将保存到 examples_root/example_name/inter_files/variant_id.
        """
        self._part = part
        self._clock = clock
        self._examples_root = Path(examples_root) if examples_root else None
        self._output_root = Path(output_root)
        self._tb_gen = TestbenchGenerator()

    def prepare_environment(
        self,
        example_name: str,
        variant_id: str,
        hls_cpp_code: str,
        golden_outputs: dict[str, list[float]],
        test_inputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> PreCheckResult:
        """准备 Vitis HLS 运行环境.

        执行以下步骤：
        1. 创建输出目录
        2. 验证 golden 数据格式
        3. 生成 hls_config.cfg
        4. 准备 kernel.h（如需要）
        5. 生成 testbench.cpp（供 L1/L3 使用）

        Args:
            example_name: 示例名称（如 "fir_16tap", "ldpc_cnu"）.
            variant_id: 变体标识符（如 "baseline", "spa_p4"）.
            hls_cpp_code: HLS C++ 源码.
            golden_outputs: Golden 参考输出.
            test_inputs: 测试输入数据.
            csr_data: 可选的 CSR 格式稀疏矩阵数据.

        Returns:
            PreCheckResult 包含所有生成的文件路径和状态.
        """
        result = PreCheckResult(
            example_name=example_name,
            variant_id=variant_id,
        )

        # 验证输入
        validation_error = self._validate_inputs(
            hls_cpp_code, golden_outputs, test_inputs
        )
        if validation_error:
            result.error = validation_error
            return result

        # 创建输出目录
        output_dir = self._create_output_dir(example_name, variant_id)
        result.output_dir = str(output_dir)

        # 生成 testbundle（testbench + config + header）
        try:
            spec = TestbenchSpec(
                hls_cpp_code=hls_cpp_code,
                test_inputs=test_inputs,
                golden_outputs=golden_outputs,
                csr_data=csr_data,
                part=self._part,
                clock=self._clock,
            )
            bundle = self._tb_gen.generate_bundle(spec)

            # 写入 testbench.cpp
            testbench_path = output_dir / f"{bundle.function_name}_tb.cpp"
            testbench_path.write_text(bundle.testbench_code, encoding="utf-8")
            result.testbench_path = str(testbench_path)

            # 写入 hls_config.cfg
            config_path = output_dir / "hls_config.cfg"
            config_path.write_text(bundle.hls_config, encoding="utf-8")
            result.config_path = str(config_path)

            # 如果需要 kernel.h，写入它
            if bundle.kernel_header:
                header_path = output_dir / "kernel.h"
                header_path.write_text(bundle.kernel_header, encoding="utf-8")
                result.kernel_header_path = str(header_path)

            # 写入 HLS kernel 源码
            kernel_path = output_dir / f"{bundle.function_name}.cpp"
            kernel_path.write_text(hls_cpp_code, encoding="utf-8")

            result.ready = True
            logger.info(
                "PreChecker 准备完成 [%s]: dir=%s",
                variant_id,
                output_dir,
            )

        except Exception as e:
            result.error = f"环境准备失败: {e}"
            logger.warning("PreChecker 失败 [%s]: %s", variant_id, result.error)

        return result

    def _create_output_dir(self, example_name: str, variant_id: str) -> Path:
        """创建输出目录结构.

        如果设置了 examples_root，则使用 examples_root/example_name/inter_files/variant_id，
        否则使用 output_root/example_name/variant_id（兼容旧代码）.
        """
        if self._examples_root:
            output_dir = self._examples_root / example_name / "inter_files" / variant_id
        else:
            output_dir = self._output_root / example_name / variant_id
        output_dir.mkdir(parents=True, exist_ok=True)
        return output_dir

    @staticmethod
    def _validate_inputs(
        hls_cpp_code: str,
        golden_outputs: dict[str, list[float]],
        test_inputs: dict[str, list[float]],
    ) -> str | None:
        """验证输入数据格式.

        Returns:
            错误信息字符串，如果验证通过则返回 None.
        """
        if not hls_cpp_code.strip():
            return "HLS C++ 代码为空"

        if not golden_outputs:
            return "Golden 输出数据为空"

        if not test_inputs:
            return "测试输入数据为空"

        # 验证 golden 输出格式
        for key, values in golden_outputs.items():
            if not isinstance(values, list):
                return f"Golden 输出 '{key}' 不是列表类型"
            if not values:
                return f"Golden 输出 '{key}' 为空列表"

        return None

    def get_output_dir(self, example_name: str, variant_id: str) -> Path:
        """获取指定示例和变体的输出目录（不自动创建）.

        Args:
            example_name: 示例名称.
            variant_id: 变体标识符.

        Returns:
            输出目录的 Path 对象.
        """
        return self._output_root / example_name / variant_id

    def cleanup_variant(self, example_name: str, variant_id: str) -> bool:
        """清理指定变体的输出目录.

        Args:
            example_name: 示例名称.
            variant_id: 变体标识符.

        Returns:
            是否成功清理.
        """
        output_dir = self.get_output_dir(example_name, variant_id)
        try:
            if output_dir.exists():
                import shutil

                shutil.rmtree(output_dir)
                logger.info("清理输出目录 [%s]: %s", variant_id, output_dir)
                return True
        except Exception as e:
            logger.warning("清理输出目录失败 [%s]: %s", variant_id, e)
        return False
