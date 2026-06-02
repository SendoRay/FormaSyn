# FormaSyn: HLS C++ → Verilog 迁移设计

## 核心论点

**结构化 IR 提升 LLM 硬件代码生成能力**：三层 Dialect 为 LLM 提供高信息密度、低歧义的结构化 spec，每一层消除一类设计决策的歧义，使 LLM 只需做最终的"RTL 调度→Verilog"翻译。配合验证驱动的迭代修复闭环，实现通信算法到可综合 Verilog 的全自动转换。

## 动机

### 问题
1. **性能天花板**：HLS 工具将并行的数学表达重新编码为顺序 C++，再费力恢复并行性——信息损失导致生成的 RTL 质量不如手写 Verilog
2. **工具链依赖**：Vitis HLS 闭源且昂贵，L2/L3 验证无法在无许可证环境运行
3. **LLM 角色不足**：当前 LLM 仅做 DSE 和诊断，与课题"基于大语言模型的通信算法硬件设计自动化方法研究"不匹配

### 解决方案
- 生成目标从 HLS C++ 切换到 Verilog/SystemVerilog
- 验证链路从 Vitis HLS 切换到 Verilator + Yosys（全开源）
- LLM 主导 Verilog 代码生成，IR 作为结构化 prompt 工程
- 验证驱动的 LLM-in-the-loop 迭代优化闭环

---

## 架构概览

### 三层 Dialect（保留，第三层替换）

```
MathDialect (纯数学 DAG: "算什么")
├── MapOp, ReduceOp, DelayOp, ShiftRegOp, MessagePassOp
├── CycleOp, IterationOp
└── 无任何硬件概念
         ↓ math_to_algohw (近似重写 + 量化)
AlgoHWDialect (算法级硬件映射: "怎么算")
├── approx_method, parallelism, quant_int/frac_bits
├── saturation_guard, data_type
└── 无调度/RTL 细节
         ↓ algohw_to_rtl (ASAP/ALAP 调度)
RTLScheduleDialect (RTL 调度: "硬件怎么组织")    ← 新，替换 HLSScheduleDialect
├── pipeline_stage, latency_cycles, register_output
├── storage_type, bram_ports, bram_banks
├── fsm_state, exec_mode
└── 直接映射到 Verilog 结构
```

### 管线阶段

```
1. DSL 解析           FormulaGraph → MathDialect
2. 不规则访问分析      标记 irregular_access + CSR 构建
3. Golden 模型生成     float64 C++ 参考模型 + 量化分析
4. DSE (LLM)          搜索近似/量化/并行度组合 → IntentJSON
5. Math→AlgoHW        近似重写 + 量化 + 并行度
6. AlgoHW→RTL         ASAP/ALAP 调度 + 存储决策 + FSM + 端口
7. 内存布局            BRAM bank 分配 + 地址映射
8. Codegen (LLM)      RTLScheduleDialect → Verilog
9. 验证循环 (LLM-in-the-loop):
   ├─ L1: Verilator 功能验证 → 失败 → LLM 诊断修复 → 重新生成
   ├─ L2: Yosys 资源/时序    → 超标 → LLM 调整 → 回退到 step 6
   └─ L3: 质量仿真 (BER/NMSE) → 不达标 → LLM 调整 → 回退到 step 5
```

---

## 模块结构

### 新结构

```
formasyn/
├── dsl/              # 纯 DSL：算子定义 + parser (FormulaGraph → MathDialect)
│   ├── operators.py
│   └── parser.py
│
├── ir/               # 三层 IR 定义
│   ├── math_dialect.py       # 不变
│   ├── algo_hw_dialect.py    # 微调：去掉 HLS 术语
│   └── rtl_dialect.py        # 新：替换 schedule_dialect.py
│
├── lowering/         # 所有 IR 降级 pass
│   ├── math_to_algohw.py     # 原 dsl/template_engine.py
│   ├── algohw_to_rtl.py      # 原 solver/schedule_builder.py，重写为 RTL 调度
│   └── memory_layout.py      # 原 mlc/ 后端
│
├── analysis/         # 所有静态分析
│   ├── irregular_access.py   # 原 mlc/ 前端
│   ├── interval.py           # 位宽推导
│   └── spectral.py           # 频谱诊断
│
├── codegen/          # LLM 主导 + 模板辅助的 Verilog 生成
│   ├── verilog_agent.py      # LLM codegen agent
│   ├── scaffold.py           # 模板骨架生成（端口、时钟、复位框架）
│   └── testbench_gen.py      # SystemVerilog testbench 生成
│
├── golden/           # Golden 模型生成（不变）
│   ├── generator.py
│   └── quant_analyzer.py
│
├── checker/          # 全开源验证
│   ├── l1_checker.py         # Verilator 功能仿真
│   ├── l2_checker.py         # Yosys 综合 + 资源统计
│   ├── l3_checker.py         # 质量仿真（BER/NMSE/SFDR）
│   ├── pre_checker.py        # 验证环境准备
│   └── simulators/           # 信号质量仿真器（不变）
│
├── rewrites/         # 代数重写规则 + QualityBound（不变）
├── agent/            # LLM 代理
│   ├── dse_agent.py          # DSE 探索（不变）
│   └── diagnostic.py         # 诊断 + 修复建议（微调适配 RTL）
│
├── feedback/         # 验证驱动的迭代循环
│   └── loop.py               # LLM-in-the-loop 闭环
│
└── research/         # 研究原型（不变）
```

### 模块迁移映射

| 原模块 | 新位置 | 变化类型 |
|--------|--------|---------|
| `dsl/template_engine.py` | `lowering/math_to_algohw.py` | 移动 + 重命名 |
| `solver/schedule_builder.py` | `lowering/algohw_to_rtl.py` | 移动 + 重写 |
| `mlc/` 前端（分析） | `analysis/irregular_access.py` | 拆分 |
| `mlc/` 后端（BRAM） | `lowering/memory_layout.py` | 拆分 |
| `ir/schedule_dialect.py` | `ir/rtl_dialect.py` | 替换 |
| `agent/codegen_agent.py` | `codegen/verilog_agent.py` | 替换（HLS C++ → Verilog） |
| `checker/l1_checker.py` | `checker/l1_checker.py` | 重写（Vitis csim → Verilator） |
| `checker/l2_checker.py` | `checker/l2_checker.py` | 重写（Vitis csynth → Yosys） |
| `solver/` 目录 | 删除 | 合并到 lowering/ |
| `mlc/` 目录 | 删除 | 拆分到 analysis/ + lowering/ |

---

## 详细设计

### 1. RTLScheduleDialect（ir/rtl_dialect.py）

替换 `HLSScheduleDialect`，用 RTL 原生概念替代 HLS pragma。

```python
@dataclass
class RTLNode:
    node_id: str
    op_type: str                    # map/reduce/delay/shift_reg/message_pass
    op_detail: str                  # 具体运算：add/mul/sign/abs/min...

    # 从 AlgoHWNode 继承
    data_type: str                  # "fixed<16,8>" / "uint<8>"
    approx_method: str | None
    parallelism: int
    saturation_guard: bool
    quant_int_bits: int
    quant_frac_bits: int

    # RTL 调度
    pipeline_stage: int             # 所在流水线级（ASAP/ALAP 调度结果）
    latency_cycles: int             # 该操作的时钟周期数
    register_output: bool           # 输出是否需要寄存器（流水线切割点）

    # 存储映射
    storage_type: str               # "register" | "bram" | "lutram" | "distributed"
    bram_ports: int                 # BRAM 端口数（单/双端口）
    bram_banks: int                 # bank 数
    address_width: int              # 地址位宽

    # 控制流
    fsm_state: str | None           # 所属 FSM 状态（迭代算法用）
    exec_mode: str                  # "combinational" | "pipelined" | "iterative"

    # 连接
    input_nodes: list[str]
    shape: list[int]


@dataclass
class PortDef:
    name: str
    direction: str                  # "input" | "output"
    width: int                      # 位宽
    is_array: bool
    array_depth: int | None


@dataclass
class RTLScheduleDialect:
    kernel_name: str
    nodes: dict[str, RTLNode]

    # 全局调度
    clock_period_ns: float
    total_pipeline_stages: int
    total_latency_cycles: int
    throughput_samples_per_cycle: int

    # 资源预估（RTL 粒度）
    estimated_luts: int
    estimated_ffs: int
    estimated_dsps: int
    estimated_brams: int

    # FSM（迭代算法用）
    fsm_states: list[str]
    fsm_transitions: dict[str, str]

    # 端口定义
    input_ports: list[PortDef]
    output_ports: list[PortDef]
    clock_name: str = "clk"
    reset_name: str = "rst_n"

    # 溯源
    variant_id: str = ""
    quality_bound: dict | None = None
```

### 2. RTL 调度器（lowering/algohw_to_rtl.py）

替换 `ScheduleBuilder`，做真正的 RTL 调度。

```python
class RTLScheduler:
    """AlgoHWDialect → RTLScheduleDialect"""

    # 运算延迟表（时钟周期数）
    OP_LATENCY = {
        "add": 1, "sub": 1, "mul": 3, "div": 10,
        "cmp": 1, "mux": 1, "sign": 1, "abs": 1,
        "shift": 1, "xor": 1, "and": 1, "or": 1,
    }

    def lower(self, algo_hw: AlgoHWDialect, constraints: dict) -> RTLScheduleDialect:
        # 1. 数据依赖分析：从 DAG 提取关键路径
        # 2. 延迟标注：查表 OP_LATENCY
        # 3. ASAP 调度：尽早执行，确定 pipeline_stage 下界
        # 4. ALAP 调度：尽晚执行，确定 pipeline_stage 上界
        # 5. 在 [ASAP, ALAP] 区间内选择最终 stage（最小化寄存器）
        # 6. 存储决策：
        #    - 元素数 <= 64 → register
        #    - 元素数 <= 256 → lutram
        #    - 元素数 > 256 → bram
        # 7. exec_mode 决策：
        #    - 纯组合（无反馈、无迭代）→ "combinational"
        #    - CycleOp body → "pipelined"
        #    - IterationOp → "iterative" + 生成 FSM 状态
        # 8. 端口推导：从 input/output nodes 的 data_type + shape 推导
        # 9. 资源粗估：DSP = mul 节点数 × parallelism, etc.
        ...
```

### 3. LLM Verilog 代码生成（codegen/verilog_agent.py）

LLM 主导生成，模板提供骨架约束。

**工作流程：**

```
RTLScheduleDialect
    ↓
scaffold.py 生成模块骨架:
  - module 声明 + 端口列表
  - 时钟/复位信号
  - wire/reg 声明框架
  - 预留的 TODO 标记（LLM 填充）
    ↓
verilog_agent.py:
  - system prompt: Verilog 编码规范 + 常见 pattern
  - user prompt: RTLScheduleDialect JSON + 骨架代码 + golden 参考行为
  - LLM 生成完整 Verilog（填充数据通路逻辑）
    ↓
输出: kernel_top.v + kernel_tb.sv
```

**LLM prompt 结构：**

```
System: 你是 Verilog RTL 设计专家。根据给定的 RTL 调度规格生成可综合的 Verilog。
规则：
- 使用 wire signed [W-1:0] 表示定点数
- pipeline_stage 对应寄存器级
- exec_mode="iterative" 时生成 FSM
- 所有运算使用显式位宽，不依赖推断
- 饱和保护使用 clamp 逻辑

User:
## RTL Schedule
{rtl_schedule_json}

## 模块骨架
{scaffold_code}

## Golden 行为描述
{golden_behavior}

请生成完整的 Verilog 实现。
```

**与当前 codegen_agent 的区别：**
- 当前：LLM 生成 HLS C++（pragma 提示 + ap_fixed 类型）
- 新：LLM 生成 Verilog（显式流水线寄存器 + 显式位宽 + FSM）
- 新：模板骨架约束 LLM 的输出格式，减少结构性错误
- 新：RTLScheduleDialect 提供的信息比 HLSScheduleDialect 更精确（每个节点有明确的 pipeline_stage 和 exec_mode）

### 4. 开源验证链路（checker/）

**L1: Verilator 功能验证**

```python
class L1Checker:
    def run(self, variant_dir: str, golden_data: dict) -> CheckResult:
        # 1. verilator --cc kernel_top.v --exe kernel_tb.cpp --build
        # 2. 运行仿真，捕获输出（通过 $display 或文件 I/O）
        # 3. 对比 golden：metric dispatch by kernel_type
        #    - channel_coding → sign_error_rate + snr_penalty_db
        #    - filtering → nmse_db
        #    - transform → nmse_db
        # 4. 返回 pass/fail + 具体偏差数据
        ...
```

**L2: Yosys 资源/时序验证**

```python
class L2Checker:
    def run(self, variant_dir: str, constraints: dict) -> CheckResult:
        # 1. yosys -p "read_verilog kernel_top.v; synth_xilinx; stat"
        #    或 synth_ice40 / synth_gowin 等目标平台
        # 2. 解析 stat 输出：LUT, FF, DSP48E, BRAM
        # 3. 对比 constraints.yaml 的资源预算
        # 4. 可选：nextpnr 做布局布线获取真实时序
        ...
```

**L3: 质量仿真**

```python
class L3Checker:
    def run(self, variant_dir: str, constraints: dict) -> CheckResult:
        # L3a 不再需要（L1 已是 cycle-accurate RTL 仿真）
        # L3b: 复用现有 simulators/（BER/Filter/Transform/Detection/Sync）
        #      输入从 C++ 仿真输出改为 Verilator 仿真输出
        ...
```

### 5. LLM-in-the-loop 迭代循环（feedback/loop.py）

```python
class FeedbackLoop:
    MAX_CODEGEN_RETRIES = 3    # L1 失败时 LLM 重新生成 Verilog
    MAX_SCHEDULE_RETRIES = 3   # L2 失败时调整调度参数
    MAX_DSE_ROUNDS = 3         # L3 失败时切换近似策略

    def run(self, variant, pipeline_stages) -> FinalResult:
        for dse_round in range(self.MAX_DSE_ROUNDS):
            algo_hw = pipeline_stages.math_to_algohw(intent)

            for sched_round in range(self.MAX_SCHEDULE_RETRIES):
                rtl_schedule = pipeline_stages.algohw_to_rtl(algo_hw)

                for codegen_round in range(self.MAX_CODEGEN_RETRIES):
                    verilog = pipeline_stages.codegen(rtl_schedule)

                    # L1: 功能验证
                    l1 = self.l1_checker.run(verilog, golden)
                    if not l1.passed:
                        # LLM 诊断编译/功能错误，修复 Verilog
                        fix = self.diagnostic.diagnose_l1(l1, verilog)
                        rtl_schedule = self.apply_fix(fix, rtl_schedule)
                        continue  # 重新生成 Verilog

                    # L2: 资源验证
                    l2 = self.l2_checker.run(verilog, constraints)
                    if not l2.passed:
                        # LLM 诊断资源超标，调整调度参数
                        fix = self.diagnostic.diagnose_l2(l2, rtl_schedule)
                        break  # 回退到 schedule 层重试

                    # L3: 质量验证
                    l3 = self.l3_checker.run(verilog, constraints)
                    if not l3.passed:
                        # LLM 诊断质量不达标，调整近似策略
                        fix = self.diagnostic.diagnose_l3(l3, algo_hw)
                        break  # 回退到 AlgoHW 层重试

                    return FinalResult(passed=True, verilog=verilog)

        return FinalResult(passed=False, reason="exhausted retries")
```

**迭代层次：**
- **内层（codegen 级）**：Verilog 编译/功能错误 → LLM 修复代码 → 重新生成
- **中层（schedule 级）**：资源超标 → LLM 调整调度（减少并行度/改存储类型）→ 重新调度 + 重新生成
- **外层（DSE 级）**：质量不达标 → LLM 切换近似方法/调整量化 → 从 AlgoHW 层重来

每层失败都携带**结构化的错误上下文**（FailureContext），包含具体的偏差数据（如 NMSE=-25dB vs 目标 -30dB，LUT=15000 vs 预算 10000），让 LLM 做有针对性的修复。

---

## LLM 在框架中的四个角色

| 角色 | 位置 | 输入 | 输出 | 贡献点 |
|------|------|------|------|--------|
| **设计空间探索** | `agent/dse_agent.py` | MathDialect + 约束 | IntentJSON 变体列表 | 搜索近似/量化/并行度组合空间 |
| **代码生成** | `codegen/verilog_agent.py` | RTLScheduleDialect + 骨架 | Verilog 源码 | 核心贡献：结构化 IR → 高质量 RTL |
| **故障诊断** | `agent/diagnostic.py` | FailureContext + IR | 修复建议 | 分析错误根因，定位修复层级 |
| **迭代修复** | `feedback/loop.py` | 诊断结果 + 当前 IR | 修复后的 IR/代码 | 闭环收敛到满足约束的设计 |

---

## 论文实验设计

### 对比实验：IR 粒度 vs LLM 生成质量

| 实验组 | 给 LLM 的输入 | 衡量指标 |
|--------|--------------|---------|
| Baseline | 纯自然语言算法描述 | 功能正确率, 迭代次数, 资源效率 |
| MathDialect only | 数学 DAG JSON | 同上 |
| Math + AlgoHW | 两层 IR | 同上 |
| 完整三层 IR | RTLScheduleDialect JSON + 骨架 | 同上 |

**预期结论**：IR 层次越完整，LLM 生成的 Verilog 功能正确率越高、迭代次数越少、资源效率越接近手写。

### 消融实验

- 去掉骨架模板 → 衡量结构性错误率变化
- 去掉迭代修复 → 衡量一次生成的成功率
- 去掉 DSE → 固定参数 vs LLM 搜索的 Pareto 前沿对比

---

## 依赖变更

### 新增依赖
- **Verilator** (apt/brew install verilator): RTL 仿真
- **Yosys** (apt/brew install yosys): 综合 + 资源统计
- **Jinja2** (pip install jinja2): 模板引擎（骨架生成）

### 移除依赖
- **Vitis HLS**: 不再需要（L1/L2/L3 全部替换为开源工具）

### 保留依赖
- numpy, scipy, networkx, openai, pyyaml（不变）

---

## 删除/保留清单

### 删除

| 文件/模块 | 理由 |
|-----------|------|
| `formasyn/ir/schedule_dialect.py` | 替换为 `rtl_dialect.py` |
| `formasyn/solver/` 整个目录 | 合并到 `lowering/algohw_to_rtl.py` |
| `formasyn/mlc/` 整个目录 | 拆分到 `analysis/` 和 `lowering/` |
| `formasyn/dsl/template_engine.py` | 移动到 `lowering/math_to_algohw.py` |
| `formasyn/agent/codegen_agent.py` | 替换为 `codegen/verilog_agent.py` |

### 保留（不变或微调）

| 模块 | 状态 |
|------|------|
| `formasyn/dsl/` (parser + operators) | 不变 |
| `formasyn/ir/math_dialect.py` | 不变 |
| `formasyn/ir/algo_hw_dialect.py` | 微调：去 HLS 术语 |
| `formasyn/rewrites/` | 不变 |
| `formasyn/golden/` | 不变 |
| `formasyn/agent/dse_agent.py` | 不变 |
| `formasyn/agent/diagnostic.py` | 微调：适配 RTL 概念 |
| `formasyn/feedback/loop.py` | 重写：三层迭代循环 |
| `formasyn/checker/simulators/` | 不变 |
| `formasyn/analysis/interval.py` | 不变 |
| `formasyn/analysis/spectral.py` | 不变 |
| `formasyn/research/` | 不变 |

---

## 实现优先级

1. **Phase 1 — IR 替换**：`rtl_dialect.py` + `algohw_to_rtl.py`（核心调度逻辑）
2. **Phase 2 — Codegen**：`verilog_agent.py` + `scaffold.py`（LLM Verilog 生成）
3. **Phase 3 — 验证**：L1 (Verilator) + L2 (Yosys) checker 重写
4. **Phase 4 — 迭代循环**：`feedback/loop.py` 三层嵌套迭代
5. **Phase 5 — 模块重组**：MLC 拆分、template_engine 迁移、目录清理
6. **Phase 6 — 端到端验证**：所有 7 个示例通过新管线
