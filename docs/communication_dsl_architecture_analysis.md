# FormaSyn 通信领域 DSL 架构分析报告

## 执行摘要

作为对比分析的参考框架：
- **Spiral (CMU)**: 基于数学公式（SPL/Σ-SPL）的信号处理代码/硬件生成器
- **Delite (Stanford PPL)**: 异构并行 DSL 框架，支持多后端代码生成

**核心结论**: 当前 FormaSyn DSL 处于**基础阶段**，距离实现"从通信数学公式直接生成硬件"的目标还有显著差距。当前仅支持约 **30-40%** 的通信核心算法，需要系统性架构升级才能达到类似 Spiral/Delite 的成熟度。

---

## 一、参考架构分析

### 1.1 Spiral 框架核心思想

```
数学公式 (SPL) → 算法重写优化 → 结构优化 (Σ-SPL) → 代码/硬件生成
     ↑                                                  ↓
  Breakdown Rules                                Verilog/VHDL/C
```

**关键技术**:
- **SPL (Signal Processing Language)**: 基于 Kronecker 积的数学 DSL
  ```
  DFT_n = (DFT_k ⊗ I_m) · T · (I_k ⊗ DFT_m) · L  // Cooley-Tukey FFT
  ```
- **Σ-SPL**: 引入循环和索引的扩展，支持存储访问优化
- **重写系统**: 基于规则的算法空间探索
- **硬件公式**: 显式描述并行度、流水线、存储层次

### 1.2 Delite 框架核心思想

```
DSL 程序 (Scala嵌入) → LMS IR → 并行优化 → 异构代码生成 → 运行时调度
                             ↓
                    Vector/Matrix/Graph Ops
```

**关键技术**:
- **LMS (Lightweight Modular Staging)**: 编译时分阶段求值
- **多态数据类型**: Vector/Matrix/Graph 统一抽象
- **并行模式**: Map/Reduce/Scan/ZipWith 内置并行
- **异构后端**: Scala/C++/CUDA 统一代码生成

---

## 二、FormaSyn 现状评估

### 2.1 当前 DSL 算子矩阵

| 算子 | 类型 | 表达能力 | 硬件映射 | 覆盖率 |
|------|------|----------|----------|--------|
| `MapOp` | 元素级映射 | ⭐⭐⭐ | LUT/DSP | 基础 |
| `ReduceOp` | 归约 | ⭐⭐⭐ | 归约树 | 基础 |
| `ShiftRegOp` | 移位寄存器 | ⭐⭐⭐ | 寄存器链 | FIR/相关器 |
| `DelayOp` | 固定延迟 | ⭐⭐⭐ | 寄存器 | 简单延迟 |
| `MessagePassOp` | 图消息传递 | ⭐⭐ | BRAM | LDPC |

### 2.2 与 Spiral/Delite 的关键差距

| 维度 | Spiral | Delite | FormaSyn (当前) |
|------|--------|--------|-----------------|
| **数学抽象** | Kronecker 积公式 | 线性代数操作 | 数据流图 (DAG) |
| **算法空间探索** | 重写规则系统 | 编译时多版本生成 | 无 |
| **存储层次建模** | Σ-SPL 显式描述 | 运行时内存管理 | 隐式/无 |
| **反馈/递归** | 支持 (IIR/状态机) | 支持 (迭代算法) | ❌ **不支持** |
| **复数类型** | 原生支持 | 复数运算库 | ❌ **不支持** |
| **蝶形网络** | FFT 核心结构 | 并行模式 | ❌ **不支持** |
| **参数化硬件** | 全参数化 | 编译时常量 | 部分支持 |
| **多后端** | C/Verilog/FPGA | Scala/C++/CUDA | HLS C++ |

---

## 三、通信算法覆盖度分析

### 3.1 当前支持（30-40%）

```python
# 可直接表达
✅ FIR 滤波器: y[n] = Σ h[k]·x[n-k]
✅ LDPC CNU: min-sum / SPA 消息传递
✅ 实数相关: R[m] = Σ x[n]·p[n-m]
✅ 调制映射: LUT-based QAM/PSK
✅ 向量运算: add/mul/mac/max
```

### 3.2 需要扩展（60-70%）

```python
# 需要 FeedbackOp
⚠️ IIR 滤波器: y[n] = Σb·x[n-k] - Σa·y[n-k]
⚠️ AGC: g[n] = g[n-1] + μ·(A - |y[n]|)
⚠️ PLL: θ[n] = θ[n-1] + α·e[n] + β·Σe[k]

# 需要 ButterflyOp
⚠️ FFT: X[k] = Σ x[n]·W_N^(nk), W_N = e^(-j2π/N)
⚠️ OFDM: FFT/IFFT + CP + 子载波映射

# 需要 TrellisOp
❌ Viterbi: ACS (Add-Compare-Select)
❌ Turbo: BCJR 前向-后向算法

# 需要 MatrixOp
❌ MIMO MMSE: ŝ = (H^H·H + σ²I)^(-1)·H^H·y
❌ MIMO ML: min ||y - H·s||²

# 需要 SortOp
❌ Polar SCL: 路径度量排序
```

### 3.3 覆盖度对比表

| 通信系统模块 | 当前 DSL | +Feedback | +Butterfly | +Trellis | +Matrix |
|--------------|----------|-----------|------------|----------|---------|
| WiFi 802.11a/g | 60% | 70% | 85% | 100% | 100% |
| 5G NR | 40% | 50% | 60% | 70% | 85% |
| LTE | 50% | 60% | 75% | 90% | 90% |
| 通用 SDR | 35% | 50% | 70% | 80% | 90% |

---

## 四、缺失的核心算子详细定义

### 4.1 FeedbackOp（反馈算子）🔥 最高优先级

**数学形式**:
```
y[n] = f(x[n], y[n-1], y[n-2], ..., y[n-M])
```

**DSL 定义**:
```python
@dataclass
class FeedbackOp:
    """递归/反馈算子 - 支持 IIR、PLL、AGC"""
    # 信号
    input_signal: str                    # 输入 x[n]
    output_signal: str                   # 输出 y[n]
    
    # 前馈路径
    feedforward_coeffs: List[float]      # [b0, b1, ..., bN]
    feedforward_delay: List[int]         # [0, 1, ..., N]
    
    # 反馈路径
    feedback_coeffs: List[float]         # [a1, a2, ..., aM]
    feedback_delay: List[int]            # [1, 2, ..., M]
    
    # 运算类型
    arithmetic: str = "fixed"            # fixed/floating
    bit_width: int = 16
    frac_bits: int = 15
    
    # 稳定性保护
    saturation: bool = True
    rounding_mode: str = "convergent"    # truncate/convergent

# 使用示例: IIR Biquad
fp.feedback(
    input_signal="x",
    output_signal="y",
    feedforward_coeffs=[b0, b1, b2],
    feedforward_delay=[0, 1, 2],
    feedback_coeffs=[a1, a2],           # y 的系数 (通常 a0=1)
    feedback_delay=[1, 2],
    bit_width=16,
    frac_bits=14
)

# 使用示例: AGC 环路
fp.feedback(
    input_signal="gain_error",          # μ·(target - |y|)
    output_signal="gain",
    feedforward_coeffs=[1.0],
    feedforward_delay=[0],
    feedback_coeffs=[1.0],              # 积分器
    feedback_delay=[1],
    saturation=True                     # 增益限幅
)
```

**硬件生成**:
```verilog
module feedback_iir_biquad (
    input  signed [15:0] x,
    output signed [15:0] y,
    input  clk, rst
);
    // 延迟线
    reg signed [15:0] x_d1, x_d2;
    reg signed [15:0] y_d1, y_d2;
    
    // 系数 (定点化: Q14)
    localparam signed [15:0] B0 = 1648;  // b0 * 2^14
    localparam signed [15:0] B1 = 3296;
    localparam signed [15:0] B2 = 1648;
    localparam signed [15:0] A1 = 2979;  // -a1 * 2^14
    localparam signed [15:0] A2 = -1086; // -a2 * 2^14
    
    // DSP48 乘法累加链
    wire signed [31:0] prod_b0 = x * B0;
    wire signed [31:0] prod_b1 = x_d1 * B1;
    wire signed [31:0] prod_b2 = x_d2 * B2;
    wire signed [31:0] prod_a1 = y_d1 * A1;
    wire signed [31:0] prod_a2 = y_d2 * A2;
    
    wire signed [35:0] sum = prod_b0 + prod_b1 + prod_b2 + prod_a1 + prod_a2;
    wire signed [15:0] y_next = sum >>> 14;  // 量化
    
    // 饱和保护
    assign y = (y_next > 32767) ? 32767 : 
               (y_next < -32768) ? -32768 : y_next;
    
    always @(posedge clk) begin
        if (rst) begin
            x_d1 <= 0; x_d2 <= 0;
            y_d1 <= 0; y_d2 <= 0;
        end else begin
            x_d2 <= x_d1; x_d1 <= x;
            y_d2 <= y_d1; y_d1 <= y;
        end
    end
endmodule
```

**关键硬件约束**:
- **DSP 资源**: 每二阶节 2-3 个 DSP48
- **稳定性**: 需要极点位置检查（保证 |p| < 1）
- **关键路径**: 乘法器 + 加法树，需要流水线级
- **数值精度**: 反馈路径的舍入误差会累积

### 4.2 ButterflyOp（蝶形算子）🔥 最高优先级

**数学形式** (Radix-2 DIT):
```
Y0 = X0 + W_N^k · X1
Y1 = X0 - W_N^k · X1
其中 W_N^k = e^(-j2πk/N) = cos(2πk/N) - j·sin(2πk/N)
```

**DSL 定义**:
```python
@dataclass
class ButterflyOp:
    """FFT 蝶形算子 - 支持 DIT/DIF, Radix-2/4"""
    # 输入
    inputs: List[str]              # [x0, x1] for radix-2
    
    # 旋转因子 (复数)
    twiddle_real: float
    twiddle_imag: float
    twiddle_width: int = 16        # 旋转因子位宽
    
    # 配置
    radix: int = 2                 # 2 或 4
    mode: str = "dit"              # "dit" (时域抽取) 或 "dif" (频域抽取)
    
    # 输出
    outputs: List[str]             # [y0, y1]
    
    # 精度
    input_width: int = 16
    output_width: int = 16
    
    # 优化选项
    use_hard_complex: bool = True  # 使用硬复数乘法器
    pipeline_stages: int = 1       # 内部流水线级数

@dataclass  
class FFTStageOp:
    """FFT 完整阶段 - 包含多个蝶形"""
    input_signal: str
    fft_size: int                  # N = 64, 128, ..., 2048
    stage: int                     # 当前阶段 0..log2(N)-1
    direction: str = "forward"     # "forward" 或 "inverse"
    output_signal: str
    
    # 实现策略
    implementation: str = "pipelined"  # "pipelined", "iterative", "ip_core"
    parallelism: int = 1           # 每周期处理的蝶形数

# 使用示例: 1024-FFT 单级
fp.fft_stage(
    input_signal="stage0_in",
    fft_size=1024,
    stage=0,
    direction="forward",
    output_signal="stage1_out",
    implementation="pipelined",
    parallelism=4
)

# 使用示例: 完整 FFT
fp.fft(
    input_signal="time_domain",
    size=1024,
    direction="forward",
    output_signal="freq_domain",
    implementation="xilinx_ip"      # 或 "hls_pipelined"
)
```

**硬件生成选项**:

选项 1: HLS 描述 (灵活)
```c
void butterfly_radix2(
    complex<int16_t> x0, complex<int16_t> x1,
    complex<int16_t> w,
    complex<int16_t> &y0, complex<int16_t> &y1
) {
    #pragma HLS INLINE
    
    // 复数乘法: 4 实数乘法
    int32_t prod_r = x1.real * w.real - x1.imag * w.imag;
    int32_t prod_i = x1.real * w.imag + x1.imag * w.real;
    
    // 量化
    int16_t wx1_r = prod_r >> 15;
    int16_t wx1_i = prod_i >> 15;
    
    // 蝶形加减
    y0.real = x0.real + wx1_r;
    y0.imag = x0.imag + wx1_i;
    y1.real = x0.real - wx1_r;
    y1.imag = x0.imag - wx1_i;
}

void fft_1024(
    hls::stream<complex<int16_t>> &in,
    hls::stream<complex<int16_t>> &out
) {
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    
    complex<int16_t> buf[1024];
    complex<int16_t> twiddle[512];
    
    // 位逆序输入
    for (int i = 0; i < 1024; i++) {
        #pragma HLS PIPELINE II=1
        buf[bit_reverse(i, 10)] = in.read();
    }
    
    // 10 级蝶形
    for (int stage = 0; stage < 10; stage++) {
        int groups = 1 << stage;
        int butterflies_per_group = 512 >> stage;
        
        for (int g = 0; g < groups; g++) {
            for (int b = 0; b < butterflies_per_group; b++) {
                #pragma HLS PIPELINE II=1
                #pragma HLS UNROLL factor=4
                
                int idx0 = g * (butterflies_per_group * 2) + b;
                int idx1 = idx0 + butterflies_per_group;
                int tw_idx = b << (9 - stage);
                
                butterfly_radix2(buf[idx0], buf[idx1], twiddle[tw_idx], 
                                buf[idx0], buf[idx1]);
            }
        }
    }
    
    // 输出
    for (int i = 0; i < 1024; i++) {
        #pragma HLS PIPELINE II=1
        out.write(buf[i]);
    }
}
```

选项 2: 直接映射到 Xilinx FFT IP
```python
class FFTCodegen:
    def generate_xilinx_ip_config(self, op: FFTStageOp) -> dict:
        return {
            "component_name": f"xfft_{op.fft_size}",
            "transform_length": op.fft_size,
            "target_clock_frequency": 300,
            "target_data_throughput": op.parallelism * op.fft_size,
            "transform_direction": "forward" if op.direction == "forward" else "inverse",
            "data_format": "fixed_point",
            "input_width": op.input_width,
            "phase_factor_width": op.twiddle_width,
            "scaling_options": "unscaled",  # 或 "scaled"
            "rounding_modes": "convergent_rounding",
            "memory_options": "block_ram_for_data",
            "complex_mult_type": "use_4mults",  # 4 或 3 乘法器结构
            "butterfly_type": "use_luts",  # 或 "use_xtremedsp_slices"
        }
```

**关键硬件约束**:
- **DSP 资源**: 每蝶形 3-4 个 DSP48（复数乘法）
- **BRAM**: FFT N 点需要 N 个复数存储 + N/2 旋转因子
- **位逆序**: 需要专用地址生成器或重排网络
- **流水线**: log2(N) 级流水线吞吐量 = N 样本/周期（全并行）

### 4.3 TrellisOp（网格图算子）

**数学形式** (Viterbi ACS):
```
对于每个状态 s 和时间 t:
    PM[s,t] = min(
        PM[prev_state_0, t-1] + BM[branch_0],
        PM[prev_state_1, t-1] + BM[branch_1]
    )
    survivor[s,t] = argmin(...)  # 保存路径
```

**DSL 定义**:
```python
@dataclass
class TrellisOp:
    """网格图算子 - Viterbi/Turbo/卷积码"""
    # 算法选择
    algorithm: str                 # "viterbi", "bcjr", "map"
    
    # 编码器参数
    constraint_length: int         # K (通常为 7)
    code_rate: Tuple[int,int]      # (1, 2) for rate 1/2
    generator_polynomials: List[int]  # 如 [0o133, 0o171] for WiFi
    
    # 输入
    input_signal: str              # 软判决 LLR 或硬比特
    input_width: int = 8           # 软判决位宽
    
    # Viterbi 特有
    traceback_depth: int = 64      # 回溯深度
    
    # BCJR 特有
    num_iterations: int = 8        # Turbo 迭代次数
    
    # 并行度
    parallelism: int = 64          # 1 (串行) 到 64 (全并行)
    
    output_signal: str

# 使用示例: WiFi K=7 Viterbi
fp.trellis(
    algorithm="viterbi",
    constraint_length=7,
    code_rate=(1, 2),
    generator_polynomials=[0o133, 0o171],
    input_signal="soft_demod",
    input_width=8,
    traceback_depth=96,
    parallelism=64,                 # 全并行 ACS
    output_signal="decoded_bits"
)
```

**硬件生成**:
```verilog
module viterbi_acs (
    input  signed [7:0] pm_in_0, pm_in_1,    // 路径度量输入
    input  signed [7:0] bm_0, bm_1,          // 分支度量
    output signed [7:0] pm_out,
    output              survivor,
    input  clk
);
    wire signed [8:0] candidate_0 = pm_in_0 + bm_0;
    wire signed [8:0] candidate_1 = pm_in_1 + bm_1;
    
    assign survivor = (candidate_0 <= candidate_1) ? 0 : 1;
    assign pm_out = survivor ? candidate_1[7:0] : candidate_0[7:0];
endmodule

// 64 状态 Viterbi (WiFi K=7)
module viterbi_k7 (
    input  signed [7:0] llr_in [0:1],   // 2 位软判决输入
    output reg          decoded_bit,
    input  clk, rst
);
    // 64 个状态的路径度量
    reg signed [7:0] path_metric [0:63];
    reg signed [7:0] path_metric_next [0:63];
    
    // 64 个 ACS 单元
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : acs_gen
            viterbi_acs acs (
                .pm_in_0(path_metric[prev_state_0(i)]),
                .pm_in_1(path_metric[prev_state_1(i)]),
                .bm_0(branch_metric(i, 0)),
                .bm_1(branch_metric(i, 1)),
                .pm_out(path_metric_next[i]),
                .survivor(survivor[i]),
                .clk(clk)
            );
        end
    endgenerate
    
    // 回溯存储 (96 深度 x 64 状态)
    reg survivor_mem [0:95][0:63];
    reg [6:0] traceback_state;
    
    // ... 回溯逻辑
endmodule
```

**关键硬件约束**:
- **ACS 单元**: 64 状态需要 64 个 ACS（或时分复用）
- **递归依赖**: PM[t] 依赖 PM[t-1]，关键路径长
- **存储**: 回溯存储需要 traceback_depth × num_states 比特
- **时钟**: 通常 150-250 MHz（ACS 反馈路径限制）

### 4.4 ComplexOp（复数运算算子）

**数学形式**:
```
乘法: (a+bi)(c+di) = (ac-bd) + (ad+bc)i
加法: (a+bi)+(c+di) = (a+c) + (b+d)i
共轭: conj(a+bi) = a-bi
模方: |a+bi|² = a² + b²
```

**DSL 定义**:
```python
@dataclass
class ComplexMapOp:
    """复数元素级运算"""
    input_signal: str              # 复数输入 (实部/虚部配对)
    operation: str                 # "multiply", "add", "sub", "conjugate", "scale"
    operand_signal: Optional[str] = None  # 二元运算的第二操作数
    scale_real: Optional[float] = None    # 标量缩放实部
    scale_imag: Optional[float] = None    # 标量缩放虚部
    output_signal: str
    
    # 位宽
    input_width: int = 16
    output_width: int = 16
    
    # 实现选择
    implementation: str = "standard"  # "standard" (4 mult) 或 "karatsuba" (3 mult)

@dataclass
class ComplexReduceOp:
    """复数归约运算"""
    input_signal: str
    operation: str                 # "add", "dot_product"
    domain: Domain
    output_signal: str

# 使用示例: 复数 FIR
fp.shift_reg("rx_signal", taps=range(16), output="taps")
fp.complex_map("taps", operation="multiply", operand_signal="coeffs", output="products")
fp.complex_reduce("products", operation="add", domain=fp.domain.all(), output="filtered")

# 使用示例: OFDM 信道估计
fp.complex_map("rx_pilot", operation="multiply", 
               operand_signal="conj(pilot_seq)", output="h_est")
```

**硬件生成**:
```verilog
// 标准复数乘法 (4 实数乘法器)
module complex_mult_4m (
    input  signed [15:0] ar, ai,   // a = ar + j*ai
    input  signed [15:0] br, bi,   // b = br + j*bi
    output signed [15:0] pr, pi,   // p = pr + j*pi
    input  clk
);
    wire signed [31:0] ac = ar * br;  // DSP48
    wire signed [31:0] bd = ai * bi;  // DSP48
    wire signed [31:0] ad = ar * bi;  // DSP48
    wire signed [31:0] bc = ai * br;  // DSP48
    
    assign pr = (ac - bd) >>> 15;
    assign pi = (ad + bc) >>> 15;
endmodule

// Karatsuba 优化 (3 实数乘法器)
module complex_mult_3m (
    input  signed [15:0] ar, ai,
    input  signed [15:0] br, bi,
    output signed [15:0] pr, pi,
    input  clk
);
    wire signed [15:0] a_sum = ar + ai;
    wire signed [15:0] b_sum = br + bi;
    
    wire signed [31:0] t1 = a_sum * b_sum;  // (a+b)(c+d)
    wire signed [31:0] t2 = ar * br;        // ac
    wire signed [31:0] t3 = ai * bi;        // bd
    
    assign pr = (t2 - t3) >>> 15;
    assign pi = (t1 - t2 - t3) >>> 15;
endmodule
```

**DSP 资源对比**:

| 位宽 | 标准 (4 mult) | Karatsuba (3 mult) | 适用场景 |
|------|---------------|-------------------|----------|
| 8-bit | 0 (LUT) | 0 (LUT) | 低精度控制信道 |
| 12-bit | 3 DSP | 2 DSP | 标准 OFDM |
| 16-bit | 4 DSP | 3 DSP | 高精度 FFT |
| 18-bit | 4 DSP | 3 DSP | 最大精度 |

### 4.5 MatrixOp（矩阵运算算子）

**数学形式** (MIMO MMSE):
```
ŝ = (H^H · H + σ²I)^(-1) · H^H · y

其中:
- H: N_r × N_t 信道矩阵
- y: N_r × 1 接收信号
- ŝ: N_t × 1 估计信号
```

**DSL 定义**:
```python
@dataclass
class MatrixMultOp:
    """矩阵乘法 C = A × B"""
    matrix_a: str
    matrix_b: str
    dimensions: Tuple[int, int, int]  # (M, K, N) for M×K @ K×N
    output: str
    
    # 实现策略
    schedule: str = "systolic"       # "systolic", "blocked", "naive"
    tile_size: int = 16
    
    # 数据类型
    bit_width: int = 16
    frac_bits: int = 14

@dataclass
class MatrixInversionOp:
    """矩阵求逆 (用于 MMSE)"""
    matrix: str
    size: int                      # 2, 4, 8 (天线数)
    method: str = "cholesky"       # "cholesky", "qr", "direct"
    output: str

# 使用示例: 2x2 MIMO MMSE
fp.matrix_mult("H_conj_T", "H", (2, 2, 2), output="H_HH")
fp.matrix_add("H_HH", "sigma2_I", output="G")
fp.matrix_inversion("G", size=2, method="cholesky", output="G_inv")
fp.matrix_mult("G_inv", "H_conj_T", (2, 2, 2), output="W")
fp.matrix_mult("W", "y", (2, 2, 1), output="s_hat")
```

**硬件生成** (脉动阵列):
```verilog
// 2x2 脉动阵列矩阵乘法
module systolic_2x2 (
    input  signed [15:0] a00, a01, a10, a11,
    input  signed [15:0] b00, b01, b10, b11,
    output signed [31:0] c00, c01, c10, c11,
    input  clk
);
    // 流水线性结构
    // PE 阵列: 每个 PE 执行 mac = mac + a * b
    
    // 简化的直接实现
    assign c00 = a00*b00 + a01*b10;
    assign c01 = a00*b01 + a01*b11;
    assign c10 = a10*b00 + a11*b10;
    assign c11 = a10*b01 + a11*b11;
endmodule
```

---

## 五、Shape/位宽/并行度变体推荐

### 5.1 完整 Kernel 配置空间

| Kernel | Shape 变体 | 位宽变体 | 并行度 | 算法变体 |
|--------|-----------|----------|--------|----------|
| **fir_direct** | taps: 8, 16, 32, 64, 128, 256 | 8, 12, 16, 18 bit | 1, 2, 4, 8, 16, 32 | symmetric, polyphase |
| **iir_biquad** | sections: 1, 2, 4, 6, 8 | 12, 16, 20, 24 bit | 1, 2, 4 | direct_form_I, II, transposed |
| **fft_radix2** | N: 64, 128, 256, 512, 1024, 2048 | 12, 16, 18 bit | 1, 2, 4, 8 | dit, dif, pipeline, iterative |
| **fft_radix4** | N: 64, 256, 1024, 4096 | 12, 16, 18 bit | 1, 4, 16 | dit, dif |
| **ldpc_cnu** | dc: 4, 6, 8, 12, 16, 24, 32 | 6, 8, 10 bit | 1, dc/2, dc | min_sum, offset_ms, normalized_ms, spa |
| **viterbi** | K: 5, 7, 9 | 8, 10 bit | 1, 2^k/4, 2^k | hard, soft |
| **agc** | - | 12, 16, 20 bit | 1 | loop_filter: iir, pi |
| **complex_fir** | taps: 8, 16, 32, 64 | 12, 16 bit | 1, 2, 4, 8 | - |
| **mimo_mmse** | antennas: 2, 4, 8 | 12, 16 bit | 1, 2, 4 | cholesky, qr |
| **correlator** | length: 64, 128, 256, 512, 1024 | 8, 12, 16 bit | 1, 2, 4, 8 | real, complex |

### 5.2 推荐优先级矩阵

```
优先级 = 算法重要性 × 实现复杂度 × 硬件 ROI

🔥🔥🔥 必须实现 (P0)
├── fir_direct_N{16,32,64,128}_b{12,16}_p{1,2,4,8}
├── ldpc_cnu_dc{8,16}_min_sum_b{6,8}
├── vec_add/mul/mac_N{64,256,1024}_b{8,16}_p{1,4,16}
└── correlator_N{64,128,256}_b{12,16}

🔥🔥 高优先级 (P1) - 需要 FeedbackOp
├── iir_biquad_sections{1,2,4}_b{16}_p{1,2}
├── agc_loop_b{16}_mu{0.001,0.01}
└── pll_carrier_recovery_order{1,2}_b{16}

🔥🔥 高优先级 (P2) - 需要 ButterflyOp
├── fft_radix2_N{128,256,1024}_b{16}_p{1,4}
├── ofdm_fft_N{256,1024}_cp{16,64}
└── complex_fir_taps{16,32}_b{16}

🔥 中优先级 (P3) - 需要 TrellisOp
├── viterbi_k7_rate{1/2}_soft_b{8}
└── turbo_map_iterations{4,6}_b{8}

📌 低优先级 (P4) - 需要 MatrixOp/SortOp
├── mimo_mmse_antennas{2,4}_b{16}
└── polar_scl_n{256}_L{8,16}
```

---

## 六、硬件约束参数规范

### 6.1 FPGA 资源模型 (Xilinx UltraScale+)

| 资源类型 | 单位 | 能力 | 限制 |
|----------|------|------|------|
| **DSP48E2** | 1x | 27×18 乘法 + 48-bit 累加 | 每 100MHz 1 操作/周期 |
| **BRAM36K** | 1x | 36Kb 双端口 RAM | 最大 1.2 GHz 端口速率 |
| **LUT6** | 1x | 6 输入布尔函数 | 用于控制逻辑、小位宽乘法 |
| **FF** | 1x | D 触发器 | 用于流水线、延迟线 |
| **URAM** | 1x | 288Kb 单端口 | 大容量存储，延迟稍高 |

### 6.2 Kernel 资源预算模板

```yaml
fir_direct:
  dsp_per_tap: 0.5          # 对称系数优化
  bram_per_64taps: 1        # 延迟线存储
  target_freq_mhz: 400
  pipeline_stages: 3        # 乘法 + 加法树 + 输出

fft_radix2:
  dsp_per_butterfly: 3.5    # 复数乘法 (4) - 优化后
  bram_for_data_n: 2N       # 位逆序双缓冲
  bram_for_twiddle_n: N/2   # 旋转因子
  target_freq_mhz: 350
  pipeline_stages_per_stage: 2

iir_biquad:
  dsp_per_section: 2.5
  ff_per_section: 64
  target_freq_mhz: 300
  stability_check: required

viterbi_k7:
  dsp_for_acs: 0            # 纯 LUT 实现
  lut_per_acs: 32
  ff_per_state: 16
  bram_for_traceback: 96*64/8  # 字节/状态
  target_freq_mhz: 200
```

### 6.3 时序约束公式

```
关键路径延迟 = 组合逻辑延迟 + 布线延迟 + 建立时间

对于流水线设计:
最大频率 = 1 / (max_stage_delay + clock_uncertainty)

典型约束:
- FIR 直接型: T_period ≥ T_mult + T_add_tree + T_setup
- FFT 蝶形: T_period ≥ T_complex_mult + T_add + T_setup  
- IIR 反馈: T_period ≥ T_mult + T_add + T_feedback_loop (最难)
```

---

## 七、向 Spiral/Delite 架构演进路线图

### 7.1 架构对比

```
当前 FormaSyn:                    目标架构 (Spiral-inspired):
┌─────────────┐                   ┌─────────────────┐
│  Python DSL │                   │  Math DSL (SPL) │
│  (数据流图)  │                   │  (Kronecker积)  │
└──────┬──────┘                   └────────┬────────┘
       ↓                                   ↓
┌─────────────┐                   ┌─────────────────┐
│  IR (DAG)   │                   │  Σ-SPL IR       │
└──────┬──────┘                   │  (含存储访问)    │
       ↓                          └────────┬────────┘
┌─────────────┐                            ↓
│  Template   │                   ┌─────────────────┐
│  Engine     │                   │  Rewriting      │
└──────┬──────┘                   │  Optimizer      │
       ↓                          └────────┬────────┘
┌─────────────┐                            ↓
│ HLS C++     │                   ┌─────────────────┐
│ (Vitis)     │                   │  Scheduling     │
└─────────────┘                   │  + Codegen      │
                                  └────────┬────────┘
                                           ↓
                                  ┌─────────────────┐
                                  │  Verilog/VHDL   │
                                  │  (直接硬件)      │
                                  └─────────────────┘
```

### 7.2 演进阶段

#### Phase 1: 核心算子扩展 (2-3 个月)
**目标**: 达到 60-70% 算法覆盖率

```python
# 新增算子
+ FeedbackOp    → IIR, AGC, PLL
+ ButterflyOp   → FFT, OFDM  
+ ComplexOp     → 复数 FIR, 均衡

# IR 扩展
- 支持循环依赖检测
- 支持状态机表示
```

**验证标准**:
- IIR Biquad 合成成功，频率响应与 MATLAB 一致
- 256-FFT 合成成功，SQNR > 40dB
- 复数 FIR 4-并行，300MHz 时序收敛

#### Phase 2: 数学抽象层 (2-3 个月)
**目标**: 引入类似 SPL 的数学 DSL

```python
# 当前: 显式数据流
fp.shift_reg("x", taps=range(16), output="taps")
fp.map("taps", func="multiply", coeff=h, output="p")
fp.reduce("p", op="add", output="y")

# 目标: 数学公式
@comm_kernel
def fir_16tap(x: Signal, h: Coeffs) -> Signal:
    return Sum(h[i] * Delay(x, i) for i in range(16))

# 自动推导数据流 + 硬件映射
```

**新增组件**:
- `MathDSL` 前端: 支持线性变换公式
- `FormulaParser`: 解析数学表达式到 IR
- `PatternMatcher`: 识别标准结构 (FIR, FFT, etc.)

#### Phase 3: 优化与重写系统 (3-4 个月)
**目标**: 算法空间自动探索

```python
# 重写规则示例
REWRITE_RULES = {
    # FFT 分解规则
    "dft_split": DFT(n) -> (DFT(n/2) ⊗ I(2)) · Twiddle(n) · (I(n/2) ⊗ DFT(2)),
    
    # FIR 对称优化
    "fir_symmetric": FIR(h, x) -> FIR_Sym(h[:N//2], x) if is_symmetric(h),
    
    # 强度削减
    "strength_reduction": Mul(Pow(2, k), x) -> ShiftLeft(x, k),
}

# 成本模型
COST_MODEL = {
    "dsp48": 1.0,
    "bram36k": 0.5,
    "lut": 0.01,
    "latency": 0.1,  # 每周期
}
```

**验证标准**:
- 自动生成 FIR 对称优化版本（节省 50% DSP）
- FFT 算法空间探索（Cooley-Tukey vs Bluestein）
- Pareto 最优解自动筛选

#### Phase 4: 直接硬件生成 (3-4 个月)
**目标**: 绕过 HLS，直接生成 RTL

```python
class VerilogCodegen:
    def emit_feedback_op(self, op: FeedbackOp) -> str:
        # 直接生成 Verilog，无 HLS 中间层
        return f"""
        module {op.name}(
            input  signed [{op.bit_width-1}:0] x,
            output signed [{op.bit_width-1}:0] y,
            input  clk, rst
        );
            // 自动推导流水线级数
            // 自动插入寄存器满足时序
            // 自动生成位真测试平台
        endmodule
        """
```

**优势**:
- 更精细的硬件控制
- 更短的编译时间
- 更好的时序收敛

#### Phase 5: 异构扩展 (长期)
**目标**: 支持多后端（类似 Delite）

```python
# 统一 DSL，多后端生成
spec = CommSystemSpec(...)  # 通信系统规格

# FPGA 实现
fpga_impl = spec.compile(target="xilinx_fpga", 
                         device="xcvu9p",
                         frequency=400e6)

# ASIC 实现
asic_impl = spec.compile(target="asic_65nm",
                         frequency=1e9,
                         power_budget=100e-3)

# 软件仿真
sw_impl = spec.compile(target="cpp_sim",
                       bit_accurate=True)
```

---

## 八、推荐公式到硬件的完整映射示例

### 8.1 OFDM 发射机（从公式到硬件）

**数学规格**:
```
输入: s[k] ∈ {M-QAM 星座}, k = 0..N-1

1. 子载波映射:
   S[m] = s[k] if m ∈ data_subcarriers[k] else 0

2. IFFT:
   x[n] = (1/N) · Σ_{m=0}^{N-1} S[m] · e^(j2πmn/N)

3. 加循环前缀:
   x_cp[i] = x[N-CP+i] for i = 0..CP-1
   x_cp[CP+i] = x[i] for i = 0..N-1

输出: x_cp (时域采样)
```

**FormaSyn DSL 目标**:
```python
@ofdm_transmitter
class OFDM_Tx:
    fft_size: int = 1024
    cp_length: int = 72
    modulation: str = "64qam"
    used_subcarriers: int = 840
    
    def process(self, bits: BitStream) -> ComplexSignal:
        # 调制
        symbols = self.modulate(bits, self.modulation)
        
        # 子载波映射 (零填充)
        freq_domain = self.subcarrier_map(symbols, self.used_subcarriers)
        
        # IFFT
        time_domain = self.ifft(freq_domain, self.fft_size)
        
        # 加 CP
        with_cp = self.add_cyclic_prefix(time_domain, self.cp_length)
        
        return with_cp

# 生成硬件
system = OFDM_Tx()
verilog = system.compile(
    target="xilinx_fpga",
    optimizations=["fft_pipeline", "cp_overlap"],
    frequency_mhz=400
)
```

**生成的硬件结构**:
```verilog
module ofdm_tx (
    input  [5:0]   bits_in,        // 6 bits for 64-QAM
    input          valid_in,
    output [31:0]  sample_out,     // 16-bit I + 16-bit Q
    output         valid_out,
    input          clk, rst
);
    // 1. 64-QAM Mapper (LUT)
    qam64_mapper mapper (.bits(bits_in), .symbol(qam_out));
    
    // 2. 子载波映射 (双端口 BRAM + 地址生成)
    subcarrier_mapper #(.N(1024), .K(840)) sc_map (
        .symbol_in(qam_out),
        .freq_out(freq_sample),
        .valid(valid_sc)
    );
    
    // 3. 1024-IFFT (Xilinx FFT IP 或自定义蝶形网络)
    xfft_1024 ifft_inst (
        .clk(clk),
        .start(valid_sc),
        .xn_re(freq_sample[31:16]),
        .xn_im(freq_sample[15:0]),
        .xk_re(time_re),
        .xk_im(time_im),
        .dv(time_valid)
    );
    
    // 4. 循环前缀添加 (延迟线 + 复用)
    cyclic_prefix #(.N(1024), .CP(72)) cp_inst (
        .sample_in({time_re, time_im}),
        .valid_in(time_valid),
        .sample_out(sample_out),
        .valid_out(valid_out),
        .clk(clk)
    );
endmodule
```

---

## 九、结论与建议

### 9.1 当前 DSL 关键缺口总结

| 缺口 | 影响 | 优先级 | 估计工作量 |
|------|------|--------|-----------|
| **FeedbackOp** | 无法表达 IIR/PLL/AGC | 🔥🔥🔥 | 2-3 周 |
| **ButterflyOp** | 无法表达 FFT/OFDM | 🔥🔥🔥 | 3-4 周 |
| **ComplexOp** | 复数运算冗余表达 | 🔥🔥 | 1-2 周 |
| **TrellisOp** | 无法表达 Viterbi/Turbo | 🔥🔥 | 3-4 周 |
| **数学抽象层** | 非公式化编程 | 🔥 | 2-3 月 |
| **重写优化** | 无法自动算法优化 | 🔥 | 2-3 月 |
| **直接 RTL** | 依赖 HLS 间接生成 | 📌 | 3-4 月 |

### 9.2 实现路径建议

**短期 (1-2 个月)**:
1. **立即实现 FeedbackOp** - 这是最大障碍
2. **实现 ButterflyOp** - FFT 是通信核心
3. **添加 ComplexOp** - 简化复数运算表达

**中期 (3-6 个月)**:
1. **TrellisOp + Viterbi** - 完成信道编码覆盖
2. **数学抽象层** - 引入公式化 DSL
3. **完整 WiFi 基带** - 验证端到端能力

**长期 (6-12 个月)**:
1. **重写优化系统** - 实现 Spiral 级算法空间探索
2. **直接 RTL 生成** - 绕过 HLS 限制
3. **异构后端** - 支持 FPGA/ASIC/仿真

### 9.3 与 Spiral/Delite 的最终对比愿景

```
                   Spiral    Delite    FormaSyn (目标)
数学抽象           ⭐⭐⭐⭐⭐   ⭐⭐⭐⭐     ⭐⭐⭐⭐⭐
算法空间探索        ⭐⭐⭐⭐⭐   ⭐⭐⭐       ⭐⭐⭐⭐
硬件控制精度        ⭐⭐⭐⭐    ⭐⭐        ⭐⭐⭐⭐⭐
多后端支持          ⭐⭐⭐     ⭐⭐⭐⭐⭐     ⭐⭐⭐⭐
通信领域特定        ⭐⭐⭐     ⭐⭐        ⭐⭐⭐⭐⭐
生产力             ⭐⭐⭐     ⭐⭐⭐⭐      ⭐⭐⭐⭐
```

**FormaSyn 的定位**: 
- 比 Spiral 更专注于通信硬件
- 比 Delite 更贴近硬件实现细节
- 目标是成为"通信领域的 Spiral + 硬件优化的 Delite"

---

*文档版本: 1.0*  
*分析日期: 2026-04-08*  
*作者: FormaSyn EDA/通信硬件专家*
