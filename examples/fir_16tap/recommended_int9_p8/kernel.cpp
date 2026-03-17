#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> x_in) {
    #pragma HLS INTERFACE ap_ctrl_none port=return
    #pragma HLS INTERFACE ap_none port=x_in
    #pragma HLS PIPELINE II=2
    
    // Shift register for taps (16 elements)
    static ap_int<8> taps[16];
    #pragma HLS ARRAY_PARTITION variable=taps cyclic factor=2
    
    // Shift operation
    for (int i = 15; i > 0; i--) {
        #pragma HLS UNROLL factor=8
        taps[i] = taps[i-1];
    }
    taps[0] = x_in;
    
    // FIR coefficients (example values, adjust as needed)
    static const ap_int<8> coeffs[16] = {1, 2, 3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3, 2, 1};
    #pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    // Multiply and accumulate
    ap_int<12> y_out = 0;
    for (int i = 0; i < 16; i++) {
        #pragma HLS UNROLL factor=8
        y_out += taps[i] * coeffs[i];
    }
}
