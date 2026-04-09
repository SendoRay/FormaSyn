#include "kernel.h"
#include <cmath>

// QPSK Mapper - Lookup Table Implementation
// Target: II=1
// Constellation: QPSK with points at (±0.707, ±0.707) scaled to 1000
// Gray coding: 00->(+707,+707), 01->(+707,-707), 10->(-707,+707), 11->(-707,-707)

void qpsk_mapper(ap_uint<2> bits_in, ap_int<16> *y_real, ap_int<16> *y_imag) {
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS INTERFACE s_axilite port=bits_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_real bundle=control
    #pragma HLS INTERFACE s_axilite port=y_imag bundle=control
    
    // QPSK LUT for I (real) component
    // 00 -> +707, 01 -> +707, 10 -> -707, 11 -> -707
    static const ap_int<16> qpsk_i_lut[4] = {
         707,   // 00: +0.707
         707,   // 01: +0.707
        -707,   // 10: -0.707
        -707    // 11: -0.707
    };
    
    // QPSK LUT for Q (imaginary) component
    // 00 -> +707, 01 -> -707, 10 -> +707, 11 -> -707
    static const ap_int<16> qpsk_q_lut[4] = {
         707,   // 00: +0.707
        -707,   // 01: -0.707
         707,   // 10: +0.707
        -707    // 11: -0.707
    };
    
    #pragma HLS BIND_STORAGE variable=qpsk_i_lut type=ROM_1P
    #pragma HLS BIND_STORAGE variable=qpsk_q_lut type=ROM_1P
    
    // Lookup table access - single cycle
    *y_real = qpsk_i_lut[bits_in];
    *y_imag = qpsk_q_lut[bits_in];
}
