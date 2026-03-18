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

    ap_int<10> c[16];
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=2

    // Compute c = a + b
    compute_c:
    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=8
        #pragma HLS UNROLL factor=2
        ap_int<10> sum = a[i] + b[i];
        c[i] = sum;
    }

    // Compute c_scale = c * 0.75
    compute_c_scale:
    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=8
        #pragma HLS UNROLL factor=2
        ap_int<10> temp = c[i];
        ap_int<10> scaled = (temp * 3) >> 2;
        if (scaled > 127) {
            c_scale[i] = 127;
        } else if (scaled < -128) {
            c_scale[i] = -128;
        } else {
            c_scale[i] = (ap_int<8>)scaled;
        }
    }
}
