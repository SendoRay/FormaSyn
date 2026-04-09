#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// IIR Cascade of Biquad Sections
// M-section cascade for higher-order filters
//
// FormulaGraph equivalent:
//   def iir_cascade(x, sections):
//       return FormulaGraph([Cycle(...) for _ in sections])
//
// Each section: y_i = H_i(z) * y_{i-1}
// where y_0 = x (input), y_M = y (output)
//
// Hardware: 5*M DSP (M sections)
// Verification: NMSE <= -40 dB
//
// This implementation: 2-section cascade (4th order filter)
// Total DSP: 10
void kernel(ap_int<16> x_in, ap_int<16>& y_out);

#endif // KERNEL_H
