# Complex FIR Filter

8-tap Complex FIR filter with 4-real-multiply complex multiplication.

## Algorithm

Complex FIR implements the following formula:
```
y[n] = sum(k=0 to 7) h[k] * x[n-k]
```

Where both `h` and `x` are complex numbers.

### Complex Multiplication

Using 4 real multiplies per complex multiply:
```
I_out = I*hr - Q*hi
Q_out = I*hi + Q*hr
```

Where:
- `I` = real input, `Q` = imaginary input
- `hr` = real coefficient, `hi` = imaginary coefficient

## FormulaGraph Structure

```
ShiftReg(input_ref=x_real, taps=[0-7], output_ref="d_r")
ShiftReg(input_ref=x_imag, taps=[0-7], output_ref="d_i")
    -> Map(func="complex_multiply", coeffs=[hr, hi], output_ref="p")
    -> Reduce(op="add", output_ref=["y_real", "y_imag"])
```

## Parameters

- `TAPS`: 8 taps
- `DATA_WIDTH`: 16-bit input/output
- `COEFF_WIDTH`: 16-bit coefficients
- Coefficients are symmetric low-pass filter

## Quality Metrics

- **NMSE**: ≤ -30 dB

## HLS Directives

- `PIPELINE II=1`: Target initiation interval of 1 cycle
- `ARRAY_PARTITION complete`: All arrays fully partitioned for parallel access
- `UNROLL`: All loops unrolled

## Build & Test Commands

```bash
# C Simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --csim

# Synthesis
v++ -c --mode hls --config hls_config.cfg --work_dir work --csynth

# Co-simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --cosim
```
