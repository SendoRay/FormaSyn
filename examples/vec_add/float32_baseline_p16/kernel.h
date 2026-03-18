#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

void kernel(
    ap_int<32> a[16],
    ap_int<32> b[16],
    ap_int<8> c_scale[16]
);

#endif // KERNEL_H
