# OFDM Baseband Modulator

## Overview

This kernel implements an OFDM (Orthogonal Frequency Division Multiplexing) baseband modulator with a 16-point IFFT and cyclic prefix insertion. It is suitable for small-scale OFDM systems and educational purposes.

## Specifications

| Parameter | Value |
|-----------|-------|
| IFFT Size | 16 points |
| Cyclic Prefix (CP) | 4 samples |
| Total Output | 20 samples (16 + 4) |
| Input/Output Type | Complex fixed-point (16-bit, 3 integer bits) |
| EVM Requirement | ≤ 6% |

## Architecture

### IFFT Implementation
- **Algorithm**: Radix-2 Decimation-in-Time (DIT)
- **Stages**: 4 (log₂(16))
- **Butterfly Units**: 8 per stage
- **Twiddle Factors**: Pre-computed constants (W₁₆)

### Cyclic Prefix Insertion
- Copies the last 4 samples of the IFFT output to the front
- Provides robustness against multipath fading
- Achieved through parallel unrolled loops for minimal latency

### Fixed-Point Format
- **Type**: `ap_fixed<16, 3>`
- **Range**: [-4, 3.9999]
- **Precision**: ~0.00003 (2⁻¹³)

## Files

| File | Description |
|------|-------------|
| `kernel.h` | Header with type definitions and constants |
| `kernel.cpp` | Main kernel implementation |
| `kernel_tb.cpp` | Testbench with multiple test cases |
| `hls_config.cfg` | Vitis HLS configuration |
| `metadata.json` | Kernel metadata and specifications |

## Usage

### C++ API

```cpp
#include "kernel.h"

complex_t in[OFDM_N];        // 16 input symbols
complex_t out[OFDM_SYM_LEN]; // 20 output samples

// Initialize input symbols...

ofdm_base(in, out);
```

### Vitis HLS Synthesis

```bash
vitis_hls hls_config.cfg
```

## Test Cases

The testbench includes the following test cases:

1. **Impulse at DC**: Verifies correct DC response
2. **Single Tone**: Tests frequency translation
3. **QPSK Random**: Tests with random QPSK symbols
4. **Cyclic Prefix Verification**: Confirms CP is correctly inserted

## Performance Metrics

| Metric | Target |
|--------|--------|
| Clock Period | 5 ns (200 MHz) |
| Initiation Interval | 1 cycle |
| Latency | Fixed (dataflow) |
| EVM | ≤ 6% |

## Resource Estimation

| Resource | Estimated |
|----------|-----------|
| DSP48 | 8 |
| BRAM | 0 |
| LUT | ~2,000 |
| FF | ~1,500 |

## Algorithm Details

### IFFT Formula
```
x[n] = (1/N) × Σ X[k] × exp(j×2π×k×n/N)
     k=0 to N-1
```

Where:
- N = 16 (IFFT size)
- X[k] = Input frequency-domain symbols
- x[n] = Output time-domain samples

### Cyclic Prefix
```
Output = [x[N-CP], x[N-CP+1], ..., x[N-1], x[0], x[1], ..., x[N-1]]
       = [x[12], x[13], x[14], x[15], x[0], x[1], ..., x[15]]
```

## Optimization Techniques

1. **Array Partitioning**: Complete partitioning of intermediate arrays for parallel butterfly access
2. **Loop Unrolling**: All loops unrolled for maximum throughput
3. **Pipeline**: II=1 throughout the kernel
4. **Constant Twiddle Factors**: Pre-computed to save DSP resources

## References

- IEEE 802.11a OFDM PHY specification
- "Digital Communications" by John Proakis
- Xilinx UG902 - Vitis HLS User Guide
