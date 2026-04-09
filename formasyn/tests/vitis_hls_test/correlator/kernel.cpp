#include "kernel.h"
#include <ap_int.h>

// Correlator (Matched Filter) - FormulaGraph Implementation
// 
// FormulaGraph equivalent:
//   ShiftReg(input_ref=x, taps=list(range(16)), output_ref="d")
//   Map(input_ref="d", func="multiply", func_params={"coeffs": preamble}, output_ref="p")
//   Reduce(input_refs=["p"], op="add", domain=Domain("all"), output_ref="y")
//
// This implementation uses a predefined 16-tap preamble for II=1
void kernel(ap_int<16> x_in, ap_int<32>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // Constants
    const int TAPS = 16;
    const int DATA_WIDTH = 16;
    const int COEFF_WIDTH = 2;   // Preamble values are -1 or +1 (2 bits sufficient)
    const int OUT_WIDTH = 32;    // Output width for correlation result
    
    typedef ap_int<DATA_WIDTH> data_t;
    typedef ap_int<COEFF_WIDTH> coeff_t;
    typedef ap_int<DATA_WIDTH + 1> prod_t;  // 16-bit * 2-bit = 17-bit product
    typedef ap_int<OUT_WIDTH> acc_t;
    
    // Preamble sequence - 16-tap Barker-like sequence for correlation
    // Values: +1 or -1 for matched filtering
    const coeff_t preamble[TAPS] = {
        1, 1, 1, 1, -1, -1, 1, -1, 1, -1, -1, 1, 1, -1, 1, 1
    };
    #pragma HLS ARRAY_PARTITION variable=preamble complete
    
    // ShiftReg: Shift register for delay line
    static data_t shift_reg[TAPS];
    #pragma HLS ARRAY_PARTITION variable=shift_reg complete
    
    // Update shift register: shift in new sample
    for (int i = TAPS - 1; i > 0; i--) {
        #pragma HLS UNROLL
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;
    
    // Map: Multiply each delayed sample with corresponding preamble value
    // (correlation = multiply by +1 or -1)
    prod_t products[TAPS];
    #pragma HLS ARRAY_PARTITION variable=products complete
    
    for (int i = 0; i < TAPS; i++) {
        #pragma HLS UNROLL
        products[i] = shift_reg[i] * preamble[i];
    }
    
    // Reduce: Sum all products (domain="all") for correlation output
    acc_t acc = 0;
    for (int i = 0; i < TAPS; i++) {
        #pragma HLS UNROLL
        acc += products[i];
    }
    
    y_out = acc;
}
