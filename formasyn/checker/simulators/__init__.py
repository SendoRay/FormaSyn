"""质量仿真模块：按 kernel_type 分发的 L3b 质量仿真.

本模块提供各类算法的质量仿真器，通过 get_simulator() 函数
根据 kernel_type 自动选择对应的 Simulator。
"""

from FormaSyn.formasyn.checker.simulators.base import (
    QualitySimulator,
    get_simulator,
)
from FormaSyn.formasyn.checker.simulators.ber_sim import BERSimulator
from FormaSyn.formasyn.checker.simulators.detection_sim import DetectionSimulator
from FormaSyn.formasyn.checker.simulators.filter_sim import FilterSimulator
from FormaSyn.formasyn.checker.simulators.sync_sim import SyncSimulator
from FormaSyn.formasyn.checker.simulators.transform_sim import TransformSimulator

__all__ = [
    "QualitySimulator",
    "get_simulator",
    "BERSimulator",
    "FilterSimulator",
    "TransformSimulator",
    "DetectionSimulator",
    "SyncSimulator",
]
