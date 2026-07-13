# Category 3: 变换域运算 (15 kernels, 90+ configurations)

---

## 3.01 FFT Radix-2 DIT 蝶形单元

**公式**:
```
X = A + W_N^k · B
Y = A - W_N^k · B

其中 W_N^k = e^{-j2πk/N} = cos(2πk/N) - j·sin(2πk/N)
展开: 需要 1 个复数乘法 + 2 个复数加法
```

**来源**:
- Cooley & Tukey, "An Algorithm for the Machine Calculation of Complex Fourier Series," Math. Comp., 1965
- 3GPP TS 38.211 §5.3.1 (OFDM 需要 FFT/IFFT)
- IEEE 802.11-2020 §17.3.10.6 (OFDM FFT processing)

**参数配置**:
| Config | N | data_width | twiddle_width | 应用 | 来源 |
|--------|---|------------|--------------|------|------|
| C1 | 64 | 16-bit | 16-bit | WiFi 802.11a/g 20MHz | IEEE 802.11-2020 §17.3.10 |
| C2 | 128 | 16-bit | 16-bit | WiFi 802.11n 40MHz (half) | IEEE 802.11-2020 |
| C3 | 256 | 16-bit | 16-bit | WiFi 802.11ac 80MHz (half) | IEEE 802.11-2020 |
| C4 | 512 | 16-bit | 16-bit | LTE 5MHz | 3GPP TS 36.211 §5.6 |
| C5 | 1024 | 16-bit | 16-bit | LTE 10MHz / WiFi 802.11ax 80MHz | 3GPP / IEEE |
| C6 | 2048 | 16-bit | 16-bit | LTE 20MHz | 3GPP TS 36.211 §5.6 |
| C7 | 4096 | 16-bit | 18-bit | 5G NR 100MHz (SCS=30kHz) | 3GPP TS 38.211 §5.3.1 |
| C8 | 4096 | 16-bit | 18-bit | 5G NR 100MHz (SCS=15kHz) — N=8192 时用 Radix-2 拆分 | 3GPP TS 38.211 |

---

## 3.02 FFT Radix-4 蝶形单元

**公式**:
```
X₀ = A₀ + A₁ + A₂ + A₃
X₁ = A₀ - jA₁ - A₂ + jA₃
X₂ = A₀ - A₁ + A₂ - A₃
X₃ = A₀ + jA₁ - A₂ - jA₃

乘以 ±j: 实虚交换+取反 (无乘法器)
每个 Radix-4 蝶形: 3 个非平凡复数乘法 + 8 个复数加法
vs 等效的 2 个 Radix-2 级: 4 个复数乘法 + 8 个复数加法 → 节省 25% 乘法
```

**来源**:
- Rabiner & Gold, "Theory and Application of Digital Signal Processing," 1975, Ch. 6
- He & Torkelson, "A New Approach to Pipeline FFT Processor," IPPS 1996
- 多数商用 OFDM 芯片使用 Radix-4 或 Mixed-Radix

**参数配置**:
| Config | N | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 64 | 16-bit | WiFi (64=4³) | IEEE 802.11 |
| C2 | 256 | 16-bit | WiFi 80MHz (256=4⁴) | IEEE 802.11ac |
| C3 | 1024 | 16-bit | LTE 10MHz (1024=4⁵) | 3GPP TS 36.211 |
| C4 | 4096 | 16-bit | 5G NR (4096=4⁶) | 3GPP TS 38.211 |

---

## 3.03 FFT 流水线型 — SDF (Single-path Delay Feedback)

**公式**:
```
Radix-2 SDF: log₂(N) 个蝶形级, 每级一个蝶形处理器
存储: 第 s 级有 N/2^s 个延迟单元 (反馈路径)
总存储: N-1 个复数
吞吐率: 1 sample/cycle (连续流)

控制: (log₂(N))-bit 计数器驱动各级的输入/输出切换
```

**来源**:
- He & Torkelson, "A New Approach to Pipeline FFT Processor," IPPS 1996
- Wold & Despain, "Pipeline and Parallel-Pipeline FFT Processors for VLSI Implementations," IEEE Trans. Comp., 1984
- 广泛用于 OFDM 基带芯片 (连续流处理要求)

**参数配置**:
| Config | N | radix | pipeline_stages | 应用 | 来源 |
|--------|---|-------|----------------|------|------|
| C1 | 64 | R2SDF | 6 stages | WiFi | He 1996 |
| C2 | 64 | R4SDF | 3 stages | WiFi (fewer stages) | He 1996 |
| C3 | 256 | R2²SDF | 4 stages | WiFi 80MHz | He 1996 |
| C4 | 1024 | R2SDF | 10 stages | LTE 10MHz | 通用 |
| C5 | 2048 | R4SDF + R2 | 6 stages | LTE 20MHz | 3GPP baseband |
| C6 | 4096 | R4SDF | 6 stages | 5G NR | 3GPP baseband |

---

## 3.04 FFT 存储器型 (In-Place)

**公式**:
```
In-place 运算: 同一存储位置读出→蝶形→写回
地址生成: bit-reversal pattern

双缓冲: Buffer A 做运算, Buffer B 接收新数据
地址: stage s, butterfly b → addr = bit_reverse(b, s)
```

**来源**:
- Oppenheim & Schafer, "Discrete-Time Signal Processing," 3rd Ed, Ch. 9
- 适用于面积敏感设计 (只需 1-2 个蝶形单元, 复用处理)

**参数配置**:
| Config | N | butterflies | memory | 应用 |
|--------|---|------------|--------|------|
| C1 | 256 | 1 | 256×2 (双缓冲) | 低面积 WiFi |
| C2 | 1024 | 1 | 1024×2 | 低面积 LTE |
| C3 | 4096 | 4 | 4096×2 | 5G NR (面积优化) |

---

## 3.05 IFFT (逆快速傅里叶变换)

**公式**:
```
x[n] = (1/N) · Σ_{k=0}^{N-1} X[k] · e^{j2πkn/N}

利用: IFFT(X) = conj(FFT(conj(X))) / N
或:   IFFT(X) = FFT(X*)* / N
实现: 复用 FFT 硬件 + 输入共轭 + 输出共轭 + 除以 N (移位)
```

**来源**:
- 3GPP TS 38.211 §5.3.1 (OFDM 发射: IFFT)
- IEEE 802.11-2020 §17.3.10.4 (OFDM transmitter)
- 所有 OFDM 系统发射端必须

**参数配置**: 同 3.01-3.04（复用 FFT 硬件）

---

## 3.06 Mixed-Radix FFT (非2幂点数)

**公式**:
```
5G NR FFT sizes (3GPP TS 38.211 Table 5.3.1-1):
N = 2^a · 3^b · 5^c, 其中 a,b,c ≥ 0

例: N = 12 = 2²×3, N = 36 = 2²×3², N = 60 = 2²×3×5
    N = 180 = 2²×3²×5, N = 300 = 2²×3×5², N = 1500 = 2²×3×5³

Radix-3 蝶形: X₀ = A+B+C, X₁ = A+W₃B+W₃²C, X₂ = A+W₃²B+W₃⁴C
Radix-5 蝶形: 类似, 用 W₅ 的幂次
```

**来源**:
- 3GPP TS 38.211 V17.3.0 Table 5.3.1-1 (所有合法 NR FFT 大小)
- Singleton, R.C., "An Algorithm for Computing the Mixed Radix FFT," IEEE Trans. Audio, 1969
- Winograd, S., "On Computing the DFT," Math. Comp., 1978

**参数配置**:
| Config | N | factorization | 应用 | 来源 |
|--------|---|--------------|------|------|
| C1 | 12 | 2²×3 | NR 最小 | 3GPP TS 38.211 Table 5.3.1-1 |
| C2 | 24 | 2³×3 | NR | 3GPP TS 38.211 |
| C3 | 36 | 2²×3² | NR | 3GPP TS 38.211 |
| C4 | 60 | 2²×3×5 | NR | 3GPP TS 38.211 |
| C5 | 72 | 2³×3² | NR | 3GPP TS 38.211 |
| C6 | 128 | 2⁷ | NR / LTE | 3GPP |
| C7 | 180 | 2²×3²×5 | NR | 3GPP TS 38.211 |
| C8 | 300 | 2²×3×5² | NR | 3GPP TS 38.211 |
| C9 | 512 | 2⁹ | LTE 5MHz | 3GPP TS 36.211 |
| C10 | 1024 | 2¹⁰ | LTE 10MHz | 3GPP TS 36.211 |
| C11 | 1536 | 2⁹×3 | NR | 3GPP TS 38.211 |
| C12 | 2048 | 2¹¹ | LTE 20MHz | 3GPP TS 36.211 |
| C13 | 3072 | 2¹⁰×3 | NR | 3GPP TS 38.211 |
| C14 | 4096 | 2¹² | NR 100MHz | 3GPP TS 38.211 |

---

## 3.07 DCT-II (8点, 用于图像/视频压缩)

**公式**:
```
X[k] = Σ_{n=0}^{N-1} x[n] · cos(π(2n+1)k / (2N)), k=0,...,N-1

8-point Chen's fast algorithm: 只需 11 次乘法 + 29 次加法
(vs 直接计算 64 次乘法)
```

**来源**:
- Chen, Smith, Fralick, "A Fast Computational Algorithm for the DCT," IEEE Trans. Comm., 1977
- Lee, B., "A New Algorithm to Compute the DCT," IEEE Trans. ASSP, 1984
- ITU-T H.264 §8.5 (视频编码中的 4×4/8×8 DCT 变换)
- JPEG ISO/IEC 10918-1 (8×8 DCT)

**参数配置**:
| Config | N | method | data_width | 应用 | 来源 |
|--------|---|--------|------------|------|------|
| C1 | 8 | Chen | 16-bit | JPEG/H.264 | ITU-T H.264 |
| C2 | 4 | butterfly | 16-bit | H.264 4×4 | ITU-T H.264 §8.5 |
| C3 | 8 | Lee | 18-bit | 高精度 | Lee 1984 |
| C4 | 16 | cascade | 16-bit | H.265 | ITU-T H.265 |

---

## 3.08 Walsh-Hadamard 变换 (WHT)

**公式**:
```
Y = H_N · X
H_2 = [1  1; 1 -1]
H_{2N} = [H_N  H_N; H_N  -H_N]  (Kronecker 构造)

蝶形: 只有加减法, 无乘法
N 点 WHT: N·log₂(N)/2 次加法
```

**来源**:
- 3GPP TS 36.211 §6.3.3.3 (LTE PUCCH Format 1: 4-point DFT, 类似 WHT)
- CDMA2000 (IS-2000): Walsh 码扩频
- IEEE 802.11b §15.2.3 (CCK 调制中的 Walsh 变换)

**参数配置**:
| Config | N | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 4 | 16-bit | LTE PUCCH | 3GPP TS 36.211 |
| C2 | 8 | 16-bit | CCK | IEEE 802.11b |
| C3 | 16 | 16-bit | CDMA Walsh | IS-2000 |
| C4 | 64 | 16-bit | CDMA | IS-2000 |

---

## 3.09 Goertzel 算法 (单频 DFT)

**公式**:
```
s[n] = x[n] + 2cos(2πk/N)·s[n-1] - s[n-2]
初始: s[-1] = s[-2] = 0

处理完 N 个样本后:
X[k] = s[N-1] - e^{-j2πk/N}·s[N-2]
|X[k]|² = s[N-1]² + s[N-2]² - 2cos(2πk/N)·s[N-1]·s[N-2]
```

**来源**:
- Goertzel, G., "An Algorithm for the Evaluation of Finite Trigonometric Series," Amer. Math. Monthly, 1958
- 应用: DTMF 检测 (ITU-T Q.24: 8 个频率, N≈200 @8kHz)
- 应用: 单频功率检测

**参数配置**:
| Config | N | num_freqs | data_width | 应用 | 来源 |
|--------|---|-----------|------------|------|------|
| C1 | 205 | 8 | 16-bit | DTMF 检测 | ITU-T Q.24 |
| C2 | 128 | 1 | 16-bit | 单频率 | 通用 |
| C3 | 256 | 4 | 16-bit | 多频检测 | 通用 |

---

## 3.10 DFT (直接计算, 小点数)

**公式**:
```
X[k] = Σ_{n=0}^{N-1} x[n] · W_N^{nk}, W_N = e^{-j2π/N}
O(N²) 复杂度, 但小 N 时可能比 FFT 更高效 (无控制开销)
```

**来源**:
- 3GPP TS 38.211 §5.3 (DFT-s-OFDM 中小点数 DFT: N=12 的倍数)
- 3GPP TS 36.211 §5.6 (SC-FDMA: DFT precoding, M=12~1200)

**参数配置**:
| Config | N | data_width | 应用 | 来源 |
|--------|---|------------|------|------|
| C1 | 12 | 16-bit | 1 RB DFT precoding | 3GPP TS 38.211 §5.3 |
| C2 | 24 | 16-bit | 2 RB | 3GPP TS 38.211 |
| C3 | 36 | 16-bit | 3 RB | 3GPP TS 38.211 |
| C4 | 6 | 16-bit | 半 RB | 3GPP |

---

## 3.11 Chirp-Z 变换 (Bluestein's Algorithm)

**公式**:
```
将任意 N 点 DFT 转化为长度为 M≥2N-1 的卷积:
X[k] = W_N^{k²/2} · Σ_n [x[n]·W_N^{n²/2}] · W_N^{-(n-k)²/2}

= W_N^{k²/2} · IFFT{ FFT{x·chirp_in} · FFT{chirp_ref} }
```

**来源**:
- Bluestein, L., "A Linear Filtering Approach to the Computation of the DFT," IEEE Trans. Audio, 1970
- Rabiner, Schafer, Rader, "The Chirp-Z Transform Algorithm," IEEE Trans. Audio, 1969
- 应用: 非2幂 FFT 实现 (将非2幂 N 嵌入到 2幂长度卷积中)

**参数配置**:
| Config | N (原始) | M (FFT length) | 应用 | 来源 |
|--------|---------|----------------|------|------|
| C1 | 12 | 32 | NR DFT precoding (小N) | 3GPP via Bluestein |
| C2 | 36 | 128 | NR DFT precoding | 3GPP via Bluestein |
| C3 | 300 | 1024 | NR 大 DFT | 3GPP via Bluestein |

---

## 3.12 STFT (短时傅里叶变换)

**公式**:
```
X[m,k] = Σ_{n=0}^{L-1} w[n] · x[n + mH] · e^{-j2πkn/N}

m: 帧索引, H: hop size, L: 窗长, w[n]: 窗函数
实现: 分帧 → 加窗 → FFT
```

**来源**:
- Allen, J.B., "Short-Term Spectral Analysis, Synthesis, and Modification by DFT," IEEE Trans. ASSP, 1977
- 3GPP TS 26.445 (EVS codec: MDCT/STFT-based analysis)
- 应用: 语音编码分析、频谱感知 (SDR)

**参数配置**:
| Config | L (window) | N (FFT) | H (hop) | 应用 | 来源 |
|--------|-----------|---------|---------|------|------|
| C1 | 256 | 256 | 128 | 语音分析 (16kHz) | 3GPP TS 26.445 |
| C2 | 512 | 512 | 256 | 宽带语音 | EVS codec |
| C3 | 1024 | 1024 | 512 | 频谱感知 | SDR |

---

## 3.13 离散 Hartley 变换 (DHT)

**公式**:
```
X[k] = Σ_{n=0}^{N-1} x[n] · cas(2πkn/N)
cas(θ) = cos(θ) + sin(θ)

DHT 是实数到实数的变换, 可用于实信号频谱分析
与 DFT 的关系: X_DFT[k] = (X_DHT[k] + X_DHT[N-k])/2 - j(X_DHT[k] - X_DHT[N-k])/2
```

**来源**:
- Bracewell, R.N., "The Discrete Hartley Transform," JOSA, 1983
- 应用: 实信号频谱分析 (无需复数运算)

**参数配置**:
| Config | N | data_width | 应用 |
|--------|---|------------|------|
| C1 | 256 | 16-bit | 实信号频谱 |
| C2 | 1024 | 16-bit | 宽带分析 |

---

## 3.14 Number Theoretic Transform (NTT)

**公式**:
```
X[k] = Σ_{n=0}^{N-1} x[n] · g^{nk} mod p
g: primitive N-th root of unity modulo p
无浮点/定点误差 — 精确整数运算
```

**来源**:
- Agarwal & Burrus, "Number Theoretic Transforms to Implement Fast Digital Convolution," Proc. IEEE, 1975
- 应用: 精确卷积 (长 FIR 滤波)
- 应用: 后量子密码学 (Kyber/Dilithium, NIST PQC 标准)

**参数配置**:
| Config | N | p (modulus) | 应用 | 来源 |
|--------|---|-------------|------|------|
| C1 | 256 | 7681 | Kyber | NIST FIPS 203 |
| C2 | 256 | 8380417 | Dilithium | NIST FIPS 204 |
| C3 | 1024 | 12289 | NewHope (legacy) | PQC research |

---

## 3.15 Sliding DFT (滑动 DFT)

**公式**:
```
X_{new}[k] = (X_{old}[k] - x[n-N] + x[n]) · W_N^k
每个新样本只需 1 次复数乘法 + 2 次复数加法 per bin
```

**来源**:
- Jacobsen & Lyons, "The Sliding DFT," IEEE Signal Processing Magazine, 2003
- 应用: 实时频谱监测 (SDR)
- 应用: 窄带信号跟踪

**参数配置**:
| Config | N | num_bins | data_width | 应用 |
|--------|---|---------|------------|------|
| C1 | 64 | 64 (full) | 16-bit | 频谱监测 |
| C2 | 256 | 16 (selected) | 16-bit | 选择性监测 |
