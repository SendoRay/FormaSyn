# FVIR Op 粒度分析：方案 A vs 方案 B

## 评估方法

用同一个算法（LDPC Min-Sum CN Update）在两种粒度下表达，然后分析 LLM 生成 Verilog 时会遇到什么。

---

## 方案 A：极简类别型（5类，~10个子op）

```fvir
@kernel ldpc_cn_min_sum
@constraint { msg_width: 6, dc: 19, throughput: "10Gbps", freq: 500MHz }

signs = ELEMENTWISE(sign, L_q[0..dc-1])
total_sign = REDUCE(xor, signs, dc)
magnitudes = ELEMENTWISE(abs, L_q[0..dc-1])
min_ex[j] = REDUCE(min_exclude, magnitudes, dc, j)  # 对每个j
L_r[j] = ELEMENTWISE(mux, total_sign ^ signs[j], min_ex[j], -min_ex[j])
```

**LLM 看到这个需要推断什么：**
- `REDUCE(xor, signs, dc)` → XOR 链/树？寄存器级数？
- `REDUCE(min_exclude, ...)` → 怎么实现？存 min1+min2+argmin？
- `ELEMENTWISE(mux, ...)` → 一个 MUX 还是 dc 个并行 MUX？
- 流水线怎么加？没有提示

**结论**：表达力够，但 LLM 需要自己"补全"大量硬件实现细节。这可能是优点（给 LLM 自由度探索），也可能是缺点（容易出错）。

---

## 方案 B：中等语义型（15-20个op）

```fvir
@kernel ldpc_cn_min_sum
@constraint { msg_width: 6, dc: 19, throughput: "10Gbps", freq: 500MHz }

signs = SIGN_EXTRACT(L_q[0..dc-1])           # 明确：取符号位
total_sign = XOR_REDUCE(signs, dc)            # 明确：XOR 树
magnitudes = ABS(L_q[0..dc-1])               # 明确：补码取绝对值
{min1, min2, argmin1} = MIN_PAIR(magnitudes, dc)  # 明确：找最小和次小
min_ex[j] = SELECT(j == argmin1, min2, min1)  # 明确：排除逻辑
L_r[j] = SIGN_APPLY(total_sign ^ signs[j], min_ex[j])  # 明确：符号恢复
```

**LLM 看到这个的优势：**
- `MIN_PAIR` → LLM 直接知道"遍历一次，维护 min1/min2/argmin"
- `XOR_REDUCE` → 明确是树形结构
- 每一步到 Verilog 的映射几乎是 1:1

**缺点**：
- 引入了 `MIN_PAIR`、`SIGN_EXTRACT`、`SIGN_APPLY` 等通信领域特有 op
- 新 kernel 可能需要新 op（扩展性问题）

---

## 核心权衡

| 维度 | 方案 A (极简) | 方案 B (中等) |
|------|--------------|--------------|
| Op 数量 | ~10 | ~20 |
| 表达通用性 | ★★★★★ (任何算法都能表达) | ★★★☆ (可能遇到需要新op的情况) |
| LLM 理解难度 | ★★ (概念少，容易记) | ★★★ (概念多一些，但每个更具体) |
| LLM 生成准确性 | ★★☆ (自由度大→错误空间大) | ★★★★ (约束强→不容易出错) |
| 硬件映射明确性 | ★★☆ (需要 LLM 自己推断) | ★★★★★ (几乎1:1映射) |
| 优雅程度 | ★★★★★ | ★★★ |
| 学术新颖性 | ★★★★ (极简设计=更强的claim) | ★★★ (相对常规) |
| 实验可预测性 | ★★ (结果方差可能大) | ★★★★ (结果更稳定) |

---

## 我的评估结论

**推荐：方案 A 为主，方案 B 的核心 op 作为"语法糖"可选扩展。**

理由：

1. **论文叙事更强**：如果你能用 5 类 ~10 个基础 op 表达 130+ 个通信 kernel，这本身就是一个很强的 claim——"通信算法的硬件实现本质上只需要这几类运算"。

2. **LLM 的能力应该被信任而非限制**：你的核心假设之一是"LLM 比人更好地理解公式"。如果 IR 太细太具体，反而限制了 LLM 的创造空间。LLM 看到 `REDUCE(min_exclude, ...)` 后自己决定用 min1/min2 策略——这正是你想测试的能力。

3. **变换自由度更大**：方案 A 下，LLM 从同一个 `REDUCE(min, ...)` 可以探索多种实现。方案 B 的 `MIN_PAIR` 已经暗示了实现方式，限制了变换空间。

4. **消融实验的价值**：在论文中可以做"方案 A vs 方案 B"的对比实验——如果方案 A 效果接近方案 B，说明 LLM 确实有足够的硬件映射能力；如果方案 B 显著更好，说明领域特化 op 的价值。

---

## 方案 A 最终 Op 集设计

```
FVIR Op 集 (5类, 约12个基础op)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
类别 1: ELEMENTWISE — 逐元素标量运算
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  算术: +, -, *, /
  一元: abs, neg, sign
  比较: max, min, clip
  移位: <<, >>  (×2^n, ÷2^n)
  逻辑: &, |, ^, ~

用法: ELEMENTWISE(op, operands...)
可向量化: ELEMENTWISE(op, array[0..N-1], ...)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
类别 2: REDUCE — N→1 规约
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  op: sum, prod, min, max, xor, and, or

用法: REDUCE(op, array, N)
变体: REDUCE_EXCLUDE(op, array, N, exclude_idx)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
类别 3: MEMORY — 存储与时序
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  delay(x, cycles)
  buffer(x, size)
  rom(addr, table)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
类别 4: CONTROL — 结构
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  iterate(body, N)
  select(cond, a, b)
  index(array, idx)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
类别 5: CONSTRAINT — 约束标注
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  @width(var, integer_bits, frac_bits)
  @range(var, min, max)
  @throughput(value)
  @freq(value)
  @resource_limit(type, count)
```

总共：
- 类别 1: ~15 个算术/逻辑运算符（但都是 ELEMENTWISE 下的参数）
- 类别 2: 7 个规约运算 + 1 个变体
- 类别 3: 3 种存储原语
- 类别 4: 3 种控制结构
- 类别 5: 约束标注

**本质上只有 5 个"语法概念"**，非常极简。

---

## 完整流程（含迭代和回退）

```
数学公式 (LaTeX)
    │
    ▼
[Stage 1: Parse] → FVIR (naive, 直接翻译)
    │
    ▼
[Stage 2: LLM Transform Agent]
    │  读取 FVIR + Transform Library
    │  生成 N 个变体:
    │    variant_0: naive
    │    variant_1: 等价变换
    │    variant_2: 等价变换
    │    variant_3: 近似变换
    │    ...
    ▼
[Stage 3: LLM Codegen Agent] → 每个 variant → Verilog
    │
    ▼
[Stage 4: Verify & Select]
    │
    ├─── Verilator 编译失败 ──→ [回退到 Stage 3] LLM 修 code
    │                           (最多 K 次，超过则放弃该 variant)
    │
    ├─── Verilator 仿真失败 ──→ [回退到 Stage 3] LLM 修 code
    │    (vs Golden Model)       或 [回退到 Stage 2] 换变换策略
    │
    ├─── Yosys 综合：不满足约束 ──→ [回退到 Stage 2] 
    │    (面积超/频率不够)           尝试新变换 or 调整并行度
    │
    └─── 全部通过 ──→ 收集所有通过的 variants
                          │
                          ▼
                     [Stage 5: Rank & Iterate]
                          │ 按资源/频率/功耗排序
                          │ 选 Top-1 为当前最优
                          │
                          │ 是否继续优化？
                          ├─ 未达目标 → [回退到 Stage 2]
                          │              提示: "当前最优是 variant_k，
                          │              资源=X, 频率=Y，能否做得更好？"
                          │              LLM 基于当前最优探索新变换
                          │
                          └─ 达到目标 or 收敛（连续M轮无提升）
                               │
                               ▼
                             ✓ 输出最优设计
```

关键设计：
- **每一步都可以回退**，不是单向流水线
- **LLM Agent 参与所有回退决策**——看到错误信息/性能数据后决定修 code 还是换策略
- **收敛判断**：连续 M 轮没有找到更优的 variant → 停止
- **失败上限**：每个 variant 最多尝试 K 次修复，超过就丢弃
