set SynModuleInfo {
  {SRCNAME Loop_VITIS_LOOP_22_1_proc MODELNAME Loop_VITIS_LOOP_22_1_proc RTLNAME conv_encode_Loop_VITIS_LOOP_22_1_proc
    SUBMODULES {
      {MODELNAME conv_encode_flow_control_loop_pipe RTLNAME conv_encode_flow_control_loop_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME conv_encode_flow_control_loop_pipe_U}
    }
  }
  {SRCNAME conv_encode MODELNAME conv_encode RTLNAME conv_encode IS_TOP 1
    SUBMODULES {
      {MODELNAME conv_encode_control_s_axi RTLNAME conv_encode_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}
