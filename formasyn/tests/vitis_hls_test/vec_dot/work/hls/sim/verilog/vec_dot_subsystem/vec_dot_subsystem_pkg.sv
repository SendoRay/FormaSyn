//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`timescale 1ns/1ps 

`ifndef VEC_DOT_SUBSYSTEM_PKG__SV          
    `define VEC_DOT_SUBSYSTEM_PKG__SV      
                                                     
    package vec_dot_subsystem_pkg;               
                                                     
        import uvm_pkg::*;                           
        import file_agent_pkg::*;                    
        import axi_pkg::*;
                                                     
        `include "uvm_macros.svh"                  
                                                     
        `include "vec_dot_config.sv"           
        `include "vec_dot_reference_model.sv"  
        `include "vec_dot_scoreboard.sv"       
        `include "vec_dot_subsystem_monitor.sv"
        `include "vec_dot_virtual_sequencer.sv"
        `include "vec_dot_pkg_sequence_lib.sv" 
        `include "vec_dot_env.sv"              
                                                     
    endpackage                                       
                                                     
`endif                                               
