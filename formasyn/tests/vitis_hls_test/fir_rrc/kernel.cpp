#include "kernel.h"
#include <ap_int.h>
#include <cmath>

// FIR RRC (Root Raised Cosine) Filter - FormulaGraph Implementation
//
// RRC filter is used for pulse shaping in digital communications
// Coefficients are pre-computed based on:
//   - sps: samples per symbol (4)
//   - span: filter span in symbols (8)
//   - alpha: roll-off factor (0.35)
// Total taps = sps * span + 1 = 33

void kernel(ap_int<16> x_in, ap_int<16>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    const int TAPS = 33;        // sps(4) * span(8) + 1 = 33
    const int DATA_WIDTH = 16;
    const int COEFF_WIDTH = 16;
    const int ACC_WIDTH = DATA_WIDTH + COEFF_WIDTH + 8;
    
    // Pre-computed RRC coefficients (alpha=0.35, sps=4, span=8)
    // Normalized to Q15 format (max coefficient ≈ 0.5 -> ~16384)
    const ap_int<16> coeffs[TAPS] = {
        -12, -28, -45, -48, -24, 40, 136, 254,
        363, 427, 416, 322, 161, -38, -228, -360,
        -403, -360, -228, -38, 161, 322, 416, 427,
        363, 254, 136, 40, -24, -48, -45, -28, -12
    };
    #pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    // Shift register for delay line
    static ap_int<16> shift_reg[TAPS];
    #pragma HLS ARRAY_PARTITION variable=shift_reg complete
    
    // Update shift register
    for (int i = TAPS - 1; i > 0; i--) {
        #pragma HLS UNROLL
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;
    
    // Map: Multiply each tap with coefficient
    ap_int<32> products[TAPS];
    #pragma HLS ARRAY_PARTITION variable=products complete
    
    for (int i = 0; i < TAPS; i++) {
        #pragma HLS UNROLL
        products[i] = shift_reg[i] * coeffs[i];
    }
    
    // Reduce: Sum all products
    ap_int<ACC_WIDTH> acc = 0;
    for (int i = 0; i < TAPS; i++) {
        #pragma HLS UNROLL
        acc += products[i];
    }
    
    // Saturate to 16-bit output
    ap_int<16> result;
    ap_int<16> max_val = 32767;
    ap_int<16> min_val = -32768;
    
    if (acc > max_val) {
        result = max_val;
    } else if (acc < min_val) {
        result = min_val;
    } else {
        result = acc;
    }
    
    y_out = result;
}
