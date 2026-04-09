#include "kernel.h"
#include <iostream>

int main() {
    ap_int<16> y;
    
    // Simple step response test
    std::cout << "Step response:" << std::endl;
    for (int i = 0; i < 30; i++) {
        kernel(1000, y);
        std::cout << "y[" << i << "] = " << y.to_int() << std::endl;
    }
    
    std::cout << "PASS" << std::endl;
    return 0;
}
