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
#pragma HLS INTERFACE s_axilite port=return

    LOOP_VEC_ADD:
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=17
        ap_int<9> tmp = (ap_int<9>)a[i] + (ap_int<9>)b[i];
        // Saturation guard: clamp to ap_int<8> range [-128, 127]
        if (tmp > 127) {
            c[i] = (ap_int<8>)127;
        } else if (tmp < -128) {
            c[i] = (ap_int<8>)-128;
        } else {
            c[i] = (ap_int<8>)tmp;
        }
    }
}
