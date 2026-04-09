/*
 * IFFT Radix-2 Kernel Implementation
 * 16-point IFFT using FFT + conj_scale approach
 * Target: II=1 for streaming
 */

#include "kernel.h"

// Pre-computed twiddle factors W_N^k = exp(-j*2*pi*k/N) for N=16
static const cmpx_twiddle_t twiddle_table[NFFT/2] = {
    cmpx_twiddle_t(1.000000000000000,  0.000000000000000),
    cmpx_twiddle_t(0.923879532511287, -0.382683432365090),
    cmpx_twiddle_t(0.707106781186548, -0.707106781186547),
    cmpx_twiddle_t(0.382683432365090, -0.923879532511287),
    cmpx_twiddle_t(0.000000000000000, -1.000000000000000),
    cmpx_twiddle_t(-0.382683432365090, -0.923879532511287),
    cmpx_twiddle_t(-0.707106781186548, -0.707106781186547),
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
static inline void butterfly(
    cmpx_data_t in_a,
    cmpx_data_t in_b,
    cmpx_twiddle_t tw,
    cmpx_data_t &out_a,
    cmpx_data_t &out_b
) {
    #pragma HLS INLINE
    cmpx_data_t tw_b;
    tw_b.real(tw.real() * in_b.real() - tw.imag() * in_b.imag());
    tw_b.imag(tw.real() * in_b.imag() + tw.imag() * in_b.real());
    out_a = in_a + tw_b;
    out_b = in_a - tw_b;
}

// Internal FFT function for IFFT use
void fft_radix2_internal(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]) {
    #pragma HLS INLINE
    
    // Local buffers for ping-pong operation
    cmpx_data_t stage_buf[2][NFFT];
    #pragma HLS ARRAY_PARTITION variable=stage_buf complete dim=1
    
    // Bit-reverse reordering stage
    bit_reverse_loop:
    for (int i = 0; i < NFFT; i++) {
        #pragma HLS UNROLL
        unsigned char rev_idx = bit_reverse_4bit((unsigned char)i);
        stage_buf[0][i] = in[rev_idx];
    }
    
    // Butterfly stages
    int ping_pong = 0;
    stage_loop:
    for (int stage = 0; stage < N_STAGES; stage++) {
        #pragma HLS UNROLL
        int groups = 1 << stage;
        int group_size = NFFT >> stage;
        int half_group = group_size >> 1;
        
        butterfly_loop:
        for (int g = 0; g < groups; g++) {
            #pragma HLS UNROLL
            for (int b = 0; b < half_group; b++) {
                #pragma HLS UNROLL
                int idx_a = g * group_size + b;
                int idx_b = idx_a + half_group;
                int tw_idx = b * groups;
                cmpx_twiddle_t tw = twiddle_table[tw_idx];
                
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

// Conjugate and scale: out[i] = conj(in[i]) / NFFT
// For IFFT: we conjugate input, FFT, then conjugate and scale output
void conj_scale(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]) {
    #pragma HLS INLINE
    
    // Scale factor = 1/NFFT = 1/16 = 0.0625
    // Using ap_fixed<16,2> for scale
    const scale_t scale = 1.0 / NFFT;
    
    conj_scale_loop:
    for (int i = 0; i < NFFT; i++) {
        #pragma HLS UNROLL
        // Conjugate: (a + jb)* = (a - jb)
        // Then scale by 1/NFFT
        data_t real_part = in[i].real();
        data_t imag_part = in[i].imag();
        out[i].real(real_part * scale);
        out[i].imag(-imag_part * scale);
    }
}

// IFFT main kernel
// FormulaGraph: conj -> fft -> conj_scale
extern "C" {
    void ifft_radix2(cmpx_data_t in[NFFT], cmpx_data_t out[NFFT]) {
        #pragma HLS INTERFACE mode=ap_memory port=in
        #pragma HLS INTERFACE mode=ap_memory port=out
        #pragma HLS INTERFACE mode=s_axilite port=return
        
        // Pipeline target: II=1
        #pragma HLS PIPELINE II=1
        
        // Local buffers
        cmpx_data_t conj_in[NFFT];
        cmpx_data_t fft_out[NFFT];
        #pragma HLS ARRAY_PARTITION variable=conj_in complete
        #pragma HLS ARRAY_PARTITION variable=fft_out complete
        
        // Stage 1: Conjugate input
        // FormulaGraph: conj
        conj_input_loop:
        for (int i = 0; i < NFFT; i++) {
            #pragma HLS UNROLL
            conj_in[i].real(in[i].real());
            conj_in[i].imag(-in[i].imag());
        }
        
        // Stage 2: FFT
        // FormulaGraph: fft
        fft_radix2_internal(conj_in, fft_out);
        
        // Stage 3: Conjugate and scale by 1/NFFT
        // FormulaGraph: conj_scale
        conj_scale(fft_out, out);
    }
}
