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

    ap_int<16> c[16];
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=2

    // Pipeline with II=2
    LOOP_COMPUTE:
    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        #pragma HLS UNROLL factor=8
        
        // Node c: add operation
        c[i] = a[i] + b[i];
        
        // Node c_scale: multiply by 0.75 (3/4)
        ap_int<16> temp = (c[i] * 3) >> 2;
        
        // Saturation guard to ap_int<8>
        if (temp > 127) {
            c_scale[i] = 127;
        } else if (temp < -128) {
            c_scale[i] = -128;
        } else {
            c_scale[i] = (ap_int<8>)temp;
        }
    }
}
