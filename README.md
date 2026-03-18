# FormaSyn

**FormaSyn** 是一个 AI 驱动的编译器框架，专注于通信算法（LDPC、FIR 等）的 FPGA 实现自动优化。它将数学算法描述自动转化为可综合的 Vitis HLS C++ 代码，并通过三级验证流水线保证正确性与性能。

## 核心特性

- **LLM 设计空间探索（DSE）**：调用 LLM 自动生成多个硬件变体（近似方法、量化方案、并行度）
- **三层中间表示（IR）**：Math Dialect → Algo-HW Dialect → HLS Schedule Dialect
- **自动验证流水线**：L1（软件数值）→ L2（EDA 资源/时序）→ L3（Co-Sim + 信号质量）
- **迭代反馈优化**：pragma 快速调优 + LLM 深度迭代修复

## 架构概览

```
用户定义算法 (FormulaGraph)
        ↓
ExampleSpec 注册 (输入 / 参数 / kernel_type / 可选 CSR 钩子)
        ↓
统一执行管线 run.py::run_example(...)
        ↓
   Math Dialect (纯数学 DAG)
        ↓
LLM 代理生成意图 JSON (多变体)
        ↓
  Algo-HW Dialect (量化 + 近似 + 并行度)
        ↓
 RooflineSolver (循环展开 / pipeline / 分块)
        ↓
HLS Schedule Dialect (完整调度信息)
        ↓
  MLCBackend (不规则访问 / BRAM 映射)
        ↓
  HLS C++ 代码 (.cpp / .h)
        ↓
  逐变体验证（超资源变体仅 SKIP）
        ↓
  L1 → L2 → L3 三级验证
        ↓
    通过的最优变体
```

当前 `run.py` 不再为每个算法单独维护一套 `run_xxx()` 流程。不同示例只通过 `ExampleSpec` 提供少量差异化信息，例如：

- 如何构造 `FormulaGraph`
- 如何生成测试输入
- 是否需要额外 CLI 参数
- 是否需要从图结构提取 `csr_data`
- `constraints.yaml` 中声明的 `kernel_type` 与容差指标

## 快速开始

### 安装依赖

```bash
pip install numpy scipy networkx openai pyyaml

```

### 一键运行示例

```bash
# FIR 16-tap 低通滤波器
python run.py fir_16tap

# LDPC 校验节点更新（默认度数 dc=8）
python run.py ldpc_cnu

# 调整校验节点度数
python run.py ldpc_cnu --dc 16

# 向量加法（c = a + b）
python run.py vec_add
```

运行后会依次输出每个阶段的进度和各变体的验证结果：

```
==> [1/5] 解析算法到 Math Dialect ...
==> [2/5] 生成黄金参考模型并分析量化参数 ...
==> [3/5] 调用 LLM 生成硬件变体意图 ...
    生成 8 个变体
==> [4/5] 编译并验证各变体 ...
    [SKIP] baseline_int16_p16_full  reason=BRAM 超限: 估算 26 块, 预算 12 块
    [PASS] min_sum_int8_p8   metrics={'nmse_db': -63.2, 'max_overflows': 0}
    [PASS] offset_ms_int10   metrics={'nmse_db': -71.5, 'max_overflows': 0}
    [FAIL] spa_int16_p1      metrics={'nmse_db': -58.1, 'max_overflows': 0}
    ...
==> [5/5] 完成：5/8 个变体通过 L1 验证
```

说明：如果某个候选变体在 `RooflineSolver` 阶段估算出 DSP / BRAM 超预算，当前实现会把该变体标记为 `SKIP` 并继续尝试后续变体，不会因为单个失败中断整轮探索。

## 添加新算子示例

### 目录结构

每个示例至少包含两个文件，由根目录 `run.py` 的统一执行器调度：

```
examples/
└── my_algorithm/
    ├── kernel.py          # 算法数学定义（FormulaGraph）
    └── constraints.yaml   # 硬件约束与质量容差
```

### kernel.py — 算法定义

使用 `FormulaGraph` 串联 DSL 算子描述算法拓扑，**不包含任何硬件参数**：

```python
from dsl.operators import FormulaGraph

def build_my_algorithm():
    fp = FormulaGraph(name="my_algorithm")

    # 移位寄存器（延迟线）
    fp.shift_reg("x_in", taps=range(8), output="taps")

    # 元素级映射：乘以系数
    COEFFS = [0.1, 0.2, 0.4, 0.5, 0.5, 0.4, 0.2, 0.1]
    fp.map("taps", func="multiply", coeff=COEFFS, output="products")

    # 归约：求和
    fp.reduce("products", op="add", domain=fp.domain.all(), output="y_out")

    return fp
```

### constraints.yaml — 硬件约束

```yaml
hardware_constraints:
  target_device: "xcu200-fsgd2104-2-e"   # Xilinx 器件型号
  clock_target_mhz: 300                   # 目标时钟频率（MHz）
  max_dsp: 32                             # 最大 DSP 数量
  max_bram_18k: 8                         # 最大 BRAM-18K 数量
  target_ii: 1                            # 目标启动间隔（每多少周期处理一次输入）

algorithm_metrics:
  evaluator_type: "WaveformEvaluator"     # 见下方评估器说明
  kernel_type: "filtering"                # 交给统一 L1 流程选择 metric
  tolerance:
    nmse_db: -60.0                        # 归一化均方误差阈值（dB，越小越严格）
    max_overflows: 0                      # 允许溢出次数
```

### 新增示例的接入方式

新增算法时，不建议再写新的 `run_xxx_kernel()` 或复制一份执行流程。推荐做法是：

1. 在 `examples/<name>/kernel.py` 中提供构图函数。
2. 在 `examples/<name>/constraints.yaml` 中声明硬件约束、`kernel_type` 和容差。
3. 如果需要额外参数、测试输入生成逻辑或 `csr_data` 提取逻辑，在 `run.py` 的 `ExampleSpec` 注册表中补一条描述。

这样新增示例只引入“算法差异”，不会复制 DSE、roofline、代码生成和验证流水线本身。

## DSL 算子参考

### MapOp — 元素级映射

将函数逐元素应用到输入张量。

```python
fp.map(input_ref, func, output, **func_params)
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `input_ref` | `str` | 输入信号名 |
| `func` | `str` | 映射函数（见下表） |
| `output` | `str` | 输出信号名 |
| `**func_params` | `dict` | 函数额外参数 |

**有效 `func` 值：**

| 函数名 | 说明 | 额外参数 |
|--------|------|----------|
| `multiply` | 乘以标量或逐元素乘 | `coeff`: 系数（标量或列表） |
| `tanh` | 双曲正切 | — |
| `atanh` | 反双曲正切 | — |
| `sign` | 符号函数（±1） | — |
| `abs` | 绝对值 | — |
| `lut` | 查找表映射 | `lut_table`: 列表 |
| `clamp` | 截断到范围 | `min_val`, `max_val` |
| `quantize` | 定点量化 | `bits`: 总位宽 |
| `xor_reduce` | 逐位 XOR 归约 | — |

### ReduceOp — 归约操作

对输入张量沿指定域做归约。

```python
fp.reduce(input_ref, op, domain, output)
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `input_ref` | `str` | 输入信号名 |
| `op` | `str` | 归约操作（见下表） |
| `domain` | `Domain` | 归约范围（见 Domain 说明） |
| `output` | `str` | 输出信号名 |

**有效 `op` 值：**

| 操作 | 说明 |
|------|------|
| `add` | 求和 |
| `mul` | 求积 |
| `min` | 取最小值 |
| `max` | 取最大值 |
| `xor` | 按位异或 |

**Domain 类型：**

```python
# 全部元素归约
fp.domain.all()

# 图邻域归约（用于 LDPC 等图算法）
fp.domain.neighbors(graph_ref="H", exclude_self=True)

# 滑动窗口归约
fp.domain.window(size=3, stride=1)
```

### ShiftRegOp — 移位寄存器

创建延迟线，提取指定抽头的历史值。

```python
fp.shift_reg(input_ref, taps, output)
```

| 参数 | 类型 | 说明 |
|------|------|------|
| `input_ref` | `str` | 输入信号名 |
| `taps` | `list[int]` | 要提取的延迟抽头索引（从 0 开始） |
| `output` | `str` | 输出信号名（长度等于 taps 数量） |

### DelayOp — 延迟

将信号延迟固定步数。

```python
fp.delay(input_ref, steps, output)
```

### MessagePassOp — 图消息传递

用于 LDPC 等图信号处理算法。

```python
fp.message_pass(
    graph_ref,       # str: H 矩阵或图结构引用
    node_type,       # "variable_node" 或 "check_node"
    forward_map,     # MapOp: 消息变换
    forward_reduce,  # ReduceOp: 邻域聚合
    schedule,        # "flooding" 或 "layered"
    output,
)
```

## 硬件约束参数说明

### `hardware_constraints` 字段

| 字段 | 说明 | 示例值 |
|------|------|--------|
| `target_device` | Xilinx 器件型号 | `"xcu200-fsgd2104-2-e"` |
| `clock_target_mhz` | 目标时钟频率 | `300` |
| `max_dsp` | 最大 DSP 块数量 | `32` |
| `max_bram_18k` | 最大 BRAM-18K 数量 | `8` |
| `target_ii` | 目标启动间隔（周期） | `1` |

### `algorithm_metrics` 字段

| `evaluator_type` | 适用场景 | 容差指标 |
|-----------------|----------|----------|
| `WaveformEvaluator` | FIR、FFT、通用滤波 | `nmse_db`, `max_overflows` |
| `BERCurveEvaluator` | LDPC、Turbo 等信道编码 | `sign_error_rate`, `snr_penalty_db` |
| `SFDREvaluator` | DAC/ADC、频谱分析 | `sfdr_db` |
| `EVMEvaluator` | 调制解调（OFDM 等） | `evm_percent` |
| `RMSEEvaluator` | 同步、估计算法 | `rmse` |

## 近似算法选项（针对 LDPC 等信道编码）

LLM 代理在生成变体时会从以下近似方法中选择：

| `approx_method` | 描述 | 可调参数 | DSP 成本 | SNR 损失 |
|-----------------|------|----------|----------|----------|
| `spa_exact` | Sum-Product（精确） | — | 高 | 0 dB |
| `min_sum` | 最小和近似 | — | 低 | ~0.5 dB |
| `offset_min_sum` | 偏置最小和 | `offset_beta ∈ [0.1, 0.5]` | 低 | ~0.2 dB |
| `normalized_min_sum` | 归一化最小和 | `scale_factor ∈ [0.6, 0.9]` | 低 | ~0.2 dB |
| `lut_tanh` | LUT 查表 tanh | `lut_size: 32~256` | 中 | ~0.1 dB |

## 验证流水线

### L1 — 软件数值验证

- 用 `g++` 编译生成的 HLS C++，与 float64 黄金模型对比
- 计算 NMSE / 符号错误率 / SNR 损失等指标
- **不需要 Vitis HLS，速度快**

### L2 — EDA 资源与时序验证

- 调用 Vitis HLS 执行 `csim` 和 `csynth`
- 验证 DSP / BRAM / LUT / FF 用量和实际 II
- **需要安装 Vitis HLS**

### L3 — Co-Sim 与信号质量验证

- RTL 协同仿真，验证 RTL 波形与 C++ 行为一致
- 完整信号质量评估（BER 曲线、NMSE、SFDR、EVM、RMSE）
- **需要安装 Vitis HLS 和 Vivado**

## 两个内置示例

### FIR 16-tap 低通滤波器

**运行方式**：`python run.py fir_16tap`

16 阶对称 FIR 低通滤波器，使用对称系数减少乘法器数量。

- **目标器件**：Xilinx UltraScale+ `xcu200`
- **时钟**：300 MHz，II=1
- **DSP 限制**：≤16，BRAM ≤2
- **质量指标**：NMSE ≤ −60 dB，无溢出

### LDPC 校验节点更新（CNU）

**运行方式**：`python run.py ldpc_cnu`

LDPC Min-Sum 译码器的校验节点更新单元，度数 `dc=8`。

- **目标器件**：Xilinx Zynq UltraScale+ `xczu7ev`
- **时钟**：250 MHz，II=1
- **DSP 限制**：≤64，BRAM ≤32
- **质量指标**：符号错误率 ≤1%，SNR 损失 ≤0.1 dB

## 项目结构

```
FormaSyn/
├── dsl/
│   ├── operators.py          # 五种 DSL 算子定义
│   ├── parser.py             # FormulaGraph → Math Dialect
│   └── template_engine.py   # Intent JSON → Algo-HW Dialect
├── ir/
│   ├── math_dialect.py       # IR 第1层：纯数学拓扑
│   ├── algo_hw_dialect.py    # IR 第2层：算法-硬件映射
│   └── schedule_dialect.py  # IR 第3层：HLS 调度 + pragma
├── agent/
│   ├── base_agent.py         # 统一 LLM client/base 配置
│   ├── codegen_agent.py      # Schedule Dialect -> HLS C++ 代码生成
│   ├── dse_agent.py          # LLM 设计空间探索代理
│   └── knowledge_prompt.py  # 通信算法领域知识
├── solver/
│   └── roofline_solver.py   # 屋顶线模型资源估算与调度
├── mlc/
│   ├── mlc_frontend.py      # 不规则访问分析
│   └── mlc_backend.py       # BRAM 映射代码生成
├── golden/
│   ├── generator.py         # float64 黄金参考模型生成
│   └── quant_analyzer.py    # 量化精度分析
├── checker/
│   ├── l1_checker.py        # 软件数值验证
│   ├── l2_checker.py        # EDA 资源/时序验证
│   ├── l3_checker.py        # Co-Sim + 信号质量验证
│   └── diagnostic.py        # 故障诊断报告
├── feedback/
│   ├── pragma_tuner.py      # 快速 pragma 调优
│   └── deep_loop.py         # LLM 深度迭代反馈
└── examples/
    ├── fir_16tap/            # 16阶 FIR 滤波器示例
    └── ldpc_cnu/             # LDPC 校验节点更新示例
```

## LLM 配置

默认使用 Claude API（通过 AllAI 代理）：

```python
# agent/base_agent.py + agent/dse_agent.py
agent = DSEAgent(  # 或 ScheduleCodegenAgent(...)
    model="claude-sonnet-4-5-20250929",
    max_variants=8,  # DSEAgent 参数
)
```

`api_key` 与 `base_url` 统一在 `agent/base_agent.py` 中配置。
如需切换模型，修改各 agent 构造参数中的 `model` 即可。

## 代码生成产物目录

`run.py` 在每个变体验证前会先调用 `ScheduleCodegenAgent`，固定覆盖写到：

```text
examples/<example_name>/<variant_id>/
├── kernel.cpp
├── kernel.h
├── metadata.json
└── prompt.txt
```

## 许可证

MIT
