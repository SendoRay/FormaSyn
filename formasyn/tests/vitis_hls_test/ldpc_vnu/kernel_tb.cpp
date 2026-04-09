#include "kernel.h"
#include <iostream>
#include <cmath>
#include <cstdlib>

using namespace std;

// Golden reference VNU implementation
void golden_variable_node_update(
    llr_t channel_llr,
    llr_t c2v[VNU_MAX_DEGREE],
    int degree,
    llr_t v2c[VNU_MAX_DEGREE],
    ap_uint<1> &decision
) {
    // Compute total LLR
    double total = channel_llr.to_double();
    for (int i = 0; i < degree; i++) {
        total += c2v[i].to_double();
    }
    
    // Make decision
    decision = (total < 0) ? ap_uint<1>(1) : ap_uint<1>(0);
    
    // Generate V2C messages (extrinsic)
    for (int i = 0; i < degree; i++) {
        double v2c_val = total - c2v[i].to_double();
        v2c[i] = llr_t(v2c_val);
    }
    
    // Zero out unused
    for (int i = degree; i < VNU_MAX_DEGREE; i++) {
        v2c[i] = llr_t(0);
    }
}

// Compare V2C arrays
bool compare_v2c(llr_t dut[VNU_MAX_DEGREE], llr_t golden[VNU_MAX_DEGREE], 
                 int degree, double tolerance) {
    bool match = true;
    for (int i = 0; i < degree; i++) {
        double diff = abs(dut[i].to_double() - golden[i].to_double());
        if (diff > tolerance) {
            match = false;
            cout << "  V2C mismatch at index " << i << ": DUT=" << dut[i] 
                 << ", Golden=" << golden[i] << ", diff=" << diff << endl;
        }
    }
    return match;
}

// Compare decisions
bool compare_decisions(ap_uint<1> dut[NUM_VAR_NODES], ap_uint<1> golden[NUM_VAR_NODES],
                       int num_nodes) {
    bool match = true;
    for (int i = 0; i < num_nodes; i++) {
        if (dut[i] != golden[i]) {
            match = false;
            cout << "  Decision mismatch at node " << i << ": DUT=" << dut[i] 
                 << ", Golden=" << golden[i] << endl;
        }
    }
    return match;
}

// Test 1: Simple case - positive channel LLR, no C2V messages
void test_positive_channel_only() {
    cout << "\n=== Test 1: Positive Channel LLR Only ===" << endl;
    
    llr_t channel_llr[NUM_VAR_NODES];
    llr_t c2v_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t v2c_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t golden_v2c[NUM_VAR_NODES][VNU_MAX_DEGREE];
    ap_uint<1> decisions[NUM_VAR_NODES];
    ap_uint<1> golden_decisions[NUM_VAR_NODES];
    int degree[NUM_VAR_NODES];
    
    // Initialize one variable node with degree 2
    channel_llr[0] = llr_t(1.5);  // Positive: favors bit 0
    degree[0] = 2;
    c2v_msgs[0][0] = llr_t(0);  // No info from checks
    c2v_msgs[0][1] = llr_t(0);
    c2v_msgs[0][2] = llr_t(0);
    
    // Other nodes unused
    for (int i = 1; i < NUM_VAR_NODES; i++) {
        degree[i] = 0;
        channel_llr[i] = llr_t(0);
        for (int d = 0; d < VNU_MAX_DEGREE; d++) {
            c2v_msgs[i][d] = llr_t(0);
        }
    }
    
    // Run DUT
    ldpc_vnu(channel_llr, c2v_msgs, degree, v2c_msgs, decisions);
    
    // Golden reference
    golden_variable_node_update(channel_llr[0], c2v_msgs[0], degree[0], 
                                golden_v2c[0], golden_decisions[0]);
    for (int i = 1; i < NUM_VAR_NODES; i++) {
        golden_decisions[i] = ap_uint<1>(0);
    }
    
    cout << "Channel LLR: " << channel_llr[0] << endl;
    cout << "Decision: " << decisions[0] << " (expected 0 for positive LLR)" << endl;
    cout << "V2C[0]: " << v2c_msgs[0][0] << " (should equal channel LLR)" << endl;
    cout << "V2C[1]: " << v2c_msgs[0][1] << " (should equal channel LLR)" << endl;
    
    bool pass = (decisions[0] == ap_uint<1>(0));
    pass &= compare_v2c(v2c_msgs[0], golden_v2c[0], degree[0], 0.1);
    cout << (pass ? "TEST PASSED" : "TEST FAILED") << endl;
}

// Test 2: Negative channel LLR with some C2V messages
void test_negative_with_c2v() {
    cout << "\n=== Test 2: Negative Channel LLR with C2V ===" << endl;
    
    llr_t channel_llr[NUM_VAR_NODES];
    llr_t c2v_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t v2c_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t golden_v2c[NUM_VAR_NODES][VNU_MAX_DEGREE];
    ap_uint<1> decisions[NUM_VAR_NODES];
    ap_uint<1> golden_decisions[NUM_VAR_NODES];
    int degree[NUM_VAR_NODES];
    
    // Variable node with degree 3
    channel_llr[0] = llr_t(-1.0);  // Negative: favors bit 1
    degree[0] = 3;
    c2v_msgs[0][0] = llr_t(0.5);   // Positive: favors bit 0
    c2v_msgs[0][1] = llr_t(-0.3);  // Negative: favors bit 1
    c2v_msgs[0][2] = llr_t(0.8);   // Positive: favors bit 0
    
    // Other nodes unused
    for (int i = 1; i < NUM_VAR_NODES; i++) {
        degree[i] = 0;
        channel_llr[i] = llr_t(0);
        for (int d = 0; d < VNU_MAX_DEGREE; d++) {
            c2v_msgs[i][d] = llr_t(0);
        }
    }
    
    // Run DUT
    ldpc_vnu(channel_llr, c2v_msgs, degree, v2c_msgs, decisions);
    
    // Golden reference
    golden_variable_node_update(channel_llr[0], c2v_msgs[0], degree[0], 
                                golden_v2c[0], golden_decisions[0]);
    
    // Total LLR = -1.0 + 0.5 - 0.3 + 0.8 = 0.0 (borderline)
    // With fixed-point: might be slightly positive or negative
    cout << "Channel LLR: " << channel_llr[0] << endl;
    cout << "C2V[0]: " << c2v_msgs[0][0] << endl;
    cout << "C2V[1]: " << c2v_msgs[0][1] << endl;
    cout << "C2V[2]: " << c2v_msgs[0][2] << endl;
    cout << "Decision: " << decisions[0] << endl;
    cout << "V2C[0]: " << v2c_msgs[0][0] << " (total - C2V[0])" << endl;
    cout << "V2C[1]: " << v2c_msgs[0][1] << " (total - C2V[1])" << endl;
    cout << "V2C[2]: " << v2c_msgs[0][2] << " (total - C2V[2])" << endl;
    
    bool pass = compare_v2c(v2c_msgs[0], golden_v2c[0], degree[0], 0.15);
    cout << (pass ? "TEST PASSED" : "TEST FAILED") << endl;
}

// Test 3: Degree 1 (edge case)
void test_degree_one() {
    cout << "\n=== Test 3: Degree 1 (Edge Case) ===" << endl;
    
    llr_t channel_llr[NUM_VAR_NODES];
    llr_t c2v_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t v2c_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t golden_v2c[NUM_VAR_NODES][VNU_MAX_DEGREE];
    ap_uint<1> decisions[NUM_VAR_NODES];
    ap_uint<1> golden_decisions[NUM_VAR_NODES];
    int degree[NUM_VAR_NODES];
    
    // Variable node with degree 1
    channel_llr[0] = llr_t(0.75);
    degree[0] = 1;
    c2v_msgs[0][0] = llr_t(-0.25);
    c2v_msgs[0][1] = llr_t(0);
    c2v_msgs[0][2] = llr_t(0);
    
    // Other nodes unused
    for (int i = 1; i < NUM_VAR_NODES; i++) {
        degree[i] = 0;
        channel_llr[i] = llr_t(0);
        for (int d = 0; d < VNU_MAX_DEGREE; d++) {
            c2v_msgs[i][d] = llr_t(0);
        }
    }
    
    // Run DUT
    ldpc_vnu(channel_llr, c2v_msgs, degree, v2c_msgs, decisions);
    
    // Golden reference
    golden_variable_node_update(channel_llr[0], c2v_msgs[0], degree[0], 
                                golden_v2c[0], golden_decisions[0]);
    
    // Total = 0.75 - 0.25 = 0.5 (positive, decision=0)
    // V2C[0] = total - C2V[0] = 0.5 - (-0.25) = 0.75 (equals channel LLR)
    cout << "Channel LLR: " << channel_llr[0] << endl;
    cout << "C2V[0]: " << c2v_msgs[0][0] << endl;
    cout << "Decision: " << decisions[0] << " (expected 0)" << endl;
    cout << "V2C[0]: " << v2c_msgs[0][0] << " (should equal channel LLR)" << endl;
    
    bool pass = (decisions[0] == ap_uint<1>(0));
    pass &= compare_v2c(v2c_msgs[0], golden_v2c[0], degree[0], 0.1);
    cout << (pass ? "TEST PASSED" : "TEST FAILED") << endl;
}

// Test 4: Multiple variable nodes
void test_multiple_vn() {
    cout << "\n=== Test 4: Multiple Variable Nodes ===" << endl;
    
    llr_t channel_llr[NUM_VAR_NODES];
    llr_t c2v_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t v2c_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t golden_v2c[NUM_VAR_NODES][VNU_MAX_DEGREE];
    ap_uint<1> decisions[NUM_VAR_NODES];
    ap_uint<1> golden_decisions[NUM_VAR_NODES];
    int degree[NUM_VAR_NODES];
    
    // Initialize multiple nodes with varying degrees
    for (int i = 0; i < NUM_VAR_NODES; i++) {
        degree[i] = (i % 3) + 1;  // Degrees 1, 2, 3
        channel_llr[i] = llr_t(0.5 - i * 0.2);  // Alternating bias
        
        for (int d = 0; d < VNU_MAX_DEGREE; d++) {
            if (d < degree[i]) {
                c2v_msgs[i][d] = llr_t((i + d) * 0.1 - 0.2);
            } else {
                c2v_msgs[i][d] = llr_t(0);
            }
        }
    }
    
    // Run DUT
    ldpc_vnu(channel_llr, c2v_msgs, degree, v2c_msgs, decisions);
    
    // Golden reference for all nodes
    bool all_pass = true;
    for (int i = 0; i < NUM_VAR_NODES; i++) {
        golden_variable_node_update(channel_llr[i], c2v_msgs[i], degree[i], 
                                    golden_v2c[i], golden_decisions[i]);
        bool pass = compare_v2c(v2c_msgs[i], golden_v2c[i], degree[i], 0.15);
        if (decisions[i] != golden_decisions[i]) {
            pass = false;
            cout << "Decision mismatch at node " << i << endl;
        }
        if (!pass) {
            cout << "Variable node " << i << " FAILED" << endl;
            all_pass = false;
        }
    }
    
    cout << "Processed " << NUM_VAR_NODES << " variable nodes" << endl;
    cout << (all_pass ? "TEST PASSED" : "TEST FAILED") << endl;
}

// Test 5: Verify extrinsic property
void test_extrinsic_property() {
    cout << "\n=== Test 5: Extrinsic Property Verification ===" << endl;
    
    llr_t channel_llr[NUM_VAR_NODES];
    llr_t c2v_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    llr_t v2c_msgs[NUM_VAR_NODES][VNU_MAX_DEGREE];
    ap_uint<1> decisions[NUM_VAR_NODES];
    int degree[NUM_VAR_NODES];
    
    // Variable node with degree 3
    channel_llr[0] = llr_t(1.0);
    degree[0] = 3;
    c2v_msgs[0][0] = llr_t(0.5);
    c2v_msgs[0][1] = llr_t(0.3);
    c2v_msgs[0][2] = llr_t(0.2);
    
    // Other nodes unused
    for (int i = 1; i < NUM_VAR_NODES; i++) {
        degree[i] = 0;
        channel_llr[i] = llr_t(0);
        for (int d = 0; d < VNU_MAX_DEGREE; d++) {
            c2v_msgs[i][d] = llr_t(0);
        }
    }
    
    // Run DUT
    ldpc_vnu(channel_llr, c2v_msgs, degree, v2c_msgs, decisions);
    
    // Total LLR = 1.0 + 0.5 + 0.3 + 0.2 = 2.0
    // V2C[i] = total - C2V[i]
    // V2C[0] = 2.0 - 0.5 = 1.5
    // V2C[1] = 2.0 - 0.3 = 1.7
    // V2C[2] = 2.0 - 0.2 = 1.8
    
    double total = 2.0;
    double expected_v2c[3] = {
        total - 0.5,
        total - 0.3,
        total - 0.2
    };
    
    cout << "Channel LLR: " << channel_llr[0] << endl;
    cout << "C2V messages: " << c2v_msgs[0][0] << ", " 
         << c2v_msgs[0][1] << ", " << c2v_msgs[0][2] << endl;
    cout << "V2C messages: " << v2c_msgs[0][0] << ", " 
         << v2c_msgs[0][1] << ", " << v2c_msgs[0][2] << endl;
    cout << "Expected V2C: " << expected_v2c[0] << ", " 
         << expected_v2c[1] << ", " << expected_v2c[2] << endl;
    
    bool pass = true;
    for (int i = 0; i < 3; i++) {
        double diff = abs(v2c_msgs[0][i].to_double() - expected_v2c[i]);
        if (diff > 0.15) {
            pass = false;
            cout << "Extrinsic property violation at index " << i << endl;
        }
    }
    
    cout << (pass ? "TEST PASSED: Extrinsic property verified" : "TEST FAILED") << endl;
}

int main() {
    cout << "========================================" << endl;
    cout << "LDPC Variable Node Update Testbench" << endl;
    cout << "========================================" << endl;
    cout << "Configuration:" << endl;
    cout << "  - Max Variable Node Degree: " << VNU_MAX_DEGREE << endl;
    cout << "  - Number of Variable Nodes: " << NUM_VAR_NODES << endl;
    cout << "  - LLR Width: " << LLR_WIDTH << " bits (" << LLR_INT << " integer)" << endl;
    
    // Run all tests
    test_positive_channel_only();
    test_negative_with_c2v();
    test_degree_one();
    test_multiple_vn();
    test_extrinsic_property();
    
    cout << "\n========================================" << endl;
    cout << "All tests completed" << endl;
    cout << "========================================" << endl;
    
    return 0;
}
