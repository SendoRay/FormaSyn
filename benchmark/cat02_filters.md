# Category 2: 数字滤波器 (20 kernels, 120+ configurations)

---

## 2.01 FIR 直接型

**公式**: `y[n] = Σ_{k=0}^{N-1} h[k] · x[n-k]`

**来源**:
- Proakis & Manolakis, "Digital Signal Processing," 4th Ed, Ch. 9
- 3GPP TS 36.104 V15.9.0 §6.6.3 (基站发射机 ACLR 滤波要求，需 FIR 实现)
- IEEE 802.11-2020 §17.3.2.4 (Spectral shaping filter)
- Xilinx PG149 "FIR Compiler" Product Guide

**参数配置**:
| Config | N (taps) | input_width | coeff_width | 应用 | 来源 |
|--------|----------|-------------|-------------|------|------|
| C1 | 16 | 16-bit | 16-bit | 抗混叠滤波 | 通用 DSP |
| C2 | 32 | 16-bit | 16-bit | 脉冲成形 (RRC) | 3GPP TS 36.104 |
| C3 | 64 | 16-bit | 18-bit | 信道选择 | SDR (AD9361 参考) |
| C4 | 128 | 12-bit | 12-bit | 窄带滤波 | SDR |
| C5 | 256 | 16-bit | 16-bit | 高选择性 | 专用接收机 |
| C6 | 15 | 16-bit | 16-bit | WiFi 半带 | IEEE 802.11 |

---

## 2.02 FIR 对称型 (线性相位)

**公式**:
```
利用 h[k] = h[N-1-k]:
y[n] = Σ_{k=0}^{(N-1)/2} h[k] · (x[n-k] + x[n-N+1+k])
乘法器数量减半: ⌈N/2⌉ 个
```

**来源**:
- Proakis & Manolakis, Ch. 9.2.1 (Linear-phase FIR structures)
- Xilinx PG149 §2 (FIR Compiler symmetric optimization)
- 应用: 所有需要线性相位的通信滤波器 (RRC, 信道选择)

**参数配置**:
| Config | N (taps) | symmetry | input_width | 实际乘法器数 | 应用 |
|--------|----------|----------|-------------|-------------|------|
| C1 | 32 | even symmetric | 16-bit | 16 | RRC 成形 |
| C2 | 63 | odd symmetric | 16-bit | 32 | 半带 |
| C3 | 128 | even symmetric | 12-bit | 64 | 窄带 |
| C4 | 15 | odd symmetric | 16-bit | 8 | 短滤波器 |

---

## 2.03 FIR 转置型

**公式**:
```
同直接型 y[n] = Σ h[k]·x[n-k]
但结构转置: 输入广播，乘积逐级延迟累加
关键路径: 1 multiplier + 1 adder (vs 直接型的加法器链)
```

**来源**:
- Proakis & Manolakis, Ch. 9.2.2
- Xilinx PG149 §2 ("Transpose" form for high clock rate)
- 常用于高时钟频率设计

**参数配置**: 同 2.01

---

## 2.04 FIR 多相分解 (用于抽取/插值)

**公式**:
```
抽取 (M倍):
H(z) = Σ_{m=0}^{M-1} z^{-m} · E_m(z^M)
y[n] = Σ_{m=0}^{M-1} E_m(z) applied to x[nM+m]

插值 (L倍):
H(z) = Σ_{l=0}^{L-1} z^{-l} · R_l(z^L)
```

**来源**:
- Vaidyanathan, P.P., "Multirate Systems and Filter Banks," Prentice Hall, 1993, Ch. 4
- Proakis & Manolakis, Ch. 11
- 3GPP TS 36.104 §6.6 (基站采样率转换, 30.72 MHz ↔ 其他速率)
- AD9361 Reference Design (数字上/下变频多相滤波)

**参数配置**:
| Config | taps_per_phase | M/L | phases | input_width | 应用 | 来源 |
|--------|---------------|-----|--------|-------------|------|------|
| C1 | 12 | M=2 | 2 | 16-bit | 半带抽取 | 通用 |
| C2 | 16 | M=4 | 4 | 16-bit | 信道化 | SDR channelizer |
| C3 | 8 | L=4 | 4 | 16-bit | 插值 | DUC |
| C4 | 16 | M=8 | 8 | 12-bit | 宽带抽取 | AD9361 DDC |
| C5 | 4 | M=2 | 2 | 16-bit | LTE 采样率转换 | 3GPP TS 36.104 |
| C6 | 32 | M=16 | 16 | 16-bit | 高抽取比 | 窄带接收 |

---

## 2.05 CIC 滤波器 (级联积分梳状)

**公式**:
```
传递函数: H(z) = [(1 - z^{-RM}) / (1 - z^{-1})]^N

积分器: y[n] = y[n-1] + x[n]           (运行在高速率)
梳状器: y[n] = x[n] - x[n-RM]          (运行在低速率)
增益: (RM)^N
位宽增长: N·⌈log₂(RM)⌉ + W_in
```

**来源**:
- Hogenauer, E.B., "An Economical Class of Digital Filters for Decimation and Interpolation," IEEE Trans. ASSP, 1981
- Xilinx PG140 "CIC Compiler" Product Guide
- AD9361 Reference Manual §4 (数字抽取/插值链路使用 CIC)

**参数配置**:
| Config | N (stages) | R (rate) | M (diff delay) | input_width | 应用 | 来源 |
|--------|-----------|----------|---------------|-------------|------|------|
| C1 | 3 | 8 | 1 | 16-bit | SDR DDC | AD9361 |
| C2 | 4 | 16 | 1 | 16-bit | SDR DDC 高抽取 | AD9361 |
| C3 | 5 | 32 | 1 | 12-bit | 窄带接收 | SDR |
| C4 | 3 | 4 | 1 | 16-bit | LTE 采样率匹配 | 3GPP baseband |
| C5 | 4 | 64 | 2 | 16-bit | 超窄带 | IoT/NB-IoT |
| C6 | 3 | 8 | 1 | 16-bit | 插值 (DUC) | AD9361 |

---

## 2.06 IIR 直接型 II (二阶节)

**公式**:
```
Direct Form II:
w[n] = x[n] - a₁·w[n-1] - a₂·w[n-2]
y[n] = b₀·w[n] + b₁·w[n-1] + b₂·w[n-2]
```

**来源**:
- Proakis & Manolakis, Ch. 9.3
- ITU-T G.729 §3.12 (LP 合成滤波器: 10阶 IIR, 5个二阶节级联)
- 3GPP TS 26.190 (AMR-WB: LP synthesis filter)

**参数配置**:
| Config | order | sections | coeff_width | 应用 | 来源 |
|--------|-------|----------|-------------|------|------|
| C1 | 2 (single SOS) | 1 | 16-bit | 基本二阶滤波 | 通用 |
| C2 | 10 (5×SOS) | 5 | 16-bit | LP 合成 (G.729) | ITU-T G.729 §3.12 |
| C3 | 10 (5×SOS) | 5 | 16-bit | AMR-WB LP 合成 | 3GPP TS 26.190 |
| C4 | 4 (2×SOS) | 2 | 16-bit | DC 去除 + 陷波 | SDR 前端 |

---

## 2.07 半带滤波器 (Halfband)

**公式**:
```
H(z) = Σ h[k]·z^{-k}, 其中 h[k]=0 for even k≠0 (中间系数为零)
奇数阶、偶对称、每隔一个系数为零
实际运算量约 N/4 个乘法
```

**来源**:
- Vaidyanathan 1993, Ch. 5.2
- Xilinx PG149 (halfband optimization)
- 广泛用于 2× 抽取/插值级联链 (SDR 中的多级采样率转换)

**参数配置**:
| Config | N (taps) | effective_mults | input_width | 应用 |
|--------|----------|----------------|-------------|------|
| C1 | 11 | 3 | 16-bit | 2× 抽取 (第一级) |
| C2 | 23 | 6 | 16-bit | 高抑制半带 |
| C3 | 43 | 11 | 18-bit | 高性能 SDR |
| C4 | 63 | 16 | 16-bit | 极高抑制 |

---

## 2.08 升余弦 / 根升余弦 (RRC) 脉冲成形

**公式**:
```
RRC 频域: 
H(f) = {
  √T,                                          0 ≤ |f| ≤ (1-α)/(2T)
  √(T/2·(1+cos(πT/α·(|f|-(1-α)/(2T))))),     (1-α)/(2T) < |f| ≤ (1+α)/(2T)
  0,                                           |f| > (1+α)/(2T)
}

RRC 时域:
h(t) = (sin(π(1-α)t/T) + 4αt/T·cos(π(1+α)t/T)) / (πt/T·(1-(4αt/T)²))
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §5.2.1 (5G NR: 不直接指定 RRC, 但上行 DFT-s-OFDM + 下行 CP-OFDM 的发射链路需要脉冲成形)
- 3GPP TS 25.104 (WCDMA: RRC α=0.22)
- DVB-S2 ETSI EN 302 307 §4.2 (α = 0.35, 0.25, 0.20)
- Proakis, Ch. 9.5

**参数配置**:
| Config | α (roll-off) | span (symbols) | samples/symbol | taps | 应用 | 来源 |
|--------|-------------|----------------|---------------|------|------|------|
| C1 | 0.22 | 6 | 4 | 49 | WCDMA | 3GPP TS 25.104 |
| C2 | 0.35 | 8 | 4 | 65 | DVB-S2 | EN 302 307 §4.2 |
| C3 | 0.25 | 8 | 4 | 65 | DVB-S2 opt | EN 302 307 §4.2 |
| C4 | 0.20 | 10 | 4 | 81 | DVB-S2 opt | EN 302 307 §4.2 |
| C5 | 0.50 | 6 | 2 | 25 | 低复杂度 | 通用 |
| C6 | 0.35 | 12 | 8 | 193 | 高精度 | SDR |

---

## 2.09 自适应 FIR — LMS 算法

**公式**:
```
y[n] = w^H[n] · x[n]                    (滤波)
e[n] = d[n] - y[n]                       (误差)
w[n+1] = w[n] + μ · e[n] · x*[n]        (系数更新)
```

**来源**:
- Widrow & Hoff, "Adaptive Switching Circuits," IRE WESCON Conv. Rec., 1960
- Haykin, S., "Adaptive Filter Theory," 5th Ed, Prentice Hall, Ch. 5
- 3GPP TS 36.101 §8.7 (接收机参考灵敏度, 隐含需要自适应干扰消除)
- 应用: 回波消除、干扰消除、信道均衡

**参数配置**:
| Config | N (taps) | data_width | μ (step size) | 应用 | 来源 |
|--------|----------|------------|--------------|------|------|
| C1 | 16 | 16-bit | 2^{-10} | 均衡器 | Haykin Ch.5 |
| C2 | 32 | 16-bit | 2^{-12} | 回波消除 | ITU-T G.168 |
| C3 | 64 | 16-bit | 2^{-8} | 干扰消除 | SDR |
| C4 | 128 | 16-bit | 2^{-14} | 长回波 | ITU-T G.168 §5.1 |

---

## 2.10 自适应 FIR — NLMS 算法

**公式**:
```
w[n+1] = w[n] + μ/(||x[n]||² + δ) · e[n] · x*[n]
δ: 正则化常数防止除零
```

**来源**:
- Haykin, Ch. 5.7
- ITU-T G.168 §5 (回波消除器性能要求, NLMS 为典型实现)

**参数配置**:
| Config | N | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 32 | 16-bit | 回波消除 | ITU-T G.168 |
| C2 | 64 | 16-bit | 长回波 | ITU-T G.168 |
| C3 | 128 | 16-bit | 电话线回波 | ITU-T G.168 |

---

## 2.11 匹配滤波器 (Matched Filter)

**公式**:
```
h_MF[k] = s*[N-1-k]   (接收信号的时间反转共轭)
y[n] = Σ_{k=0}^{N-1} h_MF[k] · r[n-k]
等价于: y[n] = r[n] ⊛ s*[-n] = 相关运算
```

**来源**:
- 3GPP TS 38.211 §7.4.3.1 (PSS 检测: 3 个 ZC 序列的匹配滤波)
- 3GPP TS 38.211 §7.4.3.2 (SSS 检测: 336 个候选序列)
- IEEE 802.11-2020 §17.3.3 (Short Training Field 检测)
- Proakis, Ch. 4.3 (最优接收)

**参数配置**:
| Config | N | num_templates | data_width | 应用 | 来源 |
|--------|---|--------------|-------------|------|------|
| C1 | 127 | 3 | 16-bit | 5G NR PSS | 3GPP TS 38.211 §7.4.3.1 |
| C2 | 127 | 336 | 16-bit | 5G NR SSS | 3GPP TS 38.211 §7.4.3.2 |
| C3 | 16 | 1 | 16-bit | 802.11 STS | IEEE 802.11-2020 §17.3.3 |
| C4 | 64 | 1 | 16-bit | 802.11 LTS | IEEE 802.11-2020 §17.3.3 |
| C5 | 62 | 3 | 16-bit | LTE PSS (ZC) | 3GPP TS 36.211 §6.11.1.1 |
| C6 | 839 | 64 | 16-bit | LTE PRACH (长序列) | 3GPP TS 36.211 §5.7.2 |

---

## 2.12 滑动平均 (Moving Average)

**公式**:
```
y[n] = (1/M) · Σ_{k=0}^{M-1} x[n-k]
当 M=2^p: 除法变移位, 无乘法器实现
```

**来源**:
- 3GPP TS 38.215 §5.1.1 (SS-RSRP 测量: 功率平均)
- 3GPP TS 38.133 §9.1 (L1/L3 filtering)

**参数配置**:
| Config | M | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 4 | 16-bit | 短期平均 | 3GPP TS 38.133 |
| C2 | 8 | 16-bit | RSRP 平滑 | 3GPP TS 38.215 |
| C3 | 16 | 16-bit | 噪声估计 | 通用 |
| C4 | 64 | 16-bit | 长期平均 | 通用 |

---

## 2.13 数字上变频 (DUC) 滤波链

**公式**:
```
完整 DUC 链:
x → [↑L₁] → [HB1] → [↑L₂] → [HB2] → [↑L₃] → [CIC interp] → [NCO mixer] → y
每级: 插值 + 低通滤波
```

**来源**:
- AD9361 Reference Design Manual §4 (Digital Up Conversion chain)
- Xilinx UG984 "Zynq SoC DUC/DDC" Application Note
- SDR 发射链路标准架构

**参数配置**:
| Config | stages | total_interp | output_rate | 应用 | 来源 |
|--------|--------|-------------|-------------|------|------|
| C1 | HB×2 + CIC | ×8 | 30.72 MHz | LTE 20MHz | AD9361 |
| C2 | HB×2 + CIC | ×16 | 61.44 MHz | LTE 20MHz (2×) | AD9361 |
| C3 | HB×3 + CIC | ×32 | 122.88 MHz | 5G NR 100MHz | SDR typical |
| C4 | HB×1 + CIC | ×4 | 20 MHz | WiFi 20MHz | SDR |

---

## 2.14 数字下变频 (DDC) 滤波链

**公式**:
```
完整 DDC 链:
y → [NCO mixer] → [CIC decim] → [HB1 ↓2] → [HB2 ↓2] → [FIR ↓M] → x
```

**来源**:
- AD9361 Reference Design Manual §4 (Digital Down Conversion chain)
- Xilinx XAPP1madhya "DDC Implementation"
- SDR 接收链路标准架构

**参数配置**: 同 2.13（方向相反）

---

## 2.15 直流去除 (DC Offset Removal)

**公式**:
```
方法1 (一阶 IIR HPF):
y[n] = x[n] - x[n-1] + α·y[n-1], α ≈ 1 - 2^{-k}

方法2 (减均值):
dc_est[n] = dc_est[n-1] + (x[n] - dc_est[n-1]) >> k
y[n] = x[n] - dc_est[n]
```

**来源**:
- 3GPP TS 38.104 §6.5.3 (基站接收机 DC offset 容忍要求)
- IEEE 802.11-2020 §17.3.2.5 (Direct conversion receiver DC removal)
- GNU Radio: dc_blocker

**参数配置**:
| Config | method | α/k | data_width | 应用 | 来源 |
|--------|--------|-----|------------|------|------|
| C1 | IIR HPF | α=1-2^{-8} | 16-bit | SDR 接收机 | 通用 |
| C2 | subtract mean | k=10 | 16-bit | 慢衰落补偿 | 通用 |
| C3 | IIR HPF | α=1-2^{-6} | 12-bit | 低延迟 | WiFi |

---

## 2.16 窗函数生成

**公式**:
```
Hanning: w[n] = 0.5 · (1 - cos(2πn/(N-1)))
Hamming: w[n] = 0.54 - 0.46 · cos(2πn/(N-1))
Blackman: w[n] = 0.42 - 0.5·cos(2πn/(N-1)) + 0.08·cos(4πn/(N-1))
Kaiser: w[n] = I₀(β·√(1-(2n/N-1)²)) / I₀(β)
```

**来源**:
- Harris, F.J., "On the Use of Windows for Harmonic Analysis," Proc. IEEE, 1978
- IEEE 802.11-2020 §19.3.7 (STBC windowing)
- 3GPP TS 38.211 §5.3.1 (CP-OFDM windowing for spectral containment)

**参数配置**:
| Config | window_type | N | output_width | 应用 | 来源 |
|--------|------------|---|-------------|------|------|
| C1 | Hanning | 64 | 16-bit | WiFi OFDM | 802.11 |
| C2 | Hamming | 256 | 16-bit | 频谱分析 | 通用 |
| C3 | Blackman | 1024 | 18-bit | 高抑制 | SDR |
| C4 | Kaiser (β=6) | 128 | 16-bit | 自适应旁瓣 | Harris 1978 |

---

## 2.17 中值滤波器 (Median Filter)

**公式**:
```
y[n] = median(x[n], x[n-1], ..., x[n-M+1])
需要: 排序网络 (M 个输入)
```

**来源**:
- 应用: 脉冲噪声去除 (电力线通信 PLC, ITU-T G.9960/G.hn)
- 应用: RSSI 测量去毛刺

**参数配置**:
| Config | M | data_width | 应用 |
|--------|---|------------|------|
| C1 | 3 | 16-bit | 基本去毛刺 |
| C2 | 5 | 16-bit | 脉冲噪声 |
| C3 | 7 | 12-bit | PLC |

---

## 2.18 全通滤波器 (用于均衡/延迟)

**公式**:
```
一阶: H(z) = (a + z⁻¹) / (1 + a·z⁻¹)
二阶: H(z) = (a₂ + a₁·z⁻¹ + z⁻²) / (1 + a₁·z⁻¹ + a₂·z⁻²)
|H(e^{jω})| = 1 ∀ω, 仅改变相位
```

**来源**:
- Regalia, P.A., "IIR Filterbank Design Based on Allpass Subfilters," IEEE Trans. Circuits Syst., 1990
- 应用: 半带 IIR 滤波器 (高效采样率转换)
- 应用: 群延迟均衡

**参数配置**:
| Config | order | sections | coeff_width | 应用 |
|--------|-------|----------|-------------|------|
| C1 | 1 | 1 | 16-bit | 相位调整 |
| C2 | 5 (allpass halfband) | 2+3 | 16-bit | 半带滤波 |

---

## 2.19 Farrow 结构 (可变分数延迟)

**公式**:
```
y[n] = Σ_{m=0}^{M} C_m(z) · d^m
C_m(z): 子滤波器 (FIR), d: 分数延迟 (0 ≤ d < 1)

等价于在 d 点进行多项式插值:
y = Σ_{m=0}^{M} c_m · d^m, 其中 c_m = C_m(z) applied to x
```

**来源**:
- Farrow, C.W., "A Continuously Variable Digital Delay Element," IEEE ISCAS, 1988
- Vesma & Saramäki, "Optimization of Polynomial-Based Interpolation Filters," IEEE Trans. SP, 1996
- 应用: 符号定时恢复中的插值器 (3GPP/DVB 接收机)
- 应用: 采样率转换 (任意比率)

**参数配置**:
| Config | M (poly order) | sub_filter_len | data_width | 应用 | 来源 |
|--------|---------------|---------------|------------|------|------|
| C1 | 3 (cubic) | 4 | 16-bit | 符号定时 | DVB-S2 接收机 |
| C2 | 3 (cubic) | 6 | 16-bit | 高精度定时 | 5G NR |
| C3 | 1 (linear) | 2 | 16-bit | 低复杂度 | 低功耗接收 |
| C4 | 5 (5th order) | 6 | 18-bit | 高精度 | SDR |

---

## 2.20 级联半带滤波器链

**公式**:
```
总抽取/插值比: 2^S (S 个半带级联)
每级: HB_s, 各级可不同阶数

总群延迟 = Σ delay_s
第一级抑制要求最低, 最后一级最高 (因为相对带宽不同)
```

**来源**:
- Crochiere & Rabiner, "Multirate Digital Signal Processing," Prentice Hall, 1983
- AD9361 Data Sheet §4 (3 级半带 + CIC 的抽取链)
- Xilinx XAPP1300 "Multi-stage decimation filter"

**参数配置**:
| Config | stages | total_decim | taps_per_stage | 应用 | 来源 |
|--------|--------|-------------|---------------|------|------|
| C1 | 2 | ×4 | [11, 23] | SDR DDC | AD9361 |
| C2 | 3 | ×8 | [11, 23, 43] | SDR DDC | AD9361 |
| C3 | 4 | ×16 | [11, 11, 23, 43] | 宽带 SDR | SDR |
