"""质量仿真基类.

本模块定义了所有 Quality Simulator 的基类接口，
L3b 质量仿真根据 kernel_type 分发到具体的 Simulator 实现。

Note: 自从迁移到 Verilog 后，L3 质量仿真不再编译生成代码，
而是基于 golden 参考输出进行纯 Python 质量分析。
L1 (Verilator) 负责功能正确性验证。
"""

from __future__ import annotations

import logging
from abc import ABC, abstractmethod
from typing import Optional

from ...utils.metrics import compute_nmse, compute_sign_error_rate

logger = logging.getLogger(__name__)


class QualitySimulator(ABC):
    """质量仿真基类.

    所有具体的 Simulator（BERSimulator, FilterSimulator 等）都必须继承此类
    并实现 evaluate() 方法。

    子类需要：
    1. 实现 kernel_type 类属性，指定适用的算法类别
    2. 实现 evaluate() 方法，运行仿真并返回质量指标
    """

    kernel_type: str = ""

    @abstractmethod
    def evaluate(
        self,
        generated_code: str,
        test_inputs: dict[str, list[float]],
        golden_outputs: dict[str, list[float]],
        *,
        csr_data: Optional[dict[str, list[int]]] = None,
    ) -> dict[str, float]:
        """运行仿真并返回质量指标.

        Args:
            generated_code: 生成的 Verilog 源码（用于分析，非编译执行）.
            test_inputs: 测试输入数据.
            golden_outputs: Golden 参考输出.
            csr_data: 可选的 CSR 格式稀疏矩阵数据.

        Returns:
            质量指标字典，如 {'nmse_db': -45.3, 'sfdr_db': 65.2}
        """

    # -- 指标计算 (委托给共享工具模块) -----------------------------------------

    @staticmethod
    def _compute_nmse(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> float:
        """计算归一化均方误差（NMSE）dB."""
        return compute_nmse(golden, actual)

    @staticmethod
    def _compute_sign_error_rate(
        golden: dict[str, list[float]],
        actual: dict[str, list[float]],
    ) -> tuple[float, float, float]:
        """计算符号错误率和 SNR 惩罚."""
        return compute_sign_error_rate(golden, actual)


def get_simulator(kernel_type: str) -> type[QualitySimulator]:
    """根据 kernel_type 获取对应的 Simulator 类.

    Args:
        kernel_type: 算法类别.

    Returns:
        对应的 Simulator 类.

    Raises:
        ValueError: 如果 kernel_type 不支持.
    """
    from .ber_sim import BERSimulator
    from .detection_sim import DetectionSimulator
    from .filter_sim import FilterSimulator
    from .sync_sim import SyncSimulator
    from .transform_sim import TransformSimulator

    sim_map: dict[str, type[QualitySimulator]] = {
        "channel_coding": BERSimulator,
        "demodulation": BERSimulator,
        "filtering": FilterSimulator,
        "transform": TransformSimulator,
        "detection": DetectionSimulator,
        "synchronization": SyncSimulator,
        "elementwise": TransformSimulator,
        "arithmetic": TransformSimulator,
        "generic": TransformSimulator,
    }

    sim_class = sim_map.get(kernel_type)
    if sim_class is None:
        raise ValueError(f"Unsupported kernel_type: {kernel_type}")
    return sim_class
