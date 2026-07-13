# Category 1: 基础数学运算模块 (25 kernels, 100+ configurations)

---

## 1.01 定点复数乘法

**公式**: `(a+jb)(c+jd) = (ac-bd) + j(ad+bc)`

**3乘法优化 (Karatsuba)**:
```
k1 = c(a+b), k2 = a(d-c), k3 = b(c+d)
Re = k1 - k3, Im = k1 + k2
```

**来源**:
- 3GPP TS 38.211 V17.3.0, Section 5.2.2 (OFDM 基带处理中复数乘法为基本运算)
- Proakis "Digital Communications" 5th Ed, Appendix B
- Xilinx XAPP1209 "Complex Multiplier" Application Note

**参数配置**:
| Config | input_width | output_width | 应用场景 | 来源 |
|--------|-------------|--------------|----------|------|
| C1 | 16-bit (1.15) | 32-bit (1.31) | 5G NR 基带 | 3GPP TS 38.211 §5.2 typical implementation |
| C2 | 12-bit (1.11) | 24-bit (1.23) | LTE 基带 | 3GPP TS 36.211, typical FPGA impl |
| C3 | 18-bit (1.17) | 36-bit (1.35) | WiFi 802.11ax | IEEE 802.11ax high-precision path |
| C4 | 8-bit (1.7) | 16-bit (1.15) | DVB-S2 接收机 | EN 302 307 low-complexity receiver |
| C5 | 24-bit (1.23) | 48-bit (1.47) | 高精度雷达 | 精度敏感应用 |

---

## 1.02 CORDIC 旋转模式

**公式**:
```
x[i+1] = x[i] - σ[i] · y[i] · 2^(-i)
y[i+1] = y[i] + σ[i] · x[i] · 2^(-i)
z[i+1] = z[i] - σ[i] · arctan(2^(-i))
σ[i] = sign(z[i])
```

**来源**:
- Volder, J.E., "The CORDIC Trigonometric Computing Technique," IRE Trans. Electronic Computers, 1959
- Meher et al., "50 Years of CORDIC," IEEE Trans. Circuits Syst. I, 2009
- Xilinx LogiCORE CORDIC v6.0 Product Guide (PG105)
- 3GPP TS 38.211 §5.2.2.1 (相位旋转用于 CFO 补偿)

**参数配置**:
| Config | iterations | data_width | 应用场景 | 来源 |
|--------|-----------|------------|----------|------|
| C1 | 12 | 16-bit | 5G NR CFO 补偿 | 3GPP TS 38.211, typical impl |
| C2 | 16 | 16-bit | WiFi 802.11 相位跟踪 | IEEE 802.11-2020 §19.3.10 |
| C3 | 8 | 12-bit | DVB-S2 低复杂度 | ETSI EN 302 307 |
| C4 | 20 | 24-bit | 高精度 SDR | Analog Devices AD9361 参考设计 |
| C5 | 10 | 14-bit | LTE 上行 SC-FDMA | 3GPP TS 36.211 §5.6 |

---

## 1.03 CORDIC 向量模式 (求幅值/相位)

**公式**:
```
同旋转模式，但 σ[i] = -sign(y[i])
收敛后: x → K√(x₀²+y₀²), z → z₀ + arctan(y₀/x₀)
K = Π cos(arctan(2^(-i))) ≈ 0.6073
```

**来源**:
- 同 1.02
- 用途: 信号幅度检测、相位估计 (3GPP TS 38.213 §4.1 CSI measurement)

**参数配置**: 同 1.02

---

## 1.04 对数/指数近似 (Mitchell's Algorithm)

**公式**:
```
log₂(x) ≈ exponent(x) + mantissa(x)  (一阶近似)
log₂(1+f) ≈ f + correction_term       (修正项可查表)
```

**来源**:
- Mitchell, J.N., "Computer Multiplication and Division Using Binary Logarithms," IRE Trans., 1962
- 应用: LDPC BP 译码中 log-likelihood 计算 (Richardson & Urbanke, "Modern Coding Theory", Ch. 4)
- Turbo MAP 译码中的 max* 运算 (Viterbi, "An Intuitive Justification," IEEE JSAC 1998)

**参数配置**:
| Config | input_width | table_depth | correction_order | 应用 |
|--------|-------------|-------------|-----------------|------|
| C1 | 16-bit | 16 entries | 1st order | LDPC BP 译码 |
| C2 | 12-bit | 8 entries | 0th order (无修正) | 低复杂度 Turbo |
| C3 | 20-bit | 32 entries | 2nd order | 高精度 |

---

## 1.05 Newton-Raphson 倒数

**公式**:
```
x[n+1] = x[n] · (2 - a · x[n])
收敛到 1/a，二次收敛
```

**来源**:
- Ercegovac & Lang, "Digital Arithmetic," Morgan Kaufmann, Ch. 10
- 应用: MMSE 均衡中的除法 (3GPP TS 38.214 §5.2.2.1)
- 应用: 归一化运算 (Turbo 译码度量归一化)

**参数配置**:
| Config | iterations | init_method | data_width | 应用 |
|--------|-----------|-------------|------------|------|
| C1 | 3 | LUT (8-bit) | 16-bit | MMSE EQ 归一化 |
| C2 | 2 | LUT (6-bit) | 12-bit | 低精度快速除法 |
| C3 | 4 | LUT (10-bit) | 24-bit | 高精度信道估计 |

---

## 1.06 定点向量内积 (MAC Array)

**公式**: `y = Σᵢ₌₀^(N-1) a[i] · b[i]`

**来源**:
- 所有 FIR/相关器的核心运算
- 3GPP TS 38.211 §6.3.1.5 (DMRS 相关检测)
- IEEE 802.11-2020 §17.3.10 (信道估计中的相关)

**参数配置**:
| Config | N | a_width | b_width | acc_width | 应用 | 来源 |
|--------|---|---------|---------|-----------|------|------|
| C1 | 16 | 16-bit | 16-bit | 40-bit | FIR-16 tap | 通用 DSP |
| C2 | 64 | 12-bit | 12-bit | 32-bit | LTE PSS 相关 | 3GPP TS 36.211 §6.11.1 |
| C3 | 128 | 16-bit | 16-bit | 42-bit | 5G NR SSB 检测 | 3GPP TS 38.211 §7.4.3 |
| C4 | 256 | 8-bit | 8-bit | 24-bit | WiFi 短训练序列 | 802.11-2020 §17.3.3 |
| C5 | 1024 | 16-bit | 16-bit | 48-bit | 长序列相关 | CCSDS 131.0 |
| C6 | 4 | 18-bit | 18-bit | 38-bit | 4×4 MIMO 内积 | 3GPP TS 38.214 |

---

## 1.07 小规模矩阵-向量乘

**公式**: `y = A · x`, where A ∈ ℝ^(M×N), x ∈ ℝ^N

**来源**:
- 3GPP TS 38.214 §5.2.2.1 (MIMO precoding: W·s)
- 3GPP TS 38.211 §6.3.1.4 (Layer mapping)
- Codebook-based precoding: 3GPP TS 38.214 Table 5.2.2.2.1-X

**参数配置**:
| Config | M×N | data_width | 应用 | 来源 |
|--------|-----|------------|------|------|
| C1 | 2×2 | 16-bit complex | 2×2 MIMO precoding | 3GPP TS 38.214 §5.2.2.2.1 |
| C2 | 4×4 | 16-bit complex | 4×4 MIMO | 3GPP TS 38.214 §5.2.2.2.1 |
| C3 | 4×2 | 16-bit complex | 4T2R precoding | 3GPP TS 38.214 |
| C4 | 8×4 | 12-bit complex | Massive MIMO (简化) | 3GPP TS 38.214 |
| C5 | 2×2 | 18-bit complex | WiFi 802.11ax MIMO | IEEE 802.11ax §27.3.11 |

---

## 1.08 Givens 旋转 (用于 QR 分解)

**公式**:
```
[c  s] [a]   [r]
[-s c] [b] = [0]

c = a/√(a²+b²), s = b/√(a²+b²), r = √(a²+b²)
CORDIC实现: 向量模式消去 b 分量
```

**来源**:
- Golub & Van Loan, "Matrix Computations" 4th Ed, §5.1.8
- 应用: MIMO QR 分解检测 (Wubben et al., "MMSE-based lattice reduction," IEEE Trans. SP, 2004)
- 3GPP TS 38.214 §5.2.2.1 (MIMO 检测方法之一)

**参数配置**:
| Config | matrix_size | data_width | CORDIC_iters | 应用 |
|--------|-------------|------------|-------------|------|
| C1 | 2×2 | 16-bit | 12 | 2×2 MIMO | 
| C2 | 4×4 | 16-bit | 14 | 4×4 MIMO |
| C3 | 4×2 | 18-bit | 16 | 4T2R SU-MIMO |

---

## 1.09 饱和加法/减法

**公式**:
```
sat_add(a, b) = clip(a + b, -2^(N-1), 2^(N-1)-1)
```

**来源**:
- 3GPP TS 38.212 §5.3.2 (LDPC 译码中 LLR 消息的饱和运算)
- ITU-T G.729 §3.1 (语音编码器定点运算规范: "basic operators" L_add, L_sub with saturation)
- ETSI EFR/AMR codec C reference code ("basicop2.h")

**参数配置**:
| Config | width | 应用 | 来源 |
|--------|-------|------|------|
| C1 | 6-bit | LDPC LLR | 3GPP TS 38.212 typical |
| C2 | 8-bit | Turbo metric | 3GPP TS 36.212 |
| C3 | 16-bit | 语音编码 | ITU-T G.729 basic operators |
| C4 | 32-bit | 长累加 | ITU-T G.729 L_add |

---

## 1.10 查表 + 线性插值

**公式**:
```
addr = x >> frac_bits
frac = x & ((1<<frac_bits)-1)
y = LUT[addr] + frac * (LUT[addr+1] - LUT[addr]) >> frac_bits
```

**来源**:
- Xilinx XAPP552 "Sine/Cosine Look-Up Table" 
- 应用: NCO sin/cos 查表 (3GPP TS 38.211 §5.2.2.1 相位旋转)
- 应用: LDPC φ函数查表 (Fossorier et al., "Reduced complexity iterative decoding," IEEE Trans. Comm. 1999)

**参数配置**:
| Config | table_depth | data_width | interp | 应用 | 来源 |
|--------|-------------|------------|--------|------|------|
| C1 | 1024 | 16-bit | linear | NCO sin/cos | 3GPP baseband typical |
| C2 | 64 | 8-bit | none | LDPC φ(x) | Fossorier 1999 |
| C3 | 256 | 12-bit | linear | log₂ approximation | Mitchell method |
| C4 | 4096 | 18-bit | linear | 高精度 sin/cos | SDR 高动态范围 |

---

## 1.11 优先级编码器 / 前导零计数 (CLZ)

**公式**:
```
CLZ(x) = N - 1 - ⌊log₂(x)⌋
```

**来源**:
- 用于浮点归一化、AGC 增益调整
- Xilinx UG901 "Vivado Synthesis" (inferred priority encoder)
- 应用: Turbo 译码度量归一化 (3GPP TS 36.212 §5.1.3.2)

**参数配置**:
| Config | input_width | 应用 |
|--------|-------------|------|
| C1 | 16-bit | AGC gain control |
| C2 | 32-bit | 宽动态范围归一化 |
| C3 | 8-bit | 短字长 Turbo metric |

---

## 1.12 桶形移位器 (Barrel Shifter)

**公式**:
```
y = x << n  (logical/arithmetic, variable n)
实现: log₂(W) 级 2:1 MUX
```

**来源**:
- Patterson & Hennessy, "Computer Organization" (基本移位器结构)
- 应用: CORDIC 移位 (每级固定移位，但组合时需 barrel shifter)
- 应用: CIC 滤波器增益补偿 (Hogenauer, "An Economical Class of Digital Filters," IEEE Trans. ASSP 1981)

**参数配置**:
| Config | data_width | shift_range | direction | 应用 |
|--------|------------|-------------|-----------|------|
| C1 | 16-bit | 0-15 | both | 通用 DSP |
| C2 | 32-bit | 0-31 | right (arith) | AGC 增益缩放 |
| C3 | 24-bit | 0-7 | right | CIC gain compensation |

---

## 1.13 并行 CRC 计算

**公式**:
```
R(x) = M(x) · x^n mod G(x)
并行化: 对 W-bit 输入同时计算 (展开 LFSR W 步)
```

**来源**:
- 3GPP TS 38.212 §5.1 (CRC-24A: G(x) = x²⁴+x²³+x¹⁸+x¹⁷+x¹⁴+x¹¹+x¹⁰+x⁷+x⁶+x⁵+x⁴+x³+x+1)
- 3GPP TS 38.212 §5.1 (CRC-24B: G(x) = x²⁴+x²³+x⁶+x⁵+x+1)
- 3GPP TS 38.212 §5.1 (CRC-16: G(x) = x¹⁶+x¹²+x⁵+1)
- 3GPP TS 38.212 §5.1 (CRC-11: G(x) = x¹¹+x¹⁰+x⁹+x⁵+1)
- 3GPP TS 38.212 §5.1 (CRC-6: G(x) = x⁶+x⁵+1)
- IEEE 802.11-2020 §17.3.5.6 (CRC-32 for FCS)
- IEEE 802.3 (Ethernet CRC-32)

**参数配置**:
| Config | polynomial | parallel_width | 应用 | 来源 |
|--------|-----------|---------------|------|------|
| C1 | CRC-24A | 1-bit (serial) | 5G NR TB CRC | 3GPP TS 38.212 §5.1 |
| C2 | CRC-24A | 8-bit | 5G NR parallel | 3GPP TS 38.212 |
| C3 | CRC-24A | 32-bit | 高吞吐率 | 3GPP TS 38.212 |
| C4 | CRC-24B | 8-bit | 5G NR CB CRC | 3GPP TS 38.212 |
| C5 | CRC-16 | 16-bit | 5G NR UCI | 3GPP TS 38.212 |
| C6 | CRC-11 | 8-bit | 5G NR polar | 3GPP TS 38.212 |
| C7 | CRC-32 | 8-bit | WiFi FCS | IEEE 802.11-2020 §17.3.5.6 |
| C8 | CRC-32 | 64-bit | 高速以太网 | IEEE 802.3 |
| C9 | CRC-8 | 8-bit | DVB-S2 header | ETSI EN 302 307 §5.1.3 |

---

## 1.14 伽罗华域 GF(2^m) 乘法

**公式**:
```
c(x) = a(x) · b(x) mod p(x)
p(x): 本原多项式
```

**来源**:
- 3GPP TS 38.212 §5.1 (不直接, 但 RS 码基于 GF)
- DVB-S2 ETSI EN 302 307 §5.3 (BCH 码使用 GF(2^16) 运算)
- CCSDS 131.0-B-4 (RS(255,223) 使用 GF(2^8), p(x)=x⁸+x⁴+x³+x²+1)
- Lin & Costello, "Error Control Coding" 2nd Ed, Ch. 2

**参数配置**:
| Config | m | primitive_poly | 应用 | 来源 |
|--------|---|---------------|------|------|
| C1 | 8 | 0x11D (x⁸+x⁴+x³+x²+1) | RS(255,223) | CCSDS 131.0-B-4 |
| C2 | 8 | 0x187 (x⁸+x⁷+x²+x+1) | DVB-S2 RS | EN 302 307 |
| C3 | 4 | 0x13 (x⁴+x+1) | 教学用小域 | Lin & Costello |
| C4 | 16 | — | DVB-S2 BCH | EN 302 307 §5.3 |

---

## 1.15 伽罗华域 GF(2^m) 求逆

**公式**:
```
方法1: Fermat 小定理: a⁻¹ = a^(2^m - 2)
方法2: 扩展欧几里得算法
```

**来源**:
- 同 1.14
- 应用: RS 译码 Berlekamp-Massey 算法中的关键运算

**参数配置**: 同 1.14

---

## 1.16 模运算 (Modular Arithmetic)

**公式**:
```
y = x mod M
特殊情况: M = 2^n (截断), M = 2^n - 1 (循环加)
```

**来源**:
- 3GPP TS 38.212 §5.4.2.1 (交织器地址: QPP permutation modulo N)
- 3GPP TS 38.211 §7.4.1.1 (slot/symbol numbering modulo)

**参数配置**:
| Config | M | data_width | method | 应用 | 来源 |
|--------|---|------------|--------|------|------|
| C1 | 可变 | 16-bit | general | 交织器地址 | 3GPP TS 38.212 |
| C2 | 2^n | 16-bit | truncate | 循环缓冲器 | 通用 |
| C3 | 2^n-1 | 16-bit | wrap-around add | m-序列生成 | 通用 |

---

## 1.17 累加器 (带溢出保护)

**公式**:
```
S[n] = S[n-1] + x[n]
带饱和: S[n] = sat(S[n-1] + x[n], MAX, MIN)
带归一化: if S[n] > TH: S[n] -= TH (防溢出)
```

**来源**:
- 3GPP TS 36.212 §5.1.3.2 (Turbo 译码路径度量归一化)
- Proakis, Ch. 8 (Viterbi 译码中的 path metric overflow prevention)
- Hogenauer 1981 (CIC 中的积分器)

**参数配置**:
| Config | input_width | acc_width | overflow_mode | 应用 |
|--------|-------------|-----------|---------------|------|
| C1 | 8-bit | 16-bit | saturate | Viterbi path metric |
| C2 | 16-bit | 40-bit | wrap (modular) | CIC integrator |
| C3 | 6-bit | 12-bit | normalize (subtract max) | Turbo metric |
| C4 | 16-bit | 32-bit | saturate | 功率累加 |

---

## 1.18 比较与排序网络

**公式**:
```
compare_and_swap(a, b): if a > b: swap(a,b)
Bitonic sort: O(N·log²N) comparators
Odd-even merge sort
```

**来源**:
- Batcher, K.E., "Sorting Networks and Their Applications," AFIPS 1968
- 应用: Polar SCL 译码中的路径排序 (3GPP TS 38.212 §5.3.1)
- 应用: MIMO 检测中的 SQRD 排序 (Wubben et al., 2004)
- 应用: LDPC 找最小值/次小值

**参数配置**:
| Config | N | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 4 | 16-bit | Polar SCL L=4 | 3GPP TS 38.212 |
| C2 | 8 | 16-bit | Polar SCL L=8 | 3GPP TS 38.212 |
| C3 | 4 | 16-bit complex | MIMO 4×4 排序 | SQRD |
| C4 | 19 | 6-bit | LDPC top-2 min (BG1 max dc) | 3GPP TS 38.212 |

---

## 1.19 符号函数与绝对值 (补码)

**公式**:
```
sign(x) = x[MSB]  (补码符号位)
abs(x) = x[MSB] ? (~x + 1) : x
```

**来源**:
- 3GPP TS 38.212 §5.3.2 (LDPC Min-Sum 中符号/幅值分离)
- 所有 sign-magnitude 表示的通信算法

**参数配置**:
| Config | width | 应用 |
|--------|-------|------|
| C1 | 6-bit | LDPC LLR |
| C2 | 8-bit | Turbo metric |
| C3 | 16-bit | 基带信号 |

---

## 1.20 定点数格式转换

**公式**:
```
y<W2,F2> = convert(x<W1,F1>)
需要: 移位 + 饱和 + 舍入
```

**来源**:
- ITU-T G.729 §3.1 (16-bit ↔ 32-bit 定点转换规范)
- 所有多级处理链路的级间位宽匹配

**参数配置**:
| Config | from | to | round_mode | 应用 |
|--------|------|-----|-----------|------|
| C1 | Q1.15 → Q1.7 | | truncate | 低精度路径 |
| C2 | Q1.31 → Q1.15 | | convergent | ITU-T G.729 |
| C3 | Q5.11 → Q1.15 | | saturate+round | AGC 输出归一化 |

---

## 1.21 Max* 运算 (Jacobian Logarithm)

**公式**:
```
max*(a,b) = max(a,b) + ln(1 + e^(-|a-b|))
近似1 (max-log): max*(a,b) ≈ max(a,b)
近似2 (查表修正): max*(a,b) ≈ max(a,b) + correction_table[|a-b|]
```

**来源**:
- Robertson et al., "A Comparison of Optimal and Sub-optimal MAP Decoding Algorithms," IEEE ICC 1995
- 3GPP TS 36.212 §5.1.3.2 (Turbo MAP 译码的核心运算)
- Viterbi, "An Intuitive Justification of MAP and ML Decoders," IEEE JSAC 1998

**参数配置**:
| Config | method | table_depth | data_width | 应用 | 来源 |
|--------|--------|-------------|------------|------|------|
| C1 | exact (LUT) | 32 | 8-bit | LTE Turbo MAP | 3GPP TS 36.212 |
| C2 | max-log (no table) | — | 8-bit | 低复杂度 Turbo | 3GPP TS 36.212 |
| C3 | linear approx | 8 | 6-bit | 超低复杂度 | CCSDS Turbo |
| C4 | exact (LUT) | 64 | 10-bit | 高性能 | DVB-RCS2 |

---

## 1.22 加权求和 (Scalar × Vector + Accumulate)

**公式**:
```
y = α · a + β · b
(标量×向量的线性组合)
```

**来源**:
- 3GPP TS 38.212 §5.3.2 (LDPC Normalized Min-Sum: α · min(...))
- 3GPP TS 38.214 §5.2.2.1 (MMSE 均衡: (H^H·H + σ²I)⁻¹ 中的加权)
- HARQ 软合并: LLR_combined = LLR_old + LLR_new (3GPP TS 38.212 §5.4.2)

**参数配置**:
| Config | vector_len | data_width | α/β_type | 应用 |
|--------|-----------|------------|----------|------|
| C1 | 1 (scalar) | 6-bit | fixed (0.75) | LDPC NMS |
| C2 | 1 (scalar) | 6-bit | fixed (0.5=shift) | LDPC OMS |
| C3 | N (vector) | 16-bit | variable | MMSE combining |
| C4 | N (vector) | 8-bit | fixed (1) | HARQ soft combine |

---

## 1.23 复数除法

**公式**:
```
(a+jb)/(c+jd) = (ac+bd)/(c²+d²) + j(bc-ad)/(c²+d²)
```

**来源**:
- 3GPP TS 38.214 §5.2.2.1 (频域 ZF 均衡: X[k] = Y[k]/H[k])
- IEEE 802.11-2020 §19.3.10 (OFDM one-tap equalizer)

**参数配置**:
| Config | data_width | div_method | 应用 | 来源 |
|--------|------------|-----------|------|------|
| C1 | 16-bit | Newton-Raphson | 5G NR ZF EQ | 3GPP TS 38.214 |
| C2 | 12-bit | CORDIC (polar div) | LTE EQ | 3GPP TS 36.211 |
| C3 | 18-bit | Newton-Raphson | WiFi 802.11ax EQ | IEEE 802.11ax |

---

## 1.24 指数移动平均 (IIR-1st order)

**公式**:
```
y[n] = α · x[n] + (1-α) · y[n-1]
当 α = 2^(-k): y[n] = y[n-1] + (x[n] - y[n-1]) >> k  (无乘法器)
```

**来源**:
- 3GPP TS 38.213 §4.1 (CSI-RS RSRP 测量中的滤波)
- 3GPP TS 38.133 §9.1.2 (L3 filtering: Fn = (1-α)·Fn-1 + α·Mn)
- GNU Radio: single_pole_iir_filter

**参数配置**:
| Config | α | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 1/4 (shift) | 16-bit | RSRP 滤波 | 3GPP TS 38.133 |
| C2 | 1/8 (shift) | 16-bit | 噪声方差估计 | 3GPP TS 38.213 |
| C3 | 1/16 (shift) | 12-bit | AGC 功率跟踪 | SDR typical |
| C4 | 可变 | 16-bit | 自适应滤波 | 通用 |

---

## 1.25 位反转置换 (Bit-Reversal Permutation)

**公式**:
```
y[bit_reverse(i)] = x[i]
bit_reverse(i): 将 i 的 log₂(N) 位二进制表示逆序
```

**来源**:
- Cooley & Tukey, "An Algorithm for the Machine Calculation of Complex Fourier Series," Math. Comp. 1965
- 3GPP TS 38.211 §5.3.1 (OFDM: FFT 输出重排)
- IEEE 802.11-2020 §17.3.10.6 (FFT processing)

**参数配置**:
| Config | N | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 64 | 16-bit complex | WiFi 802.11a | IEEE 802.11-2020 |
| C2 | 256 | 16-bit complex | WiFi 802.11n (40MHz) | IEEE 802.11-2020 |
| C3 | 512 | 16-bit complex | LTE 5MHz | 3GPP TS 36.211 |
| C4 | 1024 | 16-bit complex | LTE 10MHz / WiFi 802.11ax | 3GPP / IEEE |
| C5 | 2048 | 16-bit complex | LTE 20MHz | 3GPP TS 36.211 §5.6 |
| C6 | 4096 | 16-bit complex | 5G NR 30kHz SCS, 100MHz | 3GPP TS 38.211 §5.3.1 |
