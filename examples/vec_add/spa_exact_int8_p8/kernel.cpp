#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<7> c[16]
) {
#pragma HLS INTERFACE bram port=a
#pragma HLS INTERFACE bram port=b
#pragma HLS INTERFACE bram port=c
#pragma HLS ARRAY_PARTITION variable=a cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=8 dim=1

    const int N = 16;
    const int UNROLL = 8;

    vec_add_loop:
    for (int i = 0; i < N; i += UNROLL) {
#pragma HLS PIPELINE II=2
#pragma HLS UNROLL factor=8
        for (int j = 0; j < UNROLL; j++) {
#pragma HLS UNROLL
            int idx = i + j;
            if (idx < N) {
                ap_int<9> sum = (ap_int<9>)a[idx] + (ap_int<9>)b[idx];
                // Saturate to ap_int<7> range [-64, 63]
                ap_int<7> result;
                if (sum > ap_int<9>(63)) {
                    result = ap_int<7>(63);
                } else if (sum < ap_int<9>(-64)) {
                    result = ap_int<7>(-64);
                } else {
                    result = (ap_int<7>)sum;
                }
                c[idx] = result;
            }
        }
    }
}
