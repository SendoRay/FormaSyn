#include "kernel.h"

void vec_add(data_t a[VEC_SIZE], data_t b[VEC_SIZE], data_t y[VEC_SIZE]) {
    #pragma HLS INTERFACE mode=ap_memory port=a
    #pragma HLS INTERFACE mode=ap_memory port=b
    #pragma HLS INTERFACE mode=ap_memory port=y
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    
    #pragma HLS PIPELINE II=1
    
    for (int i = 0; i < VEC_SIZE; i++) {
        #pragma HLS UNROLL factor=1
        y[i] = a[i] + b[i];
    }
}
