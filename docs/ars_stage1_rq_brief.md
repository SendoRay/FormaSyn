# ARS Stage 1 Output: Research Question Brief (v2)

## 研究问题 (Research Question)

**主RQ**: 大语言模型能否通过 Agent-Aware 中间表示（FVIR），从通信算法的数学公式直接生成高质量的可综合 Verilog 硬件代码，并通过自动化迭代验证闭环保证正确性与资源效率？

**子问题**:
- **RQ1 (无顺序偏差)**: LLM 从数学公式生成的硬件是否比从 C/伪代码出发具有更高的并行度？即"公式输入消除了人类的顺序编程偏差"假设是否成立？
- **RQ2 (变换发现)**: LLM 能否基于 Transform Library 自动发现对硬件实现有利的等价/近似公式变换，生成多个设计变体（variants），并找到人工难以发现的优化路径？
- **RQ3 (IR 有效性)**: Agent-Aware IR (FVIR) 相比纯自然语言 prompt，是否能显著提升 LLM 生成 Verilog 的正确率和资源效率？（FVIR 的价值量化）
- **RQ4 (端到端对比)**: FormaFlow 框架在通信算法 Benchmark 上的综合表现（正确性、资源、性能、开发时间）如何对标 HLS 和手工设计？

## FINER 评分

| 维度 | 评分 | 理由 |
|------|------|------|
| **F**easible | 8/10 | LLM 已能生成简单 Verilog（VerilogEval 通过率 ~60%）；CommFormaBench 提供 217 个结构化 kernel；Verilator/Yosys 均为成熟开源工具；FVIR 设计完成（5 类 op） |
| **I**nteresting | 9/10 | 跨 LLM + EDA + 通信三个热点领域；"公式到硬件"是全新路径；Agent-Aware IR 概念在 EDA 领域无先例 |
| **N**ovel | 10/10 | (1) 无人从数学公式直接生成硬件；(2) 无人设计面向 LLM 的硬件 IR；(3) 无人研究 LLM 是否存在"无顺序偏差"优势；(4) 无人构建通信算法公式级 Benchmark |
| **E**thical | 10/10 | 纯技术研究，无伦理风险 |
| **R**elevant | 9/10 | 6G/AI 芯片时代急需硬件设计自动化；通信 SoC 设计周期瓶颈严重；学术界对 LLM4EDA 高度关注 |

## 范围边界

### In-Scope
- 通信领域数学密集型算法（CommFormaBench 覆盖 14 类、217 个 kernel、1040+ 参数配置）
- 从数学公式到可综合 Verilog 的端到端自动化框架 (FormaFlow)
- Agent-Aware 中间表示 (FVIR) 的设计与评估
- LLM 公式变换能力评估（等价变换 + 近似变换，基于 Transform Library）
- 自动化验证闭环：Verilator 编译 → Verilator 仿真（vs Golden Model）→ Yosys 综合 → LLM Agent 迭代修复
- 与 HLS (Vivado HLS) 和手工设计的对比实验
- FVIR vs 纯 Prompt 的消融对比（IR 有效性验证）

### Out-of-Scope
- 模拟电路 / 物理级设计
- 非通信领域算法
- LLM 训练/微调（使用现有模型 as-is）
- ASIC 后端流程（仅到 FPGA 综合）
- 正式形式验证（SAT/SMT 等价性检查，可作为未来工作）

## 关键术语定义

| 术语 | 定义 |
|------|------|
| 公式级输入 | 以 LaTeX 或结构化数学表达式描述的通信算法核心运算 |
| FVIR | Formula-to-Verilog IR，面向 LLM Agent 设计的中间表示，5 类 op（ELEMENTWISE, REDUCE, MEMORY, CONTROL, CONSTRAINT） |
| Agent-Aware IR | 专为 LLM Agent 可读性和代码生成准确性设计的 IR，而非传统编译器 IR |
| Transform Library | 独立的变换知识库，LLM Agent 参考后可生成多个设计变体 |
| 顺序偏差 | 人类因顺序编程习惯引入的不必要串行依赖（sequential bias） |
| 等价变换 | 保持数学语义完全一致的表达式重写（如对称 FIR → 预加法优化） |
| 近似变换 | 在可接受误差范围内的表达式替换（如 CORDIC 替代乘法器、Min-Sum 替代 Sum-Product） |
| Golden Model | 从数学公式自动生成的浮点参考实现（Python/SymPy），用于 Verilator 仿真比对 |
| CommFormaBench | 本文构建的通信算法公式级基准集，14 类、217 kernel、1040+ 配置，全部附标准来源 |
| FormaFlow | 本文提出的端到端自动化框架：Formula → FVIR → LLM Transform → LLM Codegen → Verify Loop |

## 三大贡献与 RQ 映射

```
贡献 1: CommFormaBench ─── 支撑 RQ1~RQ4 全部实验
  │  217 kernels × 1040+ configs, 标准来源 (3GPP/IEEE/DVB/ITU-T/CCSDS)
  │
贡献 2: FVIR (Agent-Aware IR) ─── 回答 RQ3
  │  5 类 op 覆盖全部 kernel; LLM 生成更精准
  │
贡献 3: FormaFlow (端到端框架) ─── 回答 RQ1, RQ2, RQ4
     LLM Transform Agent → LLM Codegen Agent → Verify Loop (with backtracking)
```

---

# ARS Stage 1 Output: Methodology Blueprint (v2)

## 研究范式
**Pragmatist / Design Science Research** — 构建人工物（FormaFlow 系统）并通过大规模实验评估其效果

## 方法选择
**混合方法**：系统构建（工程方法）+ 大规模控制实验（定量对比）+ 消融研究（因素分析）

## 整体方法框架

```
┌─────────────────────────────────────────────────────────────────────┐
│                 FormaFlow: 公式到硬件的自动化框架                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  [输入]                                                             │
│  数学公式 (LaTeX) + 约束 (吞吐率/面积/频率)                          │
│       │                                                             │
│       ▼                                                             │
│  [Stage 1] Formula Parser → FVIR                                    │
│  - LaTeX → 结构化 Agent-Aware IR                                    │
│  - 约束注入 (@width, @throughput, @freq, @resource_limit)           │
│  - 输出: naive FVIR (直接翻译，保留公式原始结构)                      │
│       │                                                             │
│       ▼                                                             │
│  [Stage 2] LLM Transform Agent                                      │
│  - 读取 naive FVIR + Transform Library                               │
│  - 生成 N 个变体 (variants):                                        │
│      variant_0: naive (原始公式结构)                                  │
│      variant_1~k: 等价变换 (symmetry, factorization, ...)            │
│      variant_k+1~n: 近似变换 (CORDIC, LUT, Min-Sum, ...)            │
│  - 每个 variant = 一份优化后 FVIR + 变换说明                         │
│       │                                                             │
│       ▼                                                             │
│  [Stage 3] LLM Codegen Agent                                        │
│  - 对每个 variant 的 FVIR → 生成可综合 Verilog                       │
│  - 同时生成 Testbench                                                │
│       │                                                             │
│       ▼                                                             │
│  [Stage 4] Verification Loop (Agent-Driven, with backtracking)       │
│  ┌────────────────────────────────────────────────────────┐         │
│  │  4a. Verilator 编译                                     │         │
│  │      ├─ 失败 → 错误信息 → LLM Fix Agent → 回到 4a     │         │
│  │      │         (最多 K 次修复，超过则放弃该 variant)      │         │
│  │      └─ 通过 ↓                                          │         │
│  │  4b. Verilator 仿真 vs Golden Model                     │         │
│  │      ├─ 不一致 → 差异报告 → LLM Fix Agent → 回到 4a    │         │
│  │      │         或 → 回到 Stage 2 换变换策略              │         │
│  │      └─ 通过 ↓                                          │         │
│  │  4c. Yosys 综合 → 资源/时序报告                         │         │
│  │      ├─ 不满足约束 → 回到 Stage 2                       │         │
│  │      │         LLM Optimize Agent 尝试新变换/调整并行度  │         │
│  │      └─ 满足 ↓                                          │         │
│  │  4d. ✓ 该 variant 通过，记录结果                        │         │
│  └────────────────────────────────────────────────────────┘         │
│       │                                                             │
│       ▼                                                             │
│  [Stage 5] Rank & Iterate                                           │
│  - 所有通过的 variants 按资源/频率/功耗排序                           │
│  - 选 Top-1 为当前最优                                               │
│  - 未达目标 → 回到 Stage 2，以当前最优为基础探索新变换                │
│  - 连续 M 轮无提升 → 收敛，输出最优设计                              │
│       │                                                             │
│       ▼                                                             │
│  [输出]                                                             │
│  - 可综合 Verilog RTL (最优 variant)                                 │
│  - 综合报告 (LUT/FF/DSP/BRAM, Fmax, 功耗)                           │
│  - 验证报告 (Golden Model 比对结果, BER/EVM)                         │
│  - 变换日志 (探索了哪些变换, 每个 variant 的结果)                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## 实验设计

### Benchmark: CommFormaBench

| 统计 | 数值 |
|------|------|
| 类别数 | 14 |
| Kernel 总数 | 217 |
| 参数配置总数 | 1040+ |
| 标准覆盖 | 3GPP TS 38.xxx (5G NR), TS 36.xxx (LTE), IEEE 802.11 (WiFi), DVB EN 302 307/755, ITU-T G.711/G.729, CCSDS 131.0, IS-GPS-200 等 |

**14 个类别**:

| 类别 | Kernels | 代表算法 |
|------|---------|---------|
| Cat01 基础数学 | 25 | CORDIC, 复数乘法, CRC, GF(2^m), Newton-Raphson |
| Cat02 滤波器 | 20 | FIR (direct/symmetric/transpose), CIC, RRC, LMS, Farrow |
| Cat03 变换 | 15 | FFT Radix-2/4, SDF, Mixed-Radix, DCT, NTT, Goertzel |
| Cat04 调制解调 | 18 | QAM 映射/LLR, OFDM, DFT-s-OFDM, GMSK, ZC 序列 |
| Cat05 信道编码 | 25 | LDPC (VN/CN/Layered), Polar (SC/SCL), Turbo, Viterbi ACS |
| Cat06 同步估计 | 18 | NCO, Schmidl-Cox, Gardner TED, Costas环, PSS/SSS, PRACH |
| Cat07 均衡检测 | 15 | ZF/MMSE, 2×2/4×4 MIMO, QR分解, SIC, Alamouti |
| Cat08 扩频多址 | 10 | LFSR, Gold序列, DS-SS, Rake, OVSF, GPS C/A |
| Cat09 信源编码 | 12 | μ律/A律, ADPCM, LPC, LSP, ACELP, VQ |
| Cat10 5G NR | 15 | LDPC/Polar rate matching, HARQ, PDCCH 盲检, DMRS/CSI-RS/SRS |
| Cat11 4G LTE | 12 | Turbo 编解码, CRS, PSS/SSS, PRACH, PCFICH/PHICH/PDCCH |
| Cat12 WiFi | 12 | STF/LTF, BCC/LDPC, Scrambler, Interleaver, OFDMA |
| Cat13 DVB | 10 | DVB-S2 LDPC/BCH, APSK (16/32/64/256), PL framing |
| Cat14 SDR通用 | 10 | DUC/DDC, SRC, 频谱感知, 异步FIFO, CORDIC通用引擎 |

### 实验体系 (8 个实验)

| 实验 | 对应 RQ | 目的 | 方法 | 输出指标 |
|------|---------|------|------|----------|
| **Exp-1: 端到端 Pass Rate** | RQ4 | FormaFlow 在全 Benchmark 上的通过率 | 217 kernels × 代表性配置 → FormaFlow 全流程 | 编译通过率, 仿真通过率, 综合通过率 |
| **Exp-2: 无顺序偏差验证** | RQ1 | 公式输入 vs C代码输入的并行度差异 | 同一算法: A=LLM←FVIR vs B=LLM←C代码 vs C=HLS←C代码 | ILP (数据流图并行度), 关键路径长度, LUT/DSP |
| **Exp-3: 变换发现能力** | RQ2 | LLM 能否发现有利的公式变换 | 选 20 个有已知优化的 kernel → 统计 LLM 发现率 | 变换数量, 有效变换率, 人工未发现的变换数 |
| **Exp-4: FVIR vs 纯 Prompt** | RQ3 | IR 的价值量化 | 同一 kernel: A=FVIR 输入 vs B=LaTeX prompt vs C=自然语言描述 | 正确率, 资源效率, 迭代次数 |
| **Exp-5: 与 HLS 对比** | RQ4 | FormaFlow vs Vivado HLS | 选 15 个 kernel (3难度级别 × 5) | LUT/FF/DSP, Fmax, 吞吐率, 功耗 |
| **Exp-6: 与手工设计对比** | RQ4 | FormaFlow vs 开源手工 RTL | 选有开源实现的 kernel (如 OpenCores FFT/FIR) | 资源, 频率, 开发时间 |
| **Exp-7: 迭代收敛性** | RQ4 | 验证反馈闭环的效果 | 记录每个 kernel 的迭代轨迹 | 迭代次数分布, 各阶段回退频率, 收敛速度 |
| **Exp-8: 消融实验** | RQ3,RQ4 | 各模块的贡献度 | 依次去掉: Transform Agent, FVIR (换纯prompt), Verify Loop, 多variant | Pass rate 变化, 资源效率变化 |

### 实验对象分级 (用于 Exp-2, Exp-5, Exp-6 的重点算法)

| 难度 | 代表 Kernel | 数学特征 | 验证难度 | 预期展示的优势 |
|------|------------|---------|----------|---------------|
| ★☆☆ | FIR 对称滤波器 | `y[n] = Σ h[k]·x[n-k]`, 对称性 | 低 | 并行 MAC, 预加法优化, 折叠 |
| ★☆☆ | NCO (CORDIC) | sin/cos 迭代旋转 | 低 | 近似变换（移位替代乘法） |
| ★☆☆ | CRC-24 | 多项式除法 | 低 | 并行展开 (M-bit/cycle) |
| ★★☆ | FFT Radix-2/4 (N=64~4096) | 蝶形运算, 位逆序 | 中 | 流水线策略, SDF vs memory-based |
| ★★☆ | LDPC CN Min-Sum | `Π sign · min(|L|)` | 中 | 高度并行 + min1/min2 优化 + NMS 近似 |
| ★★☆ | OFDM Mod/Demod | IFFT + CP 插入 | 中 | FFT 复用, 多种 CP 配置 |
| ★★☆ | QAM 软解映射 (64QAM) | max-log LLR | 中 | 分段线性近似, 移位替代除法 |
| ★★★ | Polar SCL 解码 | SC 递归 + 路径分裂 + 排序 | 高 | 打破递归, 路径存储优化 |
| ★★★ | Turbo MAP (前向/后向) | α/β 递归 + max* 运算 | 高 | 窗口化打破递归依赖 |
| ★★★ | 4×4 MIMO ZF (QR + 回代) | Givens QR 分解 | 高 | CORDIC 实现 Givens, 多层流水 |

### 验证策略

```
数学公式 (Golden Reference)
    │
    ├──→ [Python/SymPy] 生成浮点参考输出
    │         │
    │         ▼
    │    [Verilator 编译] → 语法/可综合性检查
    │         │
    │         ▼
    │    [Verilator 仿真] 定点输出 vs 浮点 Golden
    │         - 随机测试向量 (1000~10000 组)
    │         - 允许定点量化误差: |err| < 2^{-frac_bits+1}
    │         - 通信指标: BER, EVM, SNR degradation
    │
    └──→ [Yosys 综合] → 资源/时序报告
              - LUT, FF, DSP, BRAM
              - Fmax (critical path)
              - 吞吐率 = pipeline_stages × Fmax
```

### 评估指标体系

| 类别 | 指标 | 测量方法 |
|------|------|----------|
| **正确性** | 编译通过率 | Verilator 编译成功 / 总 kernel 数 |
| **正确性** | 仿真通过率 | Golden Model 比对通过 / 编译通过数 |
| **正确性** | BER 性能损失 | 蒙特卡洛仿真 (≥10⁵ 帧), 与浮点参考对比 |
| **效率** | LUT / FF / DSP / BRAM | Yosys 综合报告 |
| **性能** | Fmax (MHz) | Yosys 时序分析 (critical path) |
| **性能** | 吞吐率 (Gbps) | 流水线级数 × Fmax |
| **并行度** | ILP | 数据流图分析 (关键路径长度 / 总操作数) |
| **变换能力** | 变换发现率 | LLM 发现的有效变换 / 已知最优变换数 |
| **迭代效率** | 收敛迭代次数 | 从首次生成到通过验证的轮数 |
| **开发效率** | 总耗时 | 从公式输入到通过验证的端到端时间（含 LLM API 延迟） |

### 目标平台
- **综合工具**: Yosys (开源, 可复现)
- **仿真工具**: Verilator (开源, 快速 cycle-accurate)
- **对比 HLS**: Vivado HLS 2023.2 (商用参考)
- **FPGA 目标** (HLS 对比时): Xilinx Artix-7 / Zynq-7000
- **LLM**: Claude Sonnet 4 / GPT-4o / DeepSeek-Coder-V2 (对比多个模型)

### 数据收集与分析
- 每个实验重复 5 次（LLM 生成有随机性, temperature=0.7）
- 报告 mean ± std
- 使用 Wilcoxon signed-rank test 检验显著性 (n≥15 时)
- 资源效率归一化: (基线资源 / FormaFlow 资源) × 100%
- 通过率用 Wilson score interval 报告置信区间

---

## 有效性威胁 (Threats to Validity)

| 类型 | 威胁 | 缓解措施 |
|------|------|----------|
| 内部 | LLM 输出随机性 | 每实验 5 次取统计值; 固定 seed 可选 |
| 内部 | Prompt/IR 设计影响结果 | Exp-4 消融: FVIR vs LaTeX vs 自然语言; Exp-8 消融各模块 |
| 内部 | Golden Model 本身可能有误 | 使用 SymPy 符号计算 + 与标准参考实现交叉验证 |
| 外部 | Benchmark 仅覆盖通信领域 | 明确声明适用范围; 讨论泛化性 |
| 外部 | 模型版本迭代快 | 记录精确模型版本和 API 日期; 多模型对比降低单一依赖 |
| 构建 | Yosys 综合结果可能与商用工具有差异 | Exp-5 中同步使用 Vivado 综合作为参考 |
| 构建 | FVIR op 集可能不够覆盖所有 kernel | 统计 FVIR 覆盖率; 记录需要扩展的情况 |

---

## 更新后的论文结构 (8 章)

```
第一章 绪论
  1.1 研究背景（通信硬件设计瓶颈）
  1.2 问题分析（HLS 局限 + 现有 LLM 工作缺陷：缺乏公式输入、无 IR、无迭代验证）
  1.3 研究目标与三大贡献
  1.4 论文组织

第二章 相关工作
  2.1 LLM 硬件代码生成（VerilogEval, RTLCoder, AutoChip, BetterV, ChipNeMo）
  2.2 高层次综合与传统自动化（HLS 顺序偏差问题）
  2.3 通信算法硬件实现（3GPP/IEEE 标准参考设计）
  2.4 中间表示与程序变换（MLIR, CIRCT, e-graph 启发）
  2.5 迭代式 LLM Agent 系统（ReAct, AutoChip feedback loop）

第三章 CommFormaBench: 通信算法公式级基准集
  3.1 设计原则与分类体系（14 类, 217 kernel）
  3.2 Kernel 定义、参数化与标准来源
  3.3 Golden Model 自动生成
  3.4 与现有 Benchmark (VerilogEval, RTLLM) 的对比
  3.5 基准集使用指南

第四章 FVIR: Agent-Aware 中间表示
  4.1 设计动机（为什么需要专为 LLM 设计的 IR）
  4.2 Op 集设计：5 类极简 op（ELEMENTWISE, REDUCE, MEMORY, CONTROL, CONSTRAINT）
  4.3 约束表达机制
  4.4 Transform Library 设计（与 IR 分离的变换知识库）
  4.5 从 LaTeX 到 FVIR 的自动解析
  4.6 FVIR 覆盖性分析（217 kernel 全部用 5 类 op 表达）

第五章 FormaFlow: 端到端自动化框架
  5.1 系统架构总览
  5.2 Formula Parser (Stage 1)
  5.3 LLM Transform Agent (Stage 2): 多 variant 生成
  5.4 LLM Codegen Agent (Stage 3): FVIR → Verilog
  5.5 验证迭代闭环 (Stage 4): Verilator + Yosys + 回退机制
  5.6 Rank & Iterate (Stage 5): 多目标优化与收敛判断

第六章 实验与分析
  6.1 实验设置（平台、模型、参数）
  6.2 Exp-1: 端到端 Pass Rate（全 Benchmark 通过率）
  6.3 Exp-2: 无顺序偏差验证（FVIR vs C代码 vs HLS 并行度对比）
  6.4 Exp-3: 变换发现能力评估
  6.5 Exp-4: FVIR vs 纯 Prompt（IR 价值量化）
  6.6 Exp-5 & Exp-6: 与 HLS / 手工设计对比
  6.7 Exp-7: 迭代收敛性分析
  6.8 Exp-8: 消融实验
  6.9 不同 LLM 对比
  6.10 失败案例分析与讨论

第七章 讨论
  7.1 主要发现
  7.2 方法适用边界与局限
  7.3 FVIR Op 集设计的取舍（方案 A vs B 消融结果）
  7.4 对硬件设计自动化领域的启示

第八章 结论与展望
  8.1 结论
  8.2 未来工作（ASIC 流程、形式验证、更多领域扩展）
```
