#include "kernel.h"
#include <ap_int.h>

// IIR Cascade - 2 Section Biquad (simplified, cascaded single biquad)

void kernel(ap_int<16> x_in, ap_int<16>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    const int Q = 8;
    
    // Two identical biquad sections
    const ap_int<16> b0 = 17, b1 = 35, b2 = 17;
    const ap_int<16> a1 = 182, a2 = -67;
    
    static ap_int<32> w1_1 = 0, w2_1 = 0;
    static ap_int<32> w1_2 = 0, w2_2 = 0;
    
    // Section 1 output
    ap_int<32> x = ((ap_int<32>)x_in) << Q;
    
    // Section 1
    ap_int<48> acc = x - (ap_int<48>)a1 * (ap_int<48>)w1_1 - (ap_int<48>)a2 * (ap_int<48>)w2_1;
    ap_int<32> w0_1 = (ap_int<32>)(acc >> Q);
    acc = (ap_int<48>)b0 * (ap_int<48>)w0_1 + (ap_int<48>)b1 * (ap_int<48>)w1_1 + (ap_int<48>)b2 * (ap_int<48>)w2_1;
    ap_int<32> y1 = (ap_int<32>)(acc >> Q);
    w2_1 = w1_1; w1_1 = w0_1;
    
    // Section 2 (take output of section 1)
    x = y1 << Q;
    acc = x - (ap_int<48>)a1 * (ap_int<48>)w1_2 - (ap_int<48>)a2 * (ap_int<48>)w2_2;
    ap_int<32> w0_2 = (ap_int<32>)(acc >> Q);
    acc = (ap_int<48>)b0 * (ap_int<48>)w0_2 + (ap_int<48>)b1 * (ap_int<48>)w1_2 + (ap_int<48>)b2 * (ap_int<48>)w2_2;
    ap_int<32> y = (ap_int<32>)(acc >> Q);
    w2_2 = w1_2; w1_2 = w0_2;
    
    if (y > 32767) y_out = 32767;
    else if (y < -32768) y_out = -32768;
    else y_out = (ap_int<16>)y;
}
