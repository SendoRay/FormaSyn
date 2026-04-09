#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

// FIR Direct Form - FormulaGraph Implementation
// 
// FormulaGraph equivalent:
//   ShiftReg(input_ref=x, taps=list(range(16)), output_ref="d")
//   Map(input_ref="d", func="multiply", func_params={"coeffs": h}, output_ref="p")
//   Reduce(input_refs=["p"], op="add", domain=Domain("all"), output_ref="y")
//
// This implementation uses internal coefficients for II=1
void kernel(ap_int<16> x_in, ap_int<16>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // Constants
    const int TAPS = 16;
    const int DATA_WIDTH = 16;
    const int COEFF_WIDTH = 16;
    const int ACC_WIDTH = DATA_WIDTH + COEFF_WIDTH + 8;  // Extra bits for accumulation
    
    typedef ap_int<DATA_WIDTH> data_t;
    typedef ap_int<COEFF_WIDTH> coeff_t;
    typedef ap_int<DATA_WIDTH + COEFF_WIDTH> prod_t;
    typedef ap_int<ACC_WIDTH> acc_t;
    
    // FIR Coefficients - partitioned for parallel access
    const coeff_t coeffs[TAPS] = {
        10, 20, 30, 50, 70, 90, 110, 127,
        127, 110, 90, 70, 50, 30, 20, 10
    };
    #pragma HLS ARRAY_PARTITION variable=coeffs complete
    
    // ShiftReg: Shift register for delay line
    static data_t shift_reg[TAPS];
    #pragma HLS ARRAY_PARTITION variable=shift_reg complete
    
    // Update shift register: shift in new sample
    for (int i = TAPS - 1; i > 0; i--) {
        #pragma HLS UNROLL
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;
    
    // Map: Multiply each delayed sample with corresponding coefficient
    prod_t products[TAPS];
    #pragma HLS ARRAY_PARTITION variable=products complete
    
    for (int i = 0; i < TAPS; i++) {
        #pragma HLS UNROLL
        products[i] = shift_reg[i] * coeffs[i];
    }
    
    // Reduce: Sum all products (domain="all")
    acc_t acc = 0;
    for (int i = 0; i < TAPS; i++) {
        #pragma HLS UNROLL
        acc += products[i];
    }
    
    // Saturate to output width
    ap_int<DATA_WIDTH> result;
    ap_int<DATA_WIDTH> max_val = (1 << (DATA_WIDTH - 1)) - 1;   // 32767
    ap_int<DATA_WIDTH> min_val = -(1 << (DATA_WIDTH - 1));      // -32768
    
    if (acc > max_val) {
        result = max_val;
    } else if (acc < min_val) {
        result = min_val;
    } else {
        result = acc;
    }
    
    y_out = result;
}
