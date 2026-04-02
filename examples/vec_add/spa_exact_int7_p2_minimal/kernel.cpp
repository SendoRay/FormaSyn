#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<7> c[16]
) {
#pragma HLS INTERFACE bram port=a
#pragma HLS INTERFACE bram port=b
#pragma HLS INTERFACE bram port=c
#pragma HLS ARRAY_PARTITION variable=a cyclic factor=2 dim=1
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=2 dim=1
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=2 dim=1

    vec_add_loop:
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=9
        ap_int<9> sum = (ap_int<9>)a[i] + (ap_int<9>)b[i];
        // Saturation guard: clamp to ap_int<7> range [-64, 63]
        ap_int<7> sat_val;
        if (sum > ap_int<9>(63)) {
            sat_val = ap_int<7>(63);
        } else if (sum < ap_int<9>(-64)) {
            sat_val = ap_int<7>(-64);
        } else {
            sat_val = (ap_int<7>)sum;
        }
        c[i] = sat_val;
    }
}
