#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_int<15> c[16]
) {
#pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem0
#pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem1
#pragma HLS INTERFACE m_axi port=c offset=slave bundle=gmem2
#pragma HLS INTERFACE s_axilite port=a bundle=control
#pragma HLS INTERFACE s_axilite port=b bundle=control
#pragma HLS INTERFACE s_axilite port=c bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

#pragma HLS ARRAY_PARTITION variable=a cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=8

    // Saturation limits for output type ap_int<15> clamped to quant_int_bits=12
    const ap_int<15> SAT_MAX = (ap_int<15>)((1 << (12 - 1)) - 1);  // 2047
    const ap_int<15> SAT_MIN = (ap_int<15>)(-(1 << (12 - 1)));     // -2048

    vec_add_loop:
    for (int i = 0; i < 16; i += 8) {
#pragma HLS PIPELINE II=2
#pragma HLS UNROLL factor=8
        for (int j = 0; j < 8; j++) {
#pragma HLS UNROLL
            int idx = i + j;
            ap_int<15> sum = (ap_int<15>)a[idx] + (ap_int<15>)b[idx];
            // Saturation guard
            if (sum > SAT_MAX) sum = SAT_MAX;
            else if (sum < SAT_MIN) sum = SAT_MIN;
            c[idx] = sum;
        }
    }
}
