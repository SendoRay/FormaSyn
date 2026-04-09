#include "kernel.h"
#include <hls_math.h>
#include <ap_fixed.h>

// Butterfly operation for FFT/IFFT
void butterfly(
    complex_t a,
    complex_t b,
    complex_t w,
    complex_t &out_a,
    complex_t &out_b
) {
    #pragma HLS INLINE
    complex_t wb = b * w;
    out_a = a + wb;
    out_b = a - wb;
}

// 16-point IFFT using radix-2 DIT (Decimation in Time)
// Optimized for hardware with pipeline and array partitioning
void ifft_16(
    complex_t in[OFDM_N],
    complex_t out[OFDM_N]
) {
    #pragma HLS INTERFACE mode=ap_memory port=in
    #pragma HLS INTERFACE mode=ap_memory port=out
    #pragma HLS PIPELINE II=1
    
    // Stage registers with partitioning for parallel access
    complex_t stage0[OFDM_N], stage1[OFDM_N], stage2[OFDM_N], stage3[OFDM_N];
    #pragma HLS ARRAY_PARTITION variable=stage0 complete
    #pragma HLS ARRAY_PARTITION variable=stage1 complete
    #pragma HLS ARRAY_PARTITION variable=stage2 complete
    #pragma HLS ARRAY_PARTITION variable=stage3 complete
    
    // Bit-reversed input reordering
    const int bit_rev[16] = {0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15};
    
    REORDER_LOOP:
    for (int i = 0; i < OFDM_N; i++) {
        #pragma HLS UNROLL
        stage0[i] = in[bit_rev[i]];
    }
    
    // Stage 1: 8 butterflies with stride 1, twiddle W^0
    STAGE1_LOOP:
    for (int i = 0; i < 8; i++) {
        #pragma HLS UNROLL
        butterfly(stage0[2*i], stage0[2*i+1], TWIDDLE_16[0], stage1[2*i], stage1[2*i+1]);
    }
    
    // Stage 2: 8 butterflies with stride 2
    STAGE2_LOOP:
    for (int i = 0; i < 4; i++) {
        #pragma HLS UNROLL
        butterfly(stage1[4*i],   stage1[4*i+2], TWIDDLE_16[0], stage2[4*i],   stage2[4*i+2]);
        butterfly(stage1[4*i+1], stage1[4*i+3], TWIDDLE_16[4], stage2[4*i+1], stage2[4*i+3]);
    }
    
    // Stage 3: 8 butterflies with stride 4
    STAGE3_LOOP:
    for (int i = 0; i < 2; i++) {
        #pragma HLS UNROLL
        butterfly(stage2[8*i],   stage2[8*i+4], TWIDDLE_16[0], stage3[8*i],   stage3[8*i+4]);
        butterfly(stage2[8*i+1], stage2[8*i+5], TWIDDLE_16[2], stage3[8*i+1], stage3[8*i+5]);
        butterfly(stage2[8*i+2], stage2[8*i+6], TWIDDLE_16[4], stage3[8*i+2], stage3[8*i+6]);
        butterfly(stage2[8*i+3], stage2[8*i+7], TWIDDLE_16[6], stage3[8*i+3], stage3[8*i+7]);
    }
    
    // Stage 4: 8 butterflies with stride 8
    STAGE4_LOOP:
    for (int i = 0; i < 8; i++) {
        #pragma HLS UNROLL
        butterfly(stage3[i], stage3[i+8], TWIDDLE_16[i], out[i], out[i+8]);
    }
    
    // Scale by 1/N for IFFT normalization
    SCALE_LOOP:
    for (int i = 0; i < OFDM_N; i++) {
        #pragma HLS UNROLL
        out[i] = out[i] * data_t(0.0625); // 1/16
    }
}

// Main OFDM baseband modulator kernel
// Performs 16-point IFFT with cyclic prefix insertion
void ofdm_base(
    complex_t in[OFDM_N],
    complex_t out[OFDM_SYM_LEN]
) {
    #pragma HLS INTERFACE mode=ap_memory port=in
    #pragma HLS INTERFACE mode=ap_memory port=out
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    #pragma HLS PIPELINE II=1
    
    // Internal buffer for IFFT output
    complex_t ifft_out[OFDM_N];
    #pragma HLS ARRAY_PARTITION variable=ifft_out complete
    
    // Perform 16-point IFFT
    ifft_16(in, ifft_out);
    
    // Insert cyclic prefix: copy last 4 samples to front
    CP_INSERT_LOOP:
    for (int i = 0; i < OFDM_SYM_LEN; i++) {
        #pragma HLS UNROLL
        if (i < CP_LEN) {
            // Copy from last 4 samples (indices 12, 13, 14, 15)
            out[i] = ifft_out[OFDM_N - CP_LEN + i];
        } else {
            // Copy IFFT output samples (indices 0-15)
            out[i] = ifft_out[i - CP_LEN];
        }
    }
}
