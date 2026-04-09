#include "kernel.h"
#include <iostream>
#include <cmath>
#include <iomanip>

// Golden reference implementation matching the FormulaGraph semantics
static ap_int<32> correlator_golden(
    ap_int<16> x_in,
    ap_int<16> shift_reg[16]
) {
    // Same preamble as in kernel.cpp
    const ap_int<2> preamble[16] = {
        1, 1, 1, 1, -1, -1, 1, -1, 1, -1, -1, 1, 1, -1, 1, 1
    };
    
    // ShiftReg: Update delay line
    for (int i = 15; i > 0; i--) {
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;
    
    // Map(multiply) + Reduce(add): Correlation operation
    ap_int<32> acc = 0;
    for (int i = 0; i < 16; i++) {
        acc += shift_reg[i] * preamble[i];
    }
    
    return acc;
}

// Calculate NMSE between expected and actual correlation peaks
// Returns NMSE in dB
double calculate_nmse_dB(
    const double* expected,
    const double* actual,
    int len
) {
    double noise_power = 0.0;
    double signal_power = 0.0;
    
    for (int i = 0; i < len; i++) {
        double diff = expected[i] - actual[i];
        noise_power += diff * diff;
        signal_power += expected[i] * expected[i];
    }
    
    if (signal_power == 0) return -999.0;
    return 10.0 * log10(noise_power / signal_power);
}

int main() {
    const int num_samples = 200;
    int err = 0;
    
    // Golden model shift register (initialized to 0)
    ap_int<16> golden_shift_reg[16] = {0};
    
    // Warm-up DUT to initialize internal shift register
    ap_int<32> y_out;
    for (int i = 0; i < 16; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    
    // Reset golden model
    for (int i = 0; i < 16; i++) {
        golden_shift_reg[i] = 0;
    }
    
    // Arrays for NMSE calculation during preamble detection test
    const int peak_len = 32;
    double expected_peak[peak_len];
    double actual_peak[peak_len];
    int peak_idx = 0;
    
    // Test 1: Functional verification with various input patterns
    std::cout << "Test 1: Functional Verification" << std::endl;
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
        ap_int<32> golden_out = correlator_golden(x_in, golden_shift_reg);
        
        // Compute DUT output
        ap_int<32> dut_out;
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
    
    // Test 2: Preamble detection - inject exact preamble sequence
    std::cout << "\nTest 2: Preamble Detection (Matched Filter Response)" << std::endl;
    
    const ap_int<2> preamble[16] = {
        1, 1, 1, 1, -1, -1, 1, -1, 1, -1, -1, 1, 1, -1, 1, 1
    };
    
    // Scale factor for preamble values (simulate Q15 format)
    const int scale = 1000;
    
    // Reset both models
    for (int i = 0; i < 16; i++) {
        golden_shift_reg[i] = 0;
    }
    for (int i = 0; i < 16; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    for (int i = 0; i < 16; i++) {
        golden_shift_reg[i] = 0;
    }
    
    // Inject silence, then preamble, then silence
    int peak_sample = -1;
    ap_int<32> max_correlation = 0;
    
    for (int n = 0; n < 48; n++) {
        ap_int<16> x_in;
        if (n >= 10 && n < 26) {
            // Inject scaled preamble
            x_in = preamble[n - 10] * scale;
        } else {
            x_in = 0;  // Silence
        }
        
        ap_int<32> golden_out = correlator_golden(x_in, golden_shift_reg);
        ap_int<32> dut_out;
        kernel(x_in, dut_out);
        
        // Track peak for NMSE calculation window
        if (n >= 20 && n < 20 + peak_len && peak_idx < peak_len) {
            expected_peak[peak_idx] = (double)golden_out.to_int();
            actual_peak[peak_idx] = (double)dut_out.to_int();
            peak_idx++;
        }
        
        // Track maximum correlation (should occur when preamble is aligned)
        if (dut_out > max_correlation) {
            max_correlation = dut_out;
            peak_sample = n;
        }
        
        // Verify match
        if (dut_out != golden_out) {
            std::cout << "Mismatch at sample " << n
                      << ": got=" << dut_out.to_int()
                      << ", expected=" << golden_out.to_int() << std::endl;
            ++err;
        }
    }
    
    std::cout << "  Peak correlation: " << max_correlation.to_int() 
              << " at sample " << peak_sample << std::endl;
    std::cout << "  Expected peak at sample 25 (preamble fully aligned)" << std::endl;
    
    // Calculate NMSE
    double nmse_dB = calculate_nmse_dB(expected_peak, actual_peak, peak_idx);
    std::cout << "  NMSE: " << std::fixed << std::setprecision(2) << nmse_dB << " dB" << std::endl;
    
    // NMSE validation target: <= -45 dB
    if (nmse_dB > -45.0) {
        std::cout << "  WARNING: NMSE exceeds -45 dB target!" << std::endl;
    } else {
        std::cout << "  NMSE meets -45 dB target." << std::endl;
    }
    
    // Verify peak occurs at expected sample (with some tolerance)
    if (peak_sample < 24 || peak_sample > 26) {
        std::cout << "  WARNING: Peak not at expected location!" << std::endl;
    }
    
    // Test 3: Noise rejection - verify correlation with random data is low
    std::cout << "\nTest 3: Noise Rejection" << std::endl;
    
    // Reset
    for (int i = 0; i < 16; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    
    ap_int<32> noise_sum = 0;
    for (int n = 0; n < 100; n++) {
        // Random input in range [-500, 500]
        ap_int<16> x_in = (n * 37 + n * n * 13) % 1000 - 500;
        kernel(x_in, y_out);
        ap_int<32> y_out_ext = y_out;  // Extend to 32-bit
        if (y_out_ext > 0) {
            noise_sum += y_out_ext;
        } else {
            noise_sum -= y_out_ext;
        }
    }
    
    std::cout << "  Average correlation magnitude for random noise: " 
              << (noise_sum / 100).to_int() << std::endl;
    std::cout << "  Peak correlation for preamble: " << max_correlation.to_int() << std::endl;
    
    // Peak-to-noise ratio should be significant
    int peak_to_noise_ratio = max_correlation.to_int() / ((noise_sum / 100).to_int() + 1);
    std::cout << "  Peak-to-noise ratio: " << peak_to_noise_ratio << std::endl;
    
    if (err == 0) {
        std::cout << "\nPASS" << std::endl;
        return 0;
    }
    
    std::cout << "\nFAIL, err = " << err << std::endl;
    return 1;
}
