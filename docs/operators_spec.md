# FormaSyn DSL 算子规范

FormaSyn 使用 **8 个核心算子** 表达通信领域算法到硬件的映射。

---

## 算子总览

| 算子 | 类别 | 核心语义 | 典型硬件 |
|------|------|----------|----------|
| `Map` | 计算 | 逐元素变换 | LUT/DSP/组合逻辑 |
| `Reduce` | 计算 | 聚合归约 | 归约树/累加器 |
| `ShiftReg` | 存储 | 抽头延迟线 | 寄存器链/SRL |
| `Delay` | 存储 | 单步延迟 | 寄存器 |
| `MessagePass` | 计算 | 图消息传递 | BRAM + 控制器 |
| `Cycle` | 控制 | 反馈/循环结构 | 带反馈路径的时序逻辑 |
| `Iteration` | 控制 | 多级迭代 | 流水线阵列或迭代复用 |
| `Switch` | 控制 | 条件/模式选择 | 多路选择器 |

---

## 1. Map 算子

逐元素应用函数变换。

```python
@dataclass
class Map:
    input_ref: str                    # 输入信号名
    func: str                         # 函数名
    func_params: Dict[str, Any]       # 函数参数
    output_ref: str                   # 输出信号名
    output_type: Optional[TensorType] # 输出类型 (复数等)
```

**支持的内置函数**:

| 函数 | 参数 | 描述 | 硬件实现 |
|------|------|------|----------|
| `multiply` | `coeff`: 系数值或系数名 | 乘法 | DSP48 (大位宽) / LUT (小位宽) |
| `add` | `operand`: 第二操作数 | 加法 | 进位链 |
| `tanh` | `lut_size`: LUT 条目数 | 双曲正切 | BRAM 查表 |
| `sign` | - | 符号提取 | 最高位提取 |
| `abs` | - | 绝对值 | 条件取反 |
| `quantize` | `bits`, `frac_bits` | 量化 | 截断/舍入 |
| `conj` | - | 复数共轭 | 虚部取反 |
| `butterfly` | `twiddle`: 旋转因子 | FFT 蝶形 | 2-4 个 DSP + 加减法器 |

**使用示例**:

```python
# 实数乘法
Map("x", "multiply", {"coeff": 0.5}, "y")

# 复数乘法 (自动展开为 4 实数乘法)
Map("x", "multiply", 
    {"coeff": "h", "dtype": "complex<fixed<16,14>>"}, 
    "y")

# FFT 蝶形运算
Map(["x0", "x1"], "butterfly", 
    {"twiddle": "W[k]", "radix": 2}, 
    ["y0", "y1"])
```

---

## 2. Reduce 算子

在指定域上聚合运算。

```python
@dataclass
class Reduce:
    input_refs: List[str]             # 输入信号列表
    op: str                           # 归约操作
    domain: Domain                    # 归约域
    output_ref: str                   # 输出信号名
```

**归约操作**:

| 操作 | 描述 | 硬件结构 |
|------|------|----------|
| `add` | 求和 | 加法树 / 累加器 |
| `mul` | 求积 | 乘法树 |
| `min` | 最小值 | 比较树 |
| `max` | 最大值 | 比较树 |
| `xor` | 异或 | XOR 树 |

**域定义**:

```python
@dataclass
class Domain:
    kind: str                         # "all" | "neighbors" | "window"
    graph_ref: Optional[str]          # 图结构引用 (LDPC H 矩阵)
    exclude_self: bool = False        # 是否排除自身 (CNU 需要)
    window_size: Optional[int] = None # 滑动窗口大小
```

**使用示例**:

```python
# FIR 累加
Reduce(["p0", "p1", "p2", "p3"], "add", Domain("all"), "y")

# LDPC CNU: 邻居节点上的 min (排除自身)
Reduce("msgs", "min", 
       Domain("neighbors", graph_ref="H", exclude_self=True), 
       "min_msg")
```

---

## 3. ShiftReg 算子

多抽头延迟线。

```python
@dataclass
class ShiftReg:
    input_ref: str                    # 输入信号
    taps: List[int]                   # 抽头位置 [0,1,2,3] 等
    output_ref: str                   # 输出向量 (长度=len(taps))
```

**硬件映射**: 寄存器链 (SRL32 优化)

```verilog
// taps=[0,1,2,3] 生成
reg [15:0] shift_reg [0:3];
always @(posedge clk) begin
    shift_reg[0] <= input;
    shift_reg[1] <= shift_reg[0];
    shift_reg[2] <= shift_reg[1];
    shift_reg[3] <= shift_reg[2];
end
assign output = {shift_reg[0], shift_reg[1], shift_reg[2], shift_reg[3]};
```

**使用示例**:

```python
# 4-tap FIR 延迟线
ShiftReg("x", taps=[0, 1, 2, 3], output="taps")

# 抽取滤波器 (只取偶数抽头)
ShiftReg("x", taps=[0, 2, 4, 6], output="taps_decim")
```

---

## 4. Delay 算子

单步延迟。

```python
@dataclass
class Delay:
    input_ref: str                    # 输入信号
    steps: int = 1                    # 延迟周期数
    output_ref: str                   # 输出信号
```

**使用场景**:
- 流水线平衡
- 简单的 z^{-1} 延迟

**使用示例**:

```python
Delay("x", steps=1, output="x_z1")
```

---

## 5. MessagePass 算子

图结构上的消息传递。

```python
@dataclass
class MessagePass:
    graph_ref: str                    # 图/H 矩阵引用
    node_type: str                    # "variable_node" | "check_node"
    forward_map: Map                  # 消息变换函数
    forward_reduce: Reduce            # 消息聚合函数
    schedule: str = "flooding"        # "flooding" | "layered"
    output_ref: str                   # 输出信号
```

**使用场景**: LDPC 置信传播译码。

**使用示例**:

```python
# LDPC CNU (校验节点更新)
MessagePass(
    graph_ref="H",
    node_type="check_node",
    forward_map=Map("msg", "sign", {}, "sign_msg"),
    forward_reduce=Reduce("sign_msg", "xor", Domain("neighbors"), "parity"),
    schedule="layered",
    output="cnu_out"
)
```

---

## 6. Cycle 算子

表达反馈/循环计算结构。

```python
@dataclass
class Cycle:
    body: List[Op]                    # 循环体内的算子序列
    feedback_edges: List[Edge]        # 反馈边定义
    init_values: Dict[str, Value]     # 初始值
    
@dataclass
class Edge:
    src: str                          # 源信号
    dst: str                          # 目标信号
    delay: int                        # 延迟周期数
```

**语义**: `body` 内的算子构成一个计算步骤，输出通过 `feedback_edges` 延迟后反馈回输入。

**硬件映射**: 
- 组合逻辑部分：由 `body` 算子生成
- 时序部分：`feedback_edges` 生成延迟寄存器和反馈连接

**使用示例**:

```python
# IIR Biquad: y[n] = b0*x[n] + b1*x[n-1] - a1*y[n-1]
Cycle(
    body=[
        Map("x", "multiply", {"coeff": b0}, "term0"),
        Map("x_z1", "multiply", {"coeff": b1}, "term1"),
        Map("y_z1", "multiply", {"coeff": -a1}, "term2"),
        Reduce(["term0", "term1", "term2"], "add", Domain("all"), "y")
    ],
    feedback_edges=[
        Edge("y", "y_z1", delay=1),   # y[n] → Delay → y[n-1]
        Edge("x", "x_z1", delay=1)    # x[n] → Delay → x[n-1]
    ],
    init_values={"y_z1": 0, "x_z1": 0}
)
```

**生成硬件**:

```verilog
module iir_biquad (
    input signed [15:0] x,
    output signed [15:0] y,
    input clk, rst
);
    // 反馈边生成延迟寄存器
    reg signed [15:0] y_z1, x_z1;
    
    // body 生成组合逻辑
    wire signed [31:0] term0 = x * B0;
    wire signed [31:0] term1 = x_z1 * B1;
    wire signed [31:0] term2 = y_z1 * A1;
    wire signed [35:0] sum = term0 + term1 - term2;
    assign y = sum >>> 14;
    
    // 反馈边时序更新
    always @(posedge clk) begin
        if (rst) begin
            y_z1 <= 0;
            x_z1 <= 0;
        end else begin
            y_z1 <= y;
            x_z1 <= x;
        end
    end
endmodule
```

---

## 7. Iteration 算子

表达固定次数的多级迭代。

```python
@dataclass
class Iteration:
    body: List[Op]                    # 单次迭代的算子
    count: int                        # 迭代次数
    carry: List[Tuple[str, str]]      # 跨迭代数据传递 [(输出, 输入)]
    index_vars: List[str]             # 迭代索引变量名
```

**语义**: 执行 `count` 次 `body`，每次的输出通过 `carry` 传递到下一次的输入。

**实现策略**:
- `strategy="pipelined"`: 每级独立硬件，全并行
- `strategy="iterative"`: 单级硬件复用，时分复用

**使用示例**:

```python
# 1024-FFT: 10 级蝶形迭代
Iteration(
    body=[
        Map("stage_in", "butterfly", 
            {"twiddle_idx": "k * (1 << stage)"}, 
            "stage_out")
    ],
    count=10,
    carry=[("stage_out", "stage_in")],
    index_vars=["stage"]
)
```

**生成硬件** (流水线策略):

```verilog
// Stage 0
butterfly stage0 (.in(data_in), .twiddle(W0), .out(s0));

// Stage 1
butterfly stage1 (.in(s0), .twiddle(W1), .out(s1));

// ...

// Stage 9
butterfly stage9 (.in(s8), .twiddle(W9), .out(data_out));
```

**生成硬件** (迭代策略):

```c
// HLS 描述
for (int stage = 0; stage < 10; stage++) {
    #pragma HLS PIPELINE II=1
    butterfly(stage_data, twiddle[stage_idx], stage_data);
}
```

---

## 8. Switch 算子

条件/模式选择。

```python
@dataclass
class Switch:
    condition: str                    # 条件表达式
    cases: Dict[str, List[Op]]        # 各 case 对应的算子序列
    default: Optional[List[Op]]       # 默认 case
    output_ref: str                   # 输出信号
```

**使用场景**: 动态算法选择、运行时配置。

**使用示例**:

```python
# 调制模式选择
Switch(
    condition="mod_type",
    cases={
        "BPSK": [Map("bits", "bpsk_map", {}, "symbols")],
        "QPSK": [Map("bits", "qpsk_map", {}, "symbols")],
        "16QAM": [Map("bits", "qam16_map", {}, "symbols")]
    },
    output="symbols"
)
```

---

## 类型系统

### TensorType

```python
@dataclass
class TensorType:
    base: str                         # "int" | "uint" | "fixed" | "complex"
    bits: int                         # 总位宽
    frac: Optional[int] = None        # 定点小数位
    complex_base: Optional[str] = None # 复数分量类型
    shape: List[int] = field(default_factory=list)
```

**类型实例**:

| 类型 | 声明 | 硬件表示 |
|------|------|----------|
| 8-bit 有符号整数 | `TensorType("int", 8)` | `int8` |
| 16-bit 定点 Q14 | `TensorType("fixed", 16, frac=14)` | `ap_fixed<16,2>` |
| 16-bit 复数定点 | `TensorType("complex", 32, complex_base="fixed<16,14>")` | 实部+虚部各 16-bit |
| 复数向量 | `TensorType("complex", 32, shape=[16])` | 16 个复数 |

**复数运算展开**:

```python
# 复数乘法 Map 自动展开
Map("a+bj", "multiply", {"coeff": "c+dj"}, "y")

# 生成硬件：
# real = a*c - b*d
# imag = a*d + b*c
```

---

## 算法组合示例

### FIR 滤波器

```python
FormulaGraph([
    ShiftReg("x", taps=[0,1,2,3], output="taps"),
    Map("taps", "multiply", {"coeffs": h}, output="products"),
    Reduce("products", "add", Domain("all"), output="y")
])
```

### IIR 滤波器

```python
FormulaGraph([
    Cycle(
        body=[
            Map("x", "multiply", {"coeff": b0}, "p0"),
            Map("x_d1", "multiply", {"coeff": b1}, "p1"),
            Map("y_d1", "multiply", {"coeff": -a1}, "p2"),
            Reduce(["p0", "p1", "p2"], "add", Domain("all"), "y")
        ],
        feedback_edges=[
            Edge("y", "y_d1", 1),
            Edge("x", "x_d1", 1)
        ]
    )
])
```

### FFT

```python
FormulaGraph([
    Map("x", "bit_reverse", {}, "x_ordered"),
    Iteration(
        body=[Map("in", "butterfly", {"twiddle": "W[stage][k]"}, "out")],
        count=10,
        carry=[("out", "in")]
    )
])
```

### OFDM 发射机

```python
FormulaGraph([
    Map("bits", "qam_map", {"mod": "64QAM"}, "symbols"),
    Map("symbols", "subcarrier_map", {"fft_size": 1024}, "freq"),
    Iteration(
        body=[Map("in", "butterfly", {}, "out")],
        count=10,
        carry=[("out", "in")]
    ),
    ShiftReg("ifft_out", taps=[-72:1024], output="with_cp")
])
```

---

## IR 三层架构

```
MathDialect (数学语义层)
    ├── op_type: "map" | "reduce" | "shift_reg" | "delay" | "message_pass" | "cycle" | "iteration" | "switch"
    ├── op_detail: 算子参数
    └── shape: 输出张量形状

AlgoHWDialect (算法-硬件映射层)
    ├── data_type: TensorType
    ├── parallelism: int
    ├── approx_method: str
    └── saturation_guard: bool

HLSScheduleDialect (调度层)
    ├── unroll_factor: int
    ├── pipeline_ii: int
    ├── array_partition: str
    └── bram_banks: int
```

---

## 硬件映射速查

| 算子 | 关键硬件资源 | 约束要点 |
|------|-------------|----------|
| Map(multiply) | DSP48 / LUT | 位宽决定资源类型 |
| Map(tanh) | BRAM (LUT) | 表大小 vs 精度权衡 |
| Reduce(add) | 加法树 | 树深度影响时序 |
| ShiftReg | SRL32 / FF | 长延迟用 SRL 节省资源 |
| Delay | FF | - |
| Cycle | 组合逻辑 + 反馈 FF | 关键路径可能包含环路 |
| Iteration | 流水线阵列 或 复用逻辑 | 并行度 vs 面积权衡 |
| MessagePass | BRAM + 控制器 | 不规则访问需特殊地址生成 |

---

*版本: 1.0*  
*日期: 2026-04-08*
