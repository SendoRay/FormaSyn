#include <iostream>
#include <cmath>
#include "kernel.h"

// BPSK Mapper Testbench
// Tests all input combinations and verifies EVM compliance

int main() {
    std::cout << "=== BPSK Mapper Testbench ===" << std::endl;
    
    const float scale_factor = 1000.0f;
    const float evm_threshold = 0.05f;  // 5% EVM threshold
    
    // Expected constellation points (floating point reference)
    const float expected[2] = {-1.0f, 1.0f};
    
    bool all_pass = true;
    float max_evm = 0.0f;
    
    // Test all 2 possible input values
    for (int i = 0; i < 2; i++) {
        ap_uint<1> bit_in = i;
        ap_int<16> y_out;
        
        // Call DUT
        bpsk_mapper(bit_in, &y_out);
        
        // Calculate error
        float measured = y_out.to_float() / scale_factor;
        float error = measured - expected[i];
        float evm = std::abs(error);
        
        if (evm > max_evm) max_evm = evm;
        
        bool pass = evm <= evm_threshold;
        
        std::cout << "Input bit: " << i 
                  << " | Output: " << y_out 
                  << " | Expected: " << expected[i]
                  << " | Measured: " << measured
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
