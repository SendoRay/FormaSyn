#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<8> c[16]
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
        // Saturation guard: clamp to ap_int<8> range [-128, 127]
        if (sum > 127) {
            c[i] = (ap_int<8>)127;
        } else if (sum < -128) {
            c[i] = (ap_int<8>)-128;
        } else {
            c[i] = (ap_int<8>)sum;
        }
    }
}
