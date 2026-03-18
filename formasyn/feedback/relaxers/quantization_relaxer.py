"""量化回退调整器：L1 数值错误恢复.

当 L1 验证因量化太激进导致数值错误时，放宽位宽要求。
"""

from __future__ import annotations

import logging
from typing import Any

from FormaSyn.formasyn.checker.diagnostic import FailureContext, FailureStage
from FormaSyn.formasyn.feedback.relaxers.base import Action, Relaxer, RelaxerResult

logger = logging.getLogger(__name__)


class QuantizationRelaxer(Relaxer):
    """L1 数值错误恢复：放宽量化位宽.

    处理场景：
    - L1 数值验证失败（sign_error_rate �� nmse_db 超限）
    - 原因：量化位宽设置太激进

    调整策略：
    - 将整数位增加 1-2 位
    - 将小数位增加 2-4 位
    """

    MAX_RETRIES = 2

    def can_handle(self, failure: FailureContext) -> bool:
        """判断是否能处理此失败."""
        return failure.failed_at == FailureStage.L1_NUMERIC

    def relax(
        self,
        ir: Any,
        failure: FailureContext,
    ) -> tuple[Any, list[Action]]:
        """调整量化参数.

        Args:
            ir: AlgoHWDialect（包含量化信息）.
            failure: L1 数值验证失败的上下文.

        Returns:
            (调整后的 AlgoHWDialect, 操作记录列表)
        """
        actions: list[Action] = []

        # 检查 IR 类型
        if not hasattr(ir, "nodes"):
            raise ValueError("IR 不包含 nodes 属性，无法调整量化")

        # 遍历所有节点，调整量化位宽
        for node_id, node in ir.nodes.items():
            if not hasattr(node, "data_type"):
                continue

            old_dtype = node.data_type
            new_dtype = self._relax_dtype(old_dtype)

            if new_dtype != old_dtype:
                node.data_type = new_dtype
                actions.append(
                    Action(
                        description=f"放宽 {node_id} 量化位宽: {old_dtype} -> {new_dtype}",
                        target_stage="AlgoHWDialect",
                        params={
                            "node_id": node_id,
                            "old_dtype": old_dtype,
                            "new_dtype": new_dtype,
                        },
                    )
                )

        if not actions:
            logger.warning("QuantizationRelaxer 未找到可调整的量化参数")
        else:
            logger.info("QuantizationRelaxer 调整了 %d 个节点的量化位宽", len(actions))

        return ir, actions

    def _relax_dtype(self, dtype: str) -> str:
        """放宽数据类型位宽.

        Args:
            dtype: 原始数据类型，如 "ap_int<16>", "ap_fixed<16,8>" 等.

        Returns:
            放宽后的数据类型.
        """
        import re

        # 处理 ap_int<N>
        int_match = re.match(r"ap_int<(\d+)>", dtype)
        if int_match:
            bits = int(int_match.group(1))
            # 增加整数位宽
            new_bits = min(bits + 2, 64)
            return f"ap_int<{new_bits}>"

        # 处理 ap_uint<N>
        uint_match = re.match(r"ap_uint<(\d+)>", dtype)
        if uint_match:
            bits = int(uint_match.group(1))
            new_bits = min(bits + 2, 64)
            return f"ap_uint<{new_bits}>"

        # 处理 ap_fixed<W, I>
        fixed_match = re.match(r"ap_fixed<(\d+),\s*(\d+)>", dtype)
        if fixed_match:
            total = int(fixed_match.group(1))
            integer = int(fixed_match.group(2))
            frac = total - integer

            # 增加小数位和总位宽
            new_integer = integer + 1
            new_frac = min(frac + 3, 48)
            new_total = new_integer + new_frac

            return f"ap_fixed<{new_total},{new_integer}>"

        # 处理 ap_ufixed<W, I>
        ufixed_match = re.match(r"ap_ufixed<(\d+),\s*(\d+)>", dtype)
        if ufixed_match:
            total = int(ufixed_match.group(1))
            integer = int(ufixed_match.group(2))
            frac = total - integer

            new_integer = integer + 1
            new_frac = min(frac + 3, 48)
            new_total = new_integer + new_frac

            return f"ap_ufixed<{new_total},{new_integer}>"

        # 无法识别的类型，保持不变
        return dtype

    @classmethod
    def get_stage(cls) -> FailureStage:
        """获取此 Relaxer 处理的失败阶段."""
        return FailureStage.L1_NUMERIC
