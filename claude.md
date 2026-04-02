# FormaSyn 项目指导文档

> 本文档基于项目代码实际分析生成，用于指导 AI Agent 和开发人员在 FormaSyn 项目中进行代码编写和维护。

---

## 项目架构

FormaSyn 是一个 **AI 驱动的通信算法 FPGA 编译器**。它的核心功能是将用户用 Python DSL 描述���通信算法（如 LDPC、FIR、FFT）自动转换为经过验证的、带 `#pragma HLS` 的 Vitis HLS C++ 代码。

### 核心设计哲学

- **分层 IR 架构**：三层中间表示（Math Dialect → Algo-HW Dialect → HLS-Schedule Dialect），严格边界，职责分离
- **LLM 驱动的 DSE**：设计空间探索��� LLM Agent 负责，输出结构化意图 JSON
- **传统编译器技术**：硬件资源映射使用 Roofline Solver + MLC（Memory Layout Compiler）
- **三层验证流水线**：L1 csim → L2 csynth → L3 cosim + Quality Sim，逐层过滤和迭代恢复

### 系统模块依赖关系

```
用户输入 (kernel.py + constraints.yaml)
    ↓
DSL Parser → MathDialect (算���计算图，无硬件信息)
    ↓
Golden Model Generator → float64 C++ (裁判模型)
Quantization Analyzer → QuantSpec (位宽建议)
    ↓
DSE Agent (LLM) → IntentJSON[] (候选变体意图)
    ↓
Template Engine → AlgoHWDialect (含位宽、近似方法)
    ↓
MLC Frontend → CSR/不规则访存标注
Roofline Solver → ScheduleDialect (含 Unroll/Tile/II/BRAM Bank)
MLC Backend → 地址映射代码
    ↓
Codegen Agent → HLS C++ 代码
    ↓
PreChecker → 准备验证环境
L1Checker (csim) → 数值验证
L2Checker (csynth) → 资源/时序验证
L3Checker (cosim + quality) → RTL 验证 + 算法质量
    ↓
失败反馈循环 (Diagnostic + FeedbackLoop)
```

---

## 项目技术栈

### 核心依赖

| 依赖 | 版本 | 用途 |
|------|------|------|
| Python | 3.10+ | 主要开发语言 |
| openai | latest | LLM API 交互 |
| httpx | latest | HTTP 客户端 |
| networkx | latest | DAG 处理 |
| numpy | latest | 数值计算 |
| pyyaml | latest | 配置文件解析 |

### 外部工具

- **Vitis HLS**：Xilinx FPGA 高层次综合工具
- **g++**：C++ 编译器（用于 host-only 仿真）

---

## 项目模块划分

```
formasyn/
├── dsl/                    # DSL 层
│   ├── operators.py        # 五类 DSL 算子定义
│   ├── parser.py           # FormulaGraph → MathDialect
│   └── template_engine.py  # IntentJSON → AlgoHWDialect
│
├── ir/                     # 中间表示层
│   ├── math_dialect.py     # 第一层 IR：纯算法语义
│   ├── algo_hw_dialect.py  # 第二层 IR：算法-硬件映射
│   └── schedule_dialect.py # 第三层 IR：HLS 调度信息
│
├── agent/                  # Agent 层
│   ├── base_agent.py       # LLM Agent 基类
│   ├── dse_agent.py        # 设计空间探索 Agent
│   ├── codegen_agent.py    # 代码生成 Agent
│   ├── diagnostic.py       # 诊断分析 Agent
│   └── knowledge_prompt.py # 通信算法知识库
│
├── solver/                 # 求解器层
│   └── roofline_solver.py  # HLS-Aware Roofline 求解器
│
├── mlc/                    # Memory Layout Compiler
│   ├── mlc_frontend.py     # CSR 转换、不规则访存标注
│   └── mlc_backend.py      # BRAM Bank 决策、地址映射
│
├── golden/                 # Golden Model 层
│   ├── generator.py        # MathDialect → float64 C++
│   ├── testbench_gen.py    # 生成 HLS testbench
│   └── quant_analyzer.py   # 量化分析、位宽推荐
│
├── checker/                # 验证层
│   ├── metrics.py          # 所有 Result/Threshold dataclass
│   ├── pre_checker.py      # 验证环境准备
│   ├── l1_checker.py       # C 仿真验证
│   ├── l2_checker.py       # 综合验证
│   ├── l3_checker.py       # 协同仿真 + 质量验证
│   ├── diagnostic.py       # 错误诊断工具
│   └── simulators/         # 质量仿真器
│       ├── base.py
│       ├── ber_sim.py      # 信道编码/解调
│       ├── filter_sim.py   # 滤波
│       ├── transform_sim.py # 变换
│       ├── detection_sim.py # 检测
│       └── sync_sim.py     # 同步
│
├── feedback/               # 反馈循环层
│   └── loop.py             # 反馈循环执行器
│
└── tests/                  # 测试层
    ├── test_ir.py
    ├── test_agent.py
    ├── test_codegen.py
    ├── test_mlc.py
    └── ...
```

---

## 文件与文件夹布局

```
FormaSyn/
├── formasyn/               # 源代码目录
│   ├── __init__.py         # 包导出定义
│   ├── dsl/
│   ├── ir/
│   ├── agent/
│   ├── solver/
│   ├── mlc/
│   ├── golden/
│   ├── checker/
│   ├── feedback/
│   └── tests/
│
├── examples/               # 示例内核
│   ├── vec_add/
│   │   ├── kernel.py       # 用户输入：算法描述
│   │   ├── constraints.yaml # 硬件约束
│   │   └── test_data.yaml  # 测试数据
│   ├── fir_16tap/
│   ├── ldpc_cnu/
│   └── ...
│
├── run.py                  # 主入口脚本
├── formasyn.md             # 项目架构文档
├── claude.md               # 本文档
├── README.md               # 项目说明
├── config.yaml             # API 配置
└── vitis_hls_test/         # Vitis HLS 参考实现
```

---

## 项目业务模块

### 输入模块

- **用户输入**：`examples/*/kernel.py`（算法 DSL 描述）
- **约束输入**：`examples/*/constraints.yaml`（硬件资源约束）
- **测试数据**：`examples/*/test_data.yaml`（验证用输入输出）

### 处理模块

1. **DSL 解析** (`dsl/parser.py`)：FormulaGraph → MathDialect
2. **Golden 生成** (`golden/generator.py`)：MathDialect → float64 C++
3. **量化分析** (`golden/quant_analyzer.py`)：动态范围统计 → 位宽建议
4. **设计空间探索** (`agent/dse_agent.py`)：LLM → IntentJSON[]
5. **模板渲染** (`dsl/template_engine.py`)：IntentJSON → AlgoHWDialect
6. **资源求解** (`solver/roofline_solver.py`)：AlgoHWDialect → ScheduleDialect
7. **代码生成** (`agent/codegen_agent.py`)：ScheduleDialect → HLS C++

### 验证模块

1. **L1 验证** (`checker/l1_checker.py`)：C 仿真 + 数值对比
2. **L2 验证** (`checker/l2_checker.py`)：综合 + 资源/时序检查
3. **L3 验证** (`checker/l3_checker.py`)：协同仿真 + 质量评估

### 反馈模块

- **诊断** (`checker/diagnostic.py`, `agent/diagnostic.py`)：错误归因
- **反馈循环** (`feedback/loop.py`)：参数调整、深度迭代

---

## 项目代码风格与规范

### 命名约定

#### 类命名

- **PascalCase**：所有类名使用大驼峰命名
  ```python
  class MathDialect: ...
  class L1Checker: ...
  class FeedbackLoop: ...
  ```

#### 变量/函数/方法命名

- **snake_case**：所有变量、函数、方法使用小写下划线命名
  ```python
  def to_dag(self) -> nx.DiGraph: ...
  def _run_csim(self, ...) -> dict: ...
  variant_id = "min_sum_int8_p8"
  ```

#### 常量命名

- **UPPER_SNAKE_CASE**：模块级常量
  ```python
  _DEFAULT_PART = "xc7z020clg400-1"
  _OUTPUT_PREFIX = "@@OUTPUT "
  MAX_RETRIES = 3
  ```

#### 私有成员

- **单下划线前缀**：表示内部使用
  ```python
  def _extract_function_name(code: str) -> str: ...
  self._config = AgentConfig(...)
  ```

### 代码风格

#### Type Hints

- **必须使用类型注解**：所有公共接口必须添加类型注解
  ```python
  def check(
      self,
      hls_cpp_code: str,
      golden_outputs: dict[str, list[float]],
      test_inputs: dict[str, list[float]],
      variant_id: str,
  ) -> L1Result:
      ...
  ```

#### 数据类

- **优先使用 `@dataclass`**：所有数据结构使用 dataclass 定义
  ```python
  @dataclass
  class L1Result:
      variant_id: str
      passed: bool = False
      compile_ok: bool = False
      metrics: dict[str, float] = field(default_factory=dict)
      failure: Optional[FailureContext] = None
  ```

#### Future Imports

- **统一使用 `from __future__ import annotations`**：所有模块文件开头
  ```python
  from __future__ import annotations
  ```

### Import 规则

#### 标准库导入顺序

```python
# 1. from __future__ import annotations
from __future__ import annotations

# 2. 标准库（按字母序）
import logging
import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

# 3. 第三方库（按字母序）
import httpx
import numpy as np
import yaml
from openai import OpenAI

# 4. 本地模块（按字母序，使用完整路径）
from FormaSyn.formasyn.ir.math_dialect import MathDialect
from FormaSyn.formasyn.checker.diagnostic import FailureContext
```

#### 禁止的导入

- **禁止使用 `from module import *`**（除了 `__init__.py` 中的选择性导出）
- **禁止循环导入**：如需引用，使用类型字符串或 `TYPE_CHECKING`

### 依赖注入

- **通过构造函数注入**：配置和依赖通过 `__init__` 传入
  ```python
  class L1Checker:
      def __init__(
          self,
          kernel_type: str = "channel_coding",
          tolerance: Optional[dict[str, float]] = None,
          *,
          part: str = _DEFAULT_PART,
          clock: str = _DEFAULT_CLOCK,
      ) -> None:
          ...
  ```

### 日志规范

- **使用 `logging` 模块**：禁止使用 `print()`
  ```python
  import logging
  logger = logging.getLogger(__name__)

  logger.info("L1 通过 [%s]: metrics=%s", variant_id, result.metrics)
  logger.warning("L1 CSim 失败 [%s]: %s", variant_id, str(exc)[:200])
  ```

#### 日志级别

- `DEBUG`：详细调试信息
- `INFO`：正常流程节点
- `WARNING`：可恢复的错误
- `ERROR`：严重错误

### 异常处理

- **使用自定义异常**：定义领域特定的异常类
  ```python
  class _CompileError(Exception):
      pass
  ```

- **异常链**：使用 `from` 保留原始异常
  ```python
  try:
      proc = subprocess.run(...)
  except FileNotFoundError as exc:
      raise _CompileError("g++ not found on PATH") from exc
  ```

### 参数校验

- **使用 Optional**：表示可选参数
  ```python
  def check(
      self,
      csr_data: Optional[dict[str, list[int]]] = None,
  ) -> L1Result:
      ...
  ```

- **使用 Keyword-only 参数**：强制关键字参数
  ```python
  def __init__(
      self,
      *,
      part: str = _DEFAULT_PART,
  ) -> None:
      ...
  ```

### 其他规范

#### 文档字符串

- **使用 Google 风格或 reST 风格**
  ```python
  def check(
      self,
      hls_cpp_code: str,
      ...
  ) -> L1Result:
      """Run L1 verification on generated HLS C++ code.

      Args:
          hls_cpp_code: Generated HLS C++ kernel code.
          golden_outputs: Reference outputs from golden model.
          test_inputs: Test input vectors.
          variant_id: Variant identifier for logging.

      Returns:
          L1Result containing verification status and metrics.
      """
      ...
  ```

#### 属性访问

- **使用 `@property`**：计算属性
  ```python
  @property
  def can_continue(self) -> bool:
      return self.iteration < self.max_iterations
  ```

---

## 测试与质量

### 单元测试

- **使用 pytest**：测试框架
- **测试文件位置**：`formasyn/tests/test_{module}.py`
- **测试类命名**：`Test{ClassName}`

```python
class TestMathDialect:
    """MathDialect construction, example, and DAG conversion."""

    def test_example_nodes_non_empty(self) -> None:
        md = MathDialect.example_ldpc_cnu()
        assert len(md.nodes) > 0
```

### 测试覆盖率要求

- **每个模块必须有对应的测试文件**
- **核心逻辑覆盖率 > 80%**

### 集成测试

- **示例测试**：`tests/test_examples.py`
- **端到端流程测试**：验证完整的 DSE 流水线

---

## 项目构建、测试与运行

### 环境与配置

#### 配置文件

- **`config.yaml`**：API 配置（项目根目录）
  ```yaml
  api:
    api_key: "sk-xxx"
    base_url: "https://api.tryallai.com"
    model: "claude-sonnet-4-5-20250929"
  ```

- **`constraints.yaml`**：硬件约束（示例目录）
  ```yaml
  hardware_constraints:
    max_dsp: 200
    max_bram: 100
    target_ii: 1

  algorithm_metrics:
    kernel_type: "channel_coding"
    tolerance:
      sign_error_rate: 0.01
      snr_penalty_db: 0.5
  ```

### 运行示例

```bash
# 运行单个示例
python run.py vec_add

# 运行带参数的示例
python run.py ldpc_cnu --dc 16

# 运行测试
pytest formasyn/tests/
```

---

## Git 工作流程

### 分支策略

- **main**：主分支，稳定版本
- **feature/**：功能开发分支
- **fix/**：Bug 修复分支

### 提交规范

- **使用中文提交信息**（与项目现有提交保持一致）
  ```
  feat: 添加反馈循环模块
  fix: 修复 L1 checker 中的类型转换问题
  refactor: 重构 IR 层的继承关系
  ```

### 忽略文件

- `.gitignore` 中已配置：
  - `__pycache__/`
  - `*.pyc`
  - `.pytest_cache/`
  - `.Xil/`（Vitis HLS 生成文件）

---

## 文档目录

### 文档存储规范

| 文档 | 路径 | 用途 |
|------|------|------|
| 项目架构文档 | `formasyn.md` | 详细的系统架构和流程说明 |
| 项目指导文档 | `claude.md` | 本文档，代码规范和开发指南 |
| 项目说明 | `README.md` | 项目简介、安装、快速开始 |
| API 文档 | 代码 docstring | 模块/类/函数的详细说明 |

### 文档维护原则

1. **架构变更时更新 `formasyn.md`**
2. **新增规范时更新 `claude.md`**
3. **API 变更时更新 docstring**

---

## 附录：三层 IR 严格边界

### Math Dialect (`ir/math_dialect.py`)

**包含**：算子类型、shape、依赖关系、不规则访存标注
**不包含**：位宽、近似方法、Unroll Factor、BRAM Bank、循环结构

### Algo-HW Dialect (`ir/algo_hw_dialect.py`)

**包含**：MathDialect 所有内容 + data_type + approx_method + parallelism
**不包含**：Unroll Factor、tile_size、pipeline_ii、BRAM Bank、address_mapping_code

### HLS-Schedule Dialect (`ir/schedule_dialect.py`)

**包含**：AlgoHWDialect 所有内容 + unroll_factor + tile_size + pipeline_ii + array_partition_type + bram_banks + address_mapping_code
**不包含**：C++ 代码字符串（代码生成是 Codegen 的职责）

---

## 附录：DSL 五类算子

1. **map**：逐元素映射（tanh、sign、abs、multiply、clamp、quantize、lut）
2. **reduce**：归约（add、min、max、xor）
3. **delay**：单步延迟
4. **shift_reg**：抽头延迟线
5. **message_pass**：图消息传递

**禁止**：新增算子类型、在 DSL 中写 for 循环、实现 recurrence 类算子

---

## 附录：验证流水线

| 层级 | 工具 | 指标 | 代价 |
|------|------|------|------|
| L1 | Vitis HLS csim | sign_error_rate, nmse_db | 秒~分钟 |
| L2 | Vitis HLS csynth | DSP/BRAM/LUT/II | 分钟 |
| L3a | Vitis HLS cosim | RTL 行为一致性 | 小时 |
| L3b | Python + ctypes | BER/NMSE/SFDR/EVM | 分钟~小时 |

### 失败回退规则

| 失败类型 | 回退层 | 恢复模块 |
|----------|--------|----------|
| L1 数值错误 | TemplateEngine | 量化放宽 |
| L2 II 超标 | ScheduleDialect | Pragma 调整 |
| L2 DSP/LUT 超标 | AlgoHWDialect | 并行度降低 |
| L2 BRAM 超标 | ScheduleDialect | Tiling 调整 |
| L3a/L3b 失败 | DSEAgent | 深度迭代（LLM） |

---

## 附录：Simulator 分发规则

| kernel_type | Simulator | 主要指标 |
|-------------|-----------|----------|
| channel_coding | BERSimulator | BER, waterfall_intact |
| demodulation | BERSimulator | BER, SER |
| filtering | FilterSimulator | nmse_db, stopband_atten_db |
| transform | TransformSimulator | sfdr_db, nmse_db |
| detection | DetectionSimulator | evm_percent |
| synchronization | SyncSimulator | estimation_rmse, bias_db |

---

*本文档由 FormaSyn 项目代码分析自动生成，最后更新：2026-03-19*
