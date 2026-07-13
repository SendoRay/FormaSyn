// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vcomplex_mult__Syms.h"


void Vcomplex_mult___024root__trace_chg_0_sub_0(Vcomplex_mult___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vcomplex_mult___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_chg_0\n"); );
    // Body
    Vcomplex_mult___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcomplex_mult___024root*>(voidSelf);
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vcomplex_mult___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vcomplex_mult___024root__trace_chg_0_sub_0(Vcomplex_mult___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_chg_0_sub_0\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgIData(oldp+0,(vlSelfRef.complex_mult__DOT__sum_ab),17);
        bufp->chgIData(oldp+1,(vlSelfRef.complex_mult__DOT__diff_dc),17);
        bufp->chgIData(oldp+2,(vlSelfRef.complex_mult__DOT__sum_cd),17);
        bufp->chgSData(oldp+3,(vlSelfRef.complex_mult__DOT__c_r1),16);
        bufp->chgSData(oldp+4,(vlSelfRef.complex_mult__DOT__a_r1),16);
        bufp->chgSData(oldp+5,(vlSelfRef.complex_mult__DOT__b_r1),16);
        bufp->chgBit(oldp+6,(vlSelfRef.complex_mult__DOT__valid_s1));
        bufp->chgQData(oldp+7,(vlSelfRef.complex_mult__DOT__k1_full),33);
        bufp->chgQData(oldp+9,((0x00000001ffffffffULL 
                                & VL_MULS_QQQ(33, (0x00000001ffffffffULL 
                                                   & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__a_r1))), 
                                              (0x00000001ffffffffULL 
                                               & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__diff_dc))))),33);
        bufp->chgQData(oldp+11,((0x00000001ffffffffULL 
                                 & VL_MULS_QQQ(33, 
                                               (0x00000001ffffffffULL 
                                                & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__b_r1))), 
                                               (0x00000001ffffffffULL 
                                                & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__sum_cd))))),33);
        bufp->chgIData(oldp+13,((IData)(vlSelfRef.complex_mult__DOT__k1_full)),32);
        bufp->chgIData(oldp+14,((IData)((0x00000001ffffffffULL 
                                         & VL_MULS_QQQ(33, 
                                                       (0x00000001ffffffffULL 
                                                        & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__a_r1))), 
                                                       (0x00000001ffffffffULL 
                                                        & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__diff_dc)))))),32);
        bufp->chgIData(oldp+15,((IData)((0x00000001ffffffffULL 
                                         & VL_MULS_QQQ(33, 
                                                       (0x00000001ffffffffULL 
                                                        & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__b_r1))), 
                                                       (0x00000001ffffffffULL 
                                                        & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__sum_cd)))))),32);
    }
    bufp->chgBit(oldp+16,(vlSelfRef.clk));
    bufp->chgBit(oldp+17,(vlSelfRef.rst_n));
    bufp->chgBit(oldp+18,(vlSelfRef.valid_in));
    bufp->chgSData(oldp+19,(vlSelfRef.a),16);
    bufp->chgSData(oldp+20,(vlSelfRef.b),16);
    bufp->chgSData(oldp+21,(vlSelfRef.c),16);
    bufp->chgSData(oldp+22,(vlSelfRef.d),16);
    bufp->chgBit(oldp+23,(vlSelfRef.valid_out));
    bufp->chgIData(oldp+24,(vlSelfRef.re_out),32);
    bufp->chgIData(oldp+25,(vlSelfRef.im_out),32);
}

void Vcomplex_mult___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_cleanup\n"); );
    // Body
    Vcomplex_mult___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcomplex_mult___024root*>(voidSelf);
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
