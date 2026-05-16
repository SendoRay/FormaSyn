

# FormulaPilot — Codex / Cursor Agent Skill 模板
# 放置位置：项目根目录 AGENTS.md 或 .cursorrules
# 作用：让 Cursor / Codex 在整个项目中始终遵守这套规则，不需要每次重复背景

---

## 〇、你是谁，你在做什么

你是 FormulaPilot 项目的代码生成 Agent。

FormulaPilot 是一个 **AI 驱动的通信算法 FPGA 编译器**。
它的输入是用户用 Python DSL 描述的通信算法（如 LDPC、FIR、FFT），
它的输出是经过验证的、带 `#pragma HLS` 的 Vitis HLS C++ 代码，
以及对应的 BER / NMSE / SFDR 等算法质量报告。

**系统的核心哲学**：
- LLM dse agent负责算法语义层的探索（选择近似算法、量化策略），输出结构化意图 JSON   codegen agent 负责将中间表示变成对应的 hlscpp  diagnosis 负责解析反馈意见并且给出建议接到对应地方，对应地方做出对应改变
- 模板引擎负责把意图渲染成合法的中间表示，100% 语法正确
- 传统编译器（Roofline Solver + MLC）负责严谨的硬件资源映射
- 验证流水线（L1 csim → L2 csynth → L3 cosim + Quality Sim）负责逐层过滤和迭代恢复

**你在写代码时，永远不能违反这个分工。**

---

## 一、项目结构

```



FormaSyn/
├── formasyn/
    ├── dsl/
    │   ├── operators.py          # 五类 DSL 算子：map / reduce / delay / shift_reg / message_pass
    │   ├── parser.py             # FormulaGraph → Math Dialect
    │   └── template_engine.py   # IntentJSON → AlgoHW Dialect
    ├── ir/
    │   ├── math_dialect.py       # Math Dialect dataclass（算法计算图，无硬件信息）
    │   ├── algo_hw_dialect.py    # Algo-HW Dialect dataclass（含近似方法 + 位宽，无循环结构）
    │   └── schedule_dialect.py   # HLS-Schedule Dialect dataclass（含 Unroll/Tile/II/BRAM Bank）
    ├── mlc/
    │   ├── mlc_frontend.py       # H矩阵 → CSR，标注不规则访存节点（在 Solver 之前运行）
    │   └── mlc_backend.py        # 根据 Unroll Factor 决定 BRAM Bank，生成地址映射代码（在 Solver 之后运行）
    ├── golden/
    │   ├── generator.py          # Math Dialect → float64 串行 C++（裁判模型）
    │   ├── testbench_gen.py      # Golden 输出 → HLS testbench.cpp（供 L1 csim 和 L3a cosim 复用）
    │   └── quant_analyzer.py     # 运行 Golden，统计动态范围，推荐定点位宽
    ├── agent/
    │   ├── base_agent.py          
    │   ├── dse_agent.py          # 调用  API的 agent 的基类
    │   ├── codegen_agent.py          # 根据 dialect  调用对应工具 输出对应的 hlscpp 文件
    │   ├── diagnostic.py         # 解析 HLS报告 / Quality结果 → 高层归因文本（ LLM）
    │   └── knowledge_prompt.py   # 通信算法知识库（硬编码 prompt 常量）
    ├── solver/
    │   └── roofline_solver.py    # HLS-Aware Roofline：规则访存精确估算，不规则访存保守估算
    ├── checker/
    │   ├── metrics.py            # 所有 Result / Threshold dataclass 定义
    │   ├── pre_checker.py         # 准备好对应的配置环境 尽量能复用的就复用  比如 在 `examples/xx_kernel/xx_change/` 你可能需要准备好 对应的 config.cfg 什么的
    │   ├── l1_checker.py         # L1：Vitis HLS csim（testbench 由 Golden 自动生成）
    │   ├── l2_checker.py         # L2：Vitis HLS csynth（资源 + 时序）
    │   ├── l3_checker.py         # L3a cosim（Top-1 RTL验证）+ L3b Quality Sim（算法质量）
    │   └── simulators/
    │   │   ├── base.py
    │   │   ├── ber_sim.py        # channel_coding / demodulation
    │   │   ├── filter_sim.py     # filtering
    │   │   ├── transform_sim.py  # transform
    │   │   ├── detection_sim.py  # detection
    │   │   └── sync_sim.py       # synchronization
    ├── feedback/
    │   └── loop.py            
    ├── tests/
        └── test_*.py             # 每个模块对应一个测试文件
├── examples/
│   ├── 01_ldpc_cnu/
        ｜--  kernel.py             # 这个 kernel.py 是用户输入，生成 FormulaGraph，就是描述这个公式是什么样子的
        ｜--  constraints.yaml                # 这个 是 硬件的约束 （BRAM/DSP/LUT/II），由用户根据目标设备和性能需求编写，run.py 会读取这个文件来指导设计空间探索
│        └── temp/                          # 这个 temp/ 是 run.py 生成的中间产物，包含 math_dialect.json、algo_hw_dialect.json、schedule_dialect.json，生成的 hlscpp 代码，以及所有的运行结果
│   ├── 02_fir_filter/
│   ├── 03_fft_butterfly/
│   ├── 04_lms_equalizer/
│   └── 05_qam_soft_demapper/
└── run.py                   # FormaSyn 主类，串联所有模块
```


当你要加的时候，要注意放在合适的位置，而不是乱加的。
中间结果

run.py 的流程应该是


  1. 输入阶段
     输入是：命令行参数（例子名、可选超参）、constraints.yaml
     这些输入进入 run.py，由 examples/*/kernel.py 生成 FormulaGraph。
  2. DSL 到算法IR
     parser.py 把 FormulaGraph 转成 MathDialect。
     MathDialect → dse_agent.py → IntentJSON[]（多个变体）→ 不同的 math dialect 
     
     
     然后 同时送到 generator 生成float64 C++ 代码   生成 golden_outputs 和 quant_analyzer.py 每个变体的 QuantSpec（位宽建议），再送到 template_engine.py 生成 AlgoHWDialect。

     这里的原则是： MathDialect 只表达算法计算图和近似方法，完全不涉及任何硬件信息（位宽、循环结构、BRAM bank 数量等），这些都留到 AlgoHWDialect 里表达。
    
     
  3. Golden基线与量化建议
     golden/generator.py 生成 float64 参考实现并运行，输出 golden_outputs。
     golden_outputs 送到 testbench_gen.py 生成 testbench.cpp，也作为 L1/L3 的对比真值。
     quant_analyzer.py 接受 所有变体 的 math diact ，基于 golden 多次统计和对应的硬件约束  应该有一个模型或者求解器，输出 QuantSpec（位宽推荐），再送给  template_engine.py。
  4. LLM 设计空间探索
     
                                    
              

     dse_agent.py 输入 MathDialect ，输出 IntentJSON[]（多个候选变体意图）。

  5. 模板渲染与硬件映射
     template_engine.py 输出 AlgoHWDialect。
     mlc_frontend.py 在 Solver 前做 CSR/不规则访存标注，输出增强后的表示。
     roofline_solver.py 输出 ScheduleDialect（unroll/tile/II/资源估计）。
     mlc_backend.py 根据 unroll 做 BRAM bank/地址映射，输出后端映射结果。
     这些一起送到 codegen_agent.py，生成 kernel.cpp/.h 等产物。
  6. 三层验证
  pre_checker 调用 testbench_gen  生成 对应的 testbench  以及 对应的golden data，然后准备好 config.cfg 等 vitis 可能需要的一些配置 
     L1Checker  做 csim，输出 L1Result。
     L1 通过后进入 L2Checker 做 csynth，输出 L2Result（DSP/BRAM/LUT/FF/II/timing）。
     L2 通过后进入 L3Checker，输出 L3Result（L3a cosim + L3b quality 指标）。
  7. L1 失败反馈路径
     L1Result 失败时，根据 diagnositic.py 的反馈，进行对应的位置的修改
     它输出“放宽位宽后的参数”，回到 template_engine.py 重新生成后续链路。
  8. L2 失败反馈路径（按失败类型分流）
     II 超标 -> diagnositic.py 的  ，输出新 pragma，回 codegen_agent.py。
     DSP/LUT 超标 -> diagnositic.py 的 ，输出更保守并行度/位宽，回 roofline_solver.py。
     BRAM 超标 -> diagnositic.py 的，输出新 tile/bank 策略，回 mlc_backend.py。
  9. L3 失败反馈路径
     L3b 差距小 -> diagnositic.py 的，输出细粒度量化微调，回 template_engine.py。
     L3a cosim 失败或 L3b 差距大 -> diagnositic.py 的，输出 feedback_text（失败归因+建议），回 dse_agent.py 触发新一轮 Intent 生成。
  10. 诊断文本汇总路径
     agent/diagnostic.py 接收 HLS 报告和质量结果，输出高层归因文本 以及 对应的 来读这个文本、决定新的参数值、来构造回退输入，给到 deeploop ，diagnostic 负责做到底怎么改，改哪里，去哪里， deeploop 负责读入这个并且接入对应的流程步骤
      loop.py 它的工作是： 拿到 diagnostic.py 的归因文本 + 拿到某一层的"原始输入"（历史快照） → 把归因文本注入进去，构造成"新输入" → 这个新输入送回那一层重新跑
  11. 最终输出
     当有满足约束与质量的候选后，run.py 输出：
     通过的 Top-1/Top-K 变体、对应指标（L1/L2/L3）、以及落盘产物目录（代码与元数据）。
     若全部未通过，则输出失败总结并结束。



---

## 二、三层 IR 的严格边界（最容易犯错的地方）

### Math Dialect（`ir/math_dialect.py`）
**包含**：算子类型、shape、依赖关系、是否有不规则访存（由 MLC 前端标注）
**不包含**：位宽、近似方法、Unroll Factor、BRAM Bank 数量、任何循环结构

### Algo-HW Dialect（`ir/algo_hw_dialect.py`）
**包含**：Math Dialect 的所有内容 + 每个节点的 `data_type`（如 `ap_int<8>`）+ `approx_method`（如 `"min_sum"`）+ `parallelism`
**不包含**：Unroll Factor、tile_size、pipeline_ii、BRAM Bank 数量、address_mapping_code

### HLS-Schedule Dialect（`ir/schedule_dialect.py`）
**包含**：Algo-HW Dialect 的所有内容 + `unroll_factor`、`tile_size`、`pipeline_ii`、`array_partition_type`、`bram_banks`、`address_mapping_code`
**不包含**：任何 C++ 代码字符串（代码生成是 CodeGen 的职责）



---

## 三、DSL 的五类算子（不能增加，不能删除）
```python


graph = fp.FormulaGraph(name="my_kernel",
                        kernel_type="channel_coding",   # 必填，决定 L3b 用哪个 Simulator
                        inputs={"x": [8]},
                        outputs=["y"])

# 1. map：逐元素映射
graph.add(fp.map("x", func="tanh",     func_params={"scale": 0.5}, output="t"))
graph.add(fp.map("x", func="sign",     output="s"))
graph.add(fp.map("x", func="abs",      output="a"))
graph.add(fp.map("x", func="multiply", func_params={"coeff": 0.75}, output="m"))
graph.add(fp.map("x", func="clamp",    func_params={"lo": -4.0, "hi": 4.0}, output="c"))
graph.add(fp.map("x", func="quantize", func_params={"bits": 8}, output="q"))
graph.add(fp.map("x", func="lut",      func_params={"table_depth": 256}, output="l"))

# 2. reduce：归约
graph.add(fp.reduce("x", op="add", domain=fp.domain.all(),    output="sum"))
graph.add(fp.reduce("x", op="min", domain=fp.domain.all(),    output="mn"))
graph.add(fp.reduce("x", op="xor", domain=fp.domain.all(),    output="xr"))
graph.add(fp.reduce("x", op="mul",
                    domain=fp.domain.neighbors("H", exclude_self=True),
                    output="prod"))
graph.add(fp.reduce("x", op="add",
                    domain=fp.domain.window(size=16, stride=1),
                    output="win"))

# 3. delay：单步延迟
graph.add(fp.delay("x", steps=1, output="d"))

# 4. shift_reg：tap delay line（FIR 用）
graph.add(fp.shift_reg("x", taps=[0, 1, 2, 3, 4, 5, 6, 7], output="taps"))

# 5. message_pass：图上消息传递（LDPC 用）
graph.add(fp.message_pass(
    graph_ref="H",
    node_type="check_node",
    forward_map=fp.map("msg", func="tanh", func_params={"scale": 0.5}, output="_"),
    forward_reduce=fp.reduce("_", op="mul",
                              domain=fp.domain.neighbors("H", exclude_self=True),
                              output="_"),
    output="cnu_out"
))
```

**禁止行为**：
- 不能新增算子类型（如 `conv`、`matmul`），矩阵乘法必须用 `map` + `reduce` 组合表达
- 不能在 DSL 里写 `for` 循环
- `recurrence`（状态递归）类算子不在 MVP 范围内，遇到此类需求直接返回 `UnsupportedOperatorError`

---



## 五、验证流水线的层次和回退规则



这里 写 checker 怎么跑 对应的代码的 的时候 你需要参考 vitis_hls_test/ 的写法 这里面都是可以跑的  如果我们没法自动化的跑这一步 ，可能是我们哪里缺少了哪个东西  环境是没有问题的
分别跑 `csim / csynth / cosim`




在 `examples/xx_kernel/xx_change/` 目录下不同的checker 执行对应命令：

- C 仿真（csim）
`vitis-run --mode hls --csim --config hls_config.cfg --work_dir work`

- 综合（csynth）
`v++ -c --mode hls --config hls_config.cfg --work_dir work`

- 协同仿真（cosim）
`vitis-run --mode hls --cosim --config hls_config.cfg --work_dir work`


### 三层的职责
```
L1（csim）   回答：HLS C++ 的数值行为和 Golden Model 一致吗？
             工具：Vitis HLS csim（testbench 由 GoldenModelGenerator.generate_testbench() 自动生成）
             指标：sign_error_rate（coding类）/ nmse_db（其他类）
             代价：秒~分钟级

L2（csynth） 回答：综合出来的硬件资源和时序满足约束吗？
             工具：Vitis HLS csynth
             指标：actual_dsp / actual_bram / actual_lut / actual_ii
             代价：分钟级

L3a（cosim） 回答：RTL 波形和 C++ 行为一致吗？
             工具：Vitis HLS cosim，复用 L1 的 testbench.cpp
             代价：小时级，只跑 Top-1

L3b（quality）回答：在真实信号下算法质量达标吗？
             工具：Python + ctypes（编译成 .so），各类 Simulator
             指标：BER/NMSE/SFDR/EVM/RMSE（按 kernel_type 分发）
             代价：分钟~小时级，跑 Top-3
```

### 失败回退规则（必须严格遵守）


diagnosis agent 分析错误原因 然后给出一个建议  deep_loop 负责返回

```
失败类型                        回退到哪一步              触发的恢复模块
──────────────────────────────────────────────────────────────────────
L1 编译失败                   → 丢弃                    无（框架 bug）
L1 数值错误（量化太激进）      → TemplateEngine          QuantizationRelaxer
L2 II 超标（Pragma 问题）     → HLS-Schedule Dialect    PragmaTuner
L2 DSP/LUT 超标               → Algo-HW Dialect         ResourceRelaxer
L2 BRAM 超标                  → HLS-Schedule Dialect    TilingAdjuster
L3a Co-Sim 失败               → DSEAgent（LLM重探索）   DeepLoop
L3b 质量差距小（<0.5dB）      → Algo-HW Dialect         QuantTuner
L3b 质量差距大（>0.5dB）      → DSEAgent（LLM重探索）   DeepLoop
```


### 迭代上限（硬性限制

```python
MAX_RETRIES = {
    "quantization_relaxer": 2,   # L1 恢复最多2次
    "pragma_tuner":          3,   # L2 II 恢复最多3次
    "resource_relaxer":      2,   # L2 资源恢复最多2次
    "tiling_adjuster":       2,   # L2 BRAM 恢复最多2次
    "quant_tuner":           2,   # L3b 精细调整最多2次
    "deep_loop":             3,   # 深度迭代（LLM重探索）最多3轮
}
```

超过上限后，记录原因，标记变体为 `status="exhausted"`，不丢弃（保留诊断信息），继续处理下一个变体。

---

## 六、Quality Simulator 的分发规则

L3b 根据 `kernel_type` 自动选择 Simulator，不需要手动指定：

```python
SIMULATOR_MAP = {
    "channel_coding":  "BERSimulator",      # 指标：BER曲线, waterfall_intact
    "demodulation":    "BERSimulator",      # 指标：BER, SER
    "filtering":       "FilterSimulator",   # 指标：nmse_db, stopband_atten_db
    "transform":       "TransformSimulator",# 指标：sfdr_db, nmse_db
    "detection":       "DetectionSimulator",# 指标：evm_percent
    "synchronization": "SyncSimulator",     # 指标：estimation_rmse, bias_db
}
```

每个 Simulator 的测试激励生成和指标计算都在自己的类里，**不能把不同 kernel_type 的逻辑混写在一起**。

L1 的 testbench.cpp 和 L3a 的 cosim testbench 是同一份文件， 生成一次，两处复用。

---

## 七、MLC 的两个 Pass（依赖顺序不能搞错）
Memory Layout Compiler
```
MLC 前端（mlc_frontend.py）：在 Roofline Solver 之前运行
    职责：识别不规则访存节点，H矩阵 → CSR 格式存盘，标注 is_irregular_access=True
    不做：BRAM Bank 数量决策（此时不知道 Unroll Factor）

MLC 后端（mlc_backend.py）：在 Roofline Solver 之后运行
    职责：根据 Unroll Factor 计算 BRAM Bank 数量，生成 C++ 地址映射代码片段
    公式：required_banks = 向上取2的幂次(ceil(unroll_factor / 2))
    不做：CSR 转换（已经在前端完成）
```

**禁止行为**：不能在 MLC 前端里做 Bank 决策，不能在 MLC 后端里做 CSR 转换。

---

## 八、Roofline Solver 的估算原则

对于**规则访存**节点（`is_irregular_access=False`）：做精确估算
对于**不规则访存**节点（`is_irregular_access=True`）：做保守估算（pipeline_ii × 2）

保守估算的目的是"不误杀好方案"（宁可让废案进入 L2，不能让好方案被 Roofline 错误过滤）。真实的 II 值由 L2 的 csynth 来确认。

Roofline 的核心公式：
```python
# tile_size
max_tile = (bram_kb * 1024 * 8) // (2 * total_bits * shape[0])
tile_size = prev_power_of_2(max_tile)

# unroll_factor
dsp_per_op = {"mul": 2, "add": 0, "min": 0, "max": 0, "xor": 0}
unroll = min(parallelism, dsp_count // max(1, dsp_per_op[op]))
unroll_factor = prev_power_of_2(unroll)

# pipeline_ii
if unroll_factor >= shape[0]:
    pipeline_ii = 1
else:
    pipeline_ii = ceil(shape[0] / unroll_factor)
if node.is_irregular_access:
    pipeline_ii *= 2   # 保守系数
```

---

### Dataclass 风格
所有数据结构用 `@dataclass`，不用 `dict`，不用 `namedtuple`：
```python
@dataclass
class L2Result:
    passed:          bool
    actual_dsp:      int
    actual_bram:     int
    actual_lut:      int
    actual_ii:       int
    fail_reason:     Optional[str]
    raw_report:      str
    recovery_action: Optional[str]  # "pragma_tune" | "resource_relax" | "tiling_adjust" | "discard" | None
```

### 测试
每个模块必须有对应的 `tests/test_{module}.py`。

---

## 十、你在生成代码时的决策流程

当你收到一个编码任务时，按以下顺序思考，不能跳过：

```
1. 确认这个任务属于哪个模块（对照第一节的目录结构）
2. 确认这个模块的输入类型和输出类型（对照第二节的 IR 边界）
3. 确认这个模块不需要做哪些事情（避免越权）
4. 检查是否需要调用外部工具（Vitis HLS / g++ / ctypes），
   如果是，加 timeout 和 fallback
5. 写代码
6. 写对应的测试（不能只写代码不写测试）
```

**遇到模糊需求时的处理方式**：
- 如果需求描述和本文档冲突，先思考再询问清楚，最后再去做，并在代码注释里标注冲突点


---

## 十一、24 个 Benchmark Kernel 的 kernel_type 映射

生成 example 时必须按以下表格设置 `kernel_type`，不能自定义：

| kernel | kernel_type | L3b Simulator | 主要验证指标 |
|--------|------------|---------------|------------|
| ldpc_cnu_dc8 | channel_coding | BERSimulator | BER, waterfall_intact |
| ldpc_cnu_dc16 | channel_coding | BERSimulator | BER, waterfall_intact |
| ldpc_vnu | channel_coding | BERSimulator | BER |
| hamming_soft_decode | channel_coding | BERSimulator | BER |
| bch_error_poly | channel_coding | BERSimulator | correction_rate |
| fir_lp_16tap | filtering | FilterSimulator | nmse_db, stopband_atten_db |
| fir_lp_64tap | filtering | FilterSimulator | nmse_db, stopband_atten_db |
| rrc_matched_filter | filtering | FilterSimulator | isi_suppression_db |
| cic_decimator | filtering | FilterSimulator | nmse_db |
| halfband_filter | filtering | FilterSimulator | nmse_db |
| polyphase_branch | filtering | FilterSimulator | nmse_db |
| fft_butterfly | transform | TransformSimulator | sfdr_db, nmse_db |
| fft_8point | transform | TransformSimulator | sfdr_db |
| fft_real | transform | TransformSimulator | nmse_db |
| ofdm_cp_insert | filtering | FilterSimulator | correctness |
| lms_eq_8tap | detection | DetectionSimulator | evm_percent |
| lms_eq_32tap | detection | DetectionSimulator | evm_percent |
| mimo_zf_2x2 | detection | DetectionSimulator | evm_percent |
| qam16_soft_demap | demodulation | BERSimulator | BER, SER |
| freq_offset_est | synchronization | SyncSimulator | estimation_rmse |
| power_est_rms | synchronization | SyncSimulator | estimation_rmse |
| zadoff_chu_corr | synchronization | SyncSimulator | detection_prob |
| qpsk_soft_demod | demodulation | BERSimulator | BER |
| qam64_soft_demap | demodulation | BERSimulator | BER, SER |

---


---

## 十三、不能做的事情（红线，遇到立刻停止）

2. **不能跳过 testbench 自动生成**，直接用 Golden Model 输出填充 testbench，不允许手写 testbench
3. **不能在 MLC 前端做 BRAM Bank 决策**（依赖 Unroll Factor，只能在 MLC 后端做）
4. **不能对同一个变体的同类失败无限重试**（遵守第五节的迭代上限）
5. **不能新增 DSL 算子类型**（五类算子已经足够覆盖所有 MVP kernel）
6. **不能实现 recurrence 类算子**（Viterbi、IIR、PLL 等不在 MVP 范围内）
7. **不能把不同 kernel_type 的 Simulator 逻辑混写**（每个 Simulator 只处理自己的类型）
9. **不能用 print() 做日志**（全部用 logging）
10. **不能写没有测试的模块**（每个模块必须有对应的 test_*.py）





P0 — 安全（必须修）                                                                                                           
                                                                                                                                
  1. API Key 硬编码 — base_agent.py:16 和 test_api.py:13 明文写死了 API Key，提交到公开仓库即泄露。应改为环境变量或 .env        
  文件读取。                                                                                                                    
                  
  P1 — 代码质量（推荐修）                                                                                                       
                  
  2. 大量重复代码 — testbench 生成（l1_checker.py vs testbench_gen.py）、参数解析（两个位置）、mock 头文件生成（两个位置）、NMSE
   计算（三个位置）完全重复。应提取公共工具模块。
  3. 配置系统形同虚设 — base_agent.py 试图从 config.yaml 读取覆盖配置，但文件根本不存在。应删除死代码或创建真实配置。           
  4. 路径导入 hack — formasyn/checker/__init__.py 和 agent/diagnostic.py 使用 FormaSyn.formasyn.* 绝对导入，依赖 run.py 修改    
  sys.path。应改为相对导入。                                                                                                    
  5. 检测模块职责重叠 — checker/diagnostic.py 和 agent/diagnostic.py 功能重复。                                                 
                                                                                                                                
  P2 — 测试与文档                                                                                                               
                                                                                                                                
  6. 测试覆盖仅 6% — 只有 agent 模块有测试，其余 7 个核心模块全无。                                                             
  7. README.md 过时 — 引用已不存在的 feedback/pragma_tuner.py 和 deep_loop.py。
                                                                                                                                
  P3 — 架构扩展                                                                                                                 
                                                                                                                                
  8. 5 种算子不够 — supported_kernels.py 标记需要扩展 (ButterflyOp, TrellisOp 等)，当前 DSL 表达能力有限。                      
  9. 缺少 pyproject.toml/requirements.txt — 无法锁定依赖版本。
                                                                          