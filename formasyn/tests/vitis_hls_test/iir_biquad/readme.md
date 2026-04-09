# IIR Biquad Filter (Direct Form II)

FormulaGraph implementation of a second-order IIR filter with feedback.

## Transfer Function

```
H(z) = (b0 + b1*z^-1 + b2*z^-2) / (1 + a1*z^-1 + a2*z^-2)
```

## Direct Form II Structure

More efficient implementation using intermediate value w[n]:
```
w[n] = x[n] - a1*w[n-1] - a2*w[n-2]
y[n] = b0*w[n] + b1*w[n-1] + b2*w[n-2]
```

## FormulaGraph (Cycle)

```python
def iir_biquad(x, b, a):
    return FormulaGraph([Cycle(
        body=[
            Map("x", "multiply", {"coeff":b[0]}, "xf0"),
            Map("x_d1", "multiply", {"coeff":b[1]}, "xf1"),
            Map("x_d2", "multiply", {"coeff":b[2]}, "xf2"),
            Map("y_d1", "multiply", {"coeff":-a[0]}, "yb1"),
            Map("y_d2", "multiply", {"coeff":-a[1]}, "yb2"),
            Reduce(["xf0","xf1","xf2","yb1","yb2"], "add", Domain("all"), "y")
        ],
        feedback_edges=[
            Edge("y","y_d1",1), Edge("y_d1","y_d2",1),
            Edge("x","x_d1",1), Edge("x_d1","x_d2",1)
        ]
    )])
```

## Hardware
- DSP: 5 per section (2 for feedback, 3 for feedforward)
- State: 2 registers (w[n-1], w[n-2])
- II: 1

## Verification
- NMSE <= -40 dB required
- Check poles |p| < 1 for stability
