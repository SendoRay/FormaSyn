#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<17> x_in[1],
    ap_fixed<25,3> y_out[1]
) {
    #pragma HLS PIPELINE II=16
static const ap_fixed<16,4> coeffs[16] = {0.003000, 0.008000, 0.025000, 0.063000, 0.121000, 0.186000, 0.233000, 0.250000, 0.250000, 0.233000, 0.186000, 0.121000, 0.063000, 0.025000, 0.008000, 0.003000};
    static ap_fixed<16,4> shift_reg[16] = {0};
    #pragma HLS ARRAY_PARTITION variable=shift_reg complete

    for (int n = 0; n < 16; n++) {
        #pragma HLS PIPELINE II=1
        ap_fixed<32,8> acc = 0;

        for (int i = 15; i > 0; i--) {
            #pragma HLS UNROLL
            shift_reg[i] = shift_reg[i-1];
        }
        shift_reg[0] = (ap_fixed<16,4>)x_in[n];

        for (int i = 0; i < 16; i++) {
            #pragma HLS UNROLL
            acc += shift_reg[i] * coeffs[i];
        }
        y_out[n] = acc;
    }
}
