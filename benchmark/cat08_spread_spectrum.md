# Category 8: 扩频与多址 (10 kernels)

---

## 8.01 LFSR (线性反馈移位寄存器)

**公式**: `s[n] = Σ cᵢ·s[n-i] (mod 2)`, 周期 2^m-1

**来源**:
- 3GPP TS 38.211 §5.2.1 (Gold sequence: 两个 degree-31 LFSR)
- IEEE 802.11-2020 §17.3.5.4 (Scrambler: degree-7 LFSR, x⁷+x⁴+1)
- Golomb, S., "Shift Register Sequences," Holden-Day, 1967

**参数配置**:
| Config | m | polynomial | 应用 | 来源 |
|--------|---|-----------|------|------|
| C1 | 31 | x³¹+x³+1 | 5G NR Gold seq (x₁) | 3GPP TS 38.211 §5.2.1 |
| C2 | 31 | x³¹+x³+x²+x+1 | 5G NR Gold seq (x₂) | 3GPP TS 38.211 §5.2.1 |
| C3 | 7 | x⁷+x⁴+1 | WiFi scrambler | IEEE 802.11-2020 §17.3.5.4 |
| C4 | 23 | x²³+x⁵+1 | GPS C/A code (G1) | IS-GPS-200 |
| C5 | 23 | x²³+x³+x²+x+1 | GPS C/A code (G2) | IS-GPS-200 |
| C6 | 18 | x¹⁸+x⁷+1 | DVB scrambler | EN 302 307 §5.2.2 |

---

## 8.02 Gold 序列生成

**公式**:
```
g[n] = s₁[n] ⊕ s₂[n + offset]
s₁, s₂: 两个 m-序列
offset: 决定具体序列编号
Gold family size: 2^m + 1
```

**来源**:
- Gold, R., "Optimal Binary Sequences," IEEE Trans. IT, 1967
- 3GPP TS 38.211 §5.2.1 (c_init 决定 x₂ 的初始状态)
- IS-2000 (CDMA2000: Gold codes for PN spreading)

**参数配置**:
| Config | m | init_method | 应用 | 来源 |
|--------|---|-----------|------|------|
| C1 | 31 | c_init = f(N_ID, n_RNTI, slot) | 5G NR 加扰 | 3GPP TS 38.211 §5.2.1 |
| C2 | 31 | c_init = f(cell_id, slot) | LTE CRS | 3GPP TS 36.211 §7.2 |
| C3 | 10 | preset taps | GPS C/A | IS-GPS-200 |

---

## 8.03 扩频 (DS-SS)

**公式**:
```
y[n] = d[⌊n/SF⌋] · c[n]
SF: spreading factor
c[n]: PN 序列 (码片)
```

**来源**:
- 3GPP TS 25.213 §4 (WCDMA spreading: SF=4~512)
- IS-95/CDMA2000 (SF=64 for voice)

**参数配置**:
| Config | SF | chip_rate | 应用 | 来源 |
|--------|-----|----------|------|------|
| C1 | 4 | 3.84 Mcps | WCDMA HSDPA | 3GPP TS 25.213 |
| C2 | 64 | 3.84 Mcps | WCDMA voice | 3GPP TS 25.213 |
| C3 | 256 | 3.84 Mcps | WCDMA control | 3GPP TS 25.213 |
| C4 | 128 | 3.84 Mcps | WCDMA RACH | 3GPP TS 25.213 |
| C5 | 64 | 1.2288 Mcps | CDMA2000 voice | IS-2000 |

---

## 8.04 解扩相关器 (Despreader)

**公式**: `R[n] = Σ_{k=0}^{SF-1} y[n·SF+k] · c[k]`

**来源**: 同 8.03（接收端逆操作）

**参数配置**: 同 8.03

---

## 8.05 Rake 接收机

**公式**:
```
z = Σ_{l=0}^{L-1} α_l* · y[n - τ_l]
α_l: 第 l 径的信道系数
τ_l: 第 l 径的延迟 (以码片为单位)
L: finger 数
```

**来源**:
- Price & Green, "A Communication Technique for Multipath Channels," Proc. IRE, 1958
- 3GPP TS 25.101 §8 (WCDMA 接收机需要 Rake)
- Proakis, Ch. 14.5

**参数配置**:
| Config | L (fingers) | SF | data_width | 应用 | 来源 |
|--------|------------|-----|------------|------|------|
| C1 | 4 | 64 | 16-bit | WCDMA voice | 3GPP TS 25.101 |
| C2 | 6 | 4 | 16-bit | WCDMA HSDPA | 3GPP TS 25.101 |
| C3 | 3 | 64 | 16-bit | CDMA2000 | IS-2000 |

---

## 8.06 OVSF 码生成 (正交可变扩频因子)

**公式**:
```
C_{SF,k}: 码树
C₁₀ = [1]
C₂₀ = [1 1], C₂₁ = [1 -1]
C_{2n,2k} = [C_{n,k}  C_{n,k}]
C_{2n,2k+1} = [C_{n,k}  -C_{n,k}]
```

**来源**:
- 3GPP TS 25.213 §4.3.1 (WCDMA channelization codes)
- Adachi, Sawahashi, Okawa, "Tree-Structured Generation of OVSF Codes," IEEE Comm. Lett., 1997

**参数配置**:
| Config | SF_max | 应用 | 来源 |
|--------|--------|------|------|
| C1 | 512 | WCDMA DL | 3GPP TS 25.213 |
| C2 | 256 | WCDMA UL | 3GPP TS 25.213 |

---

## 8.07 GPS C/A 码生成

**公式**:
```
G1: x¹⁰+x³+1 (所有 PRN 共用)
G2: x¹⁰+x⁹+x⁸+x⁶+x³+x²+1 (相位选择决定 PRN)
C/A[n] = G1[n] ⊕ G2[n + delay(PRN)]
码长: 1023 chips, 码率: 1.023 Mcps
```

**来源**:
- IS-GPS-200 Rev N (GPS Interface Control Document)
- IS-GPS-200 Table 3-I (PRN code phase assignments)

**参数配置**:
| Config | PRN | G2_delay | 应用 | 来源 |
|--------|-----|---------|------|------|
| C1 | 1 | 5 | GPS SV1 | IS-GPS-200 Table 3-I |
| C2 | 1-32 | per PRN | GPS all SVs | IS-GPS-200 |

---

## 8.08 GPS C/A 码捕获 (并行搜索)

**公式**:
```
频域并行相关:
R = IFFT(FFT(y) · FFT(c_ref)*)
峰值搜索: max|R[d]|² → 码延迟 = d
频率搜索: 遍历 Δf ∈ [-5kHz, +5kHz], step=500Hz
```

**来源**:
- IS-GPS-200 (C/A code acquisition)
- van Diggelen, "A-GPS," Artech House, 2009
- Tsui, J.B., "Fundamentals of GPS Receivers," Wiley, 2005

**参数配置**:
| Config | N_FFT | freq_bins | 应用 | 来源 |
|--------|-------|----------|------|------|
| C1 | 2048 | 21 (±5kHz@500Hz) | 冷启动 | IS-GPS-200 |
| C2 | 4096 | 41 (±10kHz@500Hz) | 高动态 | IS-GPS-200 |

---

## 8.09 跳频序列生成

**公式**:
```
f_hop[n] = f_base + h[n] · Δf
h[n]: 伪随机跳频序列

5G NR PUCCH frequency hopping:
n_hop determined by c_init and slot number
```

**来源**:
- 3GPP TS 38.211 §6.3.2.2 (PUCCH frequency hopping)
- IEEE 802.15.1 (Bluetooth: 79-channel hopping, 1600 hops/sec)
- MIL-STD-188-141C (军事跳频通信)

**参数配置**:
| Config | channels | hop_rate | 应用 | 来源 |
|--------|---------|---------|------|------|
| C1 | 79 | 1600/s | Bluetooth | IEEE 802.15.1 |
| C2 | variable | per slot | 5G NR PUCCH | 3GPP TS 38.211 |

---

## 8.10 Scrambling (加扰/解扰)

**公式**:
```
y[n] = x[n] ⊕ c[n]  (bit-level, for coded bits)
或 y[n] = x[n] · (1-2c[n])  (symbol-level, ×{+1,-1})
c[n]: Gold 序列
```

**来源**:
- 3GPP TS 38.211 §7.3.1.1 (PDSCH scrambling)
- 3GPP TS 38.211 §6.3.1.1 (PUSCH scrambling)
- IEEE 802.11-2020 §17.3.5.4 (Data scrambling with LFSR)

**参数配置**:
| Config | level | c_init | 应用 | 来源 |
|--------|-------|-------|------|------|
| C1 | bit | f(n_RNTI, n_ID) | 5G NR PDSCH | 3GPP TS 38.211 §7.3.1.1 |
| C2 | bit | f(n_RNTI, n_ID) | 5G NR PUSCH | 3GPP TS 38.211 §6.3.1.1 |
| C3 | bit | LFSR state | WiFi | IEEE 802.11-2020 §17.3.5.4 |
