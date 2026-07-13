# Category 14: SDR 通用模块 (10 kernels)

---

## 14.01 数字上变频 (DUC)

**公式**:
```
完整链路: 插值 → 滤波 → NCO 混频

y_up[n] = x_interp[n] · e^{j2πf_c·n/f_s}

插值: 插入 L-1 个零 → 低通滤波 (anti-image)
多级: CIC(R₁) → HB → FIR 精调

AD9361 典型链路:
FIR(interp=1/2/4) → HB1(×2) → HB2(×2) → HB3(×2) → NCO → DAC
总插值: 最大 48×
```

**来源**:
- Analog Devices AD9361 Reference Manual §4 (Digital up-conversion)
- Xilinx PG149 "Digital Up Converter (DUC)" Product Guide
- Crochiere & Rabiner, "Multirate Digital Signal Processing," Ch. 3

**参数配置**:
| Config | total_interp | stages | NCO_width | DAC_rate | 应用 | 来源 |
|--------|-------------|--------|----------|---------|------|------|
| C1 | 4× | HB+HB | 32-bit | 122.88 MHz | LTE 30.72→122.88 | AD9361 |
| C2 | 8× | CIC+HB+HB | 32-bit | 245.76 MHz | 5G NR | AD9361 |
| C3 | 48× | FIR+HB×3+CIC | 32-bit | 983.04 MHz | SDR 宽带 | AD9361 |

---

## 14.02 数字下变频 (DDC)

**公式**:
```
完整链路: NCO 混频 → 滤波 → 抽取

y_down[n] = x[n] · e^{-j2πf_c·n/f_s} → LPF → ↓M

AD9361 典型链路:
ADC → HB3(÷2) → HB2(÷2) → HB1(÷2) → FIR(decim=1/2/4) → NCO
总抽取: 最大 48×
```

**来源**:
- Analog Devices AD9361 Reference Manual §3 (Digital down-conversion)
- Xilinx PG148 "Digital Down Converter (DDC)" Product Guide
- Harris, F.J., "Multirate Signal Processing for Communication Systems," Ch. 7

**参数配置**:
| Config | total_decim | stages | NCO_width | ADC_rate | 应用 | 来源 |
|--------|------------|--------|----------|---------|------|------|
| C1 | 4× | HB+HB | 32-bit | 122.88 MHz | LTE 接收 | AD9361 |
| C2 | 8× | HB×3+FIR | 32-bit | 245.76 MHz | 5G NR 接收 | AD9361 |
| C3 | 16× | CIC+HB+FIR | 32-bit | 491.52 MHz | SDR 宽带接收 | AD9361 |

---

## 14.03 样率转换 (Rational SRC)

**公式**:
```
L/M 有理数样率转换:
y[n] = Σ_k h[n·M - k·L] · x[k]

Polyphase 实现:
1. 插入 L-1 个零
2. 多相滤波 (L 路, 每路 N/L 阶)
3. 取每 M 个输出

Farrow 结构 (任意比率):
y(μ) = Σ_{m=0}^{M} c_m(n) · μ^m
c_m: 多项式系数 (从子滤波器系数导出)
μ: 分数间距 ∈ [0, 1)
```

**来源**:
- Crochiere & Rabiner, "Multirate Digital Signal Processing," Prentice Hall, 1983, Ch. 2
- Farrow, C.W., "A Continuously Variable Digital Delay Element," IEEE ISCAS 1988
- AD9361 Reference Manual (sample rate conversion in digital chain)

**参数配置**:
| Config | L/M | method | filter_order | 应用 | 来源 |
|--------|-----|--------|-------------|------|------|
| C1 | 2/3 | polyphase | 48 | 48kHz→32kHz | 音频 SRC |
| C2 | 4/5 | polyphase | 64 | sample rate align | AD9361 |
| C3 | arbitrary | Farrow (3rd order) | 4×16 | SDR 任意 SRC | Farrow 1988 |

---

## 14.04 频谱感知 — 能量检测

**公式**:
```
能量检测:
T = (1/N) · Σ_{n=0}^{N-1} |y[n]|²

判决:
T > λ → H₁ (信号存在)
T ≤ λ → H₀ (仅噪声)

阈值设置 (Neyman-Pearson):
λ = σ_n² · (1 + Q⁻¹(P_fa) · √(2/N))
P_fa: 虚警概率, P_d: 检测概率
```

**来源**:
- IEEE 802.22-2011 §9.2 (Spectrum sensing for cognitive radio, WRAN)
- Urkowitz, H., "Energy Detection of Unknown Deterministic Signals," Proc. IEEE, 1967
- 应用: 认知无线电、频谱共享、SDR

**参数配置**:
| Config | N | P_fa | bandwidth | data_width | 应用 | 来源 |
|--------|---|------|----------|------------|------|------|
| C1 | 256 | 0.01 | 6 MHz (TV band) | 16-bit | 认知无线电 | IEEE 802.22 §9.2 |
| C2 | 1024 | 0.001 | 20 MHz | 16-bit | WiFi 感知 | SDR |
| C3 | 4096 | 0.01 | 100 MHz | 16-bit | 宽带频谱扫描 | SDR |

---

## 14.05 数字 PLL (All-Digital PLL)

**公式**:
```
相位检测: e[n] = phase(y[n]) - phase_ref[n]  或 Bang-Bang
环路滤波 (PI controller):
v[n] = v[n-1] + K_I · e[n]
w[n] = K_P · e[n] + v[n]

DCO (数控振荡器):
φ[n+1] = φ[n] + w[n]
output: cos(φ[n]), sin(φ[n])

环路带宽 B_L = (K_P² + 2·K_I) / (4·(K_P + K_I))
```

**来源**:
- Best, R.E., "Phase-Locked Loops: Design, Simulation, and Applications," McGraw-Hill, 6th Ed
- Staszewski, R.B., "All-Digital Frequency Synthesizer in Deep-Submicron CMOS," Wiley, 2006
- 应用: SDR 时钟恢复, 载波恢复

**参数配置**:
| Config | PD_type | K_P | K_I | phase_acc_width | 应用 | 来源 |
|--------|---------|-----|-----|----------------|------|------|
| C1 | atan2 | 2^-4 | 2^-10 | 32-bit | 载波恢复 | Best, Ch. 6 |
| C2 | bang-bang | 2^-6 | 2^-12 | 32-bit | CDR (时钟恢复) | Staszewski 2006 |

---

## 14.06 FIFO / 弹性缓冲 (Elastic Buffer)

**公式**:
```
异步 FIFO (跨时钟域):
写指针: wr_ptr (write_clk domain)
读指针: rd_ptr (read_clk domain)

Gray 码同步:
wr_ptr_gray = wr_ptr ^ (wr_ptr >> 1)
同步到 read domain: 2-FF synchronizer
空/满判断:
empty = (rd_ptr_gray == wr_ptr_gray_sync)
full = (wr_ptr_gray[MSB:MSB-1] != rd_ptr_gray_sync[MSB:MSB-1])
       && (wr_ptr_gray[MSB-2:0] == rd_ptr_gray_sync[MSB-2:0])

弹性缓冲: FIFO + 水位控制 (用于补偿 SFO)
```

**来源**:
- Cummings, C.E., "Simulation and Synthesis Techniques for Asynchronous FIFO Design," SNUG 2002
- 应用: ADC/DAC 接口, 多时钟域通信系统

**参数配置**:
| Config | depth | width | clock_domains | 应用 | 来源 |
|--------|-------|-------|-------------|------|------|
| C1 | 32 | 32-bit | 2 (async) | ADC→基带 | Cummings 2002 |
| C2 | 256 | 16-bit | 2 (async) | 弹性缓冲 | Cummings 2002 |
| C3 | 1024 | 64-bit | 2 (async) | 高速接口 | Cummings 2002 |

---

## 14.07 AXI-Stream 数据打包/解包

**公式**:
```
AXI-Stream interface:
TDATA: 数据 (可配置宽度)
TVALID: 数据有效
TREADY: 下游就绪 (反压)
TLAST: 包/帧结束标志
TKEEP: 字节使能

宽度转换:
N:M packer: 收集 N 个小样本, 打包成 M 宽输出
M:N unpacker: 将 M 宽输入拆成 N 个小样本

Valid/Ready 握手: 数据仅在 TVALID && TREADY 时传输
```

**来源**:
- ARM AMBA AXI4-Stream Protocol Specification (IHI 0051A)
- Xilinx PG085 "AXI4-Stream Data FIFO"
- 应用: FPGA 通信系统中模块互联的标准接口

**参数配置**:
| Config | input_width | output_width | operation | 应用 | 来源 |
|--------|------------|-------------|-----------|------|------|
| C1 | 16-bit | 64-bit | 4:1 pack | IQ 样本打包 | ARM IHI 0051A |
| C2 | 64-bit | 16-bit | 1:4 unpack | IQ 样本解包 | ARM IHI 0051A |
| C3 | 32-bit | 128-bit | 4:1 pack | 高速接口 | ARM IHI 0051A |

---

## 14.08 动态位宽缩放 (Bit Width Scaling)

**公式**:
```
饱和截位:
y = clamp(x >> shift, -2^{W_out-1}, 2^{W_out-1}-1)

对称舍入:
y = (x + (1 << (shift-1))) >> shift
  = round(x / 2^shift)

收敛舍入 (银行家舍入):
if (x[shift-1:0] == half)  → round to even
else                       → standard round

位增长追踪:
FIR N-tap: W_out = W_in + ceil(log₂(N)) + W_coef
FFT N-point: W_out = W_in + ceil(log₂(N)) (每级增长 1 bit)
```

**来源**:
- Xilinx UG901 "Vivado Design Suite User Guide: Synthesis" (fixed-point handling)
- Oppenheim & Schafer §12.3 (Finite word length effects in FIR/IIR)
- 应用: 所有定点 DSP 运算中的精度控制

**参数配置**:
| Config | W_in | W_out | method | 应用 | 来源 |
|--------|------|-------|--------|------|------|
| C1 | 32 | 16 | saturate + round | FFT 输出截位 | Xilinx UG901 |
| C2 | 40 | 16 | saturate + truncate | FIR 输出截位 | Xilinx UG901 |
| C3 | 18 | 12 | convergent round | 高精度 DAC 输出 | Xilinx UG901 |

---

## 14.09 CORDIC (通用旋转模式)

**公式**:
```
统一 CORDIC 引擎:
x_{i+1} = x_i - m·d_i·y_i·2^{-i}
y_{i+1} = y_i + d_i·x_i·2^{-i}
z_{i+1} = z_i - d_i·e_i

m=1 (circular): 旋转, sin/cos, atan2, magnitude
m=0 (linear): 乘法, 除法
m=-1 (hyperbolic): sinh/cosh, atanh, sqrt, ln, exp

旋转模式 (z→0): 计算 sin/cos
向量模式 (y→0): 计算 atan2, magnitude

增益补偿: K_N = Π_{i=0}^{N-1} √(1+2^{-2i}) ≈ 1.6468 (circular)
```

**来源**:
- Volder, J., "The CORDIC Trigonometric Computing Technique," IRE Trans. EC, 1959
- Walther, J.S., "A Unified Algorithm for Elementary Functions," SJCC 1971
- Xilinx PG105 "CORDIC" Product Guide

**参数配置**:
| Config | mode | m | iterations | W_in | W_out | 应用 | 来源 |
|--------|------|---|-----------|------|-------|------|------|
| C1 | rotation | 1 (circ) | 16 | 16 | 16 | NCO sin/cos | Xilinx PG105 |
| C2 | vectoring | 1 (circ) | 16 | 16 | 16 | atan2, magnitude | Xilinx PG105 |
| C3 | rotation | -1 (hyp) | 20 | 16 | 16 | sinh/cosh | Walther 1971 |
| C4 | vectoring | -1 (hyp) | 20 | 16 | 16 | sqrt, ln | Walther 1971 |
| C5 | rotation | 0 (lin) | 16 | 16 | 32 | multiply | Walther 1971 |

---

## 14.10 伪随机数生成器 (PRNG for Simulation)

**公式**:
```
AWGN 生成 (Box-Muller):
u₁, u₂: 均匀分布 [0,1) (来自 LFSR 或 Tausworthe)
z₁ = √(-2·ln(u₁)) · cos(2π·u₂)
z₂ = √(-2·ln(u₁)) · sin(2π·u₂)

Tausworthe 组合生成器:
s₁[n+1] = ((s₁[n] & 0xFFFFFFFE) << 12) ^ (((s₁[n] << 13) ^ s₁[n]) >> 19)
s₂, s₃: 类似, 不同参数
output = s₁ ^ s₂ ^ s₃

用途: 信道模拟 (AWGN, Rayleigh fading)
```

**来源**:
- Box, G.E.P. & Muller, M.E., "A Note on the Generation of Random Normal Deviates," Ann. Math. Stat., 1958
- L'Ecuyer, P., "Maximally Equidistributed Combined Tausworthe Generators," Math. Comp., 1996
- Boutillon, J.L., Danger, J.L., Ghazel, A., "A New FPGA Implementation of a Gaussian Noise Generator," 2003

**参数配置**:
| Config | method | output_width | distribution | 应用 | 来源 |
|--------|--------|-------------|-------------|------|------|
| C1 | Box-Muller + Tausworthe | 16-bit | Gaussian | AWGN 信道仿真 | Box-Muller 1958 |
| C2 | LFSR (32-bit) | 32-bit | uniform | 通用随机数 | L'Ecuyer 1996 |
| C3 | Box-Muller + CORDIC | 16-bit | Gaussian | 高速 AWGN | Boutillon 2003 |
