#include "kernel.h"
#include <iostream>
#include <cmath>
#include <complex>

// Golden reference for LS channel estimation
static void channel_estimate_golden(
    ap_int<16> rx_real, ap_int<16> rx_imag,
    ap_int<16> p_real, ap_int<16> p_imag,
    ap_int<16>& h_real, ap_int<16>& h_imag
) {
    // Compute numerator = rx * conj(p)
    double num_r = (double)rx_real * (double)p_real + (double)rx_imag * (double)p_imag;
    double num_i = (double)rx_imag * (double)p_real - (double)rx_real * (double)p_imag;
    
    // Compute denominator = |p|^2
    double den = (double)p_real * (double)p_real + (double)p_imag * (double)p_imag;
    
    if (den == 0) {
        h_real = 0;
        h_imag = 0;
        return;
    }
    
    // Division with proper rounding
    double h_r = num_r / den;
    double h_i = num_i / den;
    
    // Saturate to 16-bit
    if (h_r > 32767) h_real = 32767;
    else if (h_r < -32768) h_real = -32768;
    else h_real = (ap_int<16>)h_r;
    
    if (h_i > 32767) h_imag = 32767;
    else if (h_i < -32768) h_imag = -32768;
    else h_imag = (ap_int<16>)h_i;
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
    
    if (noise_power == 0.0 || signal_power == 0.0) return -100.0;
    return 10.0 * std::log10(noise_power / signal_power);
}

int main() {
    const int num_tests = 100;
    const double nmse_threshold = -20.0;  // -20 dB
    
    // Test vectors with different pilot patterns and SNR levels
    std::complex<double> ref_outputs[num_tests];
    std::complex<double> dut_outputs[num_tests];
    
    int error_count = 0;
    
    for (int t = 0; t < num_tests; t++) {
        // Generate test case with known channel and noise
        // Channel: complex gain
        double ch_real = 0.8 + 0.1 * std::sin(t * 0.1);
        double ch_imag = 0.3 + 0.1 * std::cos(t * 0.1);
        
        // Pilot: QPSK-like constellation (normalized)
        int pilot_idx = t % 4;
        double p_r[4] = {1000, 1000, -1000, -1000};  // QPSK with amplitude ~1000
        double p_i[4] = {1000, -1000, 1000, -1000};
        
        ap_int<16> p_real = (ap_int<16>)p_r[pilot_idx];
        ap_int<16> p_imag = (ap_int<16>)p_i[pilot_idx];
        
        // Received signal = channel * pilot + noise (high SNR for NMSE test)
        double noise_std = 10.0;  // High SNR condition
        double noise_r = noise_std * std::cos(t * 2.3);
        double noise_i = noise_std * std::sin(t * 2.3);
        
        double rx_r = ch_real * p_r[pilot_idx] - ch_imag * p_i[pilot_idx] + noise_r;
        double rx_i = ch_real * p_i[pilot_idx] + ch_imag * p_r[pilot_idx] + noise_i;
        
        ap_int<16> rx_real = (ap_int<16>)rx_r;
        ap_int<16> rx_imag = (ap_int<16>)rx_i;
        
        // Golden reference
        ap_int<16> golden_h_real, golden_h_imag;
        channel_estimate_golden(rx_real, rx_imag, p_real, p_imag, 
                                golden_h_real, golden_h_imag);
        
        // DUT
        ap_int<16> dut_h_real, dut_h_imag;
        kernel(rx_real, rx_imag, p_real, p_imag, dut_h_real, dut_h_imag);
        
        // Store for NMSE
        ref_outputs[t] = std::complex<double>(golden_h_real.to_int(), golden_h_imag.to_int());
        dut_outputs[t] = std::complex<double>(dut_h_real.to_int(), dut_h_imag.to_int());
        
        // Check for gross errors (more than 1 LSB difference)
        int diff_real = std::abs(dut_h_real.to_int() - golden_h_real.to_int());
        int diff_imag = std::abs(dut_h_imag.to_int() - golden_h_imag.to_int());
        
        if (diff_real > 10 || diff_imag > 10) {
            std::cout << "Large error at test " << t
                      << ": expected (" << golden_h_real << ", " << golden_h_imag << ")"
                      << ", got (" << dut_h_real << ", " << dut_h_imag << ")"
                      << ", diff=(" << diff_real << ", " << diff_imag << ")" << std::endl;
            error_count++;
        }
    }
    
    // Calculate NMSE
    double nmse_dB = calculate_nmse_dB(ref_outputs, dut_outputs, num_tests);
    std::cout << "NMSE: " << nmse_dB << " dB (threshold: " << nmse_threshold << " dB)" << std::endl;
    
    if (error_count == 0 && nmse_dB <= nmse_threshold) {
        std::cout << "PASS" << std::endl;
        return 0;
    }
    
    std::cout << "FAIL - Errors: " << error_count << ", NMSE: " << nmse_dB << " dB" << std::endl;
    return 1;
}
