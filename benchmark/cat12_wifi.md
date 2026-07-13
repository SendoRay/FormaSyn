# Category 12: WiFi (IEEE 802.11) 特有处理 (12 kernels)

---

## 12.01 STF 生成与检测 (Short Training Field)

**公式**:
```
802.11a STF: 12 个非零子载波 (in 64-pt FFT)
S_{-26,...,26} = √(13/6) × {0,0,1+j,0,...} (已知序列)
时域: 10 个短重复 (每个 16 samples @ 20MHz = 0.8μs)

检测: 自相关
P[d] = Σ_{m=0}^{15} r*[d+m]·r[d+m+16]
R[d] = Σ_{m=0}^{15} |r[d+m+16]|²
M[d] = |P[d]|²/R[d]²

阈值越过 → 包检测
```

**来源**:
- IEEE 802.11-2020 §17.3.3 (Short training sequence definition)
- IEEE 802.11-2020 Table 17-7 (STF subcarrier values)

**参数配置**:
| Config | N_FFT | repeat_len | N_repeats | BW | 应用 | 来源 |
|--------|-------|-----------|----------|-----|------|------|
| C1 | 64 | 16 | 10 | 20MHz | 802.11a/g | IEEE 802.11-2020 §17.3.3 |
| C2 | 64 | 16 | 10 | 20MHz | 802.11n (per chain) | IEEE 802.11-2020 §19.3.3 |
| C3 | 256 | 64 | 10 | 80MHz | 802.11ac | IEEE 802.11-2020 §21.3.3 |

---

## 12.02 LTF 处理与信道估计 (Long Training Field)

**公式**:
```
802.11a LTF: 所有 52 个数据+导频子载波非零 (已知 BPSK 序列)
L_{-26,...,26}: 52 个 ±1 值 (3GPP Table 17-8)
时域: CP(32 samples) + 2 × OFDM symbol (各 64 samples) = 160 samples

信道估计 (LS):
H[k] = Y_LTF[k] / L[k], per subcarrier
平均: H[k] = (H₁[k] + H₂[k]) / 2 (两个 LTF 符号)
```

**来源**:
- IEEE 802.11-2020 §17.3.3 (Long training sequence)
- IEEE 802.11-2020 Table 17-8 (LTF subcarrier values)
- IEEE 802.11-2020 §19.3.3 (HT-LTF for MIMO)

**参数配置**:
| Config | N_FFT | N_LTF_symbols | mode | 应用 | 来源 |
|--------|-------|--------------|------|------|------|
| C1 | 64 | 2 | legacy | 802.11a/g | IEEE 802.11-2020 §17.3.3 |
| C2 | 64 | 2~4 | HT (MIMO) | 802.11n 2×2~4×4 | IEEE 802.11-2020 §19.3.3 |
| C3 | 256 | 1~8 | VHT | 802.11ac | IEEE 802.11-2020 §21.3.3 |
| C4 | 256 | 1~8 | HE | 802.11ax | IEEE 802.11ax §27.3.3 |

---

## 12.03 WiFi Scrambler / Descrambler

**公式**:
```
LFSR: x⁷ + x⁴ + 1
S(x) = x₇ ⊕ x₄
初始状态: 7 bits, 在 SERVICE field 的前 7 bits 传输

加扰: data_out[i] = data_in[i] ⊕ scrambler_out[i]
解扰: 相同操作 (自同步)
```

**来源**:
- IEEE 802.11-2020 §17.3.5.4 (Data scrambler)
- IEEE 802.11-2020 Figure 17-9 (Scrambler schematic)

**参数配置**:
| Config | polynomial | seed_bits | 应用 | 来源 |
|--------|-----------|----------|------|------|
| C1 | x⁷+x⁴+1 | 7 | 所有 802.11 OFDM modes | IEEE 802.11-2020 §17.3.5.4 |

---

## 12.04 WiFi BCC 编码器 (Binary Convolutional Code)

**公式**:
```
生成多项式: g₀ = 133₈ = 1011011, g₁ = 171₈ = 1111001
约束长度 K = 7, 编码速率 R = 1/2

打孔:
R=2/3: [1,1,1,0] (输出 A,B 交替打孔)
R=3/4: [1,1,1,0,0,1]
R=5/6: [1,1,1,0,0,1,1,0,0,1]
```

**来源**:
- IEEE 802.11-2020 §17.3.5.5 (Convolutional encoder)
- IEEE 802.11-2020 §17.3.5.6 (Puncturing)
- IEEE 802.11-2020 Table 17-10 (Puncturing patterns)

**参数配置**:
| Config | K | R_base | R_punctured | 应用 | 来源 |
|--------|---|--------|-----------|------|------|
| C1 | 7 | 1/2 | 1/2 | BPSK 6Mbps | IEEE 802.11-2020 §17.3.5.5 |
| C2 | 7 | 1/2 | 2/3 | 16QAM 36Mbps | IEEE 802.11-2020 Table 17-10 |
| C3 | 7 | 1/2 | 3/4 | 64QAM 54Mbps | IEEE 802.11-2020 Table 17-10 |
| C4 | 7 | 1/2 | 5/6 | 256QAM (11ac/ax) | IEEE 802.11-2020 |

---

## 12.05 WiFi Block Interleaver

**公式**:
```
两步置换:
第一步 (频率分集): i = (N_CBPS/16)·(k mod 16) + floor(k/16)
第二步 (bit 可靠性): j = s·floor(i/s) + (i + N_CBPS - floor(16·i/N_CBPS)) mod s
s = max(N_BPSC/2, 1)

N_CBPS: 每 OFDM symbol 的编码 bits
N_BPSC: 每子载波的 bits (调制阶数)
16 列 (frequency-first 到 time-first)
```

**来源**:
- IEEE 802.11-2020 §17.3.5.7 (Data interleaving)
- IEEE 802.11-2020 Eq. (17-24), (17-25)

**参数配置**:
| Config | N_CBPS | N_BPSC | s | modulation | 应用 | 来源 |
|--------|--------|--------|---|-----------|------|------|
| C1 | 48 | 1 | 1 | BPSK | 802.11a | IEEE 802.11-2020 §17.3.5.7 |
| C2 | 96 | 2 | 1 | QPSK | 802.11a | IEEE 802.11-2020 |
| C3 | 192 | 4 | 2 | 16QAM | 802.11a | IEEE 802.11-2020 |
| C4 | 288 | 6 | 3 | 64QAM | 802.11a | IEEE 802.11-2020 |
| C5 | 384 | 8 | 4 | 256QAM | 802.11ac/ax | IEEE 802.11-2020 |

---

## 12.06 WiFi LDPC 编码 (802.11n/ac/ax)

**公式**:
```
QC-LDPC with 3 码率 × 3 码字长度 = 9 种 H 矩阵

码率: R ∈ {1/2, 2/3, 3/4, 5/6}
码字长度: n ∈ {648, 1296, 1944}
lifting size: Z ∈ {27, 54, 81}

校验矩阵: H = expansion of 24×(24-k) base matrix
k = 12 (R=1/2), 16 (R=2/3), 18 (R=3/4), 20 (R=5/6)
```

**来源**:
- IEEE 802.11-2020 §19.3.11.6 (LDPC coding)
- IEEE 802.11-2020 Tables R1-R12 (LDPC matrices for each rate/length)

**参数配置**:
| Config | n | R | Z | K (info bits) | 应用 | 来源 |
|--------|---|---|---|-------------|------|------|
| C1 | 648 | 1/2 | 27 | 324 | 802.11n lowest | IEEE 802.11-2020 Table R1 |
| C2 | 1296 | 1/2 | 54 | 648 | 802.11n mid | IEEE 802.11-2020 Table R4 |
| C3 | 1944 | 1/2 | 81 | 972 | 802.11n max | IEEE 802.11-2020 Table R7 |
| C4 | 1944 | 2/3 | 81 | 1296 | 802.11ac | IEEE 802.11-2020 Table R8 |
| C5 | 1944 | 3/4 | 81 | 1458 | 802.11ac | IEEE 802.11-2020 Table R9 |
| C6 | 1944 | 5/6 | 81 | 1620 | 802.11ac/ax | IEEE 802.11-2020 Table R10 |

---

## 12.07 WiFi Viterbi 解码器

**公式**:
```
Trellis: 64 states (K=7)
Branch metric: Euclidean distance (soft) 或 Hamming distance (hard)
ACS (Add-Compare-Select): 每个时钟处理 64 states

Traceback:
depth = 5·(K-1) = 30 (最小)
典型: 35~42 bits traceback depth

输出: 硬判决 decoded bits
```

**来源**:
- IEEE 802.11-2020 §17.3.5.5 (与 BCC 编码配对的 Viterbi 解码)
- Heller & Jacobs, "Viterbi Decoding for Satellite and Space Communication," IEEE Trans. Comm., 1971

**参数配置**:
| Config | K | states | traceback_depth | metric | 应用 | 来源 |
|--------|---|--------|----------------|--------|------|------|
| C1 | 7 | 64 | 35 | soft (3-bit) | 802.11a/g | IEEE 802.11-2020 |
| C2 | 7 | 64 | 42 | soft (4-bit) | 802.11n | IEEE 802.11-2020 |
| C3 | 7 | 64 | 35 | hard | 低功耗 | IEEE 802.11-2020 |

---

## 12.08 WiFi 导频跟踪 (Pilot Phase Tracking)

**公式**:
```
802.11a: 4 个导频子载波 {-21, -7, 7, 21}
导频极性序列: p[n] = PRBS (127-length, 从 scrambler seed 导出)

Phase offset 估计:
Δφ[n] = angle(Σ_{k∈pilots} Y[k,n] · (H[k]·P[k,n])*)

补偿: Y_comp[k,n] = Y[k,n] · e^{-j·Δφ[n]}
```

**来源**:
- IEEE 802.11-2020 §17.3.5.9 (Pilot subcarrier polarities)
- IEEE 802.11-2020 §17.3.10.7 (Sampling clock offset tracking)
- IEEE 802.11-2020 Table 17-9 (Pilot polarities, 127-element sequence)

**参数配置**:
| Config | N_pilots | positions | BW | 应用 | 来源 |
|--------|---------|----------|-----|------|------|
| C1 | 4 | {-21,-7,7,21} | 20MHz | 802.11a/g | IEEE 802.11-2020 §17.3.5.9 |
| C2 | 4 | per 20MHz sub-band | 40MHz | 802.11n | IEEE 802.11-2020 §19.3.5 |
| C3 | 8 | per 20MHz sub-band | 80MHz | 802.11ac | IEEE 802.11-2020 §21.3.5 |
| C4 | 16 | per 20MHz sub-band | 160MHz | 802.11ac/ax | IEEE 802.11-2020 |

---

## 12.09 WiFi SIGNAL Field 解码

**公式**:
```
L-SIG (Legacy SIGNAL): 24 bits
  RATE (4 bits) + Reserved (1) + LENGTH (12 bits) + Parity (1) + Tail (6)
  编码: BCC R=1/2, BPSK, 1 OFDM symbol

HT-SIG (802.11n): 48 bits over 2 OFDM symbols
  MCS (7) + BW (1) + Length (16) + Smoothing (1) + ...
  QPSK, BCC R=1/2

VHT-SIG-A (802.11ac): 48 bits over 2 symbols
HE-SIG-A (802.11ax): 2 symbols

解码: 去导频 → 均衡 → 解调 → Viterbi → CRC/Parity check
```

**来源**:
- IEEE 802.11-2020 §17.3.4 (SIGNAL field, L-SIG)
- IEEE 802.11-2020 §19.3.4 (HT-SIG)
- IEEE 802.11-2020 §21.3.4 (VHT-SIG)
- IEEE 802.11ax §27.3.4 (HE-SIG)

**参数配置**:
| Config | field | bits | modulation | coding | 应用 | 来源 |
|--------|-------|------|-----------|--------|------|------|
| C1 | L-SIG | 24 | BPSK | BCC R=1/2 | legacy | IEEE 802.11-2020 §17.3.4 |
| C2 | HT-SIG | 48 | QPSK | BCC R=1/2 | 802.11n | IEEE 802.11-2020 §19.3.4 |
| C3 | VHT-SIG-A | 48 | BPSK | BCC R=1/2 | 802.11ac | IEEE 802.11-2020 §21.3.4 |
| C4 | HE-SIG-A | 52 (varies) | BPSK | BCC R=1/2 | 802.11ax | IEEE 802.11ax §27.3.4 |

---

## 12.10 WiFi A-MPDU 解析

**公式**:
```
A-MPDU delimiter (4 bytes):
  EOF (1 bit) + Reserved (1) + MPDU length (14 bits) + CRC-8 (8 bits) + Delimiter signature (8 bits = 0x4E)

解析流程:
1. 搜索 delimiter signature (0x4E)
2. 校验 CRC-8 (polynomial: x⁸+x²+x+1)
3. 提取 MPDU length
4. 提取 MPDU payload
5. 填充至 4-byte 对齐
6. 处理下一个 delimiter

CRC-8: g(D) = D⁸+D²+D+1 (over 16-bit field)
```

**来源**:
- IEEE 802.11-2020 §9.7.3 (A-MPDU format)
- IEEE 802.11-2020 §9.7.3.1 (MPDU delimiter)

**参数配置**:
| Config | max_MPDU_len | max_A_MPDU_len | 应用 | 来源 |
|--------|-------------|---------------|------|------|
| C1 | 3839 | 8191 | 802.11n | IEEE 802.11-2020 §9.7.3 |
| C2 | 11454 | 1048575 | 802.11ac | IEEE 802.11-2020 |
| C3 | 11454 | 4194304 | 802.11ax | IEEE 802.11ax |

---

## 12.11 WiFi CSD (Cyclic Shift Diversity)

**公式**:
```
时域循环移位:
x_tx_i[n] = x[(n - δ_i) mod N_FFT]

每个发射天线施加不同的循环移位以避免非预期波束成形:
δ_0 = 0 ns
δ_1 = -200 ns (20MHz, 4 samples)
δ_2 = -100 ns
δ_3 = -150 ns

等效频域: X_tx_i[k] = X[k] · e^{-j2πk·δ_i/N_FFT}
```

**来源**:
- IEEE 802.11-2020 §19.3.9 (CSD for HT)
- IEEE 802.11-2020 Table 19-10 (CSD values for legacy part)
- IEEE 802.11-2020 §21.3.7 (CSD for VHT)

**参数配置**:
| Config | N_tx | δ_values (ns) | N_FFT | 应用 | 来源 |
|--------|------|---------------|-------|------|------|
| C1 | 2 | {0, -200} | 64 | 802.11n 2Tx | IEEE 802.11-2020 Table 19-10 |
| C2 | 3 | {0, -200, -100} | 64 | 802.11n 3Tx | IEEE 802.11-2020 |
| C3 | 4 | {0, -200, -100, -150} | 64 | 802.11n 4Tx | IEEE 802.11-2020 |
| C4 | 4 | {0, -200, -100, -150} | 256 | 802.11ac 4Tx | IEEE 802.11-2020 §21.3.7 |

---

## 12.12 WiFi OFDMA 资源分配 (802.11ax)

**公式**:
```
RU (Resource Unit) sizes:
26-tone (2MHz 等效), 52-tone, 106-tone, 242-tone (20MHz),
484-tone (40MHz), 996-tone (80MHz), 2×996-tone (160MHz)

RU 分配表:
20MHz = 9×26-tone 或 4×52-tone+1×26-tone 或 2×106-tone+1×26-tone 或 1×242-tone
各 RU 之间有 guard subcarriers

每个 RU 独立分配给一个 STA:
trigger-based UL OFDMA / DL OFDMA
```

**来源**:
- IEEE 802.11ax §27.3.2 (OFDMA tone plan)
- IEEE 802.11ax Table 27-6 (RU subcarrier indices for 20MHz)
- IEEE 802.11ax Table 27-7 to 27-9 (RU indices for 40/80/160MHz)

**参数配置**:
| Config | BW | RU_sizes | N_FFT | 应用 | 来源 |
|--------|-----|---------|-------|------|------|
| C1 | 20MHz | 26/52/106/242 | 256 | 802.11ax 20MHz | IEEE 802.11ax §27.3.2 |
| C2 | 40MHz | 26/52/106/242/484 | 512 | 802.11ax 40MHz | IEEE 802.11ax |
| C3 | 80MHz | 26/52/106/242/484/996 | 1024 | 802.11ax 80MHz | IEEE 802.11ax |
| C4 | 160MHz | 26~2×996 | 2048 | 802.11ax 160MHz | IEEE 802.11ax |
