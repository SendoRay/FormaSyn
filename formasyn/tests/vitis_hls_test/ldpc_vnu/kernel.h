#ifndef LDPC_VNU_KERNEL_H
#define LDPC_VNU_KERNEL_H

#include <ap_fixed.h>

// LDPC Variable Node Update Configuration
#define VNU_MAX_DEGREE 3        // Maximum variable node degree
#define NUM_VAR_NODES 8         // Number of variable nodes processed
#define LLR_WIDTH 6             // LLR bit width
#define LLR_INT 1               // LLR integer bits
#define MAX_ITER 10             // Maximum decoding iterations

// LLR fixed-point type
// Using 6-bit LLRs: 1 sign bit, 1 integer bit, 4 fractional bits
typedef ap_fixed<LLR_WIDTH, LLR_INT> llr_t;

// Variable Node Update Kernel
// Performs variable-to-check message update and bit decision for LDPC decoding
void ldpc_vnu(
    llr_t channel_llr[NUM_VAR_NODES],                  // Channel LLR (intrinsic)
    llr_t c2v_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE],     // Check-to-variable messages
    int degree[NUM_VAR_NODES],                         // Actual degree per variable node
    llr_t v2c_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE],     // Output: Variable-to-check messages
    ap_uint<1> decisions[NUM_VAR_NODES]                // Output: Bit decisions (0/1)
);

// Single variable node update
// Input: Channel LLR + messages from check nodes
// Output: Messages to each check node + hard decision
void variable_node_update(
    llr_t channel_llr,                // Channel LLR
    llr_t c2v[VNU_MAX_DEGREE],        // Check-to-variable messages
    int degree,                       // Number of connected checks
    llr_t v2c[VNU_MAX_DEGREE],        // Output: Variable-to-check messages
    ap_uint<1> &decision              // Output: Hard decision
);

// Compute total LLR (channel + all incoming messages)
llr_t compute_total_llr(
    llr_t channel_llr,
    llr_t c2v[VNU_MAX_DEGREE],
    int degree
);

// Make hard decision from total LLR
// Returns 0 if LLR >= 0, 1 if LLR < 0
inline ap_uint<1> make_decision(llr_t total_llr);

#endif // LDPC_VNU_KERNEL_H
