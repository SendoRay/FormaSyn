#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_int<11> c[16]
) {
#pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem0
#pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem1
#pragma HLS INTERFACE m_axi port=c offset=slave bundle=gmem2
#pragma HLS INTERFACE s_axilite port=a bundle=control
#pragma HLS INTERFACE s_axilite port=b bundle=control
#pragma HLS INTERFACE s_axilite port=c bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    ap_int<11> local_a[16];
    ap_int<11> local_b[16];
    ap_int<11> local_c[16];

#pragma HLS ARRAY_PARTITION variable=local_a cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=local_b cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=local_c cyclic factor=8

    // Load a
    load_a: for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=3
        local_a[i] = a[i];
    }

    // Load b
    load_b: for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=3
        local_b[i] = b[i];
    }

    // Compute c = a + b with saturation guard
    compute: for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=3
#pragma HLS UNROLL factor=4
        ap_int<12> sum = (ap_int<12>)local_a[i] + (ap_int<12>)local_b[i];
        // Saturation guard for ap_int<11>: range [-1024, 1023]
        if (sum > ap_int<12>(1023)) {
            local_c[i] = ap_int<11>(1023);
        } else if (sum < ap_int<12>(-1024)) {
            local_c[i] = ap_int<11>(-1024);
        } else {
            local_c[i] = (ap_int<11>)sum;
        }
    }

    // Store c
    store_c: for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=3
        c[i] = local_c[i];
    }
}
