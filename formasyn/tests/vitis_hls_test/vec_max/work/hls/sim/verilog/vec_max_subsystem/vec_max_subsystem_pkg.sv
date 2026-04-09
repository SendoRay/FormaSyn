//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`timescale 1ns/1ps 

`ifndef VEC_MAX_SUBSYSTEM_PKG__SV          
    `define VEC_MAX_SUBSYSTEM_PKG__SV      
                                                     
    package vec_max_subsystem_pkg;               
                                                     
        import uvm_pkg::*;                           
        import file_agent_pkg::*;                    
        import axi_pkg::*;
                                                     
        `include "uvm_macros.svh"                  
                                                     
        `include "vec_max_config.sv"           
        `include "vec_max_reference_model.sv"  
        `include "vec_max_scoreboard.sv"       
        `include "vec_max_subsystem_monitor.sv"
        `include "vec_max_virtual_sequencer.sv"
        `include "vec_max_pkg_sequence_lib.sv" 
        `include "vec_max_env.sv"              
                                                     
    endpackage                                       
                                                     
`endif                                               
