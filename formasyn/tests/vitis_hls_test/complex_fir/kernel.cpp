#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

// Complex FIR Filter - 8 Taps
// 
// FormulaGraph equivalent:
//   ShiftReg(input_ref=x_real, taps=list(range(8)), output_ref="d_r")
//   ShiftReg(input_ref=x_imag, taps=list(range(8)), output_ref="d_i")
//   Map(input_refs=["d_r", "d_i"], func="complex_multiply",
//       func_params={"coeffs_real": hr, "coeffs_imag": hi}, output_ref="p")
//   Reduce(input_refs=["p_real"], op="add", domain=Domain("all"), output_ref="y_real")
//   Reduce(input_refs=["p_imag"], op="add", domain=Domain("all"), output_ref="y_imag")
//
// Complex multiply using 4 real multiplies per tap:
//   y_real = I*hr - Q*hi
//   y_imag = I*hi + Q*hr
//
// Target II=1, NMSE <= -30 dB
void kernel(ap_int<16> x_real, ap_int<16> x_imag, ap_int<16>& y_real, ap_int<16>& y_imag) {
    #pragma HLS INTERFACE s_axilite port=x_real bundle=control
    #pragma HLS INTERFACE s_axilite port=x_imag bundle=control
    #pragma HLS INTERFACE s_axilite port=y_real bundle=control
    #pragma HLS INTERFACE s_axilite port=y_imag bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // Constants
    const int TAPS = 8;
    const int DATA_WIDTH = 16;
    const int COEFF_WIDTH = 16;
    const int ACC_WIDTH = DATA_WIDTH + COEFF_WIDTH + 8;
    
    typedef ap_int<DATA_WIDTH> data_t;
    typedef ap_int<COEFF_WIDTH> coeff_t;
    typedef ap_int<DATA_WIDTH + COEFF_WIDTH> prod_t;
    typedef ap_int<ACC_WIDTH> acc_t;
    
    // Complex FIR coefficients (low-pass filter)
    // Real coefficients (hr)
    const coeff_t coeffs_real[TAPS] = {
        100, 200, 400, 800, 800, 400, 200, 100
    };
    // Imaginary coefficients (hi) - zero for symmetric low-pass
    const coeff_t coeffs_imag[TAPS] = {
        0, 0, 0, 0, 0, 0, 0, 0
    };
    #pragma HLS ARRAY_PARTITION variable=coeffs_real complete
    #pragma HLS ARRAY_PARTITION variable=coeffs_imag complete
    
    // Shift registers for real and imaginary parts
    static data_t shift_reg_real[TAPS];
    static data_t shift_reg_imag[TAPS];
    #pragma HLS ARRAY_PARTITION variable=shift_reg_real complete
    #pragma HLS ARRAY_PARTITION variable=shift_reg_imag complete
    
    // Update shift registers: shift in new samples
    for (int i = TAPS - 1; i > 0; i--) {
        #pragma HLS UNROLL
        shift_reg_real[i] = shift_reg_real[i-1];
        shift_reg_imag[i] = shift_reg_imag[i-1];
    }
    shift_reg_real[0] = x_real;
    shift_reg_imag[0] = x_imag;
    
    // Complex multiply-accumulate using 4 real multiplies per tap
    // y_real = sum(I*hr - Q*hi)
    // y_imag = sum(I*hi + Q*hr)
    acc_t acc_real = 0;
    acc_t acc_imag = 0;
    
    for (int i = 0; i < TAPS; i++) {
        #pragma HLS UNROLL
        // 4 real multiplies for complex multiplication
        prod_t prod_i_hr = shift_reg_real[i] * coeffs_real[i];  // I * hr
        prod_t prod_q_hi = shift_reg_imag[i] * coeffs_imag[i];  // Q * hi
        prod_t prod_i_hi = shift_reg_real[i] * coeffs_imag[i];  // I * hi
        prod_t prod_q_hr = shift_reg_imag[i] * coeffs_real[i];  // Q * hr
        
        // Combine for complex output
        acc_real += (prod_i_hr - prod_q_hi);
        acc_imag += (prod_i_hi + prod_q_hr);
    }
    
    // Saturate to output width
    data_t max_val = 32767;   // (1 << 15) - 1
    data_t min_val = -32768;  // -(1 << 15)
    
    data_t result_real, result_imag;
    
    if (acc_real > max_val) result_real = max_val;
    else if (acc_real < min_val) result_real = min_val;
    else result_real = (data_t)acc_real;
    
    if (acc_imag > max_val) result_imag = max_val;
    else if (acc_imag < min_val) result_imag = min_val;
    else result_imag = (data_t)acc_imag;
    
    y_real = result_real;
    y_imag = result_imag;
}
