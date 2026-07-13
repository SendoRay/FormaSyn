# Category 9: 信源编码 (12 kernels)

---

## 9.01 μ律压扩 (μ-law Companding)

**公式**:
```
压缩: F(x) = sgn(x) · ln(1 + μ|x|) / ln(1 + μ)
       μ = 255 (北美/日本标准)

逆变换 (扩展):
x = sgn(y) · (1/μ) · ((1+μ)^|y| - 1)

8-bit 量化: 分段线性近似 (8 段, 每段 16 级)
编码: 1 bit 符号 + 3 bit 段号 + 4 bit 段内量化
```

**来源**:
- ITU-T G.711 (1988) §2.1 (μ-law encoding, Table 1)
- ITU-T G.711 Annex A (2000) (μ-law 分段线性表)
- Smith, B., "Instantaneous Companding of Quantized Signals," Bell Syst. Tech. J., 1957

**参数配置**:
| Config | μ | input_bits | output_bits | 应用 | 来源 |
|--------|---|-----------|------------|------|------|
| C1 | 255 | 14 (linear PCM) | 8 | G.711 μ-law 编码 | ITU-T G.711 §2.1 |
| C2 | 255 | 8 | 14 | G.711 μ-law 解码 | ITU-T G.711 §2.1 |

---

## 9.02 A律压扩 (A-law Companding)

**公式**:
```
压缩:
F(x) = sgn(x) · { A|x| / (1 + ln A),           |x| ≤ 1/A
                 { (1 + ln(A|x|)) / (1 + ln A),  1/A < |x| ≤ 1
A = 87.6 (欧洲/中国标准)

8-bit 量化: 分段线性近似 (13 段折线)
编码: 1 bit 符号 + 3 bit 段号 + 4 bit 段内量化
偶数位取反 (与 μ-law 区分)
```

**来源**:
- ITU-T G.711 (1988) §2.2 (A-law encoding, Table 2)
- ITU-T G.711 Annex A (A-law 分段线性表)

**参数配置**:
| Config | A | input_bits | output_bits | 应用 | 来源 |
|--------|---|-----------|------------|------|------|
| C1 | 87.6 | 13 (linear PCM) | 8 | G.711 A-law 编码 | ITU-T G.711 §2.2 |
| C2 | 87.6 | 8 | 13 | G.711 A-law 解码 | ITU-T G.711 §2.2 |

---

## 9.03 ADPCM 编码器

**公式**:
```
预测: s_p[n] = Σ_{i=1}^{P} a_i · s_r[n-i]
差值: d[n] = s[n] - s_p[n]
自适应量化: I[n] = Q(d[n] / Δ[n])
步长更新: Δ[n+1] = Δ[n] · β(I[n])

G.726: P=2 (2阶预测器), 输出 2/3/4/5 bit
IMA ADPCM: P=0 (无预测, 仅自适应量化), 4 bit
```

**来源**:
- ITU-T G.726 (1990) (ADPCM 16/24/32/40 kbit/s)
- ITU-T G.721 (1984) (原始 32 kbit/s ADPCM, 并入 G.726)
- IMA ADPCM (Interactive Multimedia Association, 1992)

**参数配置**:
| Config | rate (kbps) | bits/sample | predictor_order | 应用 | 来源 |
|--------|-------------|------------|----------------|------|------|
| C1 | 32 | 4 | 2 | G.726 标准 | ITU-T G.726 |
| C2 | 16 | 2 | 2 | G.726 低速 | ITU-T G.726 |
| C3 | 24 | 3 | 2 | G.726 | ITU-T G.726 |
| C4 | 40 | 5 | 2 | G.726 高质量 | ITU-T G.726 |
| C5 | 32 | 4 | 0 | IMA ADPCM | IMA 1992 |

---

## 9.04 LPC 分析 (线性预测编码)

**公式**:
```
LPC 模型: s[n] = Σ_{i=1}^{P} a_i · s[n-i] + G·e[n]

Levinson-Durbin 递推:
k_m = (r[m] - Σ_{i=1}^{m-1} a_{m-1,i}·r[m-i]) / E_{m-1}
a_{m,i} = a_{m-1,i} - k_m·a_{m-1,m-i}, i=1,...,m-1
a_{m,m} = k_m
E_m = (1 - k_m²)·E_{m-1}

自相关: r[k] = Σ_n s[n]·s[n+k]
```

**来源**:
- ITU-T G.729 Annex A (1996) §3.2.1 (LP analysis: P=10, 10ms frame)
- Makhoul, J., "Linear Prediction: A Tutorial Review," Proc. IEEE, 1975
- Levinson, N., "The Wiener (Root Mean Square) Error Criterion in Filter Design and Prediction," J. Math. Phys., 1947

**参数配置**:
| Config | P (order) | frame_size | sample_rate | 应用 | 来源 |
|--------|----------|-----------|-------------|------|------|
| C1 | 10 | 80 (10ms) | 8 kHz | G.729 | ITU-T G.729 §3.2.1 |
| C2 | 10 | 160 (20ms) | 8 kHz | G.723.1 | ITU-T G.723.1 |
| C3 | 16 | 256 (16ms) | 16 kHz | AMR-WB | 3GPP TS 26.190 |

---

## 9.05 LSP/LSF 变换 (线谱频率)

**公式**:
```
LPC → LSP 变换:
A(z) = [P(z) + Q(z)] / 2
P(z) = A(z) + z^{-(P+1)} · A(z^{-1})  (对称)
Q(z) = A(z) - z^{-(P+1)} · A(z^{-1})  (反对称)

LSF: P(z) 和 Q(z) 在单位圆上的根的角频率
ω_1 < ω_2 < ... < ω_P, 交替来自 P 和 Q

优点: LSF 量化特性好, 可保证稳定性 (有序即稳定)
求根: Chebyshev 多项式方法
```

**来源**:
- ITU-T G.729 §3.2.3 (LSP 量化, 10 阶 → 10 个 LSF)
- Kabal & Ramachandran, "The Computation of Line Spectral Frequencies Using Chebyshev Polynomials," IEEE Trans. ASSP, 1986

**参数配置**:
| Config | P | method | data_width | 应用 | 来源 |
|--------|---|--------|------------|------|------|
| C1 | 10 | Chebyshev | 16-bit | G.729 | ITU-T G.729 §3.2.3 |
| C2 | 16 | Chebyshev | 16-bit | AMR-WB | 3GPP TS 26.190 |

---

## 9.06 Pitch 检测 (基音周期估计)

**公式**:
```
自相关法:
R[τ] = Σ_n s[n] · s[n+τ], τ ∈ [T_min, T_max]
T₀ = argmax_τ R[τ]

G.729: 开环搜索 → 闭环搜索
开环: T₀ ∈ [20, 143] (对应 8kHz 下 ~56Hz~400Hz)
闭环: 自适应码本搜索, 分数延迟 (1/3 样本精度)
```

**来源**:
- ITU-T G.729 §3.4 (Open-loop pitch analysis)
- ITU-T G.729 §3.7 (Closed-loop pitch search, fractional pitch)
- 3GPP TS 26.090 §5.6 (AMR pitch analysis)

**参数配置**:
| Config | T_min | T_max | resolution | frame_size | 应用 | 来源 |
|--------|-------|-------|-----------|-----------|------|------|
| C1 | 20 | 143 | 1/3 sample | 40 (5ms subframe) | G.729 | ITU-T G.729 §3.7 |
| C2 | 18 | 143 | 1/6 sample | 40 | AMR | 3GPP TS 26.090 §5.6 |

---

## 9.07 ACELP 固定码本搜索

**公式**:
```
固定码本结构: 稀疏脉冲编码
c[n] = Σ_{i=0}^{N_p-1} s_i · δ[n - m_i]
s_i ∈ {+1, -1}: 脉冲符号
m_i ∈ track_i: 脉冲位置 (每个脉冲限定在一个 track 中)

G.729: 4 个脉冲, 每个在 8 个候选位置中选 → 10 bits 位置 + 4 bits 符号 = 17 bits/subframe
搜索准则: min ‖x - g·H·c‖², H: 组合滤波器脉冲响应矩阵
```

**来源**:
- ITU-T G.729 §3.8 (Fixed codebook: algebraic CELP)
- Laflamme, Adoul, Salami, Morissette, Mabilleau, "16 kbps Wideband Speech Coding Technique Based on Algebraic CELP," IEEE ICASSP 1991
- 3GPP TS 26.090 §5.8 (AMR algebraic codebook)

**参数配置**:
| Config | N_pulses | subframe | codebook_bits | 应用 | 来源 |
|--------|---------|---------|--------------|------|------|
| C1 | 4 | 40 samples | 17 | G.729 (8 kbps) | ITU-T G.729 §3.8 |
| C2 | 10 | 40 samples | 35 | AMR 12.2 kbps | 3GPP TS 26.090 §5.8 |
| C3 | 2 | 40 samples | 12 | AMR 4.75 kbps | 3GPP TS 26.090 |

---

## 9.08 增益量化 (Pitch + Fixed Codebook Gain)

**公式**:
```
合成信号: ŝ[n] = g_p · v[n] + g_c · c[n]
g_p: 自适应码本增益 (pitch gain), 通常 [0, 1.2]
g_c: 固定码本增益

G.729: g_p 用 3 bits 标量量化
       g_c 用预测 + 4 bits 量化
       联合量化: 7 bits (g_p, g_c)
```

**来源**:
- ITU-T G.729 §3.9 (Quantization of gains)
- 3GPP TS 26.090 §5.9 (AMR gain quantization)

**参数配置**:
| Config | g_p_bits | g_c_bits | method | 应用 | 来源 |
|--------|---------|---------|--------|------|------|
| C1 | 3 | 4 | joint (7 bits) | G.729 | ITU-T G.729 §3.9 |
| C2 | 4 | 4 | joint (8 bits) | AMR 12.2k | 3GPP TS 26.090 §5.9 |

---

## 9.09 LPC 合成滤波器

**公式**:
```
1/A(z) 全极点滤波器:
ŝ[n] = e[n] + Σ_{i=1}^{P} a_i · ŝ[n-i]
e[n] = g_p · v[n] + g_c · c[n]  (激励信号)

实现: P 阶 IIR (直接型)
注意: 需确保稳定性 (所有极点在单位圆内)
```

**来源**:
- ITU-T G.729 §4.1 (Synthesis filter)
- 3GPP TS 26.090 §6.1 (AMR synthesis)

**参数配置**:
| Config | P | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 10 | 16-bit | G.729 | ITU-T G.729 §4.1 |
| C2 | 16 | 16-bit | AMR-WB | 3GPP TS 26.190 |

---

## 9.10 后置滤波器 (Post-filter)

**公式**:
```
短时后置滤波:
H_f(z) = A(z/γ_n) / A(z/γ_d), γ_n < γ_d
γ_n = 0.55, γ_d = 0.7 (G.729 典型值)

长时 (基音) 后置滤波:
H_lt(z) = (1 + g_lt · z^{-T₀}) / (1 + g_lt)
T₀: 基音周期

倾斜补偿:
H_t(z) = 1 - μ · z^{-1}, μ = k₁ · 0.5 (k₁: 第一反射系数)
```

**来源**:
- ITU-T G.729 §4.2 (Post-processing: short-term + long-term + tilt compensation)
- Chen & Gersho, "Adaptive Postfiltering for Quality Enhancement of Coded Speech," IEEE Trans. SP, 1995

**参数配置**:
| Config | P | γ_n | γ_d | 应用 | 来源 |
|--------|---|-----|-----|------|------|
| C1 | 10 | 0.55 | 0.7 | G.729 | ITU-T G.729 §4.2.1 |
| C2 | 10 | 0.5 | 0.8 | AMR | 3GPP TS 26.090 §6.2 |

---

## 9.11 矢量量化 (Vector Quantization)

**公式**:
```
编码: i* = argmin_i ‖x - c_i‖²
c_i ∈ codebook {c_0, ..., c_{N-1}}
N = 2^B 个码字, B bits

分裂矢量量化 (Split VQ):
x = [x₁, x₂, ..., x_K], 每个子向量独立量化
总 bits = B₁ + B₂ + ... + B_K

G.729 LSF 量化: 10 维 → 分成 (4,3,3), 用 (7,5,5) bits = 17 bits/10ms
```

**来源**:
- ITU-T G.729 §3.2.4 (LSF quantization using MA prediction + split VQ)
- Linde, Buzo, Gray, "An Algorithm for Vector Quantizer Design," IEEE Trans. Comm., 1980 (LBG 算法)

**参数配置**:
| Config | dim | splits | bits | 应用 | 来源 |
|--------|-----|--------|------|------|------|
| C1 | 10 | (4,3,3) | (7,5,5)=17 | G.729 LSF VQ | ITU-T G.729 §3.2.4 |
| C2 | 10 | (5,5) | (7,7)=14 | AMR LSF VQ | 3GPP TS 26.090 |

---

## 9.12 自适应后置 (Adaptive De-emphasis / Pre-emphasis)

**公式**:
```
预加重 (发送端): s'[n] = s[n] - α · s[n-1], α ≈ 0.68~0.7
去加重 (接收端): s[n] = s'[n] + α · s[n-1]

用途: 提升高频能量, 使 LPC 分析更稳定
实现: 1 阶 FIR (预加重) / 1 阶 IIR (去加重)
```

**来源**:
- ITU-T G.729 §3.2 (Pre-processing: pre-emphasis filter, α=0.7)
- 3GPP TS 26.090 §5.2 (AMR pre-emphasis)

**参数配置**:
| Config | α | direction | data_width | 应用 | 来源 |
|--------|---|-----------|------------|------|------|
| C1 | 0.7 | pre-emphasis | 16-bit | G.729 | ITU-T G.729 §3.2 |
| C2 | 0.68 | pre-emphasis | 16-bit | AMR | 3GPP TS 26.090 §5.2 |
| C3 | 0.7 | de-emphasis | 16-bit | G.729 解码 | ITU-T G.729 §4.2.2 |
