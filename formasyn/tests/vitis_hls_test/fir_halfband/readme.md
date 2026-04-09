# FIR Halfband Filter

FormulaGraph implementation of a halfband FIR filter with optimization.

## Algorithm

Halfband filters have special properties:
- Every other coefficient is zero (except center tap)
- Coefficients are symmetric: h[i] = h[N-1-i]

For a 17-tap halfband filter:
- Only 9 coefficients are non-zero
- Non-zero indices: 0, 2, 4, 6, 8, 10, 12, 14, 16
- This reduces DSP usage from 17 to effectively 5 (using symmetry)

## FormulaGraph

```python
def fir_halfband(x, h_eff, taps):
    non_zero = [i for i in range(taps) if h[i]!=0 or i==taps//2]
    return FormulaGraph([
        ShiftReg(input_ref=x, taps=non_zero, output_ref="d"),
        Map(input_ref="d", func="multiply", func_params={"coeffs": h_eff}, output_ref="p"),
        Reduce(input_refs=["p"], op="add", output_ref="y")
    ])
```

## Hardware
- DSP: ~5 (exploiting symmetry)
- II: 1
