# FormaSyn Communication Kernels - Verification Report

**Date**: 2026-04-09  
**Toolchain**: Vitis HLS 2025.1  
**Target Device**: xc7z020-clg400-1 (Zynq-7000)  
**Clock Period**: 10ns (100MHz)

---

## Executive Summary

| Metric | Count | Percentage |
|--------|-------|------------|
| Total Kernels | 31 | 100% |
| Synthesis Complete | 22 | 71% |
| Co-simulation PASS | 16 | 52% |
| Synthesis FAILED | 3 | 10% |
| Not Run | 6 | 19% |

---

## 1. Fully Verified Kernels (C-Sim + Synthesis + Co-sim PASS)

These kernels have passed the complete Vitis HLS verification flow:

### 1.1 Vector Operations

#### vec_add - Vector Addition
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 9 |
| Latency (ns) | 90.000 |
| Interval (II) | 9 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 0 |
| FF | 387 (~0%) |
| LUT | 507 (~0%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| Verilog Sim | Pass (11 cycles) |

**Pragmas Used**: `pipeline`, `interface s_axilite`

---

#### vec_mul - Vector Multiplication
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 11 |
| Latency (ns) | 110.000 |
| Interval (II) | 9 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 8 (3%) |
| FF | 707 (~0%) |
| LUT | 582 (1%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| Verilog Sim | Pass (13 cycles) |

**Pragmas Used**: `pipeline`, `interface s_axilite`, `unroll factor=8`

---

#### vec_dot - Vector Dot Product
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 12 |
| Latency (ns) | 120.000 |
| Interval (II) | 8 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 8 (3%) |
| FF | 654 (~0%) |
| LUT | 596 (1%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| Verilog Sim | Pass (14 cycles) |

**Pragmas Used**: `pipeline`, `interface s_axilite`, `unroll factor=8`, `dataflow`

---

#### vec_max - Vector Maximum
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 8 |
| Latency (ns) | 80.000 |
| Interval (II) | 8 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 0 |
| FF | 333 (~0%) |
| LUT | 592 (1%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| Verilog Sim | Pass (10 cycles, interval=39) |

**Pragmas Used**: `pipeline`, `interface s_axilite`

---

### 1.2 Signal Processing

#### complex_fir - Complex FIR Filter
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 5 |
| Latency (ns) | 50.000 |
| Interval (II) | 1 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 16 (7%) |
| FF | 944 (~0%) |
| LUT | 593 (1%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| NMSE | -100 dB (target: -30 dB) |

**Pragmas Used**: `pipeline`, `interface s_axilite`, `array_partition`

---

#### correlator - Cross-Correlator
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 1 |
| Latency (ns) | 10.000 |
| Interval (II) | 1 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 0 |
| FF | 447 (~0%) |
| LUT | 577 (1%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| NMSE | < -45 dB |

**Pragmas Used**: `pipeline`, `interface s_axilite`, `inline`

---

### 1.3 Modulation/Coding

#### conv_encode - Convolutional Encoder
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | Variable (11-1003) |
| Latency (ns) | Variable |
| Interval (II) | 23-26 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 0 |
| FF | ~300 (~0%) |
| LUT | ~400 (~0%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| Verilog Sim | Pass (11-1003 cycles) |

**Pragmas Used**: `pipeline`, `interface s_axilite`

---

### 1.4 Utility Functions

#### quantizer - Fixed-point Quantizer
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 2 |
| Latency (ns) | 20.000 |
| Interval (II) | 1 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 0 |
| FF | 273 (~0%) |
| LUT | 694 (1%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| SQNR | Verified for 8-24 bits |

**Pragmas Used**: `pipeline`, `interface s_axilite`

---

#### scaler - Gain Scaler
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 3 |
| Latency (ns) | 30.000 |
| Interval (II) | 1 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 1 (~0%) |
| FF | 126 (~0%) |
| LUT | 229 (~0%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| NMSE | -100 dB (target: -50 dB) |

**Pragmas Used**: `pipeline`, `interface s_axilite`

---

#### agc_loop - Automatic Gain Control
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 4 |
| Latency (ns) | 40.000 |
| Interval (II) | 1 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 1 (~0%) |
| FF | 206 (~0%) |
| LUT | 500 (~0%) |
| URAM | 0 |
| **Cosim Result** | **PASS** |
| Convergence | Verified |

**Pragmas Used**: `pipeline`, `interface s_axilite`

---

### 1.5 Other Verified Kernels

| Kernel | Status | Key Metrics |
|--------|--------|-------------|
| baseline_int16_p16_full | PASS | II=1, FF=253, LUT=440 |
| fir_direct | PASS | 8 DSP (3%), II=1 |
| fir_halfband | PASS | 2 DSP, II=1, Latency=4 |
| fir_rrc | PASS | 19 DSP (8%), II=1 |
| iir_biquad | **Timing Issue** | -2.49ns slack, but sim passes |
| iir_cascade | **Timing Issue** | -4.22ns slack, but sim passes |

---

## 2. Failed Kernels

### 2.1 Interface Bundle Error (Fixable)

These kernels fail due to inconsistent bundle naming in HLS interface pragmas:

#### modem_bpsk
```
ERROR: [HLS 214-219] Vitis kernel mode requires that all s_axilite ports 
must be bundled into one bundle. The following ports ('return' and 'bit_in,y_out', 
in function 'bpsk_mapper') have different bundle names: 'control' and 'control_r'.
```

**Root Cause**: Inconsistent `bundle` names in interface pragmas
```cpp
// Current (broken)
#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS INTERFACE s_axilite port=bit_in  // Missing bundle!
#pragma HLS INTERFACE s_axilite port=y_out   // Missing bundle!

// Fix: Add bundle=control to all ports
#pragma HLS INTERFACE s_axilite port=return bundle=control
#pragma HLS INTERFACE s_axilite port=bit_in bundle=control
#pragma HLS INTERFACE s_axilite port=y_out bundle=control
```

**Status**: Not synthesized

---

#### modem_qpsk
```
ERROR: [HLS 214-219] Vitis kernel mode requires that all s_axilite ports 
must be bundled into one bundle. The following ports ('return' and 'bits_in,y_real,y_imag', 
in function 'qpsk_mapper') have different bundle names: 'control' and 'control_r'.
```

**Root Cause**: Same as modem_bpsk - inconsistent bundle names

**Status**: Not synthesized

---

#### modem_qam
```
ERROR: [HLS 214-219] Vitis kernel mode requires that all s_axilite ports 
must be bundled into one bundle. The following ports ('return' and 'bits_in,y_real,y_imag', 
in function 'qam16_mapper') have different bundle names: 'control' and 'control_r'.
```

**Root Cause**: Same as above - inconsistent bundle names

**Status**: Not synthesized

**Fix Priority**: HIGH - Simple pragma fix required

---

### 2.2 Not Run / Pending

These kernels have not been run through synthesis:

| Kernel | Status | Reason |
|--------|--------|--------|
| channel_estimate | NOT RUN | Pending implementation |
| fft_radix2 | NOT RUN | Pending implementation |
| ifft_radix2 | NOT RUN | Pending implementation |
| ldpc_cnu_min_sum | NOT RUN | Algorithm fix pending |
| ldpc_vnu | NOT RUN | Algorithm fix pending |
| pll_carrier | NOT RUN | Fixed-point NaN issues |
| viterbi_simple | NOT RUN | Algorithm fix pending |

---

### 2.3 Complex Kernel with Timeout

#### ofdm_base - OFDM Baseband Processing
| Metric | Value |
|--------|-------|
| **Performance** | |
| Latency (cycles) | 37 |
| Latency (ns) | 370.000 |
| Interval (II) | 21 |
| Pipelined | Yes |
| **Resource Usage** | |
| BRAM | 0 |
| DSP | 34 (15%) |
| FF | 3001 (2%) |
| LUT | 3685 (6%) |
| URAM | 0 |
| **Issue Type** | Complexity |

**Issue**: Design is very complex, causing long synthesis times. May require:
- Pipeline restructuring
- Resource sharing optimization
- Dataflow optimization

**Status**: Synthesized but may timeout on some runs

---

## 3. Performance Summary

### 3.1 Resource Utilization Comparison

| Kernel | DSP | FF | LUT | II | Latency |
|--------|-----|-----|-----|-----|---------|
| vec_add | 0 | 387 | 507 | 9 | 9 |
| vec_mul | 8 | 707 | 582 | 9 | 11 |
| vec_dot | 8 | 654 | 596 | 8 | 12 |
| vec_max | 0 | 333 | 592 | 8 | 8 |
| complex_fir | 16 | 944 | 593 | 1 | 5 |
| correlator | 0 | 447 | 577 | 1 | 1 |
| fir_rrc | 19 | 1752 | 1315 | 1 | 6 |
| quantizer | 0 | 273 | 694 | 1 | 2 |
| scaler | 1 | 126 | 229 | 1 | 3 |
| agc_loop | 1 | 206 | 500 | 1 | 4 |

### 3.2 Timing Analysis

| Kernel | Slack | Status |
|--------|-------|--------|
| vec_add | +0.58ns | ✓ Met |
| vec_mul | +1.72ns | ✓ Met |
| vec_dot | +1.72ns | ✓ Met |
| vec_max | +0.91ns | ✓ Met |
| complex_fir | +1.37ns | ✓ Met |
| correlator | +0.14ns | ✓ Met |
| fir_rrc | +0.47ns | ✓ Met |
| agc_loop | +1.13ns | ✓ Met |
| iir_biquad | -2.49ns | ✗ Violation |
| iir_cascade | -4.22ns | ✗ Violation |

---

## 4. Pragma Usage Summary

### Most Common Optimizations

| Pragma | Usage | Kernels |
|--------|-------|---------|
| `pipeline` | Universal | All 16 verified kernels |
| `interface s_axilite` | Universal | All kernels |
| `unroll` | Vector ops | vec_mul, vec_dot, vec_add |
| `array_partition` | FIR filters | complex_fir, fir_rrc |
| `inline` | Small functions | correlator |
| `dataflow` | Dot product | vec_dot |

---

## 5. Recommendations

### Immediate Actions

1. **Fix modem kernels** (modem_bpsk, modem_qpsk, modem_qam)
   - Add `bundle=control` to all s_axilite interface pragmas
   - Estimated fix time: 15 minutes

2. **Fix timing violations** (iir_biquad, iir_cascade)
   - Increase clock period to 15ns or add pipeline stages
   - Consider resource sharing for multipliers

3. **Complete pending kernels**
   - channel_estimate: Requires channel model implementation
   - fft_radix2/ifft_radix2: Ready for synthesis
   - pll_carrier: Fix Taylor series approximation

### Long-term Improvements

1. **Optimize ofdm_base** for faster synthesis
2. **Implement LDPC decoder** with proper min-sum algorithm
3. **Fix viterbi_simple** traceback logic

---

## 6. Appendix: File Locations

### Verified Kernels
```
formasyn/tests/vitis_hls_test/
├── agc_loop/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── complex_fir/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── conv_encode/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── correlator/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── quantizer/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── scaler/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── vec_add/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── vec_dot/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── vec_max/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
├── vec_mul/{kernel.cpp, kernel.h, kernel_tb.cpp, hls_config.cfg}
└── [fir_direct, fir_halfband, fir_rrc, iir_biquad, iir_cascade]
```

### Build Commands

```bash
# C Simulation
vitis-run --mode hls --csim --config hls_config.cfg --work_dir work

# Synthesis
v++ -c --mode hls --config hls_config.cfg --work_dir work

# Co-simulation
vitis-run --mode hls --cosim --config hls_config.cfg --work_dir work
```

---

*Report generated by FormaSyn HLS Verification Tool*
