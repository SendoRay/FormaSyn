#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_int<11> c[16]
) {
#pragma HLS INTERFACE ap_none port=a
#pragma HLS INTERFACE ap_none port=b
#pragma HLS INTERFACE ap_none port=c
#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS ARRAY_PARTITION variable=a complete dim=1
#pragma HLS ARRAY_PARTITION variable=b complete dim=1
#pragma HLS ARRAY_PARTITION variable=c complete dim=1

    // Vector addition with saturation guard
    vec_add_loop:
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL factor=16
        ap_int<12> sum = (ap_int<12>)a[i] + (ap_int<12>)b[i];
        // Saturation: clamp to ap_int<11> range [-1024, 1023]
        if (sum > ap_int<12>(1023)) {
            c[i] = ap_int<11>(1023);
        } else if (sum < ap_int<12>(-1024)) {
            c[i] = ap_int<11>(-1024);
        } else {
            c[i] = (ap_int<11>)sum;
        }
    }
}
