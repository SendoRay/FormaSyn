set SynModuleInfo {
  {SRCNAME kernel MODELNAME kernel RTLNAME kernel IS_TOP 1
    SUBMODULES {
      {MODELNAME kernel_mac_muladd_16s_16s_14ns_32_4_1 RTLNAME kernel_mac_muladd_16s_16s_14ns_32_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME kernel_control_s_axi RTLNAME kernel_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
