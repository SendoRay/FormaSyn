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
	{ gmem0_0 int 32 regular {axi_master 0}  }
	{ gmem0_1 int 32 regular {axi_master 0}  }
	{ gmem0_2 int 32 regular {axi_master 0}  }
	{ gmem0_3 int 32 regular {axi_master 0}  }
	{ gmem1_0 int 32 regular {axi_master 0}  }
	{ gmem1_1 int 32 regular {axi_master 0}  }
	{ gmem1_2 int 32 regular {axi_master 0}  }
	{ gmem1_3 int 32 regular {axi_master 0}  }
	{ gmem2_0 int 64 regular {axi_master 1}  }
	{ gmem2_1 int 64 regular {axi_master 1}  }
	{ gmem2_2 int 64 regular {axi_master 1}  }
	{ gmem2_3 int 64 regular {axi_master 1}  }
	{ a_0 int 64 regular {axi_slave 0}  }
	{ a_1 int 64 regular {axi_slave 0}  }
	{ a_2 int 64 regular {axi_slave 0}  }
	{ a_3 int 64 regular {axi_slave 0}  }
	{ b_0 int 64 regular {axi_slave 0}  }
	{ b_1 int 64 regular {axi_slave 0}  }
	{ b_2 int 64 regular {axi_slave 0}  }
	{ b_3 int 64 regular {axi_slave 0}  }
	{ c_0 int 64 regular {axi_slave 0}  }
	{ c_1 int 64 regular {axi_slave 0}  }
	{ c_2 int 64 regular {axi_slave 0}  }
	{ c_3 int 64 regular {axi_slave 0}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "gmem0_0", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_0","offset": { "type": "dynamic","port_name": "a_0","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_1", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_1","offset": { "type": "dynamic","port_name": "a_1","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_2", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_2","offset": { "type": "dynamic","port_name": "a_2","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_3", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_3","offset": { "type": "dynamic","port_name": "a_3","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_0", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_0","offset": { "type": "dynamic","port_name": "b_0","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_1", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_1","offset": { "type": "dynamic","port_name": "b_1","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_2", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_2","offset": { "type": "dynamic","port_name": "b_2","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_3", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_3","offset": { "type": "dynamic","port_name": "b_3","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem2_0", "interface" : "axi_master", "bitwidth" : 64, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_0","offset": { "type": "dynamic","port_name": "c_0","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_1", "interface" : "axi_master", "bitwidth" : 64, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_1","offset": { "type": "dynamic","port_name": "c_1","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_2", "interface" : "axi_master", "bitwidth" : 64, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_2","offset": { "type": "dynamic","port_name": "c_2","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_3", "interface" : "axi_master", "bitwidth" : 64, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_3","offset": { "type": "dynamic","port_name": "c_3","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "a_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":16}, "offset_end" : {"in":27}} , 
 	{ "Name" : "a_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":28}, "offset_end" : {"in":39}} , 
 	{ "Name" : "a_2", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":40}, "offset_end" : {"in":51}} , 
 	{ "Name" : "a_3", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":52}, "offset_end" : {"in":63}} , 
 	{ "Name" : "b_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":64}, "offset_end" : {"in":75}} , 
 	{ "Name" : "b_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":76}, "offset_end" : {"in":87}} , 
 	{ "Name" : "b_2", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":88}, "offset_end" : {"in":99}} , 
 	{ "Name" : "b_3", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":100}, "offset_end" : {"in":111}} , 
 	{ "Name" : "c_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":112}, "offset_end" : {"in":123}} , 
 	{ "Name" : "c_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":124}, "offset_end" : {"in":135}} , 
 	{ "Name" : "c_2", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":136}, "offset_end" : {"in":147}} , 
 	{ "Name" : "c_3", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":148}, "offset_end" : {"in":159}} ]}
# RTL Port declarations: 
set portNum 560
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
	{ m_axi_gmem0_0_WDATA sc_out sc_lv 32 signal 0 } 
	{ m_axi_gmem0_0_WSTRB sc_out sc_lv 4 signal 0 } 
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
	{ m_axi_gmem0_0_RDATA sc_in sc_lv 32 signal 0 } 
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
	{ m_axi_gmem0_1_WDATA sc_out sc_lv 32 signal 1 } 
	{ m_axi_gmem0_1_WSTRB sc_out sc_lv 4 signal 1 } 
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
	{ m_axi_gmem0_1_RDATA sc_in sc_lv 32 signal 1 } 
	{ m_axi_gmem0_1_RLAST sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_RID sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_RUSER sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_RRESP sc_in sc_lv 2 signal 1 } 
	{ m_axi_gmem0_1_BVALID sc_in sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_BREADY sc_out sc_logic 1 signal 1 } 
	{ m_axi_gmem0_1_BRESP sc_in sc_lv 2 signal 1 } 
	{ m_axi_gmem0_1_BID sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem0_1_BUSER sc_in sc_lv 1 signal 1 } 
	{ m_axi_gmem0_2_AWVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_AWREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_AWADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem0_2_AWID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_AWLEN sc_out sc_lv 8 signal 2 } 
	{ m_axi_gmem0_2_AWSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem0_2_AWBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem0_2_AWLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem0_2_AWCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem0_2_AWPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem0_2_AWQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem0_2_AWREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem0_2_AWUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_WVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_WREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_WDATA sc_out sc_lv 32 signal 2 } 
	{ m_axi_gmem0_2_WSTRB sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem0_2_WLAST sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_WID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_WUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_ARVALID sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_ARREADY sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_ARADDR sc_out sc_lv 64 signal 2 } 
	{ m_axi_gmem0_2_ARID sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_ARLEN sc_out sc_lv 8 signal 2 } 
	{ m_axi_gmem0_2_ARSIZE sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem0_2_ARBURST sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem0_2_ARLOCK sc_out sc_lv 2 signal 2 } 
	{ m_axi_gmem0_2_ARCACHE sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem0_2_ARPROT sc_out sc_lv 3 signal 2 } 
	{ m_axi_gmem0_2_ARQOS sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem0_2_ARREGION sc_out sc_lv 4 signal 2 } 
	{ m_axi_gmem0_2_ARUSER sc_out sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_RVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_RREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_RDATA sc_in sc_lv 32 signal 2 } 
	{ m_axi_gmem0_2_RLAST sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_RID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_RUSER sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_RRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem0_2_BVALID sc_in sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_BREADY sc_out sc_logic 1 signal 2 } 
	{ m_axi_gmem0_2_BRESP sc_in sc_lv 2 signal 2 } 
	{ m_axi_gmem0_2_BID sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem0_2_BUSER sc_in sc_lv 1 signal 2 } 
	{ m_axi_gmem0_3_AWVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_AWREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_AWADDR sc_out sc_lv 64 signal 3 } 
	{ m_axi_gmem0_3_AWID sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_AWLEN sc_out sc_lv 8 signal 3 } 
	{ m_axi_gmem0_3_AWSIZE sc_out sc_lv 3 signal 3 } 
	{ m_axi_gmem0_3_AWBURST sc_out sc_lv 2 signal 3 } 
	{ m_axi_gmem0_3_AWLOCK sc_out sc_lv 2 signal 3 } 
	{ m_axi_gmem0_3_AWCACHE sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem0_3_AWPROT sc_out sc_lv 3 signal 3 } 
	{ m_axi_gmem0_3_AWQOS sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem0_3_AWREGION sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem0_3_AWUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_WVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_WREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_WDATA sc_out sc_lv 32 signal 3 } 
	{ m_axi_gmem0_3_WSTRB sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem0_3_WLAST sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_WID sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_WUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_ARVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_ARREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_ARADDR sc_out sc_lv 64 signal 3 } 
	{ m_axi_gmem0_3_ARID sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_ARLEN sc_out sc_lv 8 signal 3 } 
	{ m_axi_gmem0_3_ARSIZE sc_out sc_lv 3 signal 3 } 
	{ m_axi_gmem0_3_ARBURST sc_out sc_lv 2 signal 3 } 
	{ m_axi_gmem0_3_ARLOCK sc_out sc_lv 2 signal 3 } 
	{ m_axi_gmem0_3_ARCACHE sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem0_3_ARPROT sc_out sc_lv 3 signal 3 } 
	{ m_axi_gmem0_3_ARQOS sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem0_3_ARREGION sc_out sc_lv 4 signal 3 } 
	{ m_axi_gmem0_3_ARUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_RVALID sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_RREADY sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_RDATA sc_in sc_lv 32 signal 3 } 
	{ m_axi_gmem0_3_RLAST sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_RID sc_in sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_RUSER sc_in sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_RRESP sc_in sc_lv 2 signal 3 } 
	{ m_axi_gmem0_3_BVALID sc_in sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_BREADY sc_out sc_logic 1 signal 3 } 
	{ m_axi_gmem0_3_BRESP sc_in sc_lv 2 signal 3 } 
	{ m_axi_gmem0_3_BID sc_in sc_lv 1 signal 3 } 
	{ m_axi_gmem0_3_BUSER sc_in sc_lv 1 signal 3 } 
	{ m_axi_gmem1_0_AWVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_AWREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_AWADDR sc_out sc_lv 64 signal 4 } 
	{ m_axi_gmem1_0_AWID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_AWLEN sc_out sc_lv 8 signal 4 } 
	{ m_axi_gmem1_0_AWSIZE sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem1_0_AWBURST sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem1_0_AWLOCK sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem1_0_AWCACHE sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem1_0_AWPROT sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem1_0_AWQOS sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem1_0_AWREGION sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem1_0_AWUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_WVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_WREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_WDATA sc_out sc_lv 32 signal 4 } 
	{ m_axi_gmem1_0_WSTRB sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem1_0_WLAST sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_WID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_WUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_ARVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_ARREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_ARADDR sc_out sc_lv 64 signal 4 } 
	{ m_axi_gmem1_0_ARID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_ARLEN sc_out sc_lv 8 signal 4 } 
	{ m_axi_gmem1_0_ARSIZE sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem1_0_ARBURST sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem1_0_ARLOCK sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem1_0_ARCACHE sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem1_0_ARPROT sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem1_0_ARQOS sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem1_0_ARREGION sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem1_0_ARUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_RVALID sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_RREADY sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_RDATA sc_in sc_lv 32 signal 4 } 
	{ m_axi_gmem1_0_RLAST sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_RID sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_RUSER sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_RRESP sc_in sc_lv 2 signal 4 } 
	{ m_axi_gmem1_0_BVALID sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_BREADY sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem1_0_BRESP sc_in sc_lv 2 signal 4 } 
	{ m_axi_gmem1_0_BID sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem1_0_BUSER sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem1_1_AWVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_AWREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_AWADDR sc_out sc_lv 64 signal 5 } 
	{ m_axi_gmem1_1_AWID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_AWLEN sc_out sc_lv 8 signal 5 } 
	{ m_axi_gmem1_1_AWSIZE sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem1_1_AWBURST sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem1_1_AWLOCK sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem1_1_AWCACHE sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem1_1_AWPROT sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem1_1_AWQOS sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem1_1_AWREGION sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem1_1_AWUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_WVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_WREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_WDATA sc_out sc_lv 32 signal 5 } 
	{ m_axi_gmem1_1_WSTRB sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem1_1_WLAST sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_WID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_WUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_ARVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_ARREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_ARADDR sc_out sc_lv 64 signal 5 } 
	{ m_axi_gmem1_1_ARID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_ARLEN sc_out sc_lv 8 signal 5 } 
	{ m_axi_gmem1_1_ARSIZE sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem1_1_ARBURST sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem1_1_ARLOCK sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem1_1_ARCACHE sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem1_1_ARPROT sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem1_1_ARQOS sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem1_1_ARREGION sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem1_1_ARUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_RVALID sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_RREADY sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_RDATA sc_in sc_lv 32 signal 5 } 
	{ m_axi_gmem1_1_RLAST sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_RID sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_RUSER sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_RRESP sc_in sc_lv 2 signal 5 } 
	{ m_axi_gmem1_1_BVALID sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_BREADY sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem1_1_BRESP sc_in sc_lv 2 signal 5 } 
	{ m_axi_gmem1_1_BID sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem1_1_BUSER sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem1_2_AWVALID sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_AWREADY sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_AWADDR sc_out sc_lv 64 signal 6 } 
	{ m_axi_gmem1_2_AWID sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_AWLEN sc_out sc_lv 8 signal 6 } 
	{ m_axi_gmem1_2_AWSIZE sc_out sc_lv 3 signal 6 } 
	{ m_axi_gmem1_2_AWBURST sc_out sc_lv 2 signal 6 } 
	{ m_axi_gmem1_2_AWLOCK sc_out sc_lv 2 signal 6 } 
	{ m_axi_gmem1_2_AWCACHE sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem1_2_AWPROT sc_out sc_lv 3 signal 6 } 
	{ m_axi_gmem1_2_AWQOS sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem1_2_AWREGION sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem1_2_AWUSER sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_WVALID sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_WREADY sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_WDATA sc_out sc_lv 32 signal 6 } 
	{ m_axi_gmem1_2_WSTRB sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem1_2_WLAST sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_WID sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_WUSER sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_ARVALID sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_ARREADY sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_ARADDR sc_out sc_lv 64 signal 6 } 
	{ m_axi_gmem1_2_ARID sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_ARLEN sc_out sc_lv 8 signal 6 } 
	{ m_axi_gmem1_2_ARSIZE sc_out sc_lv 3 signal 6 } 
	{ m_axi_gmem1_2_ARBURST sc_out sc_lv 2 signal 6 } 
	{ m_axi_gmem1_2_ARLOCK sc_out sc_lv 2 signal 6 } 
	{ m_axi_gmem1_2_ARCACHE sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem1_2_ARPROT sc_out sc_lv 3 signal 6 } 
	{ m_axi_gmem1_2_ARQOS sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem1_2_ARREGION sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem1_2_ARUSER sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_RVALID sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_RREADY sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_RDATA sc_in sc_lv 32 signal 6 } 
	{ m_axi_gmem1_2_RLAST sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_RID sc_in sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_RUSER sc_in sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_RRESP sc_in sc_lv 2 signal 6 } 
	{ m_axi_gmem1_2_BVALID sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_BREADY sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem1_2_BRESP sc_in sc_lv 2 signal 6 } 
	{ m_axi_gmem1_2_BID sc_in sc_lv 1 signal 6 } 
	{ m_axi_gmem1_2_BUSER sc_in sc_lv 1 signal 6 } 
	{ m_axi_gmem1_3_AWVALID sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_AWREADY sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_AWADDR sc_out sc_lv 64 signal 7 } 
	{ m_axi_gmem1_3_AWID sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_AWLEN sc_out sc_lv 8 signal 7 } 
	{ m_axi_gmem1_3_AWSIZE sc_out sc_lv 3 signal 7 } 
	{ m_axi_gmem1_3_AWBURST sc_out sc_lv 2 signal 7 } 
	{ m_axi_gmem1_3_AWLOCK sc_out sc_lv 2 signal 7 } 
	{ m_axi_gmem1_3_AWCACHE sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem1_3_AWPROT sc_out sc_lv 3 signal 7 } 
	{ m_axi_gmem1_3_AWQOS sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem1_3_AWREGION sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem1_3_AWUSER sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_WVALID sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_WREADY sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_WDATA sc_out sc_lv 32 signal 7 } 
	{ m_axi_gmem1_3_WSTRB sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem1_3_WLAST sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_WID sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_WUSER sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_ARVALID sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_ARREADY sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_ARADDR sc_out sc_lv 64 signal 7 } 
	{ m_axi_gmem1_3_ARID sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_ARLEN sc_out sc_lv 8 signal 7 } 
	{ m_axi_gmem1_3_ARSIZE sc_out sc_lv 3 signal 7 } 
	{ m_axi_gmem1_3_ARBURST sc_out sc_lv 2 signal 7 } 
	{ m_axi_gmem1_3_ARLOCK sc_out sc_lv 2 signal 7 } 
	{ m_axi_gmem1_3_ARCACHE sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem1_3_ARPROT sc_out sc_lv 3 signal 7 } 
	{ m_axi_gmem1_3_ARQOS sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem1_3_ARREGION sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem1_3_ARUSER sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_RVALID sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_RREADY sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_RDATA sc_in sc_lv 32 signal 7 } 
	{ m_axi_gmem1_3_RLAST sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_RID sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_RUSER sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_RRESP sc_in sc_lv 2 signal 7 } 
	{ m_axi_gmem1_3_BVALID sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_BREADY sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem1_3_BRESP sc_in sc_lv 2 signal 7 } 
	{ m_axi_gmem1_3_BID sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem1_3_BUSER sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem2_0_AWVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_AWREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_AWADDR sc_out sc_lv 64 signal 8 } 
	{ m_axi_gmem2_0_AWID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_AWLEN sc_out sc_lv 8 signal 8 } 
	{ m_axi_gmem2_0_AWSIZE sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem2_0_AWBURST sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem2_0_AWLOCK sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem2_0_AWCACHE sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem2_0_AWPROT sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem2_0_AWQOS sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem2_0_AWREGION sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem2_0_AWUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_WVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_WREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_WDATA sc_out sc_lv 64 signal 8 } 
	{ m_axi_gmem2_0_WSTRB sc_out sc_lv 8 signal 8 } 
	{ m_axi_gmem2_0_WLAST sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_WID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_WUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_ARVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_ARREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_ARADDR sc_out sc_lv 64 signal 8 } 
	{ m_axi_gmem2_0_ARID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_ARLEN sc_out sc_lv 8 signal 8 } 
	{ m_axi_gmem2_0_ARSIZE sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem2_0_ARBURST sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem2_0_ARLOCK sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem2_0_ARCACHE sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem2_0_ARPROT sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem2_0_ARQOS sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem2_0_ARREGION sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem2_0_ARUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_RVALID sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_RREADY sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_RDATA sc_in sc_lv 64 signal 8 } 
	{ m_axi_gmem2_0_RLAST sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_RID sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_RUSER sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_RRESP sc_in sc_lv 2 signal 8 } 
	{ m_axi_gmem2_0_BVALID sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_BREADY sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem2_0_BRESP sc_in sc_lv 2 signal 8 } 
	{ m_axi_gmem2_0_BID sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem2_0_BUSER sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem2_1_AWVALID sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_AWREADY sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_AWADDR sc_out sc_lv 64 signal 9 } 
	{ m_axi_gmem2_1_AWID sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_AWLEN sc_out sc_lv 8 signal 9 } 
	{ m_axi_gmem2_1_AWSIZE sc_out sc_lv 3 signal 9 } 
	{ m_axi_gmem2_1_AWBURST sc_out sc_lv 2 signal 9 } 
	{ m_axi_gmem2_1_AWLOCK sc_out sc_lv 2 signal 9 } 
	{ m_axi_gmem2_1_AWCACHE sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem2_1_AWPROT sc_out sc_lv 3 signal 9 } 
	{ m_axi_gmem2_1_AWQOS sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem2_1_AWREGION sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem2_1_AWUSER sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_WVALID sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_WREADY sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_WDATA sc_out sc_lv 64 signal 9 } 
	{ m_axi_gmem2_1_WSTRB sc_out sc_lv 8 signal 9 } 
	{ m_axi_gmem2_1_WLAST sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_WID sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_WUSER sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_ARVALID sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_ARREADY sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_ARADDR sc_out sc_lv 64 signal 9 } 
	{ m_axi_gmem2_1_ARID sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_ARLEN sc_out sc_lv 8 signal 9 } 
	{ m_axi_gmem2_1_ARSIZE sc_out sc_lv 3 signal 9 } 
	{ m_axi_gmem2_1_ARBURST sc_out sc_lv 2 signal 9 } 
	{ m_axi_gmem2_1_ARLOCK sc_out sc_lv 2 signal 9 } 
	{ m_axi_gmem2_1_ARCACHE sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem2_1_ARPROT sc_out sc_lv 3 signal 9 } 
	{ m_axi_gmem2_1_ARQOS sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem2_1_ARREGION sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem2_1_ARUSER sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_RVALID sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_RREADY sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_RDATA sc_in sc_lv 64 signal 9 } 
	{ m_axi_gmem2_1_RLAST sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_RID sc_in sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_RUSER sc_in sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_RRESP sc_in sc_lv 2 signal 9 } 
	{ m_axi_gmem2_1_BVALID sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_BREADY sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem2_1_BRESP sc_in sc_lv 2 signal 9 } 
	{ m_axi_gmem2_1_BID sc_in sc_lv 1 signal 9 } 
	{ m_axi_gmem2_1_BUSER sc_in sc_lv 1 signal 9 } 
	{ m_axi_gmem2_2_AWVALID sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_AWREADY sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_AWADDR sc_out sc_lv 64 signal 10 } 
	{ m_axi_gmem2_2_AWID sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_AWLEN sc_out sc_lv 8 signal 10 } 
	{ m_axi_gmem2_2_AWSIZE sc_out sc_lv 3 signal 10 } 
	{ m_axi_gmem2_2_AWBURST sc_out sc_lv 2 signal 10 } 
	{ m_axi_gmem2_2_AWLOCK sc_out sc_lv 2 signal 10 } 
	{ m_axi_gmem2_2_AWCACHE sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem2_2_AWPROT sc_out sc_lv 3 signal 10 } 
	{ m_axi_gmem2_2_AWQOS sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem2_2_AWREGION sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem2_2_AWUSER sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_WVALID sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_WREADY sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_WDATA sc_out sc_lv 64 signal 10 } 
	{ m_axi_gmem2_2_WSTRB sc_out sc_lv 8 signal 10 } 
	{ m_axi_gmem2_2_WLAST sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_WID sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_WUSER sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_ARVALID sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_ARREADY sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_ARADDR sc_out sc_lv 64 signal 10 } 
	{ m_axi_gmem2_2_ARID sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_ARLEN sc_out sc_lv 8 signal 10 } 
	{ m_axi_gmem2_2_ARSIZE sc_out sc_lv 3 signal 10 } 
	{ m_axi_gmem2_2_ARBURST sc_out sc_lv 2 signal 10 } 
	{ m_axi_gmem2_2_ARLOCK sc_out sc_lv 2 signal 10 } 
	{ m_axi_gmem2_2_ARCACHE sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem2_2_ARPROT sc_out sc_lv 3 signal 10 } 
	{ m_axi_gmem2_2_ARQOS sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem2_2_ARREGION sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem2_2_ARUSER sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_RVALID sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_RREADY sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_RDATA sc_in sc_lv 64 signal 10 } 
	{ m_axi_gmem2_2_RLAST sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_RID sc_in sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_RUSER sc_in sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_RRESP sc_in sc_lv 2 signal 10 } 
	{ m_axi_gmem2_2_BVALID sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_BREADY sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem2_2_BRESP sc_in sc_lv 2 signal 10 } 
	{ m_axi_gmem2_2_BID sc_in sc_lv 1 signal 10 } 
	{ m_axi_gmem2_2_BUSER sc_in sc_lv 1 signal 10 } 
	{ m_axi_gmem2_3_AWVALID sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_AWREADY sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_AWADDR sc_out sc_lv 64 signal 11 } 
	{ m_axi_gmem2_3_AWID sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_AWLEN sc_out sc_lv 8 signal 11 } 
	{ m_axi_gmem2_3_AWSIZE sc_out sc_lv 3 signal 11 } 
	{ m_axi_gmem2_3_AWBURST sc_out sc_lv 2 signal 11 } 
	{ m_axi_gmem2_3_AWLOCK sc_out sc_lv 2 signal 11 } 
	{ m_axi_gmem2_3_AWCACHE sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem2_3_AWPROT sc_out sc_lv 3 signal 11 } 
	{ m_axi_gmem2_3_AWQOS sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem2_3_AWREGION sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem2_3_AWUSER sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_WVALID sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_WREADY sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_WDATA sc_out sc_lv 64 signal 11 } 
	{ m_axi_gmem2_3_WSTRB sc_out sc_lv 8 signal 11 } 
	{ m_axi_gmem2_3_WLAST sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_WID sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_WUSER sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_ARVALID sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_ARREADY sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_ARADDR sc_out sc_lv 64 signal 11 } 
	{ m_axi_gmem2_3_ARID sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_ARLEN sc_out sc_lv 8 signal 11 } 
	{ m_axi_gmem2_3_ARSIZE sc_out sc_lv 3 signal 11 } 
	{ m_axi_gmem2_3_ARBURST sc_out sc_lv 2 signal 11 } 
	{ m_axi_gmem2_3_ARLOCK sc_out sc_lv 2 signal 11 } 
	{ m_axi_gmem2_3_ARCACHE sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem2_3_ARPROT sc_out sc_lv 3 signal 11 } 
	{ m_axi_gmem2_3_ARQOS sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem2_3_ARREGION sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem2_3_ARUSER sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_RVALID sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_RREADY sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_RDATA sc_in sc_lv 64 signal 11 } 
	{ m_axi_gmem2_3_RLAST sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_RID sc_in sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_RUSER sc_in sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_RRESP sc_in sc_lv 2 signal 11 } 
	{ m_axi_gmem2_3_BVALID sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_BREADY sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem2_3_BRESP sc_in sc_lv 2 signal 11 } 
	{ m_axi_gmem2_3_BID sc_in sc_lv 1 signal 11 } 
	{ m_axi_gmem2_3_BUSER sc_in sc_lv 1 signal 11 } 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 8 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 8 signal -1 } 
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
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"kernel","role":"start","value":"0","valid_bit":"0"},{"name":"kernel","role":"continue","value":"0","valid_bit":"4"},{"name":"kernel","role":"auto_start","value":"0","valid_bit":"7"},{"name":"a_0","role":"data","value":"16"},{"name":"a_1","role":"data","value":"28"},{"name":"a_2","role":"data","value":"40"},{"name":"a_3","role":"data","value":"52"},{"name":"b_0","role":"data","value":"64"},{"name":"b_1","role":"data","value":"76"},{"name":"b_2","role":"data","value":"88"},{"name":"b_3","role":"data","value":"100"},{"name":"c_0","role":"data","value":"112"},{"name":"c_1","role":"data","value":"124"},{"name":"c_2","role":"data","value":"136"},{"name":"c_3","role":"data","value":"148"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"kernel","role":"start","value":"0","valid_bit":"0"},{"name":"kernel","role":"done","value":"0","valid_bit":"1"},{"name":"kernel","role":"idle","value":"0","valid_bit":"2"},{"name":"kernel","role":"ready","value":"0","valid_bit":"3"},{"name":"kernel","role":"auto_start","value":"0","valid_bit":"7"}] },
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
 	{ "name": "m_axi_gmem0_0_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_0_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_0", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem0_0_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_0", "role": "RDATA" }} , 
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
 	{ "name": "m_axi_gmem0_1_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_1_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_1", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem0_1_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_1_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_1_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_1_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_1_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_1", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_1_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_1_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_1_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_1_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_1_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_1", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem0_2_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem0_2_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem0_2_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem0_2_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem0_2_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem0_2_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem0_2_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem0_2_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem0_2_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem0_2_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem0_2_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem0_2_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem0_2_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem0_2_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem0_2_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem0_2_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_2", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_2_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_2", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem0_2_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem0_2_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "WID" }} , 
 	{ "name": "m_axi_gmem0_2_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem0_2_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem0_2_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem0_2_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem0_2_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem0_2_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem0_2_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem0_2_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem0_2_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem0_2_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem0_2_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem0_2_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem0_2_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem0_2_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem0_2_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem0_2_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem0_2_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_2", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_2_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_2_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_2_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_2_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_2", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_2_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_2_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_2_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_2", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_2_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_2_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_2", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem0_3_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem0_3_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem0_3_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem0_3_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem0_3_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem0_3_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem0_3_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem0_3_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem0_3_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem0_3_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem0_3_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem0_3_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem0_3_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem0_3_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem0_3_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem0_3_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_3", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_3_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_3", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem0_3_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem0_3_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "WID" }} , 
 	{ "name": "m_axi_gmem0_3_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem0_3_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem0_3_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem0_3_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem0_3_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem0_3_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem0_3_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem0_3_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem0_3_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem0_3_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem0_3_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem0_3_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem0_3_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem0_3_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem0_3_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem0_3_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem0_3_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_3", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_3_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_3_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_3_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_3_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_3", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_3_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_3_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_3_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_3", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_3_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_3_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_3", "role": "BUSER" }} , 
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
 	{ "name": "m_axi_gmem1_0_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_0_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_0", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem1_0_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_0", "role": "RDATA" }} , 
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
 	{ "name": "m_axi_gmem1_1_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_1_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_1", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem1_1_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_1_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_1_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_1_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_1_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_1", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_1_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_1_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_1_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_1_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_1_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_1", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem1_2_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem1_2_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem1_2_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem1_2_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem1_2_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem1_2_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem1_2_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem1_2_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem1_2_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem1_2_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem1_2_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem1_2_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem1_2_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem1_2_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem1_2_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem1_2_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_2", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_2_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_2", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem1_2_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem1_2_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "WID" }} , 
 	{ "name": "m_axi_gmem1_2_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem1_2_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem1_2_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem1_2_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem1_2_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem1_2_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem1_2_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem1_2_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem1_2_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem1_2_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem1_2_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem1_2_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem1_2_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem1_2_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem1_2_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem1_2_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem1_2_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_2", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_2_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_2_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_2_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_2_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_2", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_2_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_2_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_2_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_2", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_2_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_2_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_2", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem1_3_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem1_3_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem1_3_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem1_3_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem1_3_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem1_3_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem1_3_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem1_3_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem1_3_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem1_3_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem1_3_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem1_3_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem1_3_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem1_3_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem1_3_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem1_3_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_3", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_3_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_3", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem1_3_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem1_3_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "WID" }} , 
 	{ "name": "m_axi_gmem1_3_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem1_3_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem1_3_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem1_3_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem1_3_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem1_3_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem1_3_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem1_3_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem1_3_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem1_3_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem1_3_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem1_3_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem1_3_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem1_3_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem1_3_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem1_3_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem1_3_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_3", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_3_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_3_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_3_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_3_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_3", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_3_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_3_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_3_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_3", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_3_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_3_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_3", "role": "BUSER" }} , 
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
 	{ "name": "m_axi_gmem2_0_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_0_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem2_0_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RDATA" }} , 
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
 	{ "name": "m_axi_gmem2_1_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_1_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem2_1_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_1_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_1_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_1_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_1_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_1_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_1_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_1_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_1_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_1_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_1", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem2_2_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem2_2_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem2_2_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem2_2_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem2_2_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem2_2_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem2_2_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem2_2_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem2_2_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem2_2_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem2_2_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem2_2_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem2_2_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem2_2_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem2_2_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem2_2_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_2_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem2_2_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem2_2_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WID" }} , 
 	{ "name": "m_axi_gmem2_2_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem2_2_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem2_2_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem2_2_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem2_2_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem2_2_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem2_2_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem2_2_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem2_2_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem2_2_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem2_2_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem2_2_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem2_2_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem2_2_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem2_2_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem2_2_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem2_2_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_2", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_2_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_2_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_2_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_2_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_2", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_2_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_2_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_2_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_2", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_2_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_2_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_2", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem2_3_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem2_3_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem2_3_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem2_3_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem2_3_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem2_3_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem2_3_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem2_3_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem2_3_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem2_3_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem2_3_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem2_3_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem2_3_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem2_3_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem2_3_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem2_3_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_3_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem2_3_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem2_3_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WID" }} , 
 	{ "name": "m_axi_gmem2_3_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem2_3_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem2_3_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem2_3_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem2_3_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem2_3_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem2_3_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem2_3_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem2_3_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem2_3_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem2_3_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem2_3_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem2_3_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem2_3_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem2_3_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem2_3_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem2_3_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_3_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_3_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_3_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_3_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_3_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_3_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_3_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_3_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_3_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BUSER" }}  ]}

set ArgLastReadFirstWriteLatency {
	kernel {
		gmem0_0 {Type I LastRead 72 FirstWrite -1}
		gmem0_1 {Type I LastRead 72 FirstWrite -1}
		gmem0_2 {Type I LastRead 72 FirstWrite -1}
		gmem0_3 {Type I LastRead 72 FirstWrite -1}
		gmem1_0 {Type I LastRead 72 FirstWrite -1}
		gmem1_1 {Type I LastRead 72 FirstWrite -1}
		gmem1_2 {Type I LastRead 72 FirstWrite -1}
		gmem1_3 {Type I LastRead 72 FirstWrite -1}
		gmem2_0 {Type O LastRead 77 FirstWrite 76}
		gmem2_1 {Type O LastRead 77 FirstWrite 76}
		gmem2_2 {Type O LastRead 77 FirstWrite 76}
		gmem2_3 {Type O LastRead 77 FirstWrite 76}
		a_0 {Type I LastRead 0 FirstWrite -1}
		a_1 {Type I LastRead 0 FirstWrite -1}
		a_2 {Type I LastRead 0 FirstWrite -1}
		a_3 {Type I LastRead 0 FirstWrite -1}
		b_0 {Type I LastRead 0 FirstWrite -1}
		b_1 {Type I LastRead 0 FirstWrite -1}
		b_2 {Type I LastRead 0 FirstWrite -1}
		b_3 {Type I LastRead 0 FirstWrite -1}
		c_0 {Type I LastRead 0 FirstWrite -1}
		c_1 {Type I LastRead 0 FirstWrite -1}
		c_2 {Type I LastRead 0 FirstWrite -1}
		c_3 {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "147", "Max" : "147"}
	, {"Name" : "Interval", "Min" : "148", "Max" : "148"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	gmem0_0 { m_axi {  { m_axi_gmem0_0_AWVALID VALID 1 1 }  { m_axi_gmem0_0_AWREADY READY 0 1 }  { m_axi_gmem0_0_AWADDR ADDR 1 64 }  { m_axi_gmem0_0_AWID ID 1 1 }  { m_axi_gmem0_0_AWLEN SIZE 1 8 }  { m_axi_gmem0_0_AWSIZE BURST 1 3 }  { m_axi_gmem0_0_AWBURST LOCK 1 2 }  { m_axi_gmem0_0_AWLOCK CACHE 1 2 }  { m_axi_gmem0_0_AWCACHE PROT 1 4 }  { m_axi_gmem0_0_AWPROT QOS 1 3 }  { m_axi_gmem0_0_AWQOS REGION 1 4 }  { m_axi_gmem0_0_AWREGION USER 1 4 }  { m_axi_gmem0_0_AWUSER DATA 1 1 }  { m_axi_gmem0_0_WVALID VALID 1 1 }  { m_axi_gmem0_0_WREADY READY 0 1 }  { m_axi_gmem0_0_WDATA FIFONUM 1 32 }  { m_axi_gmem0_0_WSTRB STRB 1 4 }  { m_axi_gmem0_0_WLAST LAST 1 1 }  { m_axi_gmem0_0_WID ID 1 1 }  { m_axi_gmem0_0_WUSER DATA 1 1 }  { m_axi_gmem0_0_ARVALID VALID 1 1 }  { m_axi_gmem0_0_ARREADY READY 0 1 }  { m_axi_gmem0_0_ARADDR ADDR 1 64 }  { m_axi_gmem0_0_ARID ID 1 1 }  { m_axi_gmem0_0_ARLEN SIZE 1 8 }  { m_axi_gmem0_0_ARSIZE BURST 1 3 }  { m_axi_gmem0_0_ARBURST LOCK 1 2 }  { m_axi_gmem0_0_ARLOCK CACHE 1 2 }  { m_axi_gmem0_0_ARCACHE PROT 1 4 }  { m_axi_gmem0_0_ARPROT QOS 1 3 }  { m_axi_gmem0_0_ARQOS REGION 1 4 }  { m_axi_gmem0_0_ARREGION USER 1 4 }  { m_axi_gmem0_0_ARUSER DATA 1 1 }  { m_axi_gmem0_0_RVALID VALID 0 1 }  { m_axi_gmem0_0_RREADY READY 1 1 }  { m_axi_gmem0_0_RDATA FIFONUM 0 32 }  { m_axi_gmem0_0_RLAST LAST 0 1 }  { m_axi_gmem0_0_RID ID 0 1 }  { m_axi_gmem0_0_RUSER DATA 0 1 }  { m_axi_gmem0_0_RRESP RESP 0 2 }  { m_axi_gmem0_0_BVALID VALID 0 1 }  { m_axi_gmem0_0_BREADY READY 1 1 }  { m_axi_gmem0_0_BRESP RESP 0 2 }  { m_axi_gmem0_0_BID ID 0 1 }  { m_axi_gmem0_0_BUSER DATA 0 1 } } }
	gmem0_1 { m_axi {  { m_axi_gmem0_1_AWVALID VALID 1 1 }  { m_axi_gmem0_1_AWREADY READY 0 1 }  { m_axi_gmem0_1_AWADDR ADDR 1 64 }  { m_axi_gmem0_1_AWID ID 1 1 }  { m_axi_gmem0_1_AWLEN SIZE 1 8 }  { m_axi_gmem0_1_AWSIZE BURST 1 3 }  { m_axi_gmem0_1_AWBURST LOCK 1 2 }  { m_axi_gmem0_1_AWLOCK CACHE 1 2 }  { m_axi_gmem0_1_AWCACHE PROT 1 4 }  { m_axi_gmem0_1_AWPROT QOS 1 3 }  { m_axi_gmem0_1_AWQOS REGION 1 4 }  { m_axi_gmem0_1_AWREGION USER 1 4 }  { m_axi_gmem0_1_AWUSER DATA 1 1 }  { m_axi_gmem0_1_WVALID VALID 1 1 }  { m_axi_gmem0_1_WREADY READY 0 1 }  { m_axi_gmem0_1_WDATA FIFONUM 1 32 }  { m_axi_gmem0_1_WSTRB STRB 1 4 }  { m_axi_gmem0_1_WLAST LAST 1 1 }  { m_axi_gmem0_1_WID ID 1 1 }  { m_axi_gmem0_1_WUSER DATA 1 1 }  { m_axi_gmem0_1_ARVALID VALID 1 1 }  { m_axi_gmem0_1_ARREADY READY 0 1 }  { m_axi_gmem0_1_ARADDR ADDR 1 64 }  { m_axi_gmem0_1_ARID ID 1 1 }  { m_axi_gmem0_1_ARLEN SIZE 1 8 }  { m_axi_gmem0_1_ARSIZE BURST 1 3 }  { m_axi_gmem0_1_ARBURST LOCK 1 2 }  { m_axi_gmem0_1_ARLOCK CACHE 1 2 }  { m_axi_gmem0_1_ARCACHE PROT 1 4 }  { m_axi_gmem0_1_ARPROT QOS 1 3 }  { m_axi_gmem0_1_ARQOS REGION 1 4 }  { m_axi_gmem0_1_ARREGION USER 1 4 }  { m_axi_gmem0_1_ARUSER DATA 1 1 }  { m_axi_gmem0_1_RVALID VALID 0 1 }  { m_axi_gmem0_1_RREADY READY 1 1 }  { m_axi_gmem0_1_RDATA FIFONUM 0 32 }  { m_axi_gmem0_1_RLAST LAST 0 1 }  { m_axi_gmem0_1_RID ID 0 1 }  { m_axi_gmem0_1_RUSER DATA 0 1 }  { m_axi_gmem0_1_RRESP RESP 0 2 }  { m_axi_gmem0_1_BVALID VALID 0 1 }  { m_axi_gmem0_1_BREADY READY 1 1 }  { m_axi_gmem0_1_BRESP RESP 0 2 }  { m_axi_gmem0_1_BID ID 0 1 }  { m_axi_gmem0_1_BUSER DATA 0 1 } } }
	gmem0_2 { m_axi {  { m_axi_gmem0_2_AWVALID VALID 1 1 }  { m_axi_gmem0_2_AWREADY READY 0 1 }  { m_axi_gmem0_2_AWADDR ADDR 1 64 }  { m_axi_gmem0_2_AWID ID 1 1 }  { m_axi_gmem0_2_AWLEN SIZE 1 8 }  { m_axi_gmem0_2_AWSIZE BURST 1 3 }  { m_axi_gmem0_2_AWBURST LOCK 1 2 }  { m_axi_gmem0_2_AWLOCK CACHE 1 2 }  { m_axi_gmem0_2_AWCACHE PROT 1 4 }  { m_axi_gmem0_2_AWPROT QOS 1 3 }  { m_axi_gmem0_2_AWQOS REGION 1 4 }  { m_axi_gmem0_2_AWREGION USER 1 4 }  { m_axi_gmem0_2_AWUSER DATA 1 1 }  { m_axi_gmem0_2_WVALID VALID 1 1 }  { m_axi_gmem0_2_WREADY READY 0 1 }  { m_axi_gmem0_2_WDATA FIFONUM 1 32 }  { m_axi_gmem0_2_WSTRB STRB 1 4 }  { m_axi_gmem0_2_WLAST LAST 1 1 }  { m_axi_gmem0_2_WID ID 1 1 }  { m_axi_gmem0_2_WUSER DATA 1 1 }  { m_axi_gmem0_2_ARVALID VALID 1 1 }  { m_axi_gmem0_2_ARREADY READY 0 1 }  { m_axi_gmem0_2_ARADDR ADDR 1 64 }  { m_axi_gmem0_2_ARID ID 1 1 }  { m_axi_gmem0_2_ARLEN SIZE 1 8 }  { m_axi_gmem0_2_ARSIZE BURST 1 3 }  { m_axi_gmem0_2_ARBURST LOCK 1 2 }  { m_axi_gmem0_2_ARLOCK CACHE 1 2 }  { m_axi_gmem0_2_ARCACHE PROT 1 4 }  { m_axi_gmem0_2_ARPROT QOS 1 3 }  { m_axi_gmem0_2_ARQOS REGION 1 4 }  { m_axi_gmem0_2_ARREGION USER 1 4 }  { m_axi_gmem0_2_ARUSER DATA 1 1 }  { m_axi_gmem0_2_RVALID VALID 0 1 }  { m_axi_gmem0_2_RREADY READY 1 1 }  { m_axi_gmem0_2_RDATA FIFONUM 0 32 }  { m_axi_gmem0_2_RLAST LAST 0 1 }  { m_axi_gmem0_2_RID ID 0 1 }  { m_axi_gmem0_2_RUSER DATA 0 1 }  { m_axi_gmem0_2_RRESP RESP 0 2 }  { m_axi_gmem0_2_BVALID VALID 0 1 }  { m_axi_gmem0_2_BREADY READY 1 1 }  { m_axi_gmem0_2_BRESP RESP 0 2 }  { m_axi_gmem0_2_BID ID 0 1 }  { m_axi_gmem0_2_BUSER DATA 0 1 } } }
	gmem0_3 { m_axi {  { m_axi_gmem0_3_AWVALID VALID 1 1 }  { m_axi_gmem0_3_AWREADY READY 0 1 }  { m_axi_gmem0_3_AWADDR ADDR 1 64 }  { m_axi_gmem0_3_AWID ID 1 1 }  { m_axi_gmem0_3_AWLEN SIZE 1 8 }  { m_axi_gmem0_3_AWSIZE BURST 1 3 }  { m_axi_gmem0_3_AWBURST LOCK 1 2 }  { m_axi_gmem0_3_AWLOCK CACHE 1 2 }  { m_axi_gmem0_3_AWCACHE PROT 1 4 }  { m_axi_gmem0_3_AWPROT QOS 1 3 }  { m_axi_gmem0_3_AWQOS REGION 1 4 }  { m_axi_gmem0_3_AWREGION USER 1 4 }  { m_axi_gmem0_3_AWUSER DATA 1 1 }  { m_axi_gmem0_3_WVALID VALID 1 1 }  { m_axi_gmem0_3_WREADY READY 0 1 }  { m_axi_gmem0_3_WDATA FIFONUM 1 32 }  { m_axi_gmem0_3_WSTRB STRB 1 4 }  { m_axi_gmem0_3_WLAST LAST 1 1 }  { m_axi_gmem0_3_WID ID 1 1 }  { m_axi_gmem0_3_WUSER DATA 1 1 }  { m_axi_gmem0_3_ARVALID VALID 1 1 }  { m_axi_gmem0_3_ARREADY READY 0 1 }  { m_axi_gmem0_3_ARADDR ADDR 1 64 }  { m_axi_gmem0_3_ARID ID 1 1 }  { m_axi_gmem0_3_ARLEN SIZE 1 8 }  { m_axi_gmem0_3_ARSIZE BURST 1 3 }  { m_axi_gmem0_3_ARBURST LOCK 1 2 }  { m_axi_gmem0_3_ARLOCK CACHE 1 2 }  { m_axi_gmem0_3_ARCACHE PROT 1 4 }  { m_axi_gmem0_3_ARPROT QOS 1 3 }  { m_axi_gmem0_3_ARQOS REGION 1 4 }  { m_axi_gmem0_3_ARREGION USER 1 4 }  { m_axi_gmem0_3_ARUSER DATA 1 1 }  { m_axi_gmem0_3_RVALID VALID 0 1 }  { m_axi_gmem0_3_RREADY READY 1 1 }  { m_axi_gmem0_3_RDATA FIFONUM 0 32 }  { m_axi_gmem0_3_RLAST LAST 0 1 }  { m_axi_gmem0_3_RID ID 0 1 }  { m_axi_gmem0_3_RUSER DATA 0 1 }  { m_axi_gmem0_3_RRESP RESP 0 2 }  { m_axi_gmem0_3_BVALID VALID 0 1 }  { m_axi_gmem0_3_BREADY READY 1 1 }  { m_axi_gmem0_3_BRESP RESP 0 2 }  { m_axi_gmem0_3_BID ID 0 1 }  { m_axi_gmem0_3_BUSER DATA 0 1 } } }
	gmem1_0 { m_axi {  { m_axi_gmem1_0_AWVALID VALID 1 1 }  { m_axi_gmem1_0_AWREADY READY 0 1 }  { m_axi_gmem1_0_AWADDR ADDR 1 64 }  { m_axi_gmem1_0_AWID ID 1 1 }  { m_axi_gmem1_0_AWLEN SIZE 1 8 }  { m_axi_gmem1_0_AWSIZE BURST 1 3 }  { m_axi_gmem1_0_AWBURST LOCK 1 2 }  { m_axi_gmem1_0_AWLOCK CACHE 1 2 }  { m_axi_gmem1_0_AWCACHE PROT 1 4 }  { m_axi_gmem1_0_AWPROT QOS 1 3 }  { m_axi_gmem1_0_AWQOS REGION 1 4 }  { m_axi_gmem1_0_AWREGION USER 1 4 }  { m_axi_gmem1_0_AWUSER DATA 1 1 }  { m_axi_gmem1_0_WVALID VALID 1 1 }  { m_axi_gmem1_0_WREADY READY 0 1 }  { m_axi_gmem1_0_WDATA FIFONUM 1 32 }  { m_axi_gmem1_0_WSTRB STRB 1 4 }  { m_axi_gmem1_0_WLAST LAST 1 1 }  { m_axi_gmem1_0_WID ID 1 1 }  { m_axi_gmem1_0_WUSER DATA 1 1 }  { m_axi_gmem1_0_ARVALID VALID 1 1 }  { m_axi_gmem1_0_ARREADY READY 0 1 }  { m_axi_gmem1_0_ARADDR ADDR 1 64 }  { m_axi_gmem1_0_ARID ID 1 1 }  { m_axi_gmem1_0_ARLEN SIZE 1 8 }  { m_axi_gmem1_0_ARSIZE BURST 1 3 }  { m_axi_gmem1_0_ARBURST LOCK 1 2 }  { m_axi_gmem1_0_ARLOCK CACHE 1 2 }  { m_axi_gmem1_0_ARCACHE PROT 1 4 }  { m_axi_gmem1_0_ARPROT QOS 1 3 }  { m_axi_gmem1_0_ARQOS REGION 1 4 }  { m_axi_gmem1_0_ARREGION USER 1 4 }  { m_axi_gmem1_0_ARUSER DATA 1 1 }  { m_axi_gmem1_0_RVALID VALID 0 1 }  { m_axi_gmem1_0_RREADY READY 1 1 }  { m_axi_gmem1_0_RDATA FIFONUM 0 32 }  { m_axi_gmem1_0_RLAST LAST 0 1 }  { m_axi_gmem1_0_RID ID 0 1 }  { m_axi_gmem1_0_RUSER DATA 0 1 }  { m_axi_gmem1_0_RRESP RESP 0 2 }  { m_axi_gmem1_0_BVALID VALID 0 1 }  { m_axi_gmem1_0_BREADY READY 1 1 }  { m_axi_gmem1_0_BRESP RESP 0 2 }  { m_axi_gmem1_0_BID ID 0 1 }  { m_axi_gmem1_0_BUSER DATA 0 1 } } }
	gmem1_1 { m_axi {  { m_axi_gmem1_1_AWVALID VALID 1 1 }  { m_axi_gmem1_1_AWREADY READY 0 1 }  { m_axi_gmem1_1_AWADDR ADDR 1 64 }  { m_axi_gmem1_1_AWID ID 1 1 }  { m_axi_gmem1_1_AWLEN SIZE 1 8 }  { m_axi_gmem1_1_AWSIZE BURST 1 3 }  { m_axi_gmem1_1_AWBURST LOCK 1 2 }  { m_axi_gmem1_1_AWLOCK CACHE 1 2 }  { m_axi_gmem1_1_AWCACHE PROT 1 4 }  { m_axi_gmem1_1_AWPROT QOS 1 3 }  { m_axi_gmem1_1_AWQOS REGION 1 4 }  { m_axi_gmem1_1_AWREGION USER 1 4 }  { m_axi_gmem1_1_AWUSER DATA 1 1 }  { m_axi_gmem1_1_WVALID VALID 1 1 }  { m_axi_gmem1_1_WREADY READY 0 1 }  { m_axi_gmem1_1_WDATA FIFONUM 1 32 }  { m_axi_gmem1_1_WSTRB STRB 1 4 }  { m_axi_gmem1_1_WLAST LAST 1 1 }  { m_axi_gmem1_1_WID ID 1 1 }  { m_axi_gmem1_1_WUSER DATA 1 1 }  { m_axi_gmem1_1_ARVALID VALID 1 1 }  { m_axi_gmem1_1_ARREADY READY 0 1 }  { m_axi_gmem1_1_ARADDR ADDR 1 64 }  { m_axi_gmem1_1_ARID ID 1 1 }  { m_axi_gmem1_1_ARLEN SIZE 1 8 }  { m_axi_gmem1_1_ARSIZE BURST 1 3 }  { m_axi_gmem1_1_ARBURST LOCK 1 2 }  { m_axi_gmem1_1_ARLOCK CACHE 1 2 }  { m_axi_gmem1_1_ARCACHE PROT 1 4 }  { m_axi_gmem1_1_ARPROT QOS 1 3 }  { m_axi_gmem1_1_ARQOS REGION 1 4 }  { m_axi_gmem1_1_ARREGION USER 1 4 }  { m_axi_gmem1_1_ARUSER DATA 1 1 }  { m_axi_gmem1_1_RVALID VALID 0 1 }  { m_axi_gmem1_1_RREADY READY 1 1 }  { m_axi_gmem1_1_RDATA FIFONUM 0 32 }  { m_axi_gmem1_1_RLAST LAST 0 1 }  { m_axi_gmem1_1_RID ID 0 1 }  { m_axi_gmem1_1_RUSER DATA 0 1 }  { m_axi_gmem1_1_RRESP RESP 0 2 }  { m_axi_gmem1_1_BVALID VALID 0 1 }  { m_axi_gmem1_1_BREADY READY 1 1 }  { m_axi_gmem1_1_BRESP RESP 0 2 }  { m_axi_gmem1_1_BID ID 0 1 }  { m_axi_gmem1_1_BUSER DATA 0 1 } } }
	gmem1_2 { m_axi {  { m_axi_gmem1_2_AWVALID VALID 1 1 }  { m_axi_gmem1_2_AWREADY READY 0 1 }  { m_axi_gmem1_2_AWADDR ADDR 1 64 }  { m_axi_gmem1_2_AWID ID 1 1 }  { m_axi_gmem1_2_AWLEN SIZE 1 8 }  { m_axi_gmem1_2_AWSIZE BURST 1 3 }  { m_axi_gmem1_2_AWBURST LOCK 1 2 }  { m_axi_gmem1_2_AWLOCK CACHE 1 2 }  { m_axi_gmem1_2_AWCACHE PROT 1 4 }  { m_axi_gmem1_2_AWPROT QOS 1 3 }  { m_axi_gmem1_2_AWQOS REGION 1 4 }  { m_axi_gmem1_2_AWREGION USER 1 4 }  { m_axi_gmem1_2_AWUSER DATA 1 1 }  { m_axi_gmem1_2_WVALID VALID 1 1 }  { m_axi_gmem1_2_WREADY READY 0 1 }  { m_axi_gmem1_2_WDATA FIFONUM 1 32 }  { m_axi_gmem1_2_WSTRB STRB 1 4 }  { m_axi_gmem1_2_WLAST LAST 1 1 }  { m_axi_gmem1_2_WID ID 1 1 }  { m_axi_gmem1_2_WUSER DATA 1 1 }  { m_axi_gmem1_2_ARVALID VALID 1 1 }  { m_axi_gmem1_2_ARREADY READY 0 1 }  { m_axi_gmem1_2_ARADDR ADDR 1 64 }  { m_axi_gmem1_2_ARID ID 1 1 }  { m_axi_gmem1_2_ARLEN SIZE 1 8 }  { m_axi_gmem1_2_ARSIZE BURST 1 3 }  { m_axi_gmem1_2_ARBURST LOCK 1 2 }  { m_axi_gmem1_2_ARLOCK CACHE 1 2 }  { m_axi_gmem1_2_ARCACHE PROT 1 4 }  { m_axi_gmem1_2_ARPROT QOS 1 3 }  { m_axi_gmem1_2_ARQOS REGION 1 4 }  { m_axi_gmem1_2_ARREGION USER 1 4 }  { m_axi_gmem1_2_ARUSER DATA 1 1 }  { m_axi_gmem1_2_RVALID VALID 0 1 }  { m_axi_gmem1_2_RREADY READY 1 1 }  { m_axi_gmem1_2_RDATA FIFONUM 0 32 }  { m_axi_gmem1_2_RLAST LAST 0 1 }  { m_axi_gmem1_2_RID ID 0 1 }  { m_axi_gmem1_2_RUSER DATA 0 1 }  { m_axi_gmem1_2_RRESP RESP 0 2 }  { m_axi_gmem1_2_BVALID VALID 0 1 }  { m_axi_gmem1_2_BREADY READY 1 1 }  { m_axi_gmem1_2_BRESP RESP 0 2 }  { m_axi_gmem1_2_BID ID 0 1 }  { m_axi_gmem1_2_BUSER DATA 0 1 } } }
	gmem1_3 { m_axi {  { m_axi_gmem1_3_AWVALID VALID 1 1 }  { m_axi_gmem1_3_AWREADY READY 0 1 }  { m_axi_gmem1_3_AWADDR ADDR 1 64 }  { m_axi_gmem1_3_AWID ID 1 1 }  { m_axi_gmem1_3_AWLEN SIZE 1 8 }  { m_axi_gmem1_3_AWSIZE BURST 1 3 }  { m_axi_gmem1_3_AWBURST LOCK 1 2 }  { m_axi_gmem1_3_AWLOCK CACHE 1 2 }  { m_axi_gmem1_3_AWCACHE PROT 1 4 }  { m_axi_gmem1_3_AWPROT QOS 1 3 }  { m_axi_gmem1_3_AWQOS REGION 1 4 }  { m_axi_gmem1_3_AWREGION USER 1 4 }  { m_axi_gmem1_3_AWUSER DATA 1 1 }  { m_axi_gmem1_3_WVALID VALID 1 1 }  { m_axi_gmem1_3_WREADY READY 0 1 }  { m_axi_gmem1_3_WDATA FIFONUM 1 32 }  { m_axi_gmem1_3_WSTRB STRB 1 4 }  { m_axi_gmem1_3_WLAST LAST 1 1 }  { m_axi_gmem1_3_WID ID 1 1 }  { m_axi_gmem1_3_WUSER DATA 1 1 }  { m_axi_gmem1_3_ARVALID VALID 1 1 }  { m_axi_gmem1_3_ARREADY READY 0 1 }  { m_axi_gmem1_3_ARADDR ADDR 1 64 }  { m_axi_gmem1_3_ARID ID 1 1 }  { m_axi_gmem1_3_ARLEN SIZE 1 8 }  { m_axi_gmem1_3_ARSIZE BURST 1 3 }  { m_axi_gmem1_3_ARBURST LOCK 1 2 }  { m_axi_gmem1_3_ARLOCK CACHE 1 2 }  { m_axi_gmem1_3_ARCACHE PROT 1 4 }  { m_axi_gmem1_3_ARPROT QOS 1 3 }  { m_axi_gmem1_3_ARQOS REGION 1 4 }  { m_axi_gmem1_3_ARREGION USER 1 4 }  { m_axi_gmem1_3_ARUSER DATA 1 1 }  { m_axi_gmem1_3_RVALID VALID 0 1 }  { m_axi_gmem1_3_RREADY READY 1 1 }  { m_axi_gmem1_3_RDATA FIFONUM 0 32 }  { m_axi_gmem1_3_RLAST LAST 0 1 }  { m_axi_gmem1_3_RID ID 0 1 }  { m_axi_gmem1_3_RUSER DATA 0 1 }  { m_axi_gmem1_3_RRESP RESP 0 2 }  { m_axi_gmem1_3_BVALID VALID 0 1 }  { m_axi_gmem1_3_BREADY READY 1 1 }  { m_axi_gmem1_3_BRESP RESP 0 2 }  { m_axi_gmem1_3_BID ID 0 1 }  { m_axi_gmem1_3_BUSER DATA 0 1 } } }
	gmem2_0 { m_axi {  { m_axi_gmem2_0_AWVALID VALID 1 1 }  { m_axi_gmem2_0_AWREADY READY 0 1 }  { m_axi_gmem2_0_AWADDR ADDR 1 64 }  { m_axi_gmem2_0_AWID ID 1 1 }  { m_axi_gmem2_0_AWLEN SIZE 1 8 }  { m_axi_gmem2_0_AWSIZE BURST 1 3 }  { m_axi_gmem2_0_AWBURST LOCK 1 2 }  { m_axi_gmem2_0_AWLOCK CACHE 1 2 }  { m_axi_gmem2_0_AWCACHE PROT 1 4 }  { m_axi_gmem2_0_AWPROT QOS 1 3 }  { m_axi_gmem2_0_AWQOS REGION 1 4 }  { m_axi_gmem2_0_AWREGION USER 1 4 }  { m_axi_gmem2_0_AWUSER DATA 1 1 }  { m_axi_gmem2_0_WVALID VALID 1 1 }  { m_axi_gmem2_0_WREADY READY 0 1 }  { m_axi_gmem2_0_WDATA FIFONUM 1 64 }  { m_axi_gmem2_0_WSTRB STRB 1 8 }  { m_axi_gmem2_0_WLAST LAST 1 1 }  { m_axi_gmem2_0_WID ID 1 1 }  { m_axi_gmem2_0_WUSER DATA 1 1 }  { m_axi_gmem2_0_ARVALID VALID 1 1 }  { m_axi_gmem2_0_ARREADY READY 0 1 }  { m_axi_gmem2_0_ARADDR ADDR 1 64 }  { m_axi_gmem2_0_ARID ID 1 1 }  { m_axi_gmem2_0_ARLEN SIZE 1 8 }  { m_axi_gmem2_0_ARSIZE BURST 1 3 }  { m_axi_gmem2_0_ARBURST LOCK 1 2 }  { m_axi_gmem2_0_ARLOCK CACHE 1 2 }  { m_axi_gmem2_0_ARCACHE PROT 1 4 }  { m_axi_gmem2_0_ARPROT QOS 1 3 }  { m_axi_gmem2_0_ARQOS REGION 1 4 }  { m_axi_gmem2_0_ARREGION USER 1 4 }  { m_axi_gmem2_0_ARUSER DATA 1 1 }  { m_axi_gmem2_0_RVALID VALID 0 1 }  { m_axi_gmem2_0_RREADY READY 1 1 }  { m_axi_gmem2_0_RDATA FIFONUM 0 64 }  { m_axi_gmem2_0_RLAST LAST 0 1 }  { m_axi_gmem2_0_RID ID 0 1 }  { m_axi_gmem2_0_RUSER DATA 0 1 }  { m_axi_gmem2_0_RRESP RESP 0 2 }  { m_axi_gmem2_0_BVALID VALID 0 1 }  { m_axi_gmem2_0_BREADY READY 1 1 }  { m_axi_gmem2_0_BRESP RESP 0 2 }  { m_axi_gmem2_0_BID ID 0 1 }  { m_axi_gmem2_0_BUSER DATA 0 1 } } }
	gmem2_1 { m_axi {  { m_axi_gmem2_1_AWVALID VALID 1 1 }  { m_axi_gmem2_1_AWREADY READY 0 1 }  { m_axi_gmem2_1_AWADDR ADDR 1 64 }  { m_axi_gmem2_1_AWID ID 1 1 }  { m_axi_gmem2_1_AWLEN SIZE 1 8 }  { m_axi_gmem2_1_AWSIZE BURST 1 3 }  { m_axi_gmem2_1_AWBURST LOCK 1 2 }  { m_axi_gmem2_1_AWLOCK CACHE 1 2 }  { m_axi_gmem2_1_AWCACHE PROT 1 4 }  { m_axi_gmem2_1_AWPROT QOS 1 3 }  { m_axi_gmem2_1_AWQOS REGION 1 4 }  { m_axi_gmem2_1_AWREGION USER 1 4 }  { m_axi_gmem2_1_AWUSER DATA 1 1 }  { m_axi_gmem2_1_WVALID VALID 1 1 }  { m_axi_gmem2_1_WREADY READY 0 1 }  { m_axi_gmem2_1_WDATA FIFONUM 1 64 }  { m_axi_gmem2_1_WSTRB STRB 1 8 }  { m_axi_gmem2_1_WLAST LAST 1 1 }  { m_axi_gmem2_1_WID ID 1 1 }  { m_axi_gmem2_1_WUSER DATA 1 1 }  { m_axi_gmem2_1_ARVALID VALID 1 1 }  { m_axi_gmem2_1_ARREADY READY 0 1 }  { m_axi_gmem2_1_ARADDR ADDR 1 64 }  { m_axi_gmem2_1_ARID ID 1 1 }  { m_axi_gmem2_1_ARLEN SIZE 1 8 }  { m_axi_gmem2_1_ARSIZE BURST 1 3 }  { m_axi_gmem2_1_ARBURST LOCK 1 2 }  { m_axi_gmem2_1_ARLOCK CACHE 1 2 }  { m_axi_gmem2_1_ARCACHE PROT 1 4 }  { m_axi_gmem2_1_ARPROT QOS 1 3 }  { m_axi_gmem2_1_ARQOS REGION 1 4 }  { m_axi_gmem2_1_ARREGION USER 1 4 }  { m_axi_gmem2_1_ARUSER DATA 1 1 }  { m_axi_gmem2_1_RVALID VALID 0 1 }  { m_axi_gmem2_1_RREADY READY 1 1 }  { m_axi_gmem2_1_RDATA FIFONUM 0 64 }  { m_axi_gmem2_1_RLAST LAST 0 1 }  { m_axi_gmem2_1_RID ID 0 1 }  { m_axi_gmem2_1_RUSER DATA 0 1 }  { m_axi_gmem2_1_RRESP RESP 0 2 }  { m_axi_gmem2_1_BVALID VALID 0 1 }  { m_axi_gmem2_1_BREADY READY 1 1 }  { m_axi_gmem2_1_BRESP RESP 0 2 }  { m_axi_gmem2_1_BID ID 0 1 }  { m_axi_gmem2_1_BUSER DATA 0 1 } } }
	gmem2_2 { m_axi {  { m_axi_gmem2_2_AWVALID VALID 1 1 }  { m_axi_gmem2_2_AWREADY READY 0 1 }  { m_axi_gmem2_2_AWADDR ADDR 1 64 }  { m_axi_gmem2_2_AWID ID 1 1 }  { m_axi_gmem2_2_AWLEN SIZE 1 8 }  { m_axi_gmem2_2_AWSIZE BURST 1 3 }  { m_axi_gmem2_2_AWBURST LOCK 1 2 }  { m_axi_gmem2_2_AWLOCK CACHE 1 2 }  { m_axi_gmem2_2_AWCACHE PROT 1 4 }  { m_axi_gmem2_2_AWPROT QOS 1 3 }  { m_axi_gmem2_2_AWQOS REGION 1 4 }  { m_axi_gmem2_2_AWREGION USER 1 4 }  { m_axi_gmem2_2_AWUSER DATA 1 1 }  { m_axi_gmem2_2_WVALID VALID 1 1 }  { m_axi_gmem2_2_WREADY READY 0 1 }  { m_axi_gmem2_2_WDATA FIFONUM 1 64 }  { m_axi_gmem2_2_WSTRB STRB 1 8 }  { m_axi_gmem2_2_WLAST LAST 1 1 }  { m_axi_gmem2_2_WID ID 1 1 }  { m_axi_gmem2_2_WUSER DATA 1 1 }  { m_axi_gmem2_2_ARVALID VALID 1 1 }  { m_axi_gmem2_2_ARREADY READY 0 1 }  { m_axi_gmem2_2_ARADDR ADDR 1 64 }  { m_axi_gmem2_2_ARID ID 1 1 }  { m_axi_gmem2_2_ARLEN SIZE 1 8 }  { m_axi_gmem2_2_ARSIZE BURST 1 3 }  { m_axi_gmem2_2_ARBURST LOCK 1 2 }  { m_axi_gmem2_2_ARLOCK CACHE 1 2 }  { m_axi_gmem2_2_ARCACHE PROT 1 4 }  { m_axi_gmem2_2_ARPROT QOS 1 3 }  { m_axi_gmem2_2_ARQOS REGION 1 4 }  { m_axi_gmem2_2_ARREGION USER 1 4 }  { m_axi_gmem2_2_ARUSER DATA 1 1 }  { m_axi_gmem2_2_RVALID VALID 0 1 }  { m_axi_gmem2_2_RREADY READY 1 1 }  { m_axi_gmem2_2_RDATA FIFONUM 0 64 }  { m_axi_gmem2_2_RLAST LAST 0 1 }  { m_axi_gmem2_2_RID ID 0 1 }  { m_axi_gmem2_2_RUSER DATA 0 1 }  { m_axi_gmem2_2_RRESP RESP 0 2 }  { m_axi_gmem2_2_BVALID VALID 0 1 }  { m_axi_gmem2_2_BREADY READY 1 1 }  { m_axi_gmem2_2_BRESP RESP 0 2 }  { m_axi_gmem2_2_BID ID 0 1 }  { m_axi_gmem2_2_BUSER DATA 0 1 } } }
	gmem2_3 { m_axi {  { m_axi_gmem2_3_AWVALID VALID 1 1 }  { m_axi_gmem2_3_AWREADY READY 0 1 }  { m_axi_gmem2_3_AWADDR ADDR 1 64 }  { m_axi_gmem2_3_AWID ID 1 1 }  { m_axi_gmem2_3_AWLEN SIZE 1 8 }  { m_axi_gmem2_3_AWSIZE BURST 1 3 }  { m_axi_gmem2_3_AWBURST LOCK 1 2 }  { m_axi_gmem2_3_AWLOCK CACHE 1 2 }  { m_axi_gmem2_3_AWCACHE PROT 1 4 }  { m_axi_gmem2_3_AWPROT QOS 1 3 }  { m_axi_gmem2_3_AWQOS REGION 1 4 }  { m_axi_gmem2_3_AWREGION USER 1 4 }  { m_axi_gmem2_3_AWUSER DATA 1 1 }  { m_axi_gmem2_3_WVALID VALID 1 1 }  { m_axi_gmem2_3_WREADY READY 0 1 }  { m_axi_gmem2_3_WDATA FIFONUM 1 64 }  { m_axi_gmem2_3_WSTRB STRB 1 8 }  { m_axi_gmem2_3_WLAST LAST 1 1 }  { m_axi_gmem2_3_WID ID 1 1 }  { m_axi_gmem2_3_WUSER DATA 1 1 }  { m_axi_gmem2_3_ARVALID VALID 1 1 }  { m_axi_gmem2_3_ARREADY READY 0 1 }  { m_axi_gmem2_3_ARADDR ADDR 1 64 }  { m_axi_gmem2_3_ARID ID 1 1 }  { m_axi_gmem2_3_ARLEN SIZE 1 8 }  { m_axi_gmem2_3_ARSIZE BURST 1 3 }  { m_axi_gmem2_3_ARBURST LOCK 1 2 }  { m_axi_gmem2_3_ARLOCK CACHE 1 2 }  { m_axi_gmem2_3_ARCACHE PROT 1 4 }  { m_axi_gmem2_3_ARPROT QOS 1 3 }  { m_axi_gmem2_3_ARQOS REGION 1 4 }  { m_axi_gmem2_3_ARREGION USER 1 4 }  { m_axi_gmem2_3_ARUSER DATA 1 1 }  { m_axi_gmem2_3_RVALID VALID 0 1 }  { m_axi_gmem2_3_RREADY READY 1 1 }  { m_axi_gmem2_3_RDATA FIFONUM 0 64 }  { m_axi_gmem2_3_RLAST LAST 0 1 }  { m_axi_gmem2_3_RID ID 0 1 }  { m_axi_gmem2_3_RUSER DATA 0 1 }  { m_axi_gmem2_3_RRESP RESP 0 2 }  { m_axi_gmem2_3_BVALID VALID 0 1 }  { m_axi_gmem2_3_BREADY READY 1 1 }  { m_axi_gmem2_3_BRESP RESP 0 2 }  { m_axi_gmem2_3_BID ID 0 1 }  { m_axi_gmem2_3_BUSER DATA 0 1 } } }
}

set maxi_interface_dict [dict create]
dict set maxi_interface_dict gmem0_0 { CHANNEL_NUM 0 BUNDLE gmem0_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_1 { CHANNEL_NUM 0 BUNDLE gmem0_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_2 { CHANNEL_NUM 0 BUNDLE gmem0_2 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_3 { CHANNEL_NUM 0 BUNDLE gmem0_3 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_0 { CHANNEL_NUM 0 BUNDLE gmem1_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_1 { CHANNEL_NUM 0 BUNDLE gmem1_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_2 { CHANNEL_NUM 0 BUNDLE gmem1_2 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_3 { CHANNEL_NUM 0 BUNDLE gmem1_3 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem2_0 { CHANNEL_NUM 0 BUNDLE gmem2_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_1 { CHANNEL_NUM 0 BUNDLE gmem2_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_2 { CHANNEL_NUM 0 BUNDLE gmem2_2 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_3 { CHANNEL_NUM 0 BUNDLE gmem2_3 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ gmem0_0 64 }
	{ gmem0_1 64 }
	{ gmem0_2 64 }
	{ gmem0_3 64 }
	{ gmem1_0 64 }
	{ gmem1_1 64 }
	{ gmem1_2 64 }
	{ gmem1_3 64 }
	{ gmem2_0 64 }
	{ gmem2_1 64 }
	{ gmem2_2 64 }
	{ gmem2_3 64 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ gmem0_0 64 }
	{ gmem0_1 64 }
	{ gmem0_2 64 }
	{ gmem0_3 64 }
	{ gmem1_0 64 }
	{ gmem1_1 64 }
	{ gmem1_2 64 }
	{ gmem1_3 64 }
	{ gmem2_0 64 }
	{ gmem2_1 64 }
	{ gmem2_2 64 }
	{ gmem2_3 64 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
