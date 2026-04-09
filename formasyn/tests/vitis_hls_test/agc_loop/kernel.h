#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// AGC Loop - Automatic Gain Control with Feedback
// 
// FormulaGraph equivalent:
//   Cycle(
//     input_ref="x",
//     body=[
//       abs -> subtract_from(target) -> multiply(mu) -> add(g_d1) -> clamp -> multiply(x)
//     ],
//     feedback_refs={"g" -> "g_d1"},
//     output_ref="y"
//   )
//
// This implementation uses a feedback loop for adaptive gain control
// Target II=1 with 2 DSP utilization
//
// Parameters:
//   x_in: input sample (ap_int<16>)
//   y_out: output sample (ap_int<16>)
void kernel(ap_int<16> x_in, ap_int<16>& y_out);

#endif // KERNEL_H
