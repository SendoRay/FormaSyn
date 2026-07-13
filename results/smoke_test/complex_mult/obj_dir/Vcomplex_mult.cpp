// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vcomplex_mult__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vcomplex_mult::Vcomplex_mult(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vcomplex_mult__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst_n{vlSymsp->TOP.rst_n}
    , valid_in{vlSymsp->TOP.valid_in}
    , valid_out{vlSymsp->TOP.valid_out}
    , a{vlSymsp->TOP.a}
    , b{vlSymsp->TOP.b}
    , c{vlSymsp->TOP.c}
    , d{vlSymsp->TOP.d}
    , re_out{vlSymsp->TOP.re_out}
    , im_out{vlSymsp->TOP.im_out}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vcomplex_mult::Vcomplex_mult(const char* _vcname__)
    : Vcomplex_mult(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vcomplex_mult::~Vcomplex_mult() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vcomplex_mult___024root___eval_debug_assertions(Vcomplex_mult___024root* vlSelf);
#endif  // VL_DEBUG
void Vcomplex_mult___024root___eval_static(Vcomplex_mult___024root* vlSelf);
void Vcomplex_mult___024root___eval_initial(Vcomplex_mult___024root* vlSelf);
void Vcomplex_mult___024root___eval_settle(Vcomplex_mult___024root* vlSelf);
void Vcomplex_mult___024root___eval(Vcomplex_mult___024root* vlSelf);

void Vcomplex_mult::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vcomplex_mult::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vcomplex_mult___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vcomplex_mult___024root___eval_static(&(vlSymsp->TOP));
        Vcomplex_mult___024root___eval_initial(&(vlSymsp->TOP));
        Vcomplex_mult___024root___eval_settle(&(vlSymsp->TOP));
        vlSymsp->__Vm_didInit = true;
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vcomplex_mult___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vcomplex_mult::eventsPending() { return false; }

uint64_t Vcomplex_mult::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vcomplex_mult::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vcomplex_mult___024root___eval_final(Vcomplex_mult___024root* vlSelf);

VL_ATTR_COLD void Vcomplex_mult::final() {
    contextp()->executingFinal(true);
    Vcomplex_mult___024root___eval_final(&(vlSymsp->TOP));
    contextp()->executingFinal(false);
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vcomplex_mult::hierName() const { return vlSymsp->name(); }
const char* Vcomplex_mult::modelName() const { return "Vcomplex_mult"; }
unsigned Vcomplex_mult::threads() const { return 1; }
void Vcomplex_mult::prepareClone() const { contextp()->prepareClone(); }
void Vcomplex_mult::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vcomplex_mult::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false}};
};

//============================================================
// Trace configuration

void Vcomplex_mult___024root__trace_decl_types(VerilatedVcd* tracep);

void Vcomplex_mult___024root__trace_init_top(Vcomplex_mult___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vcomplex_mult___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vcomplex_mult___024root*>(voidSelf);
    Vcomplex_mult__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(vlSymsp->name(), VerilatedTracePrefixType::SCOPE_MODULE);
    Vcomplex_mult___024root__trace_decl_types(tracep);
    Vcomplex_mult___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vcomplex_mult___024root__trace_register(Vcomplex_mult___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vcomplex_mult::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vcomplex_mult::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP), name(), false, 27);
    Vcomplex_mult___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
