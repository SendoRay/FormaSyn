/*
 * FFT Radix-2 Kernel Header
 * 16-point FFT with bit-reversal and butterfly stages
 * SFDR >= 60 dB
 */

#ifndef FFT_RADIX2_KERNEL_H
#define FFT_RADIX2_KERNEL_H

#include <ap_fixed.h>
#include <complex>
#include <hls_stream.h>

// Type definitions for 60+ dB SFDR
// ap_fixed<16,8> provides ~72 dB SNR, sufficient for 60 dB SFDR
typedef ap_fixed<16, 8> data_t;
typedef std::complex<data_t> cmpx_data_t;

// Twiddle factor type - higher precision for internal computation
typedef ap_fixed<18, 2> twiddle_t;
typedef std::complex<twiddle_t> cmpx_twiddle_t;

// FFT Configuration
#define NFFT 16
#define N_STAGES 4  // log2(16) = 4

// Function prototype
extern "C" {
    void fft_radix2(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]);
}

#endif // FFT_RADIX2_KERNEL_H
