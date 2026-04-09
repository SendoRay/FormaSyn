# vec_dot - Vector Dot Product

## Description
Vector dot product kernel implementing a Map+Reduce pattern. Computes the sum of element-wise products of two 8-element vectors.

## Formula
```
y = Σ(a[i] * b[i]), for i = 0 to 7
```

## Data Types
- Input `a`: ap_int<16>[8]
- Input `b`: ap_int<16>[8]
- Output `y`: ap_int<40> (widened to hold accumulated sum)

## Files
- `kernel.h` - Header file with function declaration
- `kernel.cpp` - Kernel implementation
- `kernel_tb.cpp` - Testbench with NMSE validation
- `hls_config.cfg` - Vitis HLS configuration
- `metadata.json` - Kernel metadata

## Build Instructions
```bash
vitis-run --mode hls --config hls_config.cfg --work_dir ./work
```

## Accuracy Requirement
- NMSE ≤ -50 dB

## Performance Target
- Target II = 1
- Latency = 8 cycles
