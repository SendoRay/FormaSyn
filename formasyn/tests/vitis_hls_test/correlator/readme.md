# Correlator (Matched Filter)

FormulaGraph implementation of a correlator (matched filter) for synchronization applications with the following structure:

```
ShiftReg(input_ref=x, taps=list(range(16)), output_ref="d")
    -> Map(input_ref="d", func="multiply", func_params={"coeffs": preamble}, output_ref="p")
    -> Reduce(input_refs=["p"], op="add", domain=Domain("all"), output_ref="y")
```

## Algorithm

The correlator performs matched filtering by correlating the input signal with a known preamble sequence. This is essential for:
- Frame synchronization in digital communications
- Packet detection in wireless systems
- Timing recovery

1. **ShiftReg**: Maintains a delay line of `TAPS` (16) samples. On each cycle, the new input shifts in and older samples shift down.

2. **Map(multiply)**: Each delayed sample is multiplied by its corresponding preamble coefficient (+1 or -1).

3. **Reduce(add)**: All products are summed together to produce the correlation output.

## Preamble Sequence

The 16-tap preamble used for correlation:
```
[1, 1, 1, 1, -1, -1, 1, -1, 1, -1, -1, 1, 1, -1, 1, 1]
```

This Barker-like sequence provides good autocorrelation properties with low sidelobes.

## Parameters

- `TAPS`: Number of correlator taps (16)
- `DATA_WIDTH`: Input data width (16 bits)
- `COEFF_WIDTH`: Preamble coefficient width (2 bits, values are ±1)
- `OUTPUT_WIDTH`: Correlation output width (32 bits) - wider to prevent overflow during accumulation

## Validation Target

- **NMSE ≤ -45 dB**: Normalized Mean Square Error target for correlation accuracy

## HLS Directives

- `PIPELINE II=1`: Target initiation interval of 1 cycle
- `ARRAY_PARTITION complete`: All arrays fully partitioned for parallel access
- `UNROLL`: All loops unrolled for maximum parallelism

## Build & Test Commands

```bash
# C Simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --csim

# Synthesis
v++ -c --mode hls --config hls_config.cfg --work_dir work --csynth

# Co-simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --cosim
```

## Expected Behavior

When the input signal contains the preamble sequence, the correlator output will produce a sharp peak at the alignment point, enabling reliable synchronization detection.
