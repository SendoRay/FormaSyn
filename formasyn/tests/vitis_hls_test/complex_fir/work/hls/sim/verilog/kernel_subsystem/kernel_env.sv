//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef KERNEL_ENV__SV                                                                                   
    `define KERNEL_ENV__SV                                                                               
                                                                                                                    
                                                                                                                    
    class kernel_env extends uvm_env;                                                                          
                                                                                                                    
        kernel_virtual_sequencer kernel_virtual_sqr;                                                      
        kernel_config kernel_cfg;                                                                         
                                                                                                                    
        axi_pkg::axi_env#(6,4,4,3,1) axi_lite_control;
                                                                                                                    
        kernel_reference_model   refm;                                                                         
                                                                                                                    
        kernel_subsystem_monitor subsys_mon;                                                                   
                                                                                                                    
        `uvm_component_utils_begin(kernel_env)                                                                 
        `uvm_field_object (refm, UVM_DEFAULT | UVM_REFERENCE)                                                       
        `uvm_field_object (kernel_virtual_sqr, UVM_DEFAULT | UVM_REFERENCE)                                    
        `uvm_field_object (kernel_cfg        , UVM_DEFAULT)                                                    
        `uvm_component_utils_end                                                                                    
                                                                                                                    
        function new (string name = "kernel_env", uvm_component parent = null);                              
            super.new(name, parent);                                                                                
        endfunction                                                                                                 
                                                                                                                    
        extern virtual function void build_phase(uvm_phase phase);                                                  
        extern virtual function void connect_phase(uvm_phase phase);                                                
        extern virtual task          run_phase(uvm_phase phase);                                                    
                                                                                                                    
    endclass                                                                                                        
                                                                                                                    
    function void kernel_env::build_phase(uvm_phase phase);                                                    
        super.build_phase(phase);                                                                                   
        kernel_cfg = kernel_config::type_id::create("kernel_cfg", this);                           
                                                                                                                    

        kernel_cfg.control_cfg.set_default();
        kernel_cfg.control_cfg.drv_type = axi_pkg::MASTER;
        kernel_cfg.control_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_lite_control*", "cfg", kernel_cfg.control_cfg);
        axi_lite_control = axi_pkg::axi_env#(6,4,4,3,1)::type_id::create("axi_lite_control", this);



        refm = kernel_reference_model::type_id::create("refm", this);


        uvm_config_db#(kernel_reference_model)::set(this, "*", "refm", refm);


        `uvm_info(this.get_full_name(), "set reference model by uvm_config_db", UVM_LOW)


        subsys_mon = kernel_subsystem_monitor::type_id::create("subsys_mon", this);


        kernel_virtual_sqr = kernel_virtual_sequencer::type_id::create("kernel_virtual_sqr", this);
        `uvm_info(this.get_full_name(), "build_phase done", UVM_LOW)
    endfunction


    function void kernel_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);


        if(kernel_cfg.control_cfg.drv_type==axi_pkg::MASTER ||kernel_cfg.control_cfg.drv_type==axi_pkg::SLAVE)
            kernel_virtual_sqr.control_sqr = axi_lite_control.vsqr;
        axi_lite_control.item_wtr_port.connect(subsys_mon.control_wtr_imp);
        axi_lite_control.item_rtr_port.connect(subsys_mon.control_rtr_imp);
        refm.kernel_cfg = kernel_cfg;
        `uvm_info(this.get_full_name(), "connect phase done", UVM_LOW)
    endfunction


    task kernel_env::run_phase(uvm_phase phase);
        `uvm_info(this.get_full_name(), "kernel_env is running", UVM_LOW)
    endtask


`endif
