#include "kernel.h"
#include <hls_stream.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_fixed<16, 7> c[16]) {
    #pragma HLS INTERFACE mode=ap_fifo port=a
    #pragma HLS INTERFACE mode=ap_fifo port=b
    #pragma HLS INTERFACE mode=ap_fifo port=c
    #pragma HLS INTERFACE mode=ap_ctrl_none port=return

    #pragma HLS ARRAY_PARTITION variable=a cyclic factor=4
    #pragma HLS ARRAY_PARTITION variable=b cyclic factor=4
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=4

    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=4
        c[i] = a[i] + b[i];
    }
}
