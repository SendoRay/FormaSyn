#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// Fixed-Point Scaler (Gain Multiplier)
// 
// FormulaGraph equivalent:
//   Map(input_ref="x_in", func="multiply",
//       func_params={"gain": gain, "frac_bits": 14}, output_ref="y_out")
//
// Multiplies input by a fixed-point gain coefficient.
// Gain is in Q1.14 format (1 integer bit, 14 fractional bits, range: [-2, 2))
//
// Parameters:
//   x_in: input value (ap_int<16>)
//   gain: gain coefficient in Q1.14 format (ap_int<16>)
//   y_out: scaled output (ap_int<16>)
void kernel(ap_int<16> x_in, ap_int<16> gain, ap_int<16>& y_out);

#endif // KERNEL_H
