#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_fixed<16, 7, AP_TRN, AP_SAT> c[16]) {
    #pragma HLS INTERFACE mode=ap_fifo port=a
    #pragma HLS INTERFACE mode=ap_fifo port=b
    #pragma HLS INTERFACE mode=ap_fifo port=c
    #pragma HLS ARRAY_PARTITION variable=a cyclic factor=8 dim=1
    #pragma HLS ARRAY_PARTITION variable=b cyclic factor=8 dim=1
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=8 dim=1

    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        ap_int<8> a_val = a[i];
        ap_int<8> b_val = b[i];
        ap_fixed<16, 7, AP_TRN, AP_SAT> result = a_val + b_val;
        c[i] = result;
    }
}
