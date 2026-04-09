#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

// LS Channel Estimator - Least Squares Channel Estimation
// 
// FormulaGraph equivalent:
//   Map(input_refs=["rx_pilot", "pilot"], func="ls_estimate", output_ref="H")
//
// Algorithm: H = rx_pilot * conj(pilot) / |pilot|^2
//
// Expanded:
//   numerator_real = rx_real * p_real + rx_imag * p_imag
//   numerator_imag = rx_imag * p_real - rx_real * p_imag
//   denominator = p_real^2 + p_imag^2
//   h_real = numerator_real / denominator
//   h_imag = numerator_imag / denominator
//
// For normalized pilots (|pilot|^2 = constant), division can be simplified
// This implementation assumes pilot magnitude is known/power-of-2
//
// Target: NMSE <= -20 dB at high SNR
void kernel(ap_int<16> rx_real, ap_int<16> rx_imag,
            ap_int<16> p_real, ap_int<16> p_imag,
            ap_int<16>& h_real, ap_int<16>& h_imag) {
    #pragma HLS INTERFACE s_axilite port=rx_real bundle=control
    #pragma HLS INTERFACE s_axilite port=rx_imag bundle=control
    #pragma HLS INTERFACE s_axilite port=p_real bundle=control
    #pragma HLS INTERFACE s_axilite port=p_imag bundle=control
    #pragma HLS INTERFACE s_axilite port=h_real bundle=control
    #pragma HLS INTERFACE s_axilite port=h_imag bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // Type definitions
    typedef ap_int<16> data_t;
    typedef ap_int<32> prod_t;
    typedef ap_int<33> sum_t;
    typedef ap_uint<32> mag_sq_t;
    
    // Step 1: Compute numerator = rx_pilot * conj(pilot)
    // conj(pilot) = (p_real, -p_imag)
    // rx * conj(p) = (rx_real + j*rx_imag) * (p_real - j*p_imag)
    //              = rx_real*p_real + rx_imag*p_imag + j*(rx_imag*p_real - rx_real*p_imag)
    
    prod_t prod_rr = rx_real * p_real;  // rx_real * p_real
    prod_t prod_ii = rx_imag * p_imag;  // rx_imag * p_imag
    prod_t prod_ir = rx_imag * p_real;  // rx_imag * p_real
    prod_t prod_ri = rx_real * p_imag;  // rx_real * p_imag
    
    // Numerator real: rx_real*p_real + rx_imag*p_imag
    sum_t num_real = prod_rr + prod_ii;
    
    // Numerator imag: rx_imag*p_real - rx_real*p_imag
    sum_t num_imag = prod_ir - prod_ri;
    
    // Step 2: Compute denominator = |pilot|^2 = p_real^2 + p_imag^2
    // Using unsigned for magnitude squared to handle overflow correctly
    ap_int<32> p_real_sq = p_real * p_real;
    ap_int<32> p_imag_sq = p_imag * p_imag;
    mag_sq_t mag_sq_p = (p_real_sq >= 0) ? (mag_sq_t)p_real_sq : (mag_sq_t)(-p_real_sq);
    mag_sq_t mag_sq_q = (p_imag_sq >= 0) ? (mag_sq_t)p_imag_sq : (mag_sq_t)(-p_imag_sq);
    mag_sq_t mag_sq = mag_sq_p + mag_sq_q;
    
    // Step 3: Division by |pilot|^2 with normalization
    // Using fixed-point arithmetic for division
    // Shift numerator to maintain precision
    // Assume pilot magnitude is normalized such that division can be done by shift
    // For typical pilots with |p|^2 = 2^14 (QPSK with amplitude 128)
    
    const int NORM_SHIFT = 14;  // Normalization shift for QPSK pilots with amp 128
    
    // Divide with rounding: result = (num << shift) / mag_sq >> shift
    // Simplified: if mag_sq is approximately 2^NORM_SHIFT, use shift
    // Otherwise, use actual division
    
    ap_int<48> num_real_shifted = ((ap_int<48>)num_real) << NORM_SHIFT;
    ap_int<48> num_imag_shifted = ((ap_int<48>)num_imag) << NORM_SHIFT;
    
    // Integer division
    ap_int<48> h_real_full, h_imag_full;
    
    if (mag_sq == 0) {
        // Avoid division by zero
        h_real_full = 0;
        h_imag_full = 0;
    } else {
        h_real_full = num_real_shifted / (ap_int<48>)mag_sq;
        h_imag_full = num_imag_shifted / (ap_int<48>)mag_sq;
    }
    
    // Step 4: Saturate to output width
    data_t max_val = 32767;   // (1 << 15) - 1
    data_t min_val = -32768;  // -(1 << 15)
    
    data_t result_real, result_imag;
    
    if (h_real_full > max_val) result_real = max_val;
    else if (h_real_full < min_val) result_real = min_val;
    else result_real = (data_t)h_real_full;
    
    if (h_imag_full > max_val) result_imag = max_val;
    else if (h_imag_full < min_val) result_imag = min_val;
    else result_imag = (data_t)h_imag_full;
    
    h_real = result_real;
    h_imag = result_imag;
}
