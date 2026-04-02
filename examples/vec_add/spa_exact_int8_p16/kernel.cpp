#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_fixed<16,7> c[16]
) {
#pragma HLS INTERFACE bram port=a
#pragma HLS INTERFACE bram port=b
#pragma HLS INTERFACE bram port=c
#pragma HLS ARRAY_PARTITION variable=a cyclic factor=4
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=4
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=4

    vec_add_loop:
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=3
#pragma HLS UNROLL factor=4
        ap_fixed<16,7> val_a = (ap_fixed<16,7>)a[i];
        ap_fixed<16,7> val_b = (ap_fixed<16,7>)b[i];
        ap_fixed<16,7> sum = val_a + val_b;
        // Saturation guard: clamp to ap_fixed<16,7> representable range
        ap_fixed<16,7> max_val;
        max_val.range() = ap_uint<16>((1 << 15) - 1);
        ap_fixed<16,7> min_val;
        min_val.range() = ap_uint<16>(1 << 15);
        if (sum > max_val) sum = max_val;
        else if (sum < min_val) sum = min_val;
        c[i] = sum;
    }
}
