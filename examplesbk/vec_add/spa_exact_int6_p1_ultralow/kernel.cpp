#include <ap_int.h>
#include <ap_fixed.h>
#include "kernel.h"

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_int<9>  c[16]
) {
#pragma HLS INTERFACE bram port=a
#pragma HLS INTERFACE bram port=b
#pragma HLS INTERFACE bram port=c
#pragma HLS INTERFACE s_axilite port=return

    vec_add_loop:
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=17
        ap_int<12> sum = (ap_int<12>)a[i] + (ap_int<12>)b[i];
        // Saturate to ap_int<9> range [-256, 255]
        ap_int<9> sat;
        if (sum > ap_int<12>(255))
            sat = ap_int<9>(255);
        else if (sum < ap_int<12>(-256))
            sat = ap_int<9>(-256);
        else
            sat = (ap_int<9>)sum;
        c[i] = sat;
    }
}
