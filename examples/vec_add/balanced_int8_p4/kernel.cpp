#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_int<8> c[16]) {
    #pragma HLS INTERFACE m_axi port=a depth=16
    #pragma HLS INTERFACE m_axi port=b depth=16
    #pragma HLS INTERFACE m_axi port=c depth=16
    #pragma HLS INTERFACE s_axilite port=return

    #pragma HLS ARRAY_PARTITION variable=a cyclic factor=4
    #pragma HLS ARRAY_PARTITION variable=b cyclic factor=4
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=4

    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=4
        c[i] = a[i] + b[i];
    }
}
