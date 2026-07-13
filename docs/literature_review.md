# 文献调研报告：基于大语言模型的通信算法硬件设计自动化方法

> 调研日期：2026-06-02  
> 知识截止：2025年5月  
> 目标：为学位论文级别的文献综述提供基础

---

## 一、LLM 生成 Verilog/HDL 代码的现有工作

### 1.1 基准测试与评估

| 论文 | 作者 | 年份 | 会议/期刊 | 核心贡献 |
|------|------|------|-----------|----------|
| **VerilogEval: Evaluating Large Language Models for Verilog Code Generation** | Liu et al. | 2023 | ICCAD 2023 | 首个系统性 LLM Verilog 生成基准，包含 156 个问题，发现 GPT-4 在简单模块上 pass@1 约 60%，复杂模块显著下降 |
| **RTLLM: An Open-Source Benchmark for Design RTL Generation with Large Language Model** | Lu et al. | 2024 | ASP-DAC 2024 | 30 个 RTL 设计任务（组合逻辑+时序逻辑+FSM），评估功能正确性、语法正确性、综合可行性 |
| **VerilogEval-v2** | Pinckney et al. | 2024 | DAC 2024 | 扩展版基准，增加了参数化模块和层次化设计的评估 |

### 1.2 LLM Verilog 生成方法

| 论文 | 作者 | 年份 | 会议/期刊 | 核心贡献 |
|------|------|------|-----------|----------|
| **ChipGPT: How Far Are We from Natural Language Hardware Design** | Chang et al. | 2023 | arXiv | 利用 LLM 从自然语言规格生成 Verilog，提出"对话式芯片设计"流程 |
| **VeriGen: A Large Language Model for Verilog Code Generation** | Thakur et al. | 2023 | arXiv | 在 GitHub Verilog 代码上微调 CodeGen 模型，证明领域微调显著提升 HDL 生成质量 |
| **RTLCoder: Outperforming GPT-3.5 in Design RTL Generation with Our Open-Source Dataset and Lightweight Solution** | Liu et al. | 2024 | arXiv | 开源 RTL 代码生成模型，通过高质量数据集和轻量级微调策略超越 GPT-3.5 |
| **BetterV: Controlled Verilog Generation with Discriminative Guidance** | Pei et al. | 2024 | ICML 2024 | 使用判别式引导控制 Verilog 生成质量，提升语法和功能正确性 |
| **AutoChip: Automating HDL Generation Using LLM Feedback** | Thakur et al. | 2023 | MLCAD 2023 | 利用编译器反馈迭代修正 LLM 生成的 Verilog，pass rate 从 34% 提升到 77% |
| **ChipChat: Challenges and Opportunities in Conversational Hardware Design** | Blocklove et al. | 2023 | MLCAD 2023 | 系统研究人-LLM 对话式硬件设计的可行性与挑战 |
| **DAVE: Deriving Automatically Verilog from English** | Pearce et al. | 2020 | MLCAD 2020 | 早期工作，使用 GPT-2 从英文描述生成简单 Verilog |

### 1.3 LLM 在 EDA 全流程中的应用

| 论文 | 作者 | 年份 | 会议/期刊 | 核心贡献 |
|------|------|------|-----------|----------|
| **ChipNeMo: Domain-Adapted LLMs for Chip Design** | Liu et al. (NVIDIA) | 2023 | arXiv/ISCA 2024 | NVIDIA 内部数据训练的芯片设计专用 LLM，用于工程助手、EDA 脚本生成、Bug 总结 |
| **ChatEDA: A Large Language Model Powered Autonomous Agent for EDA** | He et al. | 2024 | TCAD | 基于 LLM 的 EDA 自主代理，可调用 OpenROAD 等工具完成完整物理设计流程 |
| **LLM4DV: Using Large Language Models for Hardware Test Stimulus Generation** | Zhang et al. | 2024 | arXiv | LLM 生成验证测试激励，覆盖率提升显著 |
| **AssertLLM: Generating and Evaluating Hardware Verification Assertions** | Fang et al. | 2024 | DAC 2024 | LLM 自动生成 SVA 断言用于形式验证 |
| **HDLCopilot** | — | 2024 | — | IDE 集成的 HDL 代码辅助工具 |

### 1.4 综述论文

| 论文 | 作者 | 年份 | 核心内容 |
|------|------|------|----------|
| **Large Language Models for EDA: A Survey** | Zhong et al. | 2024 | 全面综述 LLM 在 EDA 各阶段的应用，包括 RTL 生成、验证、物理设计 |
| **AI/ML Algorithms and Applications in VLSI Design and Technology** | Huang et al. | 2024 | 综述 AI/ML 在 VLSI 设计中的应用 |

### 1.5 关键发现总结

1. **当前 LLM 生成 Verilog 的主要局限**：
   - 简单模块（MUX、加法器、计数器）成功率高（>80%）
   - 复杂时序逻辑（FSM、流水线、存储控制器）成功率低（<30%）
   - 几乎没有针对**通信算法**这类数学密集型硬件的工作
   - 缺乏对**并行性提取**和**定点量化**的系统研究

2. **研究空白（你的机会）**：
   - 现有工作多从自然语言/伪代码出发 → 你提出从**数学公式**出发
   - 现有工作未关注 LLM 的顺序偏差问题 → 你的核心创新点
   - 没有人系统研究 LLM 的**公式变换能力**用于硬件优化

---

## 二、高层次综合（HLS）与传统自动化方法

### 2.1 HLS 基本原理与工具

| 工具/方法 | 厂商 | 输入语言 | 核心技术 |
|-----------|------|----------|----------|
| Vivado HLS / Vitis HLS | Xilinx (AMD) | C/C++/SystemC | 调度+绑定+FSM 生成 |
| Catapult HLS | Siemens (Mentor) | C++/SystemC | 高级优化、位精确建模 |
| Intel HLS Compiler | Intel (Altera) | C++ | OpenCL 集成 |
| Bambu | 学术界 | C | 开源 HLS |
| LegUp | 学术界 | C | LLVM 后端 HLS |

### 2.2 HLS 在通信领域的应用

| 论文/工作 | 核心内容 |
|-----------|----------|
| **HLS-based LDPC decoder** (多篇) | 用 C/C++ 描述 min-sum 算法，HLS 生成硬件；但资源效率通常比手写低 30-50% |
| **HLS for OFDM baseband** | FFT/IFFT 模块 HLS 实现，需要大量 pragma 指导并行化 |
| **SDR (Software Defined Radio) with HLS** | GNU Radio 算法到 FPGA 的映射尝试 |

### 2.3 HLS 的根本局限性（与你的研究高度相关）

1. **输入已被顺序化污染**：
   - HLS 的输入是 C/C++ 代码——本身就是顺序执行的程序
   - 工程师写 C 代码时已经不自觉地引入了执行顺序
   - HLS 工具需要通过`#pragma`（如 `PIPELINE`、`UNROLL`、`ARRAY_PARTITION`）来"恢复"并行性
   - 这本质上是"先破坏并行性，再尝试恢复"的悖论

2. **数学语义丢失**：
   - C 代码中 `a * b + c * d` 只是标量运算，HLS 不知道这是向量内积
   - 数学公式中的结构信息（对称性、可分解性）在 C 代码中不可见
   - HLS 无法自动发现代数等价变换

3. **量化需要人工介入**：
   - 浮点→定点转换需要人工分析数据范围
   - HLS 工具提供位精确类型（如 `ap_fixed<16,8>`）但位宽选择靠人

4. **设计空间探索有限**：
   - HLS pragma 组合的探索空间巨大
   - 传统 DSE 方法（遗传算法、贝叶斯优化）计算成本高
   - 无法探索"算法层面"的变换

### 2.4 与你研究的对比定位

```
传统流程：  数学公式 → [人工] → C代码 → [HLS] → RTL
                         ↑ 顺序偏差引入点
                         ↑ 数学语义丢失点

你的方法：  数学公式 → [LLM] → Verilog RTL
                      ↑ 保留数学语义
                      ↑ 无顺序偏差
                      ↑ 可做等价/近似变换
```

---

## 三、通信算法硬件实现的特点与挑战

### 3.1 典型通信算法的硬件实现特征

| 算法 | 核心运算 | 并行性特征 | 量化挑战 | 典型硬件结构 |
|------|----------|-----------|----------|-------------|
| **LDPC 译码 (Min-Sum)** | 比较、加减法 | 高度并行：每个校验节点/变量节点可独立计算 | 消息位宽敏感，通常 5-8 bit | 部分并行/全并行展开 |
| **Turbo 译码 (MAP/BCJR)** | 加法（log域）、比较、查表 | 前向/后向递归有数据依赖，滑窗技术打破依赖 | 状态度量需要归一化防溢出 | 串行+交织并行 |
| **OFDM 调制解调** | FFT/IFFT、复数乘法 | 蝶形运算天然并行；不同级间有依赖 | 需要缩放防止溢出 | 流水线蝶形/存储器型 |
| **Polar 码 SC 译码** | 比较、XOR | 树状结构，级间有依赖 | 相对简单 | 树形展开/折叠 |
| **信道估计 (LS/MMSE)** | 矩阵求逆、乘法 | 矩阵运算可并行化 | 矩阵求逆精度敏感 | 脉动阵列/分解法 |
| **数字滤波器 (FIR)** | 乘累加 (MAC) | 高度并行：每个 tap 独立 | 系数量化影响滤波特性 | 直接型/转置型/脉动阵列 |

### 3.2 通信算法硬件设计的核心挑战

**挑战1：并行性提取**
- 算法论文中公式通常以迭代/递归形式表达（顺序语义）
- 例如 LDPC 的消息传递：`L_q(j→i) = L_ch(j) + Σ_{i'≠i} L_r(i'→j)`
  - 数学上所有 j→i 消息可并行计算
  - 但写成 for 循环就变成串行了
  - 硬件工程师需要"看穿"公式找到并行性

**挑战2：定点量化**
- 通信系统 BER 对量化高度敏感
- 需要统计仿真确定每个中间变量的动态范围
- 位宽选择是精度-面积权衡

**挑战3：算法级变换**
- 同一算法有多种数学等价形式，硬件成本差异巨大
  - 例：LDPC Min-Sum vs. Normalized Min-Sum vs. Offset Min-Sum
  - 例：FFT Radix-2 vs. Radix-4 vs. Split-Radix
  - 例：CORDIC 展开次数选择
- 工程师需要丰富经验才能选择最优形式

**挑战4：吞吐率-面积-功耗权衡**
- 通信系统有严格的吞吐率要求（如 5G NR 要求 20 Gbps）
- 需要流水线化、折叠、资源共享等架构技术
- 这些决策目前完全依赖人工经验

### 3.3 这些挑战为什么为 LLM 创造了机会

| 挑战 | LLM 的潜在优势 |
|------|----------------|
| 并行性提取 | 从公式直接看到数据依赖关系，不受顺序代码影响 |
| 定点量化 | 可能从训练中学到"通信系统中此类信号通常用 X bit"的经验 |
| 算法级变换 | "联想"到大量已知的等价/近似变换技巧 |
| 架构权衡 | 可能从海量设计案例中学到 throughput-area tradeoff 的经验法则 |

---

## 四、LLM 数学公式理解与变换能力

### 4.1 LLM 数学推理能力的研究

| 论文 | 年份 | 核心发现 |
|------|------|----------|
| **Minerva: Solving Quantitative Reasoning Problems with Language Models** (Google) | 2022 | 在数学问题上通过 chain-of-thought 推理达到接近人类水平 |
| **Llemma: An Open Language Model for Mathematics** | 2023 | 数学领域预训练显著提升数学推理和符号计算能力 |
| **WizardMath** | 2023 | 通过 RLHF 强化数学推理 |
| **DeepSeek-Math** | 2024 | 开源数学推理模型，在 MATH 和 GSM8K 上表现优秀 |
| **InternLM-Math** | 2024 | 形式化数学证明能力 |

### 4.2 LLM 符号计算与公式变换

| 能力 | 现有证据 | 与你研究的关联 |
|------|----------|----------------|
| **代数化简** | LLM 可以进行基本代数变换（展开、因式分解、三角恒等式） | 可用于发现更高效的硬件表达式 |
| **级数展开** | Taylor 展开、Laurent 展开 | 用于近似实现（如查表+多项式近似） |
| **矩阵分解** | LU、QR、SVD 的识别和分解 | 用于矩阵运算的硬件分解实现 |
| **等价变换** | 分配律、结合律、交换律的灵活运用 | 重排运算顺序以减少关键路径或资源 |
| **量化分析** | 可分析表达式的数值范围和精度需求 | 辅助定点位宽决策 |

### 4.3 LLM "联想"能力与硬件优化的交叉

这是你研究中最具创新性的点。LLM 可能实现的变换示例：

```
输入公式：y = A * sin(2πft + φ)

人类工程师思路（顺序）：
1. 计算 2πft + φ
2. 查表得 sin(·)
3. 乘以 A

LLM 可能联想到的变换：
- sin(α+β) = sin(α)cos(β) + cos(α)sin(β)  → 两个小查表 + 乘加
- CORDIC 旋转实现 → 纯移位+加法，无乘法器
- 如果 A 是 2 的幂 → 移位代替乘法
- 如果 f 是固定的 → 预计算相位增量，用 NCO 结构
```

```
输入公式：LDPC Variable Node Update
L_q(j→i) = L_ch(j) + Σ_{i'∈M(j)\i} L_r(i'→j)

LLM 可能的变换：
- 识别出 Σ_{i'∈M(j)\i} = Σ_{i'∈M(j)} - L_r(i→j)
  → 先算总和，再减去当前项（减少加法器数量）
- 识别出度数固定时可用树形加法器（深度 log₂(d)）
- 联想到 Normalized Min-Sum 近似（若允许近似）
```

### 4.4 关键相关工作：AI 辅助代数变换

| 方向 | 代表工作 | 与你研究的关系 |
|------|----------|----------------|
| **E-graph rewriting** (egg library) | Willsey et al., 2021 | 等式饱和搜索等价表达式——LLM 可作为启发式替代 |
| **TASO: Optimizing DNN Computation with Automatic Generation of Graph Substitutions** | Jia et al., 2019 (SOSP) | 自动发现计算图等价变换——理念类似 |
| **Halide 自动调度** | Adams et al., 2019 | 将算法和调度分离——类似你"让 LLM 同时处理两者" |
| **TVM/Ansor 自动张量程序优化** | Zheng et al., 2020 | 搜索空间中的等价变换——LLM 可能更高效地探索 |
| **Denali: A Goal-Directed Superoptimizer** | Joshi et al., 2002 | 利用等式推理的超级优化——LLM 可作为新的搜索引擎 |

---

## 五、LLM 在 EDA/芯片设计中的应用现状

### 5.1 应用层次分类

```
抽象层次（从高到低）：

[系统级]  自然语言 → 架构规格        ← ChipGPT, ChipChat
[RTL级]   规格 → Verilog/VHDL        ← VeriGen, RTLCoder, BetterV, AutoChip
[验证级]  需求 → Testbench/Assertion  ← LLM4DV, AssertLLM
[物理级]  RTL → 布局布线              ← ChatEDA (调用 OpenROAD)
[调试级]  日志 → Bug 定位             ← ChipNeMo

你的研究定位：
[算法级]  数学公式 → 优化的 Verilog   ← 🆕 目前无人做
```

### 5.2 目前的技术瓶颈

1. **生成正确性不足**：复杂设计的功能正确率 <30%
2. **缺乏时序感知**：LLM 不理解时钟、复位、建立时间
3. **无法处理大规模设计**：上下文窗口限制（即使 100K tokens 也不够大型 SoC）
4. **缺乏物理约束感知**：不了解面积、功耗、时序约束
5. **验证困难**：生成的代码难以保证等价性

### 5.3 学术界与工业界的差异

| 维度 | 学术界 | 工业界 |
|------|--------|--------|
| 目标模块规模 | 小模块（<500行） | 大型 IP（万行级） |
| 验证标准 | 功能仿真通过 | 形式等价性验证 |
| 时序要求 | 忽略 | 必须满足时序收敛 |
| 应用场景 | 证明概念可行 | 量产芯片 |

---

## 六、综合分析：你的研究定位与创新点

### 6.1 研究空白地图

```
            已有工作                    空白（你的机会）
         ┌────────────┐            ┌────────────────────┐
输入     │ 自然语言    │            │ 数学公式           │
         │ C/C++ 代码  │            │ 算法伪代码(数学形式)│
         └────────────┘            └────────────────────┘
                                   
变换     │ 直接翻译    │            │ 等价/近似变换      │
         │ (无优化)    │            │ 并行性提取         │
         └────────────┘            │ 自动量化           │
                                   └────────────────────┘
                                   
领域     │ 通用数字逻辑│            │ 通信算法专用       │
         │ (计数器/FSM)│            │ (LDPC/OFDM/Turbo) │
         └────────────┘            └────────────────────┘
```

### 6.2 你的三大创新点

1. **从数学公式到 Verilog 的直接路径**（跳过 C 代码中间表示）
2. **利用 LLM 的无顺序偏差特性**提取最大并行性
3. **利用 LLM 的公式变换能力**发现人类工程师忽略的优化机会

### 6.3 潜在风险与需要验证的假设

| 假设 | 风险 | 验证方法 |
|------|------|----------|
| LLM 真的没有顺序偏差 | LLM 训练数据中大量是顺序代码，可能已学到顺序偏好 | 实验：对比 LLM 从公式 vs. 从C代码生成硬件的并行度差异 |
| LLM 能做有效的公式变换 | 变换可能不保证等价性或误差可控 | 实验：形式验证或大量仿真验证变换正确性 |
| LLM 生成的 Verilog 功能正确 | 通信算法复杂，错误率可能高 | 实验：与 golden model 对比 BER 性能 |
| 优于 HLS | HLS 工具也在进步，加上 pragma 后可能也很好 | 实验：同一算法对比资源/性能/开发时间 |

### 6.4 建议的实验算法选择

从简单到复杂排列：

| 级别 | 算法 | 为什么选它 |
|------|------|-----------|
| ★☆☆ | FIR 滤波器 | 公式简单（MAC），并行性明确，适合初步验证 |
| ★☆☆ | NCO（数控振荡器） | 涉及三角函数→CORDIC变换 |
| ★★☆ | FFT (Radix-2/4) | 蝶形运算，有多种并行化策略 |
| ★★☆ | LDPC Min-Sum 译码 | 高度并行，有经典近似变换 |
| ★★★ | Turbo MAP 译码 | 数据依赖复杂，需要打破递归 |
| ★★★ | MIMO 检测 (ZF/MMSE) | 矩阵运算，精度敏感 |

---

## 七、推荐阅读的核心参考文献清单

### 必读（直接相关）

1. Liu et al., "VerilogEval: Evaluating Large Language Models for Verilog Code Generation," ICCAD 2023
2. Lu et al., "RTLLM: An Open-Source Benchmark for Design RTL Generation with Large Language Model," ASP-DAC 2024
3. Thakur et al., "VeriGen: A Large Language Model for Verilog Code Generation," arXiv 2023
4. Thakur et al., "AutoChip: Automating HDL Generation Using LLM Feedback," MLCAD 2023
5. Liu et al., "RTLCoder: Outperforming GPT-3.5 in Design RTL Generation," arXiv 2024
6. Pei et al., "BetterV: Controlled Verilog Generation with Discriminative Guidance," ICML 2024
7. Liu et al. (NVIDIA), "ChipNeMo: Domain-Adapted LLMs for Chip Design," 2023
8. Zhong et al., "Large Language Models for EDA: A Survey," 2024
9. Blocklove et al., "ChipChat: Challenges and Opportunities in Conversational Hardware Design," MLCAD 2023
10. He et al., "ChatEDA: A Large Language Model Powered Autonomous Agent for EDA," TCAD 2024

### 重要参考（HLS与通信硬件）

11. Xilinx, "Vivado HLS User Guide" (理解 HLS 工作原理与局限)
12. Cong et al., "High-Level Synthesis for FPGAs: From Prototyping to Deployment," TCAD 2011
13. Coussy & Morawiec, "High-Level Synthesis: From Algorithm to Digital Circuit," Springer 2008
14. Chen & Parhi, "Architecture of LDPC Decoders," IEEE Trans. VLSI 2007
15. Boutillon et al., "VLSI Architectures for the BP Algorithm," IEEE Trans. VLSI 2003

### 重要参考（数学变换与优化）

16. Willsey et al., "egg: Fast and Extensible Equality Saturation," POPL 2021
17. Jia et al., "TASO: Optimizing DNN Computation with Automatic Generation of Graph Substitutions," SOSP 2019
18. Volder, "The CORDIC Trigonometric Computing Technique," IRE Trans. 1959 (经典)
19. Meher et al., "50 Years of CORDIC: Algorithms, Architectures, and Applications," IEEE Trans. Circuits Syst. 2009

### 补充参考（LLM数学推理）

20. Lewkowycz et al., "Minerva: Solving Quantitative Reasoning Problems with LLMs," 2022
21. Azerbayev et al., "Llemma: An Open Language Model for Mathematics," 2023
22. Shao et al., "DeepSeekMath: Pushing the Limits of Mathematical Reasoning," 2024

---

## 八、下一步建议

1. **立即可做**：选择 FIR 滤波器或 LDPC Min-Sum，尝试让 GPT-4/Claude 直接从数学公式生成 Verilog，观察结果
2. **验证假设**：对比 LLM 从 "数学公式输入" vs. "C代码输入" 生成的硬件并行度差异
3. **建立评估框架**：定义评估指标（功能正确性、资源利用、并行度、时序性能）
4. **深入调研**：阅读上述核心文献，特别关注 HLS 局限性和通信算法硬件实现的经典工作
