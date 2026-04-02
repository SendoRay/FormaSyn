set SynModuleInfo {
  {SRCNAME kernel MODELNAME kernel RTLNAME kernel IS_TOP 1
    SUBMODULES {
      {MODELNAME kernel_gmem0_m_axi RTLNAME kernel_gmem0_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME kernel_gmem1_m_axi RTLNAME kernel_gmem1_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME kernel_gmem2_m_axi RTLNAME kernel_gmem2_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME kernel_control_s_axi RTLNAME kernel_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
