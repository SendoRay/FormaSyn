# FormaSyn 智能设计空间探索 (DSE) 架构

## 核心理念

**所有报错统一送至 AgentDiagnostic，由 LLM 智能决策回退到哪一层，然后返回到该层进行迭代。**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         统一失败处理入口                                      │
│                     AgentDiagnostic.diagnose(failure)                        │
│                                                                              │
│  输入: FailureContext (包含所有错误信息)                                      │
│       - failed_at: L1_COMPILE / L1_NUMERIC / L2_CSYNTH / L3_QUALITY         │
│       - raw_error: 原始错误日志                                              │
│       - measured_metrics: 实测指标                                           │
│       - resource_usage: 资源使用情况                                         │
│                                                                              │
│  LLM 决策输出:                                                               │
│       - summary: 失败摘要                                                    │
│       - root_cause: 根因分析                                                 │
│       - recovery_decision: {                                                │
│           target_layer: "template_engine" | "roofline_solver" |             │
│                         "mlc_backend" | "codegen_agent" | "dse_agent"       │
│           action_type: 具体动作类型                                          │
│           params: 动作参数                                                   │
│           rationale: 决策理由                                                │
│         }                                                                    │
│       - should_deep_loop: 是否触发深度迭代                                    │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                      FeedbackLoop.recover(ir, failure)                       │
│                                                                              │
│  完全遵循 Agent 决策，执行对应恢复动作:                                        │
│  - target_layer = TEMPLATE_ENGINE  → 调整量化、approx_method                │
│  - target_layer = ROOFLINE_SOLVER  → 调整并行度、调度参数                    │
│  - target_layer = MLC_BACKEND      → 调整 BRAM tiling/banks                 │
│  - target_layer = CODEGEN_AGENT    → 调整 pragma                            │
│  - target_layer = DSE_AGENT        → 触发深度迭代，返回失败                  │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
    │ template_engine │    │ roofline_solver │    │  codegen_agent  │
    │   (AlgoHW IR)   │    │ (Schedule IR)   │    │   (HLS C++)     │
    └────────┬────────┘    └────────┬────────┘    └────────┬────────┘
             │                      │                      │
             │  调整量化位宽         │  调整并行度           │  调整 pragma
             │  切换 approx_method  │  调整 unroll/II       │  重新生成代码
             │                      │                      │
             └──────────────────────┴──────────────────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │   从修改后的 IR 重新执行流程    │
                    │   _recover_from_layer()       │
                    └───────────────────────────────┘
```

## 关键优势

### 1. 单一决策入口

所有错误都送到 `AgentDiagnostic`，不分散在各处：

```python
# 在 Pipeline 中统一处理
diagnostic = AgentDiagnostic()
result = diagnostic.diagnose(failure)

# 决策结果包含:
# - 回退到哪一层 (target_layer)
# - 做什么修改 (action_type + params)
# - 为什么这样决策 (rationale)
```

### 2. 完全利用 LLM 的智能

Agent 能看到完整的错误上下文，做全局最优决策：

```python
# LLM 可以看到：
# - 失败阶段 (L1/L2/L3)
# - 具体错误日志
# - 实测指标 vs 目标指标
# - 资源使用 vs 预算
# - 甚至历史修复记录

# 基于这些信息，LLM 可以：
# - 识别复杂的根因（如"时序问题其实是因为并行度过高导致布线拥塞"）
# - 权衡多个修复方案（如"降低并行度 vs 增加流水线 II"）
# - 决定是否需要根本性重构（回退到 DSE_AGENT）
```

### 3. 灵活的多层回退

| 目标层 | 可调参数 | 适用场景 |
|--------|----------|----------|
| `template_engine` | `quant_overrides` (位宽)<br>`approx_method`<br>`enable_saturation` | 数值精度不足<br>算法选择不当<br>需要更高精度 |
| `roofline_solver` | `parallelism` (并行度)<br>`unroll_factor`<br>`tile_size` | DSP/LUT 超限<br>需要降低资源 |
| `mlc_backend` | `bram_banks`<br>`tile_size` | BRAM 超限<br>不规则访问冲突 |
| `codegen_agent` | `pipeline_ii`<br>`array_partition_type` | 时序不满足<br>II 不达标 |
| `dse_agent` | 全新变体意图 | 本地修复无效<br>需要架构重构 |

### 4. 迭代恢复机制

```python
# 单次变体验证支持多次恢复尝试
max_recover_attempts = 3

for attempt in range(max_recover_attempts):
    # Agent 诊断决策
    loop_result = feedback_loop.recover(current_ir, failure)
    
    if loop_result.should_deep_loop:
        # 触发深度迭代，交由 DSE Agent 重新探索
        break
    
    # 从 Agent 决策的层重新开始
    success, failure = self._recover_from_layer(
        ir_state, 
        loop_result.target_layer,  # LLM 决策的回退层
        loop_result.new_ir,
        ...
    )
    
    if success:
        return True  # 恢复成功
    # 否则继续下一轮恢复
```

## 使用示例

### 场景 1: L1 数值失败

```
输入: NMSE = -45 dB (目标 < -60 dB), 符号错误率低

Agent 决策:
{
  "target_layer": "template_engine",
  "action_type": "relax_quant",
  "params": {"frac_bits_increment": 3},
  "rationale": "NMSE 过高但符号正确，说明小数精度不足，应增加 frac_bits"
}

执行: 在 AlgoHWDialect 上增加小数位宽，重新生成代码验证
```

### 场景 2: L2 DSP 超限

```
输入: DSP 使用 128，预算 64

Agent 决策:
{
  "target_layer": "roofline_solver",
  "action_type": "reduce_parallelism",
  "params": {"parallelism_factor": 0.5},
  "rationale": "DSP 超限 2x，应减半并行度从 8→4"
}

执行: 修改 AlgoHWDialect.parallelism，重新求解 schedule
```

### 场景 3: L2 时序复杂问题

```
输入: 时序不满足，但资源使用正常，并行度已较低

Agent 决策:
{
  "target_layer": "codegen_agent",
  "action_type": "tune_pragma",
  "params": {
    "pipeline_ii_increment": 2,
    "relax_array_partition": true
  },
  "rationale": "资源充足但时序失败，可能是 complete partition 导致布线拥塞，"
               "应改为 cyclic partition 并放宽 II"
}

执行: 修改 ScheduleDialect，调整 pragma 参数
```

### 场景 4: 严重质量问题

```
输入: 符号错误率 15%，NMSE = -20 dB

Agent 决策:
{
  "target_layer": "dse_agent",
  "action_type": "explore_new",
  "params": {"suggestion": "尝试 LUT-tanh 替代 Min-Sum"},
  "should_deep_loop": true,
  "rationale": "严重数值问题，当前 Min-Sum 近似精度不足，"
               "建议尝试 LUT-tanh 或 SPA 精确方法"
}

执行: 触发深度迭代，反馈给 DSE Agent 生成新变体
```

## 代码结构

```
formasyn/agent/
├── diagnostic.py          # AgentDiagnostic: LLM 智能诊断决策
│   ├── RecoveryLayer      # 回退目标层枚举
│   ├── RecoveryAction     # 恢复动作描述
│   ├── DiagnosticResult   # 诊断结果
│   └── AgentDiagnostic
│       ├── diagnose()     # 主入口: LLM 决策
│       ├── _llm_diagnose()       # LLM 智能诊断
│       └── _rule_based_diagnose() # 备用规则诊断
│
formasyn/feedback/
└── loop.py                # FeedbackLoop: 执行 Agent 决策
    ├── recover()          # 主入口
    ├── _apply_recovery_action()  # 根据层执行恢复
    ├── _apply_template_engine_action()  # 量化/算法调整
    ├── _apply_roofline_action()         # 并行度调整
    ├── _apply_mlc_action()              # BRAM 调整
    └── _apply_codegen_action()          # pragma 调整
```

## Prompt 设计

`AgentDiagnostic` 使用精心设计的 system prompt，包含：

1. **各层的职责说明** - 让 LLM 知道每层能做什么
2. **决策指南** - 不同错误类型的推荐处理策略
3. **输出格式** - 结构化的 JSON 决策格式
4. **决策原则** - 优先本地修复，必要时升级

这使得 LLM 能够做出明智的决策，而不是简单的规则匹配。
