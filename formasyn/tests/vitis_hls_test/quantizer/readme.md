# Fixed-Point Quantizer

Configurable fixed-point quantizer with saturation and rounding.

## Algorithm

The quantizer performs the following operations:

1. **Range Calculation**: Compute min/max values for target bit-width
   - Signed range: [-2^(bits-1), 2^(bits-1)-1]

2. **Saturation**: Clamp input to target range

3. **Output**: Return quantized value

## FormulaGraph Structure

```
Map(input_ref="x_in", func="quantize", 
    func_params={"bits": bits, "frac": frac}, output_ref="y_out")
```

## Parameters

- `x_in`: Input value (32-bit signed)
- `bits`: Target bit-width (1-32)
- `frac`: Number of fractional bits (configurable, 0-bits)
- `y_out`: Quantized output (32-bit signed)

## Quality Metrics

- **SQNR**: ≥ 6*bits dB (theoretical quantization noise)
  - 8-bit: ≥ 48 dB
  - 12-bit: ≥ 72 dB
  - 16-bit: ≥ 96 dB

## Implementation Notes

- Supports dynamic bit-width configuration at runtime
- Handles edge cases: overflow, underflow
- Zero-latency operation

## HLS Directives

- `PIPELINE II=1`: Target initiation interval of 1 cycle

## Build & Test Commands

```bash
# C Simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --csim

# Synthesis
v++ -c --mode hls --config hls_config.cfg --work_dir work --csynth

# Co-simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --cosim
```
