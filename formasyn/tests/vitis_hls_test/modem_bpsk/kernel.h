#ifndef BPSK_KERNEL_H
#define BPSK_KERNEL_H

#include <ap_int.h>

// BPSK Modulator Kernel
// Input: 1 bit, Output: 16-bit signed constellation point
// Constellation mapping: 0 -> -1000, 1 -> +1000

void bpsk_mapper(ap_uint<1> bit_in, ap_int<16> *y_out);

#endif // BPSK_KERNEL_H
