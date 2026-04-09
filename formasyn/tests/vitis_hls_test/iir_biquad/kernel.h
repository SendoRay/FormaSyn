#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// IIR Biquad Filter (Direct Form II)
// Second-order IIR section with feedback
//
// FormulaGraph equivalent:
//   Cycle(
//     body=[
//       Map("x", "multiply", {"coeff":b[0]}, "xf0"),
//       Map("x_d1", "multiply", {"coeff":b[1]}, "xf1"),
//       Map("x_d2", "multiply", {"coeff":b[2]}, "xf2"),
//       Map("y_d1", "multiply", {"coeff":-a[0]}, "yb1"),
//       Map("y_d2", "multiply", {"coeff":-a[1]}, "yb2"),
//       Reduce(["xf0","xf1","xf2","yb1","yb2"], "add", Domain("all"), "y")
//     ],
//     feedback_edges=[
//       Edge("y","y_d1",1), Edge("y_d1","y_d2",1),
//       Edge("x","x_d1",1), Edge("x_d1","x_d2",1)
//     ]
//   )
//
// Hardware: 5 DSP/section
// Verification: NMSE <= -40 dB (poles |p|<1 required)
//
// Parameters:
//   x_in: input sample (ap_int<16>)
//   y_out: output sample (ap_int<16>)
void kernel(ap_int<16> x_in, ap_int<16>& y_out);

#endif // KERNEL_H
