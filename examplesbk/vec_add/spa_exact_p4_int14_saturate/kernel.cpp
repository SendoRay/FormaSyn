#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<14> c[16]
) {
#pragma HLS INTERFACE m_axi port=a
#pragma HLS INTERFACE m_axi port=b
#pragma HLS INTERFACE m_axi port=c
#pragma HLS INTERFACE s_axilite port=return

#pragma HLS ARRAY_PARTITION variable=a cyclic factor=4
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=4
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=4

    vec_add_loop:
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=5
#pragma HLS UNROLL factor=2
        ap_int<14> sum = (ap_int<14>)a[i] + (ap_int<14>)b[i];
        // Saturation guard: clamp to ap_int<14> range [-8192, 8191]
        ap_int<15> wide_sum = (ap_int<15>)a[i] + (ap_int<15>)b[i];
        if (wide_sum > ap_int<15>(8191)) {
            c[i] = ap_int<14>(8191);
        } else if (wide_sum < ap_int<15>(-8192)) {
            c[i] = ap_int<14>(-8192);
        } else {
            c[i] = (ap_int<14>)wide_sum;
        }
    }
}
