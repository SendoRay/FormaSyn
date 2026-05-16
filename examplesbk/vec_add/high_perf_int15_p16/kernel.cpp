#include "kernel.h"
#include <hls_stream.h>

void kernel(
    hls::stream<ap_int<8>>& a,
    hls::stream<ap_int<8>>& b,
    hls::stream<ap_fixed<16,7>>& c
) {
    #pragma HLS INTERFACE mode=ap_ctrl_none port=return
    #pragma HLS INTERFACE mode=axis port=a
    #pragma HLS INTERFACE mode=axis port=b
    #pragma HLS INTERFACE mode=axis port=c

    for (int i = 0; i < 16; i++) {
        #pragma HLS PIPELINE II=2
        ap_int<8> val_a = a.read();
        ap_int<8> val_b = b.read();
        ap_fixed<16,7> val_c = val_a + val_b;
        c.write(val_c);
    }
}
