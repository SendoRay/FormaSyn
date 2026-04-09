#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// Fixed-Point Quantizer
// 
// FormulaGraph equivalent:
//   Map(input_ref="x_in", func="quantize", 
//       func_params={"bits": bits, "frac": frac}, output_ref="y_out")
//
// Quantizes input to specified bit-width and fractional precision.
// Applies saturation and rounding.
//
// Parameters:
//   x_in: input value (ap_int<32>)
//   bits: output bit-width (ap_uint<5>, 1-32)
//   frac: number of fractional bits (ap_uint<5>, 0-bits)
//   y_out: quantized output (ap_int<32>)
void kernel(ap_int<32> x_in, ap_uint<5> bits, ap_uint<5> frac, ap_int<32>& y_out);

#endif // KERNEL_H
