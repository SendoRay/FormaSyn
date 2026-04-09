# FormaSyn 项目重构与扩展计划

## 0. 重要参考文档

本计划基于以下文档制定：
- `docs/benchmark_suite.md` - 完整通信算法benchmark（40+ Tier1变体，20+ Tier2变体）
- `docs/communication_tiling_vs_image.md` - 通信领域Tiling问题深度分析
- `docs/dsl_extension_guide.md` - DSL算子扩展技术指南
- `docs/supported_kernels.py` - Kernel注册表（已定义200+变体）

---

## 1. 项目概述与目标

### 1.1 当前状态诊断

**根据benchmark分析，当前DSL覆盖情况：**
- **完全支持（✅）**: FIR系列、LDPC CNU、相关器、向量运算、BPSK/QPSK调制
  - 约40+变体，覆盖30-40%通信核心算法
- **需要简单扩展（⚠️）**: IIR、AGC、FFT、Viterbi
  - 需要FeedbackOp、ButterflyOp、TrellisOp
  - 约20+变体，可额外覆盖30-40%算法
- **需要复杂扩展（❌）**: MIMO检测、Polar SCL、PLL
  - 需要MatrixOp、SortOp、CORDIC

**核心问题**：
1. **DSL表达能力不足**: 5个算子无法支持IIR/FFT/Viterbi等核心算法
2. **伪DSE**: 硬编码`KERNEL_STRATEGIES`，非真正设计空间探索
3. **IR架构缺陷**: 三层继承违反组合优于继承原则
4. **LLM名不副实**: 90%代码来自fallback模板
5. **缺少--emit选项**: 用户明确要求导出中间结果

### 1.2 重构目标

**Tier 1目标**: 完全支持文档中定义的40+ Tier1变体
**Tier 2目标**: 通过新增算子支持Tier2算法（IIR/FFT/Viterbi）
**架构目标**: 扁平化IR、真正参数化DSE、诚实的代码生成

---

## 2. 详细重构任务

### Phase 1: DSL算子扩展（最高优先级）

根据 `dsl_extension_guide.md` 和 `benchmark_suite.md`，按ROI优先级扩展：

#### 2.1 FeedbackOp - 反馈算子 🔥 P0

**应用场景**: IIR滤波器、AGC、PLL/Costas环、自适应滤波器

**数学形式**: `y[n] = f(x[n], y[n-1], y[n-2], ...)`

**DSL设计**:
```python
@dataclass
class FeedbackOp(OpBase):
    input_ref: str
    feedback_refs: List[str]          # 反馈信号 (y[n-1], y[n-2]...)
    forward_func: str                 # 前向函数
    feedback_coeffs: List[float]      # 反馈系数
    forward_coeffs: List[float]       # 前向系数
    output: str
    order: int = 1                    # 反馈阶数
```

**支持的Kernels**:
- `iir_biquad` - IIR二阶节（4 variants）
- `iir_dc_blocker` - 一阶高通（2 variants）
- `agc_loop` - 自动增益控制（2 variants）
- `pll_carrier_recovery` - 载波同步（2 variants）

**实现复杂度**: IR需支持循环依赖检测，代码生成标准IIR结构

**文件影响**:
- `formasyn/dsl/operators.py` - 新增FeedbackOp
- `formasyn/dsl/parser.py` - 处理循环依赖
- `formasyn/ir/math_dialect.py` - 支持feedback边标记
- `formasyn/templates/iir_template.py` - IIR代码模板

---

#### 2.2 ButterflyOp - 蝶形算子 🔥 P0

**应用场景**: FFT/IFFT、DCT、快速多项式乘法

**数学形式**: 
```
Radix-2 DIT Butterfly:
  Y0 = X0 + W·X1
  Y1 = X0 - W·X1
```

**DSL设计**:
```python
@dataclass
class ButterflyOp(OpBase):
    x0_ref: str
    x1_ref: str
    twiddle_ref: str      # 旋转因子W
    radix: int = 2        # 2或4
    mode: str = "dit"     # DIT或DIF
    outputs: List[str]
    twiddle_width: int = 16

@dataclass  
class FFTStageOp(OpBase):
    """FFT阶段抽象 - 比单个butterfly更高层"""
    input_ref: str
    size: int             # FFT点数
    stage: int            # 当前阶段
    inverse: bool = False
    output: str
```

**支持的Kernels**:
- `fft_radix2` - 64/128/256/512/1024/2048点FFT（18 variants）
- `ifft_radix2` - 逆FFT（18 variants）
- `ofdm_fft` - OFDM处理（6 variants）

**实现策略**:
1. **方案A**: 映射到Xilinx FFT IP（推荐，性能好）
2. **方案B**: HLS蝶形网络（更灵活）

**文件影响**:
- `formasyn/dsl/operators.py` - 新增ButterflyOp/FFTStageOp
- `formasyn/templates/fft_ip_template.py` - Xilinx IP配置
- `formasyn/templates/fft_hls_template.py` - HLS蝶形实现

---

#### 2.3 ComplexOp - 复数运算算子 🔥 P0

**应用场景**: 复数FIR、复数相关、OFDM、复数均衡

**DSL设计**:
```python
@dataclass
class ComplexMapOp(OpBase):
    input_ref: str
    func: str  # "multiply", "add", "conjugate", "magnitude", "multiply_conj"
    operand_ref: Optional[str] = None
    output: str

@dataclass
class ComplexReduceOp(OpBase):
    input_ref: str
    op: str  # "add", "mul"
    domain: Domain
    output: str
```

**支持的Kernels**:
- `correlator_complex` - 复数相关（12 variants）
- `complex_fir` - 复数FIR滤波（20 variants）
- `ofdm_demod` - OFDM解调（6 variants）

**硬件实现**: 复数乘法 = 4个实数乘法（或3个Karatsuba）
- 小位宽(<12-bit): LUT实现
- 中位宽(12-18-bit): 3-4个DSP48
- 大位宽: Karatsuba减少DSP

**文件影响**:
- `formasyn/dsl/operators.py` - 新增ComplexOp
- `formasyn/templates/complex_ops_template.py` - 复数运算模板

---

#### 2.4 TrellisOp - 网格图算子 🔥 P1

**应用场景**: Viterbi译码、Turbo译码(BCJR)、卷积编码

**DSL设计**:
```python
@dataclass
class TrellisOp(OpBase):
    input_ref: str
    num_states: int           # 状态数 (64 for K=7)
    num_inputs: int           # 输入比特数
    num_outputs: int          # 输出比特数
    algorithm: str            # "viterbi", "bcjr", "map"
    generator_polynomials: List[int]
    traceback_depth: int = 64
    iterations: int = 8       # BCJR特有
    output: str
```

**支持的Kernels**:
- `viterbi_decoder_k7` - K=7 Viterbi（2 variants）
- `viterbi_decoder_k9` - K=9 Viterbi（2 variants）
- `turbo_siso` - Turbo SISO（2 variants）

**硬件挑战**: ACS(Add-Compare-Select)递归，状态数并行，布线拥塞

**文件影响**:
- `formasyn/dsl/operators.py` - 新增TrellisOp
- `formasyn/templates/viterbi_template.py` - ACS单元生成

---

#### 2.5 InterleaveOp - 交织算子 🔥 P1

**应用场景**: 信道交织、Turbo交织、块交织/解交织

**DSL设计**:
```python
@dataclass
class InterleaveOp(OpBase):
    input_ref: str
    pattern: str  # "block", "convolutional", "qpp"
    rows: Optional[int] = None
    cols: Optional[int] = None
    k: Optional[int] = None       # QPP参数
    f1: Optional[int] = None
    f2: Optional[int] = None
    direction: str = "interleave"
    output: str
```

**支持的Kernels**:
- `block_interleaver` - WiFi块交织（6 variants）
- `qpp_interleaver` - LTE Turbo QPP（4 variants）

**硬件实现**: 双端口RAM + 地址生成器

**文件影响**:
- `formasyn/dsl/operators.py` - 新增InterleaveOp
- `formasyn/templates/interleaver_template.py`

---

#### 2.6 扩展后的完整算子列表

| 算子 | 类别 | 优先级 | 覆盖Kernels |
|------|------|--------|-------------|
| `MapOp` | 基础 | ✅已有 | FIR, 向量运算 |
| `ReduceOp` | 基础 | ✅已有 | FIR, LDPC, 相关器 |
| `ShiftRegOp` | 基础 | ✅已有 | FIR, 相关器 |
| `DelayOp` | 基础 | ✅已有 | 延迟线 |
| `MessagePassOp` | 图 | ✅已有 | LDPC |
| `FeedbackOp` | 反馈 | 🔥P0 | IIR, AGC, PLL |
| `ButterflyOp` | 变换 | 🔥P0 | FFT, OFDM |
| `FFTStageOp` | 变换 | 🔥P0 | FFT batch处理 |
| `ComplexMapOp` | 复数 | 🔥P0 | 复数FIR, OFDM |
| `ComplexReduceOp` | 复数 | 🔥P0 | 复数相关 |
| `TrellisOp` | 网格 | P1 | Viterbi, Turbo |
| `InterleaveOp` | 存储 | P1 | 交织器 |
| `CordicOp` | 旋转 | P2 | PLL, 相位恢复 |
| `SortOp` | 排序 | P2 | Polar SCL, MIMO |
| `MatrixOp` | 矩阵 | P2 | MIMO检测 |

**扩展后覆盖率**: 从30-40%提升到80-90%的5G/WiFi基带处理

---

### Phase 2: IR架构重构（核心基础）

#### 2.7 扁平化IR改造 🔥 P0

**问题**: 当前三层继承(MathNode→AlgoHWNode→ScheduleNode)违反组合优于继承

**解决方案**: 统一IRNode + 属性标注

```python
@dataclass
class IRNode:
    """统一的中间表示节点"""
    node_id: str
    op_type: str
    op_detail: dict
    
    # 数学层属性
    shape: list[int]
    input_nodes: list[str]
    is_irregular_access: bool = False
    csr_ref: Optional[str] = None
    
    # Algo-HW层属性
    data_type: str = ""
    approx_method: str = ""
    parallelism: int = 1
    saturation_guard: bool = False
    quant_int_bits: int = 8
    quant_frac_bits: int = 0
    
    # Schedule层属性
    tile_size: Optional[int] = None
    unroll_factor: int = 1
    pipeline_ii: int = 1
    array_partition_type: str = "none"
    bram_banks: int = 0
    address_mapping_code: Optional[str] = None
    
    # 阶段标记
    stage: IRStage = IRStage.MATH

class IRStage(Enum):
    MATH = "math"
    ALGO_HW = "algo_hw"
    SCHEDULE = "schedule"

@dataclass
class UnifiedIR:
    """统一的IR容器"""
    variant_id: str
    kernel_name: str
    nodes: dict[str, IRNode]
    input_nodes: list[str]
    output_nodes: list[str]
    edges: list[tuple[str, str]]  # 显式边，支持反馈
    
    # 各层视图
    def as_math_view(self) -> MathView: ...
    def as_algo_hw_view(self) -> AlgoHWView: ...
    def as_schedule_view(self) -> ScheduleView: ...
```

**文件影响**:
- `formasyn/ir/unified_ir.py` - 新增统一IR
- `formasyn/ir/views.py` - 各层视图
- `formasyn/ir/math_dialect.py` - 改为视图包装器
- `formasyn/ir/algo_hw_dialect.py` - 改为视图包装器
- `formasyn/ir/schedule_dialect.py` - 改为视图包装器

**迁移策略**: 逐步替换，保持向后兼容（临时wrapper）

---

### Phase 3: DSE系统重构

#### 2.8 真正的参数化DSE 🔥 P0

**问题**: 当前硬编码`KERNEL_STRATEGIES`，非真正探索

**新设计**: 基于算法结构的动态搜索

```python
@dataclass
class DesignSpace:
    """设计空间定义 - 由算法结构推导"""
    # 算法参数空间（Layer 1）
    approx_methods: list[str]
    precision_range: tuple[int, int]
    
    # 架构参数空间（Layer 2）
    parallelism_candidates: list[int]  # 由算法结构推导
    architecture_templates: list[str]  # ["systolic", "dot_product", "blocked"]
    memory_strategies: list[str]       # ["cyclic", "layered", "fifo"]
    
    # 约束
    resource_budget: ResourceBudget
    quality_target: QualityTarget

class DSEngine:
    """真正的设计空间搜索引擎"""
    
    def analyze_algorithm(self, math_ir: UnifiedIR) -> AlgorithmCharacteristics:
        """分析算法结构，推导可行配置"""
        return AlgorithmCharacteristics(
            max_parallelism=self._compute_max_parallelism(math_ir),
            feasible_templates=self._select_templates(math_ir),
            memory_access_pattern=self._analyze_access_pattern(math_ir),
        )
    
    def generate_candidates(
        self, 
        characteristics: AlgorithmCharacteristics,
        space: DesignSpace
    ) -> Iterator[IntentJSON]:
        """生成帕累托前沿候选"""
        # 1. 算法层（approx/quant）- 2~4个变体
        for approx in space.approx_methods:
            for bits in self._quant_candidates(space.precision_range):
                # 2. 硬件层（parallelism/memory）- 由算法特征约束
                for para in characteristics.feasible_parallelism:
                    for mem in characteristics.feasible_strategies:
                        yield IntentJSON(
                            variant_name=f"{approx}_b{bits}_p{para}_{mem}",
                            approx_method=approx,
                            parallelism=para,
                            memory_strategy=mem,
                            quant_overrides={...},
                        )
    
    def prune_candidates(
        self, 
        candidates: list[IntentJSON]
    ) -> list[IntentJSON]:
        """轻量级剪枝 - 在HLS前过滤"""
        valid = []
        for c in candidates:
            # Bank conflict快速分析
            if self._has_bank_conflict(c):
                continue
            # BRAM容量快速估算
            if self._estimate_bram(c) > self.budget.bram:
                continue
            valid.append(c)
        return valid
```

**关键创新**: 
1. **分层搜索**: 算法层（Layer1）和硬件层（Layer2）解耦
2. **Kernel-aware剪枝**: 根据kernel_type约束有效空间
3. **物理模型前置**: Bank conflict、图着色、BRAM估算在HLS前剪枝

**文件影响**:
- `formasyn/solver/design_space.py` - 设计空间定义
- `formasyn/solver/search_engine.py` - 搜索引擎
- `formasyn/solver/pruning_models.py` - 剪枝模型
- `formasyn/agent/dse_agent.py` - 重写，调用DSEngine

---

### Phase 4: 代码生成与验证

#### 2.9 Codegen诚实化改造 🔥 P0

**决策**: 选择**纯模板路线**（诚实但可靠）

**理由**:
1. LLM代码生成已被证明不可靠（高失败率）
2. 通信算法有成熟的模板模式
3. 易于验证和优化
4. 学术诚实 - 不夸大"AI驱动"

**新架构**:
```python
class TemplateRegistry:
    """模板注册表 - 算子+架构到代码模板的映射"""
    
    TEMPLATES = {
        # (op_type, arch_template) -> TemplateClass
        ("fir", "dot_product_tree"): FIRDotProductTemplate,
        ("fir", "systolic"): FIRSystolicTemplate,
        ("fir", "blocked"): FIRBlockedTemplate,
        ("fft", "pipeline"): FFTPipelineTemplate,
        ("fft", "ip_core"): FFTIPCoreTemplate,
        ("ldpc", "layered"): LDPCLayeredTemplate,
        ("iir", "direct_form_ii"): IIRDirectFormTemplate,
    }
    
    @classmethod
    def get_template(cls, op_type: str, arch: str) -> CodegenTemplate:
        return cls.TEMPLATES.get((op_type, arch))

class CodegenTemplate(ABC):
    """代码生成模板基类"""
    
    @abstractmethod
    def generate(self, schedule: ScheduleView) -> CodegenArtifacts:
        """确定性代码生成"""
        pass
    
    @abstractmethod
    def estimate_resource(self, schedule: ScheduleView) -> ResourceEstimate:
        """资源估算"""
        pass

# LLM仅用于架构建议
class ArchitectureAdvisor:
    """LLM辅助架构选择（非代码生成）"""
    
    def recommend_architecture(
        self, 
        math_ir: UnifiedIR,
        constraints: HardwareConstraints
    ) -> list[tuple[str, float]]:
        """返回架构建议列表 [(arch_name, confidence), ...]"""
        # 调用LLM分析算法特征
        # 返回推荐架构，不生成代码
```

**文件影响**:
- `formasyn/templates/base_template.py` - 模板基类
- `formasyn/templates/fir_templates.py` - FIR模板族
- `formasyn/templates/fft_templates.py` - FFT模板
- `formasyn/templates/ldpc_templates.py` - LDPC模板
- `formasyn/templates/iir_templates.py` - IIR模板
- `formasyn/agent/architecture_advisor.py` - 架构建议Agent
- `formasyn/agent/codegen_agent.py` - 重写为模板调度

---

#### 2.10 添加 --emit 选项支持 🔥 P0

**用户需求**: 导出中间结果到指定目录

**设计**:
```python
# run.py 新增参数
parser.add_argument(
    "--emit",
    type=str,
    default=None,
    help="导出中间结果到指定目录"
)
parser.add_argument(
    "--emit-stages",
    type=str,
    default="all",
    help="导出的阶段: math,algo_hw,schedule,code,golden,all"
)
parser.add_argument(
    "--emit-format",
    type=str,
    default="yaml",
    choices=["yaml", "json"],
    help="导出格式"
)

# 导出结构
{emit_dir}/
└── {example_name}_{timestamp}/
    ├── 00_config/               # 配置
    │   ├── constraints.yaml
    │   └── architecture_hint.yaml
    ├── 01_math_ir/              # Math Dialect
    │   ├── ir.yaml
    │   └── graph.dot           # 可视化
    ├── 02_quant_analysis/       # 量化分析
    │   ├── quant_specs.yaml
    │   └── dynamic_range_report.txt
    ├── 03_intents/              # DSE生成的变体意图
    │   ├── intent_0.yaml
    │   ├── intent_1.yaml
    │   └── ...
    ├── 04_algo_hw/              # Algo-HW IR
    │   └── variants/
    │       ├── variant_0/
    │       │   └── ir.yaml
    │       └── ...
    ├── 05_schedule/             # Schedule IR
    │   └── variants/
    │       ├── variant_0/
    │       │   └── ir.yaml
    │       │   └── roofline_report.txt
    │       └── ...
    ├── 06_codegen/              # 生成的代码
    │   └── variants/
    │       ├── variant_0/
    │       │   ├── kernel.cpp
    │       │   ├── kernel.h
    │       │   └── metadata.json
    │       └── ...
    ├── 07_golden/               # 黄金参考模型
    │   ├── golden.cpp
    │   ├── golden.h
    │   └── test_vectors.yaml
    ├── 08_verification/         # 验证结果
    │   └── variant_0/
    │       ├── l1_result.yaml
    │       ├── l2_result.yaml
    │       └── l3_result.yaml
    └── summary.yaml             # 汇总报告
```

**文件影响**:
- `run.py` - 新增参数
- `formasyn/utils/emitter.py` - 导出工具
- `formasyn/utils/ir_serializer.py` - IR序列化

---

#### 2.11 验证层严谨化改造 P1

根据 `benchmark_suite.md` 要求，每个kernel验证：
1. **功能正确性**: 与浮点参考模型对比
2. **数值精度**: NMSE < -60 dB
3. **资源使用**: DSP、BRAM、LUT在预算内
4. **时序收敛**: 目标频率达标
5. **吞吐量**: 样本/秒满足系统要求

**改进**:
```python
@dataclass
class MetricDefinition:
    name: str
    formula: str  # LaTeX
    unit: str
    threshold: float
    statistical_requirement: str  # "n>=1000 for 95% CI"

class StatisticalValidator:
    """统计验证器"""
    
    def compute_confidence_interval(
        self,
        measurements: list[float],
        confidence: float = 0.95
    ) -> tuple[float, float, float]:  # (mean, std, margin_of_error)
        pass
    
    def validate_ber_curve(
        self,
        ber_measurements: list[tuple[float, float]]  # [(snr, ber), ...]
    ) -> BERValidationResult:
        """验证BER曲线是否符合理论预期"""
        pass
```

**文件影响**:
- `formasyn/checker/metrics.py` - 扩展指标定义
- `formasyn/checker/statistical.py` - 统计工具

---

### Phase 5: 工程质量

#### 2.12 全局硬编码清理 P0

**清理清单**（从代码分析中提取）:

| 文件 | 行号 | 当前硬编码 | 改为 |
|------|------|-----------|------|
| dse_agent.py | 182 | `max_variants=6` | 从constraints.yaml读取 |
| dse_agent.py | 246 | `temperature=0.4` | 配置文件 |
| dse_agent.py | 247 | `timeout=60.0` | 配置文件 |
| codegen_agent.py | 99 | `timeout=10.0` | 配置文件 |
| template_engine.py | 526 | `return 4, 12` | 量化分析器决定 |
| roofline_solver.py | 97 | `bram_kb=4096` | 从constraints读取 |
| l1_checker.py | 192 | `timeout=600` | 配置文件 |
| run.py | 349 | `max_variants=4` | 配置或DSEngine决定 |

**文件影响**:
- `config.yaml` - 扩展配置项
- `formasyn/config.py` - 配置管理模块

---

#### 2.13 通信领域Tiling优化 P1

根据 `communication_tiling_vs_image.md`，实现通信特有的Tiling策略：

```python
class CommunicationTilingStrategy:
    """通信领域Tiling策略"""
    
    def optimize_filtering(
        self,
        window_size: int,
        stride: int,
        parallelism: int,
        bank_count: int
    ) -> TilingConfig:
        """滑动窗口Bank对齐"""
        # cyclic partition factor选择
        # 避免bank conflict
        pass
    
    def optimize_ldpc(
        self,
        csr_matrix: CSRMatrix,
        parallelism: int
    ) -> LayeredSchedule:
        """LDPC图分层调度"""
        # 基于Tanner图的layered scheduling
        # graph coloring
        pass
    
    def optimize_fft(
        self,
        fft_size: int,
        twiddle_access_pattern: list
    ) -> BankPermutation:
        """FFT旋转因子Bank重排"""
        pass
```

**文件影响**:
- `formasyn/solver/tiling/communication_tiling.py`
- `formasyn/solver/tiling/graph_coloring.py`
- `formasyn/solver/tiling/bank_conflict_analyzer.py`

---

## 3. 实施计划

### Phase 1: 基础架构（Week 1-2）
- [ ] 2.7 扁平化IR改造
- [ ] 2.12 硬编码清理
- [ ] 2.10 --emit选项支持
- [ ] 更新文档诚实化

### Phase 2: DSL扩展（Week 3-4）
- [ ] 2.1 FeedbackOp + IIR模板
- [ ] 2.2 ButterflyOp + FFT模板
- [ ] 2.3 ComplexOp
- [ ] 更新Parser支持新算子

### Phase 3: DSE重构（Week 5-6）
- [ ] 2.8 真正参数化DSE
- [ ] 2.9 Codegen诚实化改造
- [ ] 2.13 通信Tiling优化

### Phase 4: 验证与测试（Week 7-8）
- [ ] 2.11 验证层严谨化
- [ ] 完整Benchmark测试
- [ ] 性能评估

---

## 4. Benchmark支持路线图

### Tier 1: 当前DSL完全支持（Phase 1完成即支持）
```
✅ fir_direct: 80 variants (taps x bitwidth x parallelism)
✅ fir_halfband: 40 variants
✅ fir_rrc: 72 variants
✅ ldpc_cnu: 280 variants (dc x bitwidth x parallelism x approx)
✅ correlator_real: 60 variants
✅ correlator_complex: 24 variants
✅ vec_add: 120 variants
✅ vec_mac: 48 variants
✅ modem_bpsk_qpsk: 12 variants

Total: ~736 variants
```

### Tier 2: 新增算子后支持（Phase 2完成即支持）
```
🔥 iir_biquad: 4 variants (需要FeedbackOp)
🔥 agc_loop: 2 variants (需要FeedbackOp)
🔥 fft_radix2: 18 variants (需要ButterflyOp)
🔥 ifft_radix2: 18 variants
🔥 complex_fir: 20 variants (需要ComplexOp)
⚠️ viterbi_k7: 2 variants (需要TrellisOp)
⚠️ block_interleaver: 6 variants (需要InterleaveOp)

Total: ~70 additional variants
```

### Tier 3: 未来工作
```
❌ mimo_mmse: 需要MatrixOp
❌ polar_scl: 需要SortOp
❌ pll_carrier: 需要FeedbackOp + CORDIC
```

---

## 5. 决策点（需要您确认）

### 决策1: DSL扩展范围
**选项A**: 仅实现P0算子（FeedbackOp + ButterflyOp + ComplexOp）
- 支持Tier2核心算法（IIR/FFT/复数运算）
- 覆盖率达到70-80%

**选项B**: 实现P0+P1算子（额外+TrellisOp + InterleaveOp）
- 额外支持Viterbi/Turbo/交织器
- 覆盖率达到85-90%

**建议**: B（投入产出比高，Viterbi是WiFi/GSM核心）

### 决策2: FFT实现策略
**选项A**: 映射到Xilinx FFT IP
- 性能好，资源优化
- 灵活性低

**选项B**: HLS蝶形网络实现
- 灵活性高，可定制
- 性能可能不如IP

**建议**: 两者都支持，通过architecture_hint选择

### 决策3: 重构节奏
**选项A**: 一次性大重构（8周完整计划）
- 架构一致性好
- 风险高，无法及时验证

**选项B**: 渐进式重构（每2周一个可验证里程碑）
- Phase1完成即可运行现有kernels
- Phase2完成即可支持新算法

**建议**: B

### 决策4: Codegen路线
**选项A**: 纯模板（诚实可靠）
- 技术路线清晰
- 学术贡献度较低

**选项B**: 模板为主 + LLM辅助优化
- LLM用于：参数微调、边界情况处理
- 保持可靠性同时有AI元素

**建议**: B（平衡可靠性和学术价值）

---

## 6. 成功标准

### 重构完成后应满足

**功能性**:
- [ ] `python run.py fir_16tap --emit ./temp` 成功导出所有中间结果
- [ ] `python run.py iir_biquad` 新算子正常工作
- [ ] `python run.py fft_1024` FFT正常工作
- [ ] 支持docs中定义的所有Tier1 kernels

**性能**:
- [ ] DSE搜索空间比原来扩大10倍但收敛时间相同（剪枝有效）
- [ ] 代码生成100%可靠（无LLM失败fallback）

**质量**:
- [ ] `pytest formasyn/tests/` 通过率>95%
- [ ] 代码覆盖率>80%
- [ ] 所有硬编码魔法数字消除

**学术**:
- [ ] 文档诚实描述系统能力和局限
- [ ] Benchmark结果可复现
- [ ] 新增算法仅需DSL定义，无需修改编译器核心

---

*计划更新日期: 2026-04-02*
*基于完整benchmark文档分析*
