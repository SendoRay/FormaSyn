set SynModuleInfo {
  {SRCNAME ofdm_base MODELNAME ofdm_base RTLNAME ofdm_base IS_TOP 1
    SUBMODULES {
      {MODELNAME ofdm_base_mul_16s_14s_29_1_1 RTLNAME ofdm_base_mul_16s_14s_29_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME ofdm_base_mul_16s_14ns_29_1_1 RTLNAME ofdm_base_mul_16s_14ns_29_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME ofdm_base_mul_16s_13ns_29_1_1 RTLNAME ofdm_base_mul_16s_13ns_29_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME ofdm_base_mul_16s_13s_29_1_1 RTLNAME ofdm_base_mul_16s_13s_29_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME ofdm_base_am_submul_16s_16s_13ns_29_4_1 RTLNAME ofdm_base_am_submul_16s_16s_13ns_29_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME ofdm_base_mac_muladd_16s_14s_29s_29_4_1 RTLNAME ofdm_base_mac_muladd_16s_14s_29s_29_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME ofdm_base_am_addmul_16s_16s_13ns_29_4_1 RTLNAME ofdm_base_am_addmul_16s_16s_13ns_29_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME ofdm_base_mac_muladd_16s_13s_29s_29_4_1 RTLNAME ofdm_base_mac_muladd_16s_13s_29s_29_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME ofdm_base_mac_muladd_16s_13ns_29s_29_4_1 RTLNAME ofdm_base_mac_muladd_16s_13ns_29s_29_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME ofdm_base_mac_muladd_16s_12ns_29s_29_4_1 RTLNAME ofdm_base_mac_muladd_16s_12ns_29s_29_4_1 BINDTYPE op TYPE all IMPL dsp_slice LATENCY 3}
      {MODELNAME ofdm_base_control_s_axi RTLNAME ofdm_base_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
