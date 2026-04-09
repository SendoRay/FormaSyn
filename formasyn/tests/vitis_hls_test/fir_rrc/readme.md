# FIR RRC (Root Raised Cosine) Filter

FormulaGraph implementation of a Root Raised Cosine FIR filter for pulse shaping.

## Parameters

- **sps (samples per symbol)**: 4
- **span (filter span)**: 8 symbols
- **alpha (roll-off factor)**: 0.35
- **Total taps**: sps * span + 1 = 33

## FormulaGraph

```python
def fir_rrc(x, sps, span, alpha):
    taps = sps * span + 1
    h = generate_rrc_coeffs(sps, span, alpha)
    return fir_direct(x, h, taps)
```

## Hardware
- DSP: 17 (using MACC optimization)
- II: 1
