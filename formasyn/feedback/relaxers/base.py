"""失败回退调整器基类.

本模块定义了所有 Relaxer 的基��接口，用于在验证失败后
调整 IR 并返回新版本。
"""

from __future__ import annotations

import logging
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Any

from FormaSyn.formasyn.checker.diagnostic import FailureContext, FailureStage

logger = logging.getLogger(__name__)


@dataclass
class Action:
    """调整操作记录.

    Attributes:
        description: 操作描述.
        target_stage: 目标阶段（哪个 IR 层）.
        params: 操作参数.
    """

    description: str
    target_stage: str
    params: dict[str, Any] = field(default_factory=dict)


class Relaxer(ABC):
    """回退调整器基类.

    所有的 Relaxer（QuantizationRelaxer, ResourceRelaxer, TilingAdjuster）
    都必须继承此类并实现相关方法。

    Relaxer 的工作流程：
    1. can_handle() - 判断是否能处理此失败
    2. relax() - 调整 IR 并返回新版本和操作记录
    """

    # 最大重试次数
    MAX_RETRIES: int = 2

    @abstractmethod
    def can_handle(self, failure: FailureContext) -> bool:
        """判断是否能处理此失败.

        Args:
            failure: 失败上下文.

        Returns:
            是否能处理此失败.
        """
        pass

    @abstractmethod
    def relax(
        self,
        ir: Any,
        failure: FailureContext,
    ) -> tuple[Any, list[Action]]:
        """调整 IR 并返回新版本和操作记录.

        Args:
            ir: 输入 IR（可以是 MathDialect, AlgoHWDialect, ScheduleDialect 等）.
            failure: 失败上下文.

        Returns:
            (调整后的 IR, 操作记录列表)
        """
        pass

    @classmethod
    def get_stage(cls) -> FailureStage:
        """获取此 Relaxer 处理的失败阶段."""
        return FailureStage.L1_NUMERIC


@dataclass
class RelaxerResult:
    """Relaxer 执行结果.

    Attributes:
        success: 是否成功调整.
        new_ir: 调整后的 IR.
        actions: 执行的操作列表.
        error: 错误信息（如果失败）.
    """

    success: bool
    new_ir: Any = None
    actions: list[Action] = field(default_factory=list)
    error: str = ""


class RelaxerChain:
    """Relaxer 链：按优先级尝试多个 Relaxer.

    当一个 Relaxer 无法处理或处理失败时，尝试下一个。
    """

    def __init__(self, relaxers: list[Relaxer]) -> None:
        """初始化 Relaxer 链.

        Args:
            relaxers: Relaxer 列表，按优先级排序.
        """
        self._relaxers = relaxers

    def try_relax(
        self,
        ir: Any,
        failure: FailureContext,
    ) -> RelaxerResult:
        """依次尝试每个 Relaxer 直到成功或全部失败.

        Args:
            ir: 输入 IR.
            failure: 失败上下文.

        Returns:
            RelaxerResult，包含成功/失败状态和结果.
        """
        for relaxer in self._relaxers:
            if not relaxer.can_handle(failure):
                continue

            try:
                new_ir, actions = relaxer.relax(ir, failure)
                return RelaxerResult(
                    success=True,
                    new_ir=new_ir,
                    actions=actions,
                )
            except Exception as e:
                logger.warning(
                    "Relaxer %s 处理失败: %s",
                    type(relaxer).__name__,
                    str(e)[:200],
                )
                continue

        return RelaxerResult(
            success=False,
            error="没有适用的 Relaxer",
        )
