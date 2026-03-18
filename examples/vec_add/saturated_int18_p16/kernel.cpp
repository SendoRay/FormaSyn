#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<8> c_scale[16]
) {
    #pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem0
    #pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem1
    #pragma HLS INTERFACE m_axi port=c_scale offset=slave bundle=gmem2
    #pragma HLS INTERFACE s_axilite port=a
    #pragma HLS INTERFACE s_axilite port=b
    #pragma HLS INTERFACE s_axilite port=c_scale
    #pragma HLS INTERFACE s_axilite port=return

    ap_int<18> c[16];
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=2

    // Node: c (add operation)
    LOOP_ADD: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        ap_int<18> sum = a[i] + b[i];
        if (sum > 131071) sum = 131071;
        if (sum < -131072) sum = -131072;
        c[i] = sum;
    }

    // Node: c_scale (multiply operation)
    LOOP_SCALE: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        ap_int<18> scaled = (c[i] * 3) >> 2;
        if (scaled > 127) scaled = 127;
        if (scaled < -128) scaled = -128;
        c_scale[i] = (ap_int<8>)scaled;
    }
}
