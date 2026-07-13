// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcomplex_mult.h for the primary calling header

#include "Vcomplex_mult__pch.h"

void Vcomplex_mult___024root___ctor_var_reset(Vcomplex_mult___024root* vlSelf);

Vcomplex_mult___024root::Vcomplex_mult___024root(Vcomplex_mult__Syms* symsp, const char* namep)
 {
    vlSymsp = symsp;
    vlNamep = strdup(namep);
    // Reset structure values
    Vcomplex_mult___024root___ctor_var_reset(this);
}

void Vcomplex_mult___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vcomplex_mult___024root::~Vcomplex_mult___024root() {
    VL_DO_DANGLING(std::free(const_cast<char*>(vlNamep)), vlNamep);
}
