# PLL Carrier Recovery

FormulaGraph implementation of a Phase-Locked Loop (PLL) for carrier recovery with the following structure:

```
Cycle(
    body=[
        Map("x", "phase_rotate", {"phase":"theta_d1"}, "y"),
        Map("y", "phase_error", {}, "e"),
        Map("e", "multiply", {"coeff":kp}, "pt"),
        Map("e", "multiply", {"coeff":ki}, "id"),
        Reduce(["is_d1","id"], "add", {}, "it"),
        Reduce(["theta_d1","pt","it"], "add", {}, "th"),
        Map("th", "wrap_phase", {}, "tn")
    ],
    feedback_edges=[Edge("tn","theta_d1",1), Edge("it","is_d1",1)]
)
```

## Algorithm

1. **NCO (Numerically Controlled Oscillator)**: Generates sin/cos from phase estimate using Taylor series approximation
2. **phase_rotate**: Complex multiplication to derotate the input signal
3. **phase_error**: Decision-directed phase error estimation
4. **Loop Filter**: PI controller (proportional + integral)
5. **wrap_phase**: Phase accumulator with wrapping to [-π, π]

## Parameters

- `KP`: Proportional gain (default: 0.1)
- `KI`: Integral gain (default: 0.01)
- `DATA_WIDTH`: Input/output data width (16 bits)
- `PHASE_WIDTH`: Phase accumulator width (16 bits)

## HLS Directives

- `PIPELINE II=1`: Target initiation interval of 1 cycle
- `RESET`: Static variables for feedback state

## Build & Test Commands

```bash
# C Simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --csim

# Synthesis
v++ -c --mode hls --config hls_config.cfg --work_dir work --csynth

# Co-simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --cosim
```

## Validation

- Lock time ≤ 1000 symbols
- Phase error < 5° at steady state
