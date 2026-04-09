#include <iostream>
#include <cmath>
#include "kernel.h"

int main() {
    data_in_t a[VEC_SIZE] = {1, 2, 3, 4, 5, 6, 7, 8};
    data_in_t b[VEC_SIZE] = {10, 20, 30, 40, 50, 60, 70, 80};
    data_out_t y;
    // Expected: 1*10 + 2*20 + 3*30 + 4*40 + 5*50 + 6*60 + 7*70 + 8*80
    // = 10 + 40 + 90 + 160 + 250 + 360 + 490 + 640 = 2040
    data_out_t expected = 2040;
    
    vec_dot(a, b, &y);
    
    // Compute NMSE
    double error = (double)(y - expected);
    double mse = error * error;
    double signal_power = (double)expected * (double)expected;
    
    double nmse = 10.0 * log10(mse / signal_power);
    std::cout << "Result = " << y << std::endl;
    std::cout << "Expected = " << expected << std::endl;
    std::cout << "NMSE = " << nmse << " dB" << std::endl;
    
    if (y != expected) {
        std::cout << "Mismatch: got " << y << ", expected " << expected << std::endl;
    }
    
    if (nmse <= -50.0) {
        std::cout << "Test PASSED (NMSE <= -50 dB)" << std::endl;
        return 0;
    } else {
        std::cout << "Test FAILED (NMSE > -50 dB)" << std::endl;
        return 1;
    }
}
