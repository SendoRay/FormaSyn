#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_int<8> c[16]) {
    // Array Partitioning for Inputs
    #pragma HLS ARRAY_PARTITION variable=a cyclic factor=8
    #pragma HLS ARRAY_PARTITION variable=b cyclic factor=8
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=8

    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        c[i] = a[i] + b[i];
    }
}
