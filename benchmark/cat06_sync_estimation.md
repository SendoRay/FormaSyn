# Category 6: 同步与估计 (18 kernels, 100+ configurations)

---

## 6.01 NCO (数控振荡器)

**公式**:
```
相位累加器: φ[n+1] = (φ[n] + Δφ) mod 2π
输出: I[n] = cos(φ[n]), Q[n] = sin(φ[n])
频率分辨率: Δf = f_clk / 2^W (W: 累加器位宽)
实现: 相位累加 + sin/cos 查表(ROM) 或 CORDIC
```

**来源**:
- Xilinx PG141 "DDS Compiler" Product Guide (Direct Digital Synthesis)
- Analog Devices AD9361 Reference Manual §3 (Digital tuning NCO)
- 所有数字接收机/发射机的载波生成/频偏补偿

**参数配置**:
| Config | phase_acc_width | output_width | LUT_depth | method | 应用 | 来源 |
|--------|----------------|-------------|-----------|--------|------|------|
| C1 | 32 | 16-bit | 1024 | LUT | 5G NR NCO | AD9361 |
| C2 | 24 | 12-bit | 256 | LUT | LTE NCO | 通用 |
| C3 | 32 | 16-bit | — | CORDIC (16 iter) | 高精度 SDR | Xilinx PG141 |
| C4 | 48 | 18-bit | 4096 | LUT + interp | 高 SFDR 要求 | AD9361 |

---

## 6.02 载波频偏估计 — Schmidl & Cox

**公式**:
```
利用训练符号的重复结构:
P[d] = Σ_{m=0}^{L-1} r*[d+m] · r[d+m+L]   (half-symbol 相关)
R[d] = Σ_{m=0}^{L-1} |r[d+m+L]|²            (能量归一化)
M[d] = |P[d]|² / R[d]²                        (归一化度量)

频偏估计: Δf = angle(P[d_opt]) / (2π·L·T_s)
```

**来源**:
- Schmidl & Cox, "Robust Frequency and Timing Synchronization for OFDM," IEEE Trans. Comm., 1997
- IEEE 802.11-2020 §17.3.3 (Short Training Field 用于检测和粗频偏)
- 3GPP TS 38.211 §7.4.3.1 (PSS 用于初始频偏估计)

**参数配置**:
| Config | L (half length) | data_width | 应用 | 来源 |
|--------|----------------|------------|------|------|
| C1 | 32 | 16-bit | WiFi STF (64-pt FFT, 16-sample repeat) | IEEE 802.11-2020 §17.3.3 |
| C2 | 128 | 16-bit | LTE PSS 基于 | 3GPP TS 36.211 |
| C3 | 64 | 16-bit | 通用 OFDM | Schmidl 1997 |

---

## 6.03 载波频偏估计 — Moose 算法

**公式**:
```
利用两个相同训练符号:
Δf = angle(Σ_{k=0}^{N-1} Y₂*[k]·Y₁[k]) / (2π·T_s·N)
Y₁, Y₂: 两个连续相同训练符号的 FFT

估计范围: |Δf| < 1/(2·T_s·N) = SCS/2
```

**来源**:
- Moose, P.H., "A Technique for Orthogonal Frequency Division Multiplexing Frequency Offset Correction," IEEE Trans. Comm., 1994

**参数配置**:
| Config | N | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 64 | 16-bit | WiFi | IEEE 802.11 impl |
| C2 | 256 | 16-bit | WiFi 80MHz | IEEE 802.11ac |
| C3 | 2048 | 16-bit | LTE | 3GPP baseband |

---

## 6.04 符号定时恢复 — Gardner TED

**公式**:
```
定时误差检测 (TED):
e[n] = Re{y[n] · (y*[n-1] - y*[n+1])}
(on-time sample 乘以 early-late 差)

环路滤波器 (二阶):
v[n] = v[n-1] + K₂·e[n]
w[n] = K₁·e[n] + v[n]

NCO 控制: μ[n+1] = μ[n] + w[n]
插值器: Farrow 结构根据 μ 做分数延迟
```

**来源**:
- Gardner, F.M., "A BPSK/QPSK Timing-Error Detector for Sampled Receivers," IEEE Trans. Comm., 1986
- 广泛用于 DVB-S2、CCSDS 接收机的符号定时

**参数配置**:
| Config | samples_per_symbol | data_width | loop_BW | 应用 | 来源 |
|--------|-------------------|------------|---------|------|------|
| C1 | 2 | 16-bit | 0.01 | DVB-S2 | EN 302 307 impl |
| C2 | 4 | 16-bit | 0.005 | CCSDS | CCSDS 413.0 |
| C3 | 2 | 12-bit | 0.02 | 通用 | Gardner 1986 |

---

## 6.05 符号定时恢复 — Mueller & Müller TED

**公式**:
```
e[n] = Re{â[n-1]·y[n] - â[n]·y[n-1]}
â[n]: 判决符号
y[n]: 接收样本 (1 sample/symbol, 不需要过采样)
```

**来源**:
- Mueller & Müller, "Timing Recovery in Digital Synchronous Data Receivers," IEEE Trans. Comm., 1976
- 适用于 1 sample/symbol 系统 (vs Gardner 需要 2 samples/symbol)

**参数配置**:
| Config | data_width | loop_BW | modulation | 应用 |
|--------|------------|---------|-----------|------|
| C1 | 16-bit | 0.01 | QPSK | DVB-S2 |
| C2 | 16-bit | 0.005 | 16QAM | 高阶调制 |

---

## 6.06 PLL — Costas 环 (载波恢复)

**公式**:
```
相位误差:
BPSK:  e = Im(y · sign(Re(y))*)  = Re(y)·Im(y) 的符号
QPSK:  e = Re(y)·sign(Im(y)) - Im(y)·sign(Re(y))

环路滤波 + NCO 同 6.04
```

**来源**:
- Costas, J.P., "Synchronous Communications," Proc. IRE, 1956
- Mengali & D'Andrea, "Synchronization Techniques for Digital Receivers," Plenum, 1997
- DVB-S2 接收机标准实现

**参数配置**:
| Config | modulation | data_width | loop_BW | 应用 | 来源 |
|--------|-----------|------------|---------|------|------|
| C1 | BPSK | 16-bit | 0.01 | CCSDS | CCSDS 413.0 |
| C2 | QPSK | 16-bit | 0.005 | DVB-S2 | EN 302 307 |
| C3 | 8PSK | 16-bit | 0.002 | DVB-S2 高阶 | EN 302 307 |

---

## 6.07 频域信道估计 — LS (Least Squares)

**公式**:
```
H_LS[k] = Y[k] / X[k]   (在导频子载波上)
X[k]: 已知导频符号, Y[k]: 接收到的频域值

实现: 复数除法 (per subcarrier)
```

**来源**:
- 3GPP TS 38.211 §7.4.1.1 (DMRS 位置, 接收端用于信道估计)
- IEEE 802.11-2020 §19.3.10 (Channel estimation using LTF)
- van de Beek et al., "On Channel Estimation in OFDM Systems," IEEE VTC 1995

**参数配置**:
| Config | N_pilots | spacing | data_width | 应用 | 来源 |
|--------|---------|---------|------------|------|------|
| C1 | 4 | 16 subcarriers | 16-bit | WiFi 802.11a | IEEE 802.11-2020 |
| C2 | 52 | per subcarrier | 16-bit | WiFi LTF (全频) | IEEE 802.11-2020 |
| C3 | 6 per RB | comb-2 | 16-bit | 5G NR DMRS Type1 | 3GPP TS 38.211 |
| C4 | 4 per RB | comb-2 | 16-bit | LTE CRS | 3GPP TS 36.211 |

---

## 6.08 信道插值 (导频→数据子载波)

**公式**:
```
线性插值:
H[k] = H[k₁] + (k-k₁)/(k₂-k₁) · (H[k₂]-H[k₁])

DFT-based 插值:
h = IFFT(H_pilots, zero-padded)
H_all = FFT(h, N_full)
```

**来源**:
- 3GPP TS 38.211 (隐含: DMRS 到数据 RE 的插值)
- IEEE 802.11-2020 (导频到数据的插值)
- Hsieh & Wei, "Channel Estimation for OFDM Systems Based on Comb-Type Pilot Arrangement," IEEE Trans. CE, 1998

**参数配置**:
| Config | method | pilot_spacing | data_width | 应用 | 来源 |
|--------|--------|--------------|------------|------|------|
| C1 | linear | 2 (comb-2) | 16-bit | 5G NR DMRS | 3GPP |
| C2 | linear | 6 (comb-6) | 16-bit | LTE CRS | 3GPP TS 36.211 |
| C3 | DFT-based | 4 | 16-bit | WiFi | IEEE 802.11 |

---

## 6.09 噪声方差估计

**公式**:
```
方法1 (空子载波): σ² = (1/N_null) · Σ_{k∈null} |Y[k]|²
方法2 (导频残差): σ² = (1/N_p) · Σ_{k∈pilots} |Y[k] - H[k]·X[k]|²
方法3 (数据辅助): σ² = (1/N_d) · Σ_{k∈data} |Y[k] - H[k]·X̂[k]|²
```

**来源**:
- 3GPP TS 38.214 §5.2.2.1 (CQI 报告需要 SINR 估计)
- 用于软解映射中的 LLR 缩放

**参数配置**:
| Config | method | N_samples | data_width | 应用 | 来源 |
|--------|--------|-----------|------------|------|------|
| C1 | null subcarrier | 11 (WiFi) | 16-bit | WiFi | IEEE 802.11-2020 |
| C2 | pilot residual | per RB | 16-bit | 5G NR | 3GPP TS 38.214 |
| C3 | data-aided | per symbol | 16-bit | 迭代接收 | 研究 |

---

## 6.10 AGC (自动增益控制)

**公式**:
```
功率检测: P[n] = (1/N) · Σ |x[n-k]|²  或 IIR: P[n] = α·|x[n]|² + (1-α)·P[n-1]
误差: e[n] = P_target - P[n]
增益更新: g[n+1] = g[n] + μ · e[n]  或 g = √(P_target/P[n])
输出: y[n] = g[n] · x[n]
```

**来源**:
- 3GPP TS 38.104 §7.3 (接收机动态范围要求, 需要 AGC)
- AD9361 Reference Manual §5 (Digital gain control in receive path)
- IEEE 802.11-2020 §17.3.8.4 (AGC for packet detection)

**参数配置**:
| Config | method | attack_time | hold_time | data_width | 应用 | 来源 |
|--------|--------|-------------|-----------|------------|------|------|
| C1 | log-domain | fast | — | 16-bit | WiFi 包检测 | IEEE 802.11 |
| C2 | IIR power | slow | 10 symbols | 16-bit | 5G NR | 3GPP TS 38.104 |
| C3 | dual-loop | fast+slow | — | 16-bit | SDR | AD9361 |

---

## 6.11 帧检测 / 包检测

**公式**:
```
WiFi: 利用 STF 的自相关
M[d] = |P[d]|² / R[d]²
P[d] = Σ_{m=0}^{L-1} r*[d+m]·r[d+m+L]
R[d] = Σ_{m=0}^{L-1} |r[d+m+L]|²

检测: M[d] > threshold → 检测到信号
```

**来源**:
- IEEE 802.11-2020 §17.3.3 (Packet detection using STF auto-correlation)
- 3GPP TS 38.213 §4.1 (SSB detection for initial access)

**参数配置**:
| Config | L | threshold | data_width | 应用 | 来源 |
|--------|---|-----------|------------|------|------|
| C1 | 16 | 0.5 | 16-bit | WiFi 802.11a STF | IEEE 802.11-2020 |
| C2 | 64 | 0.7 | 16-bit | WiFi 802.11n | IEEE 802.11-2020 |
| C3 | 128 | 0.6 | 16-bit | 5G PSS 检测 | 3GPP TS 38.213 |

---

## 6.12 PSS/SSS 检测 (5G NR 初始同步)

**公式**:
```
PSS (m-sequence based):
d_PSS(n) = 1 - 2·x(m), m = (n + 43·N_ID2) mod 127
x(i+7) = (x(i+4) + x(i)) mod 2

SSS (Gold sequence):
d_SSS(n) = [1-2·x₀((n+m₀) mod 127)] · [1-2·x₁((n+m₁) mod 127)]
m₀ = 15·⌊N_ID1/112⌋ + 5·N_ID2
m₁ = N_ID1 mod 112

Cell ID: N_cell_ID = 3·N_ID1 + N_ID2, N_ID2 ∈ {0,1,2}, N_ID1 ∈ {0,...,335}
总共 1008 个 cell ID
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §7.4.2.2 (PSS: 3 sequences, length 127)
- 3GPP TS 38.211 V17.3.0 §7.4.2.3 (SSS: 336 sequences per N_ID2, length 127)

**参数配置**:
| Config | task | N_ID2 | search_space | data_width | 来源 |
|--------|------|-------|-------------|------------|------|
| C1 | PSS detect | {0,1,2} | 3 hypotheses | 16-bit | 3GPP TS 38.211 §7.4.2.2 |
| C2 | SSS detect | known | 336 hypotheses | 16-bit | 3GPP TS 38.211 §7.4.2.3 |
| C3 | Joint PSS+SSS | all | 1008 hypotheses | 16-bit | 3GPP TS 38.211 |

---

## 6.13 CFO 补偿 (逐样本频率校正)

**公式**:
```
y[n] = x[n] · e^{-j2πΔf·n·T_s}
实现: NCO 生成 e^{-j·phase[n]}, 复数乘法

phase[n] = phase[n-1] + 2πΔf·T_s
```

**来源**:
- 3GPP TS 38.211 §5.3.1 (OFDM 接收需要 CFO 补偿)
- IEEE 802.11-2020 §17.3.10.3 (Fine frequency offset correction)

**参数配置**:
| Config | sample_rate | max_CFO | phase_width | data_width | 应用 | 来源 |
|--------|------------|---------|-------------|------------|------|------|
| C1 | 30.72 MHz | ±7.5 kHz | 32-bit | 16-bit | LTE | 3GPP TS 36.211 |
| C2 | 122.88 MHz | ±15 kHz | 32-bit | 16-bit | 5G NR | 3GPP TS 38.211 |
| C3 | 20 MHz | ±312.5 kHz | 24-bit | 16-bit | WiFi | IEEE 802.11 |

---

## 6.14 RSSI / RSRP / RSRQ 测量

**公式**:
```
RSSI = Σ_k |Y[k]|² (全带宽接收功率)
RSRP = (1/N_RS) · Σ_{k∈RS} |Y[k]|² (参考信号功率)
RSRQ = N_RB · RSRP / RSSI
SINR = RSRP / (RSSI/N_RB - RSRP)

All in dB: RSRP_dBm = 10·log₁₀(RSRP) + 30
```

**来源**:
- 3GPP TS 38.215 V17.3.0 §5.1.1 (SS-RSRP definition)
- 3GPP TS 38.215 §5.1.3 (SS-RSRQ definition)
- 3GPP TS 38.133 §9.1.2 (RSRP measurement accuracy requirements)

**参数配置**:
| Config | measurement | N_RS | avg_window | data_width | 来源 |
|--------|------------|------|-----------|------------|------|
| C1 | SS-RSRP | 127 (SSS) | 4 symbols | 16-bit | 3GPP TS 38.215 §5.1.1 |
| C2 | CSI-RSRP | per RB | 1 slot | 16-bit | 3GPP TS 38.215 §5.1.2 |
| C3 | RSSI | full BW | 1 ms | 16-bit | 3GPP TS 38.215 |
| C4 | RSRQ | computed | — | 16-bit | 3GPP TS 38.215 §5.1.3 |

---

## 6.15 SFO 估计 (采样频率偏移)

**公式**:
```
利用导频相位斜率:
SFO 导致子载波相位随时间线性变化:
Δφ[k,l] = 2π·k·δ/N + 2π·l·ε·N_s/N

δ: SFO (ppm)
ε: 残余 CFO

估计: δ = slope of (phase_pilot vs subcarrier_index) across OFDM symbols
```

**来源**:
- IEEE 802.11-2020 §19.3.10.7 (Sampling clock offset tracking via pilot phase rotation)
- Speth et al., "Optimum Receiver Design for OFDM-Based Broadband Transmission," IEEE Trans. Comm., 2001

**参数配置**:
| Config | N_pilots | method | data_width | 应用 | 来源 |
|--------|---------|--------|------------|------|------|
| C1 | 4 | linear regression | 16-bit | WiFi 802.11a | IEEE 802.11-2020 |
| C2 | 8 | linear regression | 16-bit | WiFi 802.11ac | IEEE 802.11-2020 |

---

## 6.16 PRACH 检测 (5G NR / LTE)

**公式**:
```
频域相关检测:
Y = FFT(y_rx)
X = FFT(x_ref)  (参考 ZC 序列)
Z = IFFT(Y · X*)
峰值检测: |Z[d]|² > threshold → 检测到, delay=d

5G NR long sequence: N_ZC=839, 频域相关
5G NR short sequence: N_ZC=139, 时域相关
```

**来源**:
- 3GPP TS 38.211 §6.3.3.1 (PRACH preamble format)
- 3GPP TS 38.213 §8.1 (PRACH procedure)
- 3GPP TS 36.211 §5.7 (LTE PRACH)

**参数配置**:
| Config | N_ZC | N_FFT | format | 应用 | 来源 |
|--------|------|-------|--------|------|------|
| C1 | 839 | 1024 | Format 0 (long) | LTE | 3GPP TS 36.211 §5.7.2 |
| C2 | 839 | 2048 | Format 0 | 5G NR | 3GPP TS 38.211 §6.3.3.1 |
| C3 | 139 | 256 | Format A1 (short) | 5G NR | 3GPP TS 38.211 §6.3.3.1 |
| C4 | 139 | 512 | Format B4 | 5G NR | 3GPP TS 38.211 |

---

## 6.17 相位跟踪 — CPE 估计 (Common Phase Error)

**公式**:
```
CPE = angle(Σ_{k∈pilots} Y[k] · (H[k]·X[k])*)
    = angle(Σ_{k∈pilots} H_est*[k] · Y[k] · X*[k])

补偿: Y_comp[k] = Y[k] · e^{-j·CPE}
```

**来源**:
- 3GPP TS 38.211 §7.4.1.4 (PTRS: Phase Tracking Reference Signal)
- IEEE 802.11ax §27.3.12 (Phase noise compensation)
- Wu & Bar-Ness, "OFDM Systems in the Presence of Phase Noise," IEEE Trans. BC, 2004

**参数配置**:
| Config | N_PTRS | 应用 | 来源 |
|--------|--------|------|------|
| C1 | 4 per symbol | WiFi 802.11ax | IEEE 802.11ax |
| C2 | variable | 5G NR PTRS | 3GPP TS 38.211 §7.4.1.4 |

---

## 6.18 时间提前估计 (Timing Advance)

**公式**:
```
PRACH 检测中:
TA = d_peak · T_s
d_peak: PRACH 相关峰值位置

反馈: TA command = N_TA · T_c
N_TA ∈ {0, 1, ..., 3846} (5G NR)
T_c = 1/(Δf_max · N_f) = 1/(480000·4096) ≈ 0.509 ns
```

**来源**:
- 3GPP TS 38.213 §4.2 (Timing Advance procedure)
- 3GPP TS 38.211 §4.3.1 (Basic time unit T_c)
- 3GPP TS 36.213 §4.2.3 (LTE Timing Advance)

**参数配置**:
| Config | TA_range | resolution | 应用 | 来源 |
|--------|---------|-----------|------|------|
| C1 | 0~3846 | T_c | 5G NR | 3GPP TS 38.213 §4.2 |
| C2 | 0~1282 | 16·T_s | LTE | 3GPP TS 36.213 §4.2.3 |
