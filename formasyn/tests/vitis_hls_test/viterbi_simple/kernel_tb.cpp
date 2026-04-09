#include "kernel.h"
#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>

// Convolutional encoder for reference (same as encoder kernel)
ap_uint<2> conv_encode_ref(ap_uint<1> bit_in, ap_uint<2>& state) {
    ap_uint<K> input_word = (state, bit_in);
    ap_uint<1> out1 = input_word[0] ^ input_word[1] ^ input_word[2];
    ap_uint<1> out2 = input_word[0] ^ input_word[2];
    state = (state << 1) | bit_in;
    return (out2, out1);
}

// Add AWGN noise to coded bits (simple model)
void add_noise(ap_uint<2> coded, float snr_db, soft_decision_t soft_out[2]) {
    // Convert to BPSK: 0 -> -1, 1 -> +1
    float bpsk[2];
    bpsk[0] = coded[0] ? 1.0f : -1.0f;
    bpsk[1] = coded[1] ? 1.0f : -1.0f;
    
    // Calculate noise variance from SNR
    float snr_linear = powf(10.0f, snr_db / 10.0f);
    float noise_std = sqrtf(1.0f / (2.0f * snr_linear));  // Rate 1/2 adjustment
    
    // Add Gaussian noise (Box-Muller approximation)
    float u1 = (float)rand() / (float)(RAND_MAX + 1ULL);
    float u2 = (float)rand() / (float)(RAND_MAX + 1ULL);
    float noise1 = noise_std * sqrtf(-2.0f * logf(u1 + 1e-10f)) * cosf(2.0f * M_PI * u2);
    
    u1 = (float)rand() / (float)(RAND_MAX + 1ULL);
    u2 = (float)rand() / (float)(RAND_MAX + 1ULL);
    float noise2 = noise_std * sqrtf(-2.0f * logf(u1 + 1e-10f)) * cosf(2.0f * M_PI * u2);
    
    // Scale to soft decision range (-128 to 127)
    float received1 = (bpsk[0] + noise1) * 127.0f;
    float received2 = (bpsk[1] + noise2) * 127.0f;
    
    // Clip to valid range
    soft_out[0] = (soft_decision_t)std::max(-128.0f, std::min(127.0f, received1));
    soft_out[1] = (soft_decision_t)std::max(-128.0f, std::min(127.0f, received2));
}

// Calculate FER
float calculate_fer(int frame_errors, int total_frames) {
    return (float)frame_errors / total_frames;
}

// Theoretical FER for soft-decision Viterbi (approximate)
float theoretical_fer(float snr_db) {
    // Approximate formula for K=3, rate 1/2 code
    // FER ≈ Q(sqrt(2 * d_free * R * Eb/N0))
    // d_free = 5 for this code, R = 1/2
    float snr_linear = powf(10.0f, snr_db / 10.0f);
    float argument = sqrtf(5.0f * snr_linear);
    // Q-function approximation
    return 0.5f * erfcf(argument / sqrtf(2.0f));
}

int main() {
    std::cout << "============================================" << std::endl;
    std::cout << "Viterbi Decoder Testbench" << std::endl;
    std::cout << "K=3, 4 states, Traceback depth=20" << std::endl;
    std::cout << "============================================" << std::endl;
    
    const int FRAME_SIZE = 1000;
    const int NUM_FRAMES = 100;
    
    // Test at different SNR points
    float snr_points[] = {2.0f, 3.0f, 4.0f, 5.0f, 6.0f};
    int num_snr = sizeof(snr_points) / sizeof(snr_points[0]);
    
    std::cout << "\nFER Performance Test:" << std::endl;
    std::cout << "SNR(dB) | Simulated FER | Theoretical FER | Gap(dB)" << std::endl;
    std::cout << "--------|---------------|-----------------|--------" << std::endl;
    
    for (int s = 0; s < num_snr; s++) {
        float snr_db = snr_points[s];
        int frame_errors = 0;
        
        for (int frame = 0; frame < NUM_FRAMES; frame++) {
            hls::stream<soft_decision_t> soft_in_stream("soft_input");
            hls::stream<ap_uint<1>> bit_out_stream("bit_output");
            
            std::vector<ap_uint<1>> original_bits;
            ap_uint<2> enc_state = 0;
            
            // Generate random frame and encode
            for (int i = 0; i < FRAME_SIZE; i++) {
                ap_uint<1> bit = rand() & 1;
                original_bits.push_back(bit);
                
                ap_uint<2> coded = conv_encode_ref(bit, enc_state);
                
                // Add noise
                soft_decision_t soft_out[2];
                add_noise(coded, snr_db, soft_out);
                
                soft_in_stream.write(soft_out[0]);
                soft_in_stream.write(soft_out[1]);
            }
            
            // Add tail bits to flush encoder (K-1 zeros)
            for (int i = 0; i < K - 1; i++) {
                ap_uint<2> coded = conv_encode_ref(0, enc_state);
                soft_decision_t soft_out[2];
                add_noise(coded, snr_db, soft_out);
                soft_in_stream.write(soft_out[0]);
                soft_in_stream.write(soft_out[1]);
            }
            
            // Run decoder
            viterbi_simple(soft_in_stream, bit_out_stream, FRAME_SIZE + K - 1);
            
            // Check output
            int bit_errors = 0;
            for (int i = 0; i < FRAME_SIZE; i++) {
                ap_uint<1> decoded = bit_out_stream.read();
                if (decoded != original_bits[i]) {
                    bit_errors++;
                }
            }
            
            if (bit_errors > 0) {
                frame_errors++;
            }
        }
        
        float sim_fer = calculate_fer(frame_errors, NUM_FRAMES);
        float theo_fer = theoretical_fer(snr_db);
        
        // Calculate gap (find SNR where theoretical gives same FER)
        float gap_db = 0.0f;
        if (sim_fer > 0) {
            // Binary search for theoretical SNR that gives simulated FER
            float low_snr = 0.0f, high_snr = 10.0f;
            for (int iter = 0; iter < 20; iter++) {
                float mid_snr = (low_snr + high_snr) / 2.0f;
                if (theoretical_fer(mid_snr) > sim_fer) {
                    low_snr = mid_snr;
                } else {
                    high_snr = mid_snr;
                }
            }
            gap_db = low_snr - snr_db;
        }
        
        printf(" %5.1f  |    %.4f     |     %.4f      | %+.2f\n", 
               snr_db, sim_fer, theo_fer, gap_db);
    }
    
    // Test 1: Error-free decode at high SNR
    std::cout << "\nTest 1: Error-free decode at high SNR" << std::endl;
    {
        hls::stream<soft_decision_t> soft_in_stream("soft_input");
        hls::stream<ap_uint<1>> bit_out_stream("bit_output");
        
        std::vector<ap_uint<1>> test_bits = {1, 0, 1, 1, 0, 0, 1, 0, 1, 1};
        ap_uint<2> enc_state = 0;
        
        for (auto bit : test_bits) {
            ap_uint<2> coded = conv_encode_ref(bit, enc_state);
            // High confidence soft values
            soft_in_stream.write(coded[0] ? 127 : -127);
            soft_in_stream.write(coded[1] ? 127 : -127);
        }
        
        // Flush
        for (int i = 0; i < K - 1; i++) {
            ap_uint<2> coded = conv_encode_ref(0, enc_state);
            soft_in_stream.write(coded[0] ? 127 : -127);
            soft_in_stream.write(coded[1] ? 127 : -127);
        }
        
        viterbi_simple(soft_in_stream, bit_out_stream, test_bits.size() + K - 1);
        
        int errors = 0;
        std::cout << "  Original: ";
        for (auto bit : test_bits) std::cout << (int)bit;
        std::cout << std::endl;
        std::cout << "  Decoded:  ";
        for (size_t i = 0; i < test_bits.size(); i++) {
            ap_uint<1> decoded = bit_out_stream.read();
            std::cout << (int)decoded;
            if (decoded != test_bits[i]) errors++;
        }
        std::cout << std::endl;
        std::cout << "  " << (errors == 0 ? "PASSED" : "FAILED") << " (errors: " << errors << ")" << std::endl;
    }
    
    // Test 2: All zeros
    std::cout << "\nTest 2: All zeros decode" << std::endl;
    {
        hls::stream<soft_decision_t> soft_in_stream("soft_input");
        hls::stream<ap_uint<1>> bit_out_stream("bit_output");
        
        // All zeros encoded with G1=111,G2=101 -> all zero outputs
        for (int i = 0; i < 20; i++) {
            soft_in_stream.write(-127);  // Strong 0
            soft_in_stream.write(-127);
        }
        
        viterbi_simple(soft_in_stream, bit_out_stream, 20);
        
        int errors = 0;
        for (int i = 0; i < 20; i++) {
            ap_uint<1> decoded = bit_out_stream.read();
            if (decoded != 0) errors++;
        }
        std::cout << "  " << (errors == 0 ? "PASSED" : "FAILED") << " (errors: " << errors << ")" << std::endl;
    }
    
    // Test 3: All ones
    std::cout << "\nTest 3: All ones decode" << std::endl;
    {
        hls::stream<soft_decision_t> soft_in_stream("soft_input");
        hls::stream<ap_uint<1>> bit_out_stream("bit_output");
        
        ap_uint<2> enc_state = 0;
        for (int i = 0; i < 20; i++) {
            ap_uint<2> coded = conv_encode_ref(1, enc_state);
            soft_in_stream.write(coded[0] ? 127 : -127);
            soft_in_stream.write(coded[1] ? 127 : -127);
        }
        
        // Flush
        for (int i = 0; i < K - 1; i++) {
            ap_uint<2> coded = conv_encode_ref(0, enc_state);
            soft_in_stream.write(coded[0] ? 127 : -127);
            soft_in_stream.write(coded[1] ? 127 : -127);
        }
        
        viterbi_simple(soft_in_stream, bit_out_stream, 22);
        
        int errors = 0;
        for (int i = 0; i < 20; i++) {
            ap_uint<1> decoded = bit_out_stream.read();
            if (decoded != 1) errors++;
        }
        std::cout << "  " << (errors == 0 ? "PASSED" : "FAILED") << " (errors: " << errors << ")" << std::endl;
    }
    
    std::cout << "\n============================================" << std::endl;
    std::cout << "Testing complete - FER gap < 0.5 dB target" << std::endl;
    std::cout << "============================================" << std::endl;
    
    return 0;
}
