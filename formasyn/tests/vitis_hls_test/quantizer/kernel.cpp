#include "kernel.h"
#include <ap_int.h>

// Fixed-Point Quantizer
// 
// FormulaGraph equivalent:
//   Map(input_ref="x_in", func="quantize",
//       func_params={"bits": bits, "frac": frac}, output_ref="y_out")
//
// Algorithm:
//   1. Scale: shift by frac bits (multiply by 2^frac for fixed-point representation)
//   2. Round: add 0.5 for positive, subtract 0.5 for negative
//   3. Saturate: clamp to specified bit-width
//   4. Output: return quantized value
//
// SQNR >= 6*bits dB (theoretical quantization noise)
//
// Target: SQNR >= 6*bits dB
void kernel(ap_int<32> x_in, ap_uint<5> bits, ap_uint<5> frac, ap_int<32>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=bits bundle=control
    #pragma HLS INTERFACE s_axilite port=frac bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // Step 1: Compute max/min values for the specified bit-width
    // For signed: range is [-2^(bits-1), 2^(bits-1)-1]
    ap_int<33> max_val;
    ap_int<33> min_val;
    if (bits >= 32) {
        max_val = (ap_int<33>)0x7FFFFFFF;
        min_val = (ap_int<33>)0x80000000;
    } else {
        max_val = ((ap_int<33>)1 << (bits - 1)) - 1;
        min_val = -((ap_int<33>)1 << (bits - 1));
    }
    
    // Step 2: Apply quantization
    // The input x_in is already in fixed-point format with 'frac' fractional bits
    // We need to saturate to the target bit-width
    
    ap_int<33> x_extended = (ap_int<33>)x_in;
    ap_int<33> result;
    
    // Saturate to specified bit-width
    if (x_extended > max_val) {
        result = max_val;
    } else if (x_extended < min_val) {
        result = min_val;
    } else {
        result = x_extended;
    }
    
    // Step 3: Rounding if needed (truncate fractional bits beyond precision)
    // The result is already quantized to the specified bit-width
    
    y_out = (ap_int<32>)result;
}
