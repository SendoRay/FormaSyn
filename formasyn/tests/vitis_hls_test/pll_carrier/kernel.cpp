#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_math.h>

// PLL Carrier Recovery - FormulaGraph Implementation
//
// FormulaGraph equivalent:
//   Cycle with feedback (theta_d1, is_d1)
//   Body: phase_rotate -> phase_error -> multiply(kp) -> multiply(ki) -> add -> add -> wrap_phase
//
// Structure:
//   1. NCO: Generate sin/cos from current phase estimate
//   2. phase_rotate: Complex multiply input with NCO output (derotate)
//   3. phase_error: Decision-directed phase error estimation
//   4. Loop Filter: PI controller (kp*error + ki*accumulated_error)
//   5. wrap_phase: Phase accumulator with wrapping to [-pi, pi]

void kernel(ap_int<16> x_real, ap_int<16> x_imag, 
            ap_int<16>& y_real, ap_int<16>& y_imag) {
    #pragma HLS INTERFACE s_axilite port=x_real bundle=control
    #pragma HLS INTERFACE s_axilite port=x_imag bundle=control
    #pragma HLS INTERFACE s_axilite port=y_real bundle=control
    #pragma HLS INTERFACE s_axilite port=y_imag bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control
    #pragma HLS PIPELINE II=1
    
    // Type definitions
    // ap_fixed<16,4> gives range [-8, 8) which covers 2*pi with ~0.0002 resolution
    typedef ap_fixed<16,4> phase_t;       // Phase in radians
    typedef ap_fixed<16,4> error_t;       // Phase error
    typedef ap_fixed<32,8> acc_phase_t;   // Accumulator with more integer bits
    typedef ap_fixed<32,12> integrator_t; // Integrator for loop filter
    typedef ap_fixed<16,2> gain_t;        // Gain coefficients
    typedef ap_int<16> data_t;            // Input/output data
    typedef ap_fixed<32,8> mult_t;        // Multiplication result
    typedef ap_fixed<18,2> nco_t;         // NCO output (sin/cos in [-1, 1])
    
    // Constants
    const gain_t KP = 0.1;    // Proportional gain
    const gain_t KI = 0.01;   // Integral gain
    const phase_t PI_VAL = 3.14159265358979;
    const phase_t TWO_PI = 6.28318530717959;
    const phase_t HALF_PI = 1.57079632679490;
    
    // Feedback state (static - preserved across calls)
    static phase_t theta_d1 = 0;      // Previous phase estimate
    static integrator_t is_d1 = 0;    // Integrator state
    #pragma HLS RESET variable=theta_d1
    #pragma HLS RESET variable=is_d1
    
    // Convert input to ap_fixed for computation
    mult_t x_r = x_real;
    mult_t x_i = x_imag;
    
    // ========== NCO: Generate sin/cos from phase estimate ==========
    // Use Taylor series approximation for sin/cos (CORDIC-style)
    // sin(theta) and cos(theta) computation
    phase_t theta = theta_d1;
    
    // Normalize theta to [-pi, pi] range for better approximation
    phase_t theta_norm = theta;
    if (theta_norm > PI_VAL) {
        theta_norm -= TWO_PI;
    } else if (theta_norm < -PI_VAL) {
        theta_norm += TWO_PI;
    }
    
    // Small-angle approximation for sin/cos (more stable than Taylor)
    // For small x: sin(x) ≈ x, cos(x) ≈ 1 - x^2/2
    // Limit to valid range
    nco_t sin_theta, cos_theta;
    
    if (theta_norm > nco_t(1.0)) {
        sin_theta = 0.84;  // sin(1.0) ≈ 0.84
        cos_theta = 0.54;  // cos(1.0) ≈ 0.54
    } else if (theta_norm < nco_t(-1.0)) {
        sin_theta = -0.84;
        cos_theta = 0.54;
    } else {
        // Small angle approximation
        sin_theta = theta_norm;
        cos_theta = nco_t(1.0) - theta_norm * theta_norm / nco_t(2.0);
    }
    
    // Clamp to [-1, 1]
    if (sin_theta > 0.99) sin_theta = 0.99;
    else if (sin_theta < -0.99) sin_theta = -0.99;
    if (cos_theta > 0.99) cos_theta = 0.99;
    else if (cos_theta < -0.99) cos_theta = -0.99;
    
    // ========== phase_rotate: Complex multiply (derotate) ==========
    // y = x * exp(-j*theta) = x * (cos - j*sin)
    // y_real = x_real * cos + x_imag * sin
    // y_imag = x_imag * cos - x_real * sin
    mult_t y_r = x_r * cos_theta + x_i * sin_theta;
    mult_t y_i = x_i * cos_theta - x_r * sin_theta;
    
    // ========== phase_error: Decision-directed estimation ==========
    // For QPSK/BPSK: error = imag(y) * sign(real(y)) - real(y) * sign(imag(y))
    // Simplified: error = -atan2(y_imag, y_real) for small errors
    // Using linear approximation for small phase errors
    error_t phase_err;
    
    // Decision-directed phase error detector
    // For small phase errors: error ≈ y_imag * sign(y_real) - y_real * sign(y_imag)
    // Simplified to: error ≈ y_imag (assuming y_real > 0, y_imag ≈ 0 at lock)
    if (y_r > 0.001) {
        phase_err = y_i;  // Linear approximation for small errors
    } else if (y_r < -0.001) {
        phase_err = -y_i;
    } else {
        phase_err = 0;
    }
    
    // Scale error to avoid saturation
    phase_err = phase_err >> 4;  // Divide by 16 for normalization
    
    // ========== Loop Filter: PI controller ==========
    // Proportional path: kp * error
    // Integral path: ki * error + previous_integral
    // Output: proportional + integral
    
    // Multiply(kp)
    mult_t prop_out = KP * phase_err;
    
    // Multiply(ki)
    mult_t int_in = KI * phase_err;
    
    // First add: integral accumulation
    integrator_t int_out = is_d1 + int_in;
    
    // Second add: proportional + integral
    mult_t loop_out = prop_out + int_out;
    
    // ========== wrap_phase: Phase accumulator with wrapping ==========
    // Accumulate phase: theta_new = theta_old - loop_out
    // Negative sign because we're correcting the error
    acc_phase_t theta_new = theta_d1 - loop_out;
    
    // Wrap phase to [-pi, pi] range
    phase_t theta_wrapped;
    if (theta_new > PI_VAL) {
        theta_wrapped = theta_new - TWO_PI;
    } else if (theta_new < -PI_VAL) {
        theta_wrapped = theta_new + TWO_PI;
    } else {
        theta_wrapped = theta_new;
    }
    
    // Update state for next cycle
    theta_d1 = theta_wrapped;
    is_d1 = int_out;
    
    // Saturate outputs to 16-bit signed integer range
    data_t y_real_out, y_imag_out;
    
    if (y_r > 32767) y_real_out = 32767;
    else if (y_r < -32768) y_real_out = -32768;
    else y_real_out = (data_t)y_r;
    
    if (y_i > 32767) y_imag_out = 32767;
    else if (y_i < -32768) y_imag_out = -32768;
    else y_imag_out = (data_t)y_i;
    
    y_real = y_real_out;
    y_imag = y_imag_out;
}
