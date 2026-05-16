#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_int<19> c[16]
) {
    #pragma HLS PIPELINE II=2
    c[0] = a[0];
}
