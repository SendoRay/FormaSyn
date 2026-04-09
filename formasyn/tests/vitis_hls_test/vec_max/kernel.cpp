#include "kernel.h"

void vec_max(data_t a[VEC_SIZE], data_t *y, idx_t *idx) {
    #pragma HLS INTERFACE mode=ap_memory port=a
    #pragma HLS INTERFACE mode=ap_vld port=y
    #pragma HLS INTERFACE mode=ap_vld port=idx
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    
    #pragma HLS PIPELINE II=1
    
    data_t max_val = a[0];
    idx_t max_idx = 0;
    
    for (int i = 1; i < VEC_SIZE; i++) {
        #pragma HLS UNROLL factor=1
        if (a[i] > max_val) {
            max_val = a[i];
            max_idx = i;
        }
    }
    
    *y = max_val;
    *idx = max_idx;
}
