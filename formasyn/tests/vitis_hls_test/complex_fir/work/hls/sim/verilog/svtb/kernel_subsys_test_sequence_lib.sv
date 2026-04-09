//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef KERNEL_SUBSYS_TEST_SEQUENCE_LIB__SV                                              
    `define KERNEL_SUBSYS_TEST_SEQUENCE_LIB__SV                                          
                                                                                                    
                                                                                                    
    `include "uvm_macros.svh"                                                                     
                                                                                                    
    class kernel_subsys_test_sequence_lib extends uvm_sequence;                                
                                                                                                    
        function new (string name = "kernel_subsys_test_sequence_lib");                      
            super.new(name);                                                                        
            `uvm_info(this.get_full_name(), "new is called", UVM_LOW)                             
        endfunction                                                                                 
                                                                                                    
        `uvm_object_utils(kernel_subsys_test_sequence_lib)                                     
        `uvm_declare_p_sequencer(kernel_virtual_sequencer)                                     
                                                                                                    
        virtual task body();                                                                        
            uvm_phase starting_phase;                                                               
            virtual interface misc_interface misc_if;                                               
            kernel_reference_model refm;                                                       
                                                                                                    
            axi_pkg::axi_busdatas_master_sequence#(6, 32) axi_master_wr_control_seq;
            axi_pkg::axi_busdatas_master_sequence#(6, 32) axi_master_rd_control_seq;
            axi_pkg::axi_busdatas_master_sequence#(6, 32) axi_master_poll_control_seq;
            axi_pkg::axi_busdatas_master_sequence#(6, 32) axi_master_wr_cont_control_seq;

            if (!uvm_config_db#(kernel_reference_model)::get(p_sequencer,"", "refm", refm))
                `uvm_fatal(this.get_full_name(), "No reference model")
            `uvm_info(this.get_full_name(), "get reference model by uvm_config_db", UVM_LOW)

            `uvm_info(this.get_full_name(), "body is called", UVM_LOW)
            starting_phase = this.get_starting_phase();
            if (starting_phase != null) begin
                `uvm_info(this.get_full_name(), "starting_phase not null", UVM_LOW)
                starting_phase.raise_objection(this);
            end
            else
                `uvm_info(this.get_full_name(), "starting_phase null" , UVM_LOW)

            misc_if = refm.misc_if;


            //phase_done.set_drain_time(this, 0ns);
            wait(refm.misc_if.reset === 1);
            repeat(3)         @(posedge refm.misc_if.clock);
            ->refm.misc_if.initialed_evt;

            fork
                begin
                    fork
                        begin
                            int control_page_idx_bak;
                            `uvm_create_on(axi_master_wr_control_seq, p_sequencer.control_sqr);
                            axi_master_wr_control_seq.misc_if = refm.misc_if;
                            axi_master_wr_control_seq.ap_done    = refm.ap_done_for_nexttrans   ;
                            axi_master_wr_control_seq.ap_ready   = refm.ap_ready_for_nexttrans  ;
                            axi_master_wr_control_seq.finish     = refm.finish ;
                            axi_master_wr_control_seq.isusr_delay = axi_pkg::NO_DELAY;
                            for(int i=0; i<264; i++) begin
                                logic[63:0] data64bit_x_real[$];
                                logic[32-1:0] databusbit_x_real[$];
                                logic[63:0] data64bit_x_imag[$];
                                logic[32-1:0] databusbit_x_imag[$];
                                data64bit_x_real.delete(); databusbit_x_real.delete();
                                axi_master_wr_control_seq.StableAxiliteNoUpdate=0;
                                refm.mem_blk_pages_control_x_real.tobusdata(data64bit_x_real, refm.mem_blk_pages_control_x_real.rd_page_idx, 32);
                                foreach(data64bit_x_real[s]) databusbit_x_real[s]=data64bit_x_real[s][32-1:0];
                                axi_master_wr_control_seq.StableAxiliteNoUpdate=1;
                                axi_master_wr_control_seq.datamerge_inavg(databusbit_x_real, 0, 16, 1);
                                data64bit_x_imag.delete(); databusbit_x_imag.delete();
                                axi_master_wr_control_seq.StableAxiliteNoUpdate=0;
                                refm.mem_blk_pages_control_x_imag.tobusdata(data64bit_x_imag, refm.mem_blk_pages_control_x_imag.rd_page_idx, 32);
                                foreach(data64bit_x_imag[s]) databusbit_x_imag[s]=data64bit_x_imag[s][32-1:0];
                                axi_master_wr_control_seq.StableAxiliteNoUpdate=1;
                                axi_master_wr_control_seq.datamerge_inavg(databusbit_x_imag, 0, 24, 1);
                                `uvm_send(axi_master_wr_control_seq);
                                @(posedge refm.misc_if.clock); //wait address 2 rsp done
                                @(posedge refm.misc_if.clock);
                                refm.write_data_finish_control = 1;
                                `uvm_info("control data writting thread", $sformatf("%0dth(total 264): waiting for all write data finish event",i), UVM_LOW)
                                wait(refm.allaxilite_write_data_finish.triggered);
                                refm.write_data_finish_control = 0;
                                fork
                                    begin
                                        axi_master_wr_control_seq.wr_addr_data.push_back( (1<<0)+(0<<32) );
                                        `uvm_info("control start dut by axilite", $sformatf("%0dth(total 264): begin to set start bit",i), UVM_LOW)
                                        `uvm_send(axi_master_wr_control_seq);
                                    end
                                    begin
                                        `uvm_info("control wait for ap_ready for next trans", $sformatf("%0dth(total 264): begin to wait",i), UVM_LOW)
                                        wait(refm.dut2tb_ap_ready.triggered);
                                        wait(refm.ap_done_for_nexttrans.triggered);
                                        #0.01; //make sure mem incr_rd_page_idx is called first
                                    end
                                join
                            end
                        end
                        begin
                            for(int j=0; j<264; j=j+refm.ap_done_cnt) begin
                                wait(misc_if.dut2tb_ap_done_kernel == 1);
                                `uvm_info("test finish control", $sformatf("ap_done of kernel is triggered"), UVM_LOW)
                                @(posedge misc_if.clock);
                                fork
                                    forever begin
                                        `uvm_create_on(axi_master_poll_control_seq, p_sequencer.control_sqr);
                                        axi_master_poll_control_seq.isusr_delay = axi_pkg::NO_DELAY;
                                        axi_master_poll_control_seq.misc_if = refm.misc_if;
                                        axi_master_poll_control_seq.rd_addr.push_back(0);
                                        `uvm_send(axi_master_poll_control_seq)
                                        repeat(2) @(posedge misc_if.clock);
                                    end
                                    begin
                                        `uvm_info("test finish control", $sformatf("%0dth(total 264) ap_done_for_nexttrans begin to wait",j), UVM_LOW)
                                        @refm.dut2tb_ap_done;
                                    end
                                join_any
                                disable fork;
                                wait(refm.ap_ready_for_nexttrans.triggered);
                                 wait(misc_if.tb2dut_ap_continue==1);
                            end
                        end
                        begin
                            `uvm_create_on(axi_master_rd_control_seq, p_sequencer.control_sqr)
                            axi_master_rd_control_seq.misc_if = refm.misc_if;
                            axi_master_rd_control_seq.ap_done    = refm.ap_done_for_nexttrans   ;
                            axi_master_rd_control_seq.ap_ready   = refm.ap_ready_for_nexttrans  ;
                            axi_master_rd_control_seq.finish     = refm.finish ;
                            axi_master_rd_control_seq.isusr_delay = axi_pkg::NO_DELAY;
                            `uvm_create_on(axi_master_wr_cont_control_seq, p_sequencer.control_sqr)
                            for(int j=0; j<264; j=j+refm.ap_done_cnt) begin
                                logic[32-1:0] databusbit[$];
                                @refm.dut2tb_ap_done;
                                axi_master_rd_control_seq.datamerge_inavg(databusbit, (1*16+32-1)/32, 32, 0);
                                axi_master_rd_control_seq.datamerge_inavg(databusbit, (1*16+32-1)/32, 48, 0);
                                    `uvm_info("axilite data read", $sformatf("%0dth(total 264) data read sequence is started",j), UVM_LOW)
                                `uvm_send(axi_master_rd_control_seq);
                                @(posedge refm.misc_if.clock); //wait address 2 rdata rsp done
                                @(posedge refm.misc_if.clock);
                                refm.read_data_finish_control = 1;
                                wait(refm.allaxilite_read_data_finish.triggered);
                                axi_master_wr_cont_control_seq.wr_addr_data.push_back( (1<<4)+(0<<32) );
                                `uvm_info("continue bit set by axilite", $sformatf("%0dth(total 264) continue setting is started",j), UVM_LOW)
                                `uvm_send(axi_master_wr_cont_control_seq);
                            end
                        end
                    join
                end

                begin
                    for(int j=0; j<264; j=j+refm.ap_done_cnt) @refm.ap_done_for_nexttrans;
                    `uvm_info(this.get_full_name(), "autotb finished", UVM_LOW)
                    -> refm.finish;
                    refm.misc_if.finished = 1;
                    @(posedge refm.misc_if.clock);
                    refm.misc_if.finished = 0;
                    @(posedge refm.misc_if.clock);
                    -> refm.misc_if.finished_evt;
                end
            join_any
            repeat(5) @(posedge refm.misc_if.clock); //5 cycles delay for finish stuff. 5 is haphazard value

            p_sequencer.control_sqr.stop_sequences();
            disable fork;
                                                                                                    
            starting_phase.drop_objection(this);                                                    
                                                                                                    
        endtask                                                                                     
    endclass                                                                                        
                                                                                                    
`endif                                                                                              
