#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<7> c[16]
) {
    #pragma HLS ARRAY_PARTITION variable=a complete
    #pragma HLS ARRAY_PARTITION variable=b complete
    #pragma HLS ARRAY_PARTITION variable=c complete
    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=1
        #pragma HLS UNROLL
        c[i] = a[i] + b[i];
    }
}
