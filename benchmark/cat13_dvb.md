# Category 13: DVB 卫星/地面/有线 (10 kernels)

---

## 13.01 DVB-S2 LDPC 编码

**公式**:
```
码字长度: n ∈ {64800 (normal), 16200 (short)}
码率: R ∈ {1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 8/9, 9/10}

IRA (Irregular Repeat-Accumulate) 结构:
校验矩阵 H 由 Table 定义:
每行: q 个 "1" 的位置 (循环移位构造)
accumulate: p_i = p_{i-1} ⊕ λ_i (逐步累积)

编码复杂度: O(n) (线性, 利用 IRA 结构)
```

**来源**:
- ETSI EN 302 307-1 V1.4.1 §5.3.2 (LDPC coding for DVB-S2)
- ETSI EN 302 307-1 Table A1~A11 (Normal frame LDPC table for each rate)
- ETSI EN 302 307-1 Table B1~B11 (Short frame LDPC table)

**参数配置**:
| Config | n | R | k (info bits) | 应用 | 来源 |
|--------|---|---|-------------|------|------|
| C1 | 64800 | 1/2 | 32400 | DVB-S2 标准 | EN 302 307 Table A2 |
| C2 | 64800 | 2/3 | 43200 | DVB-S2 高速 | EN 302 307 Table A5 |
| C3 | 64800 | 3/4 | 48600 | DVB-S2 高速 | EN 302 307 Table A6 |
| C4 | 64800 | 5/6 | 54000 | DVB-S2 高效率 | EN 302 307 Table A8 |
| C5 | 16200 | 1/2 | 7200 | DVB-S2 短帧 | EN 302 307 Table B2 |
| C6 | 16200 | 3/4 | 11880 | DVB-S2 短帧 | EN 302 307 Table B6 |

---

## 13.02 DVB-S2 BCH 编码

**公式**:
```
外码: BCH (n_bch, k_bch, t)
在 LDPC 之前级联

Normal frame (n_ldpc=64800):
R=1/2: BCH(32400, 32208, t=12)
R=2/3: BCH(43200, 43040, t=10)
R=3/4: BCH(48600, 48408, t=12)

Short frame (n_ldpc=16200):
R=1/2: BCH(7200, 7032, t=12)

生成多项式: g(x) = Π g_i(x), i=1,...,t
g_i(x): GF(2) 上 α^i 的最小多项式
```

**来源**:
- ETSI EN 302 307-1 V1.4.1 §5.3.1 (BCH encoding)
- ETSI EN 302 307-1 Table 5a (BCH parameters for normal frame)
- ETSI EN 302 307-1 Table 5b (BCH parameters for short frame)

**参数配置**:
| Config | n_bch | k_bch | t | frame | R_LDPC | 来源 |
|--------|-------|-------|---|-------|--------|------|
| C1 | 32400 | 32208 | 12 | normal | 1/2 | EN 302 307 Table 5a |
| C2 | 43200 | 43040 | 10 | normal | 2/3 | EN 302 307 Table 5a |
| C3 | 48600 | 48408 | 12 | normal | 3/4 | EN 302 307 Table 5a |
| C4 | 7200 | 7032 | 12 | short | 1/2 | EN 302 307 Table 5b |

---

## 13.03 DVB-S2 PL Framing (物理层帧)

**公式**:
```
PL frame = PLHEADER + SLOTS × payload

PLHEADER (90 symbols):
  SOF (26 symbols): Barker-like 序列 (固定, 已知)
  PLSCODE (64 symbols): MODCOD + type (7 bits → 64 symbols via Reed-Muller)

Slot: 90 symbols each
Pilot block (36 symbols): 每 16 slots 插入 (optional)
π/2-BPSK 扰码: 所有 PL frame symbols

帧长 (normal, 有导频):
QPSK R=1/2: 33282 symbols
```

**来源**:
- ETSI EN 302 307-1 §5.5.1 (PL framing)
- ETSI EN 302 307-1 §5.5.2 (PL signalling: SOF + PLSCODE)
- ETSI EN 302 307-1 §5.5.4 (Physical layer scrambling)

**参数配置**:
| Config | MODCOD | frame_type | pilot | total_symbols | 来源 |
|--------|--------|-----------|-------|-------------|------|
| C1 | QPSK 1/2 | normal | yes | 33282 | EN 302 307 §5.5 |
| C2 | 8PSK 3/4 | normal | yes | 22194 | EN 302 307 |
| C3 | QPSK 1/2 | short | no | 8370 | EN 302 307 |

---

## 13.04 DVB-S2 物理层扰码

**公式**:
```
扰码序列:
R_I[n] + j·R_Q[n], 复数扰码

Gold 序列生成:
x(i+18) = x(i+7) ⊕ x(i)  (序列 1)
y(i+18) = y(i+10) ⊕ y(i+7) ⊕ y(i+5) ⊕ y(i)  (序列 2)
x 初始: [1,0,0,...,0]
y 初始: gold_code_index 决定

z_n = (x(n) ⊕ y(n)) + j·(x(n+N_offset) ⊕ y(n+N_offset))
扰码: r[n] = c[n] · (1-2·z_I[n] + j(1-2·z_Q[n])) / √2
```

**来源**:
- ETSI EN 302 307-1 §5.5.4 (Physical layer scrambling for DVB-S2)
- ETSI EN 302 307-1 §5.5.4 Eq. (24)-(27)

**参数配置**:
| Config | gold_code_index | seq_length | 应用 | 来源 |
|--------|----------------|-----------|------|------|
| C1 | 0 | 2^18-1 | DVB-S2 default | EN 302 307 §5.5.4 |
| C2 | variable | 2^18-1 | DVB-S2 multi-beam | EN 302 307 |

---

## 13.05 DVB-S2 Bit Interleaver

**公式**:
```
列交织: N_col 列, 按列写入按行读出
列数由调制阶数决定:
QPSK: 不交织
8PSK: N_col = 3
16APSK: N_col = 4
32APSK: N_col = 5

行数: N_row = n_ldpc / N_col
交织: π(r·N_col + c) = c·N_row + r
列内旋转: 不同列有不同的 twist 参数
```

**来源**:
- ETSI EN 302 307-1 §5.3.3 (Bit interleaving)
- ETSI EN 302 307-1 Table 8 (Column twist parameters)

**参数配置**:
| Config | modulation | N_col | n_ldpc | twist_params | 来源 |
|--------|-----------|-------|--------|-------------|------|
| C1 | 8PSK | 3 | 64800 | {0,0,0} | EN 302 307 Table 8 |
| C2 | 16APSK | 4 | 64800 | per rate | EN 302 307 Table 8 |
| C3 | 32APSK | 5 | 64800 | per rate | EN 302 307 Table 8 |
| C4 | 8PSK | 3 | 16200 | {0,0,0} | EN 302 307 |

---

## 13.06 DVB-T2 OFDM 参数

**公式**:
```
FFT sizes: N ∈ {1K, 2K, 4K, 8K, 16K, 32K}
Guard interval: 1/128, 1/32, 1/16, 19/256, 1/8, 19/128, 1/4

Pilot patterns: PP1~PP8 (scattered pilot 密度不同)
PP1: Dx=3, Dy=4 (每 3 个子载波, 每 4 个 symbol)
PP2: Dx=6, Dy=2

Continual pilots + scattered pilots + edge pilots
```

**来源**:
- ETSI EN 302 755 V1.4.1 §9.5 (OFDM generation for DVB-T2)
- ETSI EN 302 755 Table 64 (Pilot patterns)
- ETSI EN 302 755 Table 62 (FFT and guard interval combinations)

**参数配置**:
| Config | N_FFT | GI | pilot_pattern | BW | 来源 |
|--------|-------|----|-------------|-----|------|
| C1 | 2048 | 1/4 | PP1 | 8MHz | EN 302 755 Table 62 |
| C2 | 8192 | 1/8 | PP2 | 8MHz | EN 302 755 |
| C3 | 16384 | 1/16 | PP4 | 8MHz | EN 302 755 |
| C4 | 32768 | 1/128 | PP7 | 8MHz | EN 302 755 |

---

## 13.07 DVB-S2 APSK 星座映射

**公式**:
```
16APSK: 2 个同心环 (4+12 点)
  内环: R1, 4 点 (QPSK-like)
  外环: R2 = γ·R1, 12 点
  γ: 由码率决定 (R=2/3: γ=3.15, R=3/4: γ=2.85)

32APSK: 3 个同心环 (4+12+16 点)
  R1, R2=γ₁·R1, R3=γ₂·R1
  R=3/4: γ₁=2.84, γ₂=5.27

归一化: 平均功率 = 1
```

**来源**:
- ETSI EN 302 307-1 §5.4.3 (16APSK constellation)
- ETSI EN 302 307-1 §5.4.4 (32APSK constellation)
- ETSI EN 302 307-1 Table 9 (16APSK radius ratios)
- ETSI EN 302 307-1 Table 10 (32APSK radius ratios)

**参数配置**:
| Config | constellation | rings | γ | R_code | 来源 |
|--------|-------------|-------|---|--------|------|
| C1 | 16APSK | 4+12 | 3.15 | 2/3 | EN 302 307 Table 9 |
| C2 | 16APSK | 4+12 | 2.85 | 3/4 | EN 302 307 Table 9 |
| C3 | 16APSK | 4+12 | 2.75 | 4/5 | EN 302 307 Table 9 |
| C4 | 32APSK | 4+12+16 | 2.84, 5.27 | 3/4 | EN 302 307 Table 10 |
| C5 | 32APSK | 4+12+16 | 2.72, 4.87 | 4/5 | EN 302 307 Table 10 |

---

## 13.08 DVB-S2X 超高阶调制

**公式**:
```
DVB-S2X 扩展 (ETSI EN 302 307-2):
64APSK: 4+12+20+28 点 (4 个环)
128APSK: 近似 Gray 映射
256APSK: 4+12+20+28+44+52+64+32 (8 环)

这些星座优化为峰值功率受限通道 (卫星 HPA)
每种码率有独立的半径比和角度参数
```

**来源**:
- ETSI EN 302 307-2 V1.3.1 §5.4 (DVB-S2X constellations)
- ETSI EN 302 307-2 Table 17a~17c (64/128/256APSK parameters)

**参数配置**:
| Config | constellation | n_points | rings | 应用 | 来源 |
|--------|-------------|---------|-------|------|------|
| C1 | 64APSK | 64 | 4 | DVB-S2X | EN 302 307-2 §5.4.5 |
| C2 | 128APSK | 128 | — | DVB-S2X | EN 302 307-2 §5.4.6 |
| C3 | 256APSK | 256 | 8 | DVB-S2X | EN 302 307-2 §5.4.7 |

---

## 13.09 DVB-C QAM 解调与均衡

**公式**:
```
DVB-C (EN 300 429):
QAM 调制: 16/32/64/128/256 QAM
Roll-off: α = 0.15

接收端:
时域盲均衡: CMA (Constant Modulus Algorithm)
e[n] = |y[n]|² - R₂
R₂ = E[|a|⁴] / E[|a|²]  (Godard 常数)
w[n+1] = w[n] - μ · e[n] · y[n] · x*[n]

切换: CMA 收敛后 → DD-LMS 精调
```

**来源**:
- ETSI EN 300 429 V1.2.1 §4.3 (Signal constellation and mapping for DVB-C)
- ETSI EN 300 429 §5 (Channel coding and modulation)
- Godard, D.N., "Self-Recovering Equalization and Carrier Tracking in Two-Dimensional Data Communication Systems," IEEE Trans. Comm., 1980

**参数配置**:
| Config | QAM | symbol_rate | α | equalizer | 应用 | 来源 |
|--------|-----|-----------|---|----------|------|------|
| C1 | 64 | 6.875 MBaud | 0.15 | CMA→DD-LMS | DVB-C | EN 300 429 |
| C2 | 256 | 6.875 MBaud | 0.15 | CMA→DD-LMS | DVB-C 高速 | EN 300 429 |

---

## 13.10 DVB-T2 时间交织 (Time Interleaving)

**公式**:
```
Cell interleaving: 伪随机置换每个 FEC block 内的 cells
时间交织: 跨多个 T2 frames 分散 FEC blocks

TI depth: N_TI ∈ {1, 2, 3, ...}
Type 0: 每个 TI block 包含 1 个 FEC block
Type 1: 每个 TI block 包含多个 FEC blocks

列扭转交织 (column-twist):
N_c 列, N_r 行, 每列不同 twist offset
```

**来源**:
- ETSI EN 302 755 V1.4.1 §8.3 (Time interleaving for DVB-T2)
- ETSI EN 302 755 §8.3.1 (Cell interleaving)
- ETSI EN 302 755 §8.3.2 (Time interleaving: type 0 and type 1)

**参数配置**:
| Config | TI_type | N_TI | cell_interleaver | 应用 | 来源 |
|--------|---------|------|-----------------|------|------|
| C1 | 0 | 1 | pseudo-random | DVB-T2 基本 | EN 302 755 §8.3 |
| C2 | 1 | 3 | pseudo-random | DVB-T2 移动 | EN 302 755 §8.3 |
