set SynModuleInfo {
  {SRCNAME kernel MODELNAME kernel RTLNAME kernel IS_TOP 1
    SUBMODULES {
      {MODELNAME kernel_am_addmul_16s_16s_8ns_25_4_1 RTLNAME kernel_am_addmul_16s_16s_8ns_25_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_ama_addmuladd_16s_16s_6s_25s_25_4_1 RTLNAME kernel_ama_addmuladd_16s_16s_6s_25s_25_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_control_s_axi RTLNAME kernel_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
