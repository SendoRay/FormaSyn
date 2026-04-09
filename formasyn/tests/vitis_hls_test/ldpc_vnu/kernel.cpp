#include "kernel.h"
#include <hls_math.h>

// Make hard decision from total LLR
// Returns 0 if LLR >= 0 (more likely bit=0), 1 if LLR < 0 (more likely bit=1)
inline ap_uint<1> make_decision(llr_t total_llr) {
    #pragma HLS INLINE
    // LLR = log(P(0)/P(1))
    // LLR >= 0 → P(0) >= P(1) → decide 0
    // LLR < 0  → P(0) < P(1)  → decide 1
    return total_llr < llr_t(0) ? ap_uint<1>(1) : ap_uint<1>(0);
}

// Compute total LLR = channel_LLR + sum of all incoming C2V messages
// This represents the complete belief about the bit
llr_t compute_total_llr(
    llr_t channel_llr,
    llr_t c2v[VNU_MAX_DEGREE],
    int degree
) {
    #pragma HLS INLINE
    
    llr_t total = channel_llr;
    
    SUM_LOOP:
    for (int i = 0; i < VNU_MAX_DEGREE; i++) {
        #pragma HLS UNROLL
        if (i < degree) {
            total = total + c2v[i];
        }
    }
    
    return total;
}

// Single variable node update
// The variable node combines channel information with check node messages
// Output to each check node excludes the message from that check node (extrinsic)
void variable_node_update(
    llr_t channel_llr,
    llr_t c2v[VNU_MAX_DEGREE],
    int degree,
    llr_t v2c[VNU_MAX_DEGREE],
    ap_uint<1> &decision
) {
    #pragma HLS INLINE
    #pragma HLS PIPELINE II=1
    
    // Arrays with partitioning for parallel access
    llr_t local_c2v[VNU_MAX_DEGREE];
    #pragma HLS ARRAY_PARTITION variable=local_c2v complete
    
    // Load C2V messages
    LOAD_LOOP:
    for (int i = 0; i < VNU_MAX_DEGREE; i++) {
        #pragma HLS UNROLL
        local_c2v[i] = (i < degree) ? c2v[i] : llr_t(0);
    }
    
    // Compute total LLR (all information combined)
    llr_t total_llr = compute_total_llr(channel_llr, local_c2v, degree);
    
    // Make hard decision based on total LLR
    decision = make_decision(total_llr);
    
    // Generate V2C messages: total excluding each incoming message
    // L(q_ij) = L_channel + Σ L(r_j'i) for j'≠j
    V2C_GEN_LOOP:
    for (int i = 0; i < VNU_MAX_DEGREE; i++) {
        #pragma HLS UNROLL
        if (i < degree) {
            // Extrinsic message: total minus the message from this check node
            v2c[i] = total_llr - local_c2v[i];
        } else {
            v2c[i] = llr_t(0);
        }
    }
}

// Main LDPC Variable Node Update Kernel
// Processes multiple variable nodes in parallel
void ldpc_vnu(
    llr_t channel_llr[NUM_VAR_NODES],
    llr_t c2v_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE],
    int degree[NUM_VAR_NODES],
    llr_t v2c_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE],
    ap_uint<1> decisions[NUM_VAR_NODES]
) {
    #pragma HLS INTERFACE mode=ap_memory port=channel_llr
    #pragma HLS INTERFACE mode=ap_memory port=c2v_msgs
    #pragma HLS INTERFACE mode=ap_memory port=degree
    #pragma HLS INTERFACE mode=ap_memory port=v2c_msgs
    #pragma HLS INTERFACE mode=ap_memory port=decisions
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    #pragma HLS PIPELINE II=1
    
    #pragma HLS ARRAY_PARTITION variable=c2v_msgs dim=2 complete
    #pragma HLS ARRAY_PARTITION variable=v2c_msgs dim=2 complete
    
    // Process each variable node
    VN_LOOP:
    for (int vn = 0; vn < NUM_VAR_NODES; vn++) {
        #pragma HLS UNROLL factor=4
        
        llr_t local_c2v[VNU_MAX_DEGREE];
        llr_t local_v2c[VNU_MAX_DEGREE];
        #pragma HLS ARRAY_PARTITION variable=local_c2v complete
        #pragma HLS ARRAY_PARTITION variable=local_v2c complete
        
        // Load C2V messages for this variable node
        C2V_LOAD_LOOP:
        for (int d = 0; d < VNU_MAX_DEGREE; d++) {
            #pragma HLS UNROLL
            local_c2v[d] = c2v_msgs[vn][d];
        }
        
        // Perform variable node update
        ap_uint<1> local_decision;
        variable_node_update(
            channel_llr[vn],
            local_c2v,
            degree[vn],
            local_v2c,
            local_decision
        );
        
        // Store V2C messages
        V2C_STORE_LOOP:
        for (int d = 0; d < VNU_MAX_DEGREE; d++) {
            #pragma HLS UNROLL
            v2c_msgs[vn][d] = local_v2c[d];
        }
        
        // Store decision
        decisions[vn] = local_decision;
    }
}
