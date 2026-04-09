#include "kernel.h"

// 16-QAM Mapper - Lookup Table Implementation
// Target: II=1
// Constellation: Gray-coded 16-QAM
// I and Q each take 2 bits, levels at ±1, ±3 (scaled to 1000)
// Gray coding for 2 bits: 00->-3, 01->-1, 11->+1, 10->+3

void qam16_mapper(ap_uint<4> bits_in, ap_int<16> *y_real, ap_int<16> *y_imag) {
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS INTERFACE s_axilite port=bits_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_real bundle=control
    #pragma HLS INTERFACE s_axilite port=y_imag bundle=control
    
    // Split 4-bit input: bits[3:2] for I (MSB), bits[1:0] for Q (LSB)
    ap_uint<2> i_bits = bits_in.range(3, 2);
    ap_uint<2> q_bits = bits_in.range(1, 0);
    
    // 16-QAM LUT for I component (same for Q)
    // Binary to Gray: gray = binary ^ (binary >> 1)
    // Inverse: 00->-3, 01->-1, 10->+3, 11->+1
    // Actually using direct mapping: bits -> amplitude
    // 00 -> -3.0 -> -3000
    // 01 -> -1.0 -> -1000
    // 10 -> +3.0 -> +3000
    // 11 -> +1.0 -> +1000
    static const ap_int<16> qam16_lut[4] = {
        -3000,  // 00: -3.0
        -1000,  // 01: -1.0
         3000,  // 10: +3.0
         1000   // 11: +1.0
    };
    
    #pragma HLS BIND_STORAGE variable=qam16_lut type=ROM_1P
    
    // Lookup table access - single cycle for both I and Q
    *y_real = qam16_lut[i_bits];
    *y_imag = qam16_lut[q_bits];
}
