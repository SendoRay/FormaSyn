//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
//Tool Version Limit: 2025.05
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef VEC_ADD_ENV__SV                                                                                   
    `define VEC_ADD_ENV__SV                                                                               
                                                                                                                    
    class axi_latency_gmem extends axi_latency;
        rand int    wr_latency;
        rand int    rd_latency;
        `uvm_object_utils_begin(axi_latency_gmem)
        `uvm_object_utils_end
        function new ( string name = "axi_latency_gmem" );
            super.new(name);
        endfunction
        virtual function int get_wr_lat();
            int delay;
            void'(std::randomize(delay) with { delay == 64;});
            wr_latency = delay;
            return wr_latency;
        endfunction
        virtual function int get_rd_lat();
            int delay;
            void'(std::randomize(delay) with { delay == 64;});
            rd_latency = delay;
            return rd_latency;
        endfunction
    endclass

                                                                                                                    
    class vec_add_env extends uvm_env;                                                                          
                                                                                                                    
        axi_latency_gmem    lat_gmem;
        vec_add_virtual_sequencer vec_add_virtual_sqr;                                                      
        vec_add_config vec_add_cfg;                                                                         
                                                                                                                    
        axi_pkg::axi_env#(64,64,8,3,1) axi_master_gmem;
        axi_pkg::axi_env#(6,4,4,3,1) axi_lite_control;
                                                                                                                    
        vec_add_reference_model   refm;                                                                         
                                                                                                                    
        vec_add_subsystem_monitor subsys_mon;                                                                   
                                                                                                                    
        `uvm_component_utils_begin(vec_add_env)                                                                 
        `uvm_field_object (refm, UVM_DEFAULT | UVM_REFERENCE)                                                       
        `uvm_field_object (vec_add_virtual_sqr, UVM_DEFAULT | UVM_REFERENCE)                                    
        `uvm_field_object (vec_add_cfg        , UVM_DEFAULT)                                                    
        `uvm_component_utils_end                                                                                    
                                                                                                                    
        function new (string name = "vec_add_env", uvm_component parent = null);                              
            super.new(name, parent);                                                                                
        endfunction                                                                                                 
                                                                                                                    
        extern virtual function void build_phase(uvm_phase phase);                                                  
        extern virtual function void connect_phase(uvm_phase phase);                                                
        extern virtual task          run_phase(uvm_phase phase);                                                    
                                                                                                                    
    endclass                                                                                                        
                                                                                                                    
    function void vec_add_env::build_phase(uvm_phase phase);                                                    
        super.build_phase(phase);                                                                                   
        vec_add_cfg = vec_add_config::type_id::create("vec_add_cfg", this);                           
                                                                                                                    

        vec_add_cfg.gmem_cfg.set_default();
        vec_add_cfg.gmem_cfg.drv_type = axi_pkg::SLAVE;
        vec_add_cfg.gmem_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        lat_gmem = axi_latency_gmem::type_id::create("lat_gmem", this);
        vec_add_cfg.gmem_cfg.clatency = lat_gmem;
        vec_add_cfg.gmem_cfg.write_latency_mode = TRANSACTION_FIRST;
        vec_add_cfg.gmem_cfg.read_latency_mode = TRANSACTION_FIRST;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_master_gmem*", "cfg", vec_add_cfg.gmem_cfg);
        axi_master_gmem = axi_pkg::axi_env#(64,64,8,3,1)::type_id::create("axi_master_gmem", this);

        vec_add_cfg.control_cfg.set_default();
        vec_add_cfg.control_cfg.drv_type = axi_pkg::MASTER;
        vec_add_cfg.control_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_lite_control*", "cfg", vec_add_cfg.control_cfg);
        axi_lite_control = axi_pkg::axi_env#(6,4,4,3,1)::type_id::create("axi_lite_control", this);



        refm = vec_add_reference_model::type_id::create("refm", this);


        uvm_config_db#(vec_add_reference_model)::set(this, "*", "refm", refm);


        `uvm_info(this.get_full_name(), "set reference model by uvm_config_db", UVM_LOW)


        subsys_mon = vec_add_subsystem_monitor::type_id::create("subsys_mon", this);


        vec_add_virtual_sqr = vec_add_virtual_sequencer::type_id::create("vec_add_virtual_sqr", this);
        `uvm_info(this.get_full_name(), "build_phase done", UVM_LOW)
    endfunction


    function void vec_add_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);


        if(vec_add_cfg.gmem_cfg.drv_type==axi_pkg::MASTER ||vec_add_cfg.gmem_cfg.drv_type==axi_pkg::SLAVE)
            vec_add_virtual_sqr.gmem_sqr = axi_master_gmem.vsqr;
        axi_master_gmem.item_wtr_port.connect(subsys_mon.gmem_wtr_imp);
        axi_master_gmem.item_rtr_port.connect(subsys_mon.gmem_rtr_imp);
        uvm_callbacks#(axi_pkg::axi_state, axi_pkg::axi_state_cbs)::add(axi_master_gmem.state, refm.axi_memaccess_cb_gmem);
        if(vec_add_cfg.control_cfg.drv_type==axi_pkg::MASTER ||vec_add_cfg.control_cfg.drv_type==axi_pkg::SLAVE)
            vec_add_virtual_sqr.control_sqr = axi_lite_control.vsqr;
        axi_lite_control.item_wtr_port.connect(subsys_mon.control_wtr_imp);
        axi_lite_control.item_rtr_port.connect(subsys_mon.control_rtr_imp);
        refm.vec_add_cfg = vec_add_cfg;
        `uvm_info(this.get_full_name(), "connect phase done", UVM_LOW)
    endfunction


    task vec_add_env::run_phase(uvm_phase phase);
        `uvm_info(this.get_full_name(), "vec_add_env is running", UVM_LOW)
    endtask


`endif
