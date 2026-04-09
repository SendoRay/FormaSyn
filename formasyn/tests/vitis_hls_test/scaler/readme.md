# Fixed-Point Scaler (Gain Multiplier)

Fixed-point scalar multiplier for signal scaling applications.

## Algorithm

Implements fixed-point multiplication with gain normalization:

```
y_out = saturate16((x_in * gain + rounding) >> 14)
```

Where:
- `x_in`: 16-bit input signal
- `gain`: 16-bit gain coefficient in Q1.14 format
- `rounding`: 1 << 13 for unbiased rounding
- `saturate16`: Clamp to 16-bit range [-32768, 32767]

## Gain Format

Q1.14 format (1 integer bit, 14 fractional bits):
- Range: [-2.0, 2.0 - 2^-14)
- Resolution: 2^-14 ≈ 6.1e-5
- Unity gain: 0x4000 (16384)

## FormulaGraph Structure

```
Map(input_ref="x_in", func="multiply",
    func_params={"gain": gain, "frac_bits": 14}, output_ref="y_out")
```

## Parameters

- `x_in`: Input value (ap_int<16>)
- `gain`: Gain coefficient in Q1.14 (ap_int<16>)
- `y_out`: Scaled output (ap_int<16>)

## Quality Metrics

- **NMSE**: ≤ -50 dB
- **Precision**: 14 fractional bits

## Implementation Notes

- Uses unbiased rounding (add 0.5 before truncating)
- Handles saturation for overflow/underflow
- Single-cycle latency

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
