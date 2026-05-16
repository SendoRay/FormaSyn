"""统一验证流水线的数据结构定义.

本模块集中定义 L1/L2/L3 验证阶段使用的所有数据结构，包括：
- 硬件预算约束 (HardwareBudget)
- 算法质量阈值 (QualityThresholds)
- 各阶段验证结果 (L1Result, L2Result, L3Result, SynthReport)

这样 checker 模块只需从 metrics.py 导入数据结构，保持代码一致性和可维护性。
"""

from __future__ import annotations

import logging
from dataclasses import dataclass, field
from typing import Optional

from .diagnostic import FailureContext

logger = logging.getLogger(__name__)


@dataclass
class HardwareBudget:
    """硬件预算约束.

    Attributes:
        dsp: DSP 切片数量上限.
        bram: BRAM_18K 数量上限.
        lut: LUT ���量上限（可选）.
        ff: 触发器数量上限（可选）.
        target_ii: 目标启动间隔.
        clock_mhz: 目标时钟频率（MHz）.
    """

    dsp: int
    bram: int
    lut: int = 0
    ff: int = 0
    target_ii: int = 1
    clock_mhz: int = 250


@dataclass
class QualityThresholds:
    """算法质量阈值，按 kernel_type 分发.

    Attributes:
        kernel_type: 算法类别，决定使用哪些指标.
        sign_error_rate: 符号错误率上限（channel_coding）.
        nmse_db: 归一化均方误差上限（dB）.
        snr_penalty_db: 信噪比惩罚上限（dB）.
        ber_at_3db: 3dB 处的误码率上限（channel_coding）.
        sfdr_db: 无杂散动态范围下限（dB）（transform）.
        evm_percent: 误差矢量幅度上限（%）（detection）.
        rmse: 均方根误差上限（synchronization）.
    """

    kernel_type: str
    sign_error_rate: float = 0.01
    nmse_db: float = -40.0
    snr_penalty_db: float = 0.5
    ber_at_3db: float = 1e-4
    sfdr_db: float = 60.0
    evm_percent: float = 5.0
    rmse: float = 0.01

    def get_tolerance_dict(self) -> dict[str, float]:
        """返回 L1Checker/L3Checker 兼容的 tolerance 字典格式."""
        if self.kernel_type == "channel_coding":
            return {
                "sign_error_rate": self.sign_error_rate,
                "snr_penalty_db": self.snr_penalty_db,
            }
        return {"nmse_db": self.nmse_db}

    def get_quality_target_dict(self) -> dict[str, float]:
        """返回 L3Checker 兼容的 quality_target 字典格式."""
        tolerance = self.get_tolerance_dict()
        if self.kernel_type == "transform":
            tolerance["sfdr_db"] = self.sfdr_db
        elif self.kernel_type == "detection":
            tolerance["evm_percent"] = self.evm_percent
        elif self.kernel_type == "synchronization":
            tolerance["rmse"] = self.rmse
        return tolerance


@dataclass
class SynthReport:
    """Vitis HLS csynth 资源和时序报告.

    Attributes:
        dsp: 使用的 DSP 切片数量.
        bram: 使用的 BRAM_18K 数量.
        lut: 使用的 LUT 数量.
        ff: 使用的触发器数量.
        achieved_ii: 实现的启动间隔.
        clock_period_ns: 估计的时钟周期（纳秒）.
        timing_met: 时序约束是否满足.
    """

    dsp: int = 0
    bram: int = 0
    lut: int = 0
    ff: int = 0
    achieved_ii: int = 1
    clock_period_ns: float = 0.0
    timing_met: bool = True


@dataclass
class L1Result:
    """L1 csim 验证结果.

    Attributes:
        variant_id: 被测变体的标识符.
        passed: 是否通过所有验证.
        compile_ok: 编译是否成功.
        metrics: 测量的质量指标（sign_error_rate, nmse_db 等）.
        failure: 失败上下文（如果失败）.
        golden_outputs: 黄金参考输出.
        hls_outputs: HLS 仿真输出.
    """

    variant_id: str
    passed: bool = False
    compile_ok: bool = False
    metrics: dict[str, float] = field(default_factory=dict)
    failure: Optional[FailureContext] = None
    golden_outputs: dict[str, list[float]] = field(default_factory=dict)
    hls_outputs: dict[str, list[float]] = field(default_factory=dict)


@dataclass
class L2Result:
    """L2 EDA 验证结果.

    Attributes:
        variant_id: 被测变体的标识符.
        passed: 是否通过所有资源和时序检查.
        skipped: 是否跳过（Vitis HLS 不可用）.
        synth_report: 解析的综合报告.
        failure: 失败上下文（如果失败）.
    """

    variant_id: str
    passed: bool = False
    skipped: bool = False
    synth_report: Optional[SynthReport] = None
    failure: Optional[FailureContext] = None


@dataclass
class L3Result:
    """L3 Co-Sim 和质量仿真结果.

    Attributes:
        variant_id: 被测变体的标识符.
        passed: 是否通过所有质量检查.
        cosim_passed: L3a Co-Sim 是否通过（或跳过）.
        quality_passed: L3b 质量仿真是否通过.
        quality_metrics: 测量的质量指标.
        failure: 失败上下文（如果失败）.
        skipped: 是否跳过检查（无 EDA）.
    """

    variant_id: str
    passed: bool = False
    cosim_passed: bool = False
    quality_passed: bool = False
    quality_metrics: dict[str, float] = field(default_factory=dict)
    failure: Optional[FailureContext] = None
    skipped: bool = False


@dataclass
class PreCheckResult:
    """预检查结果：环境准备状态.

    Attributes:
        example_name: 示例名称.
        variant_id: 变体标识符.
        output_dir: 输出目录路径.
        config_path: HLS 配置文件路径.
        kernel_header_path: kernel.h 路径.
        testbench_path: testbench.cpp 路径.
        ready: 环境是否准备就绪.
        error: 准备过程中的错误信息（如果失败）.
    """

    example_name: str
    variant_id: str
    output_dir: str = ""
    config_path: str = ""
    kernel_header_path: str = ""
    testbench_path: str = ""
    ready: bool = False
    error: str = ""


# 向后兼容：允许从 checker.metrics 导入这些类
__all__ = [
    "HardwareBudget",
    "QualityThresholds",
    "SynthReport",
    "L1Result",
    "L2Result",
    "L3Result",
    "PreCheckResult",
]
