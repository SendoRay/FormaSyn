# 16-QAM Mapper (Modulator)

## Overview
16-Quadrature Amplitude Modulation (16-QAM) modulator implemented as a Vitis HLS kernel using lookup table (LUT) mapping pattern with Gray coding.

## Architecture
- **Pattern**: Map (Dual Lookup Table)
- **Implementation**: Single ROM LUT shared for I and Q components
- **Target Initiation Interval (II)**: 1 cycle

## Interface
| Signal | Type | Width | Description |
|--------|------|-------|-------------|
| bits_in | ap_uint | 4 | Input symbol (I: bits[3:2], Q: bits[1:0]) |
| y_real | ap_int | 16 | I-component output |
| y_imag | ap_int | 16 | Q-component output |

## Constellation Mapping (Gray Coded)
The 4-bit input is split into two 2-bit groups:
- **I-component**: bits[3:2]
- **Q-component**: bits[1:0]

### 2-bit Gray to Level Mapping
| Gray Code | Decimal | Level | Value |
|-----------|---------|-------|-------|
| 00 | 0 | -3 | -3000 |
| 01 | 1 | -1 | -1000 |
| 11 | 3 | +1 | +1000 |
| 10 | 2 | +3 | +3000 |

### Full 16-QAM Constellation
| Symbol | I_bits | Q_bits | I | Q |
|--------|--------|--------|---|---|
| 0x0 | 00 | 00 | -3000 | -3000 |
| 0x1 | 00 | 01 | -3000 | -1000 |
| 0x2 | 00 | 10 | -3000 | +3000 |
| 0x3 | 00 | 11 | -3000 | +1000 |
| ... | ... | ... | ... | ... |

## Specifications
- **Scale Factor**: 1000 (16-bit signed representation)
- **Levels**: ±1, ±3 (scaled to ±1000, ±3000)
- **Coding**: Gray code (adjacent symbols differ by 1 bit)
- **EVM Requirement**: ≤ 3%
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
