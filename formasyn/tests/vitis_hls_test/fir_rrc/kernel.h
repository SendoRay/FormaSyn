#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// FIR RRC (Root Raised Cosine) Filter
// Uses pre-computed RRC coefficients for pulse shaping
//
// FormulaGraph equivalent:
//   taps = sps * span + 1  (e.g., 4 * 8 + 1 = 33 taps)
//   h = generate_rrc_coeffs(sps, span, alpha)
//   return fir_direct(x, h, taps)
//
// Parameters:
//   x_in: input sample (ap_int<16>)
//   y_out: output sample (ap_int<16>)
// Uses 33-tap RRC with roll-off factor 0.35
void kernel(ap_int<16> x_in, ap_int<16>& y_out);

#endif // KERNEL_H
