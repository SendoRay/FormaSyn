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

    ap_int<11> c[16];
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=4

    // Compute c = a + b
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=4
#pragma HLS UNROLL factor=4
        c[i] = a[i] + b[i];
    }

    // Compute c_scale = c * 0.75
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=4
#pragma HLS UNROLL factor=4
        ap_fixed<22,11> temp = c[i] * 0.75;
        c_scale[i] = (ap_int<8>)temp;
    }
}
