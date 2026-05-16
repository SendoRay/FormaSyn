#include "kernel.h"
#include <hls_stream.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_int<15> c[16]) {
    #pragma HLS INTERFACE mode=ap_fifo port=a
    #pragma HLS INTERFACE mode=ap_fifo port=b
    #pragma HLS INTERFACE mode=ap_fifo port=c
    #pragma HLS INTERFACE mode=s_axilite port=return

    #pragma HLS ARRAY_PARTITION variable=a cyclic factor=8
    #pragma HLS ARRAY_PARTITION variable=b cyclic factor=8
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=8

    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        c[i] = a[i] + b[i];
    }
}
