#ifndef FORMASYN_KERNEL_H
#define FORMASYN_KERNEL_H

#include <ap_int.h>
#include <ap_fixed.h>

void kernel(
    ap_int<11> a[16],
    ap_int<11> b[16],
    ap_fixed<19,7> c[16]
);

#endif  // FORMASYN_KERNEL_H
