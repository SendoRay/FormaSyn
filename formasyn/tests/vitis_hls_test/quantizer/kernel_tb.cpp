#include "kernel.h"
#include <iostream>
#include <cmath>

// Golden reference for quantization
static ap_int<32> quantizer_golden(ap_int<32> x_in, ap_uint<5> bits, ap_uint<5> frac) {
    // Compute saturation limits
    long long max_val, min_val;
    if (bits >= 32) {
        max_val = 2147483647LL;
        min_val = -2147483648LL;
    } else {
        max_val = (1LL << (bits - 1)) - 1;
        min_val = -(1LL << (bits - 1));
    }
    
    long long x_val = (long long)x_in.to_int();
    
    // Saturate
    long long result;
    if (x_val > max_val) result = max_val;
    else if (x_val < min_val) result = min_val;
    else result = x_val;
    
    return (ap_int<32>)result;
}

// Calculate SQNR for quantization
double calculate_sqnr_dB(ap_int<32>* input, ap_int<32>* output, int len, int bits) {
    double signal_power = 0.0;
    double noise_power = 0.0;
    
    for (int i = 0; i < len; i++) {
        double sig = (double)input[i].to_int();
        double noise = (double)(input[i] - output[i]).to_int();
        signal_power += sig * sig;
        noise_power += noise * noise;
    }
    
    if (noise_power == 0.0) return 100.0;
    return 10.0 * std::log10(signal_power / noise_power);
}

int main() {
    const int num_tests = 1000;
    int error_count = 0;
    
    // Test various bit-widths and fractional settings
    int test_bits[] = {8, 12, 16, 20, 24};
    int num_bit_configs = 5;
    
    for (int b = 0; b < num_bit_configs; b++) {
        int bits = test_bits[b];
        ap_uint<5> bits_param = (ap_uint<5>)bits;
        ap_uint<5> frac_param = (ap_uint<5>)(bits / 2);  // Half integer, half fractional
        
        double expected_sqnr = 6.0 * bits;  // 6*bits dB theoretical
        
        ap_int<32> inputs[num_tests];
        ap_int<32> outputs[num_tests];
        
        for (int t = 0; t < num_tests; t++) {
            // Generate test input within range for this bit-width
            long long max_amp = (1LL << (bits - 1)) - 1;
            long long x_val = (t * 7919) % (max_amp * 2 + 1) - max_amp;
            ap_int<32> x_in = (ap_int<32>)x_val;
            inputs[t] = x_in;
            
            // Golden reference
            ap_int<32> golden = quantizer_golden(x_in, bits_param, frac_param);
            
            // DUT
            ap_int<32> dut_out;
            kernel(x_in, bits_param, frac_param, dut_out);
            outputs[t] = dut_out;
            
            if (dut_out != golden) {
                std::cout << "Mismatch at bits=" << bits << " test=" << t
                          << ": x_in=" << x_in
                          << ", expected=" << golden
                          << ", got=" << dut_out << std::endl;
                error_count++;
            }
        }
        
        // Calculate SQNR for this configuration
        double sqnr_dB = calculate_sqnr_dB(inputs, outputs, num_tests, bits);
        std::cout << "Bits=" << bits << ": SQNR = " << sqnr_dB 
                  << " dB (expected >= " << expected_sqnr << " dB)" << std::endl;
        
        if (sqnr_dB < expected_sqnr * 0.8) {  // Allow some margin
            std::cout << "WARNING: SQNR below expected for bits=" << bits << std::endl;
        }
    }
    
    // Test edge cases
    std::cout << "Testing edge cases..." << std::endl;
    
    // Test with 16 bits
    ap_uint<5> bits_16 = 16;
    ap_uint<5> frac_8 = 8;
    
    // Max positive value
    ap_int<32> x_max = 32767;
    ap_int<32> y_out;
    kernel(x_max, bits_16, frac_8, y_out);
    if (y_out != 32767) {
        std::cout << "Edge case fail: max positive, got " << y_out << std::endl;
        error_count++;
    }
    
    // Max negative value
    ap_int<32> x_min = -32768;
    kernel(x_min, bits_16, frac_8, y_out);
    if (y_out != -32768) {
        std::cout << "Edge case fail: max negative, got " << y_out << std::endl;
        error_count++;
    }
    
    // Overflow case (should saturate)
    ap_int<32> x_overflow = 50000;
    kernel(x_overflow, bits_16, frac_8, y_out);
    if (y_out != 32767) {
        std::cout << "Edge case fail: overflow, expected 32767, got " << y_out << std::endl;
        error_count++;
    }
    
    // Underflow case (should saturate)
    ap_int<32> x_underflow = -50000;
    kernel(x_underflow, bits_16, frac_8, y_out);
    if (y_out != -32768) {
        std::cout << "Edge case fail: underflow, expected -32768, got " << y_out << std::endl;
        error_count++;
    }
    
    if (error_count == 0) {
        std::cout << "PASS" << std::endl;
        return 0;
    }
    
    std::cout << "FAIL - Errors: " << error_count << std::endl;
    return 1;
}
