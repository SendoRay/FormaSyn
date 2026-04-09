#include <iostream>
#include <cmath>
#include "kernel.h"

int main() {
    data_in_t a[VEC_SIZE] = {1, 2, 3, 4, 5, 6, 7, 8};
    data_in_t b[VEC_SIZE] = {10, 20, 30, 40, 50, 60, 70, 80};
    data_out_t y[VEC_SIZE];
    data_out_t expected[VEC_SIZE] = {10, 40, 90, 160, 250, 360, 490, 640};
    
    vec_mul(a, b, y);
    
    // Compute NMSE
    double mse = 0.0;
    double signal_power = 0.0;
    bool pass = true;
    
    for (int i = 0; i < VEC_SIZE; i++) {
        double error = (double)(y[i] - expected[i]);
        mse += error * error;
        signal_power += (double)expected[i] * (double)expected[i];
        
        if (y[i] != expected[i]) {
            std::cout << "Mismatch at index " << i << ": got " << y[i] 
                      << ", expected " << expected[i] << std::endl;
            pass = false;
        }
    }
    
    double nmse = 10.0 * log10(mse / signal_power);
    std::cout << "NMSE = " << nmse << " dB" << std::endl;
    
    if (nmse <= -50.0) {
        std::cout << "Test PASSED (NMSE <= -50 dB)" << std::endl;
        return 0;
    } else {
        std::cout << "Test FAILED (NMSE > -50 dB)" << std::endl;
        return 1;
    }
}
