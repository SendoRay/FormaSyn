#ifndef VITERBI_SIMPLE_KERNEL_H
#define VITERBI_SIMPLE_KERNEL_H

#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>
#include <algorithm>

// Viterbi Decoder Parameters
#define K 3                   // Constraint length
#define NUM_STATES 4          // 2^(K-1) = 4 states
#define RATE 2                // Code rate 1/2
#define TRACEBACK_DEPTH 20    // Traceback depth
#define MAX_METRIC 1023       // Max path metric to prevent overflow

// Soft decision type: -128 to 127
typedef ap_int<8> soft_decision_t;

// Path metric type
typedef ap_uint<10> path_metric_t;

// State type
typedef ap_uint<2> state_t;

// Generator polynomials (matching encoder)
#define G1 0x7
#define G2 0x5

// Branch metric computation
inline ap_uint<8> branch_metric(
    soft_decision_t soft_in[2],
    ap_uint<2> expected
) {
    #pragma HLS INLINE
    // Convert expected bits from {0,1} to soft values {-127, 127}
    // expected 0 -> -127, expected 1 -> 127
    soft_decision_t expected_soft[2];
    expected_soft[0] = expected[0] ? 127 : -127;
    expected_soft[1] = expected[1] ? 127 : -127;
    
    // Compute Euclidean distance metric (simplified)
    // Metric = |soft_in[0] - expected_soft[0]| + |soft_in[1] - expected_soft[1]|
    ap_int<9> diff0 = soft_in[0] - expected_soft[0];
    ap_int<9> diff1 = soft_in[1] - expected_soft[1];
    
    ap_uint<8> abs_diff0;
    if (diff0 < 0) abs_diff0 = (ap_uint<8>)(-diff0);
    else abs_diff0 = (ap_uint<8>)diff0;
    
    ap_uint<8> abs_diff1;
    if (diff1 < 0) abs_diff1 = (ap_uint<8>)(-diff1);
    else abs_diff1 = (ap_uint<8>)diff1;
    
    return abs_diff0 + abs_diff1;
}

// Get expected output for a state and input bit
inline ap_uint<2> expected_output(state_t state, ap_uint<1> input_bit) {
    #pragma HLS INLINE
    // Form K-bit word: {state, input_bit}
    ap_uint<K> word = (state, input_bit);
    
    // G1 = 0b111
    ap_uint<1> out1 = word[0] ^ word[1] ^ word[2];
    
    // G2 = 0b101
    ap_uint<1> out2 = word[0] ^ word[2];
    
    return (out2, out1);
}

// ACS (Add-Compare-Select) unit
struct ACSResult {
    path_metric_t new_metric;
    ap_uint<1> decision;  // 0 = upper path, 1 = lower path
};

inline ACSResult acs(
    path_metric_t metric0,
    path_metric_t metric1,
    ap_uint<8> branch0,
    ap_uint<8> branch1
) {
    #pragma HLS INLINE
    ACSResult result;
    
    // Add
    path_metric_t new_metric0 = metric0 + branch0;
    path_metric_t new_metric1 = metric1 + branch1;
    
    // Saturate to prevent overflow
    if (new_metric0 > MAX_METRIC) new_metric0 = MAX_METRIC;
    if (new_metric1 > MAX_METRIC) new_metric1 = MAX_METRIC;
    
    // Compare and Select
    if (new_metric0 <= new_metric1) {
        result.new_metric = new_metric0;
        result.decision = 0;
    } else {
        result.new_metric = new_metric1;
        result.decision = 1;
    }
    
    return result;
}

// Viterbi decoder kernel
void viterbi_simple(
    hls::stream<soft_decision_t>& soft_in_stream,
    hls::stream<ap_uint<1>>& bit_out_stream,
    ap_uint<32> num_symbols
);

#endif // VITERBI_SIMPLE_KERNEL_H
