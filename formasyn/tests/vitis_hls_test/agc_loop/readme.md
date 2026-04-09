# AGC Loop - Automatic Gain Control with Feedback

FormulaGraph implementation of an automatic gain control (AGC) loop with feedback:

```
Cycle(
  input_ref="x",
  body=[
    abs(x) -> subtract_from(target) -> multiply(mu) -> add(g_d1) -> clamp -> multiply(x)
  ],
  feedback_refs={"g" -> "g_d1"},
  output_ref="y"
)
```

## Algorithm

The AGC loop maintains a gain value that adapts to keep the output signal magnitude near a target value:

1. **abs**: Compute absolute value of input signal `|x|`

2. **subtract_from(target)**: Compute error `e = target - |x|`
   - If `|x| < target`, error is positive -> gain should increase
   - If `|x| > target`, error is negative -> gain should decrease

3. **multiply(mu)**: Scale error by step size `delta = mu * e`
   - Smaller `mu` = slower but more stable convergence
   - Larger `mu` = faster but potentially unstable

4. **add(g_d1)**: Update gain using feedback `g = g_d1 + delta`
   - `g_d1` is the previous gain value (feedback state)

5. **clamp**: Limit gain to valid range `[MIN_GAIN, MAX_GAIN]`
   - Prevents gain from going to zero or overflowing

6. **multiply(x)**: Apply gain to input `y = x * g_clamped`

## Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| `target_magnitude` | 1000 | Target output signal magnitude |
| `mu` | 0.01 | Step size for gain adaptation |
| `max_gain` | 8.0 | Maximum allowed gain |
| `min_gain` | 0.125 | Minimum allowed gain |
| `data_width` | 16 | Input/output data width (bits) |
| `convergence_time` | <=1000 samples | Target convergence time |

## Implementation Details

### Feedback Pattern (Cycle)

The static variable `gain_state` implements the feedback loop:
- Read `g_d1` = previous gain value (from `gain_state`)
- Compute new gain `g` based on error
- Write `g` back to `gain_state` for next iteration

This creates the cycle pattern: `g -> g_d1`

### Fixed-Point Types

- `gain_t`: `ap_fixed<16,4>` - Gain value with 4 integer bits
- `error_t`: `ap_fixed<16,14>` - Error signal
- `prod_t`: `ap_fixed<32,20>` - Product for multiplication

### HLS Directives

- `PIPELINE II=1`: Target initiation interval of 1 cycle
- `RESET variable=gain_state`: Ensure proper reset of feedback state

## Build & Test Commands

```bash
# C Simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --csim

# Synthesis
v++ -c --mode hls --config hls_config.cfg --work_dir work --csynth

# Co-simulation
v++ -c --mode hls --config hls_config.cfg --work_dir work --cosim
```

## Resource Target

- **DSP**: 2 (for multiplications)
- **FF/LUT**: Minimal (feedback state and arithmetic)
- **II**: 1 cycle
