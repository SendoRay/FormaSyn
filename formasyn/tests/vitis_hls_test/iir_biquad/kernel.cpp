#include "kernel.h"
#include <ap_int.h>

// IIR Biquad - Direct Form II
// Coefficients in Q8, output in Q0

void kernel(ap_int<16> x_in, ap_int<16>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    const int Q = 8;
    const ap_int<16> b0 = 17, b1 = 35, b2 = 17;
    const ap_int<16> a1 = 182, a2 = -67;
    
    static ap_int<32> w1 = 0, w2 = 0;
    
    // Input to Q8
    ap_int<32> x = ((ap_int<32>)x_in) << Q;
    
    // w[n] = x[n] - a1*w[n-1] - a2*w[n-2]
    ap_int<48> acc = (ap_int<48>)x;
    acc -= (ap_int<48>)a1 * (ap_int<48>)w1;
    acc -= (ap_int<48>)a2 * (ap_int<48>)w2;
    ap_int<32> w0 = (ap_int<32>)(acc >> Q);
    
    // y[n] = b0*w[n] + b1*w[n-1] + b2*w[n-2]
    acc = (ap_int<48>)b0 * (ap_int<48>)w0
        + (ap_int<48>)b1 * (ap_int<48>)w1
        + (ap_int<48>)b2 * (ap_int<48>)w2;
    ap_int<32> y = (ap_int<32>)(acc >> Q);  // This is already Q0!
    
    if (y > 32767) y_out = 32767;
    else if (y < -32768) y_out = -32768;
    else y_out = (ap_int<16>)y;
    
    w2 = w1;
    w1 = w0;
}
