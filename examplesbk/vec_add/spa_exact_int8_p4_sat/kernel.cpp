#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_fixed<19,7> c[16]
) {
    #pragma HLS PIPELINE II=4
    c[0] = a[0];
}
