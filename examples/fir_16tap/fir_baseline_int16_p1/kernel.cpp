#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> x_in, ap_int<16>& y_out) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=x_in
#pragma HLS INTERFACE ap_none port=y_out
#pragma HLS PIPELINE II=1

    static ap_int<8> taps[16];
#pragma HLS ARRAY_PARTITION variable=taps complete
    
    static const ap_int<8> coeffs[16] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
#pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    // Shift register
    for (int i = 15; i > 0; i--) {
#pragma HLS UNROLL
        taps[i] = taps[i-1];
    }
    taps[0] = x_in;
    
    // Multiply and accumulate
    ap_int<16> acc = 0;
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL
        acc += taps[i] * coeffs[i];
    }
    
    y_out = acc;
}
