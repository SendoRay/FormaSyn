# Category 7: 均衡与 MIMO 检测 (15 kernels, 80+ configurations)

---

## 7.01 频域 ZF 均衡 (One-tap)

**公式**: `X[k] = Y[k] / H[k]` (复数除法, per subcarrier)

**来源**:
- 3GPP TS 38.214 §5.2.2.1 (PDSCH 接收需要均衡)
- IEEE 802.11-2020 §19.3.10 (OFDM one-tap equalizer)
- Proakis, Ch. 12.4

**参数配置**:
| Config | N_subcarriers | data_width | div_method | 应用 | 来源 |
|--------|-------------|------------|-----------|------|------|
| C1 | 52 | 16-bit | CORDIC | WiFi 802.11a | IEEE 802.11-2020 |
| C2 | 234 | 16-bit | Newton-Raphson | WiFi 802.11ac 80MHz | IEEE 802.11-2020 |
| C3 | 3276 | 16-bit | Newton-Raphson | 5G NR 273RB | 3GPP TS 38.214 |
| C4 | 1200 | 16-bit | CORDIC | LTE 100RB | 3GPP TS 36.211 |

---

## 7.02 频域 MMSE 均衡

**公式**:
```
X[k] = H*[k] · Y[k] / (|H[k]|² + σ²)
     = H*[k]·Y[k] / (H[k]·H*[k] + N₀)
```

**来源**:
- 3GPP TS 38.214 (MMSE 为典型接收机实现)
- Proakis, Ch. 12.5

**参数配置**:
| Config | N_subcarriers | data_width | 应用 | 来源 |
|--------|-------------|------------|------|------|
| C1 | 52 | 16-bit | WiFi | IEEE 802.11 |
| C2 | 3276 | 16-bit | 5G NR | 3GPP TS 38.214 |
| C3 | 1200 | 16-bit | LTE | 3GPP TS 36.211 |

---

## 7.03 2×2 MIMO ZF 检测

**公式**:
```
y = Hx + n, H ∈ C^(2×2)
x_ZF = (H^H · H)^{-1} · H^H · y = H^{-1} · y (方阵)

2×2 矩阵求逆:
H^{-1} = (1/det(H)) · [h₂₂ -h₁₂; -h₂₁ h₁₁]
det(H) = h₁₁·h₂₂ - h₁₂·h₂₁
```

**来源**:
- 3GPP TS 38.214 §5.2.2.1 (MIMO reception)
- IEEE 802.11-2020 §19.3.11 (MIMO decoding)
- Paulraj, Nabar, Gore, "Introduction to Space-Time Wireless Communications," Cambridge, 2003

**参数配置**:
| Config | antennas | data_width | per-subcarrier | 应用 | 来源 |
|--------|---------|------------|---------------|------|------|
| C1 | 2Tx×2Rx | 16-bit | Yes (OFDM) | 5G NR 2-layer | 3GPP TS 38.214 |
| C2 | 2Tx×2Rx | 16-bit | Yes | WiFi 802.11n 2×2 | IEEE 802.11-2020 |
| C3 | 2Tx×2Rx | 16-bit | Yes | LTE 2-layer | 3GPP TS 36.214 |

---

## 7.04 4×4 MIMO ZF 检测

**公式**:
```
x_ZF = (H^H·H)^{-1} · H^H · y
4×4 矩阵求逆: Gauss-Jordan 或 QR 分解
QR: H = Q·R, x = R^{-1}·Q^H·y (回代)
```

**来源**:
- 3GPP TS 38.214 (4-layer MIMO)
- IEEE 802.11ac/ax (4×4 MIMO)

**参数配置**:
| Config | antennas | method | data_width | 应用 | 来源 |
|--------|---------|--------|------------|------|------|
| C1 | 4Tx×4Rx | QR (Givens) | 16-bit | 5G NR 4-layer | 3GPP TS 38.214 |
| C2 | 4Tx×4Rx | QR (Givens) | 16-bit | WiFi 802.11ac | IEEE 802.11ac |
| C3 | 4Tx×4Rx | direct inverse | 18-bit | 高精度 | 研究 |

---

## 7.05 MIMO MMSE 检测

**公式**:
```
x_MMSE = (H^H·H + σ²·I)^{-1} · H^H · y
正则化项 σ²·I 改善病态矩阵条件数
```

**来源**:
- 3GPP TS 38.214 (MMSE-IRC: MMSE with Interference Rejection Combining)
- Tse & Viswanath, "Fundamentals of Wireless Communications," Cambridge, Ch. 8

**参数配置**:
| Config | antennas | method | 应用 | 来源 |
|--------|---------|--------|------|------|
| C1 | 2×2 | direct | 5G NR | 3GPP TS 38.214 |
| C2 | 4×4 | QR | 5G NR | 3GPP TS 38.214 |
| C3 | 2×2 | direct | WiFi | IEEE 802.11 |
| C4 | 8×4 | QR | Massive MIMO | 3GPP TS 38.214 |

---

## 7.06 QR 分解 (Givens 旋转实现)

**公式**:
```
对 M×N 矩阵 H (M≥N):
for j = 1 to N:
  for i = M down to j+1:
    [c s] = givens_rotation(H[j,j], H[i,j])
    H = G(i,j,θ)^H · H   (消去 H[i,j])
    y = G(i,j,θ)^H · y   (同步变换 y)

Givens rotation: CORDIC 向量模式实现
结果: H = Q·R, 用 R 和 Q^H·y 做回代
```

**来源**:
- Golub & Van Loan, Ch. 5.2 (Givens QR)
- Wubben et al., "MMSE Extension of V-BLAST Based on Sorted QR Decomposition," IEEE VTC 2003
- 3GPP MIMO 检测的高效实现方法

**参数配置**:
| Config | M×N | data_width | CORDIC_iters | 应用 | 来源 |
|--------|-----|------------|-------------|------|------|
| C1 | 2×2 | 16-bit | 12 | 2-layer MIMO | 3GPP |
| C2 | 4×4 | 16-bit | 14 | 4-layer MIMO | 3GPP |
| C3 | 4×2 | 16-bit | 12 | 4Rx 2-layer | 3GPP |
| C4 | 8×4 | 16-bit | 16 | Massive MIMO (简化) | 3GPP |

---

## 7.07 回代 (Back Substitution)

**公式**:
```
Rx = Q^H·y = ỹ
上三角回代:
x[N] = ỹ[N] / R[N,N]
x[i] = (ỹ[i] - Σ_{j=i+1}^{N} R[i,j]·x[j]) / R[i,i], i=N-1,...,1
```

**来源**: 与 7.06 配合使用

**参数配置**: 同 7.06

---

## 7.08 MIMO SIC (逐层干扰消除)

**公式**:
```
Sorted QR Decomposition (SQRD):
1. 对 H 列排序 (选最强列先检测)
2. QR 分解
3. 回代 + 硬判决
4. 从 y 中减去已检测层的干扰: y = y - h_k·x̂_k
5. 对剩余层重复
```

**来源**:
- Wubben et al., "Efficient Algorithm for Detecting Layered Space-Time Codes," IEEE Comm. Lett., 2001
- Foschini, "Layered Space-Time Architecture for Wireless Communication," Bell Labs Tech. J., 1996 (V-BLAST)
- 3GPP TS 38.214 (MIMO 接收机选项之一)

**参数配置**:
| Config | layers | method | 应用 | 来源 |
|--------|--------|--------|------|------|
| C1 | 2 | SQRD + SIC | 5G NR 2-layer | 3GPP |
| C2 | 4 | SQRD + SIC | 5G NR 4-layer | 3GPP |
| C3 | 4 | SQRD + SIC | WiFi 802.11ac | IEEE 802.11ac |

---

## 7.09 时域 LMS 均衡器

**公式**: 同 2.09，但用于信道均衡

**来源**:
- Haykin, Ch. 13 (Adaptive equalization)
- 应用: 单载波系统 (GSM, DVB-C)

**参数配置**:
| Config | N_taps | modulation | 应用 | 来源 |
|--------|--------|-----------|------|------|
| C1 | 5 | GMSK | GSM | 3GPP TS 45.005 |
| C2 | 16 | 64QAM | DVB-C | EN 300 429 |

---

## 7.10 判决反馈均衡 (DFE)

**公式**:
```
y[n] = Σ_{k=0}^{N_f-1} w_f[k]·r[n-k] - Σ_{k=1}^{N_b} w_b[k]·â[n-k]
w_f: 前馈滤波器 (FIR)
w_b: 反馈滤波器 (用判决符号)
â[n]: 硬判决符号
```

**来源**:
- Austin, M.E., "Decision-Feedback Equalization for Digital Communication over Dispersive Channels," MIT Lincoln Lab, 1967
- Proakis, Ch. 12.4.3
- 应用: 单载波宽带系统

**参数配置**:
| Config | N_f | N_b | data_width | 应用 |
|--------|-----|-----|------------|------|
| C1 | 16 | 8 | 16-bit | DVB-C 均衡 |
| C2 | 32 | 16 | 16-bit | 宽带 |

---

## 7.11 MIMO 预编码 (Codebook-based)

**公式**:
```
x = W · s
W: 预编码矩阵 (从 codebook 中选择)
s: 层映射后的符号向量

5G NR Type I codebook (2 port):
W = [1; e^{jπn/2}] / √2, n ∈ {0,1,2,3}
```

**来源**:
- 3GPP TS 38.214 V17.3.0 §5.2.2.2.1 (Type I Single-Panel Codebook)
- 3GPP TS 38.214 Table 5.2.2.2.1-1 to 5.2.2.2.1-12

**参数配置**:
| Config | ports | layers | codebook_size | 应用 | 来源 |
|--------|-------|--------|-------------|------|------|
| C1 | 2 | 1 | 4 entries | 5G NR 2-port 1-layer | 3GPP TS 38.214 Table 5.2.2.2.1-1 |
| C2 | 2 | 2 | 2 entries | 5G NR 2-port 2-layer | 3GPP TS 38.214 Table 5.2.2.2.1-2 |
| C3 | 4 | 1 | 16 entries | 5G NR 4-port 1-layer | 3GPP TS 38.214 Table 5.2.2.2.1-3 |
| C4 | 4 | 2 | 16 entries | 5G NR 4-port 2-layer | 3GPP TS 38.214 Table 5.2.2.2.1-4 |

---

## 7.12 IRC (Interference Rejection Combining)

**公式**:
```
w_IRC = R_nn^{-1} · h
R_nn = Σ_{i∈interferers} h_i·h_i^H + σ²·I  (干扰+噪声协方差矩阵)

MMSE-IRC: x̂ = w_IRC^H · y
```

**来源**:
- 3GPP TS 38.214 §5.2.2.1 (Advanced receiver: MMSE-IRC)
- 3GPP TR 36.829 (LTE MMSE-IRC receiver study)

**参数配置**:
| Config | Rx_antennas | data_width | 应用 | 来源 |
|--------|------------|------------|------|------|
| C1 | 2 | 16-bit | 5G NR baseline | 3GPP TS 38.214 |
| C2 | 4 | 16-bit | 5G NR advanced | 3GPP TS 38.214 |
| C3 | 8 | 16-bit | Massive MIMO | 3GPP |

---

## 7.13 Cholesky 分解

**公式**:
```
A = L · L^H, A 正定 Hermitian
L[i,i] = √(A[i,i] - Σ_{k=1}^{i-1} |L[i,k]|²)
L[i,j] = (A[i,j] - Σ_{k=1}^{j-1} L[i,k]·L*[j,k]) / L[j,j], i>j
```

**来源**:
- Golub & Van Loan, Ch. 4.2
- 应用: MMSE 检测中 (H^H·H+σ²I) 的分解
- 应用: LMMSE 信道估计中 R_HH 的分解

**参数配置**:
| Config | N | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 2 | 16-bit | 2×2 MIMO MMSE | 3GPP |
| C2 | 4 | 16-bit | 4×4 MIMO MMSE | 3GPP |
| C3 | 8 | 16-bit | 8Rx LMMSE CE | 3GPP |

---

## 7.14 MRC (最大比合并)

**公式**:
```
x̂ = h^H · y / ||h||²
等价于: x̂ = Σ_{r=1}^{N_R} h_r* · y_r / Σ_{r=1}^{N_R} |h_r|²
```

**来源**:
- Brennan, D.G., "Linear Diversity Combining Techniques," Proc. IRE, 1959
- 3GPP (SIMO: 单天线发, 多天线收时的最优合并)

**参数配置**:
| Config | N_Rx | data_width | 应用 | 来源 |
|--------|------|------------|------|------|
| C1 | 2 | 16-bit | 2Rx 分集 | 3GPP |
| C2 | 4 | 16-bit | 4Rx 分集 | 3GPP |
| C3 | 8 | 16-bit | 8Rx MRC | 3GPP |

---

## 7.15 Alamouti STBC 解码

**公式**:
```
Alamouti 编码 (2Tx):
时刻1: [s₁, s₂], 时刻2: [-s₂*, s₁*]

接收 (1Rx): y₁ = h₁s₁ + h₂s₂, y₂ = -h₁s₂* + h₂s₁*
解码:
ŝ₁ = h₁*y₁ + h₂y₂* = (|h₁|² + |h₂|²)s₁
ŝ₂ = h₂*y₁ - h₁y₂* = (|h₁|² + |h₂|²)s₂
```

**来源**:
- Alamouti, S., "A Simple Transmit Diversity Technique for Wireless Communications," IEEE JSAC, 1998
- 3GPP TS 38.211 §7.4.4 (SFBC: Space-Frequency Block Coding, Alamouti in frequency domain)
- 3GPP TS 36.211 §6.3.4 (LTE SFBC)
- IEEE 802.11n §19.3.11.1 (STBC option)

**参数配置**:
| Config | Tx×Rx | domain | data_width | 应用 | 来源 |
|--------|-------|--------|------------|------|------|
| C1 | 2×1 | frequency (SFBC) | 16-bit | 5G NR | 3GPP TS 38.211 §7.4.4 |
| C2 | 2×2 | frequency (SFBC) | 16-bit | 5G NR | 3GPP TS 38.211 |
| C3 | 2×1 | time (STBC) | 16-bit | WiFi 802.11n | IEEE 802.11n |
| C4 | 2×2 | frequency (SFBC) | 16-bit | LTE | 3GPP TS 36.211 §6.3.4 |
