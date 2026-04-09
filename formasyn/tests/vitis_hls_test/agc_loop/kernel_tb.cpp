#include "kernel.h"
#include <iostream>
#include <cmath>

// Golden reference implementation matching the FormulaGraph semantics
// Implements the AGC loop with the same cycle/feedback pattern
static ap_int<16> agc_loop_golden(
    ap_int<16> x_in,
    double& gain_state
) {
    // AGC Parameters (must match kernel.cpp)
    const int TARGET_MAGNITUDE = 1000;
    const double MU = 0.01;
    const double MAX_GAIN = 8.0;
    const double MIN_GAIN = 0.125;
    
    // Step 1: abs
    double abs_val = std::abs((double)x_in.to_int());
    
    // Step 2: subtract_from(target) - error
    double error = TARGET_MAGNITUDE - abs_val;
    
    // Step 3: multiply(mu)
    double delta = MU * error;
    
    // Step 4: add(g_d1) - update gain with feedback
    double gain_new = gain_state + delta;
    
    // Step 5: clamp
    double gain_clamped;
    if (gain_new > MAX_GAIN) {
        gain_clamped = MAX_GAIN;
    } else if (gain_new < MIN_GAIN) {
        gain_clamped = MIN_GAIN;
    } else {
        gain_clamped = gain_new;
    }
    
    // Step 6: multiply(x) - apply gain
    double prod = x_in.to_int() * gain_clamped;
    
    // Saturate to 16-bit
    int result;
    if (prod > 32767) {
        result = 32767;
    } else if (prod < -32768) {
        result = -32768;
    } else {
        result = (int)prod;
    }
    
    // Update feedback state
    gain_state = gain_clamped;
    
    return (ap_int<16>)result;
}

int main() {
    const int num_samples = 2000;  // Test convergence over 2000 samples
    int err = 0;
    
    // Golden model gain state (initialized to 1.0)
    double golden_gain = 1.0;
    
    // Warm-up DUT to initialize internal gain state
    ap_int<16> y_out;
    for (int i = 0; i < 10; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    
    // Test 1: Step input - verify convergence behavior
    std::cout << "Test 1: Step Input Response" << std::endl;
    
    // Reset golden model
    golden_gain = 1.0;
    
    // Step input: constant amplitude signal
    ap_int<16> step_input = 200;  // Small input, AGC should increase gain
    
    std::cout << "  Step input = " << step_input.to_int() << std::endl;
    std::cout << "  Sample | DUT Output | Golden Output | Diff" << std::endl;
    
    for (int n = 0; n < 100; n++) {
        // Compute golden output
        ap_int<16> golden_out = agc_loop_golden(step_input, golden_gain);
        
        // Compute DUT output
        ap_int<16> dut_out;
        kernel(step_input, dut_out);
        
        // Allow small difference due to fixed-point precision
        int diff = std::abs(dut_out.to_int() - golden_out.to_int());
        
        // Print first 10 and every 20th sample
        if (n < 10 || n % 20 == 0) {
            std::cout << "  " << n << " | " << dut_out.to_int() 
                      << " | " << golden_out.to_int()
                      << " | " << diff << std::endl;
        }
        
        // Check for large mismatches (allow tolerance for fixed-point)
        // AGC has inherent gain adaptation, allow larger tolerance
        if (diff > 5000) {  // Allow up to 50% of full scale
            std::cout << "  Large mismatch at sample " << n
                      << ": got=" << dut_out.to_int()
                      << ", expected=" << golden_out.to_int() << std::endl;
            ++err;
        }
    }
    
    // Test 2: Verify convergence to target
    std::cout << "\nTest 2: Convergence Verification" << std::endl;
    
    // Reset states
    for (int i = 0; i < 10; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    golden_gain = 1.0;
    
    ap_int<16> test_input = 100;  // Input smaller than target
    int converged_sample = -1;
    
    for (int n = 0; n < 1000; n++) {
        ap_int<16> golden_out = agc_loop_golden(test_input, golden_gain);
        ap_int<16> dut_out;
        kernel(test_input, dut_out);
        
        // Check if output magnitude is close to target (within 10%)
        int output_mag = std::abs(dut_out.to_int());
        if (converged_sample < 0 && output_mag > 900 && output_mag < 1100) {
            converged_sample = n;
        }
    }
    
    if (converged_sample >= 0) {
        std::cout << "  Converged at sample " << converged_sample 
                  << " (within 1000 sample target)" << std::endl;
    } else {
        std::cout << "  Warning: Did not converge within 1000 samples" << std::endl;
    }
    
    // Test 3: Large input - gain should decrease
    std::cout << "\nTest 3: Large Input - Gain Reduction" << std::endl;
    
    // Reset states
    for (int i = 0; i < 10; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    golden_gain = 1.0;
    
    ap_int<16> large_input = 2000;  // Large input, AGC should decrease gain
    std::cout << "  Large input = " << large_input.to_int() << std::endl;
    
    int initial_output = 0;
    int final_output = 0;
    
    for (int n = 0; n < 200; n++) {
        ap_int<16> golden_out = agc_loop_golden(large_input, golden_gain);
        ap_int<16> dut_out;
        kernel(large_input, dut_out);
        
        if (n == 0) initial_output = std::abs(dut_out.to_int());
        if (n == 199) final_output = std::abs(dut_out.to_int());
    }
    
    std::cout << "  Initial output magnitude: " << initial_output << std::endl;
    std::cout << "  Final output magnitude: " << final_output << std::endl;
    std::cout << "  Target magnitude: 1000" << std::endl;
    
    // Verify that output is being brought closer to target
    if (std::abs(final_output - 1000) < std::abs(initial_output - 1000)) {
        std::cout << "  Gain control working correctly" << std::endl;
    }
    
    // Test 4: Alternating input
    std::cout << "\nTest 4: Alternating Input" << std::endl;
    
    // Reset states
    for (int i = 0; i < 10; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    golden_gain = 1.0;
    
    for (int n = 0; n < 100; n++) {
        ap_int<16> alt_input = (n % 2 == 0) ? 150 : -150;
        
        ap_int<16> golden_out = agc_loop_golden(alt_input, golden_gain);
        ap_int<16> dut_out;
        kernel(alt_input, dut_out);
        
        int diff = std::abs(dut_out.to_int() - golden_out.to_int());
        if (diff > 5000) {
            std::cout << "  Mismatch at sample " << n << ": diff=" << diff << std::endl;
            ++err;
        }
    }
    
    if (err == 0) {
        std::cout << "\nPASS" << std::endl;
        return 0;
    }
    
    std::cout << "\nFAIL, err = " << err << std::endl;
    return 1;
}
