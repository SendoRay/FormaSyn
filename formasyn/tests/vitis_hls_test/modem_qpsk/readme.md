# QPSK Mapper (Modulator)

## Overview
Quadrature Phase Shift Keying (QPSK) modulator implemented as a Vitis HLS kernel using lookup table (LUT) mapping pattern.

## Architecture
- **Pattern**: Map (Dual Lookup Table)
- **Implementation**: Two single-port ROM LUTs (I and Q components)
- **Target Initiation Interval (II)**: 1 cycle

## Interface
| Signal | Type | Width | Description |
|--------|------|-------|-------------|
| bits_in | ap_uint | 2 | Input symbol (00, 01, 10, 11) |
| y_real | ap_int | 16 | I-component output |
| y_imag | ap_int | 16 | Q-component output |

## Constellation Mapping (Gray Coded)
| Input | I (Real) | Q (Imag) | Phase |
|-------|----------|----------|-------|
| 00 | +707 | +707 | 45° |
| 01 | +707 | -707 | 315° (-45°) |
| 10 | -707 | +707 | 135° |
| 11 | -707 | -707 | 225° (-135°) |

## Specifications
- **Scale Factor**: 1000 (16-bit signed representation)
- **Ideal Values**: ±0.707 × 1000 = ±707
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
