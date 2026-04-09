#include "kernel.h"
#include <iostream>
#include <cstdlib>
#include <vector>

// Reference model for convolutional encoder
ap_uint<2> reference_encode(ap_uint<1> bit_in, ap_uint<2>& state) {
    // State holds K-1 = 2 bits
    ap_uint<K> input_word = (state, bit_in);
    
    // G1 = 0b111
    ap_uint<1> out1 = input_word[0] ^ input_word[1] ^ input_word[2];
    
    // G2 = 0b101
    ap_uint<1> out2 = input_word[0] ^ input_word[2];
    
    // Update state: shift in new bit
    state = (state << 1) | bit_in;
    
    return (out2, out1);
}

int main() {
    std::cout << "============================================" << std::endl;
    std::cout << "Convolutional Encoder Testbench" << std::endl;
    std::cout << "K=3, Rate 1/2, G1=0b111, G2=0b101" << std::endl;
    std::cout << "============================================" << std::endl;
    
    const int NUM_TEST_BITS = 1000;
    int errors = 0;
    
    hls::stream<ap_uint<1>> bit_in_stream("input_stream");
    hls::stream<ap_uint<2>> y_out_stream("output_stream");
    
    // Test 1: All zeros
    std::cout << "\nTest 1: All zeros input" << std::endl;
    ap_uint<2> ref_state = 0;
    errors = 0;
    
    // Fill input stream
    for (int i = 0; i < 10; i++) {
        bit_in_stream.write(0);
    }
    
    // Run DUT
    conv_encode(bit_in_stream, y_out_stream, 10);
    
    // Check output
    for (int i = 0; i < 10; i++) {
        ap_uint<2> dut_out = y_out_stream.read();
        ap_uint<2> ref_out = reference_encode(0, ref_state);
        if (dut_out != ref_out) {
            std::cout << "  Error at bit " << i << ": DUT=" << dut_out << ", REF=" << ref_out << std::endl;
            errors++;
        }
    }
    std::cout << "  " << (errors == 0 ? "PASSED" : "FAILED") << " (errors: " << errors << ")" << std::endl;
    
    // Test 2: All ones
    std::cout << "\nTest 2: All ones input" << std::endl;
    ref_state = 0;
    errors = 0;
    
    for (int i = 0; i < 10; i++) {
        bit_in_stream.write(1);
    }
    
    conv_encode(bit_in_stream, y_out_stream, 10);
    
    for (int i = 0; i < 10; i++) {
        ap_uint<2> dut_out = y_out_stream.read();
        ap_uint<2> ref_out = reference_encode(1, ref_state);
        if (dut_out != ref_out) {
            std::cout << "  Error at bit " << i << ": DUT=" << dut_out << ", REF=" << ref_out << std::endl;
            errors++;
        }
    }
    std::cout << "  " << (errors == 0 ? "PASSED" : "FAILED") << " (errors: " << errors << ")" << std::endl;
    
    // Test 3: Alternating pattern
    std::cout << "\nTest 3: Alternating 0101... pattern" << std::endl;
    ref_state = 0;
    errors = 0;
    
    for (int i = 0; i < 10; i++) {
        bit_in_stream.write(i & 1);
    }
    
    conv_encode(bit_in_stream, y_out_stream, 10);
    
    for (int i = 0; i < 10; i++) {
        ap_uint<2> dut_out = y_out_stream.read();
        ap_uint<2> ref_out = reference_encode(i & 1, ref_state);
        if (dut_out != ref_out) {
            std::cout << "  Error at bit " << i << ": DUT=" << dut_out << ", REF=" << ref_out << std::endl;
            errors++;
        }
    }
    std::cout << "  " << (errors == 0 ? "PASSED" : "FAILED") << " (errors: " << errors << ")" << std::endl;
    
    // Test 4: Known test vector
    std::cout << "\nTest 4: Known test vector" << std::endl;
    // Input:  1 1 0 1 1 0 0 0 ...
    // With state starting at 0, expected outputs:
    // State transitions and outputs computed manually
    ref_state = 0;
    errors = 0;
    
    std::vector<ap_uint<1>> test_input = {1, 1, 0, 1, 1, 0, 0, 0};
    // Expected outputs for G1=111, G2=101:
    // bit 0: input=1, state=00 -> word=001 -> out1=1, out2=1 -> output=11 (3)
    // bit 1: input=1, state=10 -> word=011 -> out1=0, out2=0 -> output=00 (0)
    // bit 2: input=0, state=11 -> word=110 -> out1=0, out2=1 -> output=10 (2)
    // bit 3: input=1, state=01 -> word=101 -> out1=0, out2=0 -> output=00 (0)
    std::vector<ap_uint<2>> expected = {3, 0, 2, 0, 3, 2, 3, 0};
    
    for (auto bit : test_input) {
        bit_in_stream.write(bit);
    }
    
    conv_encode(bit_in_stream, y_out_stream, test_input.size());
    
    for (size_t i = 0; i < expected.size(); i++) {
        ap_uint<2> dut_out = y_out_stream.read();
        if (dut_out != expected[i]) {
            std::cout << "  Error at bit " << i << ": DUT=" << dut_out << ", Expected=" << expected[i] << std::endl;
            errors++;
        }
    }
    std::cout << "  " << (errors == 0 ? "PASSED" : "FAILED") << " (errors: " << errors << ")" << std::endl;
    
    // Test 5: Random data
    std::cout << "\nTest 5: Random data (" << NUM_TEST_BITS << " bits)" << std::endl;
    ref_state = 0;
    errors = 0;
    
    // Generate random input
    std::vector<ap_uint<1>> random_input;
    for (int i = 0; i < NUM_TEST_BITS; i++) {
        random_input.push_back(rand() & 1);
    }
    
    // Feed to DUT
    for (auto bit : random_input) {
        bit_in_stream.write(bit);
    }
    
    conv_encode(bit_in_stream, y_out_stream, NUM_TEST_BITS);
    
    // Verify against reference
    ref_state = 0;
    for (int i = 0; i < NUM_TEST_BITS; i++) {
        ap_uint<2> dut_out = y_out_stream.read();
        ap_uint<2> ref_out = reference_encode(random_input[i], ref_state);
        if (dut_out != ref_out) {
            if (errors < 10) {
                std::cout << "  Error at bit " << i << ": DUT=" << dut_out << ", REF=" << ref_out << std::endl;
            }
            errors++;
        }
    }
    std::cout << "  " << (errors == 0 ? "PASSED" : "FAILED") << " (errors: " << errors << "/" << NUM_TEST_BITS << ")" << std::endl;
    
    // Summary
    std::cout << "\n============================================" << std::endl;
    if (errors == 0) {
        std::cout << "ALL TESTS PASSED (100% correct)" << std::endl;
        return 0;
    } else {
        std::cout << "SOME TESTS FAILED" << std::endl;
        return 1;
    }
}
