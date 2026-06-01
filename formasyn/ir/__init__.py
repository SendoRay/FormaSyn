"""FormaSyn IR: Three-level intermediate representation."""

from .math_dialect import MathNode, MathDialect
from .algo_hw_dialect import AlgoHWNode, AlgoHWDialect
# from .schedule_dialect import ScheduleNode, HLSScheduleDialect  # removed in RTL migration
from .rtl_dialect import RTLNode, PortDef, RTLScheduleDialect

__all__ = [
    "MathNode",
    "MathDialect",
    "AlgoHWNode",
    "AlgoHWDialect",
    "RTLNode",
    "PortDef",
    "RTLScheduleDialect",
]
