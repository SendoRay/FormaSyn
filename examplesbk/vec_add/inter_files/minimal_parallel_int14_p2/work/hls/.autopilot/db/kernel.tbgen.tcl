set moduleName kernel
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set isPipelined_legacy 0
set pipeline_type none
set FunctionProtocol ap_ctrl_chain
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 2
set C_modelName {kernel}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ gmem0_0 int 64 regular {axi_master 0}  }
	{ gmem0_1 int 64 regular {axi_master 0}  }
	{ gmem1_0 int 64 regular {axi_master 0}  }
	{ gmem1_1 int 64 regular {axi_master 0}  }
	{ gmem2_0 int 128 regular {axi_master 1}  }
	{ gmem2_1 int 128 regular {axi_master 1}  }
	{ a_0 int 64 regular {axi_slave 0}  }
	{ a_1 int 64 regular {axi_slave 0}  }
	{ b_0 int 64 regular {axi_slave 0}  }
	{ b_1 int 64 regular {axi_slave 0}  }
	{ c_0 int 64 regular {axi_slave 0}  }
	{ c_1 int 64 regular {axi_slave 0}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "gmem0_0", "interface" : "axi_master", "bitwidth" : 64, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_0","offset": { "type": "dynamic","port_name": "a_0","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_1", "interface" : "axi_master", "bitwidth" : 64, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_1","offset": { "type": "dynamic","port_name": "a_1","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_0", "interface" : "axi_master", "bitwidth" : 64, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_0","offset": { "type": "dynamic","port_name": "b_0","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_1", "interface" : "axi_master", "bitwidth" : 64, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_1","offset": { "type": "dynamic","port_name": "b_1","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem2_0", "interface" : "axi_master", "bitwidth" : 128, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_0","offset": { "type": "dynamic","port_name": "c_0","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_1", "interface" : "axi_master", "bitwidth" : 128, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_1","offset": { "type": "dynamic","port_name": "c_1","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "a_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":16}, "offset_end" : {"in":27}} , 
 	{ "Name" : "a_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":28}, "offset_end" : {"in":39}} , 
 	{ "Name" : "b_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":40}, "offset_end" : {"in":51}} , 
 	{ "Name" : "b_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":52}, "offset_end" : {"in":63}} , 
 	{ "Name" : "c_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":64}, "offset_end" : {"in":75}} , 
 	{ "Name" : "c_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":76}, "offset_end" : {"in":87}} ]}
# RTL Port declarations: 
set portNum 290
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ m_axi_gmem0_0_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem0_0_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_AWLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_gmem0_0_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem0_0_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem0_0_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem0_0_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem0_0_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem0_0_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem0_0_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem0_0_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_WDATA sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem0_0_WSTRB sc_out sc_lv 8 signal 0 } 
	{ m_axi_gmem0_0_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_ARADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem0_0_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_ARLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_gmem0_0_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem0_0_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem0_0_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem0_0_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem0_0_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem0_0_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem0_0_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem0_0_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_RDATA sc_in sc_lv 64 signal 0 } 
	{ m_axi_gmem0_0_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem0_0_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem0_0_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem0_0_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem0_0_BUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem0_1_AWVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_AWREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_AWADDR sc_out sc_lv 64 signal 1 } 
	{ m_axi_gmem0_1_AWID sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_AWLEN sc_out sc_lv 8 signal 1 } 
	{ m_axi_gmem0_1_AWSIZE sc_out sc_lv 3 signal 1 } 
	{ m_axi_gmem0_1_AWBURST sc_out sc_lv 2 signal 1 } 
	{ m_axi_gmem0_1_AWLOCK sc_out sc_lv 2 signal 1 } 
	{ m_axi_gmem0_1_AWCACHE sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem0_1_AWPROT sc_out sc_lv 3 signal 1 } 
	{ m_axi_gmem0_1_AWQOS sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem0_1_AWREGION sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem0_1_AWUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_WVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_WREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_WDATA sc_out sc_lv 64 signal 1 } 
	{ m_axi_gmem0_1_WSTRB sc_out sc_lv 8 signal 1 } 
	{ m_axi_gmem0_1_WLAST sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_WID sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_WUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_ARVALID sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_ARREADY sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_ARADDR sc_out sc_lv 64 signal 1 } 
	{ m_axi_gmem0_1_ARID sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_ARLEN sc_out sc_lv 8 signal 1 } 
	{ m_axi_gmem0_1_ARSIZE sc_out sc_lv 3 signal 1 } 
	{ m_axi_gmem0_1_ARBURST sc_out sc_lv 2 signal 1 } 
	{ m_axi_gmem0_1_ARLOCK sc_out sc_lv 2 signal 1 } 
	{ m_axi_gmem0_1_ARCACHE sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem0_1_ARPROT sc_out sc_lv 3 signal 1 } 
	{ m_axi_gmem0_1_ARQOS sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem0_1_ARREGION sc_out sc_lv 4 signal 1 } 
	{ m_axi_gmem0_1_ARUSER sc_out sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_RVALID sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_RREADY sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_RDATA sc_in sc_lv 64 signal 1 } 
	{ m_axi_gmem0_1_RLAST sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_RID sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_RUSER sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_RRESP sc_in sc_lv 2 signal 1 } 
	{ m_axi_gmem0_1_BVALID sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_BREADY sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_BRESP sc_in sc_lv 2 signal 1 } 
	{ m_axi_gmem0_1_BID sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_BUSER sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem1_0_AWVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_AWREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_AWADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem1_0_AWID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_AWLEN sc_out sc_lv 8 signal 2 } 
	{ m_axi_gmem1_0_AWSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem1_0_AWBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem1_0_AWLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem1_0_AWCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem1_0_AWPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem1_0_AWQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem1_0_AWREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem1_0_AWUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_WVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_WREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_WDATA sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem1_0_WSTRB sc_out sc_lv 8 signal 2 } 
	{ m_axi_gmem1_0_WLAST sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_WID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_WUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_ARVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_ARREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_ARADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem1_0_ARID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_ARLEN sc_out sc_lv 8 signal 2 } 
	{ m_axi_gmem1_0_ARSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem1_0_ARBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem1_0_ARLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem1_0_ARCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem1_0_ARPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem1_0_ARQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem1_0_ARREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem1_0_ARUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_RVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_RREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_RDATA sc_in sc_lv 64 signal 2 } 
	{ m_axi_gmem1_0_RLAST sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_RID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_RUSER sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_RRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem1_0_BVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_BREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem1_0_BRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem1_0_BID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem1_0_BUSER sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem1_1_AWVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_AWREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_AWADDR sc_out sc_lv 64 signal 3 } 
	{ m_axi_gmem1_1_AWID sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_AWLEN sc_out sc_lv 8 signal 3 } 
	{ m_axi_gmem1_1_AWSIZE sc_out sc_lv 3 signal 3 } 
	{ m_axi_gmem1_1_AWBURST sc_out sc_lv 2 signal 3 } 
	{ m_axi_gmem1_1_AWLOCK sc_out sc_lv 2 signal 3 } 
	{ m_axi_gmem1_1_AWCACHE sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem1_1_AWPROT sc_out sc_lv 3 signal 3 } 
	{ m_axi_gmem1_1_AWQOS sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem1_1_AWREGION sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem1_1_AWUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_WVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_WREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_WDATA sc_out sc_lv 64 signal 3 } 
	{ m_axi_gmem1_1_WSTRB sc_out sc_lv 8 signal 3 } 
	{ m_axi_gmem1_1_WLAST sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_WID sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_WUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_ARVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_ARREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_ARADDR sc_out sc_lv 64 signal 3 } 
	{ m_axi_gmem1_1_ARID sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_ARLEN sc_out sc_lv 8 signal 3 } 
	{ m_axi_gmem1_1_ARSIZE sc_out sc_lv 3 signal 3 } 
	{ m_axi_gmem1_1_ARBURST sc_out sc_lv 2 signal 3 } 
	{ m_axi_gmem1_1_ARLOCK sc_out sc_lv 2 signal 3 } 
	{ m_axi_gmem1_1_ARCACHE sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem1_1_ARPROT sc_out sc_lv 3 signal 3 } 
	{ m_axi_gmem1_1_ARQOS sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem1_1_ARREGION sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem1_1_ARUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_RVALID sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_RREADY sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_RDATA sc_in sc_lv 64 signal 3 } 
	{ m_axi_gmem1_1_RLAST sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_RID sc_in sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_RUSER sc_in sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_RRESP sc_in sc_lv 2 signal 3 } 
	{ m_axi_gmem1_1_BVALID sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_BREADY sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem1_1_BRESP sc_in sc_lv 2 signal 3 } 
	{ m_axi_gmem1_1_BID sc_in sc_lv 1 signal 3 } 
	{ m_axi_gmem1_1_BUSER sc_in sc_lv 1 signal 3 } 
	{ m_axi_gmem2_0_AWVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_AWREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_AWADDR sc_out sc_lv 64 signal 4 } 
	{ m_axi_gmem2_0_AWID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_AWLEN sc_out sc_lv 8 signal 4 } 
	{ m_axi_gmem2_0_AWSIZE sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem2_0_AWBURST sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem2_0_AWLOCK sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem2_0_AWCACHE sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem2_0_AWPROT sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem2_0_AWQOS sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem2_0_AWREGION sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem2_0_AWUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_WVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_WREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_WDATA sc_out sc_lv 128 signal 4 } 
	{ m_axi_gmem2_0_WSTRB sc_out sc_lv 16 signal 4 } 
	{ m_axi_gmem2_0_WLAST sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_WID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_WUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_ARVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_ARREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_ARADDR sc_out sc_lv 64 signal 4 } 
	{ m_axi_gmem2_0_ARID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_ARLEN sc_out sc_lv 8 signal 4 } 
	{ m_axi_gmem2_0_ARSIZE sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem2_0_ARBURST sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem2_0_ARLOCK sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem2_0_ARCACHE sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem2_0_ARPROT sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem2_0_ARQOS sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem2_0_ARREGION sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem2_0_ARUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_RVALID sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_RREADY sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_RDATA sc_in sc_lv 128 signal 4 } 
	{ m_axi_gmem2_0_RLAST sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_RID sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_RUSER sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_RRESP sc_in sc_lv 2 signal 4 } 
	{ m_axi_gmem2_0_BVALID sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_BREADY sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem2_0_BRESP sc_in sc_lv 2 signal 4 } 
	{ m_axi_gmem2_0_BID sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem2_0_BUSER sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem2_1_AWVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_AWREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_AWADDR sc_out sc_lv 64 signal 5 } 
	{ m_axi_gmem2_1_AWID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_AWLEN sc_out sc_lv 8 signal 5 } 
	{ m_axi_gmem2_1_AWSIZE sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem2_1_AWBURST sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem2_1_AWLOCK sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem2_1_AWCACHE sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem2_1_AWPROT sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem2_1_AWQOS sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem2_1_AWREGION sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem2_1_AWUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_WVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_WREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_WDATA sc_out sc_lv 128 signal 5 } 
	{ m_axi_gmem2_1_WSTRB sc_out sc_lv 16 signal 5 } 
	{ m_axi_gmem2_1_WLAST sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_WID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_WUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_ARVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_ARREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_ARADDR sc_out sc_lv 64 signal 5 } 
	{ m_axi_gmem2_1_ARID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_ARLEN sc_out sc_lv 8 signal 5 } 
	{ m_axi_gmem2_1_ARSIZE sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem2_1_ARBURST sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem2_1_ARLOCK sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem2_1_ARCACHE sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem2_1_ARPROT sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem2_1_ARQOS sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem2_1_ARREGION sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem2_1_ARUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_RVALID sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_RREADY sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_RDATA sc_in sc_lv 128 signal 5 } 
	{ m_axi_gmem2_1_RLAST sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_RID sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_RUSER sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_RRESP sc_in sc_lv 2 signal 5 } 
	{ m_axi_gmem2_1_BVALID sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_BREADY sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem2_1_BRESP sc_in sc_lv 2 signal 5 } 
	{ m_axi_gmem2_1_BID sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem2_1_BUSER sc_in sc_lv 1 signal 5 } 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 7 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 7 signal -1 } 
	{ s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
}
set NewPortList {[ 
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"kernel","role":"start","value":"0","valid_bit":"0"},{"name":"kernel","role":"continue","value":"0","valid_bit":"4"},{"name":"kernel","role":"auto_start","value":"0","valid_bit":"7"},{"name":"a_0","role":"data","value":"16"},{"name":"a_1","role":"data","value":"28"},{"name":"b_0","role":"data","value":"40"},{"name":"b_1","role":"data","value":"52"},{"name":"c_0","role":"data","value":"64"},{"name":"c_1","role":"data","value":"76"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"kernel","role":"start","value":"0","valid_bit":"0"},{"name":"kernel","role":"done","value":"0","valid_bit":"1"},{"name":"kernel","role":"idle","value":"0","valid_bit":"2"},{"name":"kernel","role":"ready","value":"0","valid_bit":"3"},{"name":"kernel","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARVALID" } },
	{ "name": "s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARREADY" } },
	{ "name": "s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RVALID" } },
	{ "name": "s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RREADY" } },
	{ "name": "s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "RDATA" } },
	{ "name": "s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "RRESP" } },
	{ "name": "s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BVALID" } },
	{ "name": "s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BREADY" } },
	{ "name": "s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "m_axi_gmem0_0_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem0_0_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem0_0_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem0_0_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem0_0_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem0_0_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem0_0_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem0_0_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem0_0_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem0_0_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem0_0_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem0_0_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem0_0_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem0_0_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem0_0_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem0_0_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_0_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem0_0_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem0_0_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WID" }} , 
 	{ "name": "m_axi_gmem0_0_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem0_0_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem0_0_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem0_0_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem0_0_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem0_0_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem0_0_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem0_0_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem0_0_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem0_0_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem0_0_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem0_0_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem0_0_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem0_0_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem0_0_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem0_0_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem0_0_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_0", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_0_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_0_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_0_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_0_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_0", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_0_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_0_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_0_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_0", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_0_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_0_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_0", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem0_1_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem0_1_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem0_1_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem0_1_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem0_1_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem0_1_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem0_1_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem0_1_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem0_1_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem0_1_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem0_1_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem0_1_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem0_1_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem0_1_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem0_1_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem0_1_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_1_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem0_1_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem0_1_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WID" }} , 
 	{ "name": "m_axi_gmem0_1_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem0_1_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem0_1_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem0_1_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem0_1_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem0_1_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem0_1_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem0_1_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem0_1_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem0_1_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem0_1_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem0_1_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem0_1_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem0_1_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem0_1_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem0_1_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem0_1_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_1_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_1_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_1_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_1_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_1_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_1_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_1_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_1_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_1_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem1_0_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem1_0_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem1_0_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem1_0_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem1_0_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem1_0_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem1_0_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem1_0_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem1_0_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem1_0_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem1_0_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem1_0_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem1_0_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem1_0_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem1_0_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem1_0_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_0_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem1_0_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem1_0_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WID" }} , 
 	{ "name": "m_axi_gmem1_0_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem1_0_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem1_0_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem1_0_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem1_0_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem1_0_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem1_0_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem1_0_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem1_0_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem1_0_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem1_0_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem1_0_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem1_0_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem1_0_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem1_0_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem1_0_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem1_0_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_0", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_0_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_0_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_0_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_0_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_0", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_0_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_0_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_0_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_0", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_0_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_0_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_0", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem1_1_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem1_1_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem1_1_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem1_1_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem1_1_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem1_1_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem1_1_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem1_1_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem1_1_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem1_1_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem1_1_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem1_1_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem1_1_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem1_1_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem1_1_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem1_1_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_1_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem1_1_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem1_1_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WID" }} , 
 	{ "name": "m_axi_gmem1_1_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem1_1_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem1_1_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem1_1_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem1_1_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem1_1_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem1_1_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem1_1_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem1_1_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem1_1_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem1_1_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem1_1_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem1_1_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem1_1_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem1_1_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem1_1_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem1_1_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_1_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_1_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_1_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_1_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_1_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_1_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_1_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_1_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_1_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem2_0_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem2_0_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem2_0_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem2_0_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem2_0_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem2_0_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem2_0_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem2_0_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem2_0_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem2_0_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem2_0_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem2_0_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem2_0_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem2_0_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem2_0_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem2_0_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_0_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem2_0_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem2_0_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WID" }} , 
 	{ "name": "m_axi_gmem2_0_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem2_0_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem2_0_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem2_0_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem2_0_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem2_0_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem2_0_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem2_0_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem2_0_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem2_0_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem2_0_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem2_0_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem2_0_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem2_0_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem2_0_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem2_0_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem2_0_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_0_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_0_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_0_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_0_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_0_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_0_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_0_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_0", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_0_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_0_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_0", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem2_1_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem2_1_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem2_1_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem2_1_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem2_1_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem2_1_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem2_1_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem2_1_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem2_1_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem2_1_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem2_1_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem2_1_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem2_1_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem2_1_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem2_1_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem2_1_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_1_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem2_1_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem2_1_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WID" }} , 
 	{ "name": "m_axi_gmem2_1_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem2_1_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem2_1_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem2_1_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem2_1_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem2_1_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem2_1_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem2_1_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem2_1_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem2_1_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem2_1_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem2_1_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem2_1_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem2_1_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem2_1_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem2_1_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem2_1_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_1_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_1_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_1_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_1_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_1_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_1_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_1_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_1_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_1_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BUSER" }}  ]}

set ArgLastReadFirstWriteLatency {
	kernel {
		gmem0_0 {Type I LastRead 72 FirstWrite -1}
		gmem0_1 {Type I LastRead 72 FirstWrite -1}
		gmem1_0 {Type I LastRead 72 FirstWrite -1}
		gmem1_1 {Type I LastRead 72 FirstWrite -1}
		gmem2_0 {Type O LastRead 77 FirstWrite 76}
		gmem2_1 {Type O LastRead 77 FirstWrite 76}
		a_0 {Type I LastRead 0 FirstWrite -1}
		a_1 {Type I LastRead 0 FirstWrite -1}
		b_0 {Type I LastRead 0 FirstWrite -1}
		b_1 {Type I LastRead 0 FirstWrite -1}
		c_0 {Type I LastRead 0 FirstWrite -1}
		c_1 {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "151", "Max" : "151"}
	, {"Name" : "Interval", "Min" : "152", "Max" : "152"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	gmem0_0 { m_axi {  { m_axi_gmem0_0_AWVALID VALID 1 1 }  { m_axi_gmem0_0_AWREADY READY 0 1 }  { m_axi_gmem0_0_AWADDR ADDR 1 64 }  { m_axi_gmem0_0_AWID ID 1 1 }  { m_axi_gmem0_0_AWLEN SIZE 1 8 }  { m_axi_gmem0_0_AWSIZE BURST 1 3 }  { m_axi_gmem0_0_AWBURST LOCK 1 2 }  { m_axi_gmem0_0_AWLOCK CACHE 1 2 }  { m_axi_gmem0_0_AWCACHE PROT 1 4 }  { m_axi_gmem0_0_AWPROT QOS 1 3 }  { m_axi_gmem0_0_AWQOS REGION 1 4 }  { m_axi_gmem0_0_AWREGION USER 1 4 }  { m_axi_gmem0_0_AWUSER DATA 1 1 }  { m_axi_gmem0_0_WVALID VALID 1 1 }  { m_axi_gmem0_0_WREADY READY 0 1 }  { m_axi_gmem0_0_WDATA FIFONUM 1 64 }  { m_axi_gmem0_0_WSTRB STRB 1 8 }  { m_axi_gmem0_0_WLAST LAST 1 1 }  { m_axi_gmem0_0_WID ID 1 1 }  { m_axi_gmem0_0_WUSER DATA 1 1 }  { m_axi_gmem0_0_ARVALID VALID 1 1 }  { m_axi_gmem0_0_ARREADY READY 0 1 }  { m_axi_gmem0_0_ARADDR ADDR 1 64 }  { m_axi_gmem0_0_ARID ID 1 1 }  { m_axi_gmem0_0_ARLEN SIZE 1 8 }  { m_axi_gmem0_0_ARSIZE BURST 1 3 }  { m_axi_gmem0_0_ARBURST LOCK 1 2 }  { m_axi_gmem0_0_ARLOCK CACHE 1 2 }  { m_axi_gmem0_0_ARCACHE PROT 1 4 }  { m_axi_gmem0_0_ARPROT QOS 1 3 }  { m_axi_gmem0_0_ARQOS REGION 1 4 }  { m_axi_gmem0_0_ARREGION USER 1 4 }  { m_axi_gmem0_0_ARUSER DATA 1 1 }  { m_axi_gmem0_0_RVALID VALID 0 1 }  { m_axi_gmem0_0_RREADY READY 1 1 }  { m_axi_gmem0_0_RDATA FIFONUM 0 64 }  { m_axi_gmem0_0_RLAST LAST 0 1 }  { m_axi_gmem0_0_RID ID 0 1 }  { m_axi_gmem0_0_RUSER DATA 0 1 }  { m_axi_gmem0_0_RRESP RESP 0 2 }  { m_axi_gmem0_0_BVALID VALID 0 1 }  { m_axi_gmem0_0_BREADY READY 1 1 }  { m_axi_gmem0_0_BRESP RESP 0 2 }  { m_axi_gmem0_0_BID ID 0 1 }  { m_axi_gmem0_0_BUSER DATA 0 1 } } }
	gmem0_1 { m_axi {  { m_axi_gmem0_1_AWVALID VALID 1 1 }  { m_axi_gmem0_1_AWREADY READY 0 1 }  { m_axi_gmem0_1_AWADDR ADDR 1 64 }  { m_axi_gmem0_1_AWID ID 1 1 }  { m_axi_gmem0_1_AWLEN SIZE 1 8 }  { m_axi_gmem0_1_AWSIZE BURST 1 3 }  { m_axi_gmem0_1_AWBURST LOCK 1 2 }  { m_axi_gmem0_1_AWLOCK CACHE 1 2 }  { m_axi_gmem0_1_AWCACHE PROT 1 4 }  { m_axi_gmem0_1_AWPROT QOS 1 3 }  { m_axi_gmem0_1_AWQOS REGION 1 4 }  { m_axi_gmem0_1_AWREGION USER 1 4 }  { m_axi_gmem0_1_AWUSER DATA 1 1 }  { m_axi_gmem0_1_WVALID VALID 1 1 }  { m_axi_gmem0_1_WREADY READY 0 1 }  { m_axi_gmem0_1_WDATA FIFONUM 1 64 }  { m_axi_gmem0_1_WSTRB STRB 1 8 }  { m_axi_gmem0_1_WLAST LAST 1 1 }  { m_axi_gmem0_1_WID ID 1 1 }  { m_axi_gmem0_1_WUSER DATA 1 1 }  { m_axi_gmem0_1_ARVALID VALID 1 1 }  { m_axi_gmem0_1_ARREADY READY 0 1 }  { m_axi_gmem0_1_ARADDR ADDR 1 64 }  { m_axi_gmem0_1_ARID ID 1 1 }  { m_axi_gmem0_1_ARLEN SIZE 1 8 }  { m_axi_gmem0_1_ARSIZE BURST 1 3 }  { m_axi_gmem0_1_ARBURST LOCK 1 2 }  { m_axi_gmem0_1_ARLOCK CACHE 1 2 }  { m_axi_gmem0_1_ARCACHE PROT 1 4 }  { m_axi_gmem0_1_ARPROT QOS 1 3 }  { m_axi_gmem0_1_ARQOS REGION 1 4 }  { m_axi_gmem0_1_ARREGION USER 1 4 }  { m_axi_gmem0_1_ARUSER DATA 1 1 }  { m_axi_gmem0_1_RVALID VALID 0 1 }  { m_axi_gmem0_1_RREADY READY 1 1 }  { m_axi_gmem0_1_RDATA FIFONUM 0 64 }  { m_axi_gmem0_1_RLAST LAST 0 1 }  { m_axi_gmem0_1_RID ID 0 1 }  { m_axi_gmem0_1_RUSER DATA 0 1 }  { m_axi_gmem0_1_RRESP RESP 0 2 }  { m_axi_gmem0_1_BVALID VALID 0 1 }  { m_axi_gmem0_1_BREADY READY 1 1 }  { m_axi_gmem0_1_BRESP RESP 0 2 }  { m_axi_gmem0_1_BID ID 0 1 }  { m_axi_gmem0_1_BUSER DATA 0 1 } } }
	gmem1_0 { m_axi {  { m_axi_gmem1_0_AWVALID VALID 1 1 }  { m_axi_gmem1_0_AWREADY READY 0 1 }  { m_axi_gmem1_0_AWADDR ADDR 1 64 }  { m_axi_gmem1_0_AWID ID 1 1 }  { m_axi_gmem1_0_AWLEN SIZE 1 8 }  { m_axi_gmem1_0_AWSIZE BURST 1 3 }  { m_axi_gmem1_0_AWBURST LOCK 1 2 }  { m_axi_gmem1_0_AWLOCK CACHE 1 2 }  { m_axi_gmem1_0_AWCACHE PROT 1 4 }  { m_axi_gmem1_0_AWPROT QOS 1 3 }  { m_axi_gmem1_0_AWQOS REGION 1 4 }  { m_axi_gmem1_0_AWREGION USER 1 4 }  { m_axi_gmem1_0_AWUSER DATA 1 1 }  { m_axi_gmem1_0_WVALID VALID 1 1 }  { m_axi_gmem1_0_WREADY READY 0 1 }  { m_axi_gmem1_0_WDATA FIFONUM 1 64 }  { m_axi_gmem1_0_WSTRB STRB 1 8 }  { m_axi_gmem1_0_WLAST LAST 1 1 }  { m_axi_gmem1_0_WID ID 1 1 }  { m_axi_gmem1_0_WUSER DATA 1 1 }  { m_axi_gmem1_0_ARVALID VALID 1 1 }  { m_axi_gmem1_0_ARREADY READY 0 1 }  { m_axi_gmem1_0_ARADDR ADDR 1 64 }  { m_axi_gmem1_0_ARID ID 1 1 }  { m_axi_gmem1_0_ARLEN SIZE 1 8 }  { m_axi_gmem1_0_ARSIZE BURST 1 3 }  { m_axi_gmem1_0_ARBURST LOCK 1 2 }  { m_axi_gmem1_0_ARLOCK CACHE 1 2 }  { m_axi_gmem1_0_ARCACHE PROT 1 4 }  { m_axi_gmem1_0_ARPROT QOS 1 3 }  { m_axi_gmem1_0_ARQOS REGION 1 4 }  { m_axi_gmem1_0_ARREGION USER 1 4 }  { m_axi_gmem1_0_ARUSER DATA 1 1 }  { m_axi_gmem1_0_RVALID VALID 0 1 }  { m_axi_gmem1_0_RREADY READY 1 1 }  { m_axi_gmem1_0_RDATA FIFONUM 0 64 }  { m_axi_gmem1_0_RLAST LAST 0 1 }  { m_axi_gmem1_0_RID ID 0 1 }  { m_axi_gmem1_0_RUSER DATA 0 1 }  { m_axi_gmem1_0_RRESP RESP 0 2 }  { m_axi_gmem1_0_BVALID VALID 0 1 }  { m_axi_gmem1_0_BREADY READY 1 1 }  { m_axi_gmem1_0_BRESP RESP 0 2 }  { m_axi_gmem1_0_BID ID 0 1 }  { m_axi_gmem1_0_BUSER DATA 0 1 } } }
	gmem1_1 { m_axi {  { m_axi_gmem1_1_AWVALID VALID 1 1 }  { m_axi_gmem1_1_AWREADY READY 0 1 }  { m_axi_gmem1_1_AWADDR ADDR 1 64 }  { m_axi_gmem1_1_AWID ID 1 1 }  { m_axi_gmem1_1_AWLEN SIZE 1 8 }  { m_axi_gmem1_1_AWSIZE BURST 1 3 }  { m_axi_gmem1_1_AWBURST LOCK 1 2 }  { m_axi_gmem1_1_AWLOCK CACHE 1 2 }  { m_axi_gmem1_1_AWCACHE PROT 1 4 }  { m_axi_gmem1_1_AWPROT QOS 1 3 }  { m_axi_gmem1_1_AWQOS REGION 1 4 }  { m_axi_gmem1_1_AWREGION USER 1 4 }  { m_axi_gmem1_1_AWUSER DATA 1 1 }  { m_axi_gmem1_1_WVALID VALID 1 1 }  { m_axi_gmem1_1_WREADY READY 0 1 }  { m_axi_gmem1_1_WDATA FIFONUM 1 64 }  { m_axi_gmem1_1_WSTRB STRB 1 8 }  { m_axi_gmem1_1_WLAST LAST 1 1 }  { m_axi_gmem1_1_WID ID 1 1 }  { m_axi_gmem1_1_WUSER DATA 1 1 }  { m_axi_gmem1_1_ARVALID VALID 1 1 }  { m_axi_gmem1_1_ARREADY READY 0 1 }  { m_axi_gmem1_1_ARADDR ADDR 1 64 }  { m_axi_gmem1_1_ARID ID 1 1 }  { m_axi_gmem1_1_ARLEN SIZE 1 8 }  { m_axi_gmem1_1_ARSIZE BURST 1 3 }  { m_axi_gmem1_1_ARBURST LOCK 1 2 }  { m_axi_gmem1_1_ARLOCK CACHE 1 2 }  { m_axi_gmem1_1_ARCACHE PROT 1 4 }  { m_axi_gmem1_1_ARPROT QOS 1 3 }  { m_axi_gmem1_1_ARQOS REGION 1 4 }  { m_axi_gmem1_1_ARREGION USER 1 4 }  { m_axi_gmem1_1_ARUSER DATA 1 1 }  { m_axi_gmem1_1_RVALID VALID 0 1 }  { m_axi_gmem1_1_RREADY READY 1 1 }  { m_axi_gmem1_1_RDATA FIFONUM 0 64 }  { m_axi_gmem1_1_RLAST LAST 0 1 }  { m_axi_gmem1_1_RID ID 0 1 }  { m_axi_gmem1_1_RUSER DATA 0 1 }  { m_axi_gmem1_1_RRESP RESP 0 2 }  { m_axi_gmem1_1_BVALID VALID 0 1 }  { m_axi_gmem1_1_BREADY READY 1 1 }  { m_axi_gmem1_1_BRESP RESP 0 2 }  { m_axi_gmem1_1_BID ID 0 1 }  { m_axi_gmem1_1_BUSER DATA 0 1 } } }
	gmem2_0 { m_axi {  { m_axi_gmem2_0_AWVALID VALID 1 1 }  { m_axi_gmem2_0_AWREADY READY 0 1 }  { m_axi_gmem2_0_AWADDR ADDR 1 64 }  { m_axi_gmem2_0_AWID ID 1 1 }  { m_axi_gmem2_0_AWLEN SIZE 1 8 }  { m_axi_gmem2_0_AWSIZE BURST 1 3 }  { m_axi_gmem2_0_AWBURST LOCK 1 2 }  { m_axi_gmem2_0_AWLOCK CACHE 1 2 }  { m_axi_gmem2_0_AWCACHE PROT 1 4 }  { m_axi_gmem2_0_AWPROT QOS 1 3 }  { m_axi_gmem2_0_AWQOS REGION 1 4 }  { m_axi_gmem2_0_AWREGION USER 1 4 }  { m_axi_gmem2_0_AWUSER DATA 1 1 }  { m_axi_gmem2_0_WVALID VALID 1 1 }  { m_axi_gmem2_0_WREADY READY 0 1 }  { m_axi_gmem2_0_WDATA FIFONUM 1 128 }  { m_axi_gmem2_0_WSTRB STRB 1 16 }  { m_axi_gmem2_0_WLAST LAST 1 1 }  { m_axi_gmem2_0_WID ID 1 1 }  { m_axi_gmem2_0_WUSER DATA 1 1 }  { m_axi_gmem2_0_ARVALID VALID 1 1 }  { m_axi_gmem2_0_ARREADY READY 0 1 }  { m_axi_gmem2_0_ARADDR ADDR 1 64 }  { m_axi_gmem2_0_ARID ID 1 1 }  { m_axi_gmem2_0_ARLEN SIZE 1 8 }  { m_axi_gmem2_0_ARSIZE BURST 1 3 }  { m_axi_gmem2_0_ARBURST LOCK 1 2 }  { m_axi_gmem2_0_ARLOCK CACHE 1 2 }  { m_axi_gmem2_0_ARCACHE PROT 1 4 }  { m_axi_gmem2_0_ARPROT QOS 1 3 }  { m_axi_gmem2_0_ARQOS REGION 1 4 }  { m_axi_gmem2_0_ARREGION USER 1 4 }  { m_axi_gmem2_0_ARUSER DATA 1 1 }  { m_axi_gmem2_0_RVALID VALID 0 1 }  { m_axi_gmem2_0_RREADY READY 1 1 }  { m_axi_gmem2_0_RDATA FIFONUM 0 128 }  { m_axi_gmem2_0_RLAST LAST 0 1 }  { m_axi_gmem2_0_RID ID 0 1 }  { m_axi_gmem2_0_RUSER DATA 0 1 }  { m_axi_gmem2_0_RRESP RESP 0 2 }  { m_axi_gmem2_0_BVALID VALID 0 1 }  { m_axi_gmem2_0_BREADY READY 1 1 }  { m_axi_gmem2_0_BRESP RESP 0 2 }  { m_axi_gmem2_0_BID ID 0 1 }  { m_axi_gmem2_0_BUSER DATA 0 1 } } }
	gmem2_1 { m_axi {  { m_axi_gmem2_1_AWVALID VALID 1 1 }  { m_axi_gmem2_1_AWREADY READY 0 1 }  { m_axi_gmem2_1_AWADDR ADDR 1 64 }  { m_axi_gmem2_1_AWID ID 1 1 }  { m_axi_gmem2_1_AWLEN SIZE 1 8 }  { m_axi_gmem2_1_AWSIZE BURST 1 3 }  { m_axi_gmem2_1_AWBURST LOCK 1 2 }  { m_axi_gmem2_1_AWLOCK CACHE 1 2 }  { m_axi_gmem2_1_AWCACHE PROT 1 4 }  { m_axi_gmem2_1_AWPROT QOS 1 3 }  { m_axi_gmem2_1_AWQOS REGION 1 4 }  { m_axi_gmem2_1_AWREGION USER 1 4 }  { m_axi_gmem2_1_AWUSER DATA 1 1 }  { m_axi_gmem2_1_WVALID VALID 1 1 }  { m_axi_gmem2_1_WREADY READY 0 1 }  { m_axi_gmem2_1_WDATA FIFONUM 1 128 }  { m_axi_gmem2_1_WSTRB STRB 1 16 }  { m_axi_gmem2_1_WLAST LAST 1 1 }  { m_axi_gmem2_1_WID ID 1 1 }  { m_axi_gmem2_1_WUSER DATA 1 1 }  { m_axi_gmem2_1_ARVALID VALID 1 1 }  { m_axi_gmem2_1_ARREADY READY 0 1 }  { m_axi_gmem2_1_ARADDR ADDR 1 64 }  { m_axi_gmem2_1_ARID ID 1 1 }  { m_axi_gmem2_1_ARLEN SIZE 1 8 }  { m_axi_gmem2_1_ARSIZE BURST 1 3 }  { m_axi_gmem2_1_ARBURST LOCK 1 2 }  { m_axi_gmem2_1_ARLOCK CACHE 1 2 }  { m_axi_gmem2_1_ARCACHE PROT 1 4 }  { m_axi_gmem2_1_ARPROT QOS 1 3 }  { m_axi_gmem2_1_ARQOS REGION 1 4 }  { m_axi_gmem2_1_ARREGION USER 1 4 }  { m_axi_gmem2_1_ARUSER DATA 1 1 }  { m_axi_gmem2_1_RVALID VALID 0 1 }  { m_axi_gmem2_1_RREADY READY 1 1 }  { m_axi_gmem2_1_RDATA FIFONUM 0 128 }  { m_axi_gmem2_1_RLAST LAST 0 1 }  { m_axi_gmem2_1_RID ID 0 1 }  { m_axi_gmem2_1_RUSER DATA 0 1 }  { m_axi_gmem2_1_RRESP RESP 0 2 }  { m_axi_gmem2_1_BVALID VALID 0 1 }  { m_axi_gmem2_1_BREADY READY 1 1 }  { m_axi_gmem2_1_BRESP RESP 0 2 }  { m_axi_gmem2_1_BID ID 0 1 }  { m_axi_gmem2_1_BUSER DATA 0 1 } } }
}

set maxi_interface_dict [dict create]
dict set maxi_interface_dict gmem0_0 { CHANNEL_NUM 0 BUNDLE gmem0_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_1 { CHANNEL_NUM 0 BUNDLE gmem0_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_0 { CHANNEL_NUM 0 BUNDLE gmem1_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_1 { CHANNEL_NUM 0 BUNDLE gmem1_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem2_0 { CHANNEL_NUM 0 BUNDLE gmem2_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_1 { CHANNEL_NUM 0 BUNDLE gmem2_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ gmem0_0 64 }
	{ gmem0_1 64 }
	{ gmem1_0 64 }
	{ gmem1_1 64 }
	{ gmem2_0 64 }
	{ gmem2_1 64 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ gmem0_0 64 }
	{ gmem0_1 64 }
	{ gmem1_0 64 }
	{ gmem1_1 64 }
	{ gmem2_0 64 }
	{ gmem2_1 64 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
