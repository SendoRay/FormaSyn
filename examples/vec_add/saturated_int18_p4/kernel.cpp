#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_int<8> c_scale[16]) {
#pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem0
#pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem1
#pragma HLS INTERFACE m_axi port=c_scale offset=slave bundle=gmem2
#pragma HLS INTERFACE s_axilite port=a
#pragma HLS INTERFACE s_axilite port=b
#pragma HLS INTERFACE s_axilite port=c_scale
#pragma HLS INTERFACE s_axilite port=return

#pragma HLS ARRAY_PARTITION variable=a cyclic factor=4
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=4
#pragma HLS ARRAY_PARTITION variable=c_scale cyclic factor=4

    ap_int<18> c[16];
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=4

    for (int i = 0; i < 16; i += 4) {
#pragma HLS PIPELINE II=4
#pragma HLS UNROLL factor=4
        for (int j = 0; j < 4; j++) {
            int idx = i + j;
            ap_int<18> sum = a[idx] + b[idx];
            if (sum > 131071) sum = 131071;
            if (sum < -131072) sum = -131072;
            c[idx] = sum;
        }
    }

    for (int i = 0; i < 16; i += 4) {
#pragma HLS PIPELINE II=4
#pragma HLS UNROLL factor=4
        for (int j = 0; j < 4; j++) {
            int idx = i + j;
            ap_int<18> scaled = (c[idx] * 3) >> 2;
            if (scaled > 127) scaled = 127;
            if (scaled < -128) scaled = -128;
            c_scale[idx] = scaled;
        }
    }
}
