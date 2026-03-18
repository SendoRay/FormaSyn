#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<32> a[16],
    ap_int<32> b[16],
    ap_int<8> c_scale[16]
) {
    #pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem0
    #pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem1
    #pragma HLS INTERFACE m_axi port=c_scale offset=slave bundle=gmem2
    #pragma HLS INTERFACE s_axilite port=a bundle=control
    #pragma HLS INTERFACE s_axilite port=b bundle=control
    #pragma HLS INTERFACE s_axilite port=c_scale bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

    ap_int<32> a_local[16];
    ap_int<32> b_local[16];
    ap_int<32> c_local[16];
    ap_int<8> c_scale_local[16];

    #pragma HLS ARRAY_PARTITION variable=a_local cyclic factor=2
    #pragma HLS ARRAY_PARTITION variable=b_local cyclic factor=2
    #pragma HLS ARRAY_PARTITION variable=c_local cyclic factor=2
    #pragma HLS ARRAY_PARTITION variable=c_scale_local cyclic factor=2

    // Load inputs
    load_a: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        a_local[i] = a[i];
    }

    load_b: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        b_local[i] = b[i];
    }

    // Compute c = a + b
    compute_c: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        c_local[i] = a_local[i] + b_local[i];
    }

    // Compute c_scale = c * 0.75
    compute_c_scale: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        ap_int<32> temp = (c_local[i] * 3) >> 2;
        if (temp > 127) {
            c_scale_local[i] = 127;
        } else if (temp < -128) {
            c_scale_local[i] = -128;
        } else {
            c_scale_local[i] = (ap_int<8>)temp;
        }
    }

    // Store output
    store_c_scale: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        c_scale[i] = c_scale_local[i];
    }
}
