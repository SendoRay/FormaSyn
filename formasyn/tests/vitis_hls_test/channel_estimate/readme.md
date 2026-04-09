# LS Channel Estimator

Least Squares (LS) channel estimator for OFDM/pilot-based systems.

## Algorithm

Implements the LS channel estimation formula:
```
H = rx_pilot * conj(pilot) / |pilot|^2
```

Where:
- `rx_pilot` = received pilot symbol
- `pilot` = known transmitted pilot
- `H` = estimated channel coefficient

### Expanded Form

```
numerator_real = rx_real * p_real + rx_imag * p_imag
numerator_imag = rx_imag * p_real - rx_real * p_imag
denominator = p_real^2 + p_imag^2

h_real = numerator_real / denominator
h_imag = numerator_imag / denominator
```

## FormulaGraph Structure

```
Map(input_refs=["rx_pilot", "pilot"], func="ls_estimate", output_ref="H")
```

## Parameters

- `DATA_WIDTH`: 16-bit input/output
- `NORM_SHIFT`: 14 bits (for QPSK pilots with amplitude ~128)

## Quality Metrics

- **NMSE**: ≤ -20 dB at high SNR

## Implementation Notes

- Division is implemented using fixed-point arithmetic with normalization shift
- Handles division by zero (returns 0)
- Saturates output to 16-bit range

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
