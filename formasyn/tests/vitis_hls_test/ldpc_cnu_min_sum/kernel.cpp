#include "kernel.h"
#include <hls_math.h>

// Get sign of LLR value (1 for negative, 0 for positive/zero)
inline int get_sign(llr_t val) {
    #pragma HLS INLINE
    return val < llr_t(0) ? 1 : 0;
}

// Sign-XOR operation for min-sum (multiplication of signs)
inline int sign_xor(int sign1, int sign2) {
    #pragma HLS INLINE
    return sign1 ^ sign2;
}

// Absolute value for fixed-point LLR
inline llr_t abs_llr(llr_t val) {
    #pragma HLS INLINE
    if (val < llr_t(0)) return -val;
    else return val;
}

// Find minimum and second minimum values in array
// Also returns index of minimum for exclusion logic
void find_two_mins(
    llr_t arr[CNU_MAX_DEGREE],
    int degree,
    llr_t &min1,
    llr_t &min2,
    int &min1_idx
) {
    #pragma HLS INLINE
    
    // Initialize with large value
    min1 = llr_t(3.0);  // Larger than max LLR magnitude
    min2 = llr_t(3.0);
    min1_idx = 0;
    
    FIND_MIN1:
    for (int i = 0; i < CNU_MAX_DEGREE; i++) {
        #pragma HLS UNROLL
        if (i < degree) {
            if (arr[i] < min1) {
                min1 = arr[i];
                min1_idx = i;
            }
        }
    }
    
    FIND_MIN2:
    for (int i = 0; i < CNU_MAX_DEGREE; i++) {
        #pragma HLS UNROLL
        if (i < degree && i != min1_idx) {
            if (arr[i] < min2) {
                min2 = arr[i];
            }
        }
    }
}

// Single check node update using min-sum algorithm
// The check node constraint: XOR of all connected bits = 0 (even parity)
// Min-sum approximation:
//   L(r_ji) = Π sign(L(q_ij')) × min(|L(q_ij')|) for j'≠j
void check_node_update(
    llr_t v2c[CNU_MAX_DEGREE],
    int degree,
    llr_t c2v[CNU_MAX_DEGREE]
) {
    #pragma HLS INLINE
    #pragma HLS PIPELINE II=1
    
    // Arrays for magnitude and sign processing
    llr_t abs_vals[CNU_MAX_DEGREE];
    int signs[CNU_MAX_DEGREE];
    #pragma HLS ARRAY_PARTITION variable=abs_vals complete
    #pragma HLS ARRAY_PARTITION variable=signs complete
    
    // Step 1: Extract signs and absolute values
    EXTRACT_LOOP:
    for (int i = 0; i < CNU_MAX_DEGREE; i++) {
        #pragma HLS UNROLL
        if (i < degree) {
            signs[i] = get_sign(v2c[i]);
            abs_vals[i] = abs_llr(v2c[i]);
        } else {
            signs[i] = 0;
            abs_vals[i] = llr_t(0);
        }
    }
    
    // Step 2: Compute overall sign product (XOR of all signs)
    int overall_sign = 0;
    SIGN_PROD_LOOP:
    for (int i = 0; i < CNU_MAX_DEGREE; i++) {
        #pragma HLS UNROLL
        if (i < degree) {
            overall_sign = sign_xor(overall_sign, signs[i]);
        }
    }
    
    // Step 3: Find minimum and second minimum magnitudes
    llr_t min1, min2;
    int min1_idx;
    find_two_mins(abs_vals, degree, min1, min2, min1_idx);
    
    // Step 4: Generate output messages
    // For each outgoing message: exclude the incoming message from that edge
    // Sign = overall_sign XOR sign_of_excluded
    // Magnitude = (excluded == min1) ? min2 : min1
    OUTPUT_LOOP:
    for (int i = 0; i < CNU_MAX_DEGREE; i++) {
        #pragma HLS UNROLL
        if (i < degree) {
            // Compute sign for this output message
            int out_sign = sign_xor(overall_sign, signs[i]);
            
            // Select magnitude (exclude self)
            llr_t magnitude;
            if (i == min1_idx) {
                magnitude = min2;
            } else {
                magnitude = min1;
            }
            
            // Apply sign
            if (out_sign) c2v[i] = -magnitude;
            else c2v[i] = magnitude;
        } else {
            c2v[i] = llr_t(0);
        }
    }
}

// Main LDPC Check Node Update Kernel (Min-Sum Algorithm)
// Processes multiple check nodes in parallel
void ldpc_cnu_min_sum(
    llr_t v2c_msgs[NUM_CHECK_NODES][CNU_MAX_DEGREE],
    int degree[NUM_CHECK_NODES],
    llr_t c2v_msgs[NUM_CHECK_NODES][CNU_MAX_DEGREE]
) {
    #pragma HLS INTERFACE mode=ap_memory port=v2c_msgs
    #pragma HLS INTERFACE mode=ap_memory port=degree
    #pragma HLS INTERFACE mode=ap_memory port=c2v_msgs
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    #pragma HLS PIPELINE II=1
    
    #pragma HLS ARRAY_PARTITION variable=v2c_msgs dim=2 complete
    #pragma HLS ARRAY_PARTITION variable=c2v_msgs dim=2 complete
    
    // Process each check node
    CN_LOOP:
    for (int cn = 0; cn < NUM_CHECK_NODES; cn++) {
        #pragma HLS UNROLL factor=2
        
        llr_t local_v2c[CNU_MAX_DEGREE];
        llr_t local_c2v[CNU_MAX_DEGREE];
        #pragma HLS ARRAY_PARTITION variable=local_v2c complete
        #pragma HLS ARRAY_PARTITION variable=local_c2v complete
        
        // Load variable-to-check messages
        LOAD_LOOP:
        for (int d = 0; d < CNU_MAX_DEGREE; d++) {
            #pragma HLS UNROLL
            local_v2c[d] = v2c_msgs[cn][d];
        }
        
        // Perform check node update
        check_node_update(local_v2c, degree[cn], local_c2v);
        
        // Store check-to-variable messages
        STORE_LOOP:
        for (int d = 0; d < CNU_MAX_DEGREE; d++) {
            #pragma HLS UNROLL
            c2v_msgs[cn][d] = local_c2v[d];
        }
    }
}
