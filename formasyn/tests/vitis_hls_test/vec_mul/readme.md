# vec_mul - Vector Multiplication

## Description
Vector multiplication kernel implementing a Map pattern. Computes element-wise multiplication of two 8-element vectors.

## Formula
```
y[i] = a[i] * b[i], for i = 0 to 7
```

## Data Types
- Input `a`: ap_int<16>[8]
- Input `b`: ap_int<16>[8]
- Output `y`: ap_int<32>[8] (widened to hold product)

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
