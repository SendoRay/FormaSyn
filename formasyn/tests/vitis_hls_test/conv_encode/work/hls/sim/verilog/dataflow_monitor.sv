
`include "dump_file_agent.svh"
`include "csv_file_dump.svh"
`include "sample_agent.svh"
`include "loop_sample_agent.svh"
`include "sample_manager.svh"
`include "nodf_module_interface.svh"
`include "nodf_module_monitor.svh"
`include "df_process_interface.svh"
`include "df_process_monitor.svh"
`include "upc_loop_interface.svh"
`include "upc_loop_monitor.svh"
`timescale 1ns/1ps

// top module for dataflow related monitors
module dataflow_monitor(
input logic clock,
input logic reset,
input logic finish
);


logic region_0_idle;
logic [31:0] region_0_start_cnt;
logic [31:0] region_0_done_cnt;
assign region_0_idle = (region_0_start_cnt == region_0_done_cnt) && AESL_inst_conv_encode.ap_start == 1'b0 ;
always @(posedge clock) begin
    if (reset == 1'b1)
        region_0_start_cnt <= 32'h0;
    else if (AESL_inst_conv_encode.ap_start == 1'b1 && AESL_inst_conv_encode.ap_ready == 1'b1)
        region_0_start_cnt <= region_0_start_cnt + 32'h1;
    else;
end
always @(posedge clock) begin
    if (reset == 1'b1)
        region_0_done_cnt <= 32'h0;
    else if (AESL_inst_conv_encode.ap_done == 1'b1 && AESL_inst_conv_encode.ap_continue == 1'b1)
        region_0_done_cnt <= region_0_done_cnt + 32'h1;
    else;
end


    df_process_intf process_intf_1(clock,reset);
    assign process_intf_1.ap_start = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_start;
    assign process_intf_1.ap_ready = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_ready;
    assign process_intf_1.ap_done = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_done;
    assign process_intf_1.ap_continue = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_continue;
    assign process_intf_1.real_start = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_start;
    assign process_intf_1.pin_stall = 1'b0;
    assign process_intf_1.pout_stall = 1'b0;
    assign process_intf_1.cin_stall = 1'b0;
    assign process_intf_1.cout_stall = 1'b0;
    assign process_intf_1.region_idle = region_0_idle;
    assign process_intf_1.finish = finish;
    csv_file_dump pstall_csv_dumper_1;
    csv_file_dump pstatus_csv_dumper_1;
    df_process_monitor process_monitor_1;

    nodf_module_intf module_intf_1(clock,reset);
    assign module_intf_1.ap_start = AESL_inst_conv_encode.ap_start;
    assign module_intf_1.ap_ready = AESL_inst_conv_encode.ap_ready;
    assign module_intf_1.ap_done = AESL_inst_conv_encode.ap_done;
    assign module_intf_1.ap_continue = AESL_inst_conv_encode.ap_continue;
    assign module_intf_1.finish = finish;
    csv_file_dump mstatus_csv_dumper_1;
    nodf_module_monitor module_monitor_1;

    upc_loop_intf#(1) upc_loop_intf_1(clock,reset);
    assign upc_loop_intf_1.cur_state = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_CS_fsm;
    assign upc_loop_intf_1.iter_start_state = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_ST_fsm_pp0_stage0;
    assign upc_loop_intf_1.iter_end_state = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_ST_fsm_pp0_stage0;
    assign upc_loop_intf_1.quit_state = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_ST_fsm_pp0_stage0;
    assign upc_loop_intf_1.iter_start_block = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_block_pp0_stage0_subdone;
    assign upc_loop_intf_1.iter_end_block = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_block_pp0_stage0_subdone;
    assign upc_loop_intf_1.quit_block = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_block_pp0_stage0_subdone;
    assign upc_loop_intf_1.iter_start_enable = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_enable_reg_pp0_iter0;
    assign upc_loop_intf_1.iter_end_enable = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_enable_reg_pp0_iter2;
    assign upc_loop_intf_1.quit_enable = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_enable_reg_pp0_iter2;
    assign upc_loop_intf_1.loop_start = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_start;
    assign upc_loop_intf_1.loop_ready = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_ready;
    assign upc_loop_intf_1.loop_done = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_done;
    assign upc_loop_intf_1.loop_continue = AESL_inst_conv_encode.Loop_VITIS_LOOP_22_1_proc_U0.ap_continue;
    assign upc_loop_intf_1.quit_at_end = 1'b1;
    assign upc_loop_intf_1.finish = finish;
    csv_file_dump upc_loop_csv_dumper_1;
    upc_loop_monitor #(1) upc_loop_monitor_1;

    sample_manager sample_manager_inst;

initial begin
    sample_manager_inst = new;


    pstall_csv_dumper_1 = new("./stalling1.csv");
    pstatus_csv_dumper_1 = new("./status1.csv");
    process_monitor_1 = new(pstall_csv_dumper_1,process_intf_1,pstatus_csv_dumper_1);

    mstatus_csv_dumper_1 = new("./module_status1.csv");
    module_monitor_1 = new(module_intf_1,mstatus_csv_dumper_1);




    upc_loop_csv_dumper_1 = new("./upc_loop_status1.csv");
    upc_loop_monitor_1 = new(upc_loop_intf_1,upc_loop_csv_dumper_1);

    sample_manager_inst.add_one_monitor(process_monitor_1);
    sample_manager_inst.add_one_monitor(module_monitor_1);
    sample_manager_inst.add_one_monitor(upc_loop_monitor_1);
    
    fork
        sample_manager_inst.start_monitor();
        last_transaction_done;
    join
    disable fork;

    sample_manager_inst.start_dump();
end

    task last_transaction_done();
        wait(reset == 0);
        while(1) begin
            if (finish == 1'b1) begin
                @(negedge clock);
                break;
            end
            else
                @(posedge clock);
        end
    endtask


endmodule
