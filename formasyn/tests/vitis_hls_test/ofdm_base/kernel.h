#ifndef OFDM_BASE_KERNEL_H
#define OFDM_BASE_KERNEL_H

#include <ap_fixed.h>
#include <complex>

// OFDM Configuration
#define OFDM_N 16           // IFFT size
#define CP_LEN 4            // Cyclic prefix length
#define OFDM_SYM_LEN 20     // Total symbol length (16 + 4)

// Fixed-point types for OFDM
typedef ap_fixed<16, 3> data_t;
typedef std::complex<data_t> complex_t;

// Main OFDM baseband modulator kernel
// Performs 16-point IFFT with cyclic prefix insertion
void ofdm_base(
    complex_t in[OFDM_N],      // Input: 16 complex frequency-domain symbols
    complex_t out[OFDM_SYM_LEN] // Output: 20 time-domain samples (16 + 4 CP)
);

// 16-point IFFT using radix-2 butterfly structure
void ifft_16(
    complex_t in[OFDM_N],
    complex_t out[OFDM_N]
);

// Butterfly operation for FFT/IFFT
void butterfly(
    complex_t a,
    complex_t b,
    complex_t w,
    complex_t &out_a,
    complex_t &out_b
);

// Twiddle factors for 16-point IFFT (W_16^-k = exp(j*2*pi*k/16))
// Pre-computed and stored as constants
static const complex_t TWIDDLE_16[8] = {
    complex_t(data_t(1.0),      data_t(0.0)),       // W^0
    complex_t(data_t(0.9239),   data_t(0.3827)),    // W^1
    complex_t(data_t(0.7071),   data_t(0.7071)),    // W^2
    complex_t(data_t(0.3827),   data_t(0.9239)),    // W^3
    complex_t(data_t(0.0),      data_t(1.0)),       // W^4
    complex_t(data_t(-0.3827),  data_t(0.9239)),    // W^5
    complex_t(data_t(-0.7071),  data_t(0.7071)),    // W^6
    complex_t(data_t(-0.9239),  data_t(0.3827))     // W^7
};

#endif // OFDM_BASE_KERNEL_H
