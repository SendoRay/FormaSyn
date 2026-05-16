#include <ap_int.h>
#include <ap_fixed.h>
#include "kernel.h"

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<7> c[16]
) {
#pragma HLS INTERFACE ap_none port=a
#pragma HLS INTERFACE ap_none port=b
#pragma HLS INTERFACE ap_none port=c
#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS ARRAY_PARTITION variable=a complete dim=1
#pragma HLS ARRAY_PARTITION variable=b complete dim=1
#pragma HLS ARRAY_PARTITION variable=c complete dim=1

    VEC_ADD_LOOP:
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL factor=16
        ap_int<9> sum = (ap_int<9>)a[i] + (ap_int<9>)b[i];
        c[i] = (ap_int<7>)sum;
    }
}
