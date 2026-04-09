#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// Correlator - Matched Filter for Synchronization
// 
// FormulaGraph equivalent:
//   ShiftReg(input_ref=x, taps=list(range(16)), output_ref="d")
//   Map(input_ref="d", func="multiply", func_params={"coeffs": preamble}, output_ref="p")
//   Reduce(input_refs=["p"], op="add", domain=Domain("all"), output_ref="y")
//
// This implementation uses a 16-tap preamble sequence for matched filtering
// Target: NMSE <= -45 dB for synchronization applications
//
// Parameters:
//   x_in: input sample (ap_int<16>)
//   y_out: correlation output (ap_int<32>) - wider for accumulation headroom
void kernel(ap_int<16> x_in, ap_int<32>& y_out);

#endif // KERNEL_H
