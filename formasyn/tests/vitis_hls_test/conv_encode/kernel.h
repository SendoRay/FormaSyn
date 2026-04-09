#ifndef CONV_ENCODE_KERNEL_H
#define CONV_ENCODE_KERNEL_H

#include <ap_int.h>
#include <hls_stream.h>

// Convolutional Encoder Parameters
#define K 3           // Constraint length
#define RATE 2        // Code rate 1/2 (2 output bits per input bit)
#define NUM_STATES 4  // 2^(K-1) = 4 states

// Generator polynomials (standard K=3, rate 1/2 code)
// G1 = 0b111 = 7 (octal)
// G2 = 0b101 = 5 (octal)
#define G1 0x7
#define G2 0x5

// Shift register for state memory
template<int WIDTH>
class ShiftReg {
private:
    ap_uint<WIDTH> reg;
public:
    ShiftReg() : reg(0) {}
    
    void shift(ap_uint<1> bit_in) {
        #pragma HLS INLINE
        reg = (reg << 1) | bit_in;
    }
    
    ap_uint<WIDTH> read() const {
        #pragma HLS INLINE
        return reg;
    }
    
    void reset() {
        #pragma HLS INLINE
        reg = 0;
    }
};

// Convolutional encoder kernel
void conv_encode(
    hls::stream<ap_uint<1>>& bit_in_stream,
    hls::stream<ap_uint<2>>& y_out_stream,
    ap_uint<32> num_bits
);

#endif // CONV_ENCODE_KERNEL_H
