#include "kernel.h"
#include <ap_int.h>

// FIR Halfband Filter - FormulaGraph Implementation
//
// Halfband filter optimization:
// - Every other coefficient is zero (except center tap)
// - Coefficients are symmetric: h[i] = h[N-1-i]
// - For 17-tap: only taps 0, 2, 4, 6, 8, 10, 12, 14, 16 are non-zero
// - This reduces DSP usage from 17 to 9

void kernel(ap_int<16> x_in, ap_int<16>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // Halfband filter parameters
    const int TOTAL_TAPS = 17;      // Total number of taps
    const int NUM_NONZERO = 9;      // Non-zero taps: ceil(17/2) = 9
    const int CENTER_TAP = 8;       // Center tap index (17//2)
    
    // Non-zero coefficient indices: 0, 2, 4, 6, 8, 10, 12, 14, 16
    // Corresponding delay line indices for symmetric pairs
    
    // Halfband coefficients (symmetric, half are zero)
    // h[0]=h[16], h[2]=h[14], h[4]=h[12], h[6]=h[10], h[8]=center
    const ap_int<16> coeffs[NUM_NONZERO] = {
        -21,    // h[0] = h[16]
        0,      // h[2] = h[14]  (placeholder, actual value used)
        133,    // h[4] = h[12]
        0,      // h[6] = h[10]  (placeholder, actual value used)
        512,    // h[8] = center tap (normalized to 512 = 1.0 in Q9)
        0,      // h[10] = h[6]  (symmetric)
        133,    // h[12] = h[4]  (symmetric)
        0,      // h[14] = h[2]  (symmetric)
        -21     // h[16] = h[0]  (symmetric)
    };
    #pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    // Full shift register (17 elements)
    static ap_int<16> shift_reg[TOTAL_TAPS];
    #pragma HLS ARRAY_PARTITION variable=shift_reg complete
    
    // Shift register update
    for (int i = TOTAL_TAPS - 1; i > 0; i--) {
        #pragma HLS UNROLL
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;
    
    // Halfband optimization: exploit symmetry and zeros
    // Pair samples: (x[0]+x[16]), (x[2]+x[14]), (x[4]+x[12]), (x[6]+x[10]), x[8]
    ap_int<17> pairs[NUM_NONZERO/2 + 1];  // 5 pairs including center
    #pragma HLS ARRAY_PARTITION variable=pairs complete
    
    // Form symmetric pairs
    pairs[0] = shift_reg[0] + shift_reg[16];  // h[0], h[16]
    pairs[1] = shift_reg[2] + shift_reg[14];  // h[2], h[14]
    pairs[2] = shift_reg[4] + shift_reg[12];  // h[4], h[12]
    pairs[3] = shift_reg[6] + shift_reg[10];  // h[6], h[10]
    pairs[4] = shift_reg[8];                   // h[8] center tap
    
    // Coefficients for pairs (only non-zero ones)
    const ap_int<16> pair_coeffs[5] = {-21, 0, 133, 0, 512};
    #pragma HLS ARRAY_PARTITION variable=pair_coeffs complete
    
    // Multiply pairs with coefficients (only non-zero multiplies)
    ap_int<32> products[5];
    #pragma HLS ARRAY_PARTITION variable=products complete
    
    // h[0]=h[16]=-21
    products[0] = pairs[0] * (-21);
    // h[2]=h[14]=0 (skip, contributes 0)
    products[1] = 0;
    // h[4]=h[12]=133
    products[2] = pairs[2] * 133;
    // h[6]=h[10]=0 (skip, contributes 0)
    products[3] = 0;
    // h[8]=512 (center)
    products[4] = pairs[4] * 512;
    
    // Accumulate all products
    ap_int<40> acc = 0;
    for (int i = 0; i < 5; i++) {
        #pragma HLS UNROLL
        acc += products[i];
    }
    
    // Scale down (coeffs are Q9, so divide by 512)
    ap_int<16> scaled = acc >> 9;
    
    // Saturate to 16-bit output
    ap_int<16> max_val = 32767;
    ap_int<16> min_val = -32768;
    
    if (scaled > max_val) {
        y_out = max_val;
    } else if (scaled < min_val) {
        y_out = min_val;
    } else {
        y_out = scaled;
    }
}
