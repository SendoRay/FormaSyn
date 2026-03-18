#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<32> a[16], ap_int<32> b[16], ap_int<8> c_scale[16]) {
#pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem0
#pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem1
#pragma HLS INTERFACE m_axi port=c_scale offset=slave bundle=gmem2
#pragma HLS INTERFACE s_axilite port=a
#pragma HLS INTERFACE s_axilite port=b
#pragma HLS INTERFACE s_axilite port=c_scale
#pragma HLS INTERFACE s_axilite port=return

    ap_int<32> c[16];
    
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=16
        c[i] = a[i] + b[i];
        
        ap_int<32> temp = c[i] * ap_int<32>(0.75 * (1 << 16));
        temp = temp >> 16;
        
        if (temp > 127) {
            c_scale[i] = 127;
        } else if (temp < -128) {
            c_scale[i] = -128;
        } else {
            c_scale[i] = (ap_int<8>)temp;
        }
    }
}
