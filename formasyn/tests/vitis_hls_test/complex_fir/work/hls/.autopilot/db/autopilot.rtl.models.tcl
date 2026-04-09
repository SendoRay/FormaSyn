set SynModuleInfo {
  {SRCNAME kernel MODELNAME kernel RTLNAME kernel IS_TOP 1
    SUBMODULES {
      {MODELNAME kernel_mul_16s_9ns_25_1_1 RTLNAME kernel_mul_16s_9ns_25_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME kernel_mul_16s_11ns_27_1_1 RTLNAME kernel_mul_16s_11ns_27_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME kernel_mac_muladd_16s_7ns_25s_25_4_1 RTLNAME kernel_mac_muladd_16s_7ns_25s_25_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_mac_muladd_16s_9ns_27s_27_4_1 RTLNAME kernel_mac_muladd_16s_9ns_27s_27_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_control_s_axi RTLNAME kernel_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
