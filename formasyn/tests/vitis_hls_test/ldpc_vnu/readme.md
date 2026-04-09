# LDPC Variable Node Update

## Overview

This kernel implements the variable node update function for LDPC (Low-Density Parity-Check) decoding. It combines channel LLR with messages from check nodes to generate extrinsic messages for the next iteration and makes hard bit decisions.

## Specifications

| Parameter | Value |
|-----------|-------|
| Max Variable Node Degree | 3 |
| Variable Nodes per Call | 8 |
| LLR Bit Width | 6 bits |
| LLR Integer Bits | 1 |
| LLR Range | [-2, 1.9375] |
| LLR Precision | 0.0625 (2⁻⁴) |

## Algorithm

### Mathematical Formulation

For a variable node connected to check nodes {1, 2, ..., d}:

**Total LLR (complete belief):**
```
L(Q_i) = L(P_i) + Σ L(r_ji)
          j
```

**Output message to check node j (extrinsic):**
```
L(q_ij) = L(Q_i) - L(r_ji)
        = L(P_i) + Σ L(r_j'i)
          j'≠j
```

**Hard decision:**
```
bit_i = 0 if L(Q_i) >= 0
bit_i = 1 if L(Q_i) < 0
```

Where:
- `L(P_i)` = Channel LLR (intrinsic information)
- `L(r_ji)` = LLR from check node j to variable i (C2V)
- `L(q_ij)` = LLR from variable i to check node j (V2C)
- `L(Q_i)` = Total LLR (all information combined)

### Key Properties

1. **Extrinsic Principle**: Output to a check node excludes the input from that same check node
2. **Summation**: All incoming information is added together
3. **Decision**: Based on total belief, not extrinsic message

## Files

| File | Description |
|------|-------------|
| `kernel.h` | Header with type definitions and function prototypes |
| `kernel.cpp` | VNU implementation with extrinsic messaging |
| `kernel_tb.cpp` | Comprehensive testbench |
| `hls_config.cfg` | Vitis HLS configuration |
| `metadata.json` | Kernel metadata |

## Usage

### C++ API

```cpp
#include "kernel.h"

llr_t channel_llr[NUM_VAR_NODES];                 // Channel LLRs
llr_t c2v_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];    // From check nodes
llr_t v2c_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];    // To check nodes
ap_uint<1> decisions[NUM_VAR_NODES];              // Hard decisions
int degree[NUM_VAR_NODES] = {2, 3, 1, 2, ...};    // Degrees

// Initialize inputs...

ldpc_vnu(channel_llr, c2v_msgs, degree, v2c_msgs, decisions);
```

### Vitis HLS Synthesis

```bash
vitis_hls hls_config.cfg
```

## Architecture

### Variable Node Update Unit
1. **Sum all inputs**: Channel LLR + all C2V messages
2. **Generate decisions**: Sign of total LLR
3. **Generate V2C messages**: Total minus each C2V (extrinsic)

### Parallel Processing
- 8 variable nodes processed per call
- Partial unrolling (factor=4) for throughput
- Inner loops fully unrolled

### Fixed-Point Format
- **Type**: `ap_fixed<6, 1>`
- **Sign bit**: 1
- **Integer bit**: 1
- **Fractional bits**: 4

## Performance Metrics

| Metric | Target |
|--------|--------|
| Clock Period | 5 ns (200 MHz) |
| Initiation Interval | 1 cycle |
| Latency | Fixed |

## Resource Estimation

| Resource | Estimated |
|----------|-----------|
| DSP48 | 0 |
| BRAM | 0 |
| LUT | ~600 |
| FF | ~300 |

## Test Cases

1. **Channel Only**: Positive/negative channel LLR without C2V
2. **With C2V Messages**: Combined channel and check node information
3. **Degree 1**: Edge case with single connection
4. **Multiple Nodes**: Parallel processing validation
5. **Extrinsic Property**: Verifies V2C = total - C2V relationship

## LDPC Context

### Variable Node Function
Variable nodes represent transmitted bits and combine:
- **Channel information**: From demodulator/quantizer
- **Code constraints**: From parity check nodes

### Message Passing Schedule
```
Iteration:
  1. VNU: Generate V2C from channel + C2V
  2. CNU: Generate C2V from V2C (parity constraints)
  3. Check stopping criterion (parity check or max iter)
```

### Extrinsic Principle
The key to belief propagation: each message sent must exclude the information received from that same edge to prevent "self-reinforcement."

## Optimization Notes

1. **No DSP Usage**: Only additions/subtractions (LUT-based)
2. **Fixed-Point Arithmetic**: 6-bit LLRs sufficient for many codes
3. **Pipelined Design**: II=1 with internal unrolling
4. **Configurable Degree**: Runtime degree allows flexible graph structure

## Integration with CNU

This VNU kernel is designed to work with the `ldpc_cnu_min_sum` kernel:

```
┌─────┐    V2C    ┌─────┐    C2V    ┌─────┐
│ VNU │ ────────→ │ CNU │ ────────→ │ VNU │
└─────┘           └─────┘           └─────┘
  ↑                                     │
  └──────── Channel LLR ←───────────────┘
```

## References

- R. Gallager, "Low-Density Parity-Check Codes," 1963
- F. Kschischang et al., "Factor Graphs and the Sum-Product Algorithm," 2001
- IEEE 802.11n/802.16e LDPC codes
- Xilinx UG902 - Vitis HLS User Guide
