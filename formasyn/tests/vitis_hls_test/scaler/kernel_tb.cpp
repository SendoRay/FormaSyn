#include "kernel.h"
#include <iostream>
#include <cmath>

// Golden reference for scaler
static ap_int<16> scaler_golden(ap_int<16> x_in, ap_int<16> gain, int frac_bits = 14) {
    // Convert to double for precise calculation
    double x_val = (double)x_in.to_int();
    double gain_val = (double)gain.to_int() / (double)(1 << frac_bits);
    
    // Multiply
    double prod = x_val * gain_val;
    
    // Round and saturate
    double rounded = std::round(prod);
    
    if (rounded > 32767) return 32767;
    if (rounded < -32768) return -32768;
    return (ap_int<16>)rounded;
}

// Calculate NMSE in dB
double calculate_nmse_dB(double* ref, double* dut, int len) {
    double signal_power = 0.0;
    double noise_power = 0.0;
    
    for (int i = 0; i < len; i++) {
        signal_power += ref[i] * ref[i];
        double error = ref[i] - dut[i];
        noise_power += error * error;
    }
    
    if (noise_power == 0.0 || signal_power == 0.0) return -100.0;
    return 10.0 * std::log10(noise_power / signal_power);
}

int main() {
    const int num_tests = 1000;
    const double nmse_threshold = -50.0;  // -50 dB
    const int frac_bits = 14;  // Q1.14 format
    
    int error_count = 0;
    
    // Test various gain values
    // Unity gain (1.0 in Q1.14)
    ap_int<16> gain_unity = 1 << frac_bits;
    // 0.5 gain
    ap_int<16> gain_half = 1 << (frac_bits - 1);
    // 1.5 gain
    ap_int<16> gain_1_5 = (3 << (frac_bits - 1));
    // 0.1 gain
    ap_int<16> gain_0_1 = (ap_int<16>)(0.1 * (1 << frac_bits));
    
    ap_int<16> test_gains[] = {gain_unity, gain_half, gain_1_5, gain_0_1};
    const char* gain_names[] = {"unity", "0.5", "1.5", "0.1"};
    int num_gains = 4;
    
    for (int g = 0; g < num_gains; g++) {
        ap_int<16> gain = test_gains[g];
        double gain_f = (double)gain.to_int() / (1 << frac_bits);
        
        double ref_outputs[num_tests];
        double dut_outputs[num_tests];
        
        std::cout << "Testing gain=" << gain_names[g] << " (" << gain_f << ")" << std::endl;
        
        for (int t = 0; t < num_tests; t++) {
            // Generate test input
            int x_val = (t * 12345) % 65536 - 32768;
            ap_int<16> x_in = (ap_int<16>)x_val;
            
            // Golden reference
            ap_int<16> golden = scaler_golden(x_in, gain, frac_bits);
            
            // DUT
            ap_int<16> dut_out;
            kernel(x_in, gain, dut_out);
            
            // Store for NMSE
            ref_outputs[t] = (double)golden.to_int();
            dut_outputs[t] = (double)dut_out.to_int();
            
            // Check exact match
            if (dut_out != golden) {
                // Allow small difference due to rounding
                int diff = std::abs(dut_out.to_int() - golden.to_int());
                if (diff > 1) {
                    std::cout << "Mismatch at gain=" << gain_names[g] << " test=" << t
                              << ": x=" << x_in
                              << ", expected=" << golden
                              << ", got=" << dut_out
                              << ", diff=" << diff << std::endl;
                    error_count++;
                }
            }
        }
        
        // Calculate NMSE for this gain
        double nmse_dB = calculate_nmse_dB(ref_outputs, dut_outputs, num_tests);
        std::cout << "  NMSE = " << nmse_dB << " dB (threshold: " << nmse_threshold << " dB)" << std::endl;
        
        if (nmse_dB > nmse_threshold) {
            std::cout << "  WARNING: NMSE above threshold for gain=" << gain_names[g] << std::endl;
            error_count++;
        }
    }
    
    // Test edge cases
    std::cout << "Testing edge cases..." << std::endl;
    
    // Max positive input with unity gain
    ap_int<16> result;
    kernel(32767, gain_unity, result);
    if (result != 32767) {
        std::cout << "Edge case fail: max pos * unity, got " << result << std::endl;
        error_count++;
    }
    
    // Max negative input with unity gain
    kernel(-32768, gain_unity, result);
    if (result != -32768) {
        std::cout << "Edge case fail: max neg * unity, got " << result << std::endl;
        error_count++;
    }
    
    // Saturation case
    kernel(30000, gain_1_5, result);
    if (result != 32767) {
        // Should saturate
        std::cout << "Saturation case: 30000 * 1.5 = " << result << " (expected 32767)" << std::endl;
    }
    
    // Zero gain
    kernel(10000, (ap_int<16>)0, result);
    if (result != 0) {
        std::cout << "Edge case fail: x * 0, got " << result << std::endl;
        error_count++;
    }
    
    // Negative gain
    ap_int<16> gain_neg = -(ap_int<16>)(0.5 * (1 << frac_bits));
    kernel(1000, gain_neg, result);
    ap_int<16> expected_neg = -500;  // 1000 * -0.5 = -500
    if (result != expected_neg) {
        std::cout << "Edge case fail: x * -0.5, expected " << expected_neg << ", got " << result << std::endl;
        error_count++;
    }
    
    if (error_count == 0) {
        std::cout << "PASS" << std::endl;
        return 0;
    }
    
    std::cout << "FAIL - Errors: " << error_count << std::endl;
    return 1;
}
