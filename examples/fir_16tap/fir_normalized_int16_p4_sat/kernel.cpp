#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> x_in, ap_int<8>& y_out_scale) {
    #pragma HLS INTERFACE ap_ctrl_none port=return
    #pragma HLS INTERFACE ap_none port=x_in
    #pragma HLS INTERFACE ap_none port=y_out_scale
    #pragma HLS PIPELINE II=4
    
    // Shift register for FIR taps
    static ap_int<8> taps[16];
    #pragma HLS ARRAY_PARTITION variable=taps cyclic factor=4
    
    // Shift operation
    for (int i = 15; i > 0; i--) {
        #pragma HLS UNROLL factor=4
        taps[i] = taps[i-1];
    }
    taps[0] = x_in;
    
    // FIR coefficients (example values, adjust as needed)
    static const ap_int<8> coeffs[16] = {1, 2, 3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3, 2, 1};
    #pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    // Multiply and accumulate
    ap_int<16> products[16];
    #pragma HLS ARRAY_PARTITION variable=products cyclic factor=4
    
    for (int i = 0; i < 16; i++) {
        #pragma HLS UNROLL factor=4
        products[i] = taps[i] * coeffs[i];
    }
    
    // Reduce sum
    ap_int<16> y_out = 0;
    for (int i = 0; i < 16; i++) {
        #pragma HLS UNROLL factor=4
        y_out += products[i];
    }
    
    // Scale by 0.75 (multiply by 3/4)
    ap_int<16> scaled = (y_out * 3) >> 2;
    
    // Saturate to 8-bit output
    if (scaled > 127) {
        y_out_scale = 127;
    } else if (scaled < -128) {
        y_out_scale = -128;
    } else {
        y_out_scale = scaled;
    }
}
