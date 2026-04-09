#include "kernel.h"
#include <iostream>
#include <cmath>

// Golden reference implementation matching the FormulaGraph semantics
static ap_int<16> fir_direct_golden(
    ap_int<16> x_in,
    ap_int<16> shift_reg[16]
) {
    // Same coefficients as in kernel.cpp
    const ap_int<16> coeffs[16] = {
        10, 20, 30, 50, 70, 90, 110, 127,
        127, 110, 90, 70, 50, 30, 20, 10
    };
    
    // ShiftReg: Update delay line
    for (int i = 15; i > 0; i--) {
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;
    
    // Map(multiply) + Reduce(add): MAC operation
    ap_int<40> acc = 0;  // Match ACC_WIDTH in kernel
    for (int i = 0; i < 16; i++) {
        acc += shift_reg[i] * coeffs[i];
    }
    
    // Saturate to 16-bit output
    ap_int<16> max_val = 32767;   // (1 << 15) - 1
    ap_int<16> min_val = -32768;  // -(1 << 15)
    
    if (acc > max_val) return max_val;
    if (acc < min_val) return min_val;
    return (ap_int<16>)acc;
}

int main() {
    const int num_samples = 100;
    int err = 0;
    
    // Golden model shift register (initialized to 0)
    ap_int<16> golden_shift_reg[16] = {0};
    
    // Warm-up DUT to initialize internal shift register
    ap_int<16> y_out;
    for (int i = 0; i < 16; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    
    // Reset golden model
    for (int i = 0; i < 16; i++) {
        golden_shift_reg[i] = 0;
    }
    
    // Test with various input patterns
    for (int n = 0; n < num_samples; n++) {
        // Generate test input: impulse, step, ramp, and pseudo-random
        ap_int<16> x_in;
        if (n == 0) {
            x_in = 1000;  // Impulse
        } else if (n < 10) {
            x_in = 500;   // Step
        } else if (n < 20) {
            x_in = n * 50;  // Ramp
        } else {
            x_in = (n * 17) % 2000 - 1000;  // Pseudo-random
        }
        
        // Compute golden output
        ap_int<16> golden_out = fir_direct_golden(x_in, golden_shift_reg);
        
        // Compute DUT output
        ap_int<16> dut_out;
        kernel(x_in, dut_out);
        
        // Compare
        if (dut_out != golden_out) {
            std::cout << "Mismatch at sample " << n
                      << ": x=" << x_in.to_int()
                      << ", got=" << dut_out.to_int()
                      << ", expected=" << golden_out.to_int() << std::endl;
            ++err;
        }
    }
    
    if (err == 0) {
        std::cout << "PASS" << std::endl;
        return 0;
    }
    
    std::cout << "FAIL, err = " << err << std::endl;
    return 1;
}
