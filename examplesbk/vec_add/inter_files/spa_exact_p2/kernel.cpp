#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<7> c[16]
) {
    #pragma HLS ARRAY_PARTITION variable=a cyclic factor=2
    #pragma HLS ARRAY_PARTITION variable=b cyclic factor=2
    #pragma HLS ARRAY_PARTITION variable=c cyclic factor=2
    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=8
        #pragma HLS UNROLL factor=2
        c[i] = a[i] + b[i];
    }
}
