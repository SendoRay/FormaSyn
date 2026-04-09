#include "kernel.h"

// Convolutional Encoder Implementation
// Constraint length K=3, code rate 1/2
// Generator polynomials: G1=0b111, G2=0b101

void conv_encode(
    hls::stream<ap_uint<1>>& bit_in_stream,
    hls::stream<ap_uint<2>>& y_out_stream,
    ap_uint<32> num_bits
) {
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    #pragma HLS INTERFACE mode=ap_fifo port=bit_in_stream
    #pragma HLS INTERFACE mode=ap_fifo port=y_out_stream
    #pragma HLS INTERFACE mode=ap_stable port=num_bits
    
    #pragma HLS DATAFLOW
    
    // Shift register for K-1 = 2 bits of state memory
    ShiftReg<K-1> shift_reg;
    
    for (ap_uint<32> i = 0; i < num_bits; i++) {
        #pragma HLS PIPELINE II=1
        
        // Read input bit
        ap_uint<1> bit_in = bit_in_stream.read();
        
        // Current state (K-1 previous bits)
        ap_uint<K-1> state = shift_reg.read();
        
        // Compute output bits using generator polynomials
        // Input bit forms the MSB of the K-bit word
        ap_uint<K> input_word = (state, bit_in);
        
        // G1 = 0b111: XOR of all 3 bits
        ap_uint<1> out1 = input_word[0] ^ input_word[1] ^ input_word[2];
        
        // G2 = 0b101: XOR of bits 0 and 2
        ap_uint<1> out2 = input_word[0] ^ input_word[2];
        
        // Pack output: {out2, out1}
        ap_uint<2> y_out = (out2, out1);
        
        // Write output
        y_out_stream.write(y_out);
        
        // Update shift register: shift in the new bit
        shift_reg.shift(bit_in);
    }
}
