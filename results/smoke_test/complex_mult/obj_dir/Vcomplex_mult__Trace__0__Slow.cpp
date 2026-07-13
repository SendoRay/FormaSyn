// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vcomplex_mult__Syms.h"


VL_ATTR_COLD void Vcomplex_mult___024root__trace_init_sub__TOP__0(Vcomplex_mult___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_init_sub__TOP__0\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const int c = vlSymsp->__Vm_baseCode;
    VL_TRACE_PUSH_PREFIX(tracep, "$rootio", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BIT(tracep,c+16,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+17,0,"rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+18,0,"valid_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+19,0,"a",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+20,0,"b",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+21,0,"c",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+22,0,"d",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BIT(tracep,c+23,0,"valid_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+24,0,"re_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+25,0,"im_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
    VL_TRACE_PUSH_PREFIX(tracep, "complex_mult", VerilatedTracePrefixType::SCOPE_MODULE, 0, 0);
    VL_TRACE_DECL_BUS(tracep,c+26,0,"WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BIT(tracep,c+16,0,"clk",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+17,0,"rst_n",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BIT(tracep,c+18,0,"valid_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+19,0,"a",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+20,0,"b",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+21,0,"c",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+22,0,"d",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BIT(tracep,c+23,0,"valid_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_BUS(tracep,c+24,0,"re_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+25,0,"im_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+0,0,"sum_ab",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 16,0);
    VL_TRACE_DECL_BUS(tracep,c+1,0,"diff_dc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 16,0);
    VL_TRACE_DECL_BUS(tracep,c+2,0,"sum_cd",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 16,0);
    VL_TRACE_DECL_BUS(tracep,c+3,0,"c_r1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+4,0,"a_r1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BUS(tracep,c+5,0,"b_r1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, 15,0);
    VL_TRACE_DECL_BIT(tracep,c+6,0,"valid_s1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC);
    VL_TRACE_DECL_QUAD(tracep,c+7,0,"k1_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 32,0);
    VL_TRACE_DECL_QUAD(tracep,c+9,0,"k2_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 32,0);
    VL_TRACE_DECL_QUAD(tracep,c+11,0,"k3_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 32,0);
    VL_TRACE_DECL_BUS(tracep,c+13,0,"k1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+14,0,"k2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_DECL_BUS(tracep,c+15,0,"k3",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, 31,0);
    VL_TRACE_POP_PREFIX(tracep);
}

VL_ATTR_COLD void Vcomplex_mult___024root__trace_init_top(Vcomplex_mult___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_init_top\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vcomplex_mult___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vcomplex_mult___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vcomplex_mult___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vcomplex_mult___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vcomplex_mult___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vcomplex_mult___024root__trace_register(Vcomplex_mult___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_register\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vcomplex_mult___024root__trace_const_0, 0, vlSelf);
    tracep->addFullCb(&Vcomplex_mult___024root__trace_full_0, 0, vlSelf);
    tracep->addChgCb(&Vcomplex_mult___024root__trace_chg_0, 0, vlSelf);
    tracep->addCleanupCb(&Vcomplex_mult___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vcomplex_mult___024root__trace_const_0_sub_0(Vcomplex_mult___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vcomplex_mult___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_const_0\n"); );
    // Body
    Vcomplex_mult___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcomplex_mult___024root*>(voidSelf);
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vcomplex_mult___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vcomplex_mult___024root__trace_const_0_sub_0(Vcomplex_mult___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_const_0_sub_0\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+26,(0x00000010U),32);
}

VL_ATTR_COLD void Vcomplex_mult___024root__trace_full_0_sub_0(Vcomplex_mult___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vcomplex_mult___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_full_0\n"); );
    // Body
    Vcomplex_mult___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcomplex_mult___024root*>(voidSelf);
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    Vcomplex_mult___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vcomplex_mult___024root__trace_full_0_sub_0(Vcomplex_mult___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcomplex_mult___024root__trace_full_0_sub_0\n"); );
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    bufp->fullIData(oldp+0,(vlSelfRef.complex_mult__DOT__sum_ab),17);
    bufp->fullIData(oldp+1,(vlSelfRef.complex_mult__DOT__diff_dc),17);
    bufp->fullIData(oldp+2,(vlSelfRef.complex_mult__DOT__sum_cd),17);
    bufp->fullSData(oldp+3,(vlSelfRef.complex_mult__DOT__c_r1),16);
    bufp->fullSData(oldp+4,(vlSelfRef.complex_mult__DOT__a_r1),16);
    bufp->fullSData(oldp+5,(vlSelfRef.complex_mult__DOT__b_r1),16);
    bufp->fullBit(oldp+6,(vlSelfRef.complex_mult__DOT__valid_s1));
    bufp->fullQData(oldp+7,(vlSelfRef.complex_mult__DOT__k1_full),33);
    bufp->fullQData(oldp+9,((0x00000001ffffffffULL 
                             & VL_MULS_QQQ(33, (0x00000001ffffffffULL 
                                                & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__a_r1))), 
                                           (0x00000001ffffffffULL 
                                            & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__diff_dc))))),33);
    bufp->fullQData(oldp+11,((0x00000001ffffffffULL 
                              & VL_MULS_QQQ(33, (0x00000001ffffffffULL 
                                                 & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__b_r1))), 
                                            (0x00000001ffffffffULL 
                                             & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__sum_cd))))),33);
    bufp->fullIData(oldp+13,((IData)(vlSelfRef.complex_mult__DOT__k1_full)),32);
    bufp->fullIData(oldp+14,((IData)((0x00000001ffffffffULL 
                                      & VL_MULS_QQQ(33, 
                                                    (0x00000001ffffffffULL 
                                                     & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__a_r1))), 
                                                    (0x00000001ffffffffULL 
                                                     & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__diff_dc)))))),32);
    bufp->fullIData(oldp+15,((IData)((0x00000001ffffffffULL 
                                      & VL_MULS_QQQ(33, 
                                                    (0x00000001ffffffffULL 
                                                     & VL_EXTENDS_QI(33,16, (IData)(vlSelfRef.complex_mult__DOT__b_r1))), 
                                                    (0x00000001ffffffffULL 
                                                     & VL_EXTENDS_QI(33,17, vlSelfRef.complex_mult__DOT__sum_cd)))))),32);
    bufp->fullBit(oldp+16,(vlSelfRef.clk));
    bufp->fullBit(oldp+17,(vlSelfRef.rst_n));
    bufp->fullBit(oldp+18,(vlSelfRef.valid_in));
    bufp->fullSData(oldp+19,(vlSelfRef.a),16);
    bufp->fullSData(oldp+20,(vlSelfRef.b),16);
    bufp->fullSData(oldp+21,(vlSelfRef.c),16);
    bufp->fullSData(oldp+22,(vlSelfRef.d),16);
    bufp->fullBit(oldp+23,(vlSelfRef.valid_out));
    bufp->fullIData(oldp+24,(vlSelfRef.re_out),32);
    bufp->fullIData(oldp+25,(vlSelfRef.im_out),32);
}
