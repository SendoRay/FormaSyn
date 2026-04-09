#include "kernel.h"
#include <iostream>
#include <cmath>
#include <complex>

// Golden reference implementation for complex FIR
static void complex_fir_golden(
    ap_int<16> x_real, ap_int<16> x_imag,
    ap_int<16> shift_reg_real[8], ap_int<16> shift_reg_imag[8],
    ap_int<16>& y_real, ap_int<16>& y_imag
) {
    // Complex FIR coefficients (same as kernel)
    const ap_int<16> coeffs_real[8] = {
        100, 200, 400, 800, 800, 400, 200, 100
    };
    const ap_int<16> coeffs_imag[8] = {
        0, 0, 0, 0, 0, 0, 0, 0
    };
    
    // Update shift registers
    for (int i = 7; i > 0; i--) {
        shift_reg_real[i] = shift_reg_real[i-1];
        shift_reg_imag[i] = shift_reg_imag[i-1];
    }
    shift_reg_real[0] = x_real;
    shift_reg_imag[0] = x_imag;
    
    // Complex multiply-accumulate
    // y_real = sum(I*hr - Q*hi)
    // y_imag = sum(I*hi + Q*hr)
    ap_int<40> acc_real = 0;
    ap_int<40> acc_imag = 0;
    
    for (int i = 0; i < 8; i++) {
        ap_int<32> prod_i_hr = shift_reg_real[i] * coeffs_real[i];
        ap_int<32> prod_q_hi = shift_reg_imag[i] * coeffs_imag[i];
        ap_int<32> prod_i_hi = shift_reg_real[i] * coeffs_imag[i];
        ap_int<32> prod_q_hr = shift_reg_imag[i] * coeffs_real[i];
        
        acc_real += (prod_i_hr - prod_q_hi);
        acc_imag += (prod_i_hi + prod_q_hr);
    }
    
    // Saturate to 16-bit
    ap_int<16> max_val = 32767;
    ap_int<16> min_val = -32768;
    
    if (acc_real > max_val) y_real = max_val;
    else if (acc_real < min_val) y_real = min_val;
    else y_real = (ap_int<16>)acc_real;
    
    if (acc_imag > max_val) y_imag = max_val;
    else if (acc_imag < min_val) y_imag = min_val;
    else y_imag = (ap_int<16>)acc_imag;
}

// Calculate NMSE in dB
double calculate_nmse_dB(
    std::complex<double>* ref, std::complex<double>* dut, int len
) {
    double signal_power = 0.0;
    double noise_power = 0.0;
    
    for (int i = 0; i < len; i++) {
        signal_power += std::norm(ref[i]);
        std::complex<double> error = ref[i] - dut[i];
        noise_power += std::norm(error);
    }
    
    if (noise_power == 0.0) return -100.0;
    return 10.0 * std::log10(noise_power / signal_power);
}

int main() {
    const int num_samples = 256;
    const double nmse_threshold = -30.0;  // -30 dB
    
    // Golden model shift registers (initialized to 0)
    ap_int<16> golden_sr_real[8] = {0};
    ap_int<16> golden_sr_imag[8] = {0};
    
    // Warm-up DUT
    ap_int<16> y_real, y_imag;
    for (int i = 0; i < 8; i++) {
        kernel((ap_int<16>)0, (ap_int<16>)0, y_real, y_imag);
    }
    
    // Arrays to store outputs for NMSE calculation
    std::complex<double> ref_outputs[num_samples];
    std::complex<double> dut_outputs[num_samples];
    
    // Test with chirp signal
    bool mismatch = false;
    for (int n = 0; n < num_samples; n++) {
        // Generate complex chirp test input
        double phase = 2.0 * M_PI * n * n / (2.0 * num_samples);
        ap_int<16> x_real = (ap_int<16>)(1000.0 * std::cos(phase));
        ap_int<16> x_imag = (ap_int<16>)(1000.0 * std::sin(phase));
        
        // Golden reference
        ap_int<16> golden_y_real, golden_y_imag;
        complex_fir_golden(x_real, x_imag, golden_sr_real, golden_sr_imag, 
                           golden_y_real, golden_y_imag);
        
        // DUT
        ap_int<16> dut_y_real, dut_y_imag;
        kernel(x_real, x_imag, dut_y_real, dut_y_imag);
        
        // Store for NMSE
        ref_outputs[n] = std::complex<double>(golden_y_real.to_int(), golden_y_imag.to_int());
        dut_outputs[n] = std::complex<double>(dut_y_real.to_int(), dut_y_imag.to_int());
        
        // Check exact match
        if (dut_y_real != golden_y_real || dut_y_imag != golden_y_imag) {
            std::cout << "Mismatch at sample " << n
                      << ": expected (" << golden_y_real << ", " << golden_y_imag << ")"
                      << ", got (" << dut_y_real << ", " << dut_y_imag << ")" << std::endl;
            mismatch = true;
        }
    }
    
    // Calculate NMSE
    double nmse_dB = calculate_nmse_dB(ref_outputs, dut_outputs, num_samples);
    std::cout << "NMSE: " << nmse_dB << " dB (threshold: " << nmse_threshold << " dB)" << std::endl;
    
    if (!mismatch && nmse_dB <= nmse_threshold) {
        std::cout << "PASS" << std::endl;
        return 0;
    }
    
    std::cout << "FAIL - NMSE: " << nmse_dB << " dB" << std::endl;
    return 1;
}
