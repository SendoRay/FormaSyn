#include <iostream>
#include <cmath>
#include "kernel.h"

// QPSK Mapper Testbench
// Tests all input combinations and verifies EVM compliance

int main() {
    std::cout << "=== QPSK Mapper Testbench ===" << std::endl;
    
    const float scale_factor = 1000.0f;
    const float evm_threshold = 0.05f;  // 5% EVM threshold
    const float sqrt2_inv = 0.7071067811865475f;  // 1/sqrt(2)
    
    // Expected constellation points (Gray-coded QPSK)
    // 00 -> (+0.707, +0.707)
    // 01 -> (+0.707, -0.707)
    // 10 -> (-0.707, +0.707)
    // 11 -> (-0.707, -0.707)
    const float expected_i[4] = { sqrt2_inv,  sqrt2_inv, -sqrt2_inv, -sqrt2_inv};
    const float expected_q[4] = { sqrt2_inv, -sqrt2_inv,  sqrt2_inv, -sqrt2_inv};
    
    bool all_pass = true;
    float max_evm = 0.0f;
    
    // Test all 4 possible input values
    for (int i = 0; i < 4; i++) {
        ap_uint<2> bits_in = i;
        ap_int<16> y_real, y_imag;
        
        // Call DUT
        qpsk_mapper(bits_in, &y_real, &y_imag);
        
        // Calculate errors
        float measured_i = y_real.to_float() / scale_factor;
        float measured_q = y_imag.to_float() / scale_factor;
        
        float error_i = measured_i - expected_i[i];
        float error_q = measured_q - expected_q[i];
        
        // EVM as magnitude of error vector
        float evm = std::sqrt(error_i * error_i + error_q * error_q);
        
        if (evm > max_evm) max_evm = evm;
        
        bool pass = evm <= evm_threshold;
        
        std::cout << "Input: " << i 
                  << " | I/Q: (" << y_real << ", " << y_imag << ")"
                  << " | Expected: (" << expected_i[i] << ", " << expected_q[i] << ")"
                  << " | Measured: (" << measured_i << ", " << measured_q << ")"
                  << " | EVM: " << (evm * 100) << "%"
                  << " | " << (pass ? "PASS" : "FAIL") << std::endl;
        
        if (!pass) all_pass = false;
    }
    
    std::cout << "\n=== Summary ===" << std::endl;
    std::cout << "Max EVM: " << (max_evm * 100) << "% (threshold: " << (evm_threshold * 100) << "%)" << std::endl;
    
    if (all_pass) {
        std::cout << "All tests PASSED!" << std::endl;
        return 0;
    } else {
        std::cout << "Some tests FAILED!" << std::endl;
        return 1;
    }
}
