#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_int<9>  c[16]
) {
#pragma HLS INTERFACE ap_none port=a
#pragma HLS INTERFACE ap_none port=b
#pragma HLS INTERFACE ap_none port=c
#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS ARRAY_PARTITION variable=a complete dim=1
#pragma HLS ARRAY_PARTITION variable=b complete dim=1
#pragma HLS ARRAY_PARTITION variable=c complete dim=1

    // Saturation limits for ap_int<9>: [-256, 255]
    const ap_int<9> SAT_MAX = 255;
    const ap_int<9> SAT_MIN = -256;

VEC_ADD_LOOP:
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL factor=16
#pragma HLS PIPELINE II=1
        ap_int<12> sum = (ap_int<12>)a[i] + (ap_int<12>)b[i];
        // Saturation guard
        if (sum > (ap_int<12>)SAT_MAX) {
            c[i] = SAT_MAX;
        } else if (sum < (ap_int<12>)SAT_MIN) {
            c[i] = SAT_MIN;
        } else {
            c[i] = (ap_int<9>)sum;
        }
    }
}
