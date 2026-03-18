#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<11> x_in, ap_fixed<19,3>& y_out);

#endif
