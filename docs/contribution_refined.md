# 论文三大贡献点细化

---

## 贡献 1: CommFormaBench — 大规模通信算法基准集

### 设计原则
- **Kernel 数量要多**（目标 200+）
- **每个 Kernel 有多组参数配置**（如 N=24, 36, 64, 128, 256, 1024）
- **严格基于标准/白皮书**，每个 kernel 附出处
- **包含约束标注**（位宽、吞吐率、目标频率等）

### 数据结构（每个 Benchmark Entry）
```yaml
kernel_id: "ldpc_cn_min_sum"
category: "channel_coding"
name: "LDPC Check Node Update (Min-Sum)"
formula_latex: "L_r(i→j) = ∏ sign(L_q) · min_{j'≠j}|L_q(j'→i)|"
source: "3GPP TS 38.212 V17.0.0, Section 5.3.2; IEEE 802.11-2020 Section 19.3.11.6"
parameters:
  - { Z: 24, R: "1/2", description: "5G NR base graph 1, smallest lifting size" }
  - { Z: 64, R: "1/2", description: "5G NR BG1 medium" }
  - { Z: 128, R: "3/4", description: "5G NR BG1 large, high rate" }
  - { Z: 384, R: "1/3", description: "5G NR BG1 max lifting, low rate" }
constraints:
  input_bitwidth: 6
  output_bitwidth: 6
  throughput_target: "10 Gbps (5G NR requirement)"
  max_latency_cycles: 100
  target_freq_mhz: 500
golden_model: "python/ldpc_cn_min_sum.py"
ir_spec: "ir/ldpc_cn_min_sum.fvir"
```

### 来源要求
每个 kernel 必须标注以下之一：
1. **3GPP 标准** (TS 38.xxx for 5G NR, TS 36.xxx for LTE)
2. **IEEE 标准** (802.11 for WiFi, 802.16 for WiMAX)
3. **ITU 建议书**
4. **经典教科书** (Proakis, Haykin, Goldsmith, Richardson-Urbanke)
5. **经典论文** (首次提出该算法的论文)

---

## 贡献 2: Agent-Aware IR (暂命名 FVIR: Formula-to-Verilog IR)

### 核心设计理念

不是给编译器看的 IR，是给 **LLM Agent** 看的 IR：
- 用**有限的 op 集**规范表达所有通信算法 kernel
- 这些 op 选择的原则：LLM 能精准理解 + 容易翻译为 Verilog
- 每个 op 都有明确的硬件语义（LLM 看到 op 就知道怎么映射到硬件）
- 显式携带约束信息
- 结构上暗示 LLM 可以做哪些变换

### Op 集设计（初步）

```
=== 算术运算 ===
ADD(a, b, width)           # 定点加法
SUB(a, b, width)           # 定点减法
MUL(a, b, width_a, width_b, width_out)  # 定点乘法
MAC(a[], b[], N, acc_width) # 乘累加（可映射为并行/流水线）
DIV(a, b, method)          # 除法（method: newton/restoring/lut）
ABS(a)                     # 绝对值
NEG(a)                     # 取负
SAT(a, min, max)           # 饱和截断
ROUND(a, mode, out_width)  # 四舍五入

=== 移位与位操作 ===
SHL(a, n)                  # 左移（×2^n）
SHR(a, n)                  # 右移（÷2^n）
BARREL_SHIFT(a, n, dir)    # 可变移位

=== 比较与选择 ===
MAX(a, b)                  # 最大值
MIN(a, b)                  # 最小值
CMP(a, b, op)              # 比较
MUX(sel, a, b)             # 选择
SIGN(a)                    # 符号提取

=== 超越函数 ===
CORDIC(x, y, z, mode, iters)  # CORDIC（旋转/向量模式）
LUT(addr, table, interp)   # 查表（可选插值）
LOG2(a, method)            # 对数
EXP2(a, method)            # 指数
SQRT(a, method)            # 平方根

=== 规约运算 ===
SUM(a[], N)                # 求和（可映射为树形加法器）
PROD_SIGN(a[], N)          # 符号连乘（XOR 链）
MIN_EXCLUDE(a[], N, idx)   # 排除自身的最小值（LDPC 特有）
ARGMAX(a[], N)             # 最大值索引

=== 复数运算 ===
CMUL(ar, ai, br, bi)       # 复数乘法
CADD(ar, ai, br, bi)       # 复数加法
CONJ(ar, ai)               # 共轭
MAG2(ar, ai)               # 幅度平方 |z|²

=== 存储与延迟 ===
DELAY(a, cycles)           # 延迟（寄存器链）
BUFFER(a[], size, mode)    # 缓冲区（FIFO/circular）
ROM(addr, content)         # 常数表

=== 结构运算 ===
BUTTERFLY(a, b, w)         # 蝶形运算（FFT 基本单元）
ACS(metric[], branch[], N) # 加-比较-选择（Viterbi）
CIRC_SHIFT(a[], shift)     # 循环移位（LDPC QC）

=== 控制流 ===
ITERATE(body, count)       # 迭代（可展开为流水线）
FOLD(op, a[], N, factor)   # 折叠（资源复用）
PIPELINE(stages[])         # 流水线标注
PARALLEL(ops[])            # 并行标注
```

### IR 示例：FIR 滤波器

```fvir
# FIR Direct Form
# Source: 数字信号处理基本运算
# Formula: y[n] = Σ_{k=0}^{N-1} h[k] · x[n-k]

@kernel fir_direct
@params {
  N: 16                    # 滤波器阶数
  input_width: 16          # 输入位宽
  coeff_width: 16          # 系数位宽
  output_width: 32         # 输出位宽
  throughput: "1 sample/cycle"
  target_freq: 200MHz
}

@constraints {
  symmetric: true          # h[k] = h[N-1-k] → LLM 可注意到预加法优化
  max_dsp: 8              # DSP 资源限制 → LLM 可考虑折叠
}

@transforms_hint {
  # 提示 LLM 可探索的变换方向（非强制）
  - "symmetric → pre-add to halve multipliers"
  - "large N → polyphase decomposition"
  - "CSD encoding for constant coefficients"
}

@body {
  input x: fixed<@input_width, frac=15>
  coeff h[0..N-1]: fixed<@coeff_width, frac=15> = ROM(...)
  
  delays = [DELAY(x, k) for k in 0..N-1]
  products = [MUL(delays[k], h[k], @input_width, @coeff_width, @output_width) for k in 0..N-1]
  output y = SUM(products, N)   # 可映射为：树形加法器 / 流水线累加 / 脉动阵列
}
```

### IR 示例：LDPC Min-Sum CN Update

```fvir
# LDPC Check Node Update (Min-Sum)
# Source: 3GPP TS 38.212, Richardson & Urbanke "Modern Coding Theory"
# Formula: L_r(i→j) = (∏_{j'∈N(i)\j} sign(L_q(j'→i))) · min_{j'∈N(i)\j} |L_q(j'→i)|

@kernel ldpc_cn_min_sum
@params {
  dc: 19                   # check node degree (5G NR BG1 max)
  msg_width: 6             # message bit width
  throughput: "10 Gbps"
  target_freq: 500MHz
}

@constraints {
  normalization: 0.75      # normalized min-sum factor (optional approx)
  min_width: 6
  pipeline_allowed: true
}

@transforms_hint {
  - "total_sign XOR → compute all, then XOR back each"
  - "min_exclude → track min1, min2, argmin1 → O(dc) instead of O(dc²)"
  - "normalized: scale by @normalization (shift approx: ×0.75 ≈ x - x>>2)"
}

@body {
  input L_q[0..dc-1]: fixed<@msg_width, frac=4>
  
  # Sign computation
  signs = [SIGN(L_q[j]) for j in 0..dc-1]
  total_sign = PROD_SIGN(signs, dc)          # XOR of all signs
  
  # Magnitude + min finding
  magnitudes = [ABS(L_q[j]) for j in 0..dc-1]
  
  # For each output j: sign_exclude = total_sign XOR signs[j]
  #                     min_exclude = min of all magnitudes except j
  output L_r[0..dc-1] = [
    MUX(total_sign XOR signs[j], 
        MIN_EXCLUDE(magnitudes, dc, j),
        NEG(MIN_EXCLUDE(magnitudes, dc, j)))
    for j in 0..dc-1
  ]
}
```

### IR 设计的三重作用

```
     ┌─────────────────────────────────────────┐
     │         Agent-Aware IR (FVIR)            │
     ├─────────────────────────────────────────┤
     │                                         │
     │  作用1: 规范输入                         │
     │  - 有限 op 集消除歧义                   │
     │  - LLM 不需要猜测公式含义              │
     │  - 约束信息显式可见                     │
     │                                         │
     │  作用2: 引导变换                         │
     │  - transforms_hint 提示可能的优化        │
     │  - op 粒度暗示硬件映射方式              │
     │  - 结构化表达暴露并行性                 │
     │                                         │
     │  作用3: 标准化评估                       │
     │  - Benchmark 中每题提供标准 IR           │
     │  - 消除 prompt 差异对实验的干扰          │
     │  - 可复现性保证                         │
     │                                         │
     └─────────────────────────────────────────┘
```

---

## 贡献 3: 端到端自动化框架 (FormaFlow)

```
┌──────────────────────────────────────────────────────────────┐
│                     FormaFlow 框架                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  [用户输入]                                                   │
│  数学公式(LaTeX) + 约束(吞吐率/面积/频率)                     │
│       │                                                      │
│       ▼                                                      │
│  [Stage 1] Formula Parser → FVIR                             │
│  - LaTeX → 结构化 IR                                         │
│  - 约束注入                                                  │
│  - 自动参数配置                                              │
│       │                                                      │
│       ▼                                                      │
│  [Stage 2] LLM Transform Agent                               │
│  - 读取 FVIR                                                 │
│  - 探索等价/近似变换                                         │
│  - 输出: 优化后 FVIR + 变换说明                              │
│       │                                                      │
│       ▼                                                      │
│  [Stage 3] LLM Codegen Agent                                 │
│  - 读取优化后 FVIR                                           │
│  - 生成可综合 Verilog                                        │
│  - 生成 Testbench                                            │
│       │                                                      │
│       ▼                                                      │
│  [Stage 4] Verification Loop (Agent-Driven)                  │
│  ┌────────────────────────────────────────────────┐         │
│  │  4a. Verilator 编译                             │         │
│  │      ├─ 失败 → 错误信息 → LLM Fix Agent → 重试 │         │
│  │      └─ 通过 ↓                                  │         │
│  │  4b. Verilator 仿真 vs Golden Model             │         │
│  │      ├─ 不一致 → 差异报告 → LLM Fix Agent      │         │
│  │      └─ 通过 ↓                                  │         │
│  │  4c. Yosys 综合 → 资源/时序报告                 │         │
│  │      ├─ 不满足约束 → LLM Optimize Agent         │         │
│  │      └─ 满足 ↓                                  │         │
│  │  4d. ✓ 完成                                     │         │
│  └────────────────────────────────────────────────┘         │
│       │                                                      │
│       ▼                                                      │
│  [输出]                                                      │
│  - 可综合 Verilog RTL                                        │
│  - 综合报告 (资源/频率/功耗)                                  │
│  - 验证报告 (正确性证明)                                      │
│  - 变换日志 (做了哪些优化)                                    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## 三个贡献的关系

```
CommFormaBench (贡献1)
    │ 提供标准化的公式+约束+Golden Model
    ▼
Agent-Aware IR / FVIR (贡献2)
    │ 规范化表达，引导 LLM 生成
    ▼
FormaFlow 端到端框架 (贡献3)
    │ 自动化完成 公式→验证通过的硬件
    ▼
实验评估: 用贡献1评估贡献2+3的效果
```

---

## 更新后的论文结构

```
第一章 绪论
  1.1 研究背景（通信硬件设计瓶颈）
  1.2 问题分析（HLS缺陷 + 现有LLM工作局限）
  1.3 研究目标与主要贡献（三大贡献概述）
  1.4 论文组织

第二章 相关工作
  2.1 LLM 硬件代码生成
  2.2 高层次综合与传统自动化
  2.3 通信算法硬件实现
  2.4 中间表示与程序变换
  2.5 迭代式 LLM Agent 系统

第三章 CommFormaBench: 通信算法基准集
  3.1 设计原则与分类体系
  3.2 Kernel 定义与参数化
  3.3 来源标注与标准依据
  3.4 Golden Model 与评估指标
  3.5 与现有 Benchmark 的对比

第四章 FVIR: Agent-Aware 中间表示
  4.1 设计动机（为什么需要专为 LLM 设计的 IR）
  4.2 Op 集设计与选择原则
  4.3 约束表达机制
  4.4 变换提示与引导机制
  4.5 从 LaTeX 到 FVIR 的解析

第五章 FormaFlow: 端到端自动化框架
  5.1 系统架构
  5.2 LLM Transform Agent
  5.3 LLM Codegen Agent
  5.4 验证迭代闭环（Verilator + Yosys + LLM Fix Agent）
  5.5 多目标优化策略

第六章 实验与分析
  6.1 实验设置
  6.2 端到端 Pass Rate（全 Benchmark）
  6.3 FVIR vs 纯 Prompt 对比（IR 的价值）
  6.4 变换发现能力评估
  6.5 迭代收敛性分析
  6.6 与 HLS / 手工设计对比
  6.7 不同 LLM 对比
  6.8 消融实验
  6.9 失败案例分析

第七章 讨论
  7.1 主要发现
  7.2 方法适用边界
  7.3 IR 设计的取舍
  7.4 对硬件设计自动化的启示

第八章 结论与展望
```
