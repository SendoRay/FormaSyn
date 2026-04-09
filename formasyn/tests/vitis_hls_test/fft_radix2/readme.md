# FFT Radix-2 Kernel (16-point)

## Overview

This directory contains a Vitis HLS implementation of a 16-point Radix-2 FFT (Fast Fourier Transform) kernel. The design achieves SFDR >= 60 dB using ap_fixed<16,8> data types and implements bit-reversal followed by butterfly computation stages.

## Architecture

### FormulaGraph Representation

```
Input -> bit_reverse -> Iteration[butterfly_stage] -> Output
                              |
                              v
                    [twiddle_factors (constants)]
```

### Implementation Details

| Parameter | Value |
|-----------|-------|
| FFT Size (NFFT) | 16 points |
| Stages | 4 (log2(16)) |
| Data Type | ap_fixed<16,8> (real/imag) |
| Twiddle Type | ap_fixed<18,2> (higher precision) |
| Target II | 1 cycle |
| SFDR | >= 60 dB |

### Bit-Reversal Stage

The input array is reordered using bit-reversal permutation. For 4-bit indices (16 points):
- Index b3b2b1b0 becomes b0b1b2b3

### Butterfly Stages

Each butterfly computes:
- out_a = in_a + twiddle * in_b
- out_b = in_a - twiddle * in_b

The kernel uses ping-pong buffers for efficient stage computation.

## Files

| File | Description |
|------|-------------|
| kernel.h | Header file with type definitions |
| kernel.cpp | Main kernel implementation |
| kernel_tb.cpp | Testbench with single-tone SFDR test |
| hls_config.cfg | Vitis HLS configuration |
| metadata.json | Kernel metadata and specifications |
| readme.md | This documentation |

## Usage

### Build with Vitis HLS

```bash
vitis-run --mode hls --config hls_config.cfg --work_dir work
```

Or using the GUI:
1. Open Vitis HLS
2. Create new project
3. Add kernel.cpp and kernel.h
4. Set top function: fft_radix2
5. Run C Simulation, C Synthesis, and Co-simulation

### C Simulation

```bash
g++ -I$XILINX_HLS/include -o fft_tb kernel_tb.cpp kernel.cpp
./fft_tb
```

### Integration

```cpp
#include "kernel.h"

// Input/output arrays
cmpx_data_t input[NFFT];
cmpx_data_t output[NFFT];

// Initialize input...

// Run FFT
fft_radix2(input, output);
```

## Performance

### Resource Estimates (Zynq UltraScale+)

| Resource | Estimate |
|----------|----------|
| DSP48 | 8 |
| FF | ~1,024 |
| LUT | ~2,048 |
| BRAM | 0 |

### Throughput

- Target clock: 100 MHz (10 ns)
- Initiation Interval: 1 cycle
- Latency: ~20 cycles (16-point FFT)

## Verification

The testbench performs:
1. Single-tone test: Verifies correct bin placement and computes SFDR
2. Multi-tone test: Tests different frequency bins
3. Impulse test: Validates DC response

### SFDR Calculation

SFDR is computed as the difference between signal power and the highest spur:
```
SFDR = P_signal - P_max_spur
```

Target: SFDR >= 60 dB

## Notes

- Twiddle factors are pre-computed constants for precision
- The design uses unrolled loops for maximum throughput
- Bit-reversal is done as a separate stage before butterfly computation
