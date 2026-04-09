#ifndef QPSK_KERNEL_H
#define QPSK_KERNEL_H

#include <ap_int.h>

// QPSK Modulator Kernel
// Input: 2 bits, Output: 16-bit signed I/Q constellation points
// Constellation mapping: (±0.707, ±0.707) scaled to 1000

void qpsk_mapper(ap_uint<2> bits_in, ap_int<16> *y_real, ap_int<16> *y_imag);

#endif // QPSK_KERNEL_H
