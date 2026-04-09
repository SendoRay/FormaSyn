#ifndef LDPC_CNU_MIN_SUM_KERNEL_H
#define LDPC_CNU_MIN_SUM_KERNEL_H

#include <ap_fixed.h>

// LDPC Code Configuration
#define CNU_MAX_DEGREE 6
#define NUM_CHECK_NODES 4
#define LLR_WIDTH 6
#define LLR_INT 1

// LLR fixed-point type
typedef ap_fixed<LLR_WIDTH, LLR_INT> llr_t;
typedef ap_int<LLR_WIDTH> llr_int_t;

// Check Node Update Kernel
void ldpc_cnu_min_sum(
    llr_t v2c_msgs[NUM_CHECK_NODES][CNU_MAX_DEGREE],
    int degree[NUM_CHECK_NODES],
    llr_t c2v_msgs[NUM_CHECK_NODES][CNU_MAX_DEGREE]
);

void check_node_update(
    llr_t v2c[CNU_MAX_DEGREE],
    int degree,
    llr_t c2v[CNU_MAX_DEGREE]
);

inline int sign_xor(int sign1, int sign2);
inline int get_sign(llr_t val);
inline llr_t abs_llr(llr_t val);
void find_two_mins(llr_t arr[CNU_MAX_DEGREE], int degree, llr_t &min1, llr_t &min2, int &min1_idx);

#endif
