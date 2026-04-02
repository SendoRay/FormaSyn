#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_fixed<19,7> c[16]
) {
#pragma HLS INTERFACE m_axi port=a depth=16
#pragma HLS INTERFACE m_axi port=b depth=16
#pragma HLS INTERFACE m_axi port=c depth=16
#pragma HLS INTERFACE s_axilite port=return

#pragma HLS ARRAY_PARTITION variable=a cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=8

    vec_add_loop:
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=3
#pragma HLS UNROLL factor=4
        ap_fixed<19,7> val_a = (ap_fixed<19,7>)a[i];
        ap_fixed<19,7> val_b = (ap_fixed<19,7>)b[i];
        ap_fixed<19,7> sum = val_a + val_b;
        // Saturation guard
        ap_fixed<19,7> max_val = ap_fixed<19,7>(127);
        ap_fixed<19,7> min_val = ap_fixed<19,7>(-128);
        if (sum > max_val) sum = max_val;
        else if (sum < min_val) sum = min_val;
        c[i] = sum;
    }
}
