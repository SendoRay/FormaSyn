# FormaSyn DSL 算子扩展技术指南

> 作为 EDA/通信硬件专家，指导如何扩展 DSL 算子以支持更多通信算法

---

## 一、当前 DSL 算子能力评估

### 1.1 现有算子回顾

| 算子 | 功能 | 表达能力 | 硬件映射 |
|------|------|---------|---------|
| `MapOp` | 元素级映射 (mul, tanh, sign, abs, lut) | ⭐⭐⭐ | 组合逻辑/LUT/DSP |
| `ReduceOp` | 归约 (add, mul, min, max, xor) | ⭐⭐⭐ | 归约树 |
| `ShiftRegOp` | 移位寄存器/延迟线 | ⭐⭐⭐ | 寄存器链/SRL |
| `DelayOp` | 固定延迟 | ⭐⭐⭐ | 寄存器 |
| `MessagePassOp` | 图消息传递 | ⭐⭐ | 不规则访问 BRAM |

### 1.2 表达能力缺口

```
当前 DSL 表达能力:  DAG (有向无环图)
缺失表达能力:      
  - 反馈/递归 (IIR, PLL, AGC)
  - 时序/状态机 (Viterbi, Turbo)
  - 复数运算 (OFDM, 复数滤波)
  - 蝶形网络 (FFT)
  - 动态控制流 (Polar SCL 的路径剪枝)
```

---

## 二、高优先级算子扩展

### 2.1 FeedbackOp (反馈算子) 🔥 最高优先级

#### 应用场景
- IIR 滤波器
- PLL/Costas 环
- AGC 自动增益控制
- 自适应滤波器 (LMS)

#### 数学形式
```
y[n] = f(x[n], y[n-1], y[n-2], ...)
```

#### DSL 设计
```python
@dataclass
class FeedbackOp:
    """反馈算子 - 支持递归计算"""
    input_ref: str                    # 输入信号
    feedback_refs: List[str]          # 反馈信号 (y[n-1], y[n-2]...)
    forward_func: str                 # 前向函数 (multiply, add)
    feedback_coeffs: List[float]      # 反馈系数
    forward_coeffs: List[float]       # 前向系数
    output: str
    order: int = 1                    # 反馈阶数
    
# 使用示例: IIR Biquad
fp.feedback(
    input_ref="x",
    feedback_refs=["y_delay1", "y_delay2"],
    forward_func="add",
    feedback_coeffs=[-a1, -a2],      # 注意符号
    forward_coeffs=[b0, b1, b2],
    output="y",
    order=2
)
```

#### 硬件实现
```verilog
// IIR Biquad 硬件结构
module iir_biquad (
    input  signed [15:0] x,
    output signed [15:0] y,
    input  clk, rst
);
    // 延迟寄存器
    reg signed [15:0] y_delay1, y_delay2;
    reg signed [15:0] x_delay1, x_delay2;
    
    // 乘法器 (DSP48)
    wire signed [31:0] prod_b0 = x * b0;
    wire signed [31:0] prod_b1 = x_delay1 * b1;
    wire signed [31:0] prod_b2 = x_delay2 * b2;
    wire signed [31:0] prod_a1 = y_delay1 * a1;
    wire signed [31:0] prod_a2 = y_delay2 * a2;
    
    // 累加
    wire signed [35:0] sum = prod_b0 + prod_b1 + prod_b2 - prod_a1 - prod_a2;
    
    assign y = sum >>> 16;  // 量化
    
    always @(posedge clk) begin
        if (rst) begin
            y_delay1 <= 0; y_delay2 <= 0;
            x_delay1 <= 0; x_delay2 <= 0;
        end else begin
            y_delay2 <= y_delay1;
            y_delay1 <= y;
            x_delay2 <= x_delay1;
            x_delay1 <= x;
        end
    end
endmodule
```

#### 实现复杂度
- **IR 扩展**: 中等（需要检测循环依赖）
- **代码生成**: 简单（标准 IIR 结构）
- **资源**: 2-5 个 DSP，少量寄存器
- **关键路径**: 乘法器 + 加法树，需要流水线

---

### 2.2 ButterflyOp (蝶形算子) 🔥 最高优先级

#### 应用场景
- FFT/IFFT (OFDM)
- DCT
- 快速多项式乘法

#### 数学形式
```
Radix-2 DIT Butterfly:
  Y0 = X0 + W·X1
  Y1 = X0 - W·X1
  
其中 W = exp(-j2πk/N) (旋转因子)
```

#### DSL 设计
```python
@dataclass
class ButterflyOp:
    """FFT 蝶形算子"""
    x0_ref: str           # 输入 0
    x1_ref: str           # 输入 1
    twiddle_ref: str      # 旋转因子 W
    radix: int = 2        # 2 或 4
    mode: str = "dit"     # DIT (时域抽取) 或 DIF (频域抽取)
    outputs: List[str] = field(default_factory=list)
    
    # 精度控制
    twiddle_width: int = 16      # 旋转因子位宽
    use_hard_complex: bool = True  # 使用硬复数乘法器

# 使用示例: 1024-FFT 的一阶
# 注意: FFT 通常需要循环/阶段描述，不是单个 butterfly
fp.butterfly_stage(
    inputs=["x0", "x1", "x2", "x3", ...],  # N 个输入
    twiddles=["w0", "w1", ...],             # N/2 个旋转因子
    stage=0,
    output="stage0_out"
)

# 或更高级抽象
fp.fft(
    input_ref="time_domain",
    size=1024,
    inverse=False,
    output="freq_domain"
)
```

#### 硬件实现
```verilog
// Radix-2 蝶形单元
module butterfly_radix2 (
    input  signed [15:0] x0_real, x0_imag,
    input  signed [15:0] x1_real, x1_imag,
    input  signed [15:0] w_real, w_imag,  // 旋转因子
    output signed [15:0] y0_real, y0_imag,
    output signed [15:0] y1_real, y1_imag,
    input  clk
);
    // 复数乘法: (a+bi)(c+di) = (ac-bd) + (ad+bc)i
    wire signed [31:0] prod_r = x1_real * w_real - x1_imag * w_imag;
    wire signed [31:0] prod_i = x1_real * w_imag + x1_imag * w_real;
    
    // 蝶形加减
    assign y0_real = x0_real + (prod_r >>> 15);
    assign y0_imag = x0_imag + (prod_i >>> 15);
    assign y1_real = x0_real - (prod_r >>> 15);
    assign y1_imag = x0_imag - (prod_i >>> 15);
endmodule
```

#### 关键挑战
1. **存储器访问模式**: FFT 需要位逆序 (bit-reverse) 寻址
2. **旋转因子存储**: N/2 个复数旋转因子需要 BRAM
3. **流水线设计**: log2(N) 级流水线 vs 迭代实现

#### 推荐实现策略
```python
# 方案 1: 直接映射到 Xilinx FFT IP
class FFTCodegen:
    def generate(self, schedule):
        if self.use_ip_core:
            return self.generate_xilinx_ip_config(schedule)
        else:
            return self.generate_hls_butterfly_network(schedule)

# 方案 2: HLS 描述 (更灵活，但资源/性能不如 IP)
void fft_1024(hls::stream<complex<int16_t>>& in,
              hls::stream<complex<int16_t>>& out) {
    #pragma HLS PIPELINE II=1
    
    complex<int16_t> stage_data[1024];
    // 读取输入
    for (int i = 0; i < 1024; i++) {
        stage_data[bit_reverse(i)] = in.read();
    }
    
    // 10 级蝶形运算
    for (int stage = 0; stage < 10; stage++) {
        int butterfly_width = 1 << stage;
        for (int i = 0; i < 512; i++) {
            #pragma HLS UNROLL factor=8
            int idx0 = ...;  // 计算索引
            int idx1 = idx0 + butterfly_width;
            complex<int16_t> w = twiddle[...];
            
            // 蝶形运算
            butterfly(stage_data[idx0], stage_data[idx1], w);
        }
    }
}
```

---

### 2.3 ComplexOp (复数运算算子)

#### 应用场景
- 复数 FIR (信道滤波)
- 复数相关 (OFDM 同步)
- 复数均衡

#### DSL 设计
```python
@dataclass
class ComplexMapOp:
    """复数映射算子"""
    input_ref: str
    func: str  # "multiply", "add", "conjugate", "magnitude"
    operand_ref: Optional[str] = None  # 二元运算的第二操作数
    output: str
    
@dataclass
class ComplexReduceOp:
    """复数归约算子"""
    input_ref: str
    op: str  # "add", "mul"
    domain: Domain
    output: str

# 使用示例: 复数 FIR
fp.shift_reg("rx_signal", taps=range(16), output="taps")
fp.complex_map("taps", func="multiply", operand_ref="coeffs", output="products")
fp.complex_reduce("products", op="add", domain=fp.domain.all(), output="filtered")
```

#### 硬件实现
复数乘法需要 4 个实数乘法器（或 3 个用 Karatsuba 算法）：
```
(a+bi)(c+di) = (ac-bd) + (ad+bc)i

标准实现: 4 乘法
优化实现 (Karatsuba): 
  t1 = (a+b)(c+d)
  t2 = ac
  t3 = bd
  real = t2 - t3
  imag = t1 - t2 - t3
  # 3 乘法，但更多加减法
```

FPGA 选择:
- 小位宽 (<12-bit): 用 LUT 实现 4 乘法
- 中位宽 (12-18-bit): 用 3-4 个 DSP48
- 大位宽: 用 Karatsuba 减少 DSP

---

### 2.4 TrellisOp (网格图算子)

#### 应用场景
- Viterbi 译码
- Turbo 译码 (BCJR)
- 卷积编码

#### DSL 设计
```python
@dataclass
class TrellisOp:
    """网格图操作 - 支持 Viterbi/Turbo"""
    input_ref: str
    num_states: int           # 状态数 (64 for K=7)
    num_inputs: int           # 输入比特数 (通常 1)
    num_outputs: int          # 输出比特数 (通常 2 for rate 1/2)
    algorithm: str            # "viterbi", "bcjr", "map"
    
    # 生成多项式 (用于编码器结构)
    generator_polynomials: List[int]
    
    output: str
    
    # Viterbi 特有
    traceback_depth: int = 64
    
    # BCJR 特有
    iterations: int = 8

# 使用示例: WiFi K=7 Viterbi
fp.trellis(
    input_ref="soft_input",
    num_states=64,
    num_inputs=1,
    num_outputs=2,
    algorithm="viterbi",
    generator_polynomials=[0o133, 0o171],  # 标准多项式
    traceback_depth=96,
    output="decoded_bits"
)
```

#### 硬件实现挑战
Viterbi 的核心是 **ACS (Add-Compare-Select)**：
```
for each state s:
    path_metric[s] = min(
        path_metric[prev_state_0] + branch_metric_0,
        path_metric[prev_state_1] + branch_metric_1
    )
```

**关键难点**:
1. **递归依赖**: path_metric[n] 依赖 path_metric[n-1]
2. **状态数**: 64 状态需要 64 个 ACS 单元并行
3. **布线拥塞**: 64 状态之间的连接复杂

**推荐实现**:
```python
# 部分并行 (资源 vs 速度权衡)
class ViterbiConfig:
    def __init__(self, constraint_length):
        self.states = 2**(constraint_length-1)
        
    def generate_hardware(self, parallelism=64):
        if parallelism == self.states:
            return "fully_parallel"  # 64 ACS 单元
        elif parallelism == 1:
            return "serial"          # 1 ACS 单元，64 周期
        else:
            return f"partial_parallel_{parallelism}"  # 折中
```

---

### 2.5 InterleaveOp (交织算子)

#### 应用场景
- 信道交织 (WiFi, 5G)
- Turbo 交织
- 块交织/解交织

#### DSL 设计
```python
@dataclass
class InterleaveOp:
    """交织/解交织算子"""
    input_ref: str
    pattern: str  # "block", "convolutional", "qpp" (Quadratic Permutation)
    
    # Block 交织参数
    rows: Optional[int] = None
    cols: Optional[int] = None
    
    # QPP 交织参数 (LTE Turbo)
    k: Optional[int] = None       # 信息长度
    f1: Optional[int] = None      # QPP 参数 1
    f2: Optional[int] = None      # QPP 参数 2
    
    direction: str = "interleave"  # 或 "deinterleave"
    output: str

# 使用示例: WiFi Block Interleaver
fp.interleave(
    input_ref="coded_bits",
    pattern="block",
    rows=16,
    cols= 27,
    direction="interleave",
    output="interleaved"
)

# LTE Turbo QPP Interleaver
fp.interleave(
    input_ref="turbo_input",
    pattern="qpp",
    k=6144,
    f1=263,
    f2=480,
    output="interleaved"
)
```

#### 硬件实现
交织本质上是 **地址生成 + 双端口 RAM**：
```verilog
module interleaver (
    input  [7:0] data_in,
    output [7:0] data_out,
    input  write_en, read_en, clk
);
    reg [7:0] mem [0:ROWS*COLS-1];
    reg [9:0] write_addr, read_addr;
    
    // 写地址: 线性
    always @(posedge clk) begin
        if (write_en) begin
            mem[write_addr] <= data_in;
            write_addr <= write_addr + 1;
        end
    end
    
    // 读地址: 交织模式
    always @(posedge clk) begin
        if (read_en) begin
            // Block interleave: 按列读出
            read_addr <= (read_addr % ROWS) * COLS + (read_addr / ROWS);
            data_out <= mem[read_addr];
        end
    end
endmodule
```

---

## 三、算子扩展实施路线图

### Phase 1: FeedbackOp (1-2 周)
- [ ] IR 扩展: 支持循环依赖检测
- [ ] Template Engine: IIR 图重写
- [ ] Codegen: HLS 反馈路径生成
- [ ] 测试: IIR Biquad, AGC

### Phase 2: ComplexOp + InterleaveOp (1 周)
- [ ] ComplexOp 设计和实现
- [ ] InterleaveOp 地址生成逻辑
- [ ] 测试: 复数 FIR, 块交织

### Phase 3: ButterflyOp (2-3 周)
- [ ] ButterflyOp IR 设计
- [ ] 旋转因子生成和管理
- [ ] 代码生成: 流水线 FFT 或 IP 集成
- [ ] 测试: 256/1024 FFT

### Phase 4: TrellisOp (2-3 周)
- [ ] Trellis 结构定义
- [ ] ACS 单元生成
- [ ] 回溯/前向算法实现
- [ ] 测试: Viterbi K=7

---

## 四、验证测试要求

每个新算子必须通过：

### 4.1 功能验证
- 与浮点参考模型对比
- 误差分析 (NMSE < -60 dB)
- 边界条件测试

### 4.2 硬件验证
- 资源使用在预算内 (DSP, BRAM, LUT)
- 时序收敛 (目标频率)
- 功耗估算

### 4.3 数值稳定性
- IIR: 极点位置检查（稳定性）
- FFT: 旋转因子精度分析
- Viterbi: 路径度量溢出保护

---

## 五、专家结论

**最高 ROI 扩展**: 
1. **FeedbackOp** - 解锁 IIR/PLL/AGC，覆盖 20% 额外算法
2. **ButterflyOp** - 解锁 FFT/OFDM，覆盖 30% 额外算法

这两个算子可使 DSL 覆盖 **80-90%** 的通信基带处理算法。

**中长期扩展**:
- TrellisOp (Viterbi/Turbo)
- MatrixOp (MIMO)
- SortOp (Polar/MIMO)
