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

#pragma HLS ARRAY_PARTITION variable=a cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=c_scale cyclic factor=8

    ap_int<8> c[16];
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=8

    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=2
#pragma HLS UNROLL factor=8
        c[i] = a[i] + b[i];
    }

    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=2
#pragma HLS UNROLL factor=8
        ap_fixed<16,8> temp = c[i] * 0.75;
        c_scale[i] = (ap_int<8>)temp;
    }
}
