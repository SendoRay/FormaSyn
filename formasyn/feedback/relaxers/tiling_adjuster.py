"""Tiling 调整器：L2 BRAM 超限恢复.

当 L2 验证因 BRAM 超限失败时，调整 tiling 策略。
"""

from __future__ import annotations

import logging
from typing import Any

from FormaSyn.formasyn.checker.diagnostic import FailureContext, FailureStage
from FormaSyn.formasyn.feedback.relaxers.base import Action, Relaxer

logger = logging.getLogger(__name__)


class TilingAdjuster(Relaxer):
    """L2 BRAM 超限恢复：调整 tiling/banking 策略.

    处理场景：
    - L2 资源验证失败（BRAM_18K 超限）
    - 原因：tile_size 过大或 BRAM bank 配置不当

    调整策略：
    - 减小 tile_size（除以 2）
    - 调整 BRAM bank 配置
    """

    MAX_RETRIES = 2

    def __init__(
        self,
        *,
        reduce_tile_size: bool = True,
        adjust_banks: bool = True,
    ) -> None:
        """初始化 TilingAdjuster.

        Args:
            reduce_tile_size: 是否减小 tile size.
            adjust_banks: 是否调整 BRAM bank 配置.
        """
        self._reduce_tile_size = reduce_tile_size
        self._adjust_banks = adjust_banks

    def can_handle(self, failure: FailureContext) -> bool:
        """判断是否能处理此失败."""
        if failure.failed_at != FailureStage.L2_CSYNTH:
            return False

        # 检查是否是 BRAM 超限
        if (
            "bram" in failure.resource_usage
            and "bram" in failure.resource_budget
        ):
            used = failure.resource_usage["bram"]
            limit = failure.resource_budget["bram"]
            return used > limit

        return False

    def relax(
        self,
        ir: Any,
        failure: FailureContext,
    ) -> tuple[Any, list[Action]]:
        """调整 tiling 配置.

        Args:
            ir: ScheduleDialect（包含 tiling/banking 信息）.
            failure: L2 资源验证失败的上下文.

        Returns:
            (调整后的 ScheduleDialect, 操作记录列表)
        """
        actions: list[Action] = []

        # 检查 IR 类型
        if not hasattr(ir, "nodes"):
            raise ValueError("IR 不包含 nodes 属性，无法调整 tiling")

        # 减小 tile_size
        if self._reduce_tile_size:
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "tile_size"):
                    continue

                old_tile = node.tile_size
                if old_tile and old_tile > 1:
                    # tile_size 减半，最少为 1
                    new_tile = max(1, old_tile // 2)
                    node.tile_size = new_tile

                    actions.append(
                        Action(
                            description=f"减小 {node_id} tile_size: {old_tile} -> {new_tile}",
                            target_stage="ScheduleDialect",
                            params={
                                "node_id": node_id,
                                "old_tile_size": old_tile,
                                "new_tile_size": new_tile,
                            },
                        )
                    )

        # 调整 BRAM bank 配置
        if self._adjust_banks:
            for node_id, node in ir.nodes.items():
                if not hasattr(node, "bram_banks"):
                    continue

                old_banks = node.bram_banks
                if old_banks and old_banks > 1:
                    # banks 减半，最少为 1
                    new_banks = max(1, old_banks // 2)
                    node.bram_banks = new_banks

                    actions.append(
                        Action(
                            description=f"减小 {node_id} bram_banks: {old_banks} -> {new_banks}",
                            target_stage="ScheduleDialect",
                            params={
                                "node_id": node_id,
                                "old_bram_banks": old_banks,
                                "new_bram_banks": new_banks,
                            },
                        )
                    )

        if not actions:
            logger.warning("TilingAdjuster 未找到可调整的 tiling 参数")
        else:
            logger.info("TilingAdjuster 执行了 %d 项调整", len(actions))

        return ir, actions

    @classmethod
    def get_stage(cls) -> FailureStage:
        """获取此 Relaxer 处理的失败阶段."""
        return FailureStage.L2_CSYNTH
