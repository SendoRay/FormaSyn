#include <iostream>
#include <cmath>
#include "kernel.h"

int main() {
    // Test case 1: max at index 5
    data_t a[VEC_SIZE] = {10, 25, 15, 30, 5, 100, 50, 20};
    data_t y;
    idx_t idx;
    
    vec_max(a, &y, &idx);
    
    std::cout << "Test 1:" << std::endl;
    std::cout << "  Input: [10, 25, 15, 30, 5, 100, 50, 20]" << std::endl;
    std::cout << "  Max value = " << y << std::endl;
    std::cout << "  Max index = " << idx << std::endl;
    
    bool pass = true;
    if (y != 100) {
        std::cout << "  FAIL: Expected max value 100, got " << y << std::endl;
        pass = false;
    }
    if (idx != 5) {
        std::cout << "  FAIL: Expected index 5, got " << idx << std::endl;
        pass = false;
    }
    
    // Test case 2: max at first element
    data_t a2[VEC_SIZE] = {99, 10, 20, 30, 40, 50, 60, 70};
    data_t y2;
    idx_t idx2;
    
    vec_max(a2, &y2, &idx2);
    
    std::cout << "Test 2:" << std::endl;
    std::cout << "  Input: [99, 10, 20, 30, 40, 50, 60, 70]" << std::endl;
    std::cout << "  Max value = " << y2 << std::endl;
    std::cout << "  Max index = " << idx2 << std::endl;
    
    if (y2 != 99) {
        std::cout << "  FAIL: Expected max value 99, got " << y2 << std::endl;
        pass = false;
    }
    if (idx2 != 0) {
        std::cout << "  FAIL: Expected index 0, got " << idx2 << std::endl;
        pass = false;
    }
    
    // Test case 3: max at last element
    data_t a3[VEC_SIZE] = {1, 2, 3, 4, 5, 6, 7, 88};
    data_t y3;
    idx_t idx3;
    
    vec_max(a3, &y3, &idx3);
    
    std::cout << "Test 3:" << std::endl;
    std::cout << "  Input: [1, 2, 3, 4, 5, 6, 7, 88]" << std::endl;
    std::cout << "  Max value = " << y3 << std::endl;
    std::cout << "  Max index = " << idx3 << std::endl;
    
    if (y3 != 88) {
        std::cout << "  FAIL: Expected max value 88, got " << y3 << std::endl;
        pass = false;
    }
    if (idx3 != 7) {
        std::cout << "  FAIL: Expected index 7, got " << idx3 << std::endl;
        pass = false;
    }
    
    if (pass) {
        std::cout << "All tests PASSED (100% correctness)" << std::endl;
        return 0;
    } else {
        std::cout << "Some tests FAILED" << std::endl;
        return 1;
    }
}
