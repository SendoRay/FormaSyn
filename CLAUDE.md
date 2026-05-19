# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目简介

FormaSyn 是一个 AI 驱动的编译器框架，将通信算法（LDPC、FIR 等）的数学描述自动转化为可综合的 Vitis HLS C++ FPGA 实现，包含三级验证流水线。

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
pip install numpy scipy networkx openai pyyaml
```


## 架构概览

### 管线阶段 (run.py::FormaSynPipeline)

执行管线共 7 个阶段：

1. **DSL 解析** (`formasyn/dsl/parser.py`) — `FormulaGraph` → `MathDialect` (纯数学 DAG)
2. **MLC 分析** (`formasyn/mlc/`) — 标记不规则访问节点, 转 H-matrix → CSR (仅图算法)
3. **Golden 模型生成** (`formasyn/golden/`) — float64 C++ 参考模型 + 量化分析
4. **DSE** (`formasyn/agent/dse_agent.py`) — LLM 生成多个硬件变体 (Intent JSON)
5. **模板引擎** (`formasyn/dsl/template_engine.py`) — Intent → `AlgoHWDialect` (近似重写 + 量化 + 并行度 + 质量上界)
6. **ScheduleBuilder** (`formasyn/solver/schedule_builder.py`) — `AlgoHWDialect` → `HLSScheduleDialect` (pragma 分配 + 资源预估)
7. **MLC 编译** (`formasyn/mlc/`) — BRAM bank 分配 + 地址映射代码生成 (仅图算法)
8. **代码生成** (`formasyn/agent/codegen_agent.py`) — `HLSScheduleDialect` → kernel.cpp/h



### 三层 Dialect 架构

```
DSL / MathDialect (纯数学语义: "算什么")
├── MapOp, ReduceOp, DelayOp, ShiftRegOp, MessagePassOp
├── CycleOp:     body + feedback_edges + init_values → 差分方程
├── IterationOp: body + count + carry → 多级迭代数学结构
└── ❌ 无 strategy, 无 pipeline, 无 unroll, 无任何硬件概念
         ↓ TemplateEngine 降级
AlgoHWDialect (硬件映射: "怎么算")
├── iteration_strategy: "pipelined" | "iterative"
├── approx_method:      "min_sum" | "lut_tanh" | ...
├── parallelism:        1, 2, 4, 8...
├── quant_int/frac_bits: 量化位宽
└── saturation_guard:   饱和保护
         ↓ ScheduleBuilder 降级
HLSScheduleDialect (调度: "具体 pragma 怎么写")
├── unroll_factor, pipeline_ii, array_partition_type
├── bram_banks, tile_size, address_mapping_code
└── 直接映射到 #pragma HLS 指令
```

### Dialect 设计原则

- **DSL 层只有数学**：递归、迭代次数、数据依赖。不知道"硬件"这个概念的存在。任何调度/实现相关的字段（strategy, unroll, pipeline）都不允许出现在此层。
- **AlgoHW 层做算法级硬件决策**：展开 vs 复用、近似方法、位宽选择。但不指定具体 pragma 值。
- **Schedule 层翻译为 pragma 参数**：直接对应 Vitis HLS 的 `#pragma HLS PIPELINE II=`, `ARRAY_PARTITION`, `UNROLL` 等。
- **信息只向下流动**：高层 dialect 不依赖低层 dialect 的任何字段。新增字段前先问"这属于哪一层？"
- **每层可独立验证**：MathDialect 可以生成 golden C++ 做数值验证；AlgoHWDialect 可以做资源估算；ScheduleDialect 可以直接生成 HLS 代码。

### DSL 算子设计原则

- **描述"是什么"而非"怎么做"**：CycleOp 描述差分方程结构，不描述硬件是用 register 还是 BRAM 实现反馈
- **最小表达力**：如果一个算法能用已有算子组合表达，不新增算子
- **组合优于继承**：CycleOp/IterationOp 内嵌 body（算子列表），而非为每种算法创建专用算子
- **显式数据依赖**：所有信号流通过 `input_ref` → `output_ref` 显式连接，禁止隐式全局状态

### 三级验证

- **L1** (`formasyn/checker/l1_checker.py`): g++ 编译, 与 golden 对比 (NMSE/符号错误率)
- **L2** (`formasyn/checker/l2_checker.py`): Vitis HLS csim + csynth, 验证 DSP/BRAM/II
- **L3** (`formasyn/checker/l3_checker.py`): Co-Sim + 信号质量 (BER/SFDR/EVM/RMSE)

### 反馈循环

`formasyn/feedback/loop.py` + `formasyn/agent/diagnostic.py`: 验证失败时由 LLM 诊断故障原因并回退到对应 IR 层重试。

## 模块分布

| 模块 | 路径 | 职责 |
|------|------|------|
| DSL | `formasyn/dsl/` | 7 种算子 (`MapOp`, `ReduceOp`, `DelayOp`, `ShiftRegOp`, `MessagePassOp`, `CycleOp`, `IterationOp`) + `FormulaGraph` |
| IR | `formasyn/ir/` | 三层 IR：`MathDialect` → `AlgoHWDialect` → `HLSScheduleDialect` |
| Agent | `formasyn/agent/` | LLM 代理 (DSE/代码生成/诊断), 知识注入 (`knowledge_prompt.py`) |
| Golden | `formasyn/golden/` | C++ 参考模型、量化分析、测试台生成 |
| Checker | `formasyn/checker/` | L1/L2/L3 验证 + 信号质量模拟器 (BER/Filter/Transform/Detection/Sync) |
| Solver | `formasyn/solver/` | `ScheduleBuilder`: pragma 分配 + 资源预估 (AlgoHW → Schedule) |
| MLC | `formasyn/mlc/` | `MemoryLayoutPass`: 不规则访问分析 + BRAM 映射 (统一类, 两阶段方法) |
| Rewrites | `formasyn/rewrites/` | 代数重写规则 + 质量上界证明 (已集成到 TemplateEngine) |
| Analysis | `formasyn/analysis/` | 区间分析 + BER bound 验证 + 频谱诊断 (待集成) |
| Research | `formasyn/research/optimizer/` | NSGA-II Pareto 优化 (研究原型, 未接入管线) |

## 关键设计约束

- 项目无 `pyproject.toml` 或 `requirements.txt` — 直接以 `python run.py` 方式运行
- 示例注册在 `run.py::ExampleSpec` 字典中, 每个示例需提供 `kernel.py` + `constraints.yaml`
- 产物输出目录: `examplesbk/<name>/<variant_id>/kernel.cpp`
- 超资源变体在 ScheduleBuilder 阶段标记 `SKIP`, 不会中断管线

## 架构不变量（修改代码时必须遵守）

1. **Dialect 层次隔离**：DSL 层禁止出现硬件/调度概念；AlgoHW 层禁止出现 pragma 细节
2. **LLM 是工具不是核心**：LLM 搜索重写规则组合 / 生成 intent / 诊断故障，不直接写最终 HLS 代码的关键路径
3. **每条重写规则必须有 QualityBound**：`formasyn/rewrites/` 中的规则必须声明可证明的质量退化上界
4. **信号名串联依赖**：算子间通过 `output_ref` → `input_ref` 显式连接，parser 据此构建 DAG
5. **kernel_type 统一命名**：使用 `channel_coding`（不是 `ldpc`）、`filtering`、`transform`、`detection`、`demodulation`、`synchronization`、`elementwise`
6. **验证层独立性**：L1 只需 g++，L2 需要 Vitis HLS，L3 需要 Vitis + 质量模拟器。各层可独立跳过

## 三个研究方向

### 方向 A：形式化近似保证 (`formasyn/rewrites/` + `formasyn/analysis/interval.py`)
- 定义代数重写规则 (Pattern → Replacement)，每条附带可证明的质量上界
- LLM 搜索规则组合空间，而非直接写代码
- 区间分析引擎自动推导最小安全位宽

### 方向 B：频谱反馈驱动 IR 修复 (`formasyn/analysis/spectral.py`)
- L3 失败时，从信号退化的频谱特征反推哪个 IR 节点需要修复
- 局部修复（某节点 +2 frac_bits）替代全局放松（所有节点 +2 bits）

### 方向 C：跨层联合 Pareto 优化 (`formasyn/research/optimizer/pareto.py`)
- 同时在 Math×AlgoHW×Schedule 三层搜索
- 研究原型, 未接入管线 (DesignPoint 的 schedule 参数会被 ScheduleBuilder 覆盖)

## 添加新示例

1. 在 `examples/<name>/kernel.py` 中使用 DSL `FormulaGraph` 定义算法拓扑
2. 在 `examples/<name>/constraints.yaml` 中声明硬件约束和容差
3. 在 `run.py` 的 `ExampleSpec` 注册表中添加一条记录（如需额外参数/CSR 钩子）
