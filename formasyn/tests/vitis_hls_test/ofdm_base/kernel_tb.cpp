#include "kernel.h"
#include <iostream>
#include <cmath>
#include <cstdlib>

using namespace std;

// Golden reference IFFT for comparison
void golden_ifft_16(complex_t in[OFDM_N], complex_t out[OFDM_N]) {
    for (int n = 0; n < OFDM_N; n++) {
        complex_t sum(0, 0);
        for (int k = 0; k < OFDM_N; k++) {
            // IFFT: x[n] = (1/N) * sum(X[k] * exp(j*2*pi*k*n/N))
            double angle = 2.0 * M_PI * k * n / OFDM_N;
            complex_t twiddle(cos(angle), sin(angle));
            sum = sum + in[k] * twiddle;
        }
        out[n] = sum * data_t(1.0/16.0);
    }
}

// Calculate EVM (Error Vector Magnitude) in percentage
double calculate_evm(complex_t ref[OFDM_SYM_LEN], complex_t dut[OFDM_SYM_LEN]) {
    double error_sum = 0.0;
    double signal_sum = 0.0;
    
    for (int i = 0; i < OFDM_SYM_LEN; i++) {
        double ref_real = ref[i].real().to_double();
        double ref_imag = ref[i].imag().to_double();
        double dut_real = dut[i].real().to_double();
        double dut_imag = dut[i].imag().to_double();
        
        double err_real = ref_real - dut_real;
        double err_imag = ref_imag - dut_imag;
        
        error_sum += err_real * err_real + err_imag * err_imag;
        signal_sum += ref_real * ref_real + ref_imag * ref_imag;
    }
    
    if (signal_sum < 1e-10) return 0.0;
    return 100.0 * sqrt(error_sum / signal_sum);
}

// Test case 1: Impulse at DC
void test_impulse_dc() {
    cout << "\n=== Test 1: Impulse at DC ===" << endl;
    
    complex_t in[OFDM_N];
    complex_t out[OFDM_SYM_LEN];
    complex_t golden_out[OFDM_N];
    complex_t golden_with_cp[OFDM_SYM_LEN];
    
    // Initialize with impulse at DC
    for (int i = 0; i < OFDM_N; i++) {
        in[i] = (i == 0) ? complex_t(data_t(1.0), data_t(0.0)) : complex_t(data_t(0.0), data_t(0.0));
    }
    
    // Run DUT
    ofdm_base(in, out);
    
    // Golden reference
    golden_ifft_16(in, golden_out);
    
    // Add CP to golden reference
    for (int i = 0; i < OFDM_SYM_LEN; i++) {
        if (i < CP_LEN) {
            golden_with_cp[i] = golden_out[OFDM_N - CP_LEN + i];
        } else {
            golden_with_cp[i] = golden_out[i - CP_LEN];
        }
    }
    
    // Calculate EVM
    double evm = calculate_evm(golden_with_cp, out);
    cout << "EVM = " << evm << "%" << endl;
    
    // Expected: constant output for DC input
    cout << "Output samples (real, imag):" << endl;
    for (int i = 0; i < OFDM_SYM_LEN; i++) {
        cout << "  [" << i << "] = (" << out[i].real() << ", " << out[i].imag() << ")" << endl;
    }
    
    if (evm <= 6.0) {
        cout << "TEST PASSED: EVM <= 6%" << endl;
    } else {
        cout << "TEST FAILED: EVM > 6%" << endl;
    }
}

// Test case 2: Single tone at index 1
void test_single_tone() {
    cout << "\n=== Test 2: Single Tone at Index 1 ===" << endl;
    
    complex_t in[OFDM_N];
    complex_t out[OFDM_SYM_LEN];
    complex_t golden_out[OFDM_N];
    complex_t golden_with_cp[OFDM_SYM_LEN];
    
    // Initialize with single tone
    for (int i = 0; i < OFDM_N; i++) {
        in[i] = (i == 1) ? complex_t(data_t(1.0), data_t(0.0)) : complex_t(data_t(0.0), data_t(0.0));
    }
    
    // Run DUT
    ofdm_base(in, out);
    
    // Golden reference
    golden_ifft_16(in, golden_out);
    
    // Add CP to golden reference
    for (int i = 0; i < OFDM_SYM_LEN; i++) {
        if (i < CP_LEN) {
            golden_with_cp[i] = golden_out[OFDM_N - CP_LEN + i];
        } else {
            golden_with_cp[i] = golden_out[i - CP_LEN];
        }
    }
    
    // Calculate EVM
    double evm = calculate_evm(golden_with_cp, out);
    cout << "EVM = " << evm << "%" << endl;
    
    if (evm <= 6.0) {
        cout << "TEST PASSED: EVM <= 6%" << endl;
    } else {
        cout << "TEST FAILED: EVM > 6%" << endl;
    }
}

// Test case 3: QPSK-like random symbols
void test_qpsk_random() {
    cout << "\n=== Test 3: QPSK-like Random Symbols ===" << endl;
    
    complex_t in[OFDM_N];
    complex_t out[OFDM_SYM_LEN];
    complex_t golden_out[OFDM_N];
    complex_t golden_with_cp[OFDM_SYM_LEN];
    
    // QPSK constellation points: (+-1/sqrt(2), +-1/sqrt(2))
    const double qpsk_val = 0.7071;
    complex_t qpsk[4] = {
        complex_t(data_t(qpsk_val), data_t(qpsk_val)),
        complex_t(data_t(-qpsk_val), data_t(qpsk_val)),
        complex_t(data_t(qpsk_val), data_t(-qpsk_val)),
        complex_t(data_t(-qpsk_val), data_t(-qpsk_val))
    };
    
    // Random seed for reproducibility
    srand(42);
    
    // Generate random QPSK symbols
    for (int i = 0; i < OFDM_N; i++) {
        in[i] = qpsk[rand() % 4];
    }
    
    // Run DUT
    ofdm_base(in, out);
    
    // Golden reference
    golden_ifft_16(in, golden_out);
    
    // Add CP to golden reference
    for (int i = 0; i < OFDM_SYM_LEN; i++) {
        if (i < CP_LEN) {
            golden_with_cp[i] = golden_out[OFDM_N - CP_LEN + i];
        } else {
            golden_with_cp[i] = golden_out[i - CP_LEN];
        }
    }
    
    // Calculate EVM
    double evm = calculate_evm(golden_with_cp, out);
    cout << "EVM = " << evm << "%" << endl;
    
    // Print first few samples
    cout << "First 5 output samples:" << endl;
    for (int i = 0; i < 5 && i < OFDM_SYM_LEN; i++) {
        cout << "  [" << i << "] = (" << out[i].real() << ", " << out[i].imag() << ")" << endl;
    }
    
    if (evm <= 6.0) {
        cout << "TEST PASSED: EVM <= 6%" << endl;
    } else {
        cout << "TEST FAILED: EVM > 6%" << endl;
    }
}

// Test case 4: Verify cyclic prefix property
void test_cyclic_prefix() {
    cout << "\n=== Test 4: Cyclic Prefix Verification ===" << endl;
    
    complex_t in[OFDM_N];
    complex_t out[OFDM_SYM_LEN];
    
    // Use non-trivial input
    for (int i = 0; i < OFDM_N; i++) {
        in[i] = complex_t(data_t(i * 0.1), data_t((OFDM_N - i) * 0.05));
    }
    
    // Run DUT
    ofdm_base(in, out);
    
    // Verify CP: samples 0-3 should equal samples 16-19
    bool cp_ok = true;
    for (int i = 0; i < CP_LEN; i++) {
        double cp_real = out[i].real().to_double();
        double cp_imag = out[i].imag().to_double();
        double end_real = out[OFDM_N + i].real().to_double();
        double end_imag = out[OFDM_N + i].imag().to_double();
        
        double diff = abs(cp_real - end_real) + abs(cp_imag - end_imag);
        if (diff > 0.01) {
            cp_ok = false;
            cout << "CP mismatch at index " << i << ": diff = " << diff << endl;
        }
    }
    
    if (cp_ok) {
        cout << "TEST PASSED: Cyclic prefix correctly inserted" << endl;
    } else {
        cout << "TEST FAILED: Cyclic prefix error detected" << endl;
    }
}

int main() {
    cout << "========================================" << endl;
    cout << "OFDM Baseband Modulator Testbench" << endl;
    cout << "========================================" << endl;
    cout << "Configuration:" << endl;
    cout << "  - IFFT Size: " << OFDM_N << " points" << endl;
    cout << "  - Cyclic Prefix: " << CP_LEN << " samples" << endl;
    cout << "  - Output Size: " << OFDM_SYM_LEN << " samples" << endl;
    cout << "  - EVM Requirement: <= 6%" << endl;
    
    // Run all tests
    test_impulse_dc();
    test_single_tone();
    test_qpsk_random();
    test_cyclic_prefix();
    
    cout << "\n========================================" << endl;
    cout << "All tests completed" << endl;
    cout << "========================================" << endl;
    
    return 0;
}
