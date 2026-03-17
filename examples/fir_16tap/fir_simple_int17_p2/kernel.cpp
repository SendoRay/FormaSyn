#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> x_in, ap_int<8>& y_out_scale) {
    #pragma HLS INTERFACE ap_ctrl_none port=return
    #pragma HLS INTERFACE ap_none port=x_in
    #pragma HLS INTERFACE ap_none port=y_out_scale
    #pragma HLS PIPELINE II=8
    
    static ap_int<8> taps[16];
    #pragma HLS ARRAY_PARTITION variable=taps cyclic factor=2
    
    static const ap_int<8> coeffs[16] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
    #pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    for (int i = 15; i > 0; i--) {
        #pragma HLS UNROLL factor=2
        taps[i] = taps[i-1];
    }
    taps[0] = x_in;
    
    ap_int<17> products[16];
    #pragma HLS ARRAY_PARTITION variable=products cyclic factor=2
    
    for (int i = 0; i < 16; i++) {
        #pragma HLS UNROLL factor=2
        products[i] = taps[i] * coeffs[i];
    }
    
    ap_int<17> y_out = 0;
    for (int i = 0; i < 16; i++) {
        #pragma HLS UNROLL factor=2
        y_out += products[i];
    }
    
    ap_int<17> scaled = (y_out * 3) >> 2;
    y_out_scale = scaled;
}
