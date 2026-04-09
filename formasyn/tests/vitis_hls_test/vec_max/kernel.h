#ifndef VEC_MAX_KERNEL_H
#define VEC_MAX_KERNEL_H

#include <ap_int.h>

#define VEC_SIZE 8

typedef ap_int<16> data_t;
typedef ap_uint<3> idx_t;

void vec_max(data_t a[VEC_SIZE], data_t *y, idx_t *idx);

#endif
