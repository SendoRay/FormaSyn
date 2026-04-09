#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// FIR Halfband Filter - Optimized for halfband symmetry
// Halfband filters have zeros at every other coefficient except center
// This reduces multiplications by ~50%
//
// FormulaGraph equivalent:
//   non_zero = [i for i in range(taps) if h[i]!=0 or i==taps//2]
//   ShiftReg(input_ref=x, taps=non_zero, output_ref="d")
//   Map(input_ref="d", func="multiply", func_params={"coeffs": h_eff}, output_ref="p")
//   Reduce(input_refs=["p"], op="add", output_ref="y")
//
// Parameters:
//   x_in: input sample (ap_int<16>)
//   y_out: output sample (ap_int<16>)
// Uses 17-tap halfband with 9 non-zero coefficients
void kernel(ap_int<16> x_in, ap_int<16>& y_out);

#endif // KERNEL_H
