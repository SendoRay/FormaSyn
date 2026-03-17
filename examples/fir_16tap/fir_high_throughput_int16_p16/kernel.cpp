#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> x_in, ap_int<16>& y_out) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=x_in
#pragma HLS INTERFACE ap_none port=y_out
#pragma HLS PIPELINE II=1

    // Shift register for FIR taps
    static ap_int<8> taps[16];
#pragma HLS ARRAY_PARTITION variable=taps complete

    // FIR coefficients (example values, adjust as needed)
    const ap_int<8> coeffs[16] = {1, 2, 3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3, 2, 1};
#pragma HLS ARRAY_PARTITION variable=coeffs complete

    // Shift operation
    for (int i = 15; i > 0; i--) {
#pragma HLS UNROLL
        taps[i] = taps[i-1];
    }
    taps[0] = x_in;

    // Multiply and accumulate
    ap_int<16> products[16];
#pragma HLS ARRAY_PARTITION variable=products complete

    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL
        products[i] = taps[i] * coeffs[i];
    }

    // Reduction (sum)
    ap_int<16> sum = 0;
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL
        sum += products[i];
    }

    y_out = sum;
}
