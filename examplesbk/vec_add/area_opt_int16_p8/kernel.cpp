#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_int<16> c[16]) {
    // Array Partitioning for Input 'a'
    #pragma HLS ARRAY_PARTITION variable=a cyclic factor=4
    // Array Partitioning for Input 'b'
    #pragma HLS ARRAY_PARTITION variable=b cyclic factor=4
    // Array Partitioning for Output 'c'
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=4

    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=3
        #pragma HLS UNROLL factor=4
        c[i] = a[i] + b[i];
    }
}