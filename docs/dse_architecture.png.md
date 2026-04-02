# DSE 架构流程图 (文本版)

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           FormaSyn 智能 DSE 架构                                  │
│                      "所有报错统一送到 Agent，由 LLM 决策回退层"                     │
└─────────────────────────────────────────────────────────────────────────────────┘

                                    开始
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│  Stage 1: 高层 DSE (DSEAgent)                                                    │
│  ─────────────────────────                                                       │
│  MathDialect + QuantSpecs + Hardware Constraints                                 │
│           │                                                                      │
│           ▼                                                                      │
│  LLM.generate_intents() ──────► IntentJSON[] (多个变体意图)                      │
│  - approx_method                                                                │
│  - parallelism                                                                  │
│  - quant_overrides                                                              │
└─────────────────────────────────────────────────────────────────────────────────┘
           │
           ▼ 对每个变体
┌─────────────────────────────────────────────────────────────────────────────────┐
│  Stage 2: 算法-硬件映射 (TemplateEngine)                                         │
│  ───────────────────────────────────────                                        │
│  IntentJSON + MathDialect ──────► AlgoHWDialect                                 │
│           │                                                                      │
│           │  • 应用 approx_method 重写 (tanh→sign+abs)                          │
│           │  • 注解数据类型 (ap_int/ap_fixed)                                   │
│           │  • 设置 parallelism, saturation_guard                               │
│           ▼                                                                      │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Stage 3: 调度求解 (RooflineSolver)                                              │
│  ─────────────────────────────────                                               │
│  AlgoHWDialect ──────► HLSScheduleDialect                                        │
│           │                                                                      │
│           │  • 计算 tile_size (BRAM-aware)                                      │
│           │  • 计算 unroll_factor (DSP-aware)                                   │
│           │  • 计算 pipeline_ii                                                 │
│           │  • array_partition_type                                             │
│           ▼                                                                      │
├─────────────────────────────────────────────────────────────────────────────────┤
│  Stage 4: 代码生成 (CodegenAgent)                                                │
│  ────────────────────────────────                                                │
│  HLSScheduleDialect ──────► kernel.cpp + kernel.h                                │
└─────────────────────────────────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│  Stage 5: 三级验证                                                               │
│  ────────────────                                                                │
│  L1: 数值验证 ───► L2: 综合验证 ───► L3: 质量验证                                │
│   (g++)              (Vitis HLS)        (Co-Sim)                                │
└─────────────────────────────────────────────────────────────────────────────────┘
           │
           └── 失败? ──────────────────────────────────────────────────────────────┐
                                                                                  │
                          ┌──────────────────────────────────────┐                │
                          ▼                                      │                │
┌─────────────────────────────────────────────────────────────────────────────────┤
│                    统一失败处理入口 (AgentDiagnostic)                              │
│  ─────────────────────────────────────────────────                               │
│                                                                                  │
│   输入: FailureContext                                                          │
│   ├── failed_at: L1_NUMERIC / L2_CSYNTH / L3_QUALITY                           │
│   ├── raw_error: "DSP usage 128 > budget 64"                                   │
│   ├── measured_metrics: {nmse_db: -45, sign_error_rate: 0.001}                 │
│   ├── resource_usage: {dsp: 128, bram: 20, lut: 5000}                          │
│   └── resource_budget: {dsp: 64, bram: 32, lut: 10000}                         │
│                                                                                  │
│   LLM 分析决策:                                                                 │
│   "DSP 超限 2x，应减半并行度，回退到 roofline_solver 层"                         │
│                                                                                  │
│   输出: DiagnosticResult                                                        │
│   ├── recovery_action: RecoveryAction                                          │
│   │   ├── layer: RecoveryLayer.ROOFLINE_SOLVER  ◄── 决策: 回退到哪层          │
│   │   ├── action_type: "reduce_parallelism"                                    │
│   │   ├── params: {"parallelism_factor": 0.5}                                  │
│   │   └── rationale: "DSP 超限，降低并行度"                                    │
│   └── should_deep_loop: false                                                  │
└─────────────────────────────────────────────────────────────────────────────────┤
           │                                                                      │
           ▼                                                                      │
┌─────────────────────────────────────────────────────────────────────────────────┤
│                    执行恢复 (FeedbackLoop.recover)                               │
│                                                                                  │
│   根据 agent.target_layer 选择恢复动作:                                         │
│                                                                                  │
│   ┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐     │
│   │ TEMPLATE_ENGINE │ ROOFLINE_SOLVER │  MLC_BACKEND    │ CODEGEN_AGENT   │     │
│   ├─────────────────┼─────────────────┼─────────────────┼─────────────────┤     │
│   │ • relax_quant   │ • reduce_para-  │ • adjust_tiling │ • tune_pragma   │     │
│   │ • change_approx │   llelism       │ • reduce_banks  │ • reduce_unroll │     │
│   │ • toggle_sat    │ • increase_para │                 │ • regenerate    │     │
│   └────────┬────────┴────────┬────────┴────────┬────────┴────────┬────────┘     │
│            │                 │                 │                 │              │
│            └─────────────────┴─────────────────┴─────────────────┘              │
│                              │                                                   │
│                              ▼                                                   │
│   ┌─────────────────────────────────────────────────────────────────────┐       │
│   │  从修改后的 IR 重新执行流程                                         │       │
│   │  _recover_from_layer(target_layer, new_ir)                         │       │
│   │                                                                     │       │
│   │  if layer == TEMPLATE_ENGINE:                                       │       │
│   │      new_algo_hw = new_ir                                           │       │
│   │      schedule = solver.solve(new_algo_hw)  # 重新求解               │       │
│   │                                                                     │       │
│   │  if layer == ROOFLINE_SOLVER:                                       │       │
│   │      new_algo_hw = new_ir                                           │       │
│   │      schedule = solver.solve(new_algo_hw)  # 重新调度               │       │
│   │                                                                     │       │
│   │  if layer in [MLC_BACKEND, CODEGEN_AGENT]:                          │       │
│   │      schedule = new_ir               # 直接使用修改后的 schedule    │       │
│   │                                                                     │       │
│   │  # 重新生成代码并验证                                               │       │
│   │  artifacts = codegen.generate(schedule)                             │       │
│   │  result = re_verify(artifacts)                                      │       │
│   │                                                                     │       │
│   └─────────────────────────────────────────────────────────────────────┘       │
│                              │                                                   │
│                              ▼                                                   │
│                    ┌─────────────────┐                                           │
│                    │   验证通过?     │                                           │
│                    └────────┬────────┘                                           │
│                             │                                                    │
│              ┌──────────────┼──────────────┐                                     │
│              ▼              ▼              ▼                                     │
│            通过            失败         达到最大                                 │
│              │              │          恢复次数                                  │
│              ▼              │              │                                     │
│           返回            继续下一次      返回                                   │
│           成功            恢复循环        失败                                   │
│                             │                                                    │
└─────────────────────────────┼────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │  Agent 决策: should_deep_loop │
              └───────────────┬───────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
           false           true           (其他失败)
              │               │               │
              ▼               ▼               ▼
           本地恢复      触发深度迭代      记录失败
           完成         (DSE Agent)      进入下一轮
                              │
                              ▼
              ┌───────────────────────────────┐
              │ feedback_loop.generate_       │
              │ feedback_for_llm(failures)   │
              └───────────────┬───────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │ DSEAgent.generate_intents(    │
              │   feedback_text=feedback)    │
              └───────────────┬───────────────┘
                              │
                              ▼
                    生成新的变体意图
                    (基于失败反馈)
                              │
                              └──────────────► 回到 Stage 1
```

## 关键设计决策

### 1. 统一入口
```python
# 所有失败都送到这里
agent = AgentDiagnostic()
result = agent.diagnose(failure)

# 决策结果包含:
result.recovery_action.layer      # 回退到哪层
result.recovery_action.params     # 修改参数
result.should_deep_loop           # 是否深度迭代
```

### 2. 灵活回退
```python
# Agent 可以决定回退到任意层
RecoveryLayer.TEMPLATE_ENGINE  # 改量化/算法
RecoveryLayer.ROOFLINE_SOLVER  # 改并行度
RecoveryLayer.MLC_BACKEND      # 改 BRAM
RecoveryLayer.CODEGEN_AGENT    # 改 pragma
RecoveryLayer.DSE_AGENT        # 重新探索
```

### 3. 迭代恢复
```python
# 单次验证支持多次恢复
for attempt in range(max_recover_attempts):
    result = feedback_loop.recover(current_ir, failure)
    
    if result.should_deep_loop:
        break  # 触发深度迭代
    
    success, failure = recover_from_layer(
        result.target_layer,  # Agent 决策
        result.new_ir
    )
    
    if success:
        return True
```

### 4. 智能决策 (LLM)
```
输入: 完整的失败上下文
       ↓
LLM 分析:
  - 失败阶段和类型
  - 具体错误信息
  - 实测 vs 目标指标
  - 资源使用情况
  - 历史修复记录
       ↓
输出: 最优回退策略
  - 选择最可能成功的层
  - 确定具体修改参数
  - 给出决策理由
```
