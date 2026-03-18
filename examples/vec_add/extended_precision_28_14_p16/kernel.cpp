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
    #pragma HLS INTERFACE s_axilite port=a bundle=control
    #pragma HLS INTERFACE s_axilite port=b bundle=control
    #pragma HLS INTERFACE s_axilite port=c_scale bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

    ap_int<14> c[16];
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=8

    // Node: c (add operation)
    LOOP_ADD: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        ap_int<14> sum = a[i] + b[i];
        c[i] = sum;
    }

    // Node: c_scale (multiply operation)
    LOOP_SCALE: for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        ap_fixed<32,16> temp = c[i] * 0.75;
        ap_int<8> result = (ap_int<8>)temp;
        c_scale[i] = result;
    }
}
