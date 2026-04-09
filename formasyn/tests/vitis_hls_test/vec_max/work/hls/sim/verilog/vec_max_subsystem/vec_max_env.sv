//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef VEC_MAX_ENV__SV                                                                                   
    `define VEC_MAX_ENV__SV                                                                               
                                                                                                                    
                                                                                                                    
    class vec_max_env extends uvm_env;                                                                          
                                                                                                                    
        vec_max_virtual_sequencer vec_max_virtual_sqr;                                                      
        vec_max_config vec_max_cfg;                                                                         
                                                                                                                    
        axi_pkg::axi_env#(6,4,4,3,1) axi_lite_control;
                                                                                                                    
        vec_max_reference_model   refm;                                                                         
                                                                                                                    
        vec_max_subsystem_monitor subsys_mon;                                                                   
                                                                                                                    
        `uvm_component_utils_begin(vec_max_env)                                                                 
        `uvm_field_object (refm, UVM_DEFAULT | UVM_REFERENCE)                                                       
        `uvm_field_object (vec_max_virtual_sqr, UVM_DEFAULT | UVM_REFERENCE)                                    
        `uvm_field_object (vec_max_cfg        , UVM_DEFAULT)                                                    
        `uvm_component_utils_end                                                                                    
                                                                                                                    
        function new (string name = "vec_max_env", uvm_component parent = null);                              
            super.new(name, parent);                                                                                
        endfunction                                                                                                 
                                                                                                                    
        extern virtual function void build_phase(uvm_phase phase);                                                  
        extern virtual function void connect_phase(uvm_phase phase);                                                
        extern virtual task          run_phase(uvm_phase phase);                                                    
                                                                                                                    
    endclass                                                                                                        
                                                                                                                    
    function void vec_max_env::build_phase(uvm_phase phase);                                                    
        super.build_phase(phase);                                                                                   
        vec_max_cfg = vec_max_config::type_id::create("vec_max_cfg", this);                           
                                                                                                                    

        vec_max_cfg.control_cfg.set_default();
        vec_max_cfg.control_cfg.drv_type = axi_pkg::MASTER;
        vec_max_cfg.control_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_lite_control*", "cfg", vec_max_cfg.control_cfg);
        axi_lite_control = axi_pkg::axi_env#(6,4,4,3,1)::type_id::create("axi_lite_control", this);



        refm = vec_max_reference_model::type_id::create("refm", this);


        uvm_config_db#(vec_max_reference_model)::set(this, "*", "refm", refm);


        `uvm_info(this.get_full_name(), "set reference model by uvm_config_db", UVM_LOW)


        subsys_mon = vec_max_subsystem_monitor::type_id::create("subsys_mon", this);


        vec_max_virtual_sqr = vec_max_virtual_sequencer::type_id::create("vec_max_virtual_sqr", this);
        `uvm_info(this.get_full_name(), "build_phase done", UVM_LOW)
    endfunction


    function void vec_max_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);


        if(vec_max_cfg.control_cfg.drv_type==axi_pkg::MASTER ||vec_max_cfg.control_cfg.drv_type==axi_pkg::SLAVE)
            vec_max_virtual_sqr.control_sqr = axi_lite_control.vsqr;
        axi_lite_control.item_wtr_port.connect(subsys_mon.control_wtr_imp);
        axi_lite_control.item_rtr_port.connect(subsys_mon.control_rtr_imp);
        refm.vec_max_cfg = vec_max_cfg;
        `uvm_info(this.get_full_name(), "connect phase done", UVM_LOW)
    endfunction


    task vec_max_env::run_phase(uvm_phase phase);
        `uvm_info(this.get_full_name(), "vec_max_env is running", UVM_LOW)
    endtask


`endif
