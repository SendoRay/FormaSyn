# FormaSyn — 核心创新点(对标 HPCA / ISCA / MICRO / DAC 级)

> 每个贡献给出一句 **paper-ready 的英文 claim** + 中文展开 + 与已有工作的区分。
> 术语沿用现有文档:FVIR、FormaFlow、CommFormaBench。

---

## 0. 一句话 thesis

**Automatically synthesizing correct, PPA-optimized RTL directly from the *mathematical formula* of a DSP/communication kernel, by casting hardware design-space exploration as a *correctness-gated, LLM-driven evolutionary search over a Pareto front*, enabled by (i) an LLM-agent-native formula IR and (ii) a tolerance-based verification contract with profile-guided fixed-point.**

从"英文/RTL 规格 → 硬件"转为"**数学公式 → 硬件**":公式本身既是最精确、最紧凑的规格,又能**直接派生 golden 参考模型**,从而让闭环功能验证无需人写 spec 即可自动进行。

---

## 1. 问题与动机(为什么值得顶会)

- **通信/DSP 硬件(5G NR、LTE、WiFi、DVB)是设计瓶颈**:kernel 组合爆炸(标准 × 参数 × 目标工艺/频率),手写 RTL 慢、HLS 粒度粗且被 vendor 工具锁定、PPA 不可控。
- **现有 LLM-RTL 工作的三个硬伤**:(a) 输入是自然语言 spec 或已有 RTL,语义含糊;(b) **单次生成、不验证**(至多编译过);(c) **无 PPA 优化、无正确性保证**。
- **软件侧的 LLM 进化搜索(FunSearch/AlphaEvolve/KernelEvolve)** 证明"生成层次可高、靠强验证+反馈取胜",但都面向**软件 kernel**,没有 RTL 的**定点正确性契约**与**PPA 多目标**。

**空白**:没有一个系统把"公式 → 可综合且经仿真验证、PPA-Pareto 最优的 RTL"做成**自动收敛的闭环**。

---

## 2. 关键洞见(Insights)

- **I1 Formula-as-Spec**:数学公式是 DSP kernel 的精确规格,且**直接生成 float golden**,使闭环功能验证摆脱"人写测试/参考"的依赖。
- **I2 正确性是"容差契约"而非逐位相等**:定点 DSP 存在量化自由度,正确性应以 **SQNR/ULP 容差**度量;而量化(Q-format/舍入/溢出)可由**对 float 参考做 profiling 自动推导**(profile-guided fixed-point)。这让"自动验证自动生成的定点 RTL"既有意义又可实现。
- **I3 生成质量受"验证/反馈强度"约束,而非模型规模**:该投资闭环(诊断回喂 + 进化),而非更大 prompt。
- **I4 硬件生成天然多目标**:correctness 为硬约束 + area/Fmax/latency 为 **Pareto 目标**;**LLM 作诊断制导的遗传算子**是自然的变异手段。

---

## 3. 贡献

### C1 — FVIR:面向 LLM Agent 的公式级 IR(Agent-Native IR)
> **A minimal (5-category, ~12-op) Formula-to-Verilog IR co-designed for LLM agents that canonicalizes the input, carries non-functional constraints *and a quantization/tolerance contract*, and exposes parallelism + transform hints — an IR designed for LLM comprehension and closed-loop verification, not for compiler passes.**

- 用**极简 op 集**规范表达 130+ 通信 kernel(消融:方案A极简 vs 方案B领域特化)。
- 与传统编译器 IR(LLVM/MLIR、HLS 前端 IR)本质不同:**为 LLM 的理解与可翻译性**、以及**携带验证契约**而设计。
- 新增(相对已有 FVIR 文档):IR 显式承载 **@qformat/@rounding/@overflow/@tolerance** 契约字段(见 C3),成为量化与验证的 single source of truth。

### C2 — Correctness-Gated Pareto Evolutionary Engine(本次落地的核心机制)
> **The first correctness-gated, multi-objective *evolutionary* RTL search that uses an LLM as a diagnostic-guided genetic operator, keeps a Pareto archive over PPA objectives, lets infeasible candidates climb via a graded fitness, and self-terminates on Pareto-front convergence under an LLM-call (evaluation) budget.**

- **correctness 硬门**(compile + **仿真**通过,非仅编译);PASS 者在 (area↓, Fmax↑, latency↓) 上做**非支配 Pareto**。
- **graded fitness**:compile_fail < sim_fail(按 mismatch 比例) < synth_fail < pass —— 让未通过者也能被选择、朝可行区**爬坡**。
- **LLM = 诊断制导遗传算子**:对失败父代做"带诊断的修复",对 PASS 父代做"降 area 的重写"(承接 AlphaEvolve 的 LLM-as-operator,但目标是 RTL 的 PPA)。
- **终止 = 停滞收敛 + LLM 调用预算兜底**(评估次数即成本代理,对齐 FunSearch/AlphaEvolve 的 sample-budget 实践);**引擎自管代数/每代产出**,用户不再规定"几轮×几个"。
- 区别于软件进化搜索:目标是**硬件 PPA + 定点正确性**;区别于 NSGA-II/BO 的 HW-DSE:**变异算子是 LLM、且从公式端到端**。

### C3 — 面向 Math→RTL 的验证契约(Verification Contract)
> **A verification contract for automatically generated fixed-point RTL: a hybrid *bit-exact / error-tolerant (SQNR·ULP)* equivalence selected by formula type, with *profile-guided* automatic fixed-point (Q-format, rounding, overflow) derived from the formula's floating-point reference.**

- 整数/精确类公式 → bit-exact;有量化自由度的 DSP 类 → **SQNR/ULP 容差**;判据由 FVIR 的 formula 类型决定。
- 量化契约**自动**:用 golden 的 float 真值在随机激励上做 **range analysis + bit-growth 传播**推导每信号 Q-format;溢出/低 SQNR 反馈再量化。
- 这是让闭环验证"对自动生成的定点硬件"**既严谨又可自动化**的关键(现有 LLM-RTL 工作普遍回避了定点正确性这一核心难点)。

### C4 — FormaFlow:开源、可复现、vendor 无关的闭环框架
> **An end-to-end parse→transform→codegen→verify(Verilator+Yosys)→evolve loop with fully open-source, reproducible, vendor-independent verification, where verifier diagnostics are injected back into generation as dynamic instructions.**

- 验证链 **Verilator(仿真)+ Yosys(综合)+ icetime(真实 Fmax)** 全开源,可复现、无 Vivado/Vitis 锁定。
- **诊断回喂**(编译错/仿真 mismatch/面积/时序)进入下一代生成 prompt —— KernelEvolve 式 dynamic instructions 在 RTL 域的落地。

### C5 — CommFormaBench:标准溯源的通信算法基准 + 评测方法学
> **A standards-sourced (3GPP/IEEE/ITU), parameterized benchmark of communication/DSP kernels with golden models and non-functional constraints, plus an evaluation protocol (pass@k, PPA-vs-HLS, IR-vs-prompt ablation, convergence/budget analysis).**

- 每 kernel 溯源标准/白皮书/经典文献,多参数配置,附 golden + 约束。
- 评测协议直接支撑 C1–C4 的量化验证(见 §5)。

---

## 4. 与相关工作的定位(一句话区分)

| 方向 | 代表 | 与本工作的关键区别 |
|---|---|---|
| LLM-RTL 生成 | VeriGen, RTLCoder, ChipGPT, AutoChip | 它们:NL/RTL 输入、单次、无仿真验证、无 PPA。本工作:**公式输入 + 闭环仿真验证 + Pareto PPA 进化**。|
| 高层次综合 HLS | Vitis/Vivado HLS | 粒度粗、vendor 锁定、PPA 不可控。本工作:**细粒度 RTL + 开源可复现 + 多目标自动搜索**(HLS 作对比 baseline)。|
| LLM 进化搜索 | FunSearch, AlphaEvolve, KernelEvolve | 面向**软件 kernel**。本工作:**RTL/定点正确性契约 + 硬件 PPA Pareto**。|
| 多目标 HW-DSE | NSGA-II / Bayesian DSE | 优化的是 HLS pragma/参数,**无 LLM 生成、非公式端到端**。|

---

## 5. 评测计划(需用实验证实的 claim)

1. **端到端 pass rate / pass@k**(全 CommFormaBench,多 backend)。
2. **FVIR vs 纯 prompt** 消融(IR 的价值)。
3. **进化引擎 vs 单次 / 固定轮次**:PPA 改进幅度、收敛代数、预算(LLM 调用数)效率。
4. **PPA vs HLS(Vitis)与手写 RTL**:LUT/FF/DSP/Fmax。
5. **验证契约消融**:bit-exact vs 容差(SQNR/ULP)对 yield 与"正确性可信度"的影响。
6. **跨 LLM 泛化**(DeepSeek / GPT / Claude)。

---

## 6. 实现状态(诚实标注,避免 overclaim)

**已跑通 / 已验证**
- 端到端 **公式→FVIR→变体→codegen→Verilator 仿真→Yosys 综合→rank**,DeepSeek 后端在 `complex_mult` 上 **真实 PASS**(~2.5 min;200 向量逐位匹配;LUT/FF 指标产出)。
- **LoopEngine(C2)** 骨架 + 诊断制导变异:自管代数、**停滞收敛**、**LLM 调用预算兜底**、**Pareto 存档**、断点续跑(`engine_run.json`)均已验证。
- 开源验证链(Verilator 5.050 + Yosys 0.67 + nextpnr-ice40/icetime)已装并自检。

**设计完成 / 实现中**
- C3 验证契约:hybrid 判据 + profile-guided 量化(SQNR/ULP)——已定方案,尚未全部落地(当前仿真为整数逐位比对)。
- 真实 **Fmax**(icetime)接入 → 让 Pareto 真正多目标(当前 Fmax 为 stub,Pareto 退化为最小 area)。
- **接口/时序契约**(强制端口名 + valid 握手 + 小延迟):当前 LLM 变体常因 testbench 假设 sim_fail,契约化后可显著提升单候选命中率与预算效率。
- CommFormaBench 全量 golden(目前仅 complex_mult、crc24 有真 golden)。

---

## 7. 顶会定位备注(诚实)

本工作横跨 **ML-for-EDA / 硬件自动化**。最直接的强命中是 **DAC / ICCAD / DATE / MLSys**;若要冲 **ISCA / HPCA / MICRO**,建议把叙事重心放在:
- "**面向硬件 PPA 的、正确性受约束的自动设计空间探索**"这一**方法学**层面(而非"又一个 LLM 写 Verilog"),
- 用 **CommFormaBench 的规模化 PPA 证据**(vs HLS/手写)+ **收敛/预算的系统性分析**支撑架构级 insight(I2/I3)。

C2(correctness-gated Pareto 进化 + LLM-as-operator + 评估预算)与 C3(math→RTL 验证契约)是最具"顶会新颖性"的两点,建议作为主线。
