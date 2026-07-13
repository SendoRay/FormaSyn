# Category 11: 4G LTE 特有处理 (12 kernels)

---

## 11.01 Turbo 编码 (LTE)

**公式**:
```
PCCC 结构: 两个 RSC (rate-1/2) 编码器 + QPP 交织器
RSC 生成多项式: (13, 15)_oct, 即 g₀=1+D²+D³, g₁=1+D+D³

输出: 系统位 x_k, 校验位 1: z_k, 校验位 2: z'_k
编码速率: 1/3 (带打孔可达 1/2, 2/3, ...)

QPP 交织: π(i) = (f₁·i + f₂·i²) mod K
f₁, f₂: 由块大小 K 决定 (3GPP Table)
```

**来源**:
- 3GPP TS 36.212 V15.9.0 §5.1.3.2 (Turbo encoder)
- 3GPP TS 36.212 Table 5.1.3-3 (QPP interleaver parameters)

**参数配置**:
| Config | K | f₁ | f₂ | rate | 应用 | 来源 |
|--------|---|-----|-----|------|------|------|
| C1 | 6144 | 263 | 480 | 1/3 | LTE max block | 3GPP TS 36.212 Table 5.1.3-3 |
| C2 | 40 | 3 | 10 | 1/3 | LTE min block | 3GPP TS 36.212 Table 5.1.3-3 |
| C3 | 1056 | 17 | 66 | 1/3 | LTE mid block | 3GPP TS 36.212 Table 5.1.3-3 |

---

## 11.02 Turbo Rate Matching (LTE)

**公式**:
```
三路子块交织:
每路: 行列交织 (R_TC=32 列, C_TC=ceil(D/32) 行)
列排列: 按 3GPP Table 5.1.4-2 置换

Circular buffer:
w = [v₀, v₁, v₂] 串接 (系统, 校验1, 校验2)
bit 选择: 从 k₀ 开始读 E 个有效位

RV (Redundancy Version):
k₀ = R_TC · (2·ceil(N_cb/(8·R_TC))·rv_idx + 2)
rv_idx ∈ {0, 1, 2, 3}
```

**来源**:
- 3GPP TS 36.212 V15.9.0 §5.1.4.1 (Rate matching for turbo coded transport channels)
- 3GPP TS 36.212 Table 5.1.4-2 (Inter-column permutation pattern)

**参数配置**:
| Config | D | R_TC | rv_idx | E | 应用 | 来源 |
|--------|---|------|--------|---|------|------|
| C1 | 6148 | 32 | 0 | 6144 | 大块 R=1/3 | 3GPP TS 36.212 §5.1.4.1 |
| C2 | 6148 | 32 | {0,1,2,3} | variable | HARQ 重传 | 3GPP TS 36.212 |
| C3 | 44 | 32 | 0 | 120 | 小块 | 3GPP TS 36.212 |

---

## 11.03 LTE CRS 生成 (Cell-specific Reference Signal)

**公式**:
```
r_l,n_s(m) = (1/√2)(1-2·c(2m)) + j(1/√2)(1-2·c(2m+1))
c_init = 2^10·(7·(n_s·2+l+1)·(2·N_cell_ID+1) + 2·N_cell_ID + N_CP)

CRS 位置:
频域: v_shift = N_cell_ID mod 6
时域: l ∈ {0, 4} (port 0,1) 或 {1} (port 2,3)
每个 RB 有 2 个 CRS RE per antenna port per OFDM symbol
```

**来源**:
- 3GPP TS 36.211 V15.9.0 §6.10.1 (Cell-specific reference signals)
- 3GPP TS 36.211 Table 6.10.1.2-1 (CRS mapping)

**参数配置**:
| Config | ports | v_shift | N_RB | 应用 | 来源 |
|--------|-------|---------|------|------|------|
| C1 | 1 | N_ID mod 6 | 6 (1.4MHz) | LTE 小带宽 | 3GPP TS 36.211 §6.10.1 |
| C2 | 2 | N_ID mod 6 | 50 (10MHz) | LTE 中带宽 | 3GPP TS 36.211 |
| C3 | 4 | N_ID mod 6 | 100 (20MHz) | LTE 大带宽 | 3GPP TS 36.211 |

---

## 11.04 LTE PDCCH 处理

**公式**:
```
DCI → CRC-16 attach (XOR RNTI) → 卷积编码 (rate 1/3) → Rate matching → QPSK → RE mapping

CCE aggregation level: L ∈ {1, 2, 4, 8}
每个 CCE = 36 RE = 9 REG
盲检: 最多 44 个候选 (16 common + 16+16 UE-specific)

卷积码: (133, 171, 165)_oct, K=7
```

**来源**:
- 3GPP TS 36.212 V15.9.0 §5.3.3 (PDCCH encoding)
- 3GPP TS 36.213 V15.9.0 §9.1.1 (PDCCH search space)
- 3GPP TS 36.211 §6.8 (PDCCH resource mapping)

**参数配置**:
| Config | AL_set | max_candidates | N_RB_DL | 应用 | 来源 |
|--------|--------|---------------|---------|------|------|
| C1 | {1,2,4,8} | 44 | 50 (10MHz) | LTE PDCCH | 3GPP TS 36.213 §9.1.1 |
| C2 | {4,8} | 6 | 100 (20MHz) | Common SS | 3GPP TS 36.213 |

---

## 11.05 LTE PSS/SSS 生成

**公式**:
```
PSS (Zadoff-Chu, length 63):
d_u(n) = e^{-jπun(n+1)/63}, u ∈ {25, 29, 34} for N_ID2 ∈ {0, 1, 2}
映射到中心 72 个子载波 (DC 排除)

SSS (M-sequences, length 62):
Two interleaved m-sequences s₀ and s₁
s_even = s₀(m₀) ⊕ c₀
s_odd = s₁(m₁) ⊕ c₁ ⊕ z₁
subframe 0 和 5 使用不同映射
m₀, m₁: 由 N_ID1 决定 (168 个值)
```

**来源**:
- 3GPP TS 36.211 V15.9.0 §6.11.1 (Primary synchronization signal)
- 3GPP TS 36.211 §6.11.2 (Secondary synchronization signal)
- 3GPP TS 36.211 Table 6.11.2.1-1, 6.11.2.1-2 (SSS mapping tables)

**参数配置**:
| Config | signal | length | N_ID | 应用 | 来源 |
|--------|--------|--------|------|------|------|
| C1 | PSS | 63 (ZC) | N_ID2∈{0,1,2} | 初始同步 | 3GPP TS 36.211 §6.11.1 |
| C2 | SSS | 62 (m-seq) | N_ID1∈{0,...,167} | 小区 ID 检测 | 3GPP TS 36.211 §6.11.2 |

---

## 11.06 LTE PRACH (格式 0-4)

**公式**:
```
Zadoff-Chu: x_u[n] = e^{-jπun(n+1)/N_ZC}, N_ZC=839

Format 0: T_SEQ=800μs, T_CP=103.13μs
Format 1: T_SEQ=800μs, T_CP=684.38μs
Format 2: T_SEQ=1600μs, T_CP=203.13μs
Format 3: T_SEQ=1600μs, T_CP=684.38μs
Format 4: T_SEQ=133.33μs, T_CP=14.58μs (TDD short)

逻辑根: 物理根 u 由 prach-RootSequenceIndex 和 N_CS 决定
```

**来源**:
- 3GPP TS 36.211 V15.9.0 §5.7.1-2 (PRACH preamble generation)
- 3GPP TS 36.211 Table 5.7.1-1 (PRACH preamble parameters)

**参数配置**:
| Config | format | N_ZC | T_seq (μs) | T_CP (μs) | 应用 | 来源 |
|--------|--------|------|-----------|----------|------|------|
| C1 | 0 | 839 | 800 | 103.13 | FDD 标准 | 3GPP TS 36.211 Table 5.7.1-1 |
| C2 | 1 | 839 | 800 | 684.38 | 大小区 | 3GPP TS 36.211 |
| C3 | 2 | 839 | 1600 | 203.13 | 超大小区 | 3GPP TS 36.211 |
| C4 | 4 | 839 | 133.33 | 14.58 | TDD 短格式 | 3GPP TS 36.211 |

---

## 11.07 LTE 资源映射 (PDSCH/PUSCH)

**公式**:
```
PDSCH RE mapping:
每个 RB = 12 subcarriers × 14 symbols (normal CP)
或 12 × 12 (extended CP)

跳过: CRS, DMRS, CSI-RS, PDCCH region, SSS, PSS
剩余 RE 用于数据

PUSCH RE mapping:
SC-FDMA: DFT precoding + subcarrier mapping (localized or distributed)
DMRS 在 symbol 3 (normal CP), symbol 2 (extended CP)
```

**来源**:
- 3GPP TS 36.211 V15.9.0 §6.3.5 (PDSCH mapping)
- 3GPP TS 36.211 §5.3.4 (PUSCH mapping)

**参数配置**:
| Config | channel | N_RB | CP | MIMO_layers | 来源 |
|--------|---------|------|-----|------------|------|
| C1 | PDSCH | 50 | normal | 1 | 3GPP TS 36.211 §6.3.5 |
| C2 | PDSCH | 100 | normal | 2 (SFBC) | 3GPP TS 36.211 |
| C3 | PUSCH | 25 | normal | 1 | 3GPP TS 36.211 §5.3.4 |
| C4 | PUSCH | 100 | normal | 1 | 3GPP TS 36.211 |

---

## 11.08 LTE PHICH 处理

**公式**:
```
PHICH: Physical HARQ Indicator Channel
ACK=1 → 重复 3 次, BPSK: [1,1,1]
NACK=0 → 重复 3 次, BPSK: [-1,-1,-1]

扩频: 正交序列 (SF=4 for normal CP, SF=2 for extended CP)
Normal CP: [1,1,1,1], [1,-1,1,-1], [j,j,-j,-j], [j,-j,-j,j]
多个 PHICH 在同一 PHICH group 中码分复用
```

**来源**:
- 3GPP TS 36.211 V15.9.0 §6.9 (PHICH)
- 3GPP TS 36.211 Table 6.9.1-2 (Orthogonal sequences for PHICH)

**参数配置**:
| Config | N_group | SF | CP | 应用 | 来源 |
|--------|---------|----|----|------|------|
| C1 | 1 | 4 | normal | LTE 小带宽 | 3GPP TS 36.211 §6.9 |
| C2 | 3 | 4 | normal | LTE 10MHz | 3GPP TS 36.211 |
| C3 | 1 | 2 | extended | LTE MBSFN | 3GPP TS 36.211 |

---

## 11.09 LTE PCFICH 处理

**公式**:
```
PCFICH: Physical Control Format Indicator Channel
CFI ∈ {1, 2, 3}: 指示 PDCCH 占用的 OFDM symbol 数

编码: CFI → 32 bits (3GPP Table 5.3.4-1)
CFI=1 → <0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1>
CFI=2 → <1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0>
CFI=3 → <1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1>

QPSK 映射 → 16 symbols → 4 REGs (分散在频域)
```

**来源**:
- 3GPP TS 36.212 V15.9.0 §5.3.4 (PCFICH encoding)
- 3GPP TS 36.211 §6.7 (PCFICH resource mapping)

**参数配置**:
| Config | CFI_range | N_RB_DL | 应用 | 来源 |
|--------|----------|---------|------|------|
| C1 | {1,2,3} | 25 (5MHz) | LTE 标准 | 3GPP TS 36.212 §5.3.4 |
| C2 | {1,2,3} | 100 (20MHz) | LTE 宽带 | 3GPP TS 36.212 |

---

## 11.10 LTE Turbo 解码 MAP — 外信息计算

**公式**:
```
Turbo 迭代解码:
L_e1(b_k) = L_APP1(b_k) - L_a1(b_k) - L_c·y_s[k]
L_a2(b_k) = π(L_e1(b_k))  (交织后作为第二分量的先验)
L_e2(b_k) = L_APP2(b_k) - L_a2(b_k) - L_c·y'_s[k]
L_a1(b_k) = π⁻¹(L_e2(b_k))  (去交织后作为第一分量的先验)

迭代 6~8 次
Max-log-MAP 简化: ln(e^a + e^b) ≈ max(a,b) + correction
```

**来源**:
- 3GPP TS 36.212 §5.1.3.2 (Turbo encoder → 对应的解码)
- Robertson, Villebrun, Hoeher, "A Comparison of Optimal and Sub-Optimal MAP Decoding Algorithms," IEEE ICC 1995

**参数配置**:
| Config | K | iterations | algorithm | data_width | 应用 | 来源 |
|--------|---|-----------|-----------|------------|------|------|
| C1 | 6144 | 6 | max-log-MAP | 8-bit LLR | LTE PDSCH | 3GPP TS 36.212 |
| C2 | 6144 | 8 | log-MAP | 8-bit LLR | 高性能 | 3GPP TS 36.212 |
| C3 | 40 | 8 | log-MAP | 8-bit LLR | LTE 小块 | 3GPP TS 36.212 |

---

## 11.11 LTE 频域均衡 (SC-FDMA 接收)

**公式**:
```
SC-FDMA 接收:
y → CP 去除 → FFT(N) → 子载波解映射 → MMSE 均衡 → IDFT(M) → 检测

频域 MMSE 均衡 (per subcarrier):
X[k] = H*[k]·Y[k] / (|H[k]|² + σ²)

IDFT: 恢复单载波信号
```

**来源**:
- 3GPP TS 36.211 §5.6 (SC-FDMA)
- 3GPP TS 36.101 §7 (UE 接收性能要求)

**参数配置**:
| Config | M (DFT) | N (FFT) | equalizer | 应用 | 来源 |
|--------|---------|---------|----------|------|------|
| C1 | 300 | 512 | MMSE | LTE UL 5MHz | 3GPP TS 36.211 |
| C2 | 600 | 1024 | MMSE | LTE UL 10MHz | 3GPP TS 36.211 |
| C3 | 1200 | 2048 | MMSE | LTE UL 20MHz | 3GPP TS 36.211 |

---

## 11.12 LTE PUCCH 格式 1/1a/1b

**公式**:
```
Format 1: SR (scheduling request), 无数据
Format 1a: 1 bit HARQ-ACK, BPSK
Format 1b: 2 bits HARQ-ACK, QPSK

处理: d(0) → cyclic shift ZC sequence → OCC spreading → 映射到 PUCCH RB

ZC cyclic shift: r_u,v^{(α)}[n], α = 2π·n_cs/12
n_cs = f(N_cell_ID, n_s, l)

OCC: [w(0), w(1), w(2), w(3)] 对 4 个 OFDM symbol 扩频
```

**来源**:
- 3GPP TS 36.211 V15.9.0 §5.4.1 (PUCCH format 1/1a/1b)
- 3GPP TS 36.211 Table 5.4.1-2 (Orthogonal sequences for PUCCH)

**参数配置**:
| Config | format | bits | N_cs | 应用 | 来源 |
|--------|--------|------|------|------|------|
| C1 | 1 | 0 (SR) | variable | SR 检测 | 3GPP TS 36.211 §5.4.1 |
| C2 | 1a | 1 | variable | HARQ-ACK 1bit | 3GPP TS 36.211 |
| C3 | 1b | 2 | variable | HARQ-ACK 2bit | 3GPP TS 36.211 |
