"""资源回退调整器：L2 DSP/LUT 超限恢复.

当 L2 验证因 DSP/LUT 超限失败时，降低并行度或位宽。
"""

from __future__ import annotations

import logging
from typing import Any

from FormaSyn.formasyn.checker.diagnostic import FailureContext, FailureStage
from FormaSyn.formasyn.feedback.relaxers.base import Action, Relaxer

logger = logging.getLogger(__name__)


class ResourceRelaxer(Relaxer):
    """L2 DSP/LUT 超限恢复：降低并行度或��宽.

    处理场景：
    - L2 资源验证失败（DSP 或 LUT 超限）
    - 原因：并行度过高或位宽过宽

    调整策略：
    - 降低 parallelism（除以 2）
    - 必要时降低数据位宽
    """

    MAX_RETRIES = 2

    def __init__(
        self,
        *,
        reduce_parallelism: bool = True,
        reduce_bitwidth: bool = False,
    ) -> None:
        """初始化 ResourceRelaxer.

        Args:
            reduce_parallelism: 是否降低并行度.
            reduce_bitwidth: 是否降低位宽.
        """
        self._reduce_parallelism = reduce_parallelism
        self._reduce_bitwidth = reduce_bitwidth

    def can_handle(self, failure: FailureContext) -> bool:
        """判断是否能处理此失败."""
        if failure.failed_at != FailureStage.L2_CSYNTH:
            return False

        # 检查是否是 DSP/LUT 超限
        for resource in ["dsp", "lut"]:
            if (
                resource in failure.resource_usage
                and resource in failure.resource_budget
            ):
                used = failure.resource_usage[resource]
                limit = failure.resource_budget[resource]
                if used > limit:
                    return True

        return False

    def relax(
        self,
        ir: Any,
        failure: FailureContext,
    ) -> tuple[Any, list[Action]]:
        """调整资源配置.

        Args:
            ir: AlgoHWDialect（包含并行度信息）.
            failure: L2 资源验证失败的上下文.

        Returns:
            (调整后的 AlgoHWDialect, 操作记录列表)
        """
        actions: list[Action] = []

        # 确定超限的资源
        overflow_resources = []
        for resource in ["dsp", "lut"]:
            if (
                resource in failure.resource_usage
                and resource in failure.resource_budget
            ):
                used = failure.resource_usage[resource]
                limit = failure.resource_budget[resource]
                if used > limit:
                    overflow_resources.append(resource)

        if not overflow_resources:
            logger.warning("ResourceRelaxer 未找到超限的资源")
            return ir, actions

        # 检查 IR 类型
        if not hasattr(ir, "nodes"):
            raise ValueError("IR 不包含 nodes 属性，无法调整资源")

        # 降低并行度
        if self._reduce_parallelism and ("dsp" in overflow_resources or "lut" in overflow_resources):
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "parallelism"):
                    continue

                old_parallelism = node.parallelism
                if old_parallelism > 1:
                    # 并行度减半，最少为 1
                    new_parallelism = max(1, old_parallelism // 2)
                    node.parallelism = new_parallelism

                    actions.append(
                        Action(
                            description=f"降低 {node_id} 并行度: {old_parallelism} -> {new_parallelism}",
                            target_stage="AlgoHWDialect",
                            params={
                                "node_id": node_id,
                                "old_parallelism": old_parallelism,
                                "new_parallelism": new_parallelism,
                            },
                        )
                    )

        # 降低位宽（如果启用）
        if self._reduce_bitwidth and actions and "lut" in overflow_resources:
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "data_type"):
                    continue

                old_dtype = node.data_type
                new_dtype = self._reduce_dtype_width(old_dtype)

                if new_dtype != old_dtype:
                    node.data_type = new_dtype
                    actions.append(
                        Action(
                            description=f"降低 {node_id} 位宽: {old_dtype} -> {new_dtype}",
                            target_stage="AlgoHWDialect",
                            params={
                                "node_id": node_id,
                                "old_dtype": old_dtype,
                                "new_dtype": new_dtype,
                            },
                        )
                    )

        if not actions:
            logger.warning("ResourceRelaxer 未找到可调整的资源参数")
        else:
            logger.info("ResourceRelaxer 执行了 %d 项调整", len(actions))

        return ir, actions

    def _reduce_dtype_width(self, dtype: str) -> str:
        """降低数据类型位宽."""
        import re

        # 处理 ap_int<N>
        int_match = re.match(r"ap_int<(\d+)>", dtype)
        if int_match:
            bits = int(int_match.group(1))
            # 减少位宽，最少 8 位
            new_bits = max(8, bits - 2)
            return f"ap_int<{new_bits}>"

        # 处理 ap_fixed<W, I>
        fixed_match = re.match(r"ap_fixed<(\d+),\s*(\d+)>", dtype)
        if fixed_match:
            total = int(fixed_match.group(1))
            integer = int(fixed_match.group(2))

            # 减少小数位
            frac = total - integer
            new_frac = max(4, frac - 2)
            new_total = integer + new_frac

            return f"ap_fixed<{new_total},{integer}>"

        return dtype

    @classmethod
    def get_stage(cls) -> FailureStage:
        """获取此 Relaxer 处理的失败阶段."""
        return FailureStage.L2_CSYNTH
