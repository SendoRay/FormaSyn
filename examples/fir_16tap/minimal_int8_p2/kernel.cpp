#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> x_in, ap_int<8>& y_out_scale) {
    #pragma HLS INTERFACE ap_ctrl_none port=return
    #pragma HLS INTERFACE ap_none port=x_in
    #pragma HLS INTERFACE ap_none port=y_out_scale
    #pragma HLS PIPELINE II=1
    
    static ap_int<8> taps[16];
    #pragma HLS ARRAY_PARTITION variable=taps cyclic factor=2
    
    static ap_int<8> coeffs[16] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
    #pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    // Shift register operation
    for (int i = 15; i > 0; i--) {
        #pragma HLS UNROLL factor=2
        taps[i] = taps[i-1];
    }
    taps[0] = x_in;
    
    // Map: multiply taps with coefficients
    ap_int<16> products[16];
    #pragma HLS ARRAY_PARTITION variable=products cyclic factor=2
    
    for (int i = 0; i < 16; i++) {
        #pragma HLS UNROLL factor=2
        products[i] = taps[i] * coeffs[i];
    }
    
    // Reduce: sum all products
    ap_int<16> y_out = 0;
    for (int i = 0; i < 16; i++) {
        #pragma HLS UNROLL factor=2
        y_out += products[i];
    }
    
    // Scale output by 0.75
    ap_int<16> scaled = (y_out * 3) >> 2;
    
    // Saturate to 8-bit range
    if (scaled > 127) {
        y_out_scale = 127;
    } else if (scaled < -128) {
        y_out_scale = -128;
    } else {
        y_out_scale = scaled;
    }
}
