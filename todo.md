
我直接给你交底：**一个完整的、能让 LLM 跑起自动化探索闭环的 Example，必须包含 4 个核心文件。** 缺了任何一个，你要么无法验证正确性，要么 LLM 会像无头苍蝇一样乱猜。

在 `examples/fir_16tap/` 目录下，你需要准备以下内容：

---

### 1. `algorithm.dsl` (纯粹的数学拓扑定义)

这是前端解析器的输入。记住我们定下的规矩：**DSL 里绝对不能出现任何硬件相关的字眼（没有 Unroll、没有定点化位宽、没有 Pipeline）。** 它--

### 1. `algorithm.dsl` (纯粹的数学拓扑定义)

这是前端解析器的输入。记住我们定下的规矩：**DSL 里绝对不能出现任何硬件相关的字眼（没有 Unroll、没有定点化位宽、没有 Pipeline）。** 它只描述数据怎么流动。




### 2. `constraints.yaml` (探针与边界限制)

这里定义了 Roofline Solver 的天花板，以及 L3 验证流水线（我们上文讨论的 `Waveform Evaluator`）的及格线。

```yaml
# examples/01_fir_16tap/constraints.yaml

hardware_constraints:
  target_device: "xcu200-fsgd2104-2-e"
  clock_target_mhz: 300
  max_dsp: 16          # 重点：16阶理论上需要16个DSP，但我们要看LLM能不能优化到8个
  max_bram_18k: 2      # 寄存器通常用FF实现，限制BRAM看系统会不会误用
  target_ii: 1         # 吞吐量要求：每个时钟周期必须吃一个数据

algorithm_metrics:
  evaluator_type: "WaveformEvaluator"
  tolerance:
    nmse_db: -60.0     # 黄金标准：硬件定点波形与浮点波形的 NMSE 必须优于 -60dB
    max_overflows: 0   # 绝对不允许出现数值溢出卷绕
```




### 4. `ll`llm_prompt_context.md` (可选：领域知识外挂)

既然 16阶 FIR 的 LLM 探索价值在于**“对称折叠 (Symmetric Folding)”**和**“量化 (Quantization)”**，如果我们直接让 LLM 猜，它可能猜不到系数是对称的。
我们可以在这个目录下放一个很小的 Markdown，作为挂载给 LLM 的 RAG（检索增强生成）知识片段：

```markdown
# examples/01_fir_16tap/llm_prompt_context.md
[Domain Knowledge: FIR Filter]
- If `coeffs` are symmetric (e.g., h[i] == h[N-1-i]), the `add` operations can be performed BEFORE the `multiply` operations: y = (x[0]+x[15])*h[0] + (x[1]+x[14])*h[1] + ...
- This structural rewriting reduces the number of Multipliers (DSPs) by exactly half.
```

---
