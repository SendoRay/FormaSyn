// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vcomplex_mult.h for the primary calling header

#ifndef VERILATED_VCOMPLEX_MULT___024ROOT_H_
#define VERILATED_VCOMPLEX_MULT___024ROOT_H_  // guard

#include "verilated.h"


class Vcomplex_mult__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vcomplex_mult___024root final {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst_n,0,0);
    VL_IN8(valid_in,0,0);
    VL_OUT8(valid_out,0,0);
    CData/*0:0*/ complex_mult__DOT__valid_s1;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VstlPhaseResult;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
    CData/*0:0*/ __VactPhaseResult;
    CData/*0:0*/ __VnbaPhaseResult;
    VL_IN16(a,15,0);
    VL_IN16(b,15,0);
    VL_IN16(c,15,0);
    VL_IN16(d,15,0);
    SData/*15:0*/ complex_mult__DOT__c_r1;
    SData/*15:0*/ complex_mult__DOT__a_r1;
    SData/*15:0*/ complex_mult__DOT__b_r1;
    VL_OUT(re_out,31,0);
    VL_OUT(im_out,31,0);
    IData/*16:0*/ complex_mult__DOT__sum_ab;
    IData/*16:0*/ complex_mult__DOT__diff_dc;
    IData/*16:0*/ complex_mult__DOT__sum_cd;
    IData/*31:0*/ __VactIterCount;
    QData/*32:0*/ complex_mult__DOT__k1_full;
    VlUnpacked<QData/*63:0*/, 1> __VstlTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VactTriggered;
    VlUnpacked<QData/*63:0*/, 1> __VnbaTriggered;
    VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;

    // INTERNAL VARIABLES
    Vcomplex_mult__Syms* vlSymsp;
    const char* vlNamep;

    // CONSTRUCTORS
    Vcomplex_mult___024root(Vcomplex_mult__Syms* symsp, const char* namep);
    ~Vcomplex_mult___024root();
    VL_UNCOPYABLE(Vcomplex_mult___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
