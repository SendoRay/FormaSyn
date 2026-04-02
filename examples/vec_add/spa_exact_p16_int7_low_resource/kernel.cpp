#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<7> c[16]
) {
    #pragma HLS PIPELINE II=2
    c[0] = a[0];
}
