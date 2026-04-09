/*
 * IFFT Radix-2 Testbench
 * Single-tone test and round-trip FFT/IFFT verification
 */

#include <cmath>
#include <cstdio>
#include "kernel.h"

// Simple FFT reference for comparison (not optimized)
void reference_fft(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]) {
    for (int k = 0; k < NFFT; k++) {
        double real_sum = 0.0;
        double imag_sum = 0.0;
        for (int n = 0; n < NFFT; n++) {
            double angle = -2.0 * M_PI * k * n / NFFT;
            double real = in[n].real().to_double();
            double imag = in[n].imag().to_double();
            real_sum += real * cos(angle) - imag * sin(angle);
            imag_sum += real * sin(angle) + imag * cos(angle);
        }
        out[k].real(real_sum);
        out[k].imag(imag_sum);
    }
}

// Simple IFFT reference for comparison
void reference_ifft(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]) {
    for (int n = 0; n < NFFT; n++) {
        double real_sum = 0.0;
        double imag_sum = 0.0;
        for (int k = 0; k < NFFT; k++) {
            double angle = 2.0 * M_PI * k * n / NFFT;
            double real = in[k].real().to_double();
            double imag = in[k].imag().to_double();
            real_sum += real * cos(angle) - imag * sin(angle);
            imag_sum += real * sin(angle) + imag * cos(angle);
        }
        out[n].real(real_sum / NFFT);
        out[n].imag(imag_sum / NFFT);
    }
}

// Convert to dB
double to_dB(double linear) {
    if (linear <= 0) return -200.0;
    return 20.0 * log10(linear);
}

int main() {
    printf("========================================\n");
    printf("IFFT Radix-2 Testbench (NFFT=%d)\n", NFFT);
    printf("========================================\n\n");
    
    cmpx_data_t in[NFFT];
    cmpx_data_t out[NFFT];
    cmpx_data_t ref_out[NFFT];
    
    // Test 1: Single-tone IFFT at bin 3
    printf("Test 1: Single-tone IFFT at bin 3\n");
    printf("----------------------------------\n");
    
    // Create single-tone input in frequency domain
    // A single tone at bin 3 means all zeros except bin 3
    for (int i = 0; i < NFFT; i++) {
        in[i].real(0.0);
        in[i].imag(0.0);
    }
    // Set bin 3 to have amplitude 1.0 (with 0 phase)
    in[3].real(1.0);
    in[3].imag(0.0);
    // Also set conjugate symmetric bin for real output
    in[NFFT-3].real(1.0);
    in[NFFT-3].imag(0.0);
    
    // Run IFFT
    ifft_radix2(in, out);
    
    // Run reference IFFT
    reference_ifft(in, ref_out);
    
    printf("IFFT Output (time domain):\n");
    printf("  Index | Hardware (real, imag) | Reference (real, imag) | Error\n");
    printf("  ------|-----------------------|------------------------|------\n");
    
    double max_error = 0.0;
    for (int i = 0; i < NFFT; i++) {
        double hw_real = out[i].real().to_double();
        double hw_imag = out[i].imag().to_double();
        double ref_real = ref_out[i].real().to_double();
        double ref_imag = ref_out[i].imag().to_double();
        double error = sqrt(pow(hw_real - ref_real, 2) + pow(hw_imag - ref_imag, 2));
        if (error > max_error) max_error = error;
        printf("  %4d  | (%8.4f, %8.4f) | (%8.4f, %8.4f) | %.4f\n",
               i, hw_real, hw_imag, ref_real, ref_imag, error);
    }
    printf("\nMax error vs reference: %.6f\n", max_error);
    int pass1 = (max_error < 0.01) ? 1 : 0;
    printf("Test 1 Result: %s\n\n", pass1 ? "PASS" : "FAIL");
    
    // Test 2: Round-trip FFT -> IFFT
    printf("Test 2: Round-trip FFT -> IFFT\n");
    printf("-------------------------------\n");
    
    // Create time domain signal
    double freq_bin = 3.0;
    double signal_amp = 0.5;
    for (int n = 0; n < NFFT; n++) {
        double phase = 2.0 * M_PI * freq_bin * n / NFFT;
        in[n].real(signal_amp * cos(phase));
        in[n].imag(signal_amp * sin(phase));
    }
    
    // Store original for comparison
    cmpx_data_t original[NFFT];
    for (int i = 0; i < NFFT; i++) {
        original[i] = in[i];
    }
    
    // Forward FFT (using reference for this test since we test IFFT)
    cmpx_data_t fft_out[NFFT];
    reference_fft(in, fft_out);
    
    // Inverse FFT using hardware kernel
    ifft_radix2(fft_out, out);
    
    printf("Round-trip comparison (original vs IFFT(FFT)):\n");
    printf("  Index | Original (real, imag) | Recovered (real, imag) | Error\n");
    printf("  ------|-----------------------|------------------------|------\n");
    
    max_error = 0.0;
    for (int i = 0; i < NFFT; i++) {
        double orig_real = original[i].real().to_double();
        double orig_imag = original[i].imag().to_double();
        double rec_real = out[i].real().to_double();
        double rec_imag = out[i].imag().to_double();
        double error = sqrt(pow(orig_real - rec_real, 2) + pow(orig_imag - rec_imag, 2));
        if (error > max_error) max_error = error;
        printf("  %4d  | (%8.4f, %8.4f) | (%8.4f, %8.4f) | %.4f\n",
               i, orig_real, orig_imag, rec_real, rec_imag, error);
    }
    printf("\nMax round-trip error: %.6f\n", max_error);
    int pass2 = (max_error < 0.01) ? 1 : 0;
    printf("Test 2 Result: %s\n\n", pass2 ? "PASS" : "FAIL");
    
    // Test 3: DC component test
    printf("Test 3: DC component test\n");
    printf("-------------------------\n");
    
    // DC in frequency domain should give constant in time domain
    for (int i = 0; i < NFFT; i++) {
        in[i].real(0.0);
        in[i].imag(0.0);
    }
    in[0].real(1.0);  // Only DC bin
    
    ifft_radix2(in, out);
    
    printf("DC IFFT output (should be constant 1/NFFT = 0.0625):\n");
    int pass3 = 1;
    for (int i = 0; i < NFFT; i++) {
        double real = out[i].real().to_double();
        double imag = out[i].imag().to_double();
        printf("  Index %2d: (%.4f, %.4f)\n", i, real, imag);
        if (fabs(real - 1.0/NFFT) > 0.001 || fabs(imag) > 0.001) {
            pass3 = 0;
        }
    }
    printf("Test 3 Result: %s\n\n", pass3 ? "PASS" : "FAIL");
    
    // Final summary
    printf("========================================\n");
    printf("Overall Result: %s\n", 
           (pass1 && pass2 && pass3) ? "ALL TESTS PASSED" : "SOME TESTS FAILED");
    printf("========================================\n");
    
    return (pass1 && pass2 && pass3) ? 0 : 1;
}
