#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    hls::stream<ap_int<8>>& a,
    hls::stream<ap_int<8>>& b,
    hls::stream<ap_fixed<16,7>>& c
);

#endif
