#ifndef KERNEL_H_
#define KERNEL_H_

#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_fixed<16, 7, AP_TRN, AP_SAT> c[16]);

#endif // KERNEL_H_
