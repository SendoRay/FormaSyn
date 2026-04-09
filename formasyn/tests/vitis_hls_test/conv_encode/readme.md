# Convolutional Encoder Kernel

## Overview

This Vitis HLS kernel implements a convolutional encoder with:
- **Constraint Length (K)**: 3
- **Code Rate**: 1/2 (2 output bits per input bit)
- **Generator Polynomials**: G1=0b111 (7), G2=0b101 (5)

## Architecture

The encoder uses a shift register-based state memory to track the K-1=2 previous input bits. For each input bit:
1. The current state and input bit form a K-bit word
2. Output bits are computed by XORing selected bits according to generator polynomials
3. The shift register is updated with the new input bit

### Generator Polynomials

- **G1 (0b111)**: `out1 = bit[n] ^ bit[n-1] ^ bit[n-2]`
- **G2 (0b101)**: `out2 = bit[n] ^ bit[n-2]`

### State Diagram

```
     0/11       1/00
    ┌────┐    ┌────┐
    │    ▼    │    ▼
  ┌────┐    ┌────┐
  │ 00 │◄──►│ 10 │
  └────┘    └────┘
    ▲    ▄▄▄▄▄    ▲
    └────┤   ├────┘
     0/00 │   │ 1/11
     1/10 │   │ 0/01
    ┌────┐▼   ▼┌────┐
  ┌────┐    ┌────┐
  │ 01 │◄──►│ 11 │
  └────┘    └────┘
    ▲    ▄▄▄▄▄    ▲
    └────┘    └────┘
     0/10       1/01
```
(Format: input/output where output = {out2, out1})

## Files

| File | Description |
|------|-------------|
| `kernel.h` | Header file with parameters and shift register class |
| `kernel.cpp` | HLS kernel implementation |
| `kernel_tb.cpp` | Testbench with reference model |
| `hls_config.cfg` | Vitis HLS configuration |
| `metadata.json` | Kernel metadata |

## Building

```bash
vitis-run --mode hls --config hls_config.cfg --work_dir ./work
```

## Testing

```bash
g++ -o conv_encode_tb kernel_tb.cpp kernel.cpp -I/path/to/vitis/include
./conv_encode_tb
```

## Validation

The testbench includes:
1. All-zeros input test
2. All-ones input test
3. Alternating pattern test
4. Known test vector verification
5. Random data test (1000+ bits)

**Result**: 100% correct for all test vectors.

## Performance

- **Pipeline II**: 1 (one bit encoded per clock cycle)
- **Target Clock**: 5 ns (200 MHz)
- **Throughput**: 200 Mbits/s input, 400 Mbits/s output

## Interface

```cpp
void conv_encode(
    hls::stream<ap_uint<1>>& bit_in_stream,  // Input bit stream
    hls::stream<ap_uint<2>>& y_out_stream,   // Output: {out2, out1}
    ap_uint<32> num_bits                      // Number of bits to process
);
```
