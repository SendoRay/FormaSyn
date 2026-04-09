# FIR Direct Form Filter

FormulaGraph implementation of a direct-form FIR filter with the following structure:

```
ShiftReg(input_ref=x, taps=list(range(taps)), output_ref="d")
    -> Map(input_ref="d", func="multiply", func_params={"coeffs": h}, output_ref="p")
    -> Reduce(input_refs=["p"], op="add", domain=Domain("all"), output_ref="y")
```

## Algorithm

1. **ShiftReg**: Maintains a delay line of `TAPS` samples. On each cycle, the new input shifts in and older samples shift down.

2. **Map(multiply)**: Each delayed sample is multiplied by its corresponding coefficient from coefficient array `h`.

3. **Reduce(add)**: All products are summed together to produce the final output.

## Parameters

- `TAPS`: Number of filter taps (default: 16)
- `DATA_WIDTH`: Input/output data width (default: 16 bits)
- `COEFF_WIDTH`: Coefficient width (default: 16 bits)

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
