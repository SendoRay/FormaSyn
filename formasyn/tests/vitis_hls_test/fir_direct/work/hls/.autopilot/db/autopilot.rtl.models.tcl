set SynModuleInfo {
  {SRCNAME kernel MODELNAME kernel RTLNAME kernel IS_TOP 1
    SUBMODULES {
      {MODELNAME kernel_mul_16s_8ns_24_1_1 RTLNAME kernel_mul_16s_8ns_24_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME kernel_mac_muladd_16s_6ns_22s_23_4_1 RTLNAME kernel_mac_muladd_16s_6ns_22s_23_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_mac_muladd_16s_7ns_24s_24_4_1 RTLNAME kernel_mac_muladd_16s_7ns_24s_24_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_mac_muladd_16s_7ns_22s_23_4_1 RTLNAME kernel_mac_muladd_16s_7ns_22s_23_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_mac_muladd_16s_7ns_21s_23_4_1 RTLNAME kernel_mac_muladd_16s_7ns_21s_23_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_mac_muladd_16s_6ns_20s_22_4_1 RTLNAME kernel_mac_muladd_16s_6ns_20s_22_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_control_s_axi RTLNAME kernel_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
