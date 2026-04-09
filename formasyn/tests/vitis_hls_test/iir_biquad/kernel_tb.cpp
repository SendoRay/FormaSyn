#include "kernel.h"
#include <iostream>
#include <cmath>

// Golden reference using same Q8 coefficients
static ap_int<16> iir_golden(ap_int<16> x_in, double& w1, double& w2) {
    const double Q = 256.0;
    const double b0 = 17.0/Q, b1 = 35.0/Q, b2 = 17.0/Q;
    const double a1 = 182.0/Q, a2 = -67.0/Q;
    
    // w[n] = x[n] - a1*w[n-1] - a2*w[n-2]
    double w0 = x_in - a1*w1 - a2*w2;
    
    // y[n] = b0*w[n] + b1*w[n-1] + b2*w[n-2]
    double y = b0*w0 + b1*w1 + b2*w2;
    
    w2 = w1;
    w1 = w0;
    
    if (y > 32767) return 32767;
    if (y < -32768) return -32768;
    return (ap_int<16>)(y >= 0 ? y + 0.5 : y - 0.5);
}

int main() {
    const int num = 100;
    int err = 0;
    
    double w1 = 0, w2 = 0;
    ap_int<16> y;
    
    // Test with sine wave
    for (int n = 0; n < num; n++) {
        ap_int<16> x = (ap_int<16>)(500.0 * sin(2.0 * 3.14159 * n / 20));
        
        ap_int<16> golden = iir_golden(x, w1, w2);
        kernel(x, y);
        
        int diff = std::abs((int)y - (int)golden);
        if (diff > 2) {
            if (err < 3) {
                std::cout << "Mismatch at " << n << ": x=" << x 
                          << ", got=" << y << ", exp=" << golden << std::endl;
            }
            err++;
        }
    }
    
    if (err == 0) std::cout << "PASS" << std::endl;
    else std::cout << "FAIL, err=" << err << std::endl;
    
    return err == 0 ? 0 : 1;
}
