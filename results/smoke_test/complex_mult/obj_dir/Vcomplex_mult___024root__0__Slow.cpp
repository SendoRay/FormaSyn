// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcomplex_mult.h for the primary calling header

#include "Vcomplex_mult__pch.h"

VL_ATTR_COLD void Vcomplex_mult___024root___eval_static(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_static\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0 = vlSelfRef.rst_n;
}

VL_ATTR_COLD void Vcomplex_mult___024root___eval_initial(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_initial\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vcomplex_mult___024root___eval_final(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_final\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcomplex_mult___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vcomplex_mult___024root___eval_phase__stl(Vcomplex_mult___024root* vlSelf);

VL_ATTR_COLD void Vcomplex_mult___024root___eval_settle(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_settle\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00002710U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vcomplex_mult___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("complex_mult.v", 9, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 10000 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vcomplex_mult___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD void Vcomplex_mult___024root___eval_triggers_vec__stl(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_triggers_vec__stl\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
}

VL_ATTR_COLD bool Vcomplex_mult___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcomplex_mult___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vcomplex_mult___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vcomplex_mult___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___trigger_anySet__stl\n"); );
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

VL_ATTR_COLD void Vcomplex_mult___024root___stl_sequent__TOP__0(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___stl_sequent__TOP__0\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.complex_mult__DOT__k1_full = (0x00000001ffffffffULL 
                                            & VL_MULS_QQQ(33, 
                                                          (0x00000001ffffffffULL 
                                                           & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__c_r1))), 
                                                          (0x00000001ffffffffULL 
                                                           & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__sum_ab))));
}

VL_ATTR_COLD void Vcomplex_mult___024root____Vm_traceActivitySetAll(Vcomplex_mult___024root* vlSelf);

VL_ATTR_COLD void Vcomplex_mult___024root___eval_stl(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_stl\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
        Vcomplex_mult___024root___stl_sequent__TOP__0(vlSelf);
        Vcomplex_mult___024root____Vm_traceActivitySetAll(vlSelf);
    }
}

VL_ATTR_COLD bool Vcomplex_mult___024root___eval_phase__stl(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___eval_phase__stl\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    Vcomplex_mult___024root___eval_triggers_vec__stl(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vcomplex_mult___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vcomplex_mult___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        Vcomplex_mult___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

bool Vcomplex_mult___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcomplex_mult___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vcomplex_mult___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge clk)\n");
    }
    if ((1U & (IData)((triggers[0U] >> 1U)))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 1 is active: @(negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcomplex_mult___024root____Vm_traceActivitySetAll(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root____Vm_traceActivitySetAll\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
}

VL_ATTR_COLD void Vcomplex_mult___024root___ctor_var_reset(Vcomplex_mult___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root___ctor_var_reset\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->rst_n = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 1638864771569018232ull);
    vlSelf->valid_in = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16540271516330450727ull);
    vlSelf->a = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 510903276987443985ull);
    vlSelf->b = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 16900879642891266615ull);
    vlSelf->c = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 15598372446745583797ull);
    vlSelf->d = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 1720370409040345145ull);
    vlSelf->valid_out = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8744939437868816662ull);
    vlSelf->re_out = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14600032873377650451ull);
    vlSelf->im_out = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 3397566012444838695ull);
    vlSelf->complex_mult__DOT__sum_ab = VL_SCOPED_RAND_RESET_I(17, __VscopeHash, 13513116627161886180ull);
    vlSelf->complex_mult__DOT__diff_dc = VL_SCOPED_RAND_RESET_I(17, __VscopeHash, 9777565239401616624ull);
    vlSelf->complex_mult__DOT__sum_cd = VL_SCOPED_RAND_RESET_I(17, __VscopeHash, 10825912902286628043ull);
    vlSelf->complex_mult__DOT__c_r1 = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 16941055201971670901ull);
    vlSelf->complex_mult__DOT__a_r1 = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 6994336805888296430ull);
    vlSelf->complex_mult__DOT__b_r1 = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 856567395977875799ull);
    vlSelf->complex_mult__DOT__valid_s1 = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 550028808265523334ull);
    vlSelf->complex_mult__DOT__k1_full = VL_SCOPED_RAND_RESET_Q(33, __VscopeHash, 14070042825970620806ull);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 2; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
