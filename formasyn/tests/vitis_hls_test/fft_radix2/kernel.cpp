/*
 * FFT Radix-2 Kernel Implementation
 * 16-point FFT with bit-reversal and butterfly stages
 * Target: II=1 for streaming
 */

#include "kernel.h"

// Pre-computed twiddle factors W_N^k = exp(-j*2*pi*k/N) for N=16
// Stored with higher precision for accuracy
static const cmpx_twiddle_t twiddle_table[NFFT/2] = {
    // W_16^0 = 1.000000 - j0.000000
    cmpx_twiddle_t(1.000000000000000,  0.000000000000000),
    // W_16^1 = 0.923880 - j0.382683
    cmpx_twiddle_t(0.923879532511287, -0.382683432365090),
    // W_16^2 = 0.707107 - j0.707107
    cmpx_twiddle_t(0.707106781186548, -0.707106781186547),
    // W_16^3 = 0.382683 - j0.923880
    cmpx_twiddle_t(0.382683432365090, -0.923879532511287),
    // W_16^4 = 0.000000 - j1.000000
    cmpx_twiddle_t(0.000000000000000, -1.000000000000000),
    // W_16^5 = -0.382683 - j0.923880
    cmpx_twiddle_t(-0.382683432365090, -0.923879532511287),
    // W_16^6 = -0.707107 - j0.707107
    cmpx_twiddle_t(-0.707106781186548, -0.707106781186547),
    // W_16^7 = -0.923880 - j0.382683
    cmpx_twiddle_t(-0.923879532511287, -0.382683432365090)
};

// Bit-reverse index for 4-bit address (16 points)
static inline unsigned char bit_reverse_4bit(unsigned char x) {
    #pragma HLS INLINE
    unsigned char result = 0;
    result |= (x & 0x1) << 3;
    result |= (x & 0x2) << 1;
    result |= (x & 0x4) >> 1;
    result |= (x & 0x8) >> 3;
    return result;
}

// Single butterfly operation
// out_a = in_a + twiddle * in_b
// out_b = in_a - twiddle * in_b
static inline void butterfly(
    cmpx_data_t in_a,
    cmpx_data_t in_b,
    cmpx_twiddle_t tw,
    cmpx_data_t &out_a,
    cmpx_data_t &out_b
) {
    #pragma HLS INLINE
    
    // Complex multiplication: tw * in_b
    cmpx_data_t tw_b;
    tw_b.real(tw.real() * in_b.real() - tw.imag() * in_b.imag());
    tw_b.imag(tw.real() * in_b.imag() + tw.imag() * in_b.real());
    
    // Butterfly add/sub
    out_a = in_a + tw_b;
    out_b = in_a - tw_b;
}

// FFT Radix-2 main kernel
extern "C" {
    void fft_radix2(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]) {
        #pragma HLS INTERFACE mode=ap_memory port=in
        #pragma HLS INTERFACE mode=ap_memory port=out
        #pragma HLS INTERFACE mode=s_axilite port=return
        
        // Pipeline target: II=1
        #pragma HLS PIPELINE II=1
        
        // Local buffers for ping-pong operation
        cmpx_data_t stage_buf[2][NFFT];
        #pragma HLS ARRAY_PARTITION variable=stage_buf complete dim=1
        
        // Bit-reverse reordering stage
        // FormulaGraph: bit_reverse
        bit_reverse_loop:
        for (int i = 0; i < NFFT; i++) {
            #pragma HLS UNROLL
            unsigned char rev_idx = bit_reverse_4bit((unsigned char)i);
            stage_buf[0][i] = in[rev_idx];
        }
        
        // Butterfly stages
        // FormulaGraph: Iteration(butterfly stages)
        int ping_pong = 0;
        
        stage_loop:
        for (int stage = 0; stage < N_STAGES; stage++) {
            #pragma HLS UNROLL
            
            int groups = 1 << stage;           // Number of butterfly groups
            int group_size = NFFT >> stage;     // Butterflies per group
            int half_group = group_size >> 1;   // Distance between butterfly inputs
            
            butterfly_loop:
            for (int g = 0; g < groups; g++) {
                #pragma HLS UNROLL
                
                for (int b = 0; b < half_group; b++) {
                    #pragma HLS UNROLL
                    
                    // Compute indices
                    int idx_a = g * group_size + b;
                    int idx_b = idx_a + half_group;
                    
                    // Get twiddle factor index
                    int tw_idx = b * groups;
                    cmpx_twiddle_t tw = twiddle_table[tw_idx];
                    
                    // Perform butterfly
                    cmpx_data_t in_a = stage_buf[ping_pong][idx_a];
                    cmpx_data_t in_b = stage_buf[ping_pong][idx_b];
                    
                    butterfly(
                        in_a, in_b, tw,
                        stage_buf[1-ping_pong][idx_a],
                        stage_buf[1-ping_pong][idx_b]
                    );
                }
            }
            
            ping_pong = 1 - ping_pong;
        }
        
        // Write output
        output_loop:
        for (int i = 0; i < NFFT; i++) {
            #pragma HLS UNROLL
            out[i] = stage_buf[ping_pong][i];
        }
    }
}
