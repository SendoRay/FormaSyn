# BPSK Mapper (Modulator)

## Overview
Binary Phase Shift Keying (BPSK) modulator implemented as a Vitis HLS kernel using lookup table (LUT) mapping pattern.

## Architecture
- **Pattern**: Map (Lookup Table)
- **Implementation**: Single-port ROM LUT
- **Target Initiation Interval (II)**: 1 cycle

## Interface
| Signal | Type | Width | Description |
|--------|------|-------|-------------|
| bit_in | ap_uint | 1 | Input bit (0 or 1) |
| y_out | ap_int | 16 | Output constellation point |

## Constellation Mapping
| Input | Output | Value |
|-------|--------|-------|
| 0 | -1000 | -1.0 × scale |
| 1 | +1000 | +1.0 × scale |

## Specifications
- **Scale Factor**: 1000 (16-bit signed representation)
- **EVM Requirement**: ≤ 5%
- **Clock Target**: 5ns

## Files
- `kernel.h` - Header file with function prototype
- `kernel.cpp` - HLS kernel implementation
- `kernel_tb.cpp` - Testbench with EVM verification
- `hls_config.cfg` - Vitis HLS configuration
- `metadata.json` - Kernel metadata

## Build Instructions
```bash
vitis_hls -f hls_config.cfg
```
