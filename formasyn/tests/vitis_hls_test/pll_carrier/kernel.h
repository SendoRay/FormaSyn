#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>
#include <ap_fixed.h>

// PLL Carrier Recovery - Phase-Locked Loop for Carrier Synchronization
//
// FormulaGraph equivalent:
//   Cycle with feedback (theta_d1, is_d1)
//   Body: phase_rotate -> phase_error -> multiply(kp) -> multiply(ki) -> add -> add -> wrap_phase
//
// This implementation performs carrier recovery using a Costas-loop style PLL
// with PI loop filter for phase tracking.
//
// Parameters:
//   x_real, x_imag: Complex input sample (ap_int<16>)
//   y_real, y_imag: Phase-rotated output sample (ap_int<16>)
//
// Loop parameters:
//   kp = 0.1 (proportional gain)
//   ki = 0.01 (integral gain)
//   Lock time target: <= 1000 symbols
void kernel(ap_int<16> x_real, ap_int<16> x_imag, 
            ap_int<16>& y_real, ap_int<16>& y_imag);

#endif // KERNEL_H
