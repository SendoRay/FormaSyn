#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_int<19> c[16]
) {
#pragma HLS INTERFACE ap_none port=a
#pragma HLS INTERFACE ap_none port=b
#pragma HLS INTERFACE ap_none port=c
#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS ARRAY_PARTITION variable=a complete dim=1
#pragma HLS ARRAY_PARTITION variable=b complete dim=1
#pragma HLS ARRAY_PARTITION variable=c complete dim=1

    // Vector addition: c[i] = a[i] + b[i] with saturation guard
    // Output type ap_int<19> accommodates full precision of ap_int<11> + ap_int<11>
    // Saturation clamps result to ap_int<16> range (quant_int_bits=16)

    static const ap_int<19> SAT_MAX = (ap_int<19>)((1 << 15) - 1);  // 32767
    static const ap_int<19> SAT_MIN = (ap_int<19>)(-(1 << 15));      // -32768

#pragma HLS PIPELINE II=1
    for (int i = 0; i < 16; i++) {
#pragma HLS UNROLL factor=16
        ap_int<19> sum = (ap_int<19>)a[i] + (ap_int<19>)b[i];
        // Saturate to int16 range
        if (sum > SAT_MAX) {
            c[i] = SAT_MAX;
        } else if (sum < SAT_MIN) {
            c[i] = SAT_MIN;
        } else {
            c[i] = sum;
        }
    }
}
