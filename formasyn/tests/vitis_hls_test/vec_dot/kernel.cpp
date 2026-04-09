#include "kernel.h"

void vec_dot(data_in_t a[VEC_SIZE], data_in_t b[VEC_SIZE], data_out_t *y) {
    #pragma HLS INTERFACE mode=ap_memory port=a
    #pragma HLS INTERFACE mode=ap_memory port=b
    #pragma HLS INTERFACE mode=ap_vld port=y
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    
    #pragma HLS PIPELINE II=1
    
    data_out_t sum = 0;
    
    for (int i = 0; i < VEC_SIZE; i++) {
        #pragma HLS UNROLL factor=1
        sum += a[i] * b[i];
    }
    
    *y = sum;
}
