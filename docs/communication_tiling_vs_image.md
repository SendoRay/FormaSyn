# 通信领域算法映射到硬件时的 Tiling 问题与图像处理的差异

> 本文档分析在 FormaSyn 的上下文中，通信领域（channel coding、filtering、detection、transform、synchronization）算法从数学公式映射到 FPGA/ASIC 硬件时，是否面临与图像处理类似的 Tiling 问题；如果有，通信领域的特殊性是什么；以及相比图像处理，通信领域的自动优化空间是更大还是更小。

---

## 1. 核心结论：通信领域也有 Tiling，但问题的形态完全不同

| 维度 | 图像处理 (CNN/GEMM) | 通信领域 (LDPC/滤波/检测/同步) |
|------|---------------------|--------------------------------|
| **数据规模** | 极大（4K/8K 图像，MB~GB 级） | 中等（一帧/一码字，KB~MB 级） |
| **Tiling 动机** | 片上内存（BRAM/URAM）装不下完整特征图，必须分块 | 片上内存通常能装下一帧，但**访问模式不规则**导致 bank conflict |
| **Tiling 对象** | 2D/3D 张量（高×宽×通道） | 1D 滑动窗口、图邻居列表、迭代消息 |
| **核心挑战** | 数据复用、带宽隐藏、double buffering | **图结构映射到规则存储体**、滑动窗口 stride 与 bank 数对齐、迭代流水线调度 |
| **优化空间** | 相对成熟（Halide/TVM/AutoTVM 已深度覆盖） | **更大且更未被挖掘**：精度-资源-吞吐联合探索 + 不规则访问 tiling |

**一句话总结**：
> 图像处理的 Tiling 是“把太大的规则张量切成小块”；通信领域的 Tiling 是“把不规则的图/窗口访问模式塞到规则的 BRAM bank 里，同时不破坏数值精度”。

---

## 2. 图像处理的 Tiling 为什么相对“标准”

图像处理（尤其是卷积神经网络）的内存访问模式是高度规则的：

- **2D/3D 滑动窗口**：卷积核在特征图上以固定 stride 滑动。
- **局部性可预测**：只要知道 `tile_height`、`tile_width`、`channel`，就能精确计算片上缓存大小和复用率。
- **调度原语成熟**：Halide 的 `split/reorder/vectorize/unroll`、TVM 的 `AutoTVM` 搜索空间，都是围绕“如何把规则张量切分”展开的。

因此，图像处理的 Tiling 优化空间虽然大，但已经被工业界和学术界研究得非常透彻。对于 FPGA HLS 而言，常见的做法就是：

```cpp
// 图像处理：标准的行缓冲 / 块缓冲
for (int ty = 0; ty < H / TILE_H; ty++)
  for (int tx = 0; tx < W / TILE_W; tx++) {
    // 加载 tile 到 local buffer
    // 在 tile 内做卷积
  }
```

---

## 3. 通信领域的 Tiling：三种截然不同的形态

在 FormaSyn 当前支持的 kernel 类型中，Tiling/存储分区问题至少呈现三种不同形态：

### 3.1 Filtering / Transform：滑动窗口（Sliding Window）的 Bank 对齐

**典型场景**：FIR 滤波、信道估计的滑动平均、OFDM 的变换窗口。

FormaSyn DSL 中通过 `fp.domain.window(size=L, stride=S)` 描述：

```python
graph.add(fp.reduce("x", op="add",
                    domain=fp.domain.window(size=16, stride=1),
                    output="win"))
```

**硬件映射时的 Tiling 问题**：

- 窗口大小 `L` 可能很大（如 64、128、256），若直接展开，BRAM 端口数成为瓶颈。
- 当并行度 `P` 提高时，每个周期需要同时读取 `P` 个窗口内的数据。如果 BRAM  bank 数 `B` 与窗口长度 `L` 或 stride `S` 不互质，会产生严重的 **bank conflict**。
- **Tiling 策略**：不是“把数据切小”，而是把 1D 数据流**循环分区（cyclic partitioning）**到 `B` 个 BRAM bank，使得任意滑动窗口内的 `P` 个并发读取都能映射到不同的 bank。

**与图像处理的区别**：

| | 图像处理 | 通信 Filtering |
|---|---|---|
| 维度 | 2D 块 | 1D 流 |
| 关键参数 | `tile_h`, `tile_w` | `window_size`, `window_stride`, `bank_count`, `parallelism` |
| 冲突来源 | 边界数据复用 | 滑动窗口内多个地址落到同一 bank |

### 3.2 Channel Coding（LDPC）：图邻居访问的图分区（Graph Partitioning）

**典型场景**：LDPC 解码中的 Check Node Update（CNU）和 Variable Node Update（VNU）。

FormaSyn DSL 中通过 `fp.domain.neighbors(graph_ref="H", exclude_self=True)` 描述：

```python
graph.add(fp.reduce("msg_in", op="min",
                    domain=fp.domain.neighbors(graph_ref="H", exclude_self=True),
                    output="min_msg"))
```

这里的 `H` 是 LDPC 的校验矩阵（Tanner 图）。**每个节点的邻居列表完全不规则**，由 H 矩阵的列/行权重决定。

**硬件映射时的 Tiling 问题**：

- 无法像图像卷积那样简单地用 2D tiling。
- 当并行处理 `P` 个 check node 时，每个节点要读取其对应行中的所有 variable node 消息。这些消息的存储地址散布在 BRAM 中。
- 如果不做存储分区，多个并行节点可能同时访问同一个 BRAM bank，导致冲突和 II 增大。
- **Tiling 策略**：需要基于 Tanner 图结构做 **layered scheduling** 或 **graph partitioning**（即把 Tanner 图分成若干层/子图，每层内节点间无共享边，从而可以无冲突并行）。这正是 5G NR LDPC 分层译码器的核心思想。

**与图像处理的区别**：

| | 图像处理 | 通信 LDPC |
|---|---|---|
| 数据结构 | 规则张量 | 稀疏图（CSR 格式） |
| 并行限制 | 数据依赖、带宽 | **图结构导致的 bank conflict / 读写 hazard** |
| Tiling 含义 | 空间分块 | **图分层 / 子图分区** |
| 精度约束 | PSNR/SSIM 容忍度高 | BER/FER 对近似极度敏感 |

### 3.3 Detection / Synchronization：迭代流水线的“时间 Tiling”

**典型场景**：MIMO 检测（如 MMSE/ML）、载波同步（Costas 环）、帧同步（相关峰搜索）。

这些算法的特点是：

- **迭代性**：算法本身包含多次迭代（如 LDPC 的 10-50 次迭代、迭代 MIMO 检测）。
- **流水线 vs 时间复用**：在 FPGA 上，你可以选择把迭代完全展开成深度流水线（每级做一个迭代），也可以时间复用同一套硬件做多次迭代。

**硬件映射时的 Tiling 问题**：

- 这里的 tiling 更像是 **temporal tiling（时间分块）**：一帧数据被切分成若干子帧，每个子帧在处理单元（PE）阵列中流水线通过，而 PE 阵列内部可能还需要对 H 矩阵或相关窗口做进一步的空间分区。
- 当处理单元内部有局部缓存时，子帧大小（temporal tile size）决定了 BRAM 用量和流水线深度。

**与图像处理的区别**：

| | 图像处理 | 通信 Detection/Sync |
|---|---|---|
| Tiling 维度 | 纯空间（Spatial） | **空间 + 时间（Spatial + Temporal）** |
| 主要目标 | 减少片外访存 | 平衡迭代 latency 与硬件资源复用 |
| 额外约束 | 精度通常可接受 INT8 | 定点量化位宽直接影响检测门限/捕获概率 |

---

## 4. 通信领域的特殊问题：窗口、滑动与图结构

从 FormaSyn 的 DSL 设计可以看出，通信领域有两大类特有的“域（Domain）”操作：

### 4.1 `fp.domain.window` —— 滑动窗口

- **问题**：滑动窗口的 stride 和 size 不一定是 2 的幂次。如果 HLS 自动生成的数组分区策略不当，极易产生 bank conflict。
- **优化机会**：在 DSE 或 MLC Backend 层，根据 `(window_size, window_stride, parallelism)` 自动选择 **cyclic/block/cyclic-block 混合分区**。

### 4.2 `fp.domain.neighbors` —— 图邻居

- **问题**：邻居访问的地址由 CSR 格式的 `col_idx` 决定，完全不规则。简单的数组分区无效。
- **优化机会**：
  1. **Graph Coloring / Layering**：把 Tanner 图分成若干颜色层（或层集合），每层内节点可完全并行。
  2. **Permutation-based Banking**：对消息 RAM 做地址重排（permutation），使得同一层内节点的邻居消息落在不同 bank。
  3. **Approximate Graph Sparsification**：在 DSE 层面，通过 LLM 探索是否可以用 slightly sparser 的近似图结构来降低访问冲突（但这需要 L3 BER 验证把关）。

### 4.3 精度-资源联合约束

这是通信领域**最特殊**、图像处理**最不突出**的维度：

- **图像处理**：INT8 量化后 PSNR 掉 0.5dB 通常可接受。Tiling 探索可以独立于精度探索。
- **通信领域**：LDPC 从 SPA 精确算法改为 Min-Sum 近似，可能节省 30% LUT，但会带来 0.3dB 的 SNR 损失。这个 trade-off 必须同时考虑。
- **对 Tiling 的影响**：通信领域的存储分区策略不能随意牺牲精度。例如，为了减少 BRAM，不能把消息位宽从 6 bit 降到 4 bit，除非 BER 曲线验证通过。因此，**Tiling/存储优化必须与 Quantization + Approximation 联合探索**。

---

## 5. 优化空间：通信领域比图像处理更大

综合以上分析，通信领域从算法公式到硬件的自动优化空间**不仅存在，而且很可能比图像处理更大**，原因如下：

### 5.1 搜索维度更多

图像处理的 DSE 维度相对集中：
- Tile size、Loop order、Unroll factor、Vector width。

通信领域的 DSE 维度更复杂：
- **Algorithm**：`approx_method`（SPA / Min-Sum / Offset-Min-Sum / LUT-tanh）
- **Numerical**：`quant_overrides`（每个 node 的 int/frac bits）、`scale_factor`、`offset_beta`
- **Parallelism**：`parallelism`（受图结构和 bank conflict 约束）
- **Memory**：`tiling_factor`、`bank_strategy`、`layer_schedule`
- **Pipeline**：迭代是否 fully unrolled、II target

这些维度之间存在强烈的耦合关系，手工调参几乎不可能找到全局最优，**自动探索的收益空间巨大**。

### 5.2 手工优化的成熟度低

- 图像处理：Halide/TVM/oneDNN 已经把 CNN 的 tiling 优化做到了接近天花板。
- 通信领域：LDPC 译码器、MIMO 检测器、同步模块的 HLS 实现大多依赖手写 RTL 或高度手工调参的 HLS。**自动编译/综合工具链非常不成熟**，意味着自动工具（如 FormaSyn）有更大的机会超越 baseline。

### 5.3 不规则性带来的非连续优化空间

图像处理的搜索空间虽然大，但往往是连续/分段连续的（tile size 从 16 变到 32，资源近似线性变化）。

通信领域由于图结构的存在，搜索空间是**高度非连续**的：
- 并行度从 8 提到 16 可能完全不可行（因为图着色数刚好是 8）。
- 换一个 `approx_method` 可能突然改变数据依赖图，从而打开全新的调度空间。

这种非连续性恰恰是 **LLM-based DSE（如 FormaSyn 的 DSEAgent）** 的优势所在——它不需要梯度，可以在离散、非光滑的空间中做跳跃式探索。

---

## 6. 关键质疑：加上 Tiling 后，通信算法的搜索空间会不会过大？

这是一个非常现实的问题。如果通信领域已经比图像处理多了 `approx_method`、`quant_overrides`、`parallelism` 等维度，现在再把 `tiling_factor`、`memory_strategy`、`layer_schedule` 加进来，DSE 的搜索空间会不会直接爆炸到无法收敛？

**答案是：搜索空间确实会显著扩大，但它并不会因此变得不可控，原因如下。**

### 6.1 通信数据的“规模天花板”天然限制了 Tiling 粒度的选择范围

图像处理中，一幅 4K 图像可以被切成 8×8、16×16、32×32、64×64…  tile size 的选择空间很大。而在通信领域：

- 一帧数据通常只有 **KB~MB 级别**（如 LDPC 码长 648、1296、WiFi 帧 4096 字节）。
- 片上 BRAM/URAM 通常**足够装下整帧**。因此通信领域不需要像图像那样探索“能不能装下”的极端切分。
- **Tiling 的目的不是“切小”，而是“对齐 bank”**。这意味着 tile size 往往由硬件参数（BRAM 深度、bank 数）和算法参数（window size、图着色数）唯一确定或 strongly constrained，而不是自由选择的。

> 举例：一个 64-tap FIR 滤波器，并行度为 8，BRAM 有 4 个 bank。为了无冲突读取，cyclic partition factor 基本被约束为 8 或 4 的倍数，有效选择可能只有 2~3 种，而不是像图像 tile size 那样有 10+ 种选择。

### 6.2 Kernel-aware 的强约束大幅剪枝了无效组合

在 FormaSyn 中，`kernel_type` 已经把搜索空间分割成了几个互不重叠的子空间：

| Kernel Type | 合法的 Approx Method | 合法的 Parallelism | 合法的 Memory Strategy |
|-------------|----------------------|--------------------|------------------------|
| `filtering` | `spa_exact` only | 1, 2, 4, 8, 16 | `window_fifo`, `cyclic_partition` |
| `ldpc` | `min_sum`, `offset_min_sum`, `normalized_min_sum` | ≤ 图着色数 | `layered_banking`, `naive` |
| `detection` | `spa_exact` | 1, 2, 4 | `block_partition` |
| `transform` | `spa_exact` | 1, 2, 4, 8 | `cyclic_partition`, `twiddle_permute` |

**关键洞察**：`memory_strategy` 和 `tiling_factor` 不是全局自由的，它们被 `kernel_type` 和 `approx_method` 强约束。例如：

- LDPC 不可能使用 `window_fifo`（因为没有滑动窗口）。
- FIR 滤波不可能使用 `layered_banking`（因为没有图结构）。

这种 **kernel-aware pruning** 可以把原本 $N^k$ 的全组合空间削减到 $O(N \cdot k)$ 的分层空间。

### 6.3 算法层与存储层可以分层解耦搜索

搜索空间过大的根本恐惧来自于“所有维度同时组合爆炸”。但实际上，通信领域的 DSE 可以清晰地分为两层：

**Layer 1: 算法-数值空间（Algorithm-Numerical Space）**
- `approx_method`
- `quant_overrides`（int/frac bits）
- `scale_factor` / `offset_beta`

这一层决定的是**算法的数值正确性**（BER/FER/NMSE）。如果 L3 质量验证失败，无论 tiling 怎么调都没用。

**Layer 2: 存储-调度空间（Memory-Schedule Space）**
- `parallelism`
- `memory_strategy`
- `tiling_factor`
- `pipeline_ii`

这一层决定的是**硬件资源与吞吐**（DSP/BRAM/Latency）。如果 L2 资源/时序验证失败，才需要调整这一层。

**分层搜索策略**：
1. DSEAgent 首先在 Layer 1 生成 2~4 个变体（不同 approx/quant 组合）。
2. 对每个 Layer 1 变体，Roofline Solver / MLC Backend 在 Layer 2 做局部微调（如调整 parallelism 或 tiling）。
3. 如果 Layer 1 通过了 L3 但 Layer 2 在 L1/L2 失败，反馈只作用于 Layer 2，不需要重新探索 Layer 1。

这种分层策略把原本 $O(A \times M)$ 的联合空间变成了 $O(A) + O(M)$ 的序列搜索，避免了组合爆炸。

### 6.4 物理非法组合可以被快速剪枝（Runtime Pruning）

很多 tiling + parallelism 的组合在物理上就是不可能实现的，可以在 HLS 综合之前就快速排除：

- **Bank Conflict 分析**：给定 `window_size`、`stride`、`parallelism`、`bank_count`，可以用一个简化的冲突模型在毫秒级判断该组合是否会产生 II>1 的冲突。不需要跑完整 HLS。
- **图着色数上界**：对于 LDPC，基于 CSR 结构可以快速计算 Tanner 图的近似着色数。任何 `parallelism > 着色数` 的组合直接剪枝。
- **BRAM 容量快速估算**：给定 `quant_overrides` 和 `tiling_factor`，可以在 1ms 内估算所需 BRAM 容量。若超出片上资源 20%，直接跳过。

这些 **lightweight analytical models** 可以作为前置过滤器，把 90% 以上的无效组合在进入 HLS 之前剪掉。

### 6.5 LLM 先验知识进一步缩小有效区域

FormaSyn 的 DSEAgent 使用 LLM（如 `gpt-5-codex-high`）来生成变体意图。LLM 在通信领域拥有大量先验知识：

- 它“知道”LDPC 分层译码器的典型并行度是 4 或 8，不会建议 63。
- 它“知道”FIR 滤波的 BRAM 通常用 cyclic partition，不会建议 random scatter。
- 它“知道”Min-Sum 算法在 5~6 bit 量化时性能最好，不会建议 1 bit。

这意味着 LLM 的生成不是均匀采样整个搜索空间，而是**集中在人类专家也会考虑的高价值区域**。虽然 LLM 不保证最优，但它能显著降低搜索空间的“有效体积”。

### 6.6 定量直觉：通信 vs 图像的搜索空间大小

我们可以用一个粗糙的定量模型来对比：

**图像处理（ResNet-50 风格卷积）**：
- Tile size：~10 种 (8, 16, 32, 64, 128…)
- Loop order：~6 种 (reorder 排列)
- Unroll factor：~5 种
- Vector width：~4 种
- **总组合数 ≈ $10 \times 6 \times 5 \times 4 = 1200$**

**通信领域（LDPC 译码器）**：
- Approx method：~3 种 (min_sum, offset, normalized)
- Quant (int bits)：~3 种 (4, 6, 8 bit)
- Parallelism：~3 种 (受图着色约束，如 2, 4, 8)
- Memory strategy：~2 种 (layered_banking, naive)
- Tiling factor：~2 种 (full_frame, half_frame)
- **总组合数 ≈ $3 \times 3 \times 3 \times 2 \times 2 = 108$**

即使加上 pipeline schedule 和 saturation toggle，通信领域的组合数通常也在 **$10^2 \sim 10^3$ 量级**，与图像处理相当，甚至更小。区别在于通信领域的每个组合评估更慢（需要 BER 仿真），但组合总数并不更大。

### 6.7 小结

> 加上 Tiling 后，通信算法的搜索空间**会扩大，但不会失控**。这是因为：
> 1. 数据规模小，Tiling 粒度选择有限；
> 2. Kernel-aware 约束把全局空间切成了互不相关的小子空间；
> 3. 算法层和存储层可以分层解耦搜索；
> 4. 物理模型（bank conflict、图着色、BRAM 估算）能在 HLS 前剪掉绝大多数无效组合；
> 5. LLM 先验把采样集中在高价值区域。
>
> 因此，Tiling 不仅不会导致搜索空间不可管理，反而是通信领域 DSE **尚未被充分挖掘的高收益维度**。

---

## 8. 对 FormaSyn 后续设计的建议

基于上述分析，建议在 FormaSyn 的后续迭代中，在 DSE/Backend 层面显式引入通信领域的 Tiling/Memory 优化：

### 6.1 扩展 `IntentJSON` 的 memory 相关字段

```json
{
  "variant_name": "ldpc_layered_int6_p8",
  "approx_method": "min_sum",
  "parallelism": 8,
  "memory_strategy": "layered_banking",
  "tiling_factor": 0.5,
  "enable_saturation": true
}
```

- `memory_strategy`：可选 `naive`、`cyclic_partition`、`layered_banking`、`window_fifo` 等，由 kernel_type 决定可用集合。
- `tiling_factor`：对 filtering/transform 控制滑动窗口的 BRAM tiling 粒度；对 LDPC 控制 layer size。

### 6.2 在 MLC_BACKEND 层实现 kernel-aware tiling

目前 FormaSyn 的 `MLC_BACKEND` 已经有 `adjust_tiling` 的 recovery action，但它是通用的。建议：

- **Filtering**：实现 `window_size → cyclic partition factor` 的自动推导，避免 bank conflict。
- **LDPC**：实现基于 Tanner 图 CSR 数据的 **layered schedule generator**，把 `neighbors` 域的归约操作转换成无冲突的层循环。
- **Transform**：实现基于旋转因子（twiddle factor）访问模式的 **bank permutation**。

### 6.3 把 Graph Coloring 纳入 DSE 反馈循环

如果 L2 Checker 报告 BRAM 端口冲突或 II 超标，反馈给 DSEAgent 的信息可以不只是 "reduce parallelism"，还可以是：

> "当前 Tanner 图在 parallelism=16 时存在大量 bank conflict，建议尝试 layered scheduling 或把 parallelism 降到图着色数以下。"

这要求 L2 Checker 能够分析 CSR 访问模式并给出结构化的失败原因。

---

## 7. 总结

1. **通信领域确实有 Tiling 问题**，但它不是图像处理那种“把大图像切成小块”的问题，而是 **“把不规则的图/窗口访问映射到规则 BRAM bank”** 的问题。
2. 通信领域的特殊挑战来自：
   - **滑动窗口**（`window` domain）的 stride/bank 对齐；
   - **图邻居访问**（`neighbors` domain）的图着色与分层调度；
   - **迭代算法**的时间-空间联合 tiling；
   - **精度-资源强耦合**（approx + quant 必须与 tiling 联合探索）。
3. **通信领域的自动优化空间比图像处理更大**，因为手工优化成熟度低、搜索维度更多、空间更不规则，而这正是 LLM-driven DSE（如 FormaSyn）可以发挥最大价值的领域。

