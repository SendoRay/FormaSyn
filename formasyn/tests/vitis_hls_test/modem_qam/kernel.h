#ifndef QAM16_KERNEL_H
#define QAM16_KERNEL_H

#include <ap_int.h>

// 16-QAM Modulator Kernel
// Input: 4 bits, Output: 16-bit signed I/Q constellation points
// Constellation: Gray-coded 16-QAM with levels at ±1000, ±3000

void qam16_mapper(ap_uint<4> bits_in, ap_int<16> *y_real, ap_int<16> *y_imag);

#endif // QAM16_KERNEL_H
