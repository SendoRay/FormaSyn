#ifndef VEC_ADD_KERNEL_H
#define VEC_ADD_KERNEL_H

#include <ap_int.h>

#define VEC_SIZE 8

typedef ap_int<16> data_t;

void vec_add(data_t a[VEC_SIZE], data_t b[VEC_SIZE], data_t y[VEC_SIZE]);

#endif
