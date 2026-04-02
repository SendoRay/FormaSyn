# FormaSyn Benchmark Suite
## 通信算法 FPGA 实现完整评测集

> 作为 EDA 和通信硬件设计专家，基于以下依据构建：
> 1. liquidsdr.org 的 SDR 算法模块
> 2. 3GPP/802.11 等标准中的核心算子
> 3. 当前 DSL 算子能力（Map/Reduce/ShiftReg/Delay/MessagePass）
> 4. FPGA 硬件实现的实际约束

---

## 一、当前 DSL 可直接支持的 Kernel

### 1.1 滤波类 (Filtering)

#### FIR 滤波器族

| Kernel | 公式 | Shape 变体 | 位宽变体 | 硬件特性 |
|--------|------|-----------|---------|---------|
| `fir_direct` | y[n] = Σ h[k]·x[n-k] | taps: 8, 16, 32, 64, 128 | 8/12/16/18 bit | 对称系数优化 |
| `fir_halfband` | 半带抽取/插值 | taps: 7, 11, 15, 23 (奇数) | 12/16/18 bit | 零系数跳过 |
| `fir_root_raised_cosine` | RRC 脉冲成形 | roll-off: 0.2, 0.35, 0.5 | 12/16 bit | 系数对称 |
| `fir_cic_comp` | CIC 补偿滤波 | taps: 16, 32 | 16/18 bit | 级联 CIC 后使用 |

**DSL 表达示例 (fir_16tap)**:
```python
fp.shift_reg("x_in", taps=range(16), output="taps")
fp.map("taps", func="multiply", coeff=h_coeffs, output="products")
fp.reduce("products", op="add", domain=fp.domain.all(), output="y_out")
```

**变体参数空间**:
- parallelism: 1, 2, 4, 8, 16 (与输入采样率相关)
- 系数对称性: symmetric (节省 50% 乘法器) / asymmetric
- 输出速率: 1x (单速率) / 2x (2倍抽取) / 0.5x (2倍插值)

---

#### IIR 滤波器族 ⚠️ 部分支持

| Kernel | 公式 | DSL 限制 | 建议扩展 |
|--------|------|---------|---------|
| `iir_biquad` | y[n] = b0·x[n] + b1·x[n-1] + b2·x[n-2] - a1·y[n-1] - a2·y[n-2] | 需要反馈路径 (y[n-1]) | 新增 `FeedbackOp` 或递归 Reduce |
| `iir_dc_blocker` | 一阶 IIR 高通 | 同上 | 同上 |

**专家评估**: IIR 的反馈路径在 DSL 中难以表达。当前 DSL 是 DAG（有向无环图），IIR 需要循环依赖。

---

### 1.2 信道编码 (Channel Coding)

#### LDPC 译码

| Kernel | 算法 | Shape 变体 | 位宽 | 近似方法 |
|--------|------|-----------|------|---------|
| `ldpc_cnu_spa` | Sum-Product (tanh/atanh) | dc: 4, 8, 16, 24, 32 | 8/10/12 bit LLR | spa_exact |
| `ldpc_cnu_min_sum` | Min-Sum (sign+abs) | dc: 4, 8, 16, 24, 32 | 6/8/10 bit | min_sum |
| `ldpc_cnu_offset_ms` | Offset Min-Sum | dc: 4, 8, 16, 24, 32 | 6/8/10 bit | offset_min_sum (β=0.15-0.5) |
| `ldpc_cnu_normalized_ms` | Normalized Min-Sum | dc: 4, 8, 16, 24, 32 | 6/8/10 bit | normalized_min_sum (α=0.7-0.85) |
| `ldpc_cnu_lut_tanh` | LUT-based tanh | dc: 4, 8, 16 | 8/10 bit | lut_tanh (64-256 entry) |

**变体参数空间**:
- H 矩阵: WiFi (648, 1296, 1944), 5G NR (various)
- 并行度: 1, dc/2, dc (全并行)
- 迭代次数 (外部): 10, 25, 50

**DSL 表达 (ldpc_cnu)**:
```python
fp.map("msg_in", func="tanh", output="tanh_out")  # 或 sign+abs
fp.reduce("tanh_out", op="mul", domain=neighbors(H), output="product")
fp.map("product", func="atanh", output="msg_out")  # 或 min+xor
```

---

#### Turbo 译码 ⚠️ 需要扩展

| Kernel | 算法 | 需求 | 当前支持度 |
|--------|------|------|-----------|
| `turbo_map_decoder` | MAP/Log-MAP | 前向-后向算法 (BCJR) | ❌ 不支持递归 |
| `turbo_siso` | Soft-In-Soft-Out | 网格状态机遍历 | ❌ 需要 StateMachineOp |

**专家评估**: Turbo 译码的 BCJR 算法需要前向-后向递归，当前 DSL 不支持时序/状态机。

---

#### 卷积码/Viterbi ⚠️ 需要扩展

| Kernel | 约束长度 | 需求 | 当前支持度 |
|--------|---------|------|-----------|
| `viterbi_decoder_k7` | K=7, 64 states | ACS (加-比-选) 递归 | ❌ 不支持 |
| `viterbi_decoder_k9` | K=9, 256 states | 同上 | ❌ 不支持 |

**建议扩展**: `TrellisOp` - 网格图操作，支持 Viterbi/Turbo 的 ACS 操作。

---

#### Polar 译码 ⚠️ 需要扩展

| Kernel | 算法 | 需求 | 当前支持度 |
|--------|------|------|-----------|
| `polar_sc_decoder` | Successive Cancellation | 递归树遍历 | ⚠️ 可用 Reduce 树近似 |
| `polar_scl_decoder` | SC List | 路径保留/剪枝 | ❌ 不支持动态选择 |

---

### 1.3 同步与检测 (Synchronization & Detection)

#### 相关器/匹配滤波

| Kernel | 公式 | Shape 变体 | 位宽 | 应用场景 |
|--------|------|-----------|------|---------|
| `correlator_real` | R[m] = Σ x[n]·p[n-m] | length: 64, 128, 256, 512 | 8/12/16 bit | 前导码检测 |
| `correlator_complex` | 复数相关 | length: 64, 128, 256 | 8/12/16 bit I/Q | OFDM 同步 |
| `matched_filter` | 与本地序列相关 | length: 16-1024 | 12/16 bit | 扩频接收 |

**DSL 表达**:
```python
fp.shift_reg("x_in", taps=range(N), output="taps")
fp.map("taps", func="multiply", coeff=preamble, output="products")
fp.reduce("products", op="add", domain=fp.domain.all(), output="corr_out")
```

---

#### AGC (自动增益控制) ⚠️ 需要扩展

| Kernel | 公式 | 需求 | 当前支持度 |
|--------|------|------|-----------|
| `agc_loop` | g[n] = g[n-1] + μ·(A - |y[n]|) | 反馈环路 | ❌ 不支持递归 |

**专家评估**: AGC 是闭环反馈系统，当前 DSL 不支持。需要 `FeedbackOp`。

---

#### PLL/Costas 环 ⚠️ 需要扩展

| Kernel | 用途 | 需求 | 当前支持度 |
|--------|------|------|-----------|
| `pll_carrier_recovery` | 载波同步 | 二阶环路滤波器 | ❌ 需要 IIR + 反馈 |
| `costas_loop_bpsk` | BPSK 相位恢复 | 同上 | ❌ 不支持 |
| `costas_loop_qpsk` | QPSK 相位恢复 | 四相 Costas | ❌ 不支持 |

---

### 1.4 调制解调 (Modulation)

#### 数字调制映射

| Kernel | 调制方式 | Shape | 位宽 | 近似方法 |
|--------|---------|-------|------|---------|
| `modem_bpsk` | BPSK 映射 | 1→1 | 12/16 bit | N/A |
| `modem_qpsk` | QPSK 映射 | 2→1 (复数) | 12/16 bit | N/A |
| `modem_16qam` | 16-QAM 映射 | 4→1 (复数) | 12/16 bit | LUT 实现 |
| `modem_64qam` | 64-QAM 映射 | 6→1 (复数) | 12/16 bit | LUT 实现 |
| `modem_256qam` | 256-QAM 映射 | 8→1 (复数) | 12/16 bit | LUT 实现 |

**DSL 表达**:
```python
# 16-QAM: 4 bits -> I/Q 各 2 bits
fp.map("bits_in", func="lut", lut_table=qam16_constellation, output="symbol_out")
```

---

#### OFDM 处理 ⚠️ 部分支持

| Kernel | 功能 | Shape | 当前支持度 | 说明 |
|--------|------|-------|-----------|------|
| `ofdm_cyclic_prefix` | 添加 CP | FFT_size: 64, 128, 256, 512, 1024, 2048 | ⚠️ 可用 ShiftReg | 循环前缀是延迟操作 |
| `ofdm_subcarrier_map` | 子载波映射 | used_subcarriers: 48-1200 | ✅ 支持 | Map 操作 |
| `ofdm_fft` | FFT/IFFT | 64-2048 点 | ❌ 不支持 | 需要 ButterflyOp |

**专家评估**: OFDM 的核心是 FFT，当前 DSL 无 FFT 算子。实际硬件中 FFT 通常用 IP 核实现。

---

### 1.5 变换与变换域处理 (Transform)

#### FFT/IFFT ⚠️ 不支持

| Kernel | 点数 | 需求 | 建议 |
|--------|------|------|------|
| `fft_radix2` | 64, 128, 256, 512, 1024, 2048 | 蝶形运算网络 | 新增 `FFTOp` 或作为外部 IP |
| `fft_radix4` | 64, 256, 1024 | 4-基蝶形 | 同上 |

**专家意见**: FFT 是通信系统核心，但硬件实现复杂（蝶形网络、位逆序）。建议：
1. DSL 中新增 `FFTOp` 作为高层抽象
2. 代码生成时映射到 Xilinx FFT IP 或开源 FFT 核

---

#### DCT ⚠️ 不支持

| Kernel | 用途 | 需求 |
|--------|------|------|
| `dct_compression` | 图像/视频压缩 | 类似 FFT 的蝶形网络 |

---

### 1.6 基本向量运算 (Vector Operations)

| Kernel | 公式 | Shape | 位宽 | 并行度 |
|--------|------|-------|------|--------|
| `vec_add` | c[i] = a[i] + b[i] | 16, 64, 256, 1024 | 8/12/16/32 bit | 1, 2, 4, 8, 16 |
| `vec_mul` | c[i] = a[i] · b[i] | 16, 64, 256, 1024 | 8/12/16/18 bit | 1, 2, 4, 8 |
| `vec_mac` | acc += a[i] · b[i] | 16, 64, 256, 1024 | 16/24/32/40 bit | 1, 2, 4 |
| `vec_scale` | b[i] = a[i] · gain | 16, 64, 256, 1024 | 8/12/16 bit | 1, 2, 4, 8 |
| `vec_abs` | b[i] = |a[i]| | 16, 64, 256, 1024 | 8/12/16 bit | 1, 2, 4, 8, 16 |
| `vec_max` | max = max(a[i]) | 16, 64, 256, 1024 | 8/12/16 bit | 树形归约 |
| `vec_min` | min = min(a[i]) | 16, 64, 256, 1024 | 8/12/16 bit | 树形归约 |

**DSL 表达 (vec_add)**:
```python
fp.map(["a", "b"], func="add", output="c")  # 需要扩展 Map 支持多输入
# 或
fp.map("a", func="add", coeff="b", output="c")  # 当前方式
```

---

## 二、需要扩展 DSL 算子的重要 Kernel

### 2.1 高优先级扩展（通信系统核心）

#### 1. ButterflyOp (FFT 蝶形)
```python
fp.butterfly("x0", "x1", twiddle=w, outputs=["y0", "y1"])
```
- 用于: FFT, IFFT, DCT
- 硬件: 复数乘法器 + 加减法

#### 2. FeedbackOp (反馈环路)
```python
fp.feedback("input", "delayed", func="add", coeff=gain, delay=1, output="output")
```
- 用于: IIR, PLL, AGC, 自适应滤波器
- 硬件: 寄存器 + 乘法器 + 加法器

#### 3. TrellisOp (网格图)
```python
fp.trellis("input", states=S, outputs=O, transitions=T, algorithm="viterbi", output="decoded")
```
- 用于: Viterbi, Turbo, 卷积码
- 硬件: ACS (Add-Compare-Select) 单元阵列

#### 4. ComplexOp (复数运算)
```python
fp.complex_map("x", func="multiply", y="h", output="y")  # 复数乘法
```
- 用于: 复数滤波、复数相关、OFDM
- 硬件: 4 个实数乘法器 + 2 个加法器

#### 5. InterleaveOp (交织/解交织)
```python
fp.interleave("data_in", pattern="block", rows=R, cols=C, output="data_out")
```
- 用于: 信道交织、Turbo 交织
- 硬件: 双端口 RAM + 地址生成器

### 2.2 中优先级扩展

#### 6. CordicOp
```python
fp.cordic("x", "y", mode="rotation", output=["x_rot", "y_rot"])
```
- 用于: 极坐标转换、三角函数、复数相位旋转
- 硬件: 移位-加法迭代单元

#### 7. SortOp
```python
fp.sort("values", k=8, order="ascending", output="sorted")
```
- 用于: Polar SCL 译码、MIMO 检测
- 硬件: 排序网络 (bitonic sort)

#### 8. MatrixOp
```python
fp.matrix_mult("A", "B", M, N, K, output="C")
```
- 用于: MIMO 检测、预编码
- 硬件: 脉动阵列 (systolic array)

---

## 三、完整 Benchmark 列表

### Tier 1: 当前 DSL 完全支持（必须实现）

```
✅ fir_direct_N16_N32_N64_N128
✅ fir_halfband_N7_N11_N15_N23
✅ fir_rrc_rolloff020_035_050
✅ ldpc_cnu_dc4_dc8_dc16_dc32_spa_minsum_offsetms_normalizedms
✅ correlator_real_N64_N128_N256_N512
✅ correlator_complex_N64_N128_N256
✅ vec_add_N16_N64_N256_N1024
✅ vec_mul_N16_N64_N256_N1024
✅ vec_mac_N16_N64_N256
✅ modem_bpsk_qpsk_16qam_64qam_lut
```

**总计**: ~40+ 变体

### Tier 2: 需要 1-2 个新算子（高价值）

```
⚠️ iir_biquad_N2_N4_N6 (需要 FeedbackOp)
⚠️ agc_loop (需要 FeedbackOp)
⚠️ ofdm_fft_64_128_256_512_1024_2048 (需要 ButterflyOp)
⚠️ fft_64_128_256_512_1024_2048 (需要 ButterflyOp)
⚠️ viterbi_k7_k9 (需要 TrellisOp)
⚠️ turbo_map (需要 TrellisOp)
```

**总计**: ~20+ 变体

### Tier 3: 需要复杂扩展（未来工作）

```
❌ mimo_mmse_detector (需要 MatrixOp)
❌ mimo_ml_detector (需要 MatrixOp + SortOp)
❌ polar_scl_L8_L16 (需要 SortOp + 递归)
❌ pll_carrier_recovery (需要 FeedbackOp + CORDIC)
```

---

## 四、硬件实现约束（真实限制）

### 4.1 DSP 资源约束

| 操作 | 输入位宽 | DSP48 消耗 | 说明 |
|------|---------|-----------|------|
| 实数乘法 | 8-bit | 0 (LUT) | 小位宽用 LUT |
| 实数乘法 | 16-bit | 1 | 标准模式 |
| 实数乘法 | 18x25 | 1 | 单 DSP 最大 |
| 复数乘法 | 12-bit | 3 | 3 个 DSP |
| 复数乘法 | 16-bit | 4 | 4 个 DSP |
| MAC (累积) | 16-bit | 1 | DSP 内建 ACC |

**设计规则**:
- 每 100 MHz 时钟频率，16-bit 乘法器可支持 1 并行度
- 超过 256 并行度的 FIR 需要多相分解

### 4.2 存储器约束

| Kernel | 存储需求 | BRAM18 估算 |
|--------|---------|------------|
| FIR 32-tap | 系数 + 延迟线 | 1-2 |
| FIR 128-tap | 同上 | 4-8 |
| LDPC CNU dc=8 | 消息存储 | 4-16 |
| FFT 1024 | 旋转因子 + 数据 | 8-16 |
| Correlator 256 | 本地序列 | 2-4 |

### 4.3 时钟频率目标

| 算法类型 | 目标频率 | 关键路径 |
|---------|---------|---------|
| FIR (直接型) | 300-500 MHz | 乘法器 + 加法树 |
| FIR (分布式) | 200-300 MHz | LUT 查找 |
| LDPC CNU | 200-300 MHz | min 树 + XOR 树 |
| FFT 1024 | 300-400 MHz | 蝶形 + 旋转因子乘法 |
| Viterbi K=7 | 150-250 MHz | ACS 反馈路径 |

---

## 五、推荐的扩展路线图

### Phase 1 (当前 DSL 可完成)
- [x] FIR 系列（各种 taps、shape）
- [x] LDPC CNU（各种度数、近似方法）
- [x] 相关器/匹配滤波
- [x] 向量运算（作为基础）

### Phase 2 (增加 FeedbackOp)
- [ ] IIR 滤波器
- [ ] AGC
- [ ] 简单 PLL

### Phase 3 (增加 ButterflyOp)
- [ ] FFT/IFFT
- [ ] OFDM 处理链

### Phase 4 (增加 TrellisOp)
- [ ] Viterbi 译码
- [ ] Turbo 译码

### Phase 5 (高级扩展)
- [ ] MIMO 检测 (MatrixOp)
- [ ] Polar SCL (SortOp)

---

## 六、验证测试建议

每个 kernel 应该测试：

1. **功能正确性**: 与浮点 MATLAB/Python 参考模型对比
2. **数值精度**: NMSE < -60 dB（通信系统典型要求）
3. **资源使用**: DSP、BRAM、LUT 在预算内
4. **时序收敛**: 目标频率达标
5. **吞吐量**: 样本/秒满足系统要求

---

## 七、结论

当前 DSL 设计可以覆盖 **30-40%** 的通信核心算法（主要是 FIR、LDPC、基本向量运算）。

**最高优先级扩展**: `FeedbackOp` 和 `ButterflyOp`，可将覆盖提升到 **60-70%**。

**长期目标**: 增加 `TrellisOp`、`MatrixOp` 后，可覆盖 **90%+** 的 5G/ WiFi 基带处理。
