#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// Complex FIR Filter - 8 Taps
// 
// FormulaGraph equivalent:
//   ShiftReg(input_ref=x_real, taps=list(range(8)), output_ref="d_r")
//   ShiftReg(input_ref=x_imag, taps=list(range(8)), output_ref="d_i")
//   Map(input_refs=["d_r", "d_i"], func="complex_multiply", 
//       func_params={"coeffs_real": hr, "coeffs_imag": hi}, output_ref="p")
//   Reduce(input_refs=["p_real"], op="add", domain=Domain("all"), output_ref="y_real")
//   Reduce(input_refs=["p_imag"], op="add", domain=Domain("all"), output_ref="y_imag")
//
// Complex multiply using 4 real multiplies:
//   y_real = I*hr - Q*hi
//   y_imag = I*hi + Q*hr
//
// Parameters:
//   x_real: real input sample (ap_int<16>)
//   x_imag: imaginary input sample (ap_int<16>)
//   y_real: real output sample (ap_int<16>)
//   y_imag: imaginary output sample (ap_int<16>)
void kernel(ap_int<16> x_real, ap_int<16> x_imag, ap_int<16>& y_real, ap_int<16>& y_imag);

#endif // KERNEL_H
