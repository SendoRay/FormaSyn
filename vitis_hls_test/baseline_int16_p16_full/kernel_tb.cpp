#include "kernel.h"

#include <iostream>

static ap_int<8> golden_step(ap_int<8> x_in) {
    static ap_int<8> taps[16] = {0};
    const ap_int<8> coeffs[16] = {1, 2, 3, 4, 5, 6, 7, 8, 8, 7, 6, 5, 4, 3, 2, 1};

    for (int i = 15; i > 0; --i) {
        taps[i] = taps[i - 1];
    }
    taps[0] = x_in;

    ap_int<16> y_out = 0;
    for (int i = 0; i < 16; ++i) {
        y_out += taps[i] * coeffs[i];
    }

    ap_int<16> scaled = (y_out * 3) >> 2;
    if (scaled > 127) {
        return 127;
    }
    if (scaled < -128) {
        return -128;
    }
    return ap_int<8>(scaled);
}

int main() {
    int err = 0;
    const int num_samples = 64;

    for (int n = 0; n < num_samples; ++n) {
        ap_int<8> x_in = (n % 23) - 11;
        ap_int<8> dut_out = 0;
        ap_int<8> golden_out = golden_step(x_in);

        kernel(x_in, dut_out);

        if (dut_out != golden_out) {
            std::cout << "Mismatch at sample " << n
                      << ": in=" << int(x_in)
                      << ", got=" << int(dut_out)
                      << ", expected=" << int(golden_out) << std::endl;
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
