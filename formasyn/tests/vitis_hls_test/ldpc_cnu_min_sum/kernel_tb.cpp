#include "kernel.h"
#include <iostream>
#include <cmath>
#include <cstdlib>

using namespace std;

// Golden reference min-sum CNU implementation
void golden_check_node_update(
    llr_t v2c[CNU_MAX_DEGREE],
    int degree,
    llr_t c2v[CNU_MAX_DEGREE]
) {
    // Compute signs and absolute values
    int signs[CNU_MAX_DEGREE];
    double abs_vals[CNU_MAX_DEGREE];
    
    for (int i = 0; i < degree; i++) {
        double val = v2c[i].to_double();
        signs[i] = (val < 0) ? 1 : 0;
        abs_vals[i] = abs(val);
    }
    
    // Overall sign product
    int overall_sign = 0;
    for (int i = 0; i < degree; i++) {
        overall_sign ^= signs[i];
    }
    
    // Generate output for each edge
    for (int i = 0; i < degree; i++) {
        // Find minimum excluding self
        double min_val = 1000.0;
        for (int j = 0; j < degree; j++) {
            if (j != i && abs_vals[j] < min_val) {
                min_val = abs_vals[j];
            }
        }
        
        // Compute output sign
        int out_sign = overall_sign ^ signs[i];
        
        // Apply sign
        double result = out_sign ? -min_val : min_val;
        c2v[i] = llr_t(result);
    }
    
    // Zero out unused
    for (int i = degree; i < CNU_MAX_DEGREE; i++) {
        c2v[i] = llr_t(0);
    }
}

// Compare two C2V message arrays
bool compare_c2v(llr_t dut[CNU_MAX_DEGREE], llr_t golden[CNU_MAX_DEGREE], int degree, double tolerance) {
    bool match = true;
    for (int i = 0; i < degree; i++) {
        double diff = abs(dut[i].to_double() - golden[i].to_double());
        if (diff > tolerance) {
            match = false;
            cout << "  Mismatch at index " << i << ": DUT=" << dut[i] 
                 << ", Golden=" << golden[i] << ", diff=" << diff << endl;
        }
    }
    return match;
}

// Test 1: Simple parity check - all positive LLRs
void test_all_positive() {
    cout << "\n=== Test 1: All Positive LLRs ===" << endl;
    
    llr_t v2c[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t golden_c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    int degree[NUM_CHECK_NODES];
    
    // Initialize one check node with degree 4
    degree[0] = 4;
    for (int i = 1; i < NUM_CHECK_NODES; i++) {
        degree[i] = 0;
    }
    
    // All positive LLRs (indicating bit=0 with varying confidence)
    v2c[0][0] = llr_t(1.5);
    v2c[0][1] = llr_t(0.5);
    v2c[0][2] = llr_t(2.0);
    v2c[0][3] = llr_t(1.0);
    for (int i = 4; i < CNU_MAX_DEGREE; i++) {
        v2c[0][i] = llr_t(0);
    }
    
    // Run DUT
    ldpc_cnu_min_sum(v2c, degree, c2v);
    
    // Golden reference
    golden_check_node_update(v2c[0], degree[0], golden_c2v[0]);
    
    // Compare
    cout << "Input LLRs: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << v2c[0][i] << " ";
    }
    cout << endl;
    
    cout << "DUT Output: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << c2v[0][i] << " ";
    }
    cout << endl;
    
    cout << "Golden Output: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << golden_c2v[0][i] << " ";
    }
    cout << endl;
    
    bool pass = compare_c2v(c2v[0], golden_c2v[0], degree[0], 0.1);
    cout << (pass ? "TEST PASSED" : "TEST FAILED") << endl;
}

// Test 2: Mixed signs
void test_mixed_signs() {
    cout << "\n=== Test 2: Mixed Signs ===" << endl;
    
    llr_t v2c[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t golden_c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    int degree[NUM_CHECK_NODES];
    
    degree[0] = 4;
    for (int i = 1; i < NUM_CHECK_NODES; i++) {
        degree[i] = 0;
    }
    
    // Mixed signs: 2 positive, 2 negative
    v2c[0][0] = llr_t(1.5);
    v2c[0][1] = llr_t(-0.5);
    v2c[0][2] = llr_t(2.0);
    v2c[0][3] = llr_t(-1.0);
    for (int i = 4; i < CNU_MAX_DEGREE; i++) {
        v2c[0][i] = llr_t(0);
    }
    
    // Run DUT
    ldpc_cnu_min_sum(v2c, degree, c2v);
    
    // Golden reference
    golden_check_node_update(v2c[0], degree[0], golden_c2v[0]);
    
    cout << "Input LLRs: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << v2c[0][i] << " ";
    }
    cout << endl;
    
    cout << "DUT Output: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << c2v[0][i] << " ";
    }
    cout << endl;
    
    cout << "Golden Output: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << golden_c2v[0][i] << " ";
    }
    cout << endl;
    
    bool pass = compare_c2v(c2v[0], golden_c2v[0], degree[0], 0.1);
    cout << (pass ? "TEST PASSED" : "TEST FAILED") << endl;
}

// Test 3: Degree 6 (maximum)
void test_max_degree() {
    cout << "\n=== Test 3: Maximum Degree (6) ===" << endl;
    
    llr_t v2c[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t golden_c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    int degree[NUM_CHECK_NODES];
    
    degree[0] = 6;
    for (int i = 1; i < NUM_CHECK_NODES; i++) {
        degree[i] = 0;
    }
    
    // Random LLRs with varying magnitudes
    v2c[0][0] = llr_t(0.5);
    v2c[0][1] = llr_t(-1.0);
    v2c[0][2] = llr_t(1.5);
    v2c[0][3] = llr_t(-0.25);
    v2c[0][4] = llr_t(2.0);
    v2c[0][5] = llr_t(-1.5);
    
    // Run DUT
    ldpc_cnu_min_sum(v2c, degree, c2v);
    
    // Golden reference
    golden_check_node_update(v2c[0], degree[0], golden_c2v[0]);
    
    cout << "Input LLRs: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << v2c[0][i] << " ";
    }
    cout << endl;
    
    cout << "DUT Output: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << c2v[0][i] << " ";
    }
    cout << endl;
    
    bool pass = compare_c2v(c2v[0], golden_c2v[0], degree[0], 0.1);
    cout << (pass ? "TEST PASSED" : "TEST FAILED") << endl;
}

// Test 4: Multiple check nodes
void test_multiple_cn() {
    cout << "\n=== Test 4: Multiple Check Nodes ===" << endl;
    
    llr_t v2c[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t golden_c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    int degree[NUM_CHECK_NODES];
    
    // Set degrees for all check nodes
    degree[0] = 4;
    degree[1] = 3;
    degree[2] = 5;
    degree[3] = 4;
    
    // Initialize with some test data
    for (int cn = 0; cn < NUM_CHECK_NODES; cn++) {
        for (int i = 0; i < CNU_MAX_DEGREE; i++) {
            if (i < degree[cn]) {
                // Alternating pattern
                double val = (i % 2 == 0) ? (0.5 + i * 0.25) : -(0.5 + i * 0.25);
                v2c[cn][i] = llr_t(val);
            } else {
                v2c[cn][i] = llr_t(0);
            }
        }
    }
    
    // Run DUT
    ldpc_cnu_min_sum(v2c, degree, c2v);
    
    // Golden reference for each check node
    bool all_pass = true;
    for (int cn = 0; cn < NUM_CHECK_NODES; cn++) {
        golden_check_node_update(v2c[cn], degree[cn], golden_c2v[cn]);
        bool pass = compare_c2v(c2v[cn], golden_c2v[cn], degree[cn], 0.1);
        if (!pass) {
            cout << "Check node " << cn << " FAILED" << endl;
            all_pass = false;
        }
    }
    
    cout << (all_pass ? "TEST PASSED" : "TEST FAILED") << endl;
}

// Test 5: Verify min-sum property
void test_min_sum_property() {
    cout << "\n=== Test 5: Min-Sum Property Verification ===" << endl;
    
    llr_t v2c[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    llr_t c2v[NUM_CHECK_NODES][CNU_MAX_DEGREE];
    int degree[NUM_CHECK_NODES];
    
    degree[0] = 4;
    for (int i = 1; i < NUM_CHECK_NODES; i++) {
        degree[i] = 0;
    }
    
    // Test case: one message has much larger magnitude
    v2c[0][0] = llr_t(0.5);
    v2c[0][1] = llr_t(0.6);
    v2c[0][2] = llr_t(10.0);  // Very large (should be excluded in min for others)
    v2c[0][3] = llr_t(0.4);
    for (int i = 4; i < CNU_MAX_DEGREE; i++) {
        v2c[0][i] = llr_t(0);
    }
    
    // Run DUT
    ldpc_cnu_min_sum(v2c, degree, c2v);
    
    cout << "Input LLRs: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << v2c[0][i] << " ";
    }
    cout << endl;
    
    cout << "Output C2V: ";
    for (int i = 0; i < degree[0]; i++) {
        cout << c2v[0][i] << " ";
    }
    cout << endl;
    
    // Verify property: output for index 2 should use min of others (0.4)
    // others should use min excluding self (0.4 or 0.5)
    cout << "Checking min-sum property..." << endl;
    
    // For edge 2 (large input), output should be min of {0.5, 0.6, 0.4} = 0.4
    // For other edges, output should be min of remaining = 0.4
    
    bool property_ok = true;
    for (int i = 0; i < degree[0]; i++) {
        double out_mag = abs(c2v[0][i].to_double());
        // All outputs should have magnitude around 0.4 (the min of the set excluding each)
        if (out_mag < 0.35 || out_mag > 0.45) {
            property_ok = false;
            cout << "  Property violation at index " << i << ": magnitude=" << out_mag << endl;
        }
    }
    
    cout << (property_ok ? "TEST PASSED: Min-sum property verified" : "TEST FAILED") << endl;
}

int main() {
    cout << "========================================" << endl;
    cout << "LDPC Check Node Update (Min-Sum) Testbench" << endl;
    cout << "========================================" << endl;
    cout << "Configuration:" << endl;
    cout << "  - Max Check Node Degree: " << CNU_MAX_DEGREE << endl;
    cout << "  - Number of Check Nodes: " << NUM_CHECK_NODES << endl;
    cout << "  - LLR Width: " << LLR_WIDTH << " bits (" << LLR_INT << " integer)" << endl;
    
    // Run all tests
    test_all_positive();
    test_mixed_signs();
    test_max_degree();
    test_multiple_cn();
    test_min_sum_property();
    
    cout << "\n========================================" << endl;
    cout << "All tests completed" << endl;
    cout << "========================================" << endl;
    
    return 0;
}
