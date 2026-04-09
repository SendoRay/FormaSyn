#include "kernel.h"
#include <iostream>
#include <cmath>

// Golden reference for halfband FIR
static ap_int<16> fir_halfband_golden(
    ap_int<16> x_in,
    ap_int<16> shift_reg[17]
) {
    // Halfband coefficients (17-tap)
    const ap_int<16> coeffs[17] = {
        -21, 0, 0, 0, 133, 0, 0, 0, 512, 0, 0, 0, 133, 0, 0, 0, -21
    };
    
    // Shift register update
    for (int i = 16; i > 0; i--) {
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;
    
    // MAC operation
    ap_int<40> acc = 0;
    for (int i = 0; i < 17; i++) {
        acc += shift_reg[i] * coeffs[i];
    }
    
    // Scale and saturate (Q9 format)
    ap_int<16> scaled = acc >> 9;
    ap_int<16> max_val = 32767;
    ap_int<16> min_val = -32768;
    
    if (scaled > max_val) return max_val;
    if (scaled < min_val) return min_val;
    return scaled;
}

int main() {
    const int num_samples = 100;
    int err = 0;
    
    // Golden model shift register
    ap_int<16> golden_shift_reg[17] = {0};
    
    // Warm-up DUT
    ap_int<16> y_out;
    for (int i = 0; i < 17; i++) {
        ap_int<16> zero = 0;
        kernel(zero, y_out);
    }
    
    // Reset golden model
    for (int i = 0; i < 17; i++) {
        golden_shift_reg[i] = 0;
    }
    
    // Test with various inputs
    for (int n = 0; n < num_samples; n++) {
        ap_int<16> x_in = (n % 1000) - 500;
        
        ap_int<16> golden_out = fir_halfband_golden(x_in, golden_shift_reg);
        
        ap_int<16> dut_out;
        kernel(x_in, dut_out);
        
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
