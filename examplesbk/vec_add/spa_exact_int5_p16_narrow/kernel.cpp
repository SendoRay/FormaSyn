#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<8> a[16],
    ap_int<8> b[16],
    ap_int<5> c[16]
) {
#pragma HLS INTERFACE bram port=a
#pragma HLS INTERFACE bram port=b
#pragma HLS INTERFACE bram port=c
#pragma HLS ARRAY_PARTITION variable=a cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=8
#pragma HLS ARRAY_PARTITION variable=c cyclic factor=8

    vec_add_loop:
    for (int i = 0; i < 16; i++) {
#pragma HLS PIPELINE II=2
#pragma HLS UNROLL factor=8
        ap_int<9> sum = (ap_int<9>)a[i] + (ap_int<9>)b[i];
        // Saturate to ap_int<5> range [-16, 15]
        ap_int<5> result;
        if (sum > ap_int<9>(15)) {
            result = ap_int<5>(15);
        } else if (sum < ap_int<9>(-16)) {
            result = ap_int<5>(-16);
        } else {
            result = (ap_int<5>)sum;
        }
        c[i] = result;
    }
}
