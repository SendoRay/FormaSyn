# Category 10: 5G NR 特有处理 (15 kernels)

---

## 10.01 LDPC Rate Matching (5G NR)

**公式**:
```
步骤 1: Bit selection
filler bits → NULL
circular buffer: E 个比特从 k₀ 开始选取

步骤 2: Bit interleaving
d(i) = e(i·E/Q_m + floor(i/E))  — 按 QAM order 交织

k₀ 起始位置:
RV=0: k₀=0
RV=1: k₀ = floor(17·N_cb/(66·Z_c))·Z_c
RV=2: k₀ = floor(33·N_cb/(66·Z_c))·Z_c
RV=3: k₀ = floor(56·N_cb/(66·Z_c))·Z_c
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §5.4.2.1 (Rate matching for LDPC base graph 1 and 2)
- 3GPP TS 38.212 Table 5.4.2.1-2 (k₀ for LDPC)

**参数配置**:
| Config | base_graph | Z_c | RV | E | 应用 | 来源 |
|--------|-----------|-----|-----|---|------|------|
| C1 | BG1 | 384 | 0 | 8424 | PDSCH 大块 | 3GPP TS 38.212 §5.4.2.1 |
| C2 | BG1 | 384 | {0,1,2,3} | variable | HARQ 重传 | 3GPP TS 38.212 |
| C3 | BG2 | 52 | 0 | 1000 | PUSCH 小块 | 3GPP TS 38.212 |
| C4 | BG2 | 16 | 0 | 400 | UCI on PUSCH | 3GPP TS 38.212 |

---

## 10.02 Polar Rate Matching (5G NR)

**公式**:
```
三种模式:
1. 重复 (E < N): y[i] = d[i mod N]
2. 打孔 (E ≥ 3N/4): 从头打孔
3. 缩短 (E < 3N/4): 从尾缩短

Sub-block interleaver:
J[n] = bit_reversal(n, log₂N)
y[n] = d[J[n]]
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §5.4.1 (Rate matching for Polar codes)
- 3GPP TS 38.212 Table 5.3.1.2-1 (Polar code sequence Q_N)

**参数配置**:
| Config | N | E | K | mode | 应用 | 来源 |
|--------|---|---|---|------|------|------|
| C1 | 512 | 432 | 36 | puncturing | DCI (PDCCH) | 3GPP TS 38.212 §5.4.1 |
| C2 | 256 | 200 | 32 | puncturing | UCI | 3GPP TS 38.212 |
| C3 | 1024 | 1024 | 140 | no RM | PBCH | 3GPP TS 38.212 |
| C4 | 128 | 64 | 20 | shortening | 小 UCI | 3GPP TS 38.212 |

---

## 10.03 HARQ 软合并 (HARQ-IR / Chase Combining)

**公式**:
```
Chase Combining:
L_combined[i] = L_1[i] + L_2[i] + ... + L_K[i]

Incremental Redundancy (IR):
circular buffer 中不同 RV 对应不同奇偶校验位
L_combined = 合并来自多个 RV 的 LLR

HARQ buffer management:
N_soft = min(N_cb, N_ref), N_ref = floor(TBS_LBRM / C · R_LBRM)
```

**来源**:
- 3GPP TS 38.212 §5.4.2 (LDPC rate matching, HARQ IR basis)
- 3GPP TS 38.214 §5.1.2.1 (HARQ-ACK feedback)
- 3GPP TS 38.306 §4.1 (UE HARQ soft buffer capability)

**参数配置**:
| Config | method | max_retx | buffer_depth | 应用 | 来源 |
|--------|--------|---------|-------------|------|------|
| C1 | IR | 4 | 8 processes | PDSCH DL | 3GPP TS 38.214 §5.1.2 |
| C2 | Chase | 4 | 8 processes | PUSCH UL | 3GPP TS 38.214 §6.1.2 |
| C3 | IR | 4 | 16 processes | CA/DC | 3GPP TS 38.306 |

---

## 10.04 PDCCH 盲检测

**公式**:
```
CCE aggregation level: L ∈ {1, 2, 4, 8, 16}
每个 AL 下搜索 M_L 个候选:
候选位置: n_CCE = L · { (Y_p + m · N_CCE/(L·M_L)) mod (N_CCE/L) }

Y_p: RNTI-based hash (初始值依赖 n_RNTI)
Y_p = (A·Y_{p-1}) mod D, A=39827, D=65537

每个候选: Polar 解码 + CRC-24C 校验
CRC 匹配 → 检测成功
```

**来源**:
- 3GPP TS 38.213 V17.3.0 §10.1 (Search space and PDCCH candidates)
- 3GPP TS 38.213 Table 10.1-1 (M_L for USS and CSS)
- 3GPP TS 38.212 §7.3.2 (DCI formats)

**参数配置**:
| Config | AL_set | max_candidates | CORESET_size | 应用 | 来源 |
|--------|--------|---------------|-------------|------|------|
| C1 | {1,2,4,8,16} | 44 total | 48 RBs | USS 全搜索 | 3GPP TS 38.213 §10.1 |
| C2 | {4,8} | 7 | 24 RBs | CSS Type 0 | 3GPP TS 38.213 Table 10.1-1 |
| C3 | {4,8,16} | 10 | 48 RBs | CSS Type 1 | 3GPP TS 38.213 |

---

## 10.05 CSI-RS 生成与处理

**公式**:
```
CSI-RS 序列:
r(m) = (1/√2)(1-2·c(2m)) + j(1/√2)(1-2·c(2m+1))
c(n): Gold 序列, c_init = f(N_ID, l, n_s)

CSI-RS 资源映射:
RE 位置由 CSI-RS density (ρ) 和 CDM type 决定
ρ ∈ {1/2, 1, 3} per port per RB
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §7.4.1.5 (CSI-RS)
- 3GPP TS 38.214 §5.2.2.3 (CSI reporting)

**参数配置**:
| Config | ports | density | CDM_type | 应用 | 来源 |
|--------|-------|---------|---------|------|------|
| C1 | 1 | 3 | no CDM | CSI 测量 (beam) | 3GPP TS 38.211 §7.4.1.5 |
| C2 | 2 | 1 | FD-CDM2 | CSI 2-port | 3GPP TS 38.211 |
| C3 | 4 | 1 | FD-CDM2 | CSI 4-port | 3GPP TS 38.211 |
| C4 | 32 | 0.5 | CDM4(FD2,TD2) | Massive MIMO | 3GPP TS 38.211 |

---

## 10.06 DMRS 生成 (5G NR)

**公式**:
```
DMRS 序列 (Type 1):
r(m) = (1/√2)(1-2·c(2m)) + j(1/√2)(1-2·c(2m+1))
c_init = f(n_SCID, N_ID, n_s, l)

Type 1: comb-2 (每隔一个子载波), 最多 8 个 CDM 端口
Type 2: groups of 2/3, 最多 12 个 CDM 端口

配置类型1: 1 个 OFDM symbol (front-loaded)
配置类型2: 2 个 OFDM symbol (front-loaded)
additional positions: 0/1/2/3 个额外 DMRS 位置
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §7.4.1.1 (DMRS for PDSCH)
- 3GPP TS 38.211 §6.4.1.1 (DMRS for PUSCH)
- 3GPP TS 38.211 Table 7.4.1.1.2-1 (DMRS positions in time)

**参数配置**:
| Config | type | max_ports | config_type | add_pos | 应用 | 来源 |
|--------|------|----------|------------|---------|------|------|
| C1 | Type 1 | 8 | 1 (single) | 0 | PDSCH 低速 | 3GPP TS 38.211 §7.4.1.1 |
| C2 | Type 1 | 8 | 2 (double) | 1 | PDSCH 高速 | 3GPP TS 38.211 |
| C3 | Type 2 | 12 | 1 | 0 | PDSCH MU-MIMO | 3GPP TS 38.211 |
| C4 | Type 1 | 4 | 1 | 0 | PUSCH | 3GPP TS 38.211 §6.4.1.1 |

---

## 10.07 SSB 生成与检测

**公式**:
```
SSB = PSS + SSS + PBCH + DMRS (4 OFDM symbols × 240 subcarriers)

PSS: 127-length m-sequence (3 sequences, N_ID2)
SSS: 127-length Gold sequence (336 per N_ID2, N_ID1)
PBCH: Polar encoded (K=56, E=864), QPSK
PBCH DMRS: Gold sequence, v = N_cell_ID mod 4

SSB 周期: {5, 10, 20, 40, 80, 160} ms
SSB beam index: i_SSB ∈ {0,...,L_max-1}
L_max = 4 (< 3GHz), 8 (3-6GHz), 64 (> 6GHz)
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §7.4.2 (SS/PBCH block)
- 3GPP TS 38.213 §4.1 (SSB configuration)

**参数配置**:
| Config | SCS | L_max | period | freq_range | 来源 |
|--------|-----|-------|--------|-----------|------|
| C1 | 15 kHz | 4 | 20 ms | FR1 < 3GHz | 3GPP TS 38.213 §4.1 |
| C2 | 30 kHz | 8 | 20 ms | FR1 3-6GHz | 3GPP TS 38.213 |
| C3 | 120 kHz | 64 | 20 ms | FR2 | 3GPP TS 38.213 |

---

## 10.08 Beam Sweeping (波束扫描)

**公式**:
```
SSB beam 与 DFT codebook:
w[n] = e^{j2πn·d·sin(θ_k)/λ}, n=0,...,N_ant-1
θ_k = -π/2 + k·π/L_max, k=0,...,L_max-1

每个 SSB index 对应一个 beam 方向
UE 侧: RSRP 测量每个 SSB beam → 报告最佳 beam index

发射端: per-SSB precoding vector/matrix
```

**来源**:
- 3GPP TS 38.214 §5.1.5 (Beam management)
- 3GPP TS 38.321 §5.17 (Beam failure detection and recovery)
- 3GPP TR 38.802 §6.1.6 (Study on beam management)

**参数配置**:
| Config | N_ant | L_max | beam_type | 应用 | 来源 |
|--------|-------|-------|----------|------|------|
| C1 | 8 | 4 | analog | FR1 sub-3GHz | 3GPP TS 38.214 §5.1.5 |
| C2 | 32 | 8 | analog | FR1 3-6GHz | 3GPP TS 38.214 |
| C3 | 64 | 64 | analog/hybrid | FR2 mmWave | 3GPP TS 38.214 |

---

## 10.09 UCI 编码 (Uplink Control Information)

**公式**:
```
UCI payload size 决定编码方式:
K ≤ 2 bits: 重复/simplex code
3 ≤ K ≤ 11 bits: Reed-Muller (RM) 码 或 short block code
K ≥ 12 bits: Polar code

Short block code (K=3~11):
c[n] = Σ_{i=0}^{K-1} (a_i · M_{i,n}) mod 2
M: basis sequences from 3GPP Table 5.3.3.3-1 (32 columns)
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §5.3.3 (Encoding of small block lengths)
- 3GPP TS 38.212 Table 5.3.3.3-1 (Basis sequence for UCI)
- 3GPP TS 38.212 §5.3.1 (Polar coding for K≥12)

**参数配置**:
| Config | K | method | E | 应用 | 来源 |
|--------|---|--------|---|------|------|
| C1 | 1 | repetition | 2 | HARQ-ACK 1bit | 3GPP TS 38.212 §5.3.3.1 |
| C2 | 2 | simplex | 3 | HARQ-ACK 2bit | 3GPP TS 38.212 §5.3.3.2 |
| C3 | 6 | short block | 32 | CSI part 1 | 3GPP TS 38.212 §5.3.3.3 |
| C4 | 11 | short block | 32 | CSI part 1 | 3GPP TS 38.212 §5.3.3.3 |
| C5 | 20 | Polar | 108 | CSI part 2 | 3GPP TS 38.212 §5.3.1 |

---

## 10.10 SRS 生成 (Sounding Reference Signal)

**公式**:
```
SRS 基于 ZC 序列:
r_u,v^{(α)}[n] = e^{j·α·n} · x_u,v(n)
x_u,v(n): ZC base sequence with group/sequence hopping

频域: comb-2/4 (K_TC ∈ {2, 4})
梳齿偏移: k_TC_offset
带宽配置: B_SRS, C_SRS → m_{SRS,b} (RB 数)
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §6.4.1.4 (SRS)
- 3GPP TS 38.211 Table 6.4.1.4.3-1 (SRS bandwidth configuration)

**参数配置**:
| Config | K_TC | BW (RBs) | N_symb | 应用 | 来源 |
|--------|------|----------|--------|------|------|
| C1 | 2 | 4 | 1 | SRS 窄带 | 3GPP TS 38.211 §6.4.1.4 |
| C2 | 4 | 272 | 1 | SRS 宽带 | 3GPP TS 38.211 |
| C3 | 2 | 68 | 2 | SRS 2-symbol | 3GPP TS 38.211 |
| C4 | 2 | 136 | 4 | SRS antenna switching | 3GPP TS 38.211 |

---

## 10.11 DCI 格式处理

**公式**:
```
DCI format sizes (bits):
Format 0_0 (UL grant fallback): ~39-49 bits (SCS dependent)
Format 0_1 (UL grant full): variable
Format 1_0 (DL assignment fallback): ~39-49 bits
Format 1_1 (DL assignment full): variable

DCI 打包: 各字段按规定顺序拼接
DCI 填充: 使 0_0 和 1_0 大小相同 (减少盲检)
CRC attach: 24-bit CRC, XOR with RNTI
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §7.3.1 (DCI formats)
- 3GPP TS 38.212 Table 7.3.1.1.1-1 (DCI format 0_0 fields)
- 3GPP TS 38.212 Table 7.3.1.2.1-1 (DCI format 1_0 fields)

**参数配置**:
| Config | format | payload_bits | CRC | 应用 | 来源 |
|--------|--------|-------------|-----|------|------|
| C1 | 0_0 | 39+padding | CRC24C | UL fallback | 3GPP TS 38.212 §7.3.1.1 |
| C2 | 1_0 | 39+padding | CRC24C | DL fallback | 3GPP TS 38.212 §7.3.1.2 |
| C3 | 0_1 | variable | CRC24C | UL full | 3GPP TS 38.212 §7.3.1.1.2 |
| C4 | 1_1 | variable | CRC24C | DL full | 3GPP TS 38.212 §7.3.1.2.2 |

---

## 10.12 PBCH 处理链

**公式**:
```
MIB (24 bits) → CRC-24C attach → Polar encode (K=56, E=864) →
Rate matching → Scrambling (c_init=N_cell_ID) → QPSK mapping →
RE mapping (SSB 中 symbol 1,2,3 的非 DMRS 位置)

PBCH payload scrambling (cell-specific):
ā_j = (a_j + s_j) mod 2
s: 序列由 N_cell_ID 和 v (half-frame indicator) 决定

解码: QPSK 软解映射 → Rate de-matching → Polar SCL decode → CRC 校验
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §7.1 (PBCH)
- 3GPP TS 38.211 §7.4.3 (PBCH physical processing)

**参数配置**:
| Config | K | E | list_size (SCL) | 应用 | 来源 |
|--------|---|---|----------------|------|------|
| C1 | 56 | 864 | 8 | PBCH 解码 | 3GPP TS 38.212 §7.1 |

---

## 10.13 PUCCH 格式处理

**公式**:
```
Format 0: 1~2 bits, 序列检测 (ZC cyclic shift)
  r_u,v^{(α)}[n], α = 2π·m_cs/12, m_cs: function of HARQ-ACK/SR

Format 1: 1~2 bits, sequence spreading (长持续时间)
  OCC (orthogonal cover code) + ZC sequence

Format 2: > 2 bits, OFDM-based (1~2 symbols, wideband)
  编码 + QPSK + 资源映射

Format 3: > 2 bits, DFT-s-OFDM (4~14 symbols, wideband)
Format 4: > 2 bits, DFT-s-OFDM (4~14 symbols, 1 RB, 多用户 OCC)
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §6.3.2 (PUCCH)
- 3GPP TS 38.213 §9.2 (PUCCH resource)

**参数配置**:
| Config | format | bits | symbols | PRBs | 应用 | 来源 |
|--------|--------|------|---------|------|------|------|
| C1 | 0 | 1-2 | 1-2 | 1 | HARQ-ACK/SR | 3GPP TS 38.211 §6.3.2.3 |
| C2 | 1 | 1-2 | 4-14 | 1 | HARQ-ACK long | 3GPP TS 38.211 §6.3.2.4 |
| C3 | 2 | >2 | 1-2 | 1-16 | CSI 短 | 3GPP TS 38.211 §6.3.2.5 |
| C4 | 3 | >2 | 4-14 | 1-16 | CSI 长 (SF) | 3GPP TS 38.211 §6.3.2.6 |

---

## 10.14 CRC 计算 (NR 专用多项式)

**公式**:
```
5G NR 使用多种 CRC:
CRC-24A: g(D) = D²⁴+D²³+D¹⁸+D¹⁷+D¹⁴+D¹¹+D¹⁰+D⁷+D⁶+D⁵+D⁴+D³+D+1
  → Transport block CRC (PDSCH/PUSCH)

CRC-24B: g(D) = D²⁴+D²³+D⁶+D⁵+D+1
  → Code block CRC (LDPC 分段)

CRC-24C: g(D) = D²⁴+D²³+D²¹+D²⁰+D¹⁷+D¹⁵+D¹³+D¹²+D⁸+D⁴+D²+D+1
  → Polar code CRC (PDCCH, PBCH)

CRC-16: g(D) = D¹⁶+D¹²+D⁵+1
  → Code block CRC (小块 LDPC)

CRC-11: g(D) = D¹¹+D¹⁰+D⁹+D⁵+1
  → Polar code CRC (UCI)

CRC-6: g(D) = D⁶+D⁵+1
  → Polar code CRC (short UCI)
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §5.1 (CRC calculation, all polynomial definitions)
- 3GPP TS 38.212 Table 5.1-1 (CRC polynomials)

**参数配置**:
| Config | CRC_type | length | polynomial | 应用 | 来源 |
|--------|---------|--------|-----------|------|------|
| C1 | CRC-24A | 24 | see above | TB CRC | 3GPP TS 38.212 §5.1 |
| C2 | CRC-24B | 24 | see above | CB CRC (LDPC) | 3GPP TS 38.212 §5.1 |
| C3 | CRC-24C | 24 | see above | Polar CRC | 3GPP TS 38.212 §5.1 |
| C4 | CRC-16 | 16 | see above | CB CRC (small) | 3GPP TS 38.212 §5.1 |
| C5 | CRC-11 | 11 | see above | UCI CRC | 3GPP TS 38.212 §5.1 |
| C6 | CRC-6 | 6 | see above | short UCI CRC | 3GPP TS 38.212 §5.1 |

---

## 10.15 Code Block Segmentation (NR LDPC)

**公式**:
```
Transport block + CRC-24A → 分段 (如果 B > K_cb)
K_cb = 8448 (BG1), 3840 (BG2)

段数: C = ceil(B / (K_cb - 24))
每段: K = B'/C + 24 (CRC-24B)
B' = B + 24·C

Filler bits: F = C·K - B'
Z_c: 最小 lifting size 满足 K_b·Z_c ≥ K
K_b = 22 (BG1), 10 (BG2)
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §5.2.2 (Code block segmentation and CRC attachment)
- 3GPP TS 38.212 Table 5.3.2-1 (Lifting sizes Z_c)

**参数配置**:
| Config | BG | K_cb | max_Z_c | K_b | 应用 | 来源 |
|--------|-----|------|---------|-----|------|------|
| C1 | BG1 | 8448 | 384 | 22 | PDSCH/PUSCH 大块 | 3GPP TS 38.212 §5.2.2 |
| C2 | BG2 | 3840 | 384 | 10 | PDSCH/PUSCH 小块 | 3GPP TS 38.212 §5.2.2 |
