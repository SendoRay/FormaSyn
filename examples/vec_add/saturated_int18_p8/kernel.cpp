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

    ap_int<18> c[16];
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=8

    for (int i = 0; i < 16; i += 8) {
#pragma HLS PIPELINE II=2
#pragma HLS UNROLL factor=8
        for (int j = 0; j < 8; j++) {
            int idx = i + j;
            if (idx < 16) {
                ap_int<18> sum = a[idx] + b[idx];
                c[idx] = sum;
                
                ap_int<18> scaled = (sum * 3) >> 2;
                
                if (scaled > 127) {
                    c_scale[idx] = 127;
                } else if (scaled < -128) {
                    c_scale[idx] = -128;
                } else {
                    c_scale[idx] = scaled;
                }
            }
        }
    }
}
