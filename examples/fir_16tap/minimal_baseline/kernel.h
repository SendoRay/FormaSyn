#ifndef FORMASYN_KERNEL_H
#define FORMASYN_KERNEL_H

#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<17> x_in[1],
    ap_fixed<25,3> y_out[1]
);

#endif  // FORMASYN_KERNEL_H
