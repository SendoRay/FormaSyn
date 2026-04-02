"""
FormaSyn Supported Kernels Registry
====================================

作为 EDA/通信硬件专家的完整 Kernel 定义，包含：
- 当前 DSL 支持的 kernel
- 推荐的 shape/位宽/并行度变体
- 硬件约束参数

使用方法:
    from supported_kernels import KERNEL_REGISTRY
    
    # 获取特定 kernel 的所有变体
    fir_kernels = KERNEL_REGISTRY["fir_direct"]
"""

from dataclasses import dataclass, field
from typing import List, Dict, Any, Optional
from enum import Enum


class SupportStatus(Enum):
    FULLY_SUPPORTED = "✅"      # 当前 DSL 完全支持
    PARTIALLY_SUPPORTED = "⚠️"  # 需要简单扩展
    NOT_SUPPORTED = "❌"        # 需要复杂扩展


@dataclass
class KernelVariant:
    """单个 kernel 变体定义"""
    name: str                           # 变体名称
    shape: Dict[str, int]               # 形状参数 (taps, length, etc.)
    bitwidth: int                       # 位宽
    parallelism: int                    # 并行度
    approx_method: Optional[str] = None # 近似方法 (LDPC 等)
    dsp_estimate: int = 0               # 估算 DSP 数量
    bram_estimate: int = 0              # 估算 BRAM 数量
    target_freq_mhz: int = 300          # 目标频率
    

@dataclass
class KernelSpec:
    """Kernel 规格定义"""
    name: str                           # kernel 名称
    category: str                       # 类别 (filtering, coding, sync, etc.)
    status: SupportStatus               # 支持状态
    formula: str                        # 数学公式
    dsl_ops: List[str]                  # 使用的 DSL 算子
    variants: List[KernelVariant] = field(default_factory=list)
    required_new_ops: List[str] = field(default_factory=list)  # 需要的新算子
    hardware_notes: str = ""            # 硬件实现注意点
    

# =============================================================================
# 完整 Kernel 注册表
# =============================================================================

KERNEL_REGISTRY: Dict[str, KernelSpec] = {}

# -----------------------------------------------------------------------------
# 1. FIR 滤波器系列 (完全支持)
# -----------------------------------------------------------------------------

# FIR 直接型 - 标准 taps 配置
FIR_TAPS_VARIANTS = [8, 16, 32, 64, 128]
FIR_BITWIDTHS = [8, 12, 16, 18]
FIR_PARALLELISM = [1, 2, 4, 8, 16]

fir_direct_variants = []
for taps in FIR_TAPS_VARIANTS:
    for bits in FIR_BITWIDTHS:
        for para in FIR_PARALLELISM:
            # DSP 估算: taps * parallelism / 2 (对称优化)
            dsp = (taps // 2) * (1 if bits <= 8 else 1) * para
            # BRAM 估算: 延迟线存储
            bram = (taps * bits * para) // (18 * 1024) + 1
            
            fir_direct_variants.append(KernelVariant(
                name=f"fir_direct_t{taps}_b{bits}_p{para}",
                shape={"taps": taps, "input_length": 1024},
                bitwidth=bits,
                parallelism=para,
                dsp_estimate=dsp,
                bram_estimate=bram,
                target_freq_mhz=400 if taps <= 32 else 300
            ))

KERNEL_REGISTRY["fir_direct"] = KernelSpec(
    name="fir_direct",
    category="filtering",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="y[n] = Σ h[k]·x[n-k] for k=0 to N-1",
    dsl_ops=["shift_reg", "map", "reduce"],
    variants=fir_direct_variants,
    hardware_notes="对称系数可节省 50% 乘法器。级联 FIR 需要注意中间位宽扩展。"
)

# 半带滤波器 (奇数 taps，零系数跳过)
HALFBAND_TAPS = [7, 11, 15, 23, 31]
halbband_variants = []
for taps in HALFBAND_TAPS:
    for bits in [12, 16, 18]:
        for para in [1, 2, 4, 8]:
            # 半带只有约 taps/2 非零系数
            dsp = ((taps // 2 + 1) // 2) * para
            halbband_variants.append(KernelVariant(
                name=f"fir_halfband_t{taps}_b{bits}_p{para}",
                shape={"taps": taps, "input_length": 1024},
                bitwidth=bits,
                parallelism=para,
                dsp_estimate=dsp,
                bram_estimate=(taps * bits) // (18 * 1024) + 1,
                target_freq_mhz=400
            ))

KERNEL_REGISTRY["fir_halfband"] = KernelSpec(
    name="fir_halfband",
    category="filtering",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="y[n] = Σ h[k]·x[n-k] (h[k]≈0 for even k)",
    dsl_ops=["shift_reg", "map", "reduce"],
    variants=halbband_variants,
    hardware_notes="零系数跳过节省乘法器。常用于 2x 抽取/插值。"
)

# RRC 滤波器 (脉冲成形)
RRC_ROLLOFF = [0.2, 0.35, 0.5]
RRC_TAPS = [16, 32, 48, 64]
rrc_variants = []
for taps in RRC_TAPS:
    for rolloff in RRC_ROLLOFF:
        for bits in [12, 16]:
            for para in [1, 2, 4, 8]:
                rrc_variants.append(KernelVariant(
                    name=f"fir_rrc_t{taps}_r{int(rolloff*100)}_b{bits}_p{para}",
                    shape={"taps": taps, "rolloff": rolloff, "input_length": 1024},
                    bitwidth=bits,
                    parallelism=para,
                    dsp_estimate=(taps // 2) * para,
                    bram_estimate=2,
                    target_freq_mhz=400
                ))

KERNEL_REGISTRY["fir_rrc"] = KernelSpec(
    name="fir_rrc",
    category="filtering",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="RRC impulse response: h(t) = sinc(t/T)·cos(παt/T)/(1-(2αt/T)²)",
    dsl_ops=["shift_reg", "map", "reduce"],
    variants=rrc_variants,
    hardware_notes="WCDMA/LTE 标准脉冲成形。系数对称且固定，可硬连线优化。"
)

# -----------------------------------------------------------------------------
# 2. LDPC 信道编码 (完全支持)
# -----------------------------------------------------------------------------

LDPC_DC = [4, 6, 8, 12, 16, 24, 32]
LDPC_BITWIDTHS = [6, 8, 10]
LDPC_PARALLELISM = [1, 2, 4, 8]  # 通常 <= dc/2
LDPC_APPROX_METHODS = ["spa_exact", "min_sum", "offset_min_sum", "normalized_min_sum", "lut_tanh"]

ldpc_variants = []
for dc in LDPC_DC:
    for bits in LDPC_BITWIDTHS:
        for para in [p for p in LDPC_PARALLELISM if p <= dc]:
            for method in LDPC_APPROX_METHODS:
                # DSP 估算
                if method == "spa_exact":
                    dsp = dc * 3  # tanh/atanh 复杂
                elif method in ["min_sum", "offset_min_sum", "normalized_min_sum"]:
                    dsp = 1  # min 树 + scale
                else:  # lut_tanh
                    dsp = 2
                
                # 近似方法参数
                params = {}
                if method == "offset_min_sum":
                    params["offset_beta"] = 0.25
                elif method == "normalized_min_sum":
                    params["scale_factor"] = 0.75
                elif method == "lut_tanh":
                    params["lut_size"] = 256
                
                ldpc_variants.append(KernelVariant(
                    name=f"ldpc_cnu_dc{dc}_{method}_b{bits}_p{para}",
                    shape={"dc": dc, "max_iterations": 10},
                    bitwidth=bits,
                    parallelism=para,
                    approx_method=method,
                    dsp_estimate=dsp * para,
                    bram_estimate=dc * para // 4 + 4,  # 消息存储
                    target_freq_mhz=250
                ))

KERNEL_REGISTRY["ldpc_cnu"] = KernelSpec(
    name="ldpc_cnu",
    category="channel_coding",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="Check Node Update: L(r_ji) = 2·atanh(Π tanh(L(q_ij)/2))",
    dsl_ops=["map", "reduce", "message_pass"],
    variants=ldpc_variants,
    hardware_notes="Min-Sum 近似节省大量 DSP。Offset/Normalized 版本 BER 性能接近 SPA。"
)

# -----------------------------------------------------------------------------
# 3. 相关器/匹配滤波 (完全支持)
# -----------------------------------------------------------------------------

CORR_LENGTHS = [64, 128, 256, 512, 1024]
correlator_variants = []
for length in CORR_LENGTHS:
    for bits in [8, 12, 16]:
        for para in [1, 2, 4, 8]:
            correlator_variants.append(KernelVariant(
                name=f"correlator_real_n{length}_b{bits}_p{para}",
                shape={"length": length, "input_length": 4096},
                bitwidth=bits,
                parallelism=para,
                dsp_estimate=(length // para) * para if para < length else length,
                bram_estimate=length * bits // (18 * 1024) + 1,
                target_freq_mhz=350
            ))

KERNEL_REGISTRY["correlator_real"] = KernelSpec(
    name="correlator_real",
    category="synchronization",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="R[m] = Σ x[n]·p[n-m]",
    dsl_ops=["shift_reg", "map", "reduce"],
    variants=correlator_variants,
    hardware_notes="滑动窗口实现。长序列可用分段相关降低资源。"
)

# 复数相关器 (两个实数相关器 + 组合)
complex_corr_variants = []
for length in [64, 128, 256, 512]:
    for bits in [8, 12, 16]:
        for para in [1, 2, 4]:
            complex_corr_variants.append(KernelVariant(
                name=f"correlator_complex_n{length}_b{bits}_p{para}",
                shape={"length": length, "input_length": 4096},
                bitwidth=bits,
                parallelism=para,
                dsp_estimate=(length // para) * para * 4,  # 复数乘法 = 4 实数乘法
                bram_estimate=length * bits * 2 // (18 * 1024) + 2,
                target_freq_mhz=300
            ))

KERNEL_REGISTRY["correlator_complex"] = KernelSpec(
    name="correlator_complex",
    category="synchronization",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="R[m] = Σ x[n]·conj(p[n-m])",
    dsl_ops=["shift_reg", "map", "reduce"],  # 需要 4 个 map + 2 个 reduce
    variants=complex_corr_variants,
    hardware_notes="实部和虚部分开处理，最后组合。或用复数乘法器 IP。"
)

# -----------------------------------------------------------------------------
# 4. 向量运算 (完全支持 - 基础构建块)
# -----------------------------------------------------------------------------

VEC_SIZES = [16, 64, 256, 1024, 4096]
vec_add_variants = []
for size in VEC_SIZES:
    for bits in [8, 12, 16, 32]:
        for para in [1, 2, 4, 8, 16, 32]:
            if para <= size:
                vec_add_variants.append(KernelVariant(
                    name=f"vec_add_n{size}_b{bits}_p{para}",
                    shape={"size": size},
                    bitwidth=bits,
                    parallelism=para,
                    dsp_estimate=0,  # 加法用 LUT
                    bram_estimate=0,
                    target_freq_mhz=500
                ))

KERNEL_REGISTRY["vec_add"] = KernelSpec(
    name="vec_add",
    category="vector",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="c[i] = a[i] + b[i]",
    dsl_ops=["map"],
    variants=vec_add_variants,
    hardware_notes="纯 LUT 实现。高位宽时考虑 DSP 级联。"
)

# MAC (Multiply-Accumulate) - 点积
vec_mac_variants = []
for size in [16, 64, 256, 1024]:
    for bits in [8, 12, 16]:
        for para in [1, 2, 4, 8]:
            vec_mac_variants.append(KernelVariant(
                name=f"vec_mac_n{size}_b{bits}_p{para}",
                shape={"size": size},
                bitwidth=bits,
                parallelism=para,
                dsp_estimate=para,  # 并行度 = DSP 数
                bram_estimate=0,
                target_freq_mhz=450
            ))

KERNEL_REGISTRY["vec_mac"] = KernelSpec(
    name="vec_mac",
    category="vector",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="acc = Σ a[i]·b[i]",
    dsl_ops=["map", "reduce"],
    variants=vec_mac_variants,
    hardware_notes="使用 DSP 内建累加器。注意位宽扩展（需要 2x 位宽存储累加值）。"
)

# -----------------------------------------------------------------------------
# 5. 调制映射 (完全支持 - LUT 实现)
# -----------------------------------------------------------------------------

MODULATIONS = [
    ("bpsk", 1, [-1, 1]),
    ("qpsk", 2, [(-0.707-0.707j), (-0.707+0.707j), (0.707-0.707j), (0.707+0.707j)]),
]

modem_variants = []
for name, bits_per_sym, constellation in MODULATIONS:
    for bits in [12, 16]:
        for para in [1, 2, 4, 8, 16]:
            modem_variants.append(KernelVariant(
                name=f"modem_{name}_b{bits}_p{para}",
                shape={"bits_per_symbol": bits_per_sym},
                bitwidth=bits,
                parallelism=para,
                dsp_estimate=0,  # LUT 实现
                bram_estimate=1 if bits_per_sym > 2 else 0,
                target_freq_mhz=500
            ))

KERNEL_REGISTRY["modem_bpsk_qpsk"] = KernelSpec(
    name="modem_bpsk_qpsk",
    category="modulation",
    status=SupportStatus.FULLY_SUPPORTED,
    formula="LUT mapping: bits -> constellation point",
    dsl_ops=["map", "lut"],
    variants=modem_variants,
    hardware_notes="小星座用 LUT。大星座（256-QAM）需要分段 LUT 或计算。"
)

# -----------------------------------------------------------------------------
# 6. IIR 滤波器 (需要 FeedbackOp)
# -----------------------------------------------------------------------------

KERNEL_REGISTRY["iir_biquad"] = KernelSpec(
    name="iir_biquad",
    category="filtering",
    status=SupportStatus.NOT_SUPPORTED,
    formula="y[n] = b0·x[n] + b1·x[n-1] + b2·x[n-2] - a1·y[n-1] - a2·y[n-2]",
    dsl_ops=["shift_reg", "map", "reduce"],
    variants=[
        KernelVariant(
            name="iir_biquad_b16_p1",
            shape={"sections": 2, "order": 2},
            bitwidth=16,
            parallelism=1,
            dsp_estimate=5,  # 4 乘法 + 1 累加
            bram_estimate=0,
            target_freq_mhz=300
        ),
        KernelVariant(
            name="iir_biquad_b16_p4",
            shape={"sections": 4, "order": 2},
            bitwidth=16,
            parallelism=4,
            dsp_estimate=20,
            bram_estimate=0,
            target_freq_mhz=250
        ),
    ],
    required_new_ops=["FeedbackOp"],
    hardware_notes="IIR 需要反馈路径 y[n-1]。FPGA 实现注意稳定性（系数敏感性）。"
)

# -----------------------------------------------------------------------------
# 7. FFT (需要 ButterflyOp)
# -----------------------------------------------------------------------------

FFT_SIZES = [64, 128, 256, 512, 1024, 2048]
fft_variants = []
for size in FFT_SIZES:
    for bits in [12, 16]:
        for para in [1, 2, 4]:
            # 估算: N·log2(N) 蝶形 / 并行度
            butterflies = size * (size.bit_length() - 1)
            dsp = (butterflies // para) * 3 if para < butterflies else butterflies * 3  # 复数乘法
            fft_variants.append(KernelVariant(
                name=f"fft_radix2_n{size}_b{bits}_p{para}",
                shape={"size": size, "radix": 2},
                bitwidth=bits,
                parallelism=para,
                dsp_estimate=min(dsp, 64),  # 实际有限制
                bram_estimate=size * 2 * bits // (18 * 1024) + 4,  # 旋转因子 + 数据
                target_freq_mhz=350
            ))

KERNEL_REGISTRY["fft"] = KernelSpec(
    name="fft",
    category="transform",
    status=SupportStatus.NOT_SUPPORTED,
    formula="X[k] = Σ x[n]·exp(-j2πkn/N)",
    dsl_ops=[],
    variants=fft_variants,
    required_new_ops=["ButterflyOp"],
    hardware_notes="FPGA 通常用 Xilinx FFT IP 或类似。流水线 FFT 需要仔细调度。"
)

# -----------------------------------------------------------------------------
# 8. Viterbi 译码 (需要 TrellisOp)
# -----------------------------------------------------------------------------

KERNEL_REGISTRY["viterbi_k7"] = KernelSpec(
    name="viterbi_k7",
    category="channel_coding",
    status=SupportStatus.NOT_SUPPORTED,
    formula="Viterbi algorithm: ACS (Add-Compare-Select) recursion",
    dsl_ops=[],
    variants=[
        KernelVariant(
            name="viterbi_k7_soft_b8",
            shape={"constraint_length": 7, "states": 64, "code_rate": 0.5},
            bitwidth=8,
            parallelism=1,
            dsp_estimate=0,  # ACS 用 LUT
            bram_estimate=8,  # 路径度量存储
            target_freq_mhz=200
        ),
        KernelVariant(
            name="viterbi_k7_soft_b8_p64",  # 全状态并行
            shape={"constraint_length": 7, "states": 64, "code_rate": 0.5},
            bitwidth=8,
            parallelism=64,
            dsp_estimate=0,
            bram_estimate=16,
            target_freq_mhz=150
        ),
    ],
    required_new_ops=["TrellisOp"],
    hardware_notes="ACS 是递归操作。高并行度时布线拥塞严重。WiFi/GSM 常用。"
)

# -----------------------------------------------------------------------------
# 9. AGC (需要 FeedbackOp)
# -----------------------------------------------------------------------------

KERNEL_REGISTRY["agc"] = KernelSpec(
    name="agc",
    category="synchronization",
    status=SupportStatus.NOT_SUPPORTED,
    formula="g[n] = g[n-1] + μ·(target - |y[n]|)",
    dsl_ops=[],
    variants=[
        KernelVariant(
            name="agc_loop_b16",
            shape={"loop_bandwidth": 0.01},
            bitwidth=16,
            parallelism=1,
            dsp_estimate=2,
            bram_estimate=0,
            target_freq_mhz=300
        ),
    ],
    required_new_ops=["FeedbackOp"],
    hardware_notes="闭环反馈。收敛速度和稳定性需要仔细调校。"
)


# =============================================================================
# 辅助函数
# =============================================================================

def list_supported_kernels():
    """列出所有完全支持的 kernel"""
    return {k: v for k, v in KERNEL_REGISTRY.items() 
            if v.status == SupportStatus.FULLY_SUPPORTED}


def list_kernels_needing_extensions():
    """列出需要扩展的 kernel"""
    return {k: v for k, v in KERNEL_REGISTRY.items() 
            if v.status != SupportStatus.FULLY_SUPPORTED}


def get_variants_by_category(category: str):
    """按类别获取变体"""
    return {k: v for k, v in KERNEL_REGISTRY.items() 
            if v.category == category}


def estimate_total_variants():
    """估算总变体数量"""
    total = 0
    for spec in KERNEL_REGISTRY.values():
        total += len(spec.variants)
    return total


# =============================================================================
# 报告生成
# =============================================================================

if __name__ == "__main__":
    print("=" * 80)
    print("FormaSyn Kernel Registry Report")
    print("=" * 80)
    
    print("\n## 支持状态统计\n")
    
    supported = list_supported_kernels()
    unsupported = list_kernels_needing_extensions()
    
    print(f"✅ 完全支持: {len(supported)} kernels, {sum(len(v.variants) for v in supported.values())} 变体")
    print(f"⚠️/❌ 需扩展: {len(unsupported)} kernels, {sum(len(v.variants) for v in unsupported.values())} 变体")
    print(f"总计: {estimate_total_variants()} 变体")
    
    print("\n## 完全支持的 Kernels\n")
    for name, spec in supported.items():
        print(f"- {name}: {len(spec.variants)} 变体 ({spec.category})")
        print(f"  算子: {', '.join(spec.dsl_ops)}")
    
    print("\n## 需要扩展的 Kernels\n")
    for name, spec in unsupported.items():
        print(f"- {name}: {spec.status.value} {spec.required_new_ops}")
        print(f"  原因: {spec.hardware_notes[:80]}...")
    
    print("\n## 按类别分布\n")
    categories = set(v.category for v in KERNEL_REGISTRY.values())
    for cat in sorted(categories):
        kernels = get_variants_by_category(cat)
        variant_count = sum(len(v.variants) for v in kernels.values())
        print(f"- {cat}: {len(kernels)} kernels, {variant_count} 变体")
