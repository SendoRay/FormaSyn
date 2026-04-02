#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_int<16> c[16]) {
#pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem0
#pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem1
#pragma HLS INTERFACE m_axi port=c offset=slave bundle=gmem2
#pragma HLS INTERFACE s_axilite port=a bundle=control
#pragma HLS INTERFACE s_axilite port=b bundle=control
#pragma HLS INTERFACE s_axilite port=c bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    ap_int<8> a_local[16];
    ap_int<8> b_local[16];
    ap_int<16> c_local[16];
#pragma HLS ARRAY_PARTITION variable=a_local complete dim=1
#pragma HLS ARRAY_PARTITION variable=b_local complete dim=1
#pragma HLS ARRAY_PARTITION variable=c_local complete dim=1

    // Load input a
    load_a: for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=1
#pragma HLS UNROLL factor=16
        a_local[i] = a[i];
    }

    // Load input b
    load_b: for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=1
#pragma HLS UNROLL factor=16
        b_local[i] = b[i];
    }

    // Compute: c = a + b
    compute: for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=1
#pragma HLS UNROLL factor=16
        c_local[i] = a_local[i] + b_local[i];
    }

    // Store output c
    store_c: for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=1
#pragma HLS UNROLL factor=16
        c[i] = c_local[i];
    }
}
