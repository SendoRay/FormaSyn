//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`timescale 1ns/1ps 

`ifndef KERNEL_SUBSYSTEM_PKG__SV          
    `define KERNEL_SUBSYSTEM_PKG__SV      
                                                     
    package kernel_subsystem_pkg;               
                                                     
        import uvm_pkg::*;                           
        import file_agent_pkg::*;                    
        import axi_pkg::*;
                                                     
        `include "uvm_macros.svh"                  
                                                     
        `include "kernel_config.sv"           
        `include "kernel_reference_model.sv"  
        `include "kernel_scoreboard.sv"       
        `include "kernel_subsystem_monitor.sv"
        `include "kernel_virtual_sequencer.sv"
        `include "kernel_pkg_sequence_lib.sv" 
        `include "kernel_env.sv"              
                                                     
    endpackage                                       
                                                     
`endif                                               
