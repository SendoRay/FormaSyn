
› 1，code gen 应该是 llm agent 生成的 ， 应该是 agent 读懂我们生成的 schedule dialect ，然后去生成对应的hlscpp 文件。    所以这个codegen.py 应该是放在 agent 文件夹下面，然后你可以参照类似
  def __init__(
          self,
          model: str = "claude-sonnet-4-5-20250929",
          max_variants: int = 8,
      ) -> None:
          self._model = model
          self._max_variants = max_variants
          self._client = OpenAI(
              api_key="sk-fgiM17i17hA5lYtIhuPf9MGMkEN27dJA4SVE2CsXWxtNovU4",
              base_url="https://api.tryallai.com/v1",
          )
   的写法 你可以去找https://s.apifox.cn/ec36f88d-4e3d-4790-98e5-c1532253c7fb/318221937e0 这个网站 找到具体的写法  然后 所以  HLSCodeGenerator 就不要了  应该删掉，然后你再把逻辑整个补充清楚，比如 run.py    和 readme

2，当前 run.py 默认不会把最终 .cpp/.h 持久化到工程目录，而是把生成字符串直接喂给 checker（checker 里会写临时文件去仿真/综合）  你应该加一个选项，就是比如--emit 就可以把整个的运行过程的中间结果（主要是 golden model， test data，以及不同的 dialect 和生成的 hlscpp 文件）输出到 FormaSyn/temp/xx_kernel 下面




我运行python run.py fir_16tap
==> [1/5] 解析算法 fir_16tap 到 Math Dialect ...
INFO FormaSyn.dsl.parser: Parsed FormulaGraph 'fir_16tap' → MathDialect with 4 nodes
==> [2/5] 生成黄金参考模型并分析量化参数 ...
INFO FormaSyn.golden.generator: Generated golden C++ for 'fir_16tap' (39 lines)
INFO FormaSyn.golden.generator: Generated golden C++ for 'fir_16tap' (39 lines)
INFO FormaSyn.golden.quant_analyzer: Quantisation analysis complete for 'fir_16tap': 1 output nodes analysed over 100 trials
==> [3/5] 调用 LLM 生成硬件变体意图 ...
==> [4/5] 编译并验证各变体（L1/L2/L3 + feedback）...
INFO FormaSyn.agent.dse_agent: 调用 LLM 生成变体意图 (model=claude-sonnet-4-5-20250929, kernel=fir_16tap)
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
INFO FormaSyn.agent.dse_agent: 成功解析 8 个变体意图 (kernel=fir_16tap)
    Round 1: 生成 8 个变体
INFO FormaSyn.dsl.template_engine: Rendered variant 'baseline_int16_p16_full' (approx=min_sum, parallelism=16, nodes=5, dsp≈32)
INFO FormaSyn.solver.roofline_solver: Roofline solved baseline_int16_p16_full: DSP=0  BRAM=26  II=1
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'baseline_int16_p16_full' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [baseline_int16_p16_full]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] baseline_int16_p16_full  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'dsp_optimal_int8_p16' (approx=min_sum, parallelism=16, nodes=5, dsp≈32)
INFO FormaSyn.solver.roofline_solver: Roofline solved dsp_optimal_int8_p16: DSP=0  BRAM=24  II=1
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'dsp_optimal_int8_p16' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [dsp_optimal_int8_p16]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] dsp_optimal_int8_p16  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'balanced_int10_p8' (approx=offset_min_sum, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved balanced_int10_p8: DSP=0  BRAM=16  II=2
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'balanced_int10_p8' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [balanced_int10_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] balanced_int10_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'low_resource_int8_p4' (approx=normalized_min_sum, parallelism=4, nodes=5, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved low_resource_int8_p4: DSP=0  BRAM=24  II=4
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'low_resource_int8_p4' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [low_resource_int8_p4]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] low_resource_int8_p4  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'high_precision_int12_p8' (approx=offset_min_sum, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved high_precision_int12_p8: DSP=0  BRAM=17  II=2
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'high_precision_int12_p8' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [high_precision_int12_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] high_precision_int12_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'area_minimal_int6_p2' (approx=normalized_min_sum, parallelism=2, nodes=5, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved area_minimal_int6_p2: DSP=0  BRAM=27  II=8
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'area_minimal_int6_p2' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [area_minimal_int6_p2]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] area_minimal_int6_p2  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'recommended_int9_p8' (approx=offset_min_sum, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved recommended_int9_p8: DSP=0  BRAM=16  II=2
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'recommended_int9_p8' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [recommended_int9_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] recommended_int9_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'clock_optimized_int8_p8' (approx=min_sum, parallelism=8, nodes=5, dsp≈16)
INFO FormaSyn.solver.roofline_solver: Roofline solved clock_optimized_int8_p8: DSP=0  BRAM=24  II=2
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'clock_optimized_int8_p8' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [clock_optimized_int8_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] clock_optimized_int8_p8  stage=L1  metrics={}
    [DEEP] 进入第 1 轮反馈迭代，失败样本=8
INFO FormaSyn.agent.dse_agent: 调用 LLM 生成变体意图 (model=claude-sonnet-4-5-20250929, kernel=fir_16tap)
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
INFO FormaSyn.agent.dse_agent: 成功解析 8 个变体意图 (kernel=fir_16tap)
    Round 2: 生成 8 个变体
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_baseline_int16_p1' (approx=spa_exact, parallelism=1, nodes=4, dsp≈1)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_baseline_int16_p1: DSP=0  BRAM=18  II=16
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_baseline_int16_p1' (46 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_baseline_int16_p1]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_baseline_int16_p1  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_dsp_fit_int16_p2' (approx=spa_exact, parallelism=2, nodes=4, dsp≈2)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_dsp_fit_int16_p2: DSP=0  BRAM=18  II=8
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_dsp_fit_int16_p2' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_dsp_fit_int16_p2]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_dsp_fit_int16_p2  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_recommended_int9_p4' (approx=spa_exact, parallelism=4, nodes=4, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_recommended_int9_p4: DSP=0  BRAM=19  II=4
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_recommended_int9_p4' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_recommended_int9_p4]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_recommended_int9_p4  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_low_dsp_int8_p8' (approx=spa_exact, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_low_dsp_int8_p8: DSP=0  BRAM=18  II=2
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_low_dsp_int8_p8' (47 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_low_dsp_int8_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_low_dsp_int8_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_high_throughput_int10_p16' (approx=spa_exact, parallelism=16, nodes=4, dsp≈16)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_high_throughput_int10_p16: DSP=0  BRAM=15  II=1
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_high_throughput_int10_p16' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_high_throughput_int10_p16]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_high_throughput_int10_p16  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_minimal_int6_p1' (approx=spa_exact, parallelism=1, nodes=4, dsp≈1)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_minimal_int6_p1: DSP=0  BRAM=16  II=16
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_minimal_int6_p1' (46 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_minimal_int6_p1]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_minimal_int6_p1  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_balanced_int12_p4' (approx=spa_exact, parallelism=4, nodes=4, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_balanced_int12_p4: DSP=0  BRAM=16  II=4
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_balanced_int12_p4' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_balanced_int12_p4]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_balanced_int12_p4  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_clock_safe_int8_p2' (approx=spa_exact, parallelism=2, nodes=4, dsp≈2)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_clock_safe_int8_p2: DSP=0  BRAM=18  II=8
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_clock_safe_int8_p2' (47 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_clock_safe_int8_p2]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_clock_safe_int8_p2  stage=L1  metrics={}
    [DEEP] 进入第 2 轮反馈迭代，失败样本=8
INFO FormaSyn.agent.dse_agent: 调用 LLM 生成变体意图 (model=claude-sonnet-4-5-20250929, kernel=fir_16tap)
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
INFO FormaSyn.agent.dse_agent: 成功解析 8 个变体意图 (kernel=fir_16tap)
    Round 3: 生成 8 个变体
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_spa_int16_p16' (approx=spa_exact, parallelism=16, nodes=4, dsp≈16)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_spa_int16_p16: DSP=0  BRAM=18  II=1
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_spa_int16_p16' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_spa_int16_p16]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_spa_int16_p16  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_minsum_int12_p8' (approx=min_sum, parallelism=8, nodes=5, dsp≈16)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_minsum_int12_p8: DSP=0  BRAM=24  II=2
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_minsum_int12_p8' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_minsum_int12_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_minsum_int12_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_offset_int10_p4' (approx=offset_min_sum, parallelism=4, nodes=4, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_offset_int10_p4: DSP=0  BRAM=15  II=4
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_offset_int10_p4' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_offset_int10_p4]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_offset_int10_p4  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_normalized_int8_p16' (approx=normalized_min_sum, parallelism=16, nodes=5, dsp≈32)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_normalized_int8_p16: DSP=0  BRAM=26  II=1
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_normalized_int8_p16' (54 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_normalized_int8_p16]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_normalized_int8_p16  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_lut_int14_p8' (approx=lut_tanh, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_lut_int14_p8: DSP=0  BRAM=17  II=2
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_lut_int14_p8' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_lut_int14_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_lut_int14_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_spa_int13_p4' (approx=spa_exact, parallelism=4, nodes=4, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_spa_int13_p4: DSP=0  BRAM=16  II=4
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_spa_int13_p4' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_spa_int13_p4]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_spa_int13_p4  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_minsum_int15_p2' (approx=min_sum, parallelism=2, nodes=5, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_minsum_int15_p2: DSP=0  BRAM=25  II=8
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_minsum_int15_p2' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_minsum_int15_p2]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_minsum_int15_p2  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_offset_int11_p16' (approx=offset_min_sum, parallelism=16, nodes=4, dsp≈16)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_offset_int11_p16: DSP=0  BRAM=16  II=1
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_offset_int11_p16' (48 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_offset_int11_p16]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_offset_int11_p16  stage=L1  metrics={}
    [DEEP] 进入第 3 轮反馈迭代，失败样本=8
INFO FormaSyn.agent.dse_agent: 调用 LLM 生成变体意图 (model=claude-sonnet-4-5-20250929, kernel=fir_16tap)
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
INFO FormaSyn.agent.dse_agent: 成功解析 8 个变体意图 (kernel=fir_16tap)
    Round 4: 生成 8 个变体
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_basic_int16_p1' (approx=min_sum, parallelism=1, nodes=5, dsp≈2)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_basic_int16_p1: DSP=0  BRAM=26  II=16
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_basic_int16_p1' (53 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_basic_int16_p1]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_basic_int16_p1  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_recommended_int16_p2' (approx=min_sum, parallelism=2, nodes=5, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_recommended_int16_p2: DSP=0  BRAM=26  II=8
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_recommended_int16_p2' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_recommended_int16_p2]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_recommended_int16_p2  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_dsp_safe_int12_p4' (approx=min_sum, parallelism=4, nodes=5, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_dsp_safe_int12_p4: DSP=0  BRAM=24  II=4
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_dsp_safe_int12_p4' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_dsp_safe_int12_p4]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_dsp_safe_int12_p4  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_minimal_int8_p1' (approx=min_sum, parallelism=1, nodes=5, dsp≈2)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_minimal_int8_p1: DSP=0  BRAM=26  II=16
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_minimal_int8_p1' (52 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_minimal_int8_p1]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_minimal_int8_p1  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_throughput_int10_p8' (approx=min_sum, parallelism=8, nodes=5, dsp≈16)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_throughput_int10_p8: DSP=0  BRAM=23  II=2
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_throughput_int10_p8' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_throughput_int10_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_throughput_int10_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_balanced_int14_p2' (approx=min_sum, parallelism=2, nodes=5, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_balanced_int14_p2: DSP=0  BRAM=25  II=8
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_balanced_int14_p2' (55 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_balanced_int14_p2]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_balanced_int14_p2  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_high_throughput_int8_p16' (approx=min_sum, parallelism=16, nodes=5, dsp≈32)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_high_throughput_int8_p16: DSP=0  BRAM=26  II=1
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_high_throughput_int8_p16' (54 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_high_throughput_int8_p16]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_high_throughput_int8_p16  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_conservative_int15_p1' (approx=min_sum, parallelism=1, nodes=5, dsp≈2)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_conservative_int15_p1: DSP=0  BRAM=25  II=16
INFO FormaSyn.codegen.hls_codegen: Generated HLS C++ for variant 'fir_conservative_int15_p1' (53 lines)
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_conservative_int15_p1]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_conservative_int15_p1  stage=L1  metrics={}

==> [5/5] 完成：0/32 个变体通过（rounds=4）
    没有变体通过验证，请检查约束或调整参数
chengzhy@h3c-chengzhy:~/FormaSyn$ vim ~/.codex/config.toml
chengzhy@h3c-chengzhy:~/FormaSyn$ python run.py fir_16tap
==> [1/5] 解析算法 fir_16tap 到 Math Dialect ...
INFO FormaSyn.dsl.parser: Parsed FormulaGraph 'fir_16tap' → MathDialect with 4 nodes
==> [2/5] 生成黄金参考模型并分析量化参数 ...
INFO FormaSyn.golden.generator: Generated golden C++ for 'fir_16tap' (39 lines)
INFO FormaSyn.golden.generator: Generated golden C++ for 'fir_16tap' (39 lines)
INFO FormaSyn.golden.quant_analyzer: Quantisation analysis complete for 'fir_16tap': 1 output nodes analysed over 100 trials
==> [3/5] 调用 LLM 生成硬件变体意图 ...
==> [4/5] 编译并验证各变体（L1/L2/L3 + feedback）...
INFO FormaSyn.agent.dse_agent: 调用 LLM 生成变体意图 (model=claude-sonnet-4-5-20250929, kernel=fir_16tap)
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
INFO FormaSyn.agent.dse_agent: 成功解析 8 个变体意图 (kernel=fir_16tap)
    Round 1: 生成 8 个变体
INFO FormaSyn.dsl.template_engine: Rendered variant 'baseline_int16_p16_full' (approx=min_sum, parallelism=16, nodes=5, dsp≈32)
INFO FormaSyn.solver.roofline_solver: Roofline solved baseline_int16_p16_full: DSP=0  BRAM=26  II=1
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] baseline_int16_p16_full  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/baseline_int16_p16_full
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [baseline_int16_p16_full]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] baseline_int16_p16_full  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'dsp_optimal_int8_p16' (approx=min_sum, parallelism=16, nodes=5, dsp≈32)
INFO FormaSyn.solver.roofline_solver: Roofline solved dsp_optimal_int8_p16: DSP=0  BRAM=24  II=1
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] dsp_optimal_int8_p16  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/dsp_optimal_int8_p16
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [dsp_optimal_int8_p16]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] dsp_optimal_int8_p16  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'balanced_int10_p8' (approx=offset_min_sum, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved balanced_int10_p8: DSP=0  BRAM=16  II=2
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] balanced_int10_p8  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/balanced_int10_p8
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [balanced_int10_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] balanced_int10_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'low_resource_int8_p4' (approx=normalized_min_sum, parallelism=4, nodes=5, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved low_resource_int8_p4: DSP=0  BRAM=24  II=4
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] low_resource_int8_p4  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/low_resource_int8_p4
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [low_resource_int8_p4]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] low_resource_int8_p4  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'high_precision_int12_p8' (approx=offset_min_sum, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved high_precision_int12_p8: DSP=0  BRAM=17  II=2
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] high_precision_int12_p8  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/high_precision_int12_p8
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [high_precision_int12_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] high_precision_int12_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'area_minimal_int6_p2' (approx=normalized_min_sum, parallelism=2, nodes=5, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved area_minimal_int6_p2: DSP=0  BRAM=27  II=8
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] area_minimal_int6_p2  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/area_minimal_int6_p2
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [area_minimal_int6_p2]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] area_minimal_int6_p2  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'recommended_int9_p8' (approx=offset_min_sum, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved recommended_int9_p8: DSP=0  BRAM=16  II=2
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] recommended_int9_p8  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/recommended_int9_p8
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [recommended_int9_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] recommended_int9_p8  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'clock_optimized_int8_p8' (approx=min_sum, parallelism=8, nodes=5, dsp≈16)
INFO FormaSyn.solver.roofline_solver: Roofline solved clock_optimized_int8_p8: DSP=0  BRAM=24  II=2
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] clock_optimized_int8_p8  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/clock_optimized_int8_p8
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [clock_optimized_int8_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] clock_optimized_int8_p8  stage=L1  metrics={}
    [DEEP] 进入第 1 轮反馈迭代，失败样本=8
INFO FormaSyn.agent.dse_agent: 调用 LLM 生成变体意图 (model=claude-sonnet-4-5-20250929, kernel=fir_16tap)
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
INFO FormaSyn.agent.dse_agent: 成功解析 8 个变体意图 (kernel=fir_16tap)
    Round 2: 生成 8 个变体
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_baseline_int16_p1' (approx=spa_exact, parallelism=1, nodes=4, dsp≈1)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_baseline_int16_p1: DSP=0  BRAM=18  II=16
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] fir_baseline_int16_p1  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/fir_baseline_int16_p1
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_baseline_int16_p1]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_baseline_int16_p1  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_dsp_fit_int16_p2' (approx=spa_exact, parallelism=2, nodes=4, dsp≈2)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_dsp_fit_int16_p2: DSP=0  BRAM=18  II=8
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] fir_dsp_fit_int16_p2  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/fir_dsp_fit_int16_p2
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_dsp_fit_int16_p2]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_dsp_fit_int16_p2  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_recommended_int9_p4' (approx=spa_exact, parallelism=4, nodes=4, dsp≈4)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_recommended_int9_p4: DSP=0  BRAM=19  II=4
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] fir_recommended_int9_p4  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/fir_recommended_int9_p4
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_recommended_int9_p4]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
    [FAIL] fir_recommended_int9_p4  stage=L1  metrics={}
INFO FormaSyn.dsl.template_engine: Rendered variant 'fir_low_dsp_int8_p8' (approx=spa_exact, parallelism=8, nodes=4, dsp≈8)
INFO FormaSyn.solver.roofline_solver: Roofline solved fir_low_dsp_int8_p8: DSP=0  BRAM=18  II=2
INFO httpx: HTTP Request: POST https://api.tryallai.com/v1/chat/completions "HTTP/1.1 200 OK"
    [ARTIFACT] fir_low_dsp_int8_p8  dir=/home/chengzhy/FormaSyn/examples/fir_16tap/fir_low_dsp_int8_p8
WARNING FormaSyn.checker.l1_checker: L1 CSim 失败 [fir_low_dsp_int8_p8]: ERROR: [v++ 60-1520] ***Exception: unrecognised option '--csim' 
Usage: v++ [options] <input file...>
Try v++ --help
 or v++ --compile --mode aie --help
 or v++ --compile --mode hls --help
很多都是 命令出错了  所以你可以去查阅
https://docs.amd.com/r/zh-CN/ug1702-vitis-accelerated-reference   找到更合适的在l1_checker 使用的命令 

2，全局寻找，有一些硬编码很不好
3， 多复用 然后解耦一些设计
4，