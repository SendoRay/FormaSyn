# FormaSyn 最小化算子设计

## 核心原则

> **保持基础算子最小集合，通过组合表达复杂算法**

当前 5 个算子的问题分析：

| 算法 | 当前能否表达 | 缺失能力 | 解决方案 |
|------|-------------|----------|----------|
| FIR | ✅ 可以 | - | `ShiftReg → Map(mul) → Reduce(add)` |
| IIR | ❌ 不能 | 反馈环路 (y[n]→y[n-1]) | 扩展 **Cycle/Loop** 概念 |
| FFT | ⚠️ 单级可以 | 多级迭代结构 | 扩展 **Iteration** 概念 |
| 复数 FIR | ⚠️ 冗余 | 复数作为独立数据类型 | 扩展 **Tensor 类型系统** |
| Viterbi | ❌ 不能 | 状态机/动态规划 | 需要 **Loop** + 特殊 Reduce |

---

## 关键洞察：需要增加的只有 3 个核心抽象

### 1. CycleOp (循环/反馈抽象) ⭐ 最关键

当前 `DelayOp` 只能表达前馈延迟，无法表达反馈环路。

```python
# 当前：DAG 无法表达 IIR
x → [b0] → (+) → y
      ↑
      └───────┘   # 无法画这个箭头！

# 目标：支持反馈环路
@dataclass
class CycleOp:
    """表达计算图中的循环/反馈结构
    
    不是独立的"算子"，而是**图结构修饰**
    表示某个算子的输出会延迟反馈到前面的算子
    """
    body_ops: List[AnyOp]           # 循环体内的算子序列
    feedback_edges: List[Tuple[str, str, int]]  # [(src, dst, delay_cycles)]
    max_iterations: Optional[int] = None  # 固定迭代次数 (None=无限/直到收敛)

# IIR 表达：
# y[n] = b0*x[n] + b1*x[n-1] - a1*y[n-1]
cycle = CycleOp(
    body_ops=[
        MapOp("x", "multiply", {"coeff": b0}, "term0"),
        MapOp("x_delayed", "multiply", {"coeff": b1}, "term1"),
        MapOp("y_delayed", "multiply", {"coeff": -a1}, "term2"),
        ReduceOp(["term0", "term1", "term2"], "add", "y")
    ],
    feedback_edges=[
        ("y", "y_delayed", 1),      # y → Delay(1) → y_delayed
        ("x", "x_delayed", 1),      # x → Delay(1) → x_delayed
    ]
)
```

**硬件映射**：
```verilog
// CycleOp 生成带反馈路径的硬件
module iir_biquad (
    input signed [15:0] x,
    output signed [15:0] y,
    input clk, rst
);
    // 反馈边生成延迟寄存器
    reg signed [15:0] y_delayed, x_delayed;
    
    // body_ops 生成组合逻辑
    wire signed [31:0] term0 = x * B0;
    wire signed [31:0] term1 = x_delayed * B1;
    wire signed [31:0] term2 = y_delayed * A1;
    wire signed [35:0] y_next = term0 + term1 - term2;
    
    // 反馈边更新
    always @(posedge clk) begin
        y_delayed <= y;
        x_delayed <= x;
    end
    
    assign y = y_next >>> 14;
endmodule
```

### 2. IterationOp (迭代/多级结构抽象)

FFT 不是简单的 DAG，而是多级迭代结构。

```python
@dataclass  
class IterationOp:
    """表达固定次数的迭代计算
    
    每一轮迭代可以引用前一轮的结果
    类似 for-loop 的展开
    """
    body_ops: List[AnyOp]           # 单次迭代的算子
    num_iterations: int             # 迭代次数 (如 FFT 的 log2(N))
    
    # 跨迭代的数据传递
    carry_edges: List[Tuple[str, str]]  # [(prev_output, next_input)]
    
    # 索引计算 (用于 FFT twiddle 因子等)
    index_func: Optional[str] = None    # 迭代索引的函数

# FFT 表达：
fft_iteration = IterationOp(
    body_ops=[
        # 单级 FFT：N/2 个蝶形
        MapOp("input", "butterfly", {"twiddle_idx": "i"}, "output")
    ],
    num_iterations=10,  # 1024-FFT
    carry_edges=[("output", "input")],  # 本级输出作为下级输入
    index_func="twiddle_idx = k * (1 << stage)"
)
```

**关键区别**：
- `CycleOp`: 表达**反馈/递归**（如 IIR、PLL）
- `IterationOp`: 表达**多级流水线**（如 FFT stages、迭代译码）

### 3. TensorType (数据类型扩展)

复数、定点数应该作为**类型系统**的一部分，不是独立算子。

```python
@dataclass
class TensorType:
    """统一的张量类型系统"""
    base_type: str              # "int", "uint", "fixed", "complex", "float"
    bit_width: int              # 总位宽
    frac_bits: Optional[int] = None  # 定点小数位
    
    # 复数专用
    complex_component: Optional[str] = None  # "fixed<16,14>", "float32"
    
    # 向量/矩阵维度
    shape: List[int] = field(default_factory=list)

# 类型实例
t_int8 = TensorType("int", 8)
t_fixed16 = TensorType("fixed", 16, frac_bits=14)
t_complex16 = TensorType("complex", 32, complex_component="fixed<16,14>")
t_complex_vec16 = TensorType("complex", 32, complex_component="fixed<16,14>", shape=[16])

# MapOp 现在可以处理复数
MapOp(
    input_ref="x",              # type: t_complex_vec16
    func="multiply",            # 复数乘法
    func_params={"operand": "h", "operand_type": t_complex_vec16},
    output="y"
)
# 硬件自动生成 4 个实数乘法器 + 2 个加法器
```

---

## 规整后的完整算子集合 (共 8 个)

### 基础计算算子 (5 个)

| 算子 | 功能 | 通信算法示例 |
|------|------|-------------|
| **Map** | 逐元素变换 | 调制映射、量化、tanh、sign、**复数乘法** |
| **Reduce** | 聚合运算 | FIR 累加、LDPC CNU、min/max 搜索 |
| **ShiftReg** | 抽头延迟线 | FIR 抽头、相关器延迟线 |
| **Delay** | 单步延迟 | 简单延迟、流水线寄存 |
| **MessagePass** | 图消息传递 | LDPC BP 译码（不规则访问）|

### 控制流/结构算子 (3 个新增)

| 算子 | 功能 | 通信算法示例 |
|------|------|-------------|
| **Cycle** | 反馈/循环结构 | IIR、PLL、AGC、自适应滤波 |
| **Iteration** | 多级迭代 | FFT stages、Turbo 迭代、Viterbi 深度 |
| **Switch** | 条件选择 | 动态调度、模式切换（可选）|

---

## 如何用 8 个算子表达所有通信算法

### 1. FIR 滤波器（已有能力）

```python
# y[n] = Σ h[k] * x[n-k]
fir = FormulaGraph([
    ShiftRegOp("x", taps=[0,1,2,3], output="taps"),
    MapOp("taps", "multiply", {"coeffs": h}, output="products"),
    ReduceOp("products", "add", domain=Domain("all"), output="y")
])
```

### 2. IIR 滤波器（新增 Cycle）

```python
# y[n] = b0*x[n] + b1*x[n-1] - a1*y[n-1]
iir = FormulaGraph([
    ShiftRegOp("x", taps=[0,1], output="x_vec"),
    
    CycleOp(
        body_ops=[
            MapOp("x_vec", "dot", {"coeffs": [b0, b1]}, output="x_part"),
            MapOp("y_delayed", "multiply", {"coeff": -a1}, output="y_part"),
            ReduceOp(["x_part", "y_part"], "add", output="y")
        ],
        feedback_edges=[("y", "y_delayed", 1)]
    )
])
```

### 3. FFT（新增 Iteration）

```python
# N-FFT = log2(N) stages of butterflies
fft = FormulaGraph([
    # 输入重排（位逆序）
    MapOp("x", "bit_reverse", output="x_ordered"),
    
    IterationOp(
        body_ops=[
            # 单级：N/2 个蝶形并行或串行
            MapOp("stage_in", "butterfly", 
                  {"twiddle": "twiddle_rom[twiddle_idx]"},
                  output="stage_out")
        ],
        num_iterations=10,  # 1024-FFT
        carry_edges=[("stage_out", "stage_in")],
        stage_dependent_params={"twiddle_idx": "f(stage, k)"}
    )
])
```

### 4. 复数 FIR（TensorType）

```python
complex_fir = FormulaGraph([
    # 输入是复数向量
    ShiftRegOp("x", taps=[0,1,2,3], 
               tensor_type=TensorType("complex", 32, shape=[4]),
               output="taps"),
    
    # Map 自动处理复数乘法
    MapOp("taps", "multiply", 
          {"coeffs": h_complex, "dtype": "complex<fixed<16,14>>"},
          output="products"),
    
    ReduceOp("products", "add", output="y")
])

# 硬件生成器自动展开：
# for each tap:
#   (a+bi)(c+di) = (ac-bd) + (ad+bc)i
#   需要 4 DSP 或 3 DSP (Karatsuba)
```

### 5. Viterbi 译码（Cycle + Iteration）

```python
# Viterbi = 迭代 ACS + 回溯
viterbi = FormulaGraph([
    # 分支度量计算
    MapOp("recv_symbol", "branch_metric", output="bm"),
    
    IterationOp(
        body_ops=[
            CycleOp(
                body_ops=[
                    # ACS: Add-Compare-Select
                    MapOp("path_metrics", "acs_update", 
                          {"bm": "bm", "trellis": trellis_struct},
                          output="new_pm"),
                    ReduceOp("new_pm", "min", output="survivor")
                ],
                feedback_edges=[("new_pm", "path_metrics", 0)]  # 立即反馈
            )
        ],
        num_iterations=traceback_depth,
        carry_edges=[("survivor", "history")]
    ),
    
    # 回溯
    MapOp("history", "traceback", output="decoded_bits")
])
```

### 6. OFDM 发射机（组合所有算子）

```python
ofdm_tx = FormulaGraph([
    # 调制映射
    MapOp("bits", "qam_map", {"modulation": "64qam"}, output="symbols"),
    
    # 子载波映射（0 填充）
    MapOp("symbols", "subcarrier_map", {"fft_size": 1024, "used": 840},
          output="freq_domain"),
    
    # IFFT (Iteration)
    IterationOp(
        body_ops=[MapOp("in", "butterfly", output="out")],
        num_iterations=10,
        carry_edges=[("out", "in")]
    ),
    
    # 加循环前缀 (Delay + ShiftReg)
    ShiftRegOp("ifft_out", taps=[-72:0], output="with_cp")
])
```

---

## IR 三层架构保持不变

```
MathDialect (数学语义)
    ↓
AlgoHWDialect (+硬件参数：类型、并行度、近似方法)
    ↓
HLSScheduleDialect (+调度参数：tile/unroll/pipeline)
```

**唯一变化**：`MathNode.op_type` 新增 `"cycle"`, `"iteration"`

---

## 代码生成策略

### CycleOp 生成模板

```python
def codegen_cycle(op: CycleOp, ctx: Context) -> str:
    """生成带反馈的硬件结构"""
    
    # 1. 识别反馈边，生成延迟寄存器
    delay_regs = []
    for src, dst, delay in op.feedback_edges:
        delay_regs.append(f"reg [{width-1}:0] {src}_d{delay};")
    
    # 2. 生成 body_ops 的组合逻辑
    body_code = "\n".join([codegen(op) for op in op.body_ops])
    
    # 3. 生成时序逻辑（反馈更新）
    seq_code = "\n".join([
        f"always @(posedge clk) {src}_d1 <= {src};"
        for src, _, _ in op.feedback_edges
    ])
    
    return f"""
module {ctx.kernel_name}(
    input [{width-1}:0] x,
    output [{width-1}:0] y,
    input clk, rst
);
    // 反馈延迟寄存器
    {delay_regs}
    
    // 组合逻辑 (body)
    {body_code}
    
    // 时序更新 (反馈边)
    {seq_code}
endmodule
"""
```

### IterationOp 生成模板

```python
def codegen_iteration(op: IterationOp, ctx: Context) -> str:
    """生成多级迭代结构（流水线或迭代）"""
    
    if ctx.schedule.strategy == "pipelined":
        # 全流水线：每级独立硬件
        stages = []
        for i in range(op.num_iterations):
            stage = codegen_stage(op.body_ops, stage_idx=i)
            stages.append(f"// Stage {i}\n{stage}")
        return "\n".join(stages)
    
    elif ctx.schedule.strategy == "iterative":
        # 迭代：复用同一硬件
        return f"""
for (int stage = 0; stage < {op.num_iterations}; stage++) {{
    #pragma HLS PIPELINE II={ctx.target_ii}
    {codegen(op.body_ops)}
}}
"""
```

---

## 与之前设计的对比

| 方面 | 之前设计 (大量专用 Op) | 本设计 (最小 Op 集合) |
|------|----------------------|---------------------|
| **算子数量** | 10+ (Butterfly, Feedback, Complex, Trellis...) | 8 (5基础+3结构) |
| **FFT 表达** | `FFTOp` (专用高层) | `IterationOp + Map(butterfly)` |
| **IIR 表达** | `FeedbackOp` (专用) | `CycleOp` (通用反馈) |
| **复数** | `ComplexOp` (专用) | `TensorType` (类型系统) |
| **Viterbi** | `TrellisOp` (专用) | `CycleOp + IterationOp` 组合 |
| **优点** | 直接、易用 | 简洁、可组合、易扩展 |
| **缺点** | 冗余、难以维护 | 需要更多组合表达 |

---

## 实施建议

### 阶段 1: TensorType (1 周)
- 扩展现有类型系统支持复数、定点
- Map/Reduce 自动识别类型并生成正确硬件

### 阶段 2: CycleOp (2 周)
- 实现反馈边检测和延迟寄存器生成
- 支持 IIR、简单 PLL

### 阶段 3: IterationOp (2 周)
- 实现多级迭代结构
- 支持 FFT、Turbo 迭代

### 阶段 4: 组合验证 (1 周)
- 用 8 个算子表达所有目标算法
- 验证代码生成正确性

---

## 总结

**核心观点**：不需要为每个算法设计专用算子，只需要 3 个通用结构抽象：

1. **CycleOp** → 反馈/递归 (IIR、PLL、AGC)
2. **IterationOp** → 多级迭代 (FFT、Turbo)
3. **TensorType** → 复数/定点类型系统

配合原有的 5 个基础算子 (Map/Reduce/ShiftReg/Delay/MessagePass)，**总共 8 个算子**可以表达所有通信算法。

这才是真正的"**类似 Delite/Spiral 的通信 DSL**"：
- **Delite**: 用少量并行模式 (Map/Reduce/Scan) 表达 ML 算法
- **FormaSyn**: 用 8 个算子表达通信算法

保持简单，保持组合性。
