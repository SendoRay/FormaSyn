#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

// Fixed-Point Scaler (Gain Multiplier)
// 
// FormulaGraph equivalent:
//   Map(input_ref="x_in", func="multiply",
//       func_params={"gain": gain, "frac_bits": 14}, output_ref="y_out")
//
// Algorithm:
//   1. Multiply: prod = x_in * gain (32-bit result)
//   2. Normalize: result = prod >> 14 (compensate for Q1.14 format)
//   3. Saturate: clamp to 16-bit range
//
// Gain format: Q1.14 (1 integer bit, 14 fractional bits)
//   Range: [-2.0, 2.0 - 2^-14)
//   Resolution: 2^-14 ≈ 6.1e-5
//
// Target: NMSE <= -50 dB
void kernel(ap_int<16> x_in, ap_int<16> gain, ap_int<16>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=gain bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // Constants
    const int FRAC_BITS = 14;  // Q1.14 format
    const int DATA_WIDTH = 16;
    
    typedef ap_int<DATA_WIDTH> data_t;
    typedef ap_int<DATA_WIDTH * 2> prod_t;
    
    // Step 1: Multiply input by gain
    // Result is 32-bit with 14 fractional bits
    prod_t prod = (prod_t)x_in * (prod_t)gain;
    
    // Step 2: Normalize by shifting right by FRAC_BITS
    // This brings the result back to the original Q format
    // Add rounding: add 0.5 (1 << (FRAC_BITS-1)) before shifting
    prod_t rounding = (prod_t)1 << (FRAC_BITS - 1);
    prod_t prod_rounded = prod + rounding;
    
    // Right shift to normalize
    ap_int<DATA_WIDTH + 2> normalized = (ap_int<DATA_WIDTH + 2>)(prod_rounded >> FRAC_BITS);
    
    // Step 3: Saturate to output width
    data_t max_val = 32767;   // (1 << 15) - 1
    data_t min_val = -32768;  // -(1 << 15)
    
    data_t result;
    if (normalized > max_val) {
        result = max_val;
    } else if (normalized < min_val) {
        result = min_val;
    } else {
        result = (data_t)normalized;
    }
    
    y_out = result;
}
