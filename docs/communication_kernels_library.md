# FormaSyn 通信算子库

基于 8 个核心算子：Map, Reduce, ShiftReg, Delay, MessagePass, Cycle, Iteration, Switch

---

## 验证指标说明

每类算子只有一个核心验证指标：

| 算子类别 | 核心指标 | 统一阈值 |
|----------|----------|----------|
| **滤波** | NMSE | ≤ -40 dB |
| **同步** | 见具体算子 | - |
| **变换** | SFDR | ≥ 60 dB |
| **调制** | EVM | ≤ 3% |
| **编码** | FER差距 | < 0.5 dB |
| **向量** | NMSE | ≤ -50 dB |
| **均衡** | NMSE | ≤ -30 dB |

---

## 1. 滤波类

**验证指标：NMSE ≤ -40 dB**（与双精度浮点参考比较）

### 1.1 fir_direct
```python
def fir_direct(x, h, taps):
    return FormulaGraph([
        ShiftReg(input_ref=x, taps=list(range(taps)), output_ref="d"),
        Map(input_ref="d", func="multiply", func_params={"coeffs": h}, output_ref="p"),
        Reduce(input_refs=["p"], op="add", domain=Domain("all"), output_ref="y")
    ])
```

**硬件参数**
| 参数 | 范围 | 资源 |
|------|------|------|
| taps | 8~256 | N DSP |
| bit_width | 8~24 | DSP/LUT |
| parallelism | 1~32 | P并行 |

**验证**：白噪声输入，NMSE ≤ -40 dB

---

### 1.2 fir_halfband
```python
def fir_halfband(x, h_eff, taps):
    non_zero = [i for i in range(taps) if h[i]!=0 or i==taps//2]
    return FormulaGraph([
        ShiftReg(input_ref=x, taps=non_zero, output_ref="d"),
        Map(input_ref="d", func="multiply", func_params={"coeffs": h_eff}, output_ref="p"),
        Reduce(input_refs=["p"], op="add", output_ref="y")
    ])
```

**硬件参数**：~N/2 DSP（零系数跳过）

**验证**：NMSE ≤ -40 dB

---

### 1.3 fir_rrc
```python
def fir_rrc(x, sps, span, alpha):
    taps = sps * span + 1
    h = generate_rrc_coeffs(sps, span, alpha)
    return fir_direct(x, h, taps)
```

**硬件参数**：同 fir_direct

**验证**：NMSE ≤ -40 dB

---

### 1.4 iir_biquad
```python
def iir_biquad(x, b, a):
    return FormulaGraph([Cycle(
        body=[
            Map("x", "multiply", {"coeff":b[0]}, "xf0"),
            Map("x_d1", "multiply", {"coeff":b[1]}, "xf1"),
            Map("x_d2", "multiply", {"coeff":b[2]}, "xf2"),
            Map("y_d1", "multiply", {"coeff":-a[0]}, "yb1"),
            Map("y_d2", "multiply", {"coeff":-a[1]}, "yb2"),
            Reduce(["xf0","xf1","xf2","yb1","yb2"], "add", Domain("all"), "y")
        ],
        feedback_edges=[Edge("y","y_d1",1), Edge("y_d1","y_d2",1), Edge("x","x_d1",1), Edge("x_d1","x_d2",1)]
    )])
```

**硬件参数**：5 DSP/节

**验证**：NMSE ≤ -40 dB（需预检查极点|p|<1）

---

### 1.5 iir_cascade
```python
def iir_cascade(x, sections):
    return FormulaGraph([Cycle(...) for _ in sections])
```

**硬件参数**：5×M DSP（M节）

**验证**：NMSE ≤ -40 dB

---

## 2. 同步类

### 2.1 correlator
**指标：NMSE ≤ -45 dB**

```python
def correlator(x, preamble, length):
    return FormulaGraph([
        ShiftReg(x, list(range(length)), "d"),
        Map("d", "multiply", {"coeffs":preamble}, "p"),
        Reduce(["p"], "add", Domain("all"), "y")
    ])
```

**硬件参数**：N DSP（复数×4）

**验证**：已知延迟信号，NMSE ≤ -45 dB

---

### 2.2 agc_loop
**指标：收敛时间 ≤ 1000 采样**

```python
def agc_loop(x, target, mu):
    return FormulaGraph([Cycle(
        body=[
            Map("y", "abs", {}, "ym"),
            Map("ym", "subtract_from", {"value":target}, "e"),
            Map("e", "multiply", {"coeff":mu}, "d"),
            Reduce(["g_d1","d"], "add", Domain("all"), "gr"),
            Map("gr", "clamp", {"min":0.01,"max":10}, "g"),
            Map("x", "multiply", {"operand":"g"}, "y")
        ],
        feedback_edges=[Edge("g","g_d1",1)]
    )])
```

**硬件参数**：2 DSP

**验证**：阶跃输入，1000采样内稳态±5%

---

### 2.3 pll_carrier
**指标：锁定时间 ≤ 1000 符号**

```python
def pll_carrier(x, kp, ki):
    return FormulaGraph([Cycle(
        body=[
            Map("x", "phase_rotate", {"phase":"theta_d1"}, "y"),
            Map("y", "phase_error", {}, "e"),
            Map("e", "multiply", {"coeff":kp}, "pt"),
            Map("e", "multiply", {"coeff":ki}, "id"),
            Reduce(["is_d1","id"], "add", {}, "it"),
            Reduce(["theta_d1","pt","it"], "add", {}, "th"),
            Map("th", "wrap_phase", {}, "tn")
        ],
        feedback_edges=[Edge("tn","theta_d1",1), Edge("it","is_d1",1)]
    )])
```

**硬件参数**：LUT/CORDIC

**验证**：初始频偏，1000符号内相位误差<5°

---

## 3. 变换类

**验证指标：SFDR ≥ 60 dB**

### 3.1 fft_radix2
```python
def fft_radix2(x, nfft):
    return FormulaGraph([
        Map(x, "bit_reverse", {}, "xo"),
        Iteration(
            body=[Map("in", "butterfly", {"radix":2}, "out")],
            count=log2(nfft),
            carry=[("out","in")]
        )
    ])
```

**硬件参数**：N/2蝶形，Pipelined/Iterative

**验证**：单音输入，SFDR ≥ 60 dB

---

### 3.2 ifft_radix2
```python
def ifft_radix2(x, nfft):
    return FormulaGraph([
        Map(x, "conj", {}, "xc"),
        fft_radix2("xc", nfft),
        Map("fft_out", "conj_scale", {"scale":1/nfft}, "y")
    ])
```

**硬件参数**：同 fft_radix2

**验证**：SFDR ≥ 60 dB

---

## 4. 调制类

**验证指标：EVM ≤ 3%（64-QAM）**

### 4.1 modem_bpsk
```python
def modem_bpsk(bits):
    return FormulaGraph([Map(bits, "lut", {"mapping":{0:-1,1:1}}, "y")])
```

**硬件参数**：LUT: 4

**验证**：EVM ≤ 5%（BPSK放宽）

---

### 4.2 modem_qpsk
```python
def modem_qpsk(bits):
    return FormulaGraph([Map(bits, "qam_map", {"constellation":qpsk_const}, TensorType("complex",32), "y")])
```

**硬件参数**：LUT: 8

**验证**：EVM ≤ 5%

---

### 4.3 modem_qam
```python
def modem_qam(bits, m):
    return FormulaGraph([Map(bits, "qam_map", {"constellation":gen_qam(m)}, "y")])
```

**硬件参数**：LUT: m条目

**验证**：EVM ≤ 3%（64-QAM）或 ≤ 1.5%（256-QAM）

---

### 4.4 ofdm_base
```python
def ofdm_base(syms, nfft, cp):
    return FormulaGraph([
        Map(syms, "subcarrier_map", {"fft_size":nfft}, "fd"),
        Iteration([Map("in","butterfly",{},"out")], log2(nfft), [("out","in")]),
        ShiftReg("ifft_out", list(range(nfft-cp,nfft))+list(range(nfft)), "y")
    ])
```

**硬件参数**：FFT资源 + CP存储

**验证**：EVM ≤ 6%

---

## 5. 编码类

**验证指标：FER与浮点参考 < 0.5 dB差距**

### 5.1 ldpc_cnu_min_sum
```python
def ldpc_cnu_min_sum(llr, H, dc):
    return FormulaGraph([
        MessagePass(H, "check_node", Map("in","sign",{},"s"), Reduce(["s"],"xor",Domain("neighbors"),"so")),
        MessagePass(H, "check_node", Map("in","abs",{},"a"), Reduce(["a"],"min",Domain("neighbors"),"mo"))
    ])
```

**硬件参数**：XOR树/Min树

**验证**：AWGN信道，FER与浮点<0.5dB差距

---

### 5.2 ldpc_vnu
```python
def ldpc_vnu(llr, llr_ch, H):
    return FormulaGraph([MessagePass(H, "variable_node", ..., Reduce(...,"add",...)), Reduce(["sum",llr_ch],"add","y")])
```

**验证**：同 ldpc_cnu

---

### 5.3 conv_encode
```python
def conv_encode(bits, g, k):
    return FormulaGraph([ShiftReg(bits, range(k), "s"), Map("s", "conv_tap", {"generators":g}, "y")])
```

**硬件参数**：移位寄存器 + XOR

**验证**：标准测试向量，100%正确

---

### 5.4 viterbi_simple
```python
def viterbi_simple(soft, states, tb):
    return FormulaGraph([
        Map(soft, "branch_metric", {}, "bm"),
        Iteration([Cycle([Map(...,"acs_update",...), Reduce(...,"min_select",...)], [...])], tb),
        Map("path", "traceback", {}, "y")
    ])
```

**硬件参数**：ACS单元 × 状态数

**验证**：FER与软判理论<0.5dB差距

---

## 6. 向量类

**验证指标：NMSE ≤ -50 dB**

### 6.1 vec_add
```python
def vec_add(a, b, n): return FormulaGraph([Map([a,b], "add", {}, "y")])
```

**验证**：NMSE ≤ -50 dB

---

### 6.2 vec_mul
```python
def vec_mul(a, b, n): return FormulaGraph([Map([a,b], "multiply", {}, "y")])
```

**验证**：NMSE ≤ -50 dB

---

### 6.3 vec_dot
```python
def vec_dot(a, b, n): return FormulaGraph([Map([a,b], "multiply", {}, "p"), Reduce(["p"], "add", Domain("all"), "y")])
```

**验证**：NMSE ≤ -50 dB

---

### 6.4 vec_max
```python
def vec_max(a, n): return FormulaGraph([Reduce([a], "max", Domain("all"), "y")])
```

**验证**：正确率100%

---

## 7. 均衡类

**验证指标：NMSE ≤ -30 dB**

### 7.1 complex_fir
```python
def complex_fir(x, h, taps):
    return FormulaGraph([
        ShiftReg(x, range(taps), "d", TensorType("complex",32)),
        Map("d", "complex_multiply", {"coeffs":h}, "p"),
        Reduce(["p"], "complex_add", Domain("all"), "y")
    ])
```

**硬件参数**：4×N DSP（复数）

**验证**：NMSE ≤ -30 dB

---

### 7.2 channel_estimate
```python
def channel_estimate(rx_p, pilot):
    return FormulaGraph([
        Map([rx_p,pilot], "complex_multiply_conj", {}, "cc"),
        Map(pilot, "complex_mag_sq", {}, "pp"),
        Map(["cc","pp"], "complex_divide_real", {}, "y")
    ])
```

**验证**：NMSE ≤ -20 dB（高SNR）

---

## 8. 工具类

### 8.1 quantizer
```python
def quantizer(x, bits, frac): return FormulaGraph([Map(x, "quantize", {"bits":bits,"frac":frac}, "y")])
```

**验证**：SQNR ≥ 6×bits dB

---

### 8.2 scaler
```python
def scaler(x, gain): return FormulaGraph([Map(x, "multiply", {"coeff":gain}, "y")])
```

**验证**：NMSE ≤ -50 dB

---

## 汇总表

| 算子 | 核心指标 | 阈值 |
|------|----------|------|
| fir_direct | NMSE | ≤ -40 dB |
| fir_halfband | NMSE | ≤ -40 dB |
| fir_rrc | NMSE | ≤ -40 dB |
| iir_biquad | NMSE | ≤ -40 dB |
| iir_cascade | NMSE | ≤ -40 dB |
| correlator | NMSE | ≤ -45 dB |
| agc_loop | 收敛时间 | ≤ 1000采样 |
| pll_carrier | 锁定时间 | ≤ 1000符号 |
| fft_radix2 | SFDR | ≥ 60 dB |
| ifft_radix2 | SFDR | ≥ 60 dB |
| modem_bpsk | EVM | ≤ 5% |
| modem_qpsk | EVM | ≤ 5% |
| modem_qam | EVM | ≤ 3% |
| ofdm_base | EVM | ≤ 6% |
| ldpc_cnu | FER差距 | < 0.5 dB |
| ldpc_vnu | FER差距 | < 0.5 dB |
| conv_encode | 正确率 | 100% |
| viterbi_simple | FER差距 | < 0.5 dB |
| vec_add | NMSE | ≤ -50 dB |
| vec_mul | NMSE | ≤ -50 dB |
| vec_dot | NMSE | ≤ -50 dB |
| vec_max | 正确率 | 100% |
| complex_fir | NMSE | ≤ -30 dB |
| channel_estimate | NMSE | ≤ -20 dB |
| quantizer | SQNR | ≥ 6×bits dB |
| scaler | NMSE | ≤ -50 dB |

---

*版本: 1.0*  
*日期: 2026-04-08*
