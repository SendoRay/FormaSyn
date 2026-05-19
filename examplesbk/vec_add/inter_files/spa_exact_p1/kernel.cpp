#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<7> c[16]
) {
    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=16
        c[i] = a[i] + b[i];
    }
}
