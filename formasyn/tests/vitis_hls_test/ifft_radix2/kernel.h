/*
 * IFFT Radix-2 Kernel Header
 * 16-point IFFT using FFT + conj_scale
 * SFDR >= 60 dB
 */

#ifndef IFFT_RADIX2_KERNEL_H
#define IFFT_RADIX2_KERNEL_H

#include <ap_fixed.h>
#include <complex>
#include <hls_stream.h>

// Type definitions for 60+ dB SFDR
typedef ap_fixed<16, 8> data_t;
typedef std::complex<data_t> cmpx_data_t;

// Twiddle factor type - higher precision for internal computation
typedef ap_fixed<18, 2> twiddle_t;
typedef std::complex<twiddle_t> cmpx_twiddle_t;

// Scale factor type
typedef ap_fixed<16, 2> scale_t;

// FFT Configuration
#define NFFT 16
#define N_STAGES 4  // log2(16) = 4

// Function prototypes
extern "C" {
    // Main IFFT kernel
    void ifft_radix2(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]);
    
    // Internal FFT function (used by IFFT)
    void fft_radix2_internal(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]);
    
    // Conjugate and scale operation
    void conj_scale(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]);
}

#endif // IFFT_RADIX2_KERNEL_H
