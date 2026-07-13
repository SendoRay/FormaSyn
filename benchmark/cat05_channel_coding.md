# Category 5: 信道编译码 (25 kernels, 150+ configurations)

这是通信系统中硬件复杂度最高、最能体现方法价值的类别。

---

## 5.01 卷积码编码器

**公式**:
```
c₀[n] = u[n] ⊕ u[n-1] ⊕ u[n-2]           (g₀ = 111 = 7₈)
c₁[n] = u[n] ⊕ u[n-2]                     (g₁ = 101 = 5₈)
一般形式: c_j[n] = Σᵢ g_j[i] · u[n-i]  (mod 2)
```

**来源**:
- 3GPP TS 36.212 V15.9.0 §5.1.3.1 (LTE Turbo 码内含 RSC, K=4, g₀=13₈, g₁=15₈)
- IEEE 802.11-2020 §17.3.5.5 (BCC: K=7, g₀=133₈, g₁=171₈)
- CCSDS 131.0-B-4 §3.1 (K=7, Rate 1/2, g₀=171₈, g₁=133₈)
- DVB-S2 ETSI EN 302 307 (inner code option)

**参数配置**:
| Config | K | Rate | Generators | 应用 | 来源 |
|--------|---|------|-----------|------|------|
| C1 | 7 | 1/2 | (133,171)₈ | WiFi BCC | IEEE 802.11-2020 §17.3.5.5 |
| C2 | 7 | 1/2 | (171,133)₈ | CCSDS deep space | CCSDS 131.0-B-4 §3.1 |
| C3 | 4 | 1/3 | (13,15,17)₈ RSC | LTE Turbo 内码 | 3GPP TS 36.212 §5.1.3.1 |
| C4 | 7 | 3/4 | (133,171)₈ + puncture | WiFi high rate | IEEE 802.11-2020 §17.3.5.6 |
| C5 | 9 | 1/2 | (561,753)₈ | DVB-S legacy | ETSI EN 300 421 |

---

## 5.02 Viterbi 译码 — ACS 单元

**公式**:
```
Add:     PM_new[s] = PM_old[s'] + BM(s'→s)
Compare: survivor = (PM_path0 < PM_path1) ? 0 : 1
Select:  PM[s] = min(PM_path0, PM_path1)

Branch Metric (hard): BM = hamming_distance(received, expected)
Branch Metric (soft): BM = Σᵢ (1-2·expected[i]) · soft_input[i]
```

**来源**:
- Viterbi, A.J., "Error Bounds for Convolutional Codes," IEEE Trans. IT, 1967
- Forney, G.D., "The Viterbi Algorithm," Proc. IEEE, 1973
- IEEE 802.11-2020 §17.3.5.7 (Viterbi decoder for BCC)
- CCSDS 130.1-G-3 (Viterbi decoder recommended practice)

**参数配置**:
| Config | states | constraint_length | metric_width | traceback_depth | 应用 | 来源 |
|--------|--------|-------------------|-------------|-----------------|------|------|
| C1 | 64 | K=7 | 4-bit soft | 35 (5×K) | WiFi 802.11a/g | IEEE 802.11-2020 |
| C2 | 64 | K=7 | 3-bit soft | 35 | CCSDS 低功耗 | CCSDS 130.1-G-3 |
| C3 | 64 | K=7 | 8-bit soft | 96 (high perf) | WiFi 高性能 | IEEE 802.11-2020 |
| C4 | 256 | K=9 | 4-bit soft | 45 | DVB-S legacy | EN 300 421 |
| C5 | 64 | K=7 | hard (1-bit) | 35 | 极低复杂度 | CCSDS |

---

## 5.03 Turbo 编码器 (PCCC)

**公式**:
```
结构: 输入 u → RSC1(u) → c₁
              → Interleaver(u) → RSC2 → c₂
      输出: (u, c₁, c₂) systematic

RSC (K=4, g₀=13₈, g₁=15₈):
  s[n] = u[n] ⊕ s[n-1] ⊕ s[n-3]
  c[n] = s[n] ⊕ s[n-1] ⊕ s[n-2] ⊕ s[n-3]
  (feedback: g₀=1+D+D³, feedforward: g₁=1+D+D²+D³)
```

**来源**:
- Berrou, Glavieux, Thitimajshima, "Near Shannon Limit Error-Correcting Coding," ICC 1993
- 3GPP TS 36.212 V15.9.0 §5.1.3.2 (LTE Turbo 编码器完整规范)
- 3GPP TS 36.212 §5.1.3.2.3 (QPP 交织器: π(i) = (f₁·i + f₂·i²) mod N)

**参数配置**:
| Config | K (block size) | f₁ | f₂ | 应用 | 来源 |
|--------|---------------|----|----|------|------|
| C1 | 40 | 3 | 10 | LTE 最小块 | 3GPP TS 36.212 Table 5.1.3-3 |
| C2 | 128 | 15 | 32 | LTE 小块 | 3GPP TS 36.212 Table 5.1.3-3 |
| C3 | 1024 | 17 | 66 | LTE 中等块 | 3GPP TS 36.212 Table 5.1.3-3 |
| C4 | 6144 | 263 | 480 | LTE 最大块 | 3GPP TS 36.212 Table 5.1.3-3 |
| C5 | 2048 | — | — | WiMAX CTC | IEEE 802.16e §8.4.9.2.3 |

---

## 5.04 Turbo MAP 译码 — 前向递归 (α)

**公式**:
```
α_t(s) = max*_{s'} [α_{t-1}(s') + γ_t(s',s)]

其中 γ_t(s',s) = (u_s · L_a/2) + (L_c/2) · Σᵢ x_t[i] · c_t[i](s',s)

max*(a,b) = max(a,b) + ln(1+e^{-|a-b|})  [或 ≈ max(a,b)]
```

**来源**:
- Bahl, Cocke, Jelinek, Raviv, "Optimal Decoding of Linear Codes," IEEE Trans. IT, 1974 (BCJR/MAP)
- 3GPP TS 36.212 §5.1.3.2 (LTE Turbo 用 MAP/Max-Log-MAP)
- Robertson et al., "A Comparison of Optimal and Sub-optimal MAP Decoding," ICC 1995

**参数配置**:
| Config | states | metric_width | max_star_method | window_size | 来源 |
|--------|--------|-------------|-----------------|-------------|------|
| C1 | 8 (K=4) | 8-bit | Max-Log-MAP | 32 | 3GPP TS 36.212 (LTE) |
| C2 | 8 (K=4) | 10-bit | Log-MAP (LUT) | 40 | LTE 高性能 |
| C3 | 8 (K=4) | 6-bit | Max-Log-MAP | 24 | 低复杂度 |
| C4 | 16 (K=5) | 8-bit | Max-Log-MAP | 40 | WiMAX | IEEE 802.16e |

---

## 5.05 Turbo MAP 译码 — 后向递归 (β)

**公式**:
```
β_t(s) = max*_{s'} [β_{t+1}(s') + γ_{t+1}(s,s')]
```

**来源**: 同 5.04

**参数配置**: 同 5.04（结构对称，方向相反）

---

## 5.06 Turbo MAP 译码 — 外信息 (LLR)

**公式**:
```
L(u_t) = max*_{(s',s)∈S₁} [α_{t-1}(s') + γ_t(s',s) + β_t(s)]
       - max*_{(s',s)∈S₀} [α_{t-1}(s') + γ_t(s',s) + β_t(s)]

外信息: L_e(u_t) = L(u_t) - L_c · x_t^s - L_a(u_t)
```

**来源**: 同 5.04

---

## 5.07 5G NR LDPC 编码 (QC-LDPC)

**公式**:
```
校验方程: H · c^T = 0 (mod 2)
QC-LDPC: H 由 Z×Z 循环移位矩阵组成
H_BG = base graph (46×68 for BG1, 42×52 for BG2)
实际 H = expand(H_BG, Z), Z ∈ {2,3,4,...,384}

编码: p = H_p⁻¹ · H_s · s^T (利用H的近似下三角结构)
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §5.3.2 (5G NR LDPC 完整规范)
- 3GPP TS 38.212 Table 5.3.2-2 (Base Graph 1: 46 rows × 68 cols)
- 3GPP TS 38.212 Table 5.3.2-3 (Base Graph 2: 42 rows × 52 cols)
- 3GPP TS 38.212 §5.3.2 (Lifting sizes Z: {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,20,22,24,26,28,30,32,36,40,44,48,52,56,60,64,72,80,88,96,104,112,120,128,144,160,176,192,208,224,240,256,288,320,352,384})

**参数配置**:
| Config | BG | Z | K (info bits) | N (code bits) | Rate | 应用 | 来源 |
|--------|----|----|---------------|---------------|------|------|------|
| C1 | BG1 | 2 | 44 | 132 | 1/3 | 最小配置 | 3GPP TS 38.212 |
| C2 | BG1 | 24 | 528 | 1584 | 1/3 | 小块 | 3GPP TS 38.212 |
| C3 | BG1 | 64 | 1408 | 4224 | 1/3 | 中等 | 3GPP TS 38.212 |
| C4 | BG1 | 128 | 2816 | 8448 | 1/3 | 大块 | 3GPP TS 38.212 |
| C5 | BG1 | 384 | 8448 | 25344 | 1/3 | 最大块 | 3GPP TS 38.212 |
| C6 | BG1 | 384 | — | — | 8/9 | 高码率 | 3GPP TS 38.212 |
| C7 | BG2 | 24 | 240 | 1248 | ~1/5 | 小块低码率 | 3GPP TS 38.212 |
| C8 | BG2 | 384 | 3840 | 19968 | ~1/5 | 大块低码率 | 3GPP TS 38.212 |

---

## 5.08 LDPC 变量节点更新 (VN Update)

**公式**:
```
L_q(j→i) = L_ch(j) + Σ_{i'∈M(j)\i} L_r(i'→j)

优化: L_total(j) = L_ch(j) + Σ_{i'∈M(j)} L_r(i'→j)
      L_q(j→i) = L_total(j) - L_r(i→j)
```

**来源**:
- Gallager, R.G., "Low-Density Parity-Check Codes," MIT Press, 1963
- Richardson & Urbanke, "Modern Coding Theory," Cambridge, 2008, Ch. 4
- 3GPP TS 38.212 §5.3.2 (隐含在 LDPC 译码中)
- IEEE 802.11-2020 §19.3.11.6 (WiFi 6 LDPC 译码器)

**参数配置**:
| Config | dv (VN degree) | msg_width | 应用 | 来源 |
|--------|---------------|-----------|------|------|
| C1 | 2-3 (BG1 info) | 6-bit | 5G NR 信息位列 | 3GPP TS 38.212 Table 5.3.2-2 |
| C2 | 4-8 (BG1 high-degree) | 6-bit | 5G NR 高度列 | 3GPP TS 38.212 |
| C3 | 2-7 (BG2) | 6-bit | 5G NR BG2 | 3GPP TS 38.212 |
| C4 | 2-6 (802.11) | 6-bit | WiFi LDPC | IEEE 802.11-2020 |
| C5 | 2-13 (DVB-S2) | 6-bit | DVB-S2 | ETSI EN 302 307 |

---

## 5.09 LDPC 校验节点更新 — Sum-Product (BP)

**公式**:
```
L_r(i→j) = 2·atanh(Π_{j'∈N(i)\j} tanh(L_q(j'→i)/2))

等价形式 (φ函数):
L_r(i→j) = (Π_{j'∈N(i)\j} sign(L_q(j'→i))) · φ(Σ_{j'∈N(i)\j} φ(|L_q(j'→i)|))
其中 φ(x) = -ln(tanh(x/2)) = ln((e^x+1)/(e^x-1))
```

**来源**:
- Gallager 1963
- Fossorier et al., "Reduced Complexity Iterative Decoding of LDPC Codes Based on BP," IEEE Trans. Comm., 1999
- Richardson & Urbanke, Ch. 4

**参数配置**:
| Config | dc (CN degree) | msg_width | φ_method | 应用 | 来源 |
|--------|---------------|-----------|----------|------|------|
| C1 | 6-7 (BG1 typical) | 6-bit | LUT (64 entries) | 5G NR | 3GPP TS 38.212 |
| C2 | 19 (BG1 max) | 6-bit | LUT (32 entries) | 5G NR max degree | 3GPP TS 38.212 |
| C3 | 8 (BG2 typical) | 6-bit | LUT | 5G NR BG2 | 3GPP TS 38.212 |
| C4 | 6-8 (802.11n) | 5-bit | LUT | WiFi | IEEE 802.11-2020 |
| C5 | 7-30 (DVB-S2) | 6-bit | LUT | DVB-S2 | EN 302 307 Annex C |

---

## 5.10 LDPC 校验节点更新 — Min-Sum

**公式**:
```
L_r(i→j) = (Π_{j'∈N(i)\j} sign(L_q(j'→i))) · min_{j'∈N(i)\j} |L_q(j'→i)|
```

**Normalized Min-Sum**: `L_r = α · L_r_MS`, α ∈ [0.5, 0.875] typically 0.75

**Offset Min-Sum**: `L_r = max(L_r_MS - β, 0)`, β ∈ [0.15, 1.0] typically 0.5

**来源**:
- Chen & Fossorier, "Near Optimum Universal Belief Propagation Based Decoding of LDPC Codes," IEEE Trans. Comm., 2002
- Chen & Fossorier, "Density Evolution for Two Improved BP-Based Decoding Algorithms of LDPC Codes," IEEE Comm. Lett., 2002
- 3GPP TS 38.212 (实现推荐使用 Min-Sum 变体)

**参数配置**:
| Config | dc | msg_width | variant | α/β | 应用 | 来源 |
|--------|----|-----------|---------|----|------|------|
| C1 | 6-7 | 6-bit | Pure MS | — | baseline | Chen 2002 |
| C2 | 6-7 | 6-bit | NMS | α=0.75 | 5G NR typical | 3GPP impl guide |
| C3 | 19 | 6-bit | NMS | α=0.75 | 5G NR BG1 max | 3GPP impl guide |
| C4 | 6-7 | 6-bit | OMS | β=0.5 | alternative | Chen 2002 |
| C5 | 19 | 5-bit | NMS | α=0.875 | 低位宽 | Practical impl |
| C6 | 8 | 6-bit | NMS | α=0.75 | WiFi | IEEE 802.11 |
| C7 | 7-30 | 6-bit | NMS | α=0.8 | DVB-S2 | EN 302 307 |

---

## 5.11 LDPC Layered 译码 (串行更新)

**公式**:
```
Layered (行式更新):
for each row i:
  # 临时去除当前行的贡献
  L_app(j) = L_total(j) - L_r_old(i→j)
  # 更新 CN
  L_r_new(i→j) = CN_update(L_app(j') for j'∈N(i)\j)
  # 更新总 LLR
  L_total(j) = L_app(j) + L_r_new(i→j)
```

**来源**:
- Hocevar, D.E., "A Reduced Complexity Decoder Architecture via Layered Decoding of LDPC Codes," IEEE SiPS 2004
- Mansour & Shanbhag, "High-throughput LDPC decoders," IEEE Trans. VLSI, 2003
- 5G NR 实现中最常用的调度方式

**参数配置**:
| Config | BG | Z | layers | max_iterations | 来源 |
|--------|----|----|--------|---------------|------|
| C1 | BG1 | 24 | 4 (sub-matrix rows) | 8 | 3GPP typical |
| C2 | BG1 | 128 | 4 | 12 | 5G NR high perf |
| C3 | BG1 | 384 | 4 | 20 | 5G NR max config |
| C4 | BG2 | 128 | 4 | 8 | 5G NR small block |

---

## 5.12 5G NR Polar 编码

**公式**:
```
x = u · G_N (mod 2)
G_N = B_N · F^(⊗n)
F = [1 0; 1 1], F^(⊗n) = F ⊗ F ⊗ ... ⊗ F (n次Kronecker积)
B_N: bit-reversal permutation matrix

信息位集合 A 由可靠性排序确定 (3GPP 指定序列)
u_i = 0 for i ∉ A (frozen bits)
```

**来源**:
- Arıkan, E., "Channel Polarization: A Method for Constructing Capacity-Achieving Codes," IEEE Trans. IT, 2009
- 3GPP TS 38.212 V17.3.0 §5.3.1 (5G NR Polar 编码完整规范)
- 3GPP TS 38.212 §5.3.1.2 (可靠性序列 Table 5.3.1.2-1, N_max=1024)
- 3GPP TS 38.212 §5.3.1.1 (信息位分配规则)

**参数配置**:
| Config | N | K | E (rate-matched) | CRC | 应用 | 来源 |
|--------|---|---|-----------------|-----|------|------|
| C1 | 32 | 12 | 32 | CRC-6 | UCI (1-2 bits HARQ-ACK) | 3GPP TS 38.212 §5.3.1 |
| C2 | 64 | 20 | 64 | CRC-6 | UCI small | 3GPP TS 38.212 |
| C3 | 128 | 54 | 128 | CRC-11 | PDCCH (DCI) | 3GPP TS 38.212 §5.3.1 |
| C4 | 256 | 108 | 256 | CRC-11 | PDCCH medium | 3GPP TS 38.212 |
| C5 | 512 | 140 | 512 | CRC-24C | PBCH (MIB) | 3GPP TS 38.212 §7.1.1 |
| C6 | 1024 | 512 | 1024 | CRC-11 | large DCI | 3GPP TS 38.212 |

---

## 5.13 Polar SC 译码

**公式**:
```
f(a, b) = sign(a) · sign(b) · min(|a|, |b|)  [min-sum 近似]
         ≈ 2·atanh(tanh(a/2)·tanh(b/2))      [exact]

g(a, b, u) = (1-2u)·a + b

SC decoding: 从根到叶逐位判决
û_i = 0 if i ∈ frozen, else hard_decision(LLR_i)
```

**来源**:
- Arıkan 2009
- 3GPP TS 38.212 §5.3.1 (Polar 译码, SC 为基础算法)
- Leroux et al., "A Semi-Parallel Successive-Cancellation Decoder for Polar Codes," IEEE Trans. SP, 2013

**参数配置**:
| Config | N | f_function | data_width | 应用 | 来源 |
|--------|---|-----------|------------|------|------|
| C1 | 32 | min-sum approx | 6-bit | 小码长 UCI | 3GPP TS 38.212 |
| C2 | 128 | min-sum approx | 6-bit | PDCCH | 3GPP TS 38.212 |
| C3 | 256 | min-sum approx | 8-bit | PDCCH high perf | 3GPP TS 38.212 |
| C4 | 512 | min-sum approx | 6-bit | PBCH | 3GPP TS 38.212 |
| C5 | 1024 | min-sum approx | 8-bit | max N | 3GPP TS 38.212 |

---

## 5.14 Polar SCL 译码

**公式**:
```
维护 L 条路径：
at each bit position i:
  if i is frozen: extend all paths with u=0
  else: split each path into u=0 and u=1 (total 2L paths)
  
Path metric: PM[l] += ln(1 + e^{-(1-2û)·LLR})
            ≈ |LLR| if decision wrong, 0 if correct (max-log approx)

Sort by PM, keep best L paths
Final: check CRC on surviving paths, select path passing CRC
```

**来源**:
- Tal & Vardy, "List Decoding of Polar Codes," IEEE Trans. IT, 2015
- Niu & Chen, "CRC-Aided Decoding of Polar Codes," IEEE Comm. Lett., 2012
- 3GPP TS 38.212 §5.3.1 (5G NR Polar 使用 CA-SCL 译码, L=8 typical)
- Hashemi et al., "Fast SCL Decoding of Polar Codes," IEEE Trans. SP, 2017

**参数配置**:
| Config | N | L (list size) | CRC | metric_width | 应用 | 来源 |
|--------|---|--------------|-----|-------------|------|------|
| C1 | 128 | 4 | CRC-11 | 8-bit | PDCCH low-complexity | 3GPP impl |
| C2 | 128 | 8 | CRC-11 | 8-bit | PDCCH standard | 3GPP TS 38.212 |
| C3 | 256 | 8 | CRC-11 | 8-bit | large DCI | 3GPP TS 38.212 |
| C4 | 512 | 8 | CRC-24C | 8-bit | PBCH | 3GPP TS 38.212 |
| C5 | 1024 | 4 | CRC-11 | 6-bit | 低复杂度 | 3GPP |
| C6 | 1024 | 16 | CRC-11 | 10-bit | 高性能 | Research |

---

## 5.15 RS(255,223) 编码 (CCSDS)

**公式**:
```
生成多项式: g(x) = Π_{i=128}^{159} (x - α^i) over GF(2⁸)
编码: c(x) = m(x)·x^32 + [m(x)·x^32 mod g(x)]
α: primitive element of GF(2⁸) with p(x) = x⁸+x⁷+x²+x+1
```

**来源**:
- CCSDS 131.0-B-4 §4 (Reed-Solomon Coding, interleaving depth I=1,2,3,4,5,8)
- DVB-S2 ETSI EN 302 307 (外码 RS 选项, 已被 BCH 取代但仍在旧系统)
- ITU-T G.709 (OTN: RS(255,239))

**参数配置**:
| Config | (N,K) | t (纠错能力) | GF | 应用 | 来源 |
|--------|-------|-------------|-----|------|------|
| C1 | (255,223) | 16 | GF(2⁸) | 深空通信 | CCSDS 131.0-B-4 §4 |
| C2 | (255,239) | 8 | GF(2⁸) | OTN 光通信 | ITU-T G.709 |
| C3 | (204,188) | 8 | GF(2⁸) | DVB-T 缩短 RS | ETSI EN 300 744 |
| C4 | (255,191) | 32 | GF(2⁸) | 高纠错 | CCSDS option |

---

## 5.16 RS 译码 — Berlekamp-Massey 算法

**公式**:
```
输入: syndrome S₁,...,S₂ₜ (S_j = Σᵢ rᵢ·α^(ij) over GF)

BM 迭代:
for μ = 0 to 2t-1:
  Δ = S_{μ+1} + Σ_{i=1}^{L} σ_i · S_{μ+1-i}   [discrepancy]
  if Δ ≠ 0:
    if 2L ≤ μ: σ(x) = σ(x) - Δ·Δ_prev⁻¹·x^(μ-ρ)·σ_prev(x); L = μ+1-L
    else: σ(x) = σ(x) - Δ·Δ_prev⁻¹·x^(μ-ρ)·σ_prev(x)

输出: 错误定位多项式 σ(x)
```

**来源**:
- Berlekamp, E., "Algebraic Coding Theory," McGraw-Hill, 1968
- Massey, J.L., "Shift-Register Synthesis and BCH Decoding," IEEE Trans. IT, 1969
- CCSDS 131.0-B-4 (RS decoder specification)
- Blahut, R., "Theory and Practice of Error Control Codes," Addison-Wesley, 1983

**参数配置**:
| Config | t | GF(2^m) | 应用 | 来源 |
|--------|---|---------|------|------|
| C1 | 16 | GF(2⁸) | CCSDS RS(255,223) | CCSDS 131.0-B-4 |
| C2 | 8 | GF(2⁸) | ITU-T G.709 RS(255,239) | ITU-T G.709 |
| C3 | 8 | GF(2⁸) | DVB-T RS(204,188) | EN 300 744 |

---

## 5.17 DVB-S2 BCH 编码/译码

**公式**:
```
BCH over GF(2^16):
g(x) = LCM(m₁(x), m₂(x), ..., m_t(x))
m_i(x): minimal polynomial of α^i

t = 8,10,12 depending on LDPC code rate
```

**来源**:
- ETSI EN 302 307 V1.4.1 §5.3 (DVB-S2 BCH outer code)
- ETSI EN 302 755 (DVB-T2 BCH)
- Lin & Costello, Ch. 6

**参数配置**:
| Config | n_bch | t | 配合的LDPC码率 | 来源 |
|--------|-------|---|--------------|------|
| C1 | 16200 | 12 | 1/4, 1/3, 2/5 | EN 302 307 Table 5a |
| C2 | 16200 | 10 | 1/2, 3/5, 2/3, 3/4 | EN 302 307 Table 5a |
| C3 | 64800 | 12 | 1/4, 1/3, 2/5 | EN 302 307 Table 5a |
| C4 | 64800 | 10 | 1/2, 3/5, 2/3 | EN 302 307 Table 5a |
| C5 | 64800 | 8 | 3/4, 4/5, 5/6, 8/9, 9/10 | EN 302 307 Table 5a |

---

## 5.18 DVB-S2 LDPC 编码

**公式**:
```
QC-LDPC with accumulator structure:
p₀ = ⊕_{i∈Row0} s_i
p₁ = p₀ ⊕ (⊕_{i∈Row1} s_i)
...
p_j = p_{j-1} ⊕ (⊕_{i∈Rowj} s_i)

地址生成: x + q·m mod (N-K), q = (N-K)/360
```

**来源**:
- ETSI EN 302 307 V1.4.1 §5.3.2 (DVB-S2 LDPC)
- ETSI EN 302 307 Annex C (Address generation for parity accumulation)
- Eroz, Sun, Lee, "DVB-S2 LDPC Encoder," U.S. Patent 2004

**参数配置**:
| Config | N | K | Rate | 来源 |
|--------|---|---|------|------|
| C1 | 64800 | 32400 | 1/2 | EN 302 307 Table B.1 |
| C2 | 64800 | 43200 | 2/3 | EN 302 307 Table B.5 |
| C3 | 64800 | 48600 | 3/4 | EN 302 307 Table B.7 |
| C4 | 64800 | 58320 | 9/10 | EN 302 307 Table B.11 |
| C5 | 16200 | 8100 | 1/2 | EN 302 307 Table B.12 (short) |
| C6 | 16200 | 12600 | 7/8 | EN 302 307 (short, high rate) |

---

## 5.19 5G NR LDPC Rate Matching

**公式**:
```
循环缓冲器 Rate Matching:
for k = 0 to E-1:
  e[k] = d[(k₀ + k) mod N_cb]  (with null filler bit skipping)

k₀ 取决于冗余版本 rv ∈ {0, 1, 2, 3}
N_cb = min(N, Ncb_max)
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §5.4.2.1 (LDPC rate matching)
- 3GPP TS 38.212 Table 5.4.2.1-2 (rv offset table)

**参数配置**:
| Config | N | E | rv | BG | Z | 来源 |
|--------|---|---|----|----|---|------|
| C1 | 1584 | 792 | 0 | BG1 | 24 | 3GPP (rate 1/2) |
| C2 | 8448 | 2816 | 0 | BG1 | 128 | 3GPP (rate 1/3) |
| C3 | 8448 | 6336 | 0 | BG1 | 128 | 3GPP (rate 3/4) |
| C4 | 8448 | 2816 | 1 | BG1 | 128 | 3GPP (rv=1, HARQ retx) |

---

## 5.20 交织器 — QPP (Quadratic Permutation Polynomial)

**公式**:
```
π(i) = (f₁·i + f₂·i²) mod N
逆交织: π⁻¹ 通过查表或在线计算
```

**来源**:
- 3GPP TS 36.212 V15.9.0 §5.1.3.2.3 (LTE Turbo 交织器)
- 3GPP TS 36.212 Table 5.1.3-3 (188 组 (f₁, f₂) 参数, N=40~6144)
- Sun & Takeshita, "Interleavers for Turbo Codes Using Permutation Polynomials Over Integer Rings," IEEE Trans. IT, 2005

**参数配置**:
| Config | N | f₁ | f₂ | 来源 |
|--------|---|----|----|------|
| C1 | 40 | 3 | 10 | 3GPP TS 36.212 Table 5.1.3-3 |
| C2 | 128 | 15 | 32 | 3GPP TS 36.212 Table 5.1.3-3 |
| C3 | 256 | 15 | 32 | 3GPP TS 36.212 Table 5.1.3-3 |
| C4 | 512 | 25 | 64 | 3GPP TS 36.212 Table 5.1.3-3 |
| C5 | 1024 | 17 | 66 | 3GPP TS 36.212 Table 5.1.3-3 |
| C6 | 2048 | 127 | 64 | 3GPP TS 36.212 Table 5.1.3-3 |
| C7 | 4096 | 15 | 514 | 3GPP TS 36.212 Table 5.1.3-3 |
| C8 | 6144 | 263 | 480 | 3GPP TS 36.212 Table 5.1.3-3 |

---

## 5.21 循环移位网络 (Barrel Rotator for QC-LDPC)

**公式**:
```
y = circular_shift(x, s)
y[i] = x[(i+s) mod Z]

实现: QSN (Quasi-cyclic Shift Network) 基于 Benes/Barrel 网络
```

**来源**:
- 3GPP TS 38.212 §5.3.2 (QC-LDPC 需要 Z×Z 循环移位)
- Chen et al., "Overlapped Message Passing for QC-LDPC Codes," IEEE Trans. Circuits Syst. I, 2004
- Zhang & Fossorier, "Shuffled Iterative Decoding," IEEE Trans. Comm., 2005

**参数配置**:
| Config | Z | data_width | 应用 | 来源 |
|--------|---|-----------|------|------|
| C1 | 24 | 6-bit×24 | 5G NR min Z | 3GPP TS 38.212 |
| C2 | 64 | 6-bit×64 | 5G NR medium Z | 3GPP TS 38.212 |
| C3 | 128 | 6-bit×128 | 5G NR | 3GPP TS 38.212 |
| C4 | 256 | 6-bit×256 | 5G NR large Z | 3GPP TS 38.212 |
| C5 | 384 | 6-bit×384 | 5G NR max Z | 3GPP TS 38.212 |
| C6 | 360 | 6-bit×360 | DVB-S2 | EN 302 307 |

---

## 5.22 LFSR 序列生成器 (m-序列 / Gold 序列)

**公式**:
```
m-序列: s[n] = Σᵢ cᵢ·s[n-i] (mod 2), 周期 2^m - 1
Gold 序列: g[n] = s₁[n] ⊕ s₂[n], 两个 m-序列模2加

5G NR: c(n) = (x₁(n+Nc) + x₂(n+Nc)) mod 2, Nc=1600
x₁(n+31) = (x₁(n+3) + x₁(n)) mod 2
x₂(n+31) = (x₂(n+3) + x₂(n+2) + x₂(n+1) + x₂(n)) mod 2
```

**来源**:
- 3GPP TS 38.211 V17.3.0 §5.2.1 (Pseudo-random sequence generation)
- 3GPP TS 36.211 §7.2 (LTE Gold sequence)
- Gold, R., "Optimal Binary Sequences for Spread Spectrum Multiplexing," IEEE Trans. IT, 1967

**参数配置**:
| Config | m | init (c_init) | length | 应用 | 来源 |
|--------|---|-------------|--------|------|------|
| C1 | 31 | cell_id dependent | 可变 | 5G NR scrambling | 3GPP TS 38.211 §5.2.1 |
| C2 | 31 | RNTI dependent | 可变 | 5G NR PDSCH scrambling | 3GPP TS 38.211 §7.3.1.1 |
| C3 | 31 | slot/symbol dependent | 可变 | 5G NR DMRS | 3GPP TS 38.211 §7.4.1.1.1 |
| C4 | 31 | — | 可变 | LTE Reference Signal | 3GPP TS 36.211 §7.2 |

---

## 5.23 Polar Rate Matching (Bit Selection)

**公式**:
```
Sub-block interleaving + Bit selection:

Sub-block interleaver: J[n] = BIL[n] (bit-reversal interleave pattern)
Bit selection:
  if E ≥ N: repetition
  if K/E ≤ 7/16: puncturing (from beginning)
  else: shortening (from end)
```

**来源**:
- 3GPP TS 38.212 V17.3.0 §5.4.1 (Polar rate matching)
- 3GPP TS 38.212 §5.4.1.1 (Sub-block interleaver)
- 3GPP TS 38.212 §5.4.1.2 (Bit selection)

**参数配置**:
| Config | N | E | K | method | 来源 |
|--------|---|---|---|--------|------|
| C1 | 128 | 64 | 54 | puncture | 3GPP TS 38.212 |
| C2 | 256 | 128 | 108 | puncture | 3GPP TS 38.212 |
| C3 | 512 | 1024 | 140 | repetition | 3GPP TS 38.212 |
| C4 | 256 | 192 | 200 | shorten | 3GPP TS 38.212 |

---

## 5.24 WiFi LDPC (IEEE 802.11)

**公式**: 同 QC-LDPC，但使用 802.11 特定的基矩阵

**来源**:
- IEEE 802.11-2020 §19.3.11.6 (LDPC encoding)
- IEEE 802.11-2020 Tables 19-30 to 19-41 (Parity-check matrices)
- Code lengths: 648, 1296, 1944
- Code rates: 1/2, 2/3, 3/4, 5/6

**参数配置**:
| Config | N | Rate | Z | 应用 | 来源 |
|--------|---|------|---|------|------|
| C1 | 648 | 1/2 | 27 | 802.11n 20MHz | IEEE 802.11-2020 Table 19-30 |
| C2 | 648 | 3/4 | 27 | 802.11n high rate | IEEE 802.11-2020 Table 19-32 |
| C3 | 1296 | 1/2 | 54 | 802.11n 40MHz | IEEE 802.11-2020 Table 19-34 |
| C4 | 1296 | 5/6 | 54 | 802.11ac high rate | IEEE 802.11-2020 Table 19-37 |
| C5 | 1944 | 1/2 | 81 | 802.11ac/ax | IEEE 802.11-2020 Table 19-38 |
| C6 | 1944 | 3/4 | 81 | 802.11ax typical | IEEE 802.11-2020 Table 19-40 |
| C7 | 1944 | 5/6 | 81 | 802.11ax high rate | IEEE 802.11-2020 Table 19-41 |

---

## 5.25 HARQ 软合并

**公式**:
```
Chase Combining (CC): L_combined[i] = L₁[i] + L₂[i] + ... + L_M[i]
Incremental Redundancy (IR): 不同 rv 提供不同校验位, 合并后重新译码

存储: 需要 soft buffer 存储之前传输的 LLR
```

**来源**:
- 3GPP TS 38.212 §5.4.2 (LDPC HARQ with rv=0,1,2,3)
- 3GPP TS 38.214 §5.1.1 (HARQ-ACK 和 NDI 机制)
- Chase, D., "Code Combining," IEEE Trans. IT, 1985

**参数配置**:
| Config | buffer_size | msg_width | max_combining | 应用 | 来源 |
|--------|------------|-----------|--------------|------|------|
| C1 | 8448 | 6-bit | 4 (rv 0-3) | 5G NR BG1 | 3GPP TS 38.212 |
| C2 | 3840 | 6-bit | 4 | 5G NR BG2 | 3GPP TS 38.212 |
| C3 | 6144 | 5-bit | 8 | LTE Turbo | 3GPP TS 36.212 |
