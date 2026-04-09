#ifndef VEC_MUL_KERNEL_H
#define VEC_MUL_KERNEL_H

#include <ap_int.h>

#define VEC_SIZE 8

typedef ap_int<16> data_in_t;
typedef ap_int<32> data_out_t;

void vec_mul(data_in_t a[VEC_SIZE], data_in_t b[VEC_SIZE], data_out_t y[VEC_SIZE]);

#endif
