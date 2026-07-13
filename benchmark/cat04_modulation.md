# Category 4: 调制解调 (18 kernels, 110+ configurations)

---

## 4.01 BPSK/QPSK/16QAM/64QAM/256QAM 星座映射

**公式**:
```
BPSK:  s = (1-2b₀) · 1/√2
QPSK:  s = (1-2b₀ + j(1-2b₁)) · 1/√2
16QAM: s = ((1-2b₀)(2-(1-2b₁)) + j(1-2b₂)(2-(1-2b₃))) · 1/√10
64QAM: s = ((1-2b₀)(4-(1-2b₁)(2-(1-2b₂))) + j...) · 1/√42
256QAM: 类推 · 1/√170

Gray mapping: 相邻星座点只差 1 bit
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §5.1 Table 5.1-1 to 5.1-4 (5G NR 调制定义)
- 3GPP TS 36.211 §7.1 Table 7.1-1 to 7.1-4 (LTE 调制定义)
- IEEE 802.11-2020 §17.3.5.8 (WiFi 调制映射)
- DVB-S2 ETSI EN 302 307 §5.4.1 (DVB-S2 星座映射)

**参数配置**:
| Config | modulation | bits/symbol | normalization | 应用 | 来源 |
|--------|-----------|-------------|--------------|------|------|
| C1 | BPSK | 1 | 1/√2 | NR PBCH/PDCCH | 3GPP TS 38.211 §5.1 |
| C2 | QPSK | 2 | 1/√2 | NR/LTE 通用 | 3GPP TS 38.211 Table 5.1-1 |
| C3 | 16-QAM | 4 | 1/√10 | NR/LTE | 3GPP TS 38.211 Table 5.1-2 |
| C4 | 64-QAM | 6 | 1/√42 | NR/LTE | 3GPP TS 38.211 Table 5.1-3 |
| C5 | 256-QAM | 8 | 1/√170 | NR/LTE/WiFi ax | 3GPP TS 38.211 Table 5.1-4 |
| C6 | 1024-QAM | 10 | 1/√682 | WiFi 802.11ax/be | IEEE 802.11ax §27.3.10 |
| C7 | 8PSK | 3 | 1 | DVB-S2 | EN 302 307 §5.4.1 |
| C8 | 16APSK | 4 | — | DVB-S2 | EN 302 307 §5.4.1 |
| C9 | 32APSK | 5 | — | DVB-S2 | EN 302 307 §5.4.1 |
| C10 | π/4-DQPSK | 2 | 1 | TETRA | ETSI EN 300 392 §5.2 |

---

## 4.02 QAM 软解映射 (LLR 计算)

**公式**:
```
精确 LLR:
L(b_i) = ln(P(b_i=1|y) / P(b_i=0|y))
       = ln(Σ_{s∈S₁ⁱ} exp(-|y-Hs|²/σ²)) - ln(Σ_{s∈S₀ⁱ} exp(-|y-Hs|²/σ²))

Max-log 近似:
L(b_i) ≈ (1/σ²) · (min_{s∈S₀ⁱ} |y-Hs|² - min_{s∈S₁ⁱ} |y-Hs|²)

QPSK 简化: L(b₀) = 2·y_I/σ², L(b₁) = 2·y_Q/σ²
16QAM 简化: L(b₀) = 2·y_I/σ², L(b₁) = (2-|y_I|)·2/σ², ...
```

**来源**:
- 3GPP TS 38.211 §5.1 (隐含: 接收端需要软解映射)
- Tosato & Bisaglia, "Simplified Soft-Output Demapper for Binary Interleaved COFDM with Application to HIPERLAN/2," IEEE ICC 2002
- IEEE 802.11-2020 (WiFi 接收端需要 LLR)

**参数配置**:
| Config | modulation | method | data_width | σ² 处理 | 应用 | 来源 |
|--------|-----------|--------|------------|--------|------|------|
| C1 | QPSK | exact (closed-form) | 16-bit | multiply | 5G NR | 3GPP |
| C2 | 16-QAM | max-log approx | 16-bit | shift | 5G NR | 3GPP |
| C3 | 64-QAM | max-log approx | 16-bit | shift | 5G NR | 3GPP |
| C4 | 256-QAM | max-log approx | 16-bit | multiply | 5G NR | 3GPP |
| C5 | QPSK | exact | 12-bit | shift | LTE | 3GPP TS 36.211 |
| C6 | 16-QAM | piecewise linear | 12-bit | shift | WiFi | IEEE 802.11 |
| C7 | 64-QAM | max-log | 16-bit | multiply | WiFi | IEEE 802.11 |
| C8 | 1024-QAM | max-log | 16-bit | multiply | WiFi 7 | IEEE 802.11be |
| C9 | 8PSK | exact | 16-bit | multiply | DVB-S2 | EN 302 307 |

---

## 4.03 OFDM 调制器 (IFFT + CP)

**公式**:
```
时域信号:
x[n] = (1/√N) · Σ_{k=0}^{N-1} X[k] · e^{j2πkn/N}, n=0,...,N-1

加 CP:
x_cp = [x[N-N_cp],...,x[N-1], x[0],...,x[N-1]]

5G NR CP 长度:
Normal CP: N_cp = 144·κ + 16·κ (first symbol), 144·κ (others)
κ = T_s/T_c = 64 (for μ=0, SCS=15kHz)
Extended CP: N_cp = 512·κ (only for μ=2, SCS=60kHz)
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §5.3.1 (OFDM 信号生成)
- 3GPP TS 38.211 Table 5.3.1-1 (支持的 FFT sizes)
- 3GPP TS 38.211 Table 5.3.1-2 (Normal CP 长度)
- 3GPP TS 36.211 §6.12 (LTE OFDM)
- IEEE 802.11-2020 §17.3.5.9 (WiFi OFDM modulation)

**参数配置**:
| Config | N_FFT | CP_len | SCS | BW | 应用 | 来源 |
|--------|-------|--------|-----|-----|------|------|
| C1 | 64 | 16 | — | 20MHz | WiFi 802.11a | IEEE 802.11-2020 §17.3.5.9 |
| C2 | 256 | 64 | — | 80MHz | WiFi 802.11ac | IEEE 802.11-2020 |
| C3 | 1024 | 80 | — | 160MHz | WiFi 802.11ax | IEEE 802.11ax |
| C4 | 512 | 36 | 15kHz | 5MHz | LTE | 3GPP TS 36.211 |
| C5 | 1024 | 72 | 15kHz | 10MHz | LTE | 3GPP TS 36.211 |
| C6 | 2048 | 144 | 15kHz | 20MHz | LTE | 3GPP TS 36.211 |
| C7 | 4096 | 288 | 30kHz | 100MHz | 5G NR | 3GPP TS 38.211 §5.3.1 |
| C8 | 2048 | 144 | 60kHz | 100MHz | 5G NR FR2 | 3GPP TS 38.211 |
| C9 | 4096 | 288 | 15kHz | 50MHz | 5G NR | 3GPP TS 38.211 |

---

## 4.04 OFDM 解调器 (CP去除 + FFT)

**公式**: 4.03 的逆过程
**来源**: 同 4.03
**参数配置**: 同 4.03

---

## 4.05 子载波映射 / 资源映射

**公式**:
```
5G NR 资源映射:
for each RE (k, l) in allocated RBs:
  if (k, l) is DMRS position: map DMRS symbol
  elif (k, l) is CSI-RS position: map CSI-RS
  elif (k, l) is PTRS position: map PTRS
  else: map data symbol

每个 RB = 12 subcarriers × 14 OFDM symbols (normal CP)
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §7.3.1 (PDSCH resource mapping)
- 3GPP TS 38.211 §7.4.1 (DMRS positions)
- 3GPP TS 38.211 §7.4.1.5 (PTRS positions)

**参数配置**:
| Config | BWP_size (RBs) | num_symbols | DMRS_config | 应用 | 来源 |
|--------|---------------|-------------|-------------|------|------|
| C1 | 25 (5MHz@15kHz) | 14 | Type 1, single | 5G NR small BW | 3GPP TS 38.211 |
| C2 | 106 (20MHz@15kHz) | 14 | Type 1, single | 5G NR typical | 3GPP TS 38.211 |
| C3 | 273 (100MHz@30kHz) | 14 | Type 1, double | 5G NR max BW | 3GPP TS 38.211 |
| C4 | 52 (20MHz@15kHz) | 14 | — | LTE | 3GPP TS 36.211 |

---

## 4.06 DFT-s-OFDM (SC-FDMA) 调制器

**公式**:
```
发射流程: 数据 → DFT(M) → 子载波映射 → IFFT(N) → CP → 发射
M: DFT precoding 大小 = 分配的子载波数
N: IFFT 大小

SC-FDMA 的 PAPR 低于 OFDM (单载波特性)
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §5.3 (DFT-s-OFDM, 用于 NR 上行 PUSCH when transform precoding enabled)
- 3GPP TS 36.211 §5.6 (LTE 上行始终使用 SC-FDMA)
- Myung, Lim, Goodman, "Single Carrier FDMA for Uplink Wireless Transmission," IEEE VTM, 2006

**参数配置**:
| Config | M (DFT) | N (IFFT) | 应用 | 来源 |
|--------|---------|----------|------|------|
| C1 | 12 | 512 | LTE 1 RB | 3GPP TS 36.211 |
| C2 | 72 | 512 | LTE 6 RB | 3GPP TS 36.211 |
| C3 | 300 | 512 | LTE 25 RB (5MHz) | 3GPP TS 36.211 |
| C4 | 1200 | 2048 | LTE 100 RB (20MHz) | 3GPP TS 36.211 |
| C5 | 12 | 4096 | NR 1 RB | 3GPP TS 38.211 §5.3 |
| C6 | 144 | 4096 | NR 12 RB | 3GPP TS 38.211 |

---

## 4.07 GMSK 调制 (GSM/DECT)

**公式**:
```
相位: φ(t) = Σ_k b_k · ∫_{-∞}^{t} g(τ-kT) dτ
g(t) = (1/(2T)) · Q(2πBT·(t-T/2)/√(ln2)) - Q(2πBT·(t+T/2)/√(ln2))

BT = 0.3 (GSM), BT = 0.5 (DECT)
实现: 预计算相位增量查表 → 相位累加 → sin/cos 查表
```

**来源**:
- 3GPP TS 45.004 §2 (GSM/GPRS: GMSK BT=0.3)
- ETSI EN 300 175-2 (DECT: GMSK BT=0.5)
- Murota & Hirade, "GMSK Modulation for Digital Mobile Radio Telephony," IEEE Trans. Comm., 1981

**参数配置**:
| Config | BT | samples_per_symbol | span | 应用 | 来源 |
|--------|----|--------------------|------|------|------|
| C1 | 0.3 | 4 | 3 symbols | GSM | 3GPP TS 45.004 |
| C2 | 0.5 | 4 | 3 symbols | DECT | EN 300 175-2 |
| C3 | 0.3 | 8 | 4 symbols | GSM 高精度 | 3GPP TS 45.004 |

---

## 4.08 差分编码/解码

**公式**:
```
编码: d[n] = d[n-1] ⊕ b[n]  (DBPSK)
       d[n] = (d[n-1] + m[n]) mod M  (DMPSK)

解码: b[n] = d[n] ⊕ d[n-1]  (DBPSK)
非相干解调: y[n] = r[n] · r*[n-1]  (无需载波恢复)
```

**来源**:
- IEEE 802.11-2020 §15.2.3 (DBPSK 1Mbps mode)
- IEEE 802.11-2020 §15.2.3 (DQPSK 2Mbps mode)
- ETSI EN 300 392 §5.2 (TETRA: π/4-DQPSK)

**参数配置**:
| Config | modulation | 应用 | 来源 |
|--------|-----------|------|------|
| C1 | DBPSK | WiFi 1Mbps | IEEE 802.11-2020 §15.2.3 |
| C2 | DQPSK | WiFi 2Mbps | IEEE 802.11-2020 §15.2.3 |
| C3 | π/4-DQPSK | TETRA | ETSI EN 300 392 |

---

## 4.09 导频插入

**公式**:
```
WiFi 802.11a: 64点 FFT 中, k={-21,-7,7,21} 为导频位置
P = [1,1,1,-1] × polarity_sequence[symbol_index]

5G NR DMRS: Type 1: 每隔 1 个子载波 (comb-2)
            Type 2: 每 6 个子载波占 2 个 (groups of 2)
```

**来源**:
- IEEE 802.11-2020 §17.3.5.9 (Pilot subcarrier positions and polarities)
- 3GPP TS 38.211 §7.4.1.1 (DMRS for PDSCH)
- 3GPP TS 36.211 §6.10.1 (LTE CRS positions)

**参数配置**:
| Config | N_FFT | pilot_positions | pilot_type | 应用 | 来源 |
|--------|-------|----------------|-----------|------|------|
| C1 | 64 | {-21,-7,7,21} | fixed BPSK | WiFi 802.11a | IEEE 802.11-2020 |
| C2 | 256 | {-103,-75,-39,-11,11,39,75,103} | fixed BPSK | WiFi 802.11ac | IEEE 802.11-2020 |
| C3 | 12×RB | Type 1 comb-2 | QPSK (Gold seq) | 5G NR DMRS | 3GPP TS 38.211 |
| C4 | 12×RB | CRS pattern | QPSK | LTE CRS | 3GPP TS 36.211 §6.10.1 |

---

## 4.10 PAPR 降低 — 削峰 (Clipping & Filtering)

**公式**:
```
Clipping:
x_clip[n] = {
  x[n],                       |x[n]| ≤ A
  A · e^{j·angle(x[n])},      |x[n]| > A
}

Clipping Ratio (CR) = A / σ_x (通常 1.2~2.0)
削峰后需要滤波器去除带外频谱再生
```

**来源**:
- 3GPP TS 38.104 §6.5.2 (基站 EVM 要求, 隐含需要 PAPR 控制)
- Li & Cimini, "Effects of Clipping and Filtering on the Performance of OFDM," IEEE Comm. Lett., 1998
- 工业界广泛使用的 CFR (Crest Factor Reduction) 方法

**参数配置**:
| Config | N_FFT | CR | filter_taps | 应用 | 来源 |
|--------|-------|----|-------------|------|------|
| C1 | 2048 | 1.4 | 64 | LTE DL | 3GPP TS 36.104 |
| C2 | 4096 | 1.4 | 128 | 5G NR DL | 3GPP TS 38.104 |
| C3 | 64 | 1.6 | 32 | WiFi | IEEE 802.11 |

---

## 4.11 频域加窗 (Windowed-OFDM)

**公式**:
```
时域加窗:
x_w[n] = w[n] · x_cp[n]
w[n]: raised-cosine 窗 (在 CP/后缀区域渐变)

目的: 降低 OFDM 带外泄漏 (ACLR 改善)
5G NR 用 W-OFDM 或 F-OFDM
```

**来源**:
- 3GPP TS 38.211 §5.3.1 (允许实现相关的 windowing)
- Muschallik, C., "Improving an OFDM Reception Using an Adaptive Nyquist Windowing," IEEE Trans. CE, 1996

**参数配置**:
| Config | N_FFT | window_len | rolloff_samples | 应用 | 来源 |
|--------|-------|-----------|----------------|------|------|
| C1 | 2048 | 2048+144+32 | 32 | LTE | 3GPP impl |
| C2 | 4096 | 4096+288+64 | 64 | 5G NR | 3GPP impl |

---

## 4.12 FBMC-OQAM 调制

**公式**:
```
x(t) = Σ_m Σ_k a_{m,k} · g_{m,k}(t)
g_{m,k}(t) = p(t-mT/2) · e^{j2πk(t-mT/2)/T} · e^{jφ_{m,k}}
φ_{m,k} = π(m+k)/2

实现: PPN-FFT (Polyphase Network + FFT)
x[n] = IFFT{ Σ_p c_p[n-pN] · f[n-pN] }
```

**来源**:
- Bellanger, M., "FBMC Physical Layer: A Primer," PHYDYAS Project, 2010
- 5G 候选波形研究 (最终未被 NR 采纳, 但学术价值高)
- Farhang-Boroujeny, "OFDM Versus Filter Bank Multicarrier," IEEE SP Magazine, 2011

**参数配置**:
| Config | N (subcarriers) | K (overlapping) | prototype_filter | 应用 | 来源 |
|--------|----------------|-----------------|-----------------|------|------|
| C1 | 64 | 4 | PHYDYAS | 研究 | Bellanger 2010 |
| C2 | 256 | 4 | PHYDYAS | 研究 | Bellanger 2010 |
| C3 | 1024 | 4 | PHYDYAS | 5G 候选 | Farhang-Boroujeny 2011 |

---

## 4.13 Zadoff-Chu 序列生成

**公式**:
```
x_u[n] = e^{-jπun(n+1)/N_ZC}, N_ZC 为奇数
u: root index (1 ≤ u ≤ N_ZC - 1)
循环移位: x_{u,v}[n] = x_u[(n+C_v) mod N_ZC]
```

**来源**:
- 3GPP TS 38.211 §6.3.2 (5G NR PRACH preamble: N_ZC=139 or 839)
- 3GPP TS 36.211 §5.7.2 (LTE PRACH: N_ZC=839)
- 3GPP TS 38.211 §6.4.1.4 (SRS: based on ZC sequences)
- Chu, D., "Polyphase Codes with Good Periodic Correlation Properties," IEEE Trans. IT, 1972

**参数配置**:
| Config | N_ZC | u_range | 应用 | 来源 |
|--------|------|---------|------|------|
| C1 | 139 | 1-138 | 5G NR PRACH (short) | 3GPP TS 38.211 §6.3.2 |
| C2 | 839 | 1-838 | 5G NR PRACH (long) / LTE | 3GPP TS 38.211 / 36.211 |
| C3 | 31 | 1-30 | DMRS base seq (small N) | 3GPP TS 38.211 §6.4.1.4 |

---

## 4.14 星座旋转 (Phase de-rotation)

**公式**:
```
y[n] = x[n] · e^{-jθ[n]}
θ[n]: 来自相位跟踪环路 (CPE: common phase error)

实现: 复数乘法 with CORDIC/LUT generated sin/cos
```

**来源**:
- 3GPP TS 38.211 §5.3.1 (OFDM 相位补偿)
- IEEE 802.11-2020 §19.3.10.8 (Phase tracking per OFDM symbol)
- 所有 OFDM 接收机必备

**参数配置**:
| Config | data_width | angle_resolution | method | 应用 | 来源 |
|--------|------------|-----------------|--------|------|------|
| C1 | 16-bit | 12-bit | CORDIC | 5G NR | 3GPP |
| C2 | 16-bit | 10-bit | LUT | WiFi | IEEE 802.11 |
| C3 | 12-bit | 8-bit | LUT | LTE | 3GPP TS 36.211 |

---

## 4.15 OFDM 符号时域加窗/重叠

**公式**:
```
重叠加窗 (Overlap-and-add):
y[n] = w_tail[n] · x_prev[N+N_cp-W_len+n] + w_head[n] · x_curr[n]
for n = 0,...,W_len-1

w_head + w_tail = 1 (raised cosine complementary pair)
```

**来源**:
- 3GPP R1-163558 (W-OFDM 提案)
- IEEE 802.11-2020 §17.3.2.5 (Transmit spectral mask, achieved via windowing)

**参数配置**: 同 4.11

---

## 4.16 MSK 调制 (Minimum Shift Keying)

**公式**:
```
s(t) = cos(2πf_c·t + φ(t))
φ(t) = φ(0) + Σ_k b_k · (π/(2T)) · ∫ rect((τ-kT)/T) dτ

调制指数 h = 0.5 (最小频移)
相位连续, 恒包络

实现: 相位累加器 + 半正弦脉冲成形
```

**来源**:
- de Buda, R., "Coherent Demodulation of Frequency-Shift Keying with Low Deviation Ratio," IEEE Trans. Comm., 1972
- 应用: AIS (Automatic Identification System, ITU-R M.1371)
- 应用: 卫星通信 (恒包络特性)

**参数配置**:
| Config | data_rate | samples/symbol | data_width | 应用 | 来源 |
|--------|-----------|---------------|------------|------|------|
| C1 | 9600 bps | 4 | 16-bit | AIS | ITU-R M.1371 |
| C2 | 270.833 kbps | 4 | 16-bit | GSM (GMSK=filtered MSK) | 3GPP TS 45.004 |

---

## 4.17 CPM 通用调制器 (连续相位调制)

**公式**:
```
s(t) = √(2E_s/T) · cos(2πf_c·t + φ(t))
φ(t) = 2πh · Σ_k a_k · q(t-kT)
q(t) = ∫_{-∞}^{t} g(τ) dτ, g(t): 频率脉冲

特例: h=0.5, g=rect → MSK
      h=0.5, g=Gaussian → GMSK
```

**来源**:
- Anderson, Aulin, Sundberg, "Digital Phase Modulation," Plenum, 1986
- CCSDS 413.0-G-3 (CPM for deep space, h=1/2, 3RC pulse)
- MIL-STD-188-181B (军事 CPM)

**参数配置**:
| Config | h | pulse_shape | L (pulse span) | M | 应用 | 来源 |
|--------|---|-----------|------|---|------|------|
| C1 | 1/2 | 1RC | 2 | 2 | CPFSK | 通用 |
| C2 | 1/2 | 3RC | 3 | 2 | 深空 | CCSDS 413.0 |
| C3 | 1/3 | 1REC | 1 | 4 | 4-ary CPFSK | MIL-STD-188-181 |

---

## 4.18 Bit Interleaved Coded Modulation (BICM) 交织器

**公式**:
```
编码比特 → 比特交织 → 星座映射
π_BICM: 按 QAM order 分组交织

5G NR: LDPC 编码后的 rate matching 输出直接映射 (交织隐含在 LDPC 结构中)
WiFi: 编码后有显式的 block interleaver
```

**来源**:
- Caire, Taricco, Biglieri, "Bit-Interleaved Coded Modulation," IEEE Trans. IT, 1998
- IEEE 802.11-2020 §17.3.5.7 (Block interleaver for BCC)
- 3GPP TS 38.212 §5.4.2.2 (Bit interleaving for LDPC)

**参数配置**:
| Config | N_CBPS | N_BPSC | N_COL | 应用 | 来源 |
|--------|--------|--------|-------|------|------|
| C1 | 48 | 1 (BPSK) | 16 | WiFi 802.11a | IEEE 802.11-2020 §17.3.5.7 |
| C2 | 192 | 4 (16QAM) | 16 | WiFi 802.11a | IEEE 802.11-2020 |
| C3 | 288 | 6 (64QAM) | 16 | WiFi 802.11a | IEEE 802.11-2020 |
| C4 | — | — | — | 5G NR (LDPC内置) | 3GPP TS 38.212 §5.4.2.2 |
