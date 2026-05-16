#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_fixed<16,7> c[16]) {
    #pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem0
    #pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem1
    #pragma HLS INTERFACE m_axi port=c offset=slave bundle=gmem2
    #pragma HLS INTERFACE s_axilite port=a bundle=control
    #pragma HLS INTERFACE s_axilite port=b bundle=control
    #pragma HLS INTERFACE s_axilite port=c bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    
    #pragma HLS ARRAY_PARTITION variable=a cyclic factor=4
    #pragma HLS ARRAY_PARTITION variable=b cyclic factor=4
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=4
    
    loop_add:
    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=4
        #pragma HLS UNROLL factor=4
        c[i] = a[i] + b[i];
    }
}
