#include "kernel.h"
#include <iostream>

// Golden reference for RRC FIR
static ap_int<16> fir_rrc_golden(
    ap_int<16> x_in,
    ap_int<16> shift_reg[33]
) {
    // RRC coefficients (33-tap, alpha=0.35)
    const ap_int<16> coeffs[33] = {
        -12, -28, -45, -48, -24, 40, 136, 254,
        363, 427, 416, 322, 161, -38, -228, -360,
        -403, -360, -228, -38, 161, 322, 416, 427,
        363, 254, 136, 40, -24, -48, -45, -28, -12
    };
    
    // Shift register update
    for (int i = 32; i > 0; i--) {
        shift_reg[i] = shift_reg[i-1];
    }
    shift_reg[0] = x_in;
    
    // MAC operation
    ap_int<40> acc = 0;
    for (int i = 0; i < 33; i++) {
        acc += shift_reg[i] * coeffs[i];
    }
    
    // Saturate
    ap_int<16> max_val = 32767;
    ap_int<16> min_val = -32768;
    
    if (acc > max_val) return max_val;
    if (acc < min_val) return min_val;
    return (ap_int<16>)acc;
}

int main() {
    const int num_samples = 100;
    int err = 0;
    
    ap_int<16> golden_shift_reg[33] = {0};
    
    // Warm-up DUT
    ap_int<16> y_out;
    for (int i = 0; i < 33; i++) {
        kernel((ap_int<16>)0, y_out);
    }
    
    // Reset golden
    for (int i = 0; i < 33; i++) golden_shift_reg[i] = 0;
    
    // Test
    for (int n = 0; n < num_samples; n++) {
        ap_int<16> x_in = (n % 500) - 250;
        
        ap_int<16> golden_out = fir_rrc_golden(x_in, golden_shift_reg);
        
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
