# IR 架构扁平化改造对比：以 `vec_add` 为例

> 本文档展示在 **现有三层继承架构** 与 **扁平化统一 IR 架构** 下，`vec_add` kernel 经过 Pipeline 后三种 IR（MathDialect → AlgoHWDialect → HLSScheduleDialect）的具体输出形态。

---

## 现有架构：三层继承（MathNode → AlgoHWNode → ScheduleNode）

### 1. MathDialect（Parser 输出）

节点类型为 `MathNode`，仅包含纯数学语义字段。

```json
{
  "kernel_name": "vec_add",
  "nodes": {
    "a": {
      "node_id": "a",
      "op_type": "input",
      "op_detail": {},
      "shape": [16],
      "input_nodes": [],
      "is_irregular_access": false,
      "csr_ref": null
    },
    "b": {
      "node_id": "b",
      "op_type": "input",
      "op_detail": {},
      "shape": [16],
      "input_nodes": [],
      "is_irregular_access": false,
      "csr_ref": null
    },
    "c": {
      "node_id": "c",
      "op_type": "map",
      "op_detail": {
        "func": "add",
        "func_params": { "other_ref": "b" }
      },
      "shape": [16],
      "input_nodes": ["a", "b"],
      "is_irregular_access": false,
      "csr_ref": null
    }
  },
  "input_nodes": ["a", "b"],
  "output_nodes": ["c"],
  "target_metric": "throughput",
  "hw_constraint": "",
  "bram_bank_count": null
}
```

### 2. AlgoHWDialect（TemplateEngine 输出）

节点类型升级为 `AlgoHWNode`（继承自 `MathNode`），新增了 `data_type`、`approx_method`、`parallelism` 等硬件映射字段。

```json
{
  "variant_id": "minimal_baseline",
  "parent_kernel_name": "vec_add",
  "nodes": {
    "a": {
      "node_id": "a",
      "op_type": "input",
      "op_detail": {},
      "shape": [16],
      "input_nodes": [],
      "is_irregular_access": false,
      "csr_ref": null,
      "data_type": "ap_int<8>",
      "approx_method": "spa_exact",
      "parallelism": 1,
      "saturation_guard": true,
      "quant_int_bits": 8,
      "quant_frac_bits": 0
    },
    "b": { /* 同 a */ },
    "c": {
      "node_id": "c",
      "op_type": "map",
      "op_detail": { "func": "add", "func_params": { "other_ref": "b" } },
      "shape": [16],
      "input_nodes": ["a", "b"],
      "is_irregular_access": false,
      "csr_ref": null,
      "data_type": "ap_int<8>",
      "approx_method": "spa_exact",
      "parallelism": 1,
      "saturation_guard": true,
      "quant_int_bits": 8,
      "quant_frac_bits": 0
    }
  },
  "intent_json": { /* DSE 意图 */ },
  "input_nodes": ["a", "b"],
  "output_nodes": ["c"],
  "estimated_dsp": 0,
  "estimated_bram": null
}
```

### 3. HLSScheduleDialect（RooflineSolver 输出）

节点类型再次升级为 `ScheduleNode`（继承自 `AlgoHWNode`），新增了 `tile_size`、`unroll_factor`、`pipeline_ii` 等调度字段。

```json
{
  "variant_id": "minimal_baseline",
  "nodes": {
    "a": {
      "node_id": "a",
      "op_type": "input",
      "op_detail": {},
      "shape": [16],
      "input_nodes": [],
      "is_irregular_access": false,
      "csr_ref": null,
      "data_type": "ap_int<8>",
      "approx_method": "spa_exact",
      "parallelism": 1,
      "saturation_guard": true,
      "quant_int_bits": 8,
      "quant_frac_bits": 0,
      "tile_size": 131072,
      "unroll_factor": 1,
      "pipeline_ii": 16,
      "array_partition_type": "none",
      "bram_banks": 0,
      "address_mapping_code": null
    },
    "b": { /* 同 a，字段堆叠到 16 个 */ },
    "c": { /* 同 a + op_detail，字段堆叠到 16 个 */ }
  },
  "input_nodes": ["a", "b"],
  "output_nodes": ["c"],
  "total_dsp_estimate": 0,
  "total_bram_estimate": 177,
  "expected_ii": 16
}
```

#### 现有架构的问题（在 `vec_add` 上的体现）

1. **字段重复堆叠**：到了 Schedule 层，即使是一个简单的 `input` 节点，也要携带 16 个字段，其中大部分（如 `tile_size`、`address_mapping_code`）对 `input` 节点毫无意义。
2. **类型转换开销**：`TemplateEngine.render()` 中需要 `deepcopy` 并把 `MathNode` 转换为 `AlgoHWNode`；`RooflineSolver.solve()` 中又需要把 `AlgoHWNode` 转换为 `ScheduleNode`。
3. **FeedbackLoop 恢复困难**：当 L2 Checker 失败，需要把 `HLSScheduleDialect` 回退到 `AlgoHWDialect` 重新调整量化时，必须做“向下转型”，在 Python 中这实际上是重新构造一个新类型的节点，容易丢失字段或引入不一致。

---

## 改造后架构：统一 `IRNode` + 视图层

### 核心设计

```python
from dataclasses import dataclass, field
from typing import Optional
from enum import Enum, auto

class NodeStage(Enum):
    MATH = auto()
    ALGO_HW = auto()
    SCHEDULE = auto()

@dataclass
class IRNode:
    """Unified IR node: contains all possible attributes, but only the
    relevant subset is populated at any given stage.
    """
    # ── Core identity ────────────────────────────────────────────────
    node_id: str
    stage: NodeStage = NodeStage.MATH

    # ── Math layer fields ────────────────────────────────────────────
    op_type: str = ""
    op_detail: dict = field(default_factory=dict)
    shape: list[int] = field(default_factory=list)
    input_nodes: list[str] = field(default_factory=list)
    is_irregular_access: bool = False
    csr_ref: Optional[str] = None

    # ── Algo-HW layer fields (populated after TemplateEngine) ────────
    data_type: str = "float64"
    approx_method: Optional[str] = None
    parallelism: int = 1
    saturation_guard: bool = False
    quant_int_bits: int = 8
    quant_frac_bits: int = 0

    # ── Schedule layer fields (populated after RooflineSolver) ───────
    tile_size: Optional[int] = None
    unroll_factor: int = 1
    pipeline_ii: int = 1
    array_partition_type: str = "none"
    bram_banks: int = 0
    address_mapping_code: Optional[str] = None

    # ── Helper: return only fields meaningful for current stage ──────
    def to_math_view(self) -> dict:
        return {
            "node_id": self.node_id,
            "op_type": self.op_type,
            "op_detail": self.op_detail,
            "shape": self.shape,
            "input_nodes": self.input_nodes,
            "is_irregular_access": self.is_irregular_access,
            "csr_ref": self.csr_ref,
        }

    def to_algohw_view(self) -> dict:
        base = self.to_math_view()
        base.update({
            "data_type": self.data_type,
            "approx_method": self.approx_method,
            "parallelism": self.parallelism,
            "saturation_guard": self.saturation_guard,
            "quant_int_bits": self.quant_int_bits,
            "quant_frac_bits": self.quant_frac_bits,
        })
        return base

    def to_schedule_view(self) -> dict:
        base = self.to_algohw_view()
        base.update({
            "tile_size": self.tile_size,
            "unroll_factor": self.unroll_factor,
            "pipeline_ii": self.pipeline_ii,
            "array_partition_type": self.array_partition_type,
            "bram_banks": self.bram_banks,
            "address_mapping_code": self.address_mapping_code,
        })
        return base


@dataclass
class UnifiedKernelIR:
    """The single underlying IR container."""
    kernel_name: str
    variant_id: Optional[str] = None
    nodes: dict[str, IRNode] = field(default_factory=dict)
    input_nodes: list[str] = field(default_factory=list)
    output_nodes: list[str] = field(default_factory=list)
    intent_json: dict = field(default_factory=dict)
    # Stage-specific metadata is stored in flat fields
    target_metric: str = "throughput"
    hw_constraint: str = ""
    estimated_dsp: Optional[int] = None
    estimated_bram: Optional[int] = None
    expected_ii: int = 1
```

视图层只提供**投影接口**，不复制数据：

```python
@dataclass
class MathDialect:
    _backing: UnifiedKernelIR

    @property
    def kernel_name(self) -> str: return self._backing.kernel_name
    @property
    def nodes(self) -> dict[str, dict]:  # 返回过滤后的 view
        return {nid: n.to_math_view() for nid, n in self._backing.nodes.items()}
    ...

@dataclass
class AlgoHWDialect:
    _backing: UnifiedKernelIR
    @property
    def nodes(self) -> dict[str, dict]:
        return {nid: n.to_algohw_view() for nid, n in self._backing.nodes.items()}
    ...

@dataclass
class HLSScheduleDialect:
    _backing: UnifiedKernelIR
    @property
    def nodes(self) -> dict[str, dict]:
        return {nid: n.to_schedule_view() for nid, n in self._backing.nodes.items()}
    ...
```

---

### 1. MathDialect 视图（Parser 输出）

底层 `UnifiedKernelIR` 中的 `IRNode` 已经创建，但视图只暴露 math 字段。输出形态**与现有架构完全一致**。

```json
{
  "kernel_name": "vec_add",
  "nodes": {
    "a": {
      "node_id": "a",
      "op_type": "input",
      "op_detail": {},
      "shape": [16],
      "input_nodes": [],
      "is_irregular_access": false,
      "csr_ref": null
    },
    "b": { /* math view */ },
    "c": {
      "node_id": "c",
      "op_type": "map",
      "op_detail": { "func": "add", "func_params": { "other_ref": "b" } },
      "shape": [16],
      "input_nodes": ["a", "b"],
      "is_irregular_access": false,
      "csr_ref": null
    }
  },
  "input_nodes": ["a", "b"],
  "output_nodes": ["c"],
  "target_metric": "throughput",
  "hw_constraint": "",
  "bram_bank_count": null
}
```

**关键差异**：底层数据已经是 `IRNode` 对象，只是 `data_type` 等字段保持默认值（`float64`、`None`、`1`）。没有发生 `MathNode → AlgoHWNode` 的实例转换。

---

### 2. AlgoHWDialect 视图（TemplateEngine 输出）

`TemplateEngine.render()` 不再构造新的节点类型，而是**直接修改 `UnifiedKernelIR` 中每个 `IRNode` 的字段**：

```python
for node in unified_ir.nodes.values():
    node.data_type = _resolve_dtype(node, quant_specs)
    node.approx_method = intent["approx_method"]
    node.parallelism = intent["parallelism"]
    node.saturation_guard = intent["enable_saturation"]
    node.stage = NodeStage.ALGO_HW
```

视图输出形态与现有架构一致：

```json
{
  "variant_id": "minimal_baseline",
  "parent_kernel_name": "vec_add",
  "nodes": {
    "a": {
      "node_id": "a",
      "op_type": "input",
      "op_detail": {},
      "shape": [16],
      "input_nodes": [],
      "is_irregular_access": false,
      "csr_ref": null,
      "data_type": "ap_int<8>",
      "approx_method": "spa_exact",
      "parallelism": 1,
      "saturation_guard": true,
      "quant_int_bits": 8,
      "quant_frac_bits": 0
    },
    "b": { /* algo-hw view */ },
    "c": { /* algo-hw view */ }
  },
  "intent_json": { /* DSE 意图 */ },
  "input_nodes": ["a", "b"],
  "output_nodes": ["c"],
  "estimated_dsp": 0,
  "estimated_bram": null
}
```

**关键差异**：
- 没有 `deepcopy` + 类型转换；`TemplateEngine` 原地修改 `IRNode`。
- 如果后续需要回退（例如 L3 失败，DSEAgent 想换 `approx_method`），直接覆盖 `node.approx_method` 即可，不需要重新构造节点。

---

### 3. HLSScheduleDialect 视图（RooflineSolver 输出）

`RooflineSolver.solve()` 同样原地修改 `IRNode`：

```python
for node in unified_ir.nodes.values():
    node.tile_size = self._compute_tile_size(node)
    node.unroll_factor = self._compute_unroll_factor(node)
    node.pipeline_ii = self._compute_pipeline_ii(node, node.unroll_factor)
    node.array_partition_type = self._compute_array_partition(node, node.unroll_factor)
    node.stage = NodeStage.SCHEDULE
```

视图输出形态与现有架构一致：

```json
{
  "variant_id": "minimal_baseline",
  "nodes": {
    "a": {
      "node_id": "a",
      "op_type": "input",
      "op_detail": {},
      "shape": [16],
      "input_nodes": [],
      "is_irregular_access": false,
      "csr_ref": null,
      "data_type": "ap_int<8>",
      "approx_method": "spa_exact",
      "parallelism": 1,
      "saturation_guard": true,
      "quant_int_bits": 8,
      "quant_frac_bits": 0,
      "tile_size": 131072,
      "unroll_factor": 1,
      "pipeline_ii": 16,
      "array_partition_type": "none",
      "bram_banks": 0,
      "address_mapping_code": null
    },
    "b": { /* schedule view */ },
    "c": { /* schedule view */ }
  },
  "input_nodes": ["a", "b"],
  "output_nodes": ["c"],
  "total_dsp_estimate": 0,
  "total_bram_estimate": 177,
  "expected_ii": 16
}
```

**关键差异**：
- `FeedbackLoop` 收到 L2 BRAM 超标的反馈后，想从 `SCHEDULE` 回退到 `ALGO_HW` 调低 `parallelism`，只需要：
  ```python
  node.parallelism = max(1, node.parallelism // 2)
  node.stage = NodeStage.ALGO_HW
  # 然后把 tile_size / unroll_factor 等 schedule 字段重置或留待重新计算
  ```
- 不需要做 `ScheduleNode → AlgoHWNode` 的向下转型，不会丢失任何信息。

---

## 两种架构的核心差异总结

| 维度 | 现有三层继承架构 | 扁平化统一 IR 架构 |
|------|------------------|---------------------|
| **节点类型** | `MathNode` → `AlgoHWNode` → `ScheduleNode`（3 个类） | 只有一个 `IRNode` 类 |
| **阶段转换** | 每阶段都要 `deepcopy` + 构造新类型实例 | 原地修改字段 + 更新 `stage` 标记 |
| **字段冗余** | 低层节点被迫携带高层默认值；高层节点被迫继承全部字段 | 所有节点共享同一 schema，未使用的字段保持默认值 |
| **视图隔离** | 通过 Python 继承类型系统“硬隔离” | 通过 `to_math_view()` / `to_algohw_view()` / `to_schedule_view()` 动态投影 |
| **回退/恢复** | 困难：需要向下转型并重新构造节点 | 简单：直接修改底层字段，视图自动反映最新状态 |
| **LLM Prompt 友好性** | 中等：LLM 需要理解三种不同 node 的 schema | 更好：LLM 只需要理解一个 `IRNode` schema，不同阶段只是字段子集不同 |
| **代码改动量** | — | `ir/` 下 4 个文件重构；`template_engine.py`、`roofline_solver.py`、`feedback/loop.py` 需要适配 |

---

## 对 FormaSyn 的额外好处：LLM 更容易理解统一 IR

在现有架构中，当 DSEAgent 或 CodegenAgent 需要“查看当前 IR 状态”时，我们必须决定序列化哪一层。在扁平化架构中，可以直接序列化底层 `UnifiedKernelIR`，并告诉 LLM：

> "`stage=MATH` 的字段是当前已确定的；`stage=ALGO_HW` 的字段正在探索；`stage=SCHEDULE` 的字段尚未确定。"

这让 LLM 对跨阶段反馈的理解更加直观，也避免了在 prompt 中解释 "`ScheduleNode` 继承自 `AlgoHWNode`" 这类实现细节。
