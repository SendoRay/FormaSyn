# Viterbi Decoder Kernel

## Overview

This Vitis HLS kernel implements a soft-decision Viterbi decoder with:
- **Constraint Length (K)**: 3
- **Number of States**: 4 (2^(K-1))
- **Code Rate**: 1/2
- **Traceback Depth**: 20
- **ACS Units**: 4 (one per state)

## Architecture

### Add-Compare-Select (ACS) Units

The decoder uses 4 parallel ACS units, one for each state. Each ACS unit:
1. **Add**: Computes new path metrics by adding branch metrics to survivor path metrics
2. **Compare**: Compares the two incoming path metrics
3. **Select**: Selects the path with minimum metric and records the decision

### Trellis Structure

```
Time t          Time t+1
   0 ──0/11──► 0 ◄──0/11── 0
   │            │
  1│           2│
   │            │
   0 ──1/00──► 2 ◄──1/00── 0
   
   1 ──0/10──► 1 ◄──0/10── 1
   │            │
  1│           2│
   │            │
   1 ──1/01──► 3 ◄──1/01── 1
```
(Format: input/output where output = {out2, out1})

### Branch Metric

Soft-decision branch metrics are computed using Euclidean distance:
```
BM = |soft_in[0] - expected[0]| + |soft_in[1] - expected[1]|
```

Where expected values are:
- Bit 0 → -127
- Bit 1 → +127

### Traceback

The decoder maintains a survivor memory of depth 20:
- Stores ACS decisions for each state at each time step
- Performs traceback from the state with minimum path metric
- Outputs the decoded bit after tracing back 20 steps

## Files

| File | Description |
|------|-------------|
| `kernel.h` | Header with types, constants, and inline helper functions |
| `kernel.cpp` | HLS kernel implementation with 4 ACS units |
| `kernel_tb.cpp` | Testbench with AWGN channel model and FER measurements |
| `hls_config.cfg` | Vitis HLS configuration |
| `metadata.json` | Kernel metadata |

## Building

```bash
vitis-run --mode hls --config hls_config.cfg --work_dir ./work
```

## Testing

```bash
g++ -o viterbi_simple_tb kernel_tb.cpp kernel.cpp -I/path/to/vitis/include -lm
./viterbi_simple_tb
```

## Validation

The testbench includes:
1. **FER Performance Test**: Measures FER at various SNR points (2-6 dB)
2. **Error-free Decode**: Verifies correct decoding at high SNR
3. **All-zeros/All-ones**: Tests basic functionality

**Performance Target**: FER gap < 0.5 dB from soft-decision theoretical performance

### Expected Performance

| Eb/N0 (dB) | Simulated FER | Theoretical FER | Gap (dB) |
|------------|---------------|-----------------|----------|
| 2.0        | ~0.1          | ~0.08           | < 0.5    |
| 3.0        | ~0.02         | ~0.015          | < 0.5    |
| 4.0        | ~0.003        | ~0.002          | < 0.5    |
| 5.0        | ~0.0003       | ~0.0002         | < 0.5    |
| 6.0        | < 0.0001      | < 0.00001       | < 0.5    |

## Performance

- **Pipeline II**: 1 (one symbol decoded per clock cycle)
- **Target Clock**: 5 ns (200 MHz)
- **Throughput**: 200 Msym/s → 100 Mbit/s decoded output
- **Latency**: num_symbols + traceback_depth + overhead

## Interface

```cpp
void viterbi_simple(
    hls::stream<ap_int<8>>& soft_in_stream,  // Soft decisions (-128 to 127)
    hls::stream<ap_uint<1>>& bit_out_stream, // Decoded bits
    ap_uint<32> num_symbols                   // Number of symbols
);
```

### Soft Decision Mapping

| Hard Bit | Soft Value (8-bit) | Confidence |
|----------|-------------------|------------|
| 0        | -128 to -1        | Low to High|
| 1        | 0 to 127          | Low to High|
| 0 (hard) | -127              | Maximum    |
| 1 (hard) | +127              | Maximum    |

## Compatibility

This decoder is designed to work with the `conv_encode` kernel:
- Same generator polynomials (G1=0b111, G2=0b101)
- Matches the convolutional encoder's state machine
- Soft-decision interface enables 2-3 dB coding gain over hard-decision
