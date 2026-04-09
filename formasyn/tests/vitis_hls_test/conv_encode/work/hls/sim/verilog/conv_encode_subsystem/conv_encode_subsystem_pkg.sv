//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`timescale 1ns/1ps 

`ifndef CONV_ENCODE_SUBSYSTEM_PKG__SV          
    `define CONV_ENCODE_SUBSYSTEM_PKG__SV      
                                                     
    package conv_encode_subsystem_pkg;               
                                                     
        import uvm_pkg::*;                           
        import file_agent_pkg::*;                    
        import svr_pkg::*;
        import axi_pkg::*;
                                                     
        `include "uvm_macros.svh"                  
                                                     
        `include "conv_encode_config.sv"           
        `include "conv_encode_reference_model.sv"  
        `include "conv_encode_scoreboard.sv"       
        `include "conv_encode_subsystem_monitor.sv"
        `include "conv_encode_virtual_sequencer.sv"
        `include "conv_encode_pkg_sequence_lib.sv" 
        `include "conv_encode_env.sv"              
                                                     
    endpackage                                       
                                                     
`endif                                               
