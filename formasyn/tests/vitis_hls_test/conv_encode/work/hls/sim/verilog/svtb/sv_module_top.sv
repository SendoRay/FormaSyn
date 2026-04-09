//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef SV_MODULE_TOP_SV
`define SV_MODULE_TOP_SV


`timescale 1ns/1ps


`include "uvm_macros.svh"
import uvm_pkg::*;
import file_agent_pkg::*;
import svr_pkg::*;
import conv_encode_subsystem_pkg::*;
`include "conv_encode_subsys_test_sequence_lib.sv"
`include "conv_encode_test_lib.sv"


module sv_module_top;


    misc_interface              misc_if ( .clock(apatb_conv_encode_top.AESL_clock), .reset(apatb_conv_encode_top.AESL_reset) );
    assign misc_if.dut2tb_ap_ready = apatb_conv_encode_top.AESL_inst_conv_encode.ap_ready;
    assign misc_if.dut2tb_ap_done_kernel = apatb_conv_encode_top.AESL_inst_conv_encode.ap_done;
    initial begin
        uvm_config_db #(virtual misc_interface)::set(null, "uvm_test_top.top_env.*", "misc_if", misc_if);
    end


    svr_if #(1)  svr_bit_in_stream_if    (.clk  (apatb_conv_encode_top.AESL_clock), .rst(apatb_conv_encode_top.AESL_reset));
    assign svr_bit_in_stream_if.ready = apatb_conv_encode_top.bit_in_stream_read;
    assign apatb_conv_encode_top.bit_in_stream_empty_n = svr_bit_in_stream_if.valid;
    assign apatb_conv_encode_top.bit_in_stream_dout = svr_bit_in_stream_if.data[0:0];
    initial begin
        uvm_config_db #( virtual svr_if#(1) )::set(null, "uvm_test_top.top_env.env_master_svr_bit_in_stream.*", "vif", svr_bit_in_stream_if);
    end


    svr_if #(2)  svr_y_out_stream_if    (.clk  (apatb_conv_encode_top.AESL_clock), .rst(apatb_conv_encode_top.AESL_reset));
    assign svr_y_out_stream_if.valid = apatb_conv_encode_top.y_out_stream_write;
    assign apatb_conv_encode_top.y_out_stream_full_n = svr_y_out_stream_if.ready;
    assign svr_y_out_stream_if.data[1:0] = apatb_conv_encode_top.y_out_stream_din;
    initial begin
        uvm_config_db #( virtual svr_if#(2) )::set(null, "uvm_test_top.top_env.env_slave_svr_y_out_stream.*", "vif", svr_y_out_stream_if);
    end


    axi_if #(5,4,4,3,1)  axi_control_if (.clk  (apatb_conv_encode_top.AESL_clock), .rst(apatb_conv_encode_top.AESL_reset));
    assign apatb_conv_encode_top.control_AWADDR = axi_control_if.AWADDR;
    assign apatb_conv_encode_top.control_AWVALID = axi_control_if.AWVALID;
    assign axi_control_if.AWREADY = apatb_conv_encode_top.control_AWREADY;
    assign apatb_conv_encode_top.control_WVALID = axi_control_if.WVALID;
    assign axi_control_if.WREADY = apatb_conv_encode_top.control_WREADY;
    assign apatb_conv_encode_top.control_WDATA = axi_control_if.WDATA;
    assign apatb_conv_encode_top.control_WSTRB = axi_control_if.WSTRB;
    assign apatb_conv_encode_top.control_ARADDR = axi_control_if.ARADDR;
    assign apatb_conv_encode_top.control_ARVALID = axi_control_if.ARVALID;
    assign axi_control_if.ARREADY = apatb_conv_encode_top.control_ARREADY;
    assign axi_control_if.RVALID = apatb_conv_encode_top.control_RVALID;
    assign apatb_conv_encode_top.control_RREADY = axi_control_if.RREADY;
    assign axi_control_if.RDATA = apatb_conv_encode_top.control_RDATA;
    assign axi_control_if.RRESP = apatb_conv_encode_top.control_RRESP;
    assign axi_control_if.BVALID = apatb_conv_encode_top.control_BVALID;
    assign apatb_conv_encode_top.control_BREADY = axi_control_if.BREADY;
    assign axi_control_if.BRESP = apatb_conv_encode_top.control_BRESP;
    assign axi_control_if.BID = 0;
    assign axi_control_if.RID = 0;
    assign axi_control_if.RLAST = 1;
    initial begin
        uvm_config_db #( virtual axi_if#(5,4,4,3,1) )::set(null, "uvm_test_top.top_env.axi_lite_control.*", "vif", axi_control_if);
    end


    initial begin
        run_test();
    end
endmodule
`endif
