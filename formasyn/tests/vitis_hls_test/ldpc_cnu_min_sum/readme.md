# LDPC Check Node Update (Min-Sum)

## Overview

This kernel implements the check node update function for LDPC (Low-Density Parity-Check) decoding using the min-sum approximation algorithm. The check node enforces parity constraints by computing messages to send back to variable nodes.

## Specifications

| Parameter | Value |
|-----------|-------|
| Max Check Node Degree | 6 |
| Check Nodes per Call | 4 |
| LLR Bit Width | 6 bits |
| LLR Integer Bits | 1 |
| LLR Range | [-2, 1.9375] |
| LLR Precision | 0.0625 (2⁻⁴) |

## Min-Sum Algorithm

### Mathematical Formulation

For a check node with degree d connected to variable nodes {1, 2, ..., d}:

**Output message to variable node j:**
```
L(r_ji) = [Π sign(L(q_ij'))] × min(|L(q_ij')|)
           j'≠j
```

Where:
- `L(q_ij)` = LLR from variable node i to check node j (V2C)
- `L(r_ji)` = LLR from check node j to variable node i (C2V)
- `sign(x)` = 1 if x < 0, else 0
- `Π` sign product computed as XOR of signs

### Algorithm Steps

1. **Extract signs**: Get sign bit from each input LLR
2. **Get magnitudes**: Compute absolute value of each input LLR
3. **Compute overall sign**: XOR all sign bits
4. **Find minima**: Find minimum and second minimum magnitudes
5. **Generate outputs**: For each edge, output = (overall_sign XOR own_sign) × (min excluding self)

## Files

| File | Description |
|------|-------------|
| `kernel.h` | Header with type definitions and function prototypes |
| `kernel.cpp` | Min-sum CNU implementation |
| `kernel_tb.cpp` | Comprehensive testbench |
| `hls_config.cfg` | Vitis HLS configuration |
| `metadata.json` | Kernel metadata |

## Usage

### C++ API

```cpp
#include "kernel.h"

llr_t v2c_msgs[NUM_CHECK_NODES][CNU_MAX_DEGREE];  // Input messages
llr_t c2v_msgs[NUM_CHECK_NODES][CNU_MAX_DEGREE];  // Output messages
int degree[NUM_CHECK_NODES] = {4, 3, 5, 4};       // Degrees per CN

// Initialize v2c_msgs with LLR values from variable nodes...

ldpc_cnu_min_sum(v2c_msgs, degree, c2v_msgs);
```

### Vitis HLS Synthesis

```bash
vitis_hls hls_config.cfg
```

## Architecture

### Check Node Update Unit
- **Sign processing**: XOR tree for sign product computation
- **Magnitude processing**: Parallel comparison for min-finding
- **Output generation**: Sign application and min selection

### Parallelization
- Input/output arrays partitioned for parallel access
- Inner loops fully unrolled
- Check nodes processed with partial unrolling (factor=2)

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
| LUT | ~800 |
| FF | ~400 |

## Test Cases

The testbench validates:

1. **All Positive LLRs**: Verifies sign handling with uniform signs
2. **Mixed Signs**: Tests XOR sign product with mixed inputs
3. **Maximum Degree**: Validates full degree-6 operation
4. **Multiple Check Nodes**: Tests parallel CN processing
5. **Min-Sum Property**: Verifies minimum selection logic

## LDPC Context

### Check Node Function
In LDPC decoding, check nodes represent parity check equations:
```
⊕ v_i = 0  (XOR sum of connected variables = 0)
```

### Message Passing
- **V2C (Variable-to-Check)**: Extrinsic information from variables
- **C2V (Check-to-Variable)**: Parity constraint information from checks

### Min-Sum vs. BP
- **BP (Belief Propagation)**: Exact but computationally expensive (tanh function)
- **Min-Sum**: Approximation using min and sign-XOR
- **Offset Min-Sum**: Correction factor can be added for better performance

## Optimization Notes

1. **No DSP Usage**: All operations are comparisons and XOR (LUT-based)
2. **Fully Combinational Core**: Check node update is purely combinational
3. **Pipelined Wrapper**: Top-level has pipeline II=1 with internal unrolling
4. **Configurable Degree**: Runtime degree parameter allows flexible code rates

## References

- R. Gallager, "Low-Density Parity-Check Codes," 1963
- M. Fossorier et al., "Reduced complexity iterative decoding of LDPC codes," 1999
- IEEE 802.11n/802.16e LDPC codes
- Xilinx UG902 - Vitis HLS User Guide
