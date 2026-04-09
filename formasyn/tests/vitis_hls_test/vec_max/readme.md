# vec_max - Vector Max Reduction

## Description
Vector max reduction kernel implementing a Reduce pattern. Finds the maximum value and its index (argmax) in an 8-element vector.

## Formula
```
y = max(a[i])
idx = argmax(a[i]), for i = 0 to 7
```

## Data Types
- Input `a`: ap_int<16>[8]
- Output `y`: ap_int<16> (max value)
- Output `idx`: ap_uint<3> (index of max value, 0-7)

## Files
- `kernel.h` - Header file with function declaration
- `kernel.cpp` - Kernel implementation
- `kernel_tb.cpp` - Testbench with correctness validation
- `hls_config.cfg` - Vitis HLS configuration
- `metadata.json` - Kernel metadata

## Build Instructions
```bash
vitis-run --mode hls --config hls_config.cfg --work_dir ./work
```

## Accuracy Requirement
- 100% correctness (exact match for both value and index)

## Performance Target
- Target II = 1
- Latency = 8 cycles
