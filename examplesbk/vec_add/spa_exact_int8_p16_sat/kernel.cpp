#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<8> c[16]
) {
#pragma HLS INTERFACE ap_memory port=a
#pragma HLS INTERFACE ap_memory port=b
#pragma HLS INTERFACE ap_memory port=c
#pragma HLS ARRAY_PARTITION variable=a complete dim=1
#pragma HLS ARRAY_PARTITION variable=b complete dim=1
#pragma HLS ARRAY_PARTITION variable=c complete dim=1
#pragma HLS PIPELINE II=1

    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL factor=16
        ap_int<9> tmp = (ap_int<9>)a[i] + (ap_int<9>)b[i];
        // Saturation guard for ap_int<8>: clamp to [-128, 127]
        if (tmp > ap_int<9>(127)) {
            c[i] = ap_int<8>(127);
        } else if (tmp < ap_int<9>(-128)) {
            c[i] = ap_int<8>(-128);
        } else {
            c[i] = (ap_int<8>)tmp;
        }
    }
}
