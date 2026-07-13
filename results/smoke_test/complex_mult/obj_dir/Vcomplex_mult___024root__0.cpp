// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcomplex_mult.h for the primary calling header

#include "Vcomplex_mult__pch.h"

void Vcomplex_mult___024root___eval_triggers_vec__act(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_triggers_vec__act\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    ((((~ (IData)(vlSelfRef.rst_n)) 
                                                       & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0)) 
                                                      << 1U) 
                                                     | ((IData)(vlSelfRef.clk) 
                                                        & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0))))));
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0 = vlSelfRef.rst_n;
}

bool Vcomplex_mult___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___trigger_anySet__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

void Vcomplex_mult___024root___nba_sequent__TOP__0(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___nba_sequent__TOP__0\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (vlSelfRef.rst_n) {
        vlSelfRef.complex_mult__DOT__c_r1 = vlSelfRef.c;
        vlSelfRef.complex_mult__DOT__sum_ab = (0x0001ffffU 
                                               & (((0x00010000U 
                                                    & ((IData)(vlSelfRef.a) 
                                                       << 1U)) 
                                                   | (IData)(vlSelfRef.a)) 
                                                  + 
                                                  ((0x00010000U 
                                                    & ((IData)(vlSelfRef.b) 
                                                       << 1U)) 
                                                   | (IData)(vlSelfRef.b))));
        vlSelfRef.re_out = ((IData)(vlSelfRef.complex_mult__DOT__k1_full) 
                            - (IData)((0x00000001ffffffffULL 
                                       & VL_MULS_QQQ(33, 
                                                     (0x00000001ffffffffULL 
                                                      & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__b_r1))), 
                                                     (0x00000001ffffffffULL 
                                                      & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__sum_cd))))));
        vlSelfRef.im_out = ((IData)(vlSelfRef.complex_mult__DOT__k1_full) 
                            + (IData)((0x00000001ffffffffULL 
                                       & VL_MULS_QQQ(33, 
                                                     (0x00000001ffffffffULL 
                                                      & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__a_r1))), 
                                                     (0x00000001ffffffffULL 
                                                      & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__diff_dc))))));
        vlSelfRef.complex_mult__DOT__b_r1 = vlSelfRef.b;
        vlSelfRef.complex_mult__DOT__sum_cd = (0x0001ffffU 
                                               & (((0x00010000U 
                                                    & ((IData)(vlSelfRef.c) 
                                                       << 1U)) 
                                                   | (IData)(vlSelfRef.c)) 
                                                  + 
                                                  ((0x00010000U 
                                                    & ((IData)(vlSelfRef.d) 
                                                       << 1U)) 
                                                   | (IData)(vlSelfRef.d))));
        vlSelfRef.complex_mult__DOT__a_r1 = vlSelfRef.a;
        vlSelfRef.complex_mult__DOT__diff_dc = (0x0001ffffU 
                                                & (((0x00010000U 
                                                     & ((IData)(vlSelfRef.d) 
                                                        << 1U)) 
                                                    | (IData)(vlSelfRef.d)) 
                                                   - 
                                                   ((0x00010000U 
                                                     & ((IData)(vlSelfRef.c) 
                                                        << 1U)) 
                                                    | (IData)(vlSelfRef.c))));
    } else {
        vlSelfRef.complex_mult__DOT__c_r1 = 0U;
        vlSelfRef.complex_mult__DOT__sum_ab = 0U;
        vlSelfRef.re_out = 0U;
        vlSelfRef.im_out = 0U;
        vlSelfRef.complex_mult__DOT__b_r1 = 0U;
        vlSelfRef.complex_mult__DOT__sum_cd = 0U;
        vlSelfRef.complex_mult__DOT__a_r1 = 0U;
        vlSelfRef.complex_mult__DOT__diff_dc = 0U;
    }
    vlSelfRef.valid_out = ((IData)(vlSelfRef.rst_n) 
                           && (IData)(vlSelfRef.complex_mult__DOT__valid_s1));
    vlSelfRef.complex_mult__DOT__k1_full = (0x00000001ffffffffULL 
                                            & VL_MULS_QQQ(33, 
                                                          (0x00000001ffffffffULL 
                                                           & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__c_r1))), 
                                                          (0x00000001ffffffffULL 
                                                           & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__sum_ab))));
    vlSelfRef.complex_mult__DOT__valid_s1 = ((IData)(vlSelfRef.rst_n) 
                                             && (IData)(vlSelfRef.valid_in));
}

void Vcomplex_mult___024root___eval_nba(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_nba\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vcomplex_mult___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
    }
}

void Vcomplex_mult___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcomplex_mult___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vcomplex_mult___024root___eval_phase__act(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_phase__act\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vcomplex_mult___024root___eval_triggers_vec__act(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vcomplex_mult___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vcomplex_mult___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    return (0U);
}

void Vcomplex_mult___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vcomplex_mult___024root___eval_phase__nba(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_phase__nba\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vcomplex_mult___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vcomplex_mult___024root___eval_nba(vlSelf);
        Vcomplex_mult___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vcomplex_mult___024root___eval(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vcomplex_mult___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("complex_mult.v", 9, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 10000 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00002710U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vcomplex_mult___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                VL_FATAL_MT("complex_mult.v", 9, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 10000 tries");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactPhaseResult = Vcomplex_mult___024root___eval_phase__act(vlSelf);
        } while (vlSelfRef.__VactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vcomplex_mult___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vcomplex_mult___024root___eval_debug_assertions(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_debug_assertions\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");
    }
    if (VL_UNLIKELY(((vlSelfRef.rst_n & 0xfeU)))) {
        Verilated::overWidthError("rst_n");
    }
    if (VL_UNLIKELY(((vlSelfRef.valid_in & 0xfeU)))) {
        Verilated::overWidthError("valid_in");
    }
}
#endif  // VL_DEBUG
