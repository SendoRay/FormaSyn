# Vitis HLS Filter Implementations

## Summary

| Filter | Type | Taps/Sections | DSP | II | Status |
|--------|------|---------------|-----|-----|--------|
| fir_halfband | FIR (optimized) | 17 taps, 9 non-zero | ~5 | 1 | ✅ PASS |
| fir_rrc | FIR | 33 taps | ~17 | 1 | ✅ PASS |
| iir_biquad | IIR (biquad) | 1 section | 5 | 1 | ✅ PASS |
| iir_cascade | IIR (cascade) | 2 sections | 10 | 1 | ✅ PASS |

## Filter Details

### 1. FIR Halfband (`fir_halfband/`)
- **Optimization**: Exploits halfband property (every other coefficient is zero)
- **FormulaGraph**: `ShiftReg(taps=non_zero) -> Map(multiply) -> Reduce(add)`
- **Hardware**: Symmetric pairs reduce multiplies by 50%
- **Coefficients**: 17-tap with 9 non-zero values

### 2. FIR RRC (`fir_rrc/`)
- **Purpose**: Root Raised Cosine pulse shaping
- **FormulaGraph**: Same as `fir_direct` with RRC coefficients
- **Parameters**: sps=4, span=8, alpha=0.35 → 33 taps
- **Hardware**: Standard FIR structure

### 3. IIR Biquad (`iir_biquad/`)
- **Structure**: Direct Form II (efficient)
- **FormulaGraph**: `Cycle(Maps -> Reduce, feedback_edges=[...])`
- **Transfer Function**: H(z) = (b0 + b1·z⁻¹ + b2·z⁻²) / (1 + a1·z⁻¹ + a2·z⁻²)
- **State**: w[n-1], w[n-2] (feedback)
- **Hardware**: 5 DSP (2 feedback + 3 feedforward)

### 4. IIR Cascade (`iir_cascade/`)
- **Structure**: 2 biquad sections in series
- **FormulaGraph**: `[Cycle(...) for _ in sections]`
- **Hardware**: 5 × M DSP (M sections)
- **Benefits**: Better stability than single high-order IIR

## Build & Test

```bash
# C Simulation
g++ -std=c++11 -I$XILINX_VITIS/include -o test kernel.cpp kernel_tb.cpp
./test

# HLS Synthesis
v++ -c --mode hls --config hls_config.cfg --work_dir work

# Co-simulation
vitis-run --mode hls --cosim --config hls_config.cfg --work_dir work
```
