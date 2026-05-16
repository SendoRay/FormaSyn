# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目简介

FormaSyn 是一个 AI 驱动的编译器框架，将通信算法（LDPC、FIR 等）的数学描述自动转化为可综合的 Vitis HLS C++ FPGA 实现，包含三级验证流水线。

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


### 依赖安装

```bash
pip install numpy scipy networkx openai pyyaml
```

### 代码检查 (无配置文件，手动运行)

```bash
ruff check formasyn/
mypy formasyn/
```

## 架构概览

### 管线阶段 (run.py::FormaSynPipeline)

执行管线共 7 个阶段：

1. **DSL 解析** (`formasyn/dsl/parser.py`) — `FormulaGraph` → `MathDialect` (纯数学 DAG)
2. **Golden 模型生成** (`formasyn/golden/`) — float64 C++ 参考模型 + 量化分析
3. **DSE** (`formasyn/agent/dse_agent.py`) — LLM 生成多个硬件变体 (Intent JSON)
4. **模板引擎** (`formasyn/dsl/template_engine.py`) — Intent → `AlgoHWDialect` (含量化/近似/并行度)
5. **RooflineSolver** (`formasyn/solver/roofline_solver.py`) — `AlgoHWDialect` → `HLSScheduleDialect` (循环展开/pipeline/分块, 估算 DSP/BRAM)
6. **MLC** (`formasyn/mlc/`) — 不规则访问分析 + BRAM 映射 (图算法可选)
7. **代码生成** (`formasyn/agent/codegen_agent.py`) — `HLSScheduleDialect` → kernel.cpp/h

### 三级验证

- **L1** (`formasyn/checker/l1_checker.py`): g++ 编译, 与 golden 对比 (NMSE/符号错误率)
- **L2** (`formasyn/checker/l2_checker.py`): Vitis HLS csim + csynth, 验证 DSP/BRAM/II
- **L3** (`formasyn/checker/l3_checker.py`): Co-Sim + 信号质量 (BER/SFDR/EVM/RMSE)

### 反馈循环

`formasyn/feedback/loop.py` + `formasyn/agent/diagnostic.py`: 验证失败时由 LLM 诊断故障原因并回退到对应 IR 层重试。

## 模块分布

| 模块 | 路径 | 职责 |
|------|------|------|
| DSL | `formasyn/dsl/` | 5 种算子 (`MapOp`, `ReduceOp`, `DelayOp`, `ShiftRegOp`, `MessagePassOp`) + `FormulaGraph` |
| IR | `formasyn/ir/` | 三层 IR：`MathDialect` → `AlgoHWDialect` → `HLSScheduleDialect` |
| Agent | `formasyn/agent/` | LLM 代理 (DSE/代码生成/诊断), 知识注入 (`knowledge_prompt.py`) |
| Golden | `formasyn/golden/` | C++ 参考模型、量化分析、测试台生成 |
| Checker | `formasyn/checker/` | L1/L2/L3 验证 + 信号质量模拟器 (BER/Filter/Transform/Detection/Sync) |
| Solver | `formasyn/solver/` | Roofline 模型资源估算 |
| MLC | `formasyn/mlc/` | 不规则内存访问分析 + BRAM 映射 |

## 关键设计约束

- 项目无 `pyproject.toml` 或 `requirements.txt` — 直接以 `python run.py` 方式运行
- 示例注册在 `run.py::ExampleSpec` 字典中, 每个示例需提供 `kernel.py` + `constraints.yaml`
- 产物输出目录: `examples/outputs/<name>/<variant_id>/kernel.cpp`
- 超资源变体在 RooflineSolver 阶段标记 `SKIP`, 不会中断管线

## 添加新示例

1. 在 `examples/<name>/kernel.py` 中使用 DSL `FormulaGraph` 定义算法拓扑
2. 在 `examples/<name>/constraints.yaml` 中声明硬件约束和容差
3. 在 `run.py` 的 `ExampleSpec` 注册表中添加一条记录（如需额外参数/CSR 钩子）
