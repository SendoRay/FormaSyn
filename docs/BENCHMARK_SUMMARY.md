# FormaSyn Benchmark Suite - 快速参考

## 📊 支持状态总览

| 类别 | 完全支持 ✅ | 需扩展 ⚠️ | 不支持 ❌ |
|------|-----------|----------|----------|
| 滤波 (Filtering) | 3 kernels | 1 kernel | 0 |
| 信道编码 (Coding) | 1 kernel | 0 | 2 kernels |
| 同步 (Sync) | 2 kernels | 1 kernel | 2 kernels |
| 变换 (Transform) | 0 | 0 | 1 kernel |
| 调制 (Modulation) | 1 kernel | 0 | 0 |
| 向量运算 (Vector) | 3 kernels | 0 | 0 |

**总计**: 11 kernels 完全支持 (~100+ 变体), 7 kernels 需扩展

---

## ✅ 完全支持 (立即实现)

### FIR 滤波器系列
```python
# 基础 FIR
fir_direct_t{8,16,32,64,128}_b{8,12,16,18}_p{1,2,4,8,16}

# 半带滤波器 (抽取/插值)
fir_halfband_t{7,11,15,23,31}_b{12,16,18}_p{1,2,4,8}

# RRC 脉冲成形
fir_rrc_t{16,32,48,64}_r{20,35,50}_b{12,16}_p{1,2,4,8}
```

### LDPC 校验节点更新
```python
# 所有标准配置
ldpc_cnu_dc{4,6,8,12,16,24,32}_{spa_exact,min_sum,offset_min_sum,normalized_min_sum,lut_tanh}_b{6,8,10}_p{1,2,4,8}

# WiFi 802.11n (648, 1296, 1944 bits)
# 5G NR (various lifting sizes)
```

### 相关器/匹配滤波
```python
# 实数相关
correlator_real_n{64,128,256,512,1024}_b{8,12,16}_p{1,2,4,8}

# 复数相关
correlator_complex_n{64,128,256,512}_b{8,12,16}_p{1,2,4}
```

### 向量运算
```python
# 向量加法 (纯 LUT)
vec_add_n{16,64,256,1024,4096}_b{8,12,16,32}_p{1,2,4,8,16,32}

# 向量乘法 (DSP)
vec_mul_n{16,64,256,1024}_b{8,12,16}_p{1,2,4,8}

# MAC/点积 (DSP + 累加)
vec_mac_n{16,64,256,1024}_b{8,12,16}_p{1,2,4,8}

# 最大/最小值 (归约树)
vec_max_n{16,64,256,1024}_b{8,12,16}_p{1,2,4,8}
```

### 调制映射
```python
# BPSK/QPSK (LUT)
modem_bpsk_b{12,16}_p{1,2,4,8,16}
modem_qpsk_b{12,16}_p{1,2,4,8,16}

# 16-QAM (LUT)
modem_16qam_b{12,16}_p{1,2,4,8}

# 64-QAM (分段 LUT 或计算)
modem_64qam_b{12,16}_p{1,2,4}
```

---

## ⚠️ 需要 FeedbackOp (优先级: 🔥🔥🔥)

### IIR 滤波器
```python
# Biquad 节 (二阶)
iir_biquad_sections{1,2,4,6}_b{12,16}_p{1,2,4}
# 需要: FeedbackOp
# 公式: y[n] = Σb·x[n-k] - Σa·y[n-k]
# 硬件: 2-5 DSP, 稳定性检查
```

### AGC 自动增益控制
```python
# 闭环 AGC
agc_loop_b{12,16}_mu{0.001,0.01,0.1}
# 需要: FeedbackOp
# 公式: g[n] = g[n-1] + μ·(target - |y[n]|)
# 硬件: 2 DSP, 除法器 (或 LUT 近似)
```

### PLL/Costas 环
```python
# 载波恢复
pll_carrier_recovery_order{1,2}_b{16,20}
costas_loop_bpsk_b{16,20}
costas_loop_qpsk_b{16,20}
# 需要: FeedbackOp + CORDIC (相位旋转)
# 硬件: 5-10 DSP, 复杂状态机
```

---

## ⚠️ 需要 ButterflyOp (优先级: 🔥🔥🔥)

### FFT/IFFT
```python
# 标准 FFT
fft_radix2_n{64,128,256,512,1024,2048}_b{12,16}_p{1,2,4}
fft_radix4_n{64,256,1024}_b{12,16}_p{1,4,16}
# 需要: ButterflyOp
# 硬件: 3-4 DSP/蝶形, BRAM 存储旋转因子
# 关键: 流水线设计或 IP 核集成

# OFDM 处理链
ofdm_fft_n{64,128,256,512,1024,2048}_cp{16,32,64,128}_b{12,16}
# 需要: ButterflyOp + ShiftReg (循环前缀)
```

---

## ❌ 需要 TrellisOp (优先级: 🔥🔥)

### Viterbi 译码
```python
# WiFi/GSM 标准
viterbi_k7_rate{1/2}_soft_b{8}_traceback{96}
viterbi_k7_p{1,64}  # 串行或全并行
# 需要: TrellisOp
# 硬件: ACS 单元阵列 (64 states), 回溯存储器

# 其他约束长度
viterbi_k9_rate{1/2}_soft_b{8}  # 256 states, 更复杂
```

### Turbo 译码
```python
# LTE/WiMax
turbo_map_bcjr_iterations{4,6,8}_b{8,10}
# 需要: TrellisOp + FeedbackOp (迭代)
# 硬件: 两个 MAP 解码器 + 交织器, 资源密集型
```

---

## ❌ 需要 ComplexOp + MatrixOp (优先级: 🔥)

### MIMO 检测
```python
# MMSE 检测
mimo_mmse_antennas{2,4,8}_qam{16,64,256}_b{12,16}
# 需要: MatrixOp (矩阵求逆/乘法)
# 硬件: 脉动阵列, 大量 DSP

# ML 检测 (球形译码)
mimo_ml_antennas{2,4}_qam{16,64}_b{12,16}
# 需要: MatrixOp + SortOp
# 硬件: 树搜索, 动态控制流 (难)
```

### Polar 译码
```python
# Successive Cancellation List
polar_scl_n{128,256,512,1024}_L{8,16,32}_b{8,10}
# 需要: SortOp + 递归树遍历
# 硬件: 排序网络, 路径度量管理
```

---

## 📋 推荐实现优先级

### 第 1 阶段 (Week 1-2): 当前 DSL 完善
- [x] FIR 系列完整测试
- [x] LDPC CNU 所有变体
- [x] 向量运算优化

### 第 2 阶段 (Week 3-4): FeedbackOp
- [ ] 实现 FeedbackOp
- [ ] IIR Biquad
- [ ] AGC Loop

### 第 3 阶段 (Week 5-7): ButterflyOp
- [ ] 实现 ButterflyOp
- [ ] 256/1024 FFT
- [ ] OFDM 处理链

### 第 4 阶段 (Week 8-10): TrellisOp
- [ ] 实现 TrellisOp
- [ ] Viterbi K=7
- [ ] Turbo (可选)

### 第 5 阶段 (Week 11+): 高级扩展
- [ ] MatrixOp (MIMO)
- [ ] SortOp (Polar)

---

## 🎯 实际系统覆盖评估

### WiFi 802.11a/g/n/ac 基带
| 模块 | 当前 DSL | 加 Feedback | 加 Butterfly | 加 Trellis |
|------|---------|-------------|--------------|------------|
| 同步 (Sync) | ✅ 80% | ✅ 90% | ✅ 95% | ✅ 95% |
| 均衡 (EQ) | ⚠️ 50% | ✅ 80% | ✅ 90% | ✅ 90% |
| 信道译码 | ✅ 30% (LDPC) | ✅ 30% | ✅ 30% | ✅ 100% |
| 调制/解调 | ✅ 100% | ✅ 100% | ✅ 100% | ✅ 100% |

**结论**: 
- 当前 DSL 可完成 **60%** WiFi 基带
- +FeedbackOp → **70%**
- +ButterflyOp → **85%** (无 Viterbi)
- +TrellisOp → **100%**

### 5G NR 基带
| 模块 | 当前 DSL | +All Extensions |
|------|---------|-----------------|
| LDPC | ✅ 100% | ✅ 100% |
| Polar | ❌ 0% | ✅ 100% (需 SortOp) |
| FFT (OFDM) | ❌ 0% | ✅ 100% |
| MIMO | ❌ 0% | ⚠️ 50% (简单检测) |

**结论**:
- 当前 DSL 可完成 **40%** 5G NR
- +ButterflyOp → **60%**
- +TrellisOp/SortOp → **80%**
- MIMO 高级检测需要 MatrixOp

---

## 💡 专家建议

### 立即实现 (ROI 最高)
1. **fir_direct** - 最常用, 展示 DSL 能力
2. **ldpc_cnu_min_sum** - 5G/WiFi 核心, 算法优化价值高
3. **vec_add/mul/mac** - 基础构建块, 用于验证流程

### 短期扩展 (1-2 个月)
1. **FeedbackOp** - 解锁 IIR/AGC/PLL, 覆盖 20% 额外算法
2. **ButterflyOp** - 解锁 FFT/OFDM, 覆盖 30% 额外算法

### 中长期扩展 (3-6 个月)
1. **TrellisOp** - Viterbi/Turbo, 传统通信标准需要
2. **MatrixOp** - MIMO 检测, 5G 核心

### 不推荐实现的算法
| 算法 | 原因 |
|------|------|
| 高阶 MIMO ML (8x8) | 硬件复杂度极高, 通常用近似算法 |
| Turbo 高迭代 (>8) | 延迟太大, 实际用 LDPC/Polar 替代 |
| 浮点复杂算法 | 超出定点 DSL 设计范围 |

---

## 📚 参考资源

- **liquidsdr.org**: 软件参考实现
- **3GPP TS 38.212**: 5G NR 信道编码
- **IEEE 802.11-2016**: WiFi 物理层规范
- **Xilinx UG901**: Vitis HLS 用户指南

---

*文档版本: 1.0*
*最后更新: 2026-04-02*
*作者: FormaSyn EDA/通信硬件专家*
