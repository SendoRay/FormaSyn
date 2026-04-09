# IFFT Radix-2 Kernel (16-point)

## Overview

This directory contains a Vitis HLS implementation of a 16-point Radix-2 IFFT (Inverse Fast Fourier Transform) kernel. The design uses the FFT+conj_scale approach:

```
IFFT(x) = conj(FFT(conj(x))) / NFFT
```

This approach reuses the FFT hardware efficiently while maintaining SFDR >= 60 dB.

## Architecture

### FormulaGraph Representation

```
Input -> conj -> fft -> conj_scale -> Output
```

Where:
- **conj**: Complex conjugate of input
- **fft**: 16-point Radix-2 FFT
- **conj_scale**: Complex conjugate and divide by NFFT (16)

### Implementation Details

| Parameter | Value |
|-----------|-------|
| IFFT Size (NFFT) | 16 points |
| Stages | 4 (log2(16)) |
| Data Type | ap_fixed<16,8> (real/imag) |
| Twiddle Type | ap_fixed<18,2> (higher precision) |
| Scale Factor | 1/16 = 0.0625 |
| Target II | 1 cycle |
| SFDR | >= 60 dB |

### Algorithm Steps

1. **Conjugate Input**: Take complex conjugate of input frequency-domain data
2. **Forward FFT**: Apply Radix-2 FFT (bit-reverse + butterfly stages)
3. **Conjugate and Scale**: Take conjugate of FFT output and divide by NFFT

The division by NFFT is implemented as multiplication by 0.0625 for hardware efficiency.

## Files

| File | Description |
|------|-------------|
| kernel.h | Header file with type definitions and function prototypes |
| kernel.cpp | Main kernel implementation (conj -> fft -> conj_scale) |
| kernel_tb.cpp | Testbench with round-trip and reference comparison |
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
4. Set top function: ifft_radix2
5. Run C Simulation, C Synthesis, and Co-simulation

### C Simulation

```bash
g++ -I$XILINX_HLS/include -o ifft_tb kernel_tb.cpp kernel.cpp
./ifft_tb
```

### Integration

```cpp
#include "kernel.h"

// Input/output arrays (frequency domain input, time domain output)
cmpx_data_t freq_in[NFFT];
cmpx_data_t time_out[NFFT];

// Initialize frequency domain input...

// Run IFFT
ifft_radix2(freq_in, time_out);
```

## Performance

### Resource Estimates (Zynq UltraScale+)

| Resource | Estimate |
|----------|----------|
| DSP48 | 8 |
| FF | ~2,048 |
| LUT | ~4,096 |
| BRAM | 0 |

### Throughput

- Target clock: 100 MHz (10 ns)
- Initiation Interval: 1 cycle
- Latency: ~25 cycles (16-point IFFT)

## Verification

The testbench performs:
1. **Single-tone test**: IFFT of a single frequency bin
2. **Round-trip test**: FFT -> IFFT should recover original signal
3. **DC component test**: IFFT of DC should give constant output

### Accuracy

- Max error vs floating-point reference: < 0.01
- Round-trip error (FFT -> IFFT): < 0.01

## Notes

- The IFFT uses the same internal FFT core for hardware sharing
- Scale factor 1/NFFT is implemented as fixed-point multiplication
- Conjugate operations are simple sign changes on imaginary parts
- Higher precision twiddle factors ensure 60+ dB SFDR
