#ifndef KERNEL_H
#define KERNEL_H

#include <ap_int.h>

// LS Channel Estimator
// 
// FormulaGraph equivalent:
//   Map(input_refs=["rx_pilot", "pilot"], func="ls_estimate", output_ref="H")
//
// Algorithm: H = rx_pilot * conj(pilot) / |pilot|^2
//   h_real = (rx_real * p_real + rx_imag * p_imag) / (p_real^2 + p_imag^2)
//   h_imag = (rx_imag * p_real - rx_real * p_imag) / (p_real^2 + p_imag^2)
//
// Parameters:
//   rx_real: received pilot real (ap_int<16>)
//   rx_imag: received pilot imag (ap_int<16>)
//   p_real: transmitted pilot real (ap_int<16>)
//   p_imag: transmitted pilot imag (ap_int<16>)
//   h_real: channel estimate real (ap_int<16>)
//   h_imag: channel estimate imag (ap_int<16>)
void kernel(ap_int<16> rx_real, ap_int<16> rx_imag,
            ap_int<16> p_real, ap_int<16> p_imag,
            ap_int<16>& h_real, ap_int<16>& h_imag);

#endif // KERNEL_H
