# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目简介

FormaSyn 是一个 AI 驱动的编译器框架，将通信算法（LDPC、FIR 等）的数学描述自动转化为可综合的 Verilog FPGA 实现。核心论点：结构化三层 IR 提升 LLM 硬件代码生成能力。使用开源工具链（Verilator + Yosys）进行三级验证。

## 开发规范

### 代码质量
- Python 3.10+，PEP 8 命名（snake_case 函数/变量，PascalCase 类，UPPER_SNAKE_CASE 常量）
- 所有代码必须有类型注解，公共 API 必须有 docstring
- 行宽 119 字符，使用 f-string 格式化
- 函数保持精简、单一职责

### 编码原则
- **简单优先**：最少代码解决问题，不做投机性抽象
- **手术式修改**：只改必须改的，不"顺便"优化相邻代码
- **早返回**：用 early return 避免嵌套
- **DRY**：不重复自己，但三行相似代码优于过早抽象
- **函数式风格**：在不增加复杂度时优先使用不可变/无状态方式
- **配置驱动**：避免硬编码参数

### 行为准则
- **先想后写**：实现前明确假设，有歧义时主动问
- **目标驱动**：将任务转化为可验证的目标，循环直到通过
- **最小变更**：每一行改动都应能追溯到用户需求
- **迭代构建**：从最小可用功能开始，验证后再加复杂度
- **频繁测试**：用真实输入测试，验证输出
- **禁止使用mock**：不允许用任何的mock，或者类似的，跑不同就是跑不同，直接在代码抛出异常，而不是假装用一个mock代码跑通
- **不要改输出**： 我们的框架是生成代码，所以当你发现问题时，你不该直接去改生成的代码 你应该通过改框架 从而使得不会出现这样或者那样的问题，优化代码。 

## 常用命令

### 运行示例

```bash
# FIR 16-tap 低通滤波器
python run.py fir_16tap

# LDPC 校验节点更新（默认度数 dc=8）
python run.py ldpc_cnu

# 调整校验节点度数
python run.py ldpc_cnu --dc 16

# 向量加法
python run.py vec_add
```

### 依赖安装

```bash
pip install numpy scipy networkx openai pyyaml jinja2

# 开源验证工具（可选，缺失时自动跳过）
# Verilator: brew install verilator 或 apt install verilator
# Yosys: brew install yosys 或 apt install yosys
# Icarus Verilog (L1 备选): brew install icarus-verilog
```


## 架构概览

### 管线阶段 (run.py::FormaSynPipeline)

执行管线共 10 个阶段：

1. **DSL 解析** (`formasyn/dsl/parser.py`) — `FormulaGraph` → `MathDialect` (纯数学 DAG)
2. **不规则访问分析** (`formasyn/analysis/irregular_access.py`) — 标记不规则访问节点, 转 H-matrix → CSR (仅图算法)
3. **Golden 模型生成** (`formasyn/golden/`) — float64 C++ 参考模型 + 量化分析
4. **DSE** (`formasyn/agent/dse_agent.py`) — LLM 生成多个硬件变体 (Intent JSON)
5. **模板引擎** (`formasyn/lowering/math_to_algohw.py`) — Intent → `AlgoHWDialect` (近似重写 + 量化 + 并行度 + 质量上界)
6. **RTL 调度** (`formasyn/lowering/algohw_to_rtl.py`) — `AlgoHWDialect` → `RTLScheduleDialect` (ASAP 调度 + 资源预估)
7. **内存布局** (`formasyn/lowering/memory_layout.py`) — BRAM bank 分配 + 地址映射 (仅图算法)
8. **Verilog 代码生成** (`formasyn/codegen/verilog_agent.py`) — `RTLScheduleDialect` → Verilog (LLM 驱动 + scaffold)
9. **Testbench 生成** (`formasyn/codegen/testbench_gen.py`) — SystemVerilog testbench
10. **三层验证** — L1 (Verilator) / L2 (Yosys) / L3 (质量仿真)


### 三层 Dialect 架构

```
DSL / MathDialect (纯数学语义: "算什么")
├── MapOp, ReduceOp, DelayOp, ShiftRegOp, MessagePassOp
├── CycleOp:     body + feedback_edges + init_values → 差分方程
├── IterationOp: body + count + carry → 多级迭代数学结构
└── ❌ 无 strategy, 无 pipeline, 无 unroll, 无任何硬件概念
         ↓ TemplateEngine (lowering/math_to_algohw.py)
AlgoHWDialect (硬件映射: "怎么算")
├── approx_method:      "min_sum" | "lut_tanh" | ...
├── parallelism:        1, 2, 4, 8...
├── quant_int/frac_bits: 量化位宽
└── saturation_guard:   饱和保护
         ↓ RTLScheduler (lowering/algohw_to_rtl.py)
RTLScheduleDialect (RTL 调度: "具体硬件结构")
├── pipeline_stage, latency_cycles, register_output
├── storage_type: register | bram | lutram
├── exec_mode: combinational | pipelined | iterative
├── fsm_states, fsm_transitions
└── 直接映射到 Verilog 结构
```

### Dialect 设计原则

- **DSL 层只有数学**：递归、迭代次数、数据依赖。不知道"硬件"这个概念的存在。任何调度/实现相关的字段都不允许出现在此层。
- **AlgoHW 层做算法级硬件决策**：展开 vs 复用、近似方法、位宽选择。但不指定具体 RTL 结构。
- **RTLSchedule 层映射到 Verilog 结构**：pipeline stage → register boundary, storage_type → reg/BRAM, exec_mode → FSM/pipeline/combinational。
- **信息只向下流动**：高层 dialect 不依赖低层 dialect 的任何字段。新增字段前先问"这属于哪一层？"
- **每层可独立验证**：MathDialect 可以生成 golden C++ 做数值验证；AlgoHWDialect 可以做资源估算；RTLScheduleDialect 可以直接生成 Verilog。

### DSL 算子设计原则

- **描述"是什么"而非"怎么做"**：CycleOp 描述差分方程结构，不描述硬件是用 register 还是 BRAM 实现反馈
- **最小表达力**：如果一个算法能用已有算子组合表达，不新增算子
- **组合优于继承**：CycleOp/IterationOp 内嵌 body（算子列表），而非为每种算法创建专用算子
- **显式数据依赖**：所有信号流通过 `input_ref` → `output_ref` 显式连接，禁止隐式全局状态

### 三级验证

- **L1** (`formasyn/checker/l1_checker.py`): Verilator / Icarus Verilog RTL 仿真, 与 golden 对比 (NMSE/符号错误率)
- **L2** (`formasyn/checker/l2_checker.py`): Yosys 综合, 验证 DSP/BRAM/LUT/FF 资源
- **L3** (`formasyn/checker/l3_checker.py`): Python 质量仿真 (BER/SFDR/EVM/RMSE)

### 反馈循环

`formasyn/feedback/loop.py` + `formasyn/agent/diagnostic.py`: 三级嵌套迭代。验证失败时由 LLM 诊断故障原因，决策回退层：
- **内层** (codegen): 重新生成 Verilog
- **中层** (schedule): 调整 RTL 调度参数（并行度、pipeline stage）
- **外层** (DSE): 触发新一轮设计空间探索

## 模块分布

| 模块 | 路径 | 职责 |
|------|------|------|
| DSL | `formasyn/dsl/` | 7 种算子 (`MapOp`, `ReduceOp`, `DelayOp`, `ShiftRegOp`, `MessagePassOp`, `CycleOp`, `IterationOp`) + `FormulaGraph` |
| IR | `formasyn/ir/` | 三层 IR：`MathDialect` → `AlgoHWDialect` → `RTLScheduleDialect` |
| Lowering | `formasyn/lowering/` | 降级 pass：`math_to_algohw` (模板引擎), `algohw_to_rtl` (ASAP 调度), `memory_layout` (BRAM 映射) |
| Codegen | `formasyn/codegen/` | LLM Verilog 生成 (`verilog_agent`), 模块骨架 (`scaffold`), testbench (`testbench_gen`) |
| Agent | `formasyn/agent/` | LLM 代理 (DSE/诊断), 知识注入 (`knowledge_prompt.py`) |
| Golden | `formasyn/golden/` | C++ 参考模型、量化分析、测试台生成 |
| Checker | `formasyn/checker/` | L1 (Verilator) / L2 (Yosys) / L3 (质量仿真) + 信号质量模拟器 |
| Analysis | `formasyn/analysis/` | 不规则访问分析 (`irregular_access`) + 区间分析 + 频谱诊断 |
| Feedback | `formasyn/feedback/` | 三级嵌套反馈循环 (`loop.py`) |
| Rewrites | `formasyn/rewrites/` | 代数重写规则 + 质量上界证明 (已集成到 TemplateEngine) |
| Research | `formasyn/research/optimizer/` | NSGA-II Pareto 优化 (研究原型, 未接入管线) |

## 关键设计约束

- 项目无 `pyproject.toml` 或 `requirements.txt` — 直接以 `python run.py` 方式运行
- 示例注册在 `run.py::ExampleSpec` 字典中, 每个示例需提供 `kernel.py` + `constraints.yaml`
- 产物输出目录: `examplesbk/<name>/<variant_id>/<kernel_name>_top.v`
- Verilator/Yosys 缺失时自动跳过对应验证层

## 架构不变量（修改代码时必须遵守）

1. **Dialect 层次隔离**：DSL 层禁止出现硬件/调度概念；AlgoHW 层禁止出现 RTL 细节
2. **LLM 是核心代码生成器**：LLM 根据结构化 IR (RTLScheduleDialect JSON) + scaffold 模板生成 Verilog。这是本项目的核心研究论点。
3. **每条重写规则必须有 QualityBound**：`formasyn/rewrites/` 中的规则必须声明可证明的质量退化上界
4. **信号名串联依赖**：算子间通过 `output_ref` → `input_ref` 显式连接，parser 据此构建 DAG
5. **kernel_type 统一命名**：使用 `channel_coding`（不是 `ldpc`）、`filtering`、`transform`、`detection`、`demodulation`、`synchronization`、`elementwise`
6. **验证层独立性**：L1 需要 Verilator/Icarus，L2 需要 Yosys，L3 需要 Python 质量模拟器。各层可独立跳过

## 三个研究方向

### 方向 A：形式化近似保证 (`formasyn/rewrites/` + `formasyn/analysis/interval.py`)
- 定义代数重写规则 (Pattern → Replacement)，每条附带可证明的质量上界
- LLM 搜索规则组合空间，而非直接写代码
- 区间分析引擎自动推导最小安全位宽

### 方向 B：频谱反馈驱动 IR 修复 (`formasyn/analysis/spectral.py`)
- L3 失败时，从信号退化的频谱特征反推哪个 IR 节点需要修复
- 局部修复（某节点 +2 frac_bits）替代全局放松（所有节点 +2 bits）

### 方向 C：跨层联合 Pareto 优化 (`formasyn/research/optimizer/pareto.py`)
- 同时在 Math×AlgoHW×RTLSchedule 三层搜索
- 研究原型, 未接入管线

## 添加新示例

1. 在 `examples/<name>/kernel.py` 中使用 DSL `FormulaGraph` 定义算法拓扑
2. 在 `examples/<name>/constraints.yaml` 中声明硬件约束和容差
3. 在 `run.py` 的 `ExampleSpec` 注册表中添加一条记录（如需额外参数/CSR 钩子）
