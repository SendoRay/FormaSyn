#include "kernel.h"

// Viterbi Decoder Implementation
// 4-state decoder for K=3, rate 1/2 convolutional code
// Traceback depth: 20

void viterbi_simple(
    hls::stream<soft_decision_t>& soft_in_stream,
    hls::stream<ap_uint<1>>& bit_out_stream,
    ap_uint<32> num_symbols
) {
    #pragma HLS INTERFACE mode=ap_ctrl_chain port=return
    #pragma HLS INTERFACE mode=ap_fifo port=soft_in_stream
    #pragma HLS INTERFACE mode=ap_fifo port=bit_out_stream
    #pragma HLS INTERFACE mode=ap_stable port=num_symbols
    
    #pragma HLS DATAFLOW
    
    // Path metrics for all states
    path_metric_t path_metrics[NUM_STATES];
    path_metric_t new_path_metrics[NUM_STATES];
    #pragma HLS ARRAY_PARTITION variable=path_metrics complete
    #pragma HLS ARRAY_PARTITION variable=new_path_metrics complete
    
    // Survivor memory (traceback)
    // Stores decisions for each state at each time step
    ap_uint<1> survivor_memory[TRACEBACK_DEPTH][NUM_STATES];
    #pragma HLS ARRAY_PARTITION variable=survivor_memory complete dim=2
    
    // Initialize path metrics - state 0 has metric 0, others have large metric
    for (int s = 0; s < NUM_STATES; s++) {
        #pragma HLS UNROLL
        path_metrics[s] = (s == 0) ? 0 : MAX_METRIC;
    }
    
    // Traceback state
    state_t tb_state = 0;
    ap_uint<8> tb_count = 0;
    
    // Process all symbols
    for (ap_uint<32> sym = 0; sym < num_symbols + TRACEBACK_DEPTH; sym++) {
        #pragma HLS PIPELINE II=1
        
        soft_decision_t soft_in[2];
        
        // Read input or use zeros during traceback flushing
        if (sym < num_symbols) {
            soft_in[0] = soft_in_stream.read();
            soft_in[1] = soft_in_stream.read();
        } else {
            soft_in[0] = 0;
            soft_in[1] = 0;
        }
        
        // Compute branch metrics and perform ACS for each state
        // State transitions for K=3:
        // From state s with input b: go to state (s << 1 | b) & 0x3
        // Or equivalently: next_state = ((s & 1) << 1) | b
        
        // ACS for each next state
        ACSResult acs_results[NUM_STATES];
        #pragma HLS ARRAY_PARTITION variable=acs_results complete
        
        // State 0: can come from state 0 (input 0) or state 2 (input 0)
        // Actually: from state, input -> next_state
        // State 0, input 0 -> next_state 0
        // State 0, input 1 -> next_state 2
        // State 1, input 0 -> next_state 0
        // State 1, input 1 -> next_state 2
        // State 2, input 0 -> next_state 1
        // State 2, input 1 -> next_state 3
        // State 3, input 0 -> next_state 1
        // State 3, input 1 -> next_state 3
        
        // For each next state, find the best predecessor
        
        // Next state 0: predecessors are state 0 (input 0), state 1 (input 0)
        ap_uint<2> out_0_0 = expected_output(0, 0);  // state 0, input 0
        ap_uint<2> out_1_0 = expected_output(1, 0);  // state 1, input 0
        ap_uint<8> bm_0_0 = branch_metric(soft_in, out_0_0);
        ap_uint<8> bm_1_0 = branch_metric(soft_in, out_1_0);
        acs_results[0] = acs(path_metrics[0], path_metrics[1], bm_0_0, bm_1_0);
        
        // Next state 1: predecessors are state 2 (input 0), state 3 (input 0)
        ap_uint<2> out_2_0 = expected_output(2, 0);  // state 2, input 0
        ap_uint<2> out_3_0 = expected_output(3, 0);  // state 3, input 0
        ap_uint<8> bm_2_0 = branch_metric(soft_in, out_2_0);
        ap_uint<8> bm_3_0 = branch_metric(soft_in, out_3_0);
        acs_results[1] = acs(path_metrics[2], path_metrics[3], bm_2_0, bm_3_0);
        
        // Next state 2: predecessors are state 0 (input 1), state 1 (input 1)
        ap_uint<2> out_0_1 = expected_output(0, 1);  // state 0, input 1
        ap_uint<2> out_1_1 = expected_output(1, 1);  // state 1, input 1
        ap_uint<8> bm_0_1 = branch_metric(soft_in, out_0_1);
        ap_uint<8> bm_1_1 = branch_metric(soft_in, out_1_1);
        acs_results[2] = acs(path_metrics[0], path_metrics[1], bm_0_1, bm_1_1);
        
        // Next state 3: predecessors are state 2 (input 1), state 3 (input 1)
        ap_uint<2> out_2_1 = expected_output(2, 1);  // state 2, input 1
        ap_uint<2> out_3_1 = expected_output(3, 1);  // state 3, input 1
        ap_uint<8> bm_2_1 = branch_metric(soft_in, out_2_1);
        ap_uint<8> bm_3_1 = branch_metric(soft_in, out_3_1);
        acs_results[3] = acs(path_metrics[2], path_metrics[3], bm_2_1, bm_3_1);
        
        // Update path metrics
        for (int s = 0; s < NUM_STATES; s++) {
            #pragma HLS UNROLL
            new_path_metrics[s] = acs_results[s].new_metric;
            
            // Store survivor decision
            // Shift survivor memory and add new decision at front
            for (int d = TRACEBACK_DEPTH - 1; d > 0; d--) {
                #pragma HLS UNROLL
                survivor_memory[d][s] = survivor_memory[d-1][s];
            }
            survivor_memory[0][s] = acs_results[s].decision;
        }
        
        // Copy new metrics back
        for (int s = 0; s < NUM_STATES; s++) {
            #pragma HLS UNROLL
            path_metrics[s] = new_path_metrics[s];
        }
        
        // Traceback and output when we have enough history
        if (tb_count >= TRACEBACK_DEPTH && sym >= TRACEBACK_DEPTH) {
            // Find state with minimum metric
            path_metric_t min_metric = path_metrics[0];
            state_t min_state = 0;
            for (int s = 1; s < NUM_STATES; s++) {
                #pragma HLS UNROLL
                if (path_metrics[s] < min_metric) {
                    min_metric = path_metrics[s];
                    min_state = s;
                }
            }
            
            // Traceback through survivor memory
            state_t trace_state = min_state;
            ap_uint<1> decoded_bit = 0;
            
            // Trace back TRACEBACK_DEPTH steps
            for (int d = 0; d < TRACEBACK_DEPTH; d++) {
                #pragma HLS UNROLL
                ap_uint<1> decision = survivor_memory[d][trace_state];
                
                // Reconstruct the input bit from the transition
                // The decision tells us which predecessor was chosen
                // For state 0,1: decision 0 -> from state 0, decision 1 -> from state 1, both input 0
                // For state 2,3: decision 0 -> from state 0, decision 1 -> from state 1, both input 1
                
                if (d == TRACEBACK_DEPTH - 1) {
                    // This is the oldest decision - extract the bit
                    decoded_bit = (trace_state >= 2) ? 1 : 0;
                }
                
                // Update trace state: go to predecessor
                // Predecessor state = (trace_state >> 1) corresponds to the decision
                // Actually need to reverse the transition
                // If we're at state S with decision D, we came from state:
                // For S=0,1: came from state (0 or 1) with input 0
                // For S=2,3: came from state (0 or 1) with input 1
                trace_state = (decision, trace_state[0]);
            }
            
            bit_out_stream.write(decoded_bit);
        } else {
            tb_count++;
        }
    }
}
