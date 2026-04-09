# IIR Cascade of Biquad Sections

FormulaGraph implementation of cascaded second-order IIR sections.

## Structure

```
x -> [Biquad 1] -> [Biquad 2] -> ... -> [Biquad M] -> y
```

Each biquad implements:
```
H_i(z) = (b0_i + b1_i*z^-1 + b2_i*z^-2) / (1 + a1_i*z^-1 + a2_i*z^-2)
```

## FormulaGraph

```python
def iir_cascade(x, sections):
    return FormulaGraph([Cycle(...) for _ in sections])
```

## Benefits
- Better numerical stability than single high-order IIR
- Easier coefficient tuning
- Modular design

## Hardware
- DSP: 5 × M (M sections)
- This implementation: 2 sections = 10 DSP
- II: 1

## Verification
- NMSE <= -40 dB required
- Check all poles |p| < 1 for stability
