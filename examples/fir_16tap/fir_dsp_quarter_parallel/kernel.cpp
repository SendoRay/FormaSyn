#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> x_in, ap_int<16>& y_out) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=x_in
#pragma HLS INTERFACE ap_none port=y_out
#pragma HLS PIPELINE II=4

    static ap_int<8> taps[16];
#pragma HLS ARRAY_PARTITION variable=taps cyclic factor=4
    
    const ap_int<8> coeffs[16] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
#pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    // Shift register
    for (int i = 15; i > 0; i--) {
#pragma HLS UNROLL factor=4
        taps[i] = taps[i-1];
    }
    taps[0] = x_in;
    
    // Multiply and accumulate
    ap_int<16> products[16];
#pragma HLS ARRAY_PARTITION variable=products cyclic factor=4
    
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL factor=4
        products[i] = taps[i] * coeffs[i];
    }
    
    // Reduce sum
    ap_int<16> sum = 0;
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL factor=4
        sum += products[i];
    }
    
    y_out = sum;
}
