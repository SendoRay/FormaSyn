#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

// AGC Loop - Automatic Gain Control with Feedback
// 
// FormulaGraph equivalent:
//   Cycle(
//     input_ref="x",
//     body=[
//       abs(x) -> subtract_from(target) -> multiply(mu) -> add(g_d1) -> clamp -> multiply(x)
//     ],
//     feedback_refs={"g" -> "g_d1"},
//     output_ref="y"
//   )
//
// Algorithm:
//   1. Compute error: e = target - |x|
//   2. Update gain: g = g_d1 + mu * e
//   3. Clamp gain to valid range: g_clamped = clamp(g, min_gain, max_gain)
//   4. Apply gain: y = x * g_clamped
//
// Target: Convergence time <= 1000 samples, 2 DSP blocks
void kernel(ap_int<16> x_in, ap_int<16>& y_out) {
    #pragma HLS INTERFACE s_axilite port=x_in bundle=control
    #pragma HLS INTERFACE s_axilite port=y_out bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // AGC Parameters
    const int TARGET_MAGNITUDE = 1000;     // Target signal magnitude
    const ap_fixed<16, 2> MU = 0.01;       // Step size (mu) in fixed point
    const ap_fixed<16, 4> MAX_GAIN = 8.0;  // Maximum gain to prevent overflow
    const ap_fixed<16, 4> MIN_GAIN = 0.125; // Minimum gain
    
    // Type definitions
    typedef ap_int<16> data_t;
    typedef ap_int<17> abs_t;              // 17 bits for abs(-32768)
    typedef ap_fixed<16, 14> error_t;      // Error signal (target - abs(x))
    typedef ap_fixed<32, 8> gain_acc_t;    // Gain accumulator for update
    typedef ap_fixed<16, 4> gain_t;        // Clamped gain
    typedef ap_fixed<32, 20> prod_t;       // Product of x * gain
    
    // Feedback: Static gain state (g_d1 from previous cycle)
    // This implements the Cycle feedback pattern: g -> g_d1
    static gain_t gain_state = 1.0;
    #pragma HLS RESET variable=gain_state
    
    // Step 1: abs - Compute absolute value of input
    abs_t abs_val;
    if (x_in < 0) {
        abs_val = -x_in;
    } else {
        abs_val = x_in;
    }
    
    // Step 2: subtract_from(target) - Compute error
    // error = target - |x|
    error_t error = TARGET_MAGNITUDE - abs_val;
    
    // Step 3: multiply(mu) - Scale error by step size
    // delta = mu * error
    gain_acc_t delta = MU * error;
    
    // Step 4: add(g_d1) - Update gain with feedback
    // g = g_d1 + delta
    gain_acc_t gain_new = gain_state + delta;
    
    // Step 5: clamp - Clamp gain to valid range
    gain_t gain_clamped;
    if (gain_new > MAX_GAIN) {
        gain_clamped = MAX_GAIN;
    } else if (gain_new < MIN_GAIN) {
        gain_clamped = MIN_GAIN;
    } else {
        gain_clamped = gain_new;
    }
    
    // Step 6: multiply(x) - Apply gain to input
    // y = x * g_clamped
    prod_t prod = x_in * gain_clamped;
    
    // Saturate to output width (16-bit)
    data_t result;
    data_t max_val = 32767;   // (1 << 15) - 1
    data_t min_val = -32768;  // -(1 << 15)
    
    if (prod > max_val) {
        result = max_val;
    } else if (prod < min_val) {
        result = min_val;
    } else {
        result = (data_t)prod;
    }
    
    // Update feedback state for next iteration
    // This creates the Cycle: g -> g_d1
    gain_state = gain_clamped;
    
    y_out = result;
}
