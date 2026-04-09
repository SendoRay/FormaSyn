#include "kernel.h"

// BPSK Mapper - Lookup Table Implementation
// Target: II=1
// Constellation: BPSK with points at -1 and +1 (scaled to 1000)

void bpsk_mapper(ap_uint<1> bit_in, ap_int<16> *y_out) {
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS INTERFACE s_axilite port=bit_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    
    // BPSK LUT: map 1-bit input to constellation point
    // bit_in=0 -> -1000 (-1.0 scaled)
    // bit_in=1 -> +1000 (+1.0 scaled)
    static const ap_int<16> bpsk_lut[2] = {
        -1000,  // bit 0 -> -1.0
         1000   // bit 1 -> +1.0
    };
    
    #pragma HLS BIND_STORAGE variable=bpsk_lut type=ROM_1P
    
    // Lookup table access - single cycle
    *y_out = bpsk_lut[bit_in];
}
