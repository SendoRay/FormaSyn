set SynModuleInfo {
  {SRCNAME vec_dot MODELNAME vec_dot RTLNAME vec_dot IS_TOP 1
    SUBMODULES {
      {MODELNAME vec_dot_mul_16s_16s_32_1_1 RTLNAME vec_dot_mul_16s_16s_32_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME vec_dot_mac_muladd_16s_16s_32s_33_4_1 RTLNAME vec_dot_mac_muladd_16s_16s_32s_33_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME vec_dot_control_s_axi RTLNAME vec_dot_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
