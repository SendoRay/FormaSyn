#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// FIR Direct Form - Generic FIR Filter
// 
// FormulaGraph equivalent:
//   ShiftReg(input_ref=x, taps=list(range(taps)), output_ref="d")
//   Map(input_ref="d", func="multiply", func_params={"coeffs": h}, output_ref="p")
//   Reduce(input_refs=["p"], op="add", domain=Domain("all"), output_ref="y")
//
// This implementation uses fixed internal coefficients for optimal II=1
//
// Parameters:
//   x_in: input sample (ap_int<16>)
//   y_out: output sample (ap_int<16>)
void kernel(ap_int<16> x_in, ap_int<16>& y_out);

#endif // KERNEL_H
