#include <iostream>
#include <cmath>
#include "kernel.h"

// 16-QAM Mapper Testbench
// Tests all input combinations and verifies EVM compliance

int main() {
    std::cout << "=== 16-QAM Mapper Testbench ===" << std::endl;
    
    const float scale_factor = 1000.0f;
    const float evm_threshold = 0.03f;  // 3% EVM threshold
    
    // 16-QAM Gray-coded constellation mapping
    // Bits split: b3b2 for I (MSB), b1b0 for Q (LSB)
    // Gray: 00->-3, 01->-1, 11->+1, 10->+3
    const float qam_levels[4] = {-3.0f, -1.0f, 3.0f, 1.0f};  // Note: index 2=10, index 3=11
    
    // More accurate level lookup by gray code
    const float gray_to_level[4] = {-3.0f, -1.0f, 3.0f, 1.0f};  // 00, 01, 10, 11
    
    bool all_pass = true;
    float max_evm = 0.0f;
    
    // Test all 16 possible input values
    for (int i = 0; i < 16; i++) {
        ap_uint<4> bits_in = i;
        ap_int<16> y_real, y_imag;
        
        // Call DUT
        qam16_mapper(bits_in, &y_real, &y_imag);
        
        // Extract I and Q bits
        int i_bits = (i >> 2) & 0x3;  // bits[3:2]
        int q_bits = i & 0x3;          // bits[1:0]
        
        // Calculate expected values
        float expected_i = gray_to_level[i_bits];
        float expected_q = gray_to_level[q_bits];
        
        // Calculate errors
        float measured_i = y_real.to_float() / scale_factor;
        float measured_q = y_imag.to_float() / scale_factor;
        
        float error_i = measured_i - expected_i;
        float error_q = measured_q - expected_q;
        
        // EVM as magnitude of error vector
        float evm = std::sqrt(error_i * error_i + error_q * error_q);
        
        if (evm > max_evm) max_evm = evm;
        
        bool pass = evm <= evm_threshold;
        
        std::cout << "Input: 0x" << std::hex << i << std::dec
                  << " (I_bits=" << i_bits << ", Q_bits=" << q_bits << ")"
                  << " | I/Q: (" << y_real << ", " << y_imag << ")"
                  << " | Expected: (" << expected_i << ", " << expected_q << ")"
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
