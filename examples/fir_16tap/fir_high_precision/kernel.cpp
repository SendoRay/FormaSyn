#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> x_in, ap_int<18>& y_out) {
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=x_in
#pragma HLS INTERFACE ap_none port=y_out
#pragma HLS PIPELINE II=1

    // Shift register for 16 taps
    static ap_int<8> shift_reg[16];
#pragma HLS ARRAY_PARTITION variable=shift_reg complete dim=1

    // Coefficients (placeholder values, adjust as needed)
    const ap_int<8> coeff[16] = {1, 2, 3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3, 2, 1};
#pragma HLS ARRAY_PARTITION variable=coeff complete dim=1

    // Products array
    ap_int<16> products[16];
#pragma HLS ARRAY_PARTITION variable=products complete dim=1

    // Shift operation
    for (int i = 15; i > 0; i--) {
#pragma HLS UNROLL
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;

    // Multiply (map operation)
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL
        products[i] = shift_reg[i] * coeff[i];
    }

    // Reduce (accumulate)
    ap_int<18> sum = 0;
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL
        sum += products[i];
    }

    y_out = sum;
}
