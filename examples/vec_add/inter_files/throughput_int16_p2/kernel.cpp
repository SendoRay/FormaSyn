#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_fixed<16,7> c[16]
) {
    #pragma HLS PIPELINE II=8
    for (int i = 0; i < 16; i++) {
        #pragma HLS UNROLL
        c[i] = a[i] + b[i];
    }
}
