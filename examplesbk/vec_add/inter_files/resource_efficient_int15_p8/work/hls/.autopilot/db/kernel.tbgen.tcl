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
	{ gmem0_0 int 16 regular {axi_master 0}  }
	{ gmem0_1 int 16 regular {axi_master 0}  }
	{ gmem0_2 int 16 regular {axi_master 0}  }
	{ gmem0_3 int 16 regular {axi_master 0}  }
	{ gmem0_4 int 16 regular {axi_master 0}  }
	{ gmem0_5 int 16 regular {axi_master 0}  }
	{ gmem0_6 int 16 regular {axi_master 0}  }
	{ gmem0_7 int 16 regular {axi_master 0}  }
	{ gmem1_0 int 16 regular {axi_master 0}  }
	{ gmem1_1 int 16 regular {axi_master 0}  }
	{ gmem1_2 int 16 regular {axi_master 0}  }
	{ gmem1_3 int 16 regular {axi_master 0}  }
	{ gmem1_4 int 16 regular {axi_master 0}  }
	{ gmem1_5 int 16 regular {axi_master 0}  }
	{ gmem1_6 int 16 regular {axi_master 0}  }
	{ gmem1_7 int 16 regular {axi_master 0}  }
	{ gmem2_0 int 32 regular {axi_master 1}  }
	{ gmem2_1 int 32 regular {axi_master 1}  }
	{ gmem2_2 int 32 regular {axi_master 1}  }
	{ gmem2_3 int 32 regular {axi_master 1}  }
	{ gmem2_4 int 32 regular {axi_master 1}  }
	{ gmem2_5 int 32 regular {axi_master 1}  }
	{ gmem2_6 int 32 regular {axi_master 1}  }
	{ gmem2_7 int 32 regular {axi_master 1}  }
	{ a_0 int 64 regular {axi_slave 0}  }
	{ a_1 int 64 regular {axi_slave 0}  }
	{ a_2 int 64 regular {axi_slave 0}  }
	{ a_3 int 64 regular {axi_slave 0}  }
	{ a_4 int 64 regular {axi_slave 0}  }
	{ a_5 int 64 regular {axi_slave 0}  }
	{ a_6 int 64 regular {axi_slave 0}  }
	{ a_7 int 64 regular {axi_slave 0}  }
	{ b_0 int 64 regular {axi_slave 0}  }
	{ b_1 int 64 regular {axi_slave 0}  }
	{ b_2 int 64 regular {axi_slave 0}  }
	{ b_3 int 64 regular {axi_slave 0}  }
	{ b_4 int 64 regular {axi_slave 0}  }
	{ b_5 int 64 regular {axi_slave 0}  }
	{ b_6 int 64 regular {axi_slave 0}  }
	{ b_7 int 64 regular {axi_slave 0}  }
	{ c_0 int 64 regular {axi_slave 0}  }
	{ c_1 int 64 regular {axi_slave 0}  }
	{ c_2 int 64 regular {axi_slave 0}  }
	{ c_3 int 64 regular {axi_slave 0}  }
	{ c_4 int 64 regular {axi_slave 0}  }
	{ c_5 int 64 regular {axi_slave 0}  }
	{ c_6 int 64 regular {axi_slave 0}  }
	{ c_7 int 64 regular {axi_slave 0}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "gmem0_0", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_0","offset": { "type": "dynamic","port_name": "a_0","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_1", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_1","offset": { "type": "dynamic","port_name": "a_1","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_2", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_2","offset": { "type": "dynamic","port_name": "a_2","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_3", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_3","offset": { "type": "dynamic","port_name": "a_3","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_4", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_4","offset": { "type": "dynamic","port_name": "a_4","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_5", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_5","offset": { "type": "dynamic","port_name": "a_5","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_6", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_6","offset": { "type": "dynamic","port_name": "a_6","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem0_7", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "a_7","offset": { "type": "dynamic","port_name": "a_7","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_0", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_0","offset": { "type": "dynamic","port_name": "b_0","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_1", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_1","offset": { "type": "dynamic","port_name": "b_1","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_2", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_2","offset": { "type": "dynamic","port_name": "b_2","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_3", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_3","offset": { "type": "dynamic","port_name": "b_3","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_4", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_4","offset": { "type": "dynamic","port_name": "b_4","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_5", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_5","offset": { "type": "dynamic","port_name": "b_5","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_6", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_6","offset": { "type": "dynamic","port_name": "b_6","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem1_7", "interface" : "axi_master", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[ {"cElement": [{"cName": "b_7","offset": { "type": "dynamic","port_name": "b_7","bundle": "control"},"direction": "READONLY"}]}]} , 
 	{ "Name" : "gmem2_0", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_0","offset": { "type": "dynamic","port_name": "c_0","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_1", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_1","offset": { "type": "dynamic","port_name": "c_1","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_2", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_2","offset": { "type": "dynamic","port_name": "c_2","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_3", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_3","offset": { "type": "dynamic","port_name": "c_3","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_4", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_4","offset": { "type": "dynamic","port_name": "c_4","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_5", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_5","offset": { "type": "dynamic","port_name": "c_5","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_6", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_6","offset": { "type": "dynamic","port_name": "c_6","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "gmem2_7", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[ {"cElement": [{"cName": "c_7","offset": { "type": "dynamic","port_name": "c_7","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "a_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":16}, "offset_end" : {"in":27}} , 
 	{ "Name" : "a_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":28}, "offset_end" : {"in":39}} , 
 	{ "Name" : "a_2", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":40}, "offset_end" : {"in":51}} , 
 	{ "Name" : "a_3", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":52}, "offset_end" : {"in":63}} , 
 	{ "Name" : "a_4", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":64}, "offset_end" : {"in":75}} , 
 	{ "Name" : "a_5", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":76}, "offset_end" : {"in":87}} , 
 	{ "Name" : "a_6", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":88}, "offset_end" : {"in":99}} , 
 	{ "Name" : "a_7", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":100}, "offset_end" : {"in":111}} , 
 	{ "Name" : "b_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":112}, "offset_end" : {"in":123}} , 
 	{ "Name" : "b_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":124}, "offset_end" : {"in":135}} , 
 	{ "Name" : "b_2", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":136}, "offset_end" : {"in":147}} , 
 	{ "Name" : "b_3", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":148}, "offset_end" : {"in":159}} , 
 	{ "Name" : "b_4", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":160}, "offset_end" : {"in":171}} , 
 	{ "Name" : "b_5", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":172}, "offset_end" : {"in":183}} , 
 	{ "Name" : "b_6", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":184}, "offset_end" : {"in":195}} , 
 	{ "Name" : "b_7", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":196}, "offset_end" : {"in":207}} , 
 	{ "Name" : "c_0", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":208}, "offset_end" : {"in":219}} , 
 	{ "Name" : "c_1", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":220}, "offset_end" : {"in":231}} , 
 	{ "Name" : "c_2", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":232}, "offset_end" : {"in":243}} , 
 	{ "Name" : "c_3", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":244}, "offset_end" : {"in":255}} , 
 	{ "Name" : "c_4", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":256}, "offset_end" : {"in":267}} , 
 	{ "Name" : "c_5", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":268}, "offset_end" : {"in":279}} , 
 	{ "Name" : "c_6", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":280}, "offset_end" : {"in":291}} , 
 	{ "Name" : "c_7", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":292}, "offset_end" : {"in":303}} ]}
# RTL Port declarations: 
set portNum 1100
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
	{ m_axi_gmem0_4_AWVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_AWREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_AWADDR sc_out sc_lv 64 signal 4 } 
	{ m_axi_gmem0_4_AWID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_AWLEN sc_out sc_lv 8 signal 4 } 
	{ m_axi_gmem0_4_AWSIZE sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem0_4_AWBURST sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem0_4_AWLOCK sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem0_4_AWCACHE sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem0_4_AWPROT sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem0_4_AWQOS sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem0_4_AWREGION sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem0_4_AWUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_WVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_WREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_WDATA sc_out sc_lv 32 signal 4 } 
	{ m_axi_gmem0_4_WSTRB sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem0_4_WLAST sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_WID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_WUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_ARVALID sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_ARREADY sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_ARADDR sc_out sc_lv 64 signal 4 } 
	{ m_axi_gmem0_4_ARID sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_ARLEN sc_out sc_lv 8 signal 4 } 
	{ m_axi_gmem0_4_ARSIZE sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem0_4_ARBURST sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem0_4_ARLOCK sc_out sc_lv 2 signal 4 } 
	{ m_axi_gmem0_4_ARCACHE sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem0_4_ARPROT sc_out sc_lv 3 signal 4 } 
	{ m_axi_gmem0_4_ARQOS sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem0_4_ARREGION sc_out sc_lv 4 signal 4 } 
	{ m_axi_gmem0_4_ARUSER sc_out sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_RVALID sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_RREADY sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_RDATA sc_in sc_lv 32 signal 4 } 
	{ m_axi_gmem0_4_RLAST sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_RID sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_RUSER sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_RRESP sc_in sc_lv 2 signal 4 } 
	{ m_axi_gmem0_4_BVALID sc_in sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_BREADY sc_out sc_logic 1 signal 4 } 
	{ m_axi_gmem0_4_BRESP sc_in sc_lv 2 signal 4 } 
	{ m_axi_gmem0_4_BID sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem0_4_BUSER sc_in sc_lv 1 signal 4 } 
	{ m_axi_gmem0_5_AWVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_AWREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_AWADDR sc_out sc_lv 64 signal 5 } 
	{ m_axi_gmem0_5_AWID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_AWLEN sc_out sc_lv 8 signal 5 } 
	{ m_axi_gmem0_5_AWSIZE sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem0_5_AWBURST sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem0_5_AWLOCK sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem0_5_AWCACHE sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem0_5_AWPROT sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem0_5_AWQOS sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem0_5_AWREGION sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem0_5_AWUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_WVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_WREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_WDATA sc_out sc_lv 32 signal 5 } 
	{ m_axi_gmem0_5_WSTRB sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem0_5_WLAST sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_WID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_WUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_ARVALID sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_ARREADY sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_ARADDR sc_out sc_lv 64 signal 5 } 
	{ m_axi_gmem0_5_ARID sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_ARLEN sc_out sc_lv 8 signal 5 } 
	{ m_axi_gmem0_5_ARSIZE sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem0_5_ARBURST sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem0_5_ARLOCK sc_out sc_lv 2 signal 5 } 
	{ m_axi_gmem0_5_ARCACHE sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem0_5_ARPROT sc_out sc_lv 3 signal 5 } 
	{ m_axi_gmem0_5_ARQOS sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem0_5_ARREGION sc_out sc_lv 4 signal 5 } 
	{ m_axi_gmem0_5_ARUSER sc_out sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_RVALID sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_RREADY sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_RDATA sc_in sc_lv 32 signal 5 } 
	{ m_axi_gmem0_5_RLAST sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_RID sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_RUSER sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_RRESP sc_in sc_lv 2 signal 5 } 
	{ m_axi_gmem0_5_BVALID sc_in sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_BREADY sc_out sc_logic 1 signal 5 } 
	{ m_axi_gmem0_5_BRESP sc_in sc_lv 2 signal 5 } 
	{ m_axi_gmem0_5_BID sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem0_5_BUSER sc_in sc_lv 1 signal 5 } 
	{ m_axi_gmem0_6_AWVALID sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_AWREADY sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_AWADDR sc_out sc_lv 64 signal 6 } 
	{ m_axi_gmem0_6_AWID sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_AWLEN sc_out sc_lv 8 signal 6 } 
	{ m_axi_gmem0_6_AWSIZE sc_out sc_lv 3 signal 6 } 
	{ m_axi_gmem0_6_AWBURST sc_out sc_lv 2 signal 6 } 
	{ m_axi_gmem0_6_AWLOCK sc_out sc_lv 2 signal 6 } 
	{ m_axi_gmem0_6_AWCACHE sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem0_6_AWPROT sc_out sc_lv 3 signal 6 } 
	{ m_axi_gmem0_6_AWQOS sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem0_6_AWREGION sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem0_6_AWUSER sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_WVALID sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_WREADY sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_WDATA sc_out sc_lv 32 signal 6 } 
	{ m_axi_gmem0_6_WSTRB sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem0_6_WLAST sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_WID sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_WUSER sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_ARVALID sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_ARREADY sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_ARADDR sc_out sc_lv 64 signal 6 } 
	{ m_axi_gmem0_6_ARID sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_ARLEN sc_out sc_lv 8 signal 6 } 
	{ m_axi_gmem0_6_ARSIZE sc_out sc_lv 3 signal 6 } 
	{ m_axi_gmem0_6_ARBURST sc_out sc_lv 2 signal 6 } 
	{ m_axi_gmem0_6_ARLOCK sc_out sc_lv 2 signal 6 } 
	{ m_axi_gmem0_6_ARCACHE sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem0_6_ARPROT sc_out sc_lv 3 signal 6 } 
	{ m_axi_gmem0_6_ARQOS sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem0_6_ARREGION sc_out sc_lv 4 signal 6 } 
	{ m_axi_gmem0_6_ARUSER sc_out sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_RVALID sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_RREADY sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_RDATA sc_in sc_lv 32 signal 6 } 
	{ m_axi_gmem0_6_RLAST sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_RID sc_in sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_RUSER sc_in sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_RRESP sc_in sc_lv 2 signal 6 } 
	{ m_axi_gmem0_6_BVALID sc_in sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_BREADY sc_out sc_logic 1 signal 6 } 
	{ m_axi_gmem0_6_BRESP sc_in sc_lv 2 signal 6 } 
	{ m_axi_gmem0_6_BID sc_in sc_lv 1 signal 6 } 
	{ m_axi_gmem0_6_BUSER sc_in sc_lv 1 signal 6 } 
	{ m_axi_gmem0_7_AWVALID sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_AWREADY sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_AWADDR sc_out sc_lv 64 signal 7 } 
	{ m_axi_gmem0_7_AWID sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_AWLEN sc_out sc_lv 8 signal 7 } 
	{ m_axi_gmem0_7_AWSIZE sc_out sc_lv 3 signal 7 } 
	{ m_axi_gmem0_7_AWBURST sc_out sc_lv 2 signal 7 } 
	{ m_axi_gmem0_7_AWLOCK sc_out sc_lv 2 signal 7 } 
	{ m_axi_gmem0_7_AWCACHE sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem0_7_AWPROT sc_out sc_lv 3 signal 7 } 
	{ m_axi_gmem0_7_AWQOS sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem0_7_AWREGION sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem0_7_AWUSER sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_WVALID sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_WREADY sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_WDATA sc_out sc_lv 32 signal 7 } 
	{ m_axi_gmem0_7_WSTRB sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem0_7_WLAST sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_WID sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_WUSER sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_ARVALID sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_ARREADY sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_ARADDR sc_out sc_lv 64 signal 7 } 
	{ m_axi_gmem0_7_ARID sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_ARLEN sc_out sc_lv 8 signal 7 } 
	{ m_axi_gmem0_7_ARSIZE sc_out sc_lv 3 signal 7 } 
	{ m_axi_gmem0_7_ARBURST sc_out sc_lv 2 signal 7 } 
	{ m_axi_gmem0_7_ARLOCK sc_out sc_lv 2 signal 7 } 
	{ m_axi_gmem0_7_ARCACHE sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem0_7_ARPROT sc_out sc_lv 3 signal 7 } 
	{ m_axi_gmem0_7_ARQOS sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem0_7_ARREGION sc_out sc_lv 4 signal 7 } 
	{ m_axi_gmem0_7_ARUSER sc_out sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_RVALID sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_RREADY sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_RDATA sc_in sc_lv 32 signal 7 } 
	{ m_axi_gmem0_7_RLAST sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_RID sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_RUSER sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_RRESP sc_in sc_lv 2 signal 7 } 
	{ m_axi_gmem0_7_BVALID sc_in sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_BREADY sc_out sc_logic 1 signal 7 } 
	{ m_axi_gmem0_7_BRESP sc_in sc_lv 2 signal 7 } 
	{ m_axi_gmem0_7_BID sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem0_7_BUSER sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem1_0_AWVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_AWREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_AWADDR sc_out sc_lv 64 signal 8 } 
	{ m_axi_gmem1_0_AWID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_AWLEN sc_out sc_lv 8 signal 8 } 
	{ m_axi_gmem1_0_AWSIZE sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem1_0_AWBURST sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem1_0_AWLOCK sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem1_0_AWCACHE sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem1_0_AWPROT sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem1_0_AWQOS sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem1_0_AWREGION sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem1_0_AWUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_WVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_WREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_WDATA sc_out sc_lv 32 signal 8 } 
	{ m_axi_gmem1_0_WSTRB sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem1_0_WLAST sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_WID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_WUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_ARVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_ARREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_ARADDR sc_out sc_lv 64 signal 8 } 
	{ m_axi_gmem1_0_ARID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_ARLEN sc_out sc_lv 8 signal 8 } 
	{ m_axi_gmem1_0_ARSIZE sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem1_0_ARBURST sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem1_0_ARLOCK sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem1_0_ARCACHE sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem1_0_ARPROT sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem1_0_ARQOS sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem1_0_ARREGION sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem1_0_ARUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_RVALID sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_RREADY sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_RDATA sc_in sc_lv 32 signal 8 } 
	{ m_axi_gmem1_0_RLAST sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_RID sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_RUSER sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_RRESP sc_in sc_lv 2 signal 8 } 
	{ m_axi_gmem1_0_BVALID sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_BREADY sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem1_0_BRESP sc_in sc_lv 2 signal 8 } 
	{ m_axi_gmem1_0_BID sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem1_0_BUSER sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem1_1_AWVALID sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_AWREADY sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_AWADDR sc_out sc_lv 64 signal 9 } 
	{ m_axi_gmem1_1_AWID sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_AWLEN sc_out sc_lv 8 signal 9 } 
	{ m_axi_gmem1_1_AWSIZE sc_out sc_lv 3 signal 9 } 
	{ m_axi_gmem1_1_AWBURST sc_out sc_lv 2 signal 9 } 
	{ m_axi_gmem1_1_AWLOCK sc_out sc_lv 2 signal 9 } 
	{ m_axi_gmem1_1_AWCACHE sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem1_1_AWPROT sc_out sc_lv 3 signal 9 } 
	{ m_axi_gmem1_1_AWQOS sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem1_1_AWREGION sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem1_1_AWUSER sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_WVALID sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_WREADY sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_WDATA sc_out sc_lv 32 signal 9 } 
	{ m_axi_gmem1_1_WSTRB sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem1_1_WLAST sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_WID sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_WUSER sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_ARVALID sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_ARREADY sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_ARADDR sc_out sc_lv 64 signal 9 } 
	{ m_axi_gmem1_1_ARID sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_ARLEN sc_out sc_lv 8 signal 9 } 
	{ m_axi_gmem1_1_ARSIZE sc_out sc_lv 3 signal 9 } 
	{ m_axi_gmem1_1_ARBURST sc_out sc_lv 2 signal 9 } 
	{ m_axi_gmem1_1_ARLOCK sc_out sc_lv 2 signal 9 } 
	{ m_axi_gmem1_1_ARCACHE sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem1_1_ARPROT sc_out sc_lv 3 signal 9 } 
	{ m_axi_gmem1_1_ARQOS sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem1_1_ARREGION sc_out sc_lv 4 signal 9 } 
	{ m_axi_gmem1_1_ARUSER sc_out sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_RVALID sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_RREADY sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_RDATA sc_in sc_lv 32 signal 9 } 
	{ m_axi_gmem1_1_RLAST sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_RID sc_in sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_RUSER sc_in sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_RRESP sc_in sc_lv 2 signal 9 } 
	{ m_axi_gmem1_1_BVALID sc_in sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_BREADY sc_out sc_logic 1 signal 9 } 
	{ m_axi_gmem1_1_BRESP sc_in sc_lv 2 signal 9 } 
	{ m_axi_gmem1_1_BID sc_in sc_lv 1 signal 9 } 
	{ m_axi_gmem1_1_BUSER sc_in sc_lv 1 signal 9 } 
	{ m_axi_gmem1_2_AWVALID sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_AWREADY sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_AWADDR sc_out sc_lv 64 signal 10 } 
	{ m_axi_gmem1_2_AWID sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_AWLEN sc_out sc_lv 8 signal 10 } 
	{ m_axi_gmem1_2_AWSIZE sc_out sc_lv 3 signal 10 } 
	{ m_axi_gmem1_2_AWBURST sc_out sc_lv 2 signal 10 } 
	{ m_axi_gmem1_2_AWLOCK sc_out sc_lv 2 signal 10 } 
	{ m_axi_gmem1_2_AWCACHE sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem1_2_AWPROT sc_out sc_lv 3 signal 10 } 
	{ m_axi_gmem1_2_AWQOS sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem1_2_AWREGION sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem1_2_AWUSER sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_WVALID sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_WREADY sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_WDATA sc_out sc_lv 32 signal 10 } 
	{ m_axi_gmem1_2_WSTRB sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem1_2_WLAST sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_WID sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_WUSER sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_ARVALID sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_ARREADY sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_ARADDR sc_out sc_lv 64 signal 10 } 
	{ m_axi_gmem1_2_ARID sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_ARLEN sc_out sc_lv 8 signal 10 } 
	{ m_axi_gmem1_2_ARSIZE sc_out sc_lv 3 signal 10 } 
	{ m_axi_gmem1_2_ARBURST sc_out sc_lv 2 signal 10 } 
	{ m_axi_gmem1_2_ARLOCK sc_out sc_lv 2 signal 10 } 
	{ m_axi_gmem1_2_ARCACHE sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem1_2_ARPROT sc_out sc_lv 3 signal 10 } 
	{ m_axi_gmem1_2_ARQOS sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem1_2_ARREGION sc_out sc_lv 4 signal 10 } 
	{ m_axi_gmem1_2_ARUSER sc_out sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_RVALID sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_RREADY sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_RDATA sc_in sc_lv 32 signal 10 } 
	{ m_axi_gmem1_2_RLAST sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_RID sc_in sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_RUSER sc_in sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_RRESP sc_in sc_lv 2 signal 10 } 
	{ m_axi_gmem1_2_BVALID sc_in sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_BREADY sc_out sc_logic 1 signal 10 } 
	{ m_axi_gmem1_2_BRESP sc_in sc_lv 2 signal 10 } 
	{ m_axi_gmem1_2_BID sc_in sc_lv 1 signal 10 } 
	{ m_axi_gmem1_2_BUSER sc_in sc_lv 1 signal 10 } 
	{ m_axi_gmem1_3_AWVALID sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_AWREADY sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_AWADDR sc_out sc_lv 64 signal 11 } 
	{ m_axi_gmem1_3_AWID sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_AWLEN sc_out sc_lv 8 signal 11 } 
	{ m_axi_gmem1_3_AWSIZE sc_out sc_lv 3 signal 11 } 
	{ m_axi_gmem1_3_AWBURST sc_out sc_lv 2 signal 11 } 
	{ m_axi_gmem1_3_AWLOCK sc_out sc_lv 2 signal 11 } 
	{ m_axi_gmem1_3_AWCACHE sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem1_3_AWPROT sc_out sc_lv 3 signal 11 } 
	{ m_axi_gmem1_3_AWQOS sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem1_3_AWREGION sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem1_3_AWUSER sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_WVALID sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_WREADY sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_WDATA sc_out sc_lv 32 signal 11 } 
	{ m_axi_gmem1_3_WSTRB sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem1_3_WLAST sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_WID sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_WUSER sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_ARVALID sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_ARREADY sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_ARADDR sc_out sc_lv 64 signal 11 } 
	{ m_axi_gmem1_3_ARID sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_ARLEN sc_out sc_lv 8 signal 11 } 
	{ m_axi_gmem1_3_ARSIZE sc_out sc_lv 3 signal 11 } 
	{ m_axi_gmem1_3_ARBURST sc_out sc_lv 2 signal 11 } 
	{ m_axi_gmem1_3_ARLOCK sc_out sc_lv 2 signal 11 } 
	{ m_axi_gmem1_3_ARCACHE sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem1_3_ARPROT sc_out sc_lv 3 signal 11 } 
	{ m_axi_gmem1_3_ARQOS sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem1_3_ARREGION sc_out sc_lv 4 signal 11 } 
	{ m_axi_gmem1_3_ARUSER sc_out sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_RVALID sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_RREADY sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_RDATA sc_in sc_lv 32 signal 11 } 
	{ m_axi_gmem1_3_RLAST sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_RID sc_in sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_RUSER sc_in sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_RRESP sc_in sc_lv 2 signal 11 } 
	{ m_axi_gmem1_3_BVALID sc_in sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_BREADY sc_out sc_logic 1 signal 11 } 
	{ m_axi_gmem1_3_BRESP sc_in sc_lv 2 signal 11 } 
	{ m_axi_gmem1_3_BID sc_in sc_lv 1 signal 11 } 
	{ m_axi_gmem1_3_BUSER sc_in sc_lv 1 signal 11 } 
	{ m_axi_gmem1_4_AWVALID sc_out sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_AWREADY sc_in sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_AWADDR sc_out sc_lv 64 signal 12 } 
	{ m_axi_gmem1_4_AWID sc_out sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_AWLEN sc_out sc_lv 8 signal 12 } 
	{ m_axi_gmem1_4_AWSIZE sc_out sc_lv 3 signal 12 } 
	{ m_axi_gmem1_4_AWBURST sc_out sc_lv 2 signal 12 } 
	{ m_axi_gmem1_4_AWLOCK sc_out sc_lv 2 signal 12 } 
	{ m_axi_gmem1_4_AWCACHE sc_out sc_lv 4 signal 12 } 
	{ m_axi_gmem1_4_AWPROT sc_out sc_lv 3 signal 12 } 
	{ m_axi_gmem1_4_AWQOS sc_out sc_lv 4 signal 12 } 
	{ m_axi_gmem1_4_AWREGION sc_out sc_lv 4 signal 12 } 
	{ m_axi_gmem1_4_AWUSER sc_out sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_WVALID sc_out sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_WREADY sc_in sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_WDATA sc_out sc_lv 32 signal 12 } 
	{ m_axi_gmem1_4_WSTRB sc_out sc_lv 4 signal 12 } 
	{ m_axi_gmem1_4_WLAST sc_out sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_WID sc_out sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_WUSER sc_out sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_ARVALID sc_out sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_ARREADY sc_in sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_ARADDR sc_out sc_lv 64 signal 12 } 
	{ m_axi_gmem1_4_ARID sc_out sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_ARLEN sc_out sc_lv 8 signal 12 } 
	{ m_axi_gmem1_4_ARSIZE sc_out sc_lv 3 signal 12 } 
	{ m_axi_gmem1_4_ARBURST sc_out sc_lv 2 signal 12 } 
	{ m_axi_gmem1_4_ARLOCK sc_out sc_lv 2 signal 12 } 
	{ m_axi_gmem1_4_ARCACHE sc_out sc_lv 4 signal 12 } 
	{ m_axi_gmem1_4_ARPROT sc_out sc_lv 3 signal 12 } 
	{ m_axi_gmem1_4_ARQOS sc_out sc_lv 4 signal 12 } 
	{ m_axi_gmem1_4_ARREGION sc_out sc_lv 4 signal 12 } 
	{ m_axi_gmem1_4_ARUSER sc_out sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_RVALID sc_in sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_RREADY sc_out sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_RDATA sc_in sc_lv 32 signal 12 } 
	{ m_axi_gmem1_4_RLAST sc_in sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_RID sc_in sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_RUSER sc_in sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_RRESP sc_in sc_lv 2 signal 12 } 
	{ m_axi_gmem1_4_BVALID sc_in sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_BREADY sc_out sc_logic 1 signal 12 } 
	{ m_axi_gmem1_4_BRESP sc_in sc_lv 2 signal 12 } 
	{ m_axi_gmem1_4_BID sc_in sc_lv 1 signal 12 } 
	{ m_axi_gmem1_4_BUSER sc_in sc_lv 1 signal 12 } 
	{ m_axi_gmem1_5_AWVALID sc_out sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_AWREADY sc_in sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_AWADDR sc_out sc_lv 64 signal 13 } 
	{ m_axi_gmem1_5_AWID sc_out sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_AWLEN sc_out sc_lv 8 signal 13 } 
	{ m_axi_gmem1_5_AWSIZE sc_out sc_lv 3 signal 13 } 
	{ m_axi_gmem1_5_AWBURST sc_out sc_lv 2 signal 13 } 
	{ m_axi_gmem1_5_AWLOCK sc_out sc_lv 2 signal 13 } 
	{ m_axi_gmem1_5_AWCACHE sc_out sc_lv 4 signal 13 } 
	{ m_axi_gmem1_5_AWPROT sc_out sc_lv 3 signal 13 } 
	{ m_axi_gmem1_5_AWQOS sc_out sc_lv 4 signal 13 } 
	{ m_axi_gmem1_5_AWREGION sc_out sc_lv 4 signal 13 } 
	{ m_axi_gmem1_5_AWUSER sc_out sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_WVALID sc_out sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_WREADY sc_in sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_WDATA sc_out sc_lv 32 signal 13 } 
	{ m_axi_gmem1_5_WSTRB sc_out sc_lv 4 signal 13 } 
	{ m_axi_gmem1_5_WLAST sc_out sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_WID sc_out sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_WUSER sc_out sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_ARVALID sc_out sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_ARREADY sc_in sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_ARADDR sc_out sc_lv 64 signal 13 } 
	{ m_axi_gmem1_5_ARID sc_out sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_ARLEN sc_out sc_lv 8 signal 13 } 
	{ m_axi_gmem1_5_ARSIZE sc_out sc_lv 3 signal 13 } 
	{ m_axi_gmem1_5_ARBURST sc_out sc_lv 2 signal 13 } 
	{ m_axi_gmem1_5_ARLOCK sc_out sc_lv 2 signal 13 } 
	{ m_axi_gmem1_5_ARCACHE sc_out sc_lv 4 signal 13 } 
	{ m_axi_gmem1_5_ARPROT sc_out sc_lv 3 signal 13 } 
	{ m_axi_gmem1_5_ARQOS sc_out sc_lv 4 signal 13 } 
	{ m_axi_gmem1_5_ARREGION sc_out sc_lv 4 signal 13 } 
	{ m_axi_gmem1_5_ARUSER sc_out sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_RVALID sc_in sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_RREADY sc_out sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_RDATA sc_in sc_lv 32 signal 13 } 
	{ m_axi_gmem1_5_RLAST sc_in sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_RID sc_in sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_RUSER sc_in sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_RRESP sc_in sc_lv 2 signal 13 } 
	{ m_axi_gmem1_5_BVALID sc_in sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_BREADY sc_out sc_logic 1 signal 13 } 
	{ m_axi_gmem1_5_BRESP sc_in sc_lv 2 signal 13 } 
	{ m_axi_gmem1_5_BID sc_in sc_lv 1 signal 13 } 
	{ m_axi_gmem1_5_BUSER sc_in sc_lv 1 signal 13 } 
	{ m_axi_gmem1_6_AWVALID sc_out sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_AWREADY sc_in sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_AWADDR sc_out sc_lv 64 signal 14 } 
	{ m_axi_gmem1_6_AWID sc_out sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_AWLEN sc_out sc_lv 8 signal 14 } 
	{ m_axi_gmem1_6_AWSIZE sc_out sc_lv 3 signal 14 } 
	{ m_axi_gmem1_6_AWBURST sc_out sc_lv 2 signal 14 } 
	{ m_axi_gmem1_6_AWLOCK sc_out sc_lv 2 signal 14 } 
	{ m_axi_gmem1_6_AWCACHE sc_out sc_lv 4 signal 14 } 
	{ m_axi_gmem1_6_AWPROT sc_out sc_lv 3 signal 14 } 
	{ m_axi_gmem1_6_AWQOS sc_out sc_lv 4 signal 14 } 
	{ m_axi_gmem1_6_AWREGION sc_out sc_lv 4 signal 14 } 
	{ m_axi_gmem1_6_AWUSER sc_out sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_WVALID sc_out sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_WREADY sc_in sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_WDATA sc_out sc_lv 32 signal 14 } 
	{ m_axi_gmem1_6_WSTRB sc_out sc_lv 4 signal 14 } 
	{ m_axi_gmem1_6_WLAST sc_out sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_WID sc_out sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_WUSER sc_out sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_ARVALID sc_out sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_ARREADY sc_in sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_ARADDR sc_out sc_lv 64 signal 14 } 
	{ m_axi_gmem1_6_ARID sc_out sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_ARLEN sc_out sc_lv 8 signal 14 } 
	{ m_axi_gmem1_6_ARSIZE sc_out sc_lv 3 signal 14 } 
	{ m_axi_gmem1_6_ARBURST sc_out sc_lv 2 signal 14 } 
	{ m_axi_gmem1_6_ARLOCK sc_out sc_lv 2 signal 14 } 
	{ m_axi_gmem1_6_ARCACHE sc_out sc_lv 4 signal 14 } 
	{ m_axi_gmem1_6_ARPROT sc_out sc_lv 3 signal 14 } 
	{ m_axi_gmem1_6_ARQOS sc_out sc_lv 4 signal 14 } 
	{ m_axi_gmem1_6_ARREGION sc_out sc_lv 4 signal 14 } 
	{ m_axi_gmem1_6_ARUSER sc_out sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_RVALID sc_in sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_RREADY sc_out sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_RDATA sc_in sc_lv 32 signal 14 } 
	{ m_axi_gmem1_6_RLAST sc_in sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_RID sc_in sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_RUSER sc_in sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_RRESP sc_in sc_lv 2 signal 14 } 
	{ m_axi_gmem1_6_BVALID sc_in sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_BREADY sc_out sc_logic 1 signal 14 } 
	{ m_axi_gmem1_6_BRESP sc_in sc_lv 2 signal 14 } 
	{ m_axi_gmem1_6_BID sc_in sc_lv 1 signal 14 } 
	{ m_axi_gmem1_6_BUSER sc_in sc_lv 1 signal 14 } 
	{ m_axi_gmem1_7_AWVALID sc_out sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_AWREADY sc_in sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_AWADDR sc_out sc_lv 64 signal 15 } 
	{ m_axi_gmem1_7_AWID sc_out sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_AWLEN sc_out sc_lv 8 signal 15 } 
	{ m_axi_gmem1_7_AWSIZE sc_out sc_lv 3 signal 15 } 
	{ m_axi_gmem1_7_AWBURST sc_out sc_lv 2 signal 15 } 
	{ m_axi_gmem1_7_AWLOCK sc_out sc_lv 2 signal 15 } 
	{ m_axi_gmem1_7_AWCACHE sc_out sc_lv 4 signal 15 } 
	{ m_axi_gmem1_7_AWPROT sc_out sc_lv 3 signal 15 } 
	{ m_axi_gmem1_7_AWQOS sc_out sc_lv 4 signal 15 } 
	{ m_axi_gmem1_7_AWREGION sc_out sc_lv 4 signal 15 } 
	{ m_axi_gmem1_7_AWUSER sc_out sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_WVALID sc_out sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_WREADY sc_in sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_WDATA sc_out sc_lv 32 signal 15 } 
	{ m_axi_gmem1_7_WSTRB sc_out sc_lv 4 signal 15 } 
	{ m_axi_gmem1_7_WLAST sc_out sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_WID sc_out sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_WUSER sc_out sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_ARVALID sc_out sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_ARREADY sc_in sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_ARADDR sc_out sc_lv 64 signal 15 } 
	{ m_axi_gmem1_7_ARID sc_out sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_ARLEN sc_out sc_lv 8 signal 15 } 
	{ m_axi_gmem1_7_ARSIZE sc_out sc_lv 3 signal 15 } 
	{ m_axi_gmem1_7_ARBURST sc_out sc_lv 2 signal 15 } 
	{ m_axi_gmem1_7_ARLOCK sc_out sc_lv 2 signal 15 } 
	{ m_axi_gmem1_7_ARCACHE sc_out sc_lv 4 signal 15 } 
	{ m_axi_gmem1_7_ARPROT sc_out sc_lv 3 signal 15 } 
	{ m_axi_gmem1_7_ARQOS sc_out sc_lv 4 signal 15 } 
	{ m_axi_gmem1_7_ARREGION sc_out sc_lv 4 signal 15 } 
	{ m_axi_gmem1_7_ARUSER sc_out sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_RVALID sc_in sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_RREADY sc_out sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_RDATA sc_in sc_lv 32 signal 15 } 
	{ m_axi_gmem1_7_RLAST sc_in sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_RID sc_in sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_RUSER sc_in sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_RRESP sc_in sc_lv 2 signal 15 } 
	{ m_axi_gmem1_7_BVALID sc_in sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_BREADY sc_out sc_logic 1 signal 15 } 
	{ m_axi_gmem1_7_BRESP sc_in sc_lv 2 signal 15 } 
	{ m_axi_gmem1_7_BID sc_in sc_lv 1 signal 15 } 
	{ m_axi_gmem1_7_BUSER sc_in sc_lv 1 signal 15 } 
	{ m_axi_gmem2_0_AWVALID sc_out sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_AWREADY sc_in sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_AWADDR sc_out sc_lv 64 signal 16 } 
	{ m_axi_gmem2_0_AWID sc_out sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_AWLEN sc_out sc_lv 8 signal 16 } 
	{ m_axi_gmem2_0_AWSIZE sc_out sc_lv 3 signal 16 } 
	{ m_axi_gmem2_0_AWBURST sc_out sc_lv 2 signal 16 } 
	{ m_axi_gmem2_0_AWLOCK sc_out sc_lv 2 signal 16 } 
	{ m_axi_gmem2_0_AWCACHE sc_out sc_lv 4 signal 16 } 
	{ m_axi_gmem2_0_AWPROT sc_out sc_lv 3 signal 16 } 
	{ m_axi_gmem2_0_AWQOS sc_out sc_lv 4 signal 16 } 
	{ m_axi_gmem2_0_AWREGION sc_out sc_lv 4 signal 16 } 
	{ m_axi_gmem2_0_AWUSER sc_out sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_WVALID sc_out sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_WREADY sc_in sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_WDATA sc_out sc_lv 32 signal 16 } 
	{ m_axi_gmem2_0_WSTRB sc_out sc_lv 4 signal 16 } 
	{ m_axi_gmem2_0_WLAST sc_out sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_WID sc_out sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_WUSER sc_out sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_ARVALID sc_out sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_ARREADY sc_in sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_ARADDR sc_out sc_lv 64 signal 16 } 
	{ m_axi_gmem2_0_ARID sc_out sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_ARLEN sc_out sc_lv 8 signal 16 } 
	{ m_axi_gmem2_0_ARSIZE sc_out sc_lv 3 signal 16 } 
	{ m_axi_gmem2_0_ARBURST sc_out sc_lv 2 signal 16 } 
	{ m_axi_gmem2_0_ARLOCK sc_out sc_lv 2 signal 16 } 
	{ m_axi_gmem2_0_ARCACHE sc_out sc_lv 4 signal 16 } 
	{ m_axi_gmem2_0_ARPROT sc_out sc_lv 3 signal 16 } 
	{ m_axi_gmem2_0_ARQOS sc_out sc_lv 4 signal 16 } 
	{ m_axi_gmem2_0_ARREGION sc_out sc_lv 4 signal 16 } 
	{ m_axi_gmem2_0_ARUSER sc_out sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_RVALID sc_in sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_RREADY sc_out sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_RDATA sc_in sc_lv 32 signal 16 } 
	{ m_axi_gmem2_0_RLAST sc_in sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_RID sc_in sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_RUSER sc_in sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_RRESP sc_in sc_lv 2 signal 16 } 
	{ m_axi_gmem2_0_BVALID sc_in sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_BREADY sc_out sc_logic 1 signal 16 } 
	{ m_axi_gmem2_0_BRESP sc_in sc_lv 2 signal 16 } 
	{ m_axi_gmem2_0_BID sc_in sc_lv 1 signal 16 } 
	{ m_axi_gmem2_0_BUSER sc_in sc_lv 1 signal 16 } 
	{ m_axi_gmem2_1_AWVALID sc_out sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_AWREADY sc_in sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_AWADDR sc_out sc_lv 64 signal 17 } 
	{ m_axi_gmem2_1_AWID sc_out sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_AWLEN sc_out sc_lv 8 signal 17 } 
	{ m_axi_gmem2_1_AWSIZE sc_out sc_lv 3 signal 17 } 
	{ m_axi_gmem2_1_AWBURST sc_out sc_lv 2 signal 17 } 
	{ m_axi_gmem2_1_AWLOCK sc_out sc_lv 2 signal 17 } 
	{ m_axi_gmem2_1_AWCACHE sc_out sc_lv 4 signal 17 } 
	{ m_axi_gmem2_1_AWPROT sc_out sc_lv 3 signal 17 } 
	{ m_axi_gmem2_1_AWQOS sc_out sc_lv 4 signal 17 } 
	{ m_axi_gmem2_1_AWREGION sc_out sc_lv 4 signal 17 } 
	{ m_axi_gmem2_1_AWUSER sc_out sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_WVALID sc_out sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_WREADY sc_in sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_WDATA sc_out sc_lv 32 signal 17 } 
	{ m_axi_gmem2_1_WSTRB sc_out sc_lv 4 signal 17 } 
	{ m_axi_gmem2_1_WLAST sc_out sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_WID sc_out sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_WUSER sc_out sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_ARVALID sc_out sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_ARREADY sc_in sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_ARADDR sc_out sc_lv 64 signal 17 } 
	{ m_axi_gmem2_1_ARID sc_out sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_ARLEN sc_out sc_lv 8 signal 17 } 
	{ m_axi_gmem2_1_ARSIZE sc_out sc_lv 3 signal 17 } 
	{ m_axi_gmem2_1_ARBURST sc_out sc_lv 2 signal 17 } 
	{ m_axi_gmem2_1_ARLOCK sc_out sc_lv 2 signal 17 } 
	{ m_axi_gmem2_1_ARCACHE sc_out sc_lv 4 signal 17 } 
	{ m_axi_gmem2_1_ARPROT sc_out sc_lv 3 signal 17 } 
	{ m_axi_gmem2_1_ARQOS sc_out sc_lv 4 signal 17 } 
	{ m_axi_gmem2_1_ARREGION sc_out sc_lv 4 signal 17 } 
	{ m_axi_gmem2_1_ARUSER sc_out sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_RVALID sc_in sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_RREADY sc_out sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_RDATA sc_in sc_lv 32 signal 17 } 
	{ m_axi_gmem2_1_RLAST sc_in sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_RID sc_in sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_RUSER sc_in sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_RRESP sc_in sc_lv 2 signal 17 } 
	{ m_axi_gmem2_1_BVALID sc_in sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_BREADY sc_out sc_logic 1 signal 17 } 
	{ m_axi_gmem2_1_BRESP sc_in sc_lv 2 signal 17 } 
	{ m_axi_gmem2_1_BID sc_in sc_lv 1 signal 17 } 
	{ m_axi_gmem2_1_BUSER sc_in sc_lv 1 signal 17 } 
	{ m_axi_gmem2_2_AWVALID sc_out sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_AWREADY sc_in sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_AWADDR sc_out sc_lv 64 signal 18 } 
	{ m_axi_gmem2_2_AWID sc_out sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_AWLEN sc_out sc_lv 8 signal 18 } 
	{ m_axi_gmem2_2_AWSIZE sc_out sc_lv 3 signal 18 } 
	{ m_axi_gmem2_2_AWBURST sc_out sc_lv 2 signal 18 } 
	{ m_axi_gmem2_2_AWLOCK sc_out sc_lv 2 signal 18 } 
	{ m_axi_gmem2_2_AWCACHE sc_out sc_lv 4 signal 18 } 
	{ m_axi_gmem2_2_AWPROT sc_out sc_lv 3 signal 18 } 
	{ m_axi_gmem2_2_AWQOS sc_out sc_lv 4 signal 18 } 
	{ m_axi_gmem2_2_AWREGION sc_out sc_lv 4 signal 18 } 
	{ m_axi_gmem2_2_AWUSER sc_out sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_WVALID sc_out sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_WREADY sc_in sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_WDATA sc_out sc_lv 32 signal 18 } 
	{ m_axi_gmem2_2_WSTRB sc_out sc_lv 4 signal 18 } 
	{ m_axi_gmem2_2_WLAST sc_out sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_WID sc_out sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_WUSER sc_out sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_ARVALID sc_out sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_ARREADY sc_in sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_ARADDR sc_out sc_lv 64 signal 18 } 
	{ m_axi_gmem2_2_ARID sc_out sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_ARLEN sc_out sc_lv 8 signal 18 } 
	{ m_axi_gmem2_2_ARSIZE sc_out sc_lv 3 signal 18 } 
	{ m_axi_gmem2_2_ARBURST sc_out sc_lv 2 signal 18 } 
	{ m_axi_gmem2_2_ARLOCK sc_out sc_lv 2 signal 18 } 
	{ m_axi_gmem2_2_ARCACHE sc_out sc_lv 4 signal 18 } 
	{ m_axi_gmem2_2_ARPROT sc_out sc_lv 3 signal 18 } 
	{ m_axi_gmem2_2_ARQOS sc_out sc_lv 4 signal 18 } 
	{ m_axi_gmem2_2_ARREGION sc_out sc_lv 4 signal 18 } 
	{ m_axi_gmem2_2_ARUSER sc_out sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_RVALID sc_in sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_RREADY sc_out sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_RDATA sc_in sc_lv 32 signal 18 } 
	{ m_axi_gmem2_2_RLAST sc_in sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_RID sc_in sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_RUSER sc_in sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_RRESP sc_in sc_lv 2 signal 18 } 
	{ m_axi_gmem2_2_BVALID sc_in sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_BREADY sc_out sc_logic 1 signal 18 } 
	{ m_axi_gmem2_2_BRESP sc_in sc_lv 2 signal 18 } 
	{ m_axi_gmem2_2_BID sc_in sc_lv 1 signal 18 } 
	{ m_axi_gmem2_2_BUSER sc_in sc_lv 1 signal 18 } 
	{ m_axi_gmem2_3_AWVALID sc_out sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_AWREADY sc_in sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_AWADDR sc_out sc_lv 64 signal 19 } 
	{ m_axi_gmem2_3_AWID sc_out sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_AWLEN sc_out sc_lv 8 signal 19 } 
	{ m_axi_gmem2_3_AWSIZE sc_out sc_lv 3 signal 19 } 
	{ m_axi_gmem2_3_AWBURST sc_out sc_lv 2 signal 19 } 
	{ m_axi_gmem2_3_AWLOCK sc_out sc_lv 2 signal 19 } 
	{ m_axi_gmem2_3_AWCACHE sc_out sc_lv 4 signal 19 } 
	{ m_axi_gmem2_3_AWPROT sc_out sc_lv 3 signal 19 } 
	{ m_axi_gmem2_3_AWQOS sc_out sc_lv 4 signal 19 } 
	{ m_axi_gmem2_3_AWREGION sc_out sc_lv 4 signal 19 } 
	{ m_axi_gmem2_3_AWUSER sc_out sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_WVALID sc_out sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_WREADY sc_in sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_WDATA sc_out sc_lv 32 signal 19 } 
	{ m_axi_gmem2_3_WSTRB sc_out sc_lv 4 signal 19 } 
	{ m_axi_gmem2_3_WLAST sc_out sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_WID sc_out sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_WUSER sc_out sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_ARVALID sc_out sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_ARREADY sc_in sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_ARADDR sc_out sc_lv 64 signal 19 } 
	{ m_axi_gmem2_3_ARID sc_out sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_ARLEN sc_out sc_lv 8 signal 19 } 
	{ m_axi_gmem2_3_ARSIZE sc_out sc_lv 3 signal 19 } 
	{ m_axi_gmem2_3_ARBURST sc_out sc_lv 2 signal 19 } 
	{ m_axi_gmem2_3_ARLOCK sc_out sc_lv 2 signal 19 } 
	{ m_axi_gmem2_3_ARCACHE sc_out sc_lv 4 signal 19 } 
	{ m_axi_gmem2_3_ARPROT sc_out sc_lv 3 signal 19 } 
	{ m_axi_gmem2_3_ARQOS sc_out sc_lv 4 signal 19 } 
	{ m_axi_gmem2_3_ARREGION sc_out sc_lv 4 signal 19 } 
	{ m_axi_gmem2_3_ARUSER sc_out sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_RVALID sc_in sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_RREADY sc_out sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_RDATA sc_in sc_lv 32 signal 19 } 
	{ m_axi_gmem2_3_RLAST sc_in sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_RID sc_in sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_RUSER sc_in sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_RRESP sc_in sc_lv 2 signal 19 } 
	{ m_axi_gmem2_3_BVALID sc_in sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_BREADY sc_out sc_logic 1 signal 19 } 
	{ m_axi_gmem2_3_BRESP sc_in sc_lv 2 signal 19 } 
	{ m_axi_gmem2_3_BID sc_in sc_lv 1 signal 19 } 
	{ m_axi_gmem2_3_BUSER sc_in sc_lv 1 signal 19 } 
	{ m_axi_gmem2_4_AWVALID sc_out sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_AWREADY sc_in sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_AWADDR sc_out sc_lv 64 signal 20 } 
	{ m_axi_gmem2_4_AWID sc_out sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_AWLEN sc_out sc_lv 8 signal 20 } 
	{ m_axi_gmem2_4_AWSIZE sc_out sc_lv 3 signal 20 } 
	{ m_axi_gmem2_4_AWBURST sc_out sc_lv 2 signal 20 } 
	{ m_axi_gmem2_4_AWLOCK sc_out sc_lv 2 signal 20 } 
	{ m_axi_gmem2_4_AWCACHE sc_out sc_lv 4 signal 20 } 
	{ m_axi_gmem2_4_AWPROT sc_out sc_lv 3 signal 20 } 
	{ m_axi_gmem2_4_AWQOS sc_out sc_lv 4 signal 20 } 
	{ m_axi_gmem2_4_AWREGION sc_out sc_lv 4 signal 20 } 
	{ m_axi_gmem2_4_AWUSER sc_out sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_WVALID sc_out sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_WREADY sc_in sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_WDATA sc_out sc_lv 32 signal 20 } 
	{ m_axi_gmem2_4_WSTRB sc_out sc_lv 4 signal 20 } 
	{ m_axi_gmem2_4_WLAST sc_out sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_WID sc_out sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_WUSER sc_out sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_ARVALID sc_out sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_ARREADY sc_in sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_ARADDR sc_out sc_lv 64 signal 20 } 
	{ m_axi_gmem2_4_ARID sc_out sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_ARLEN sc_out sc_lv 8 signal 20 } 
	{ m_axi_gmem2_4_ARSIZE sc_out sc_lv 3 signal 20 } 
	{ m_axi_gmem2_4_ARBURST sc_out sc_lv 2 signal 20 } 
	{ m_axi_gmem2_4_ARLOCK sc_out sc_lv 2 signal 20 } 
	{ m_axi_gmem2_4_ARCACHE sc_out sc_lv 4 signal 20 } 
	{ m_axi_gmem2_4_ARPROT sc_out sc_lv 3 signal 20 } 
	{ m_axi_gmem2_4_ARQOS sc_out sc_lv 4 signal 20 } 
	{ m_axi_gmem2_4_ARREGION sc_out sc_lv 4 signal 20 } 
	{ m_axi_gmem2_4_ARUSER sc_out sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_RVALID sc_in sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_RREADY sc_out sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_RDATA sc_in sc_lv 32 signal 20 } 
	{ m_axi_gmem2_4_RLAST sc_in sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_RID sc_in sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_RUSER sc_in sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_RRESP sc_in sc_lv 2 signal 20 } 
	{ m_axi_gmem2_4_BVALID sc_in sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_BREADY sc_out sc_logic 1 signal 20 } 
	{ m_axi_gmem2_4_BRESP sc_in sc_lv 2 signal 20 } 
	{ m_axi_gmem2_4_BID sc_in sc_lv 1 signal 20 } 
	{ m_axi_gmem2_4_BUSER sc_in sc_lv 1 signal 20 } 
	{ m_axi_gmem2_5_AWVALID sc_out sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_AWREADY sc_in sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_AWADDR sc_out sc_lv 64 signal 21 } 
	{ m_axi_gmem2_5_AWID sc_out sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_AWLEN sc_out sc_lv 8 signal 21 } 
	{ m_axi_gmem2_5_AWSIZE sc_out sc_lv 3 signal 21 } 
	{ m_axi_gmem2_5_AWBURST sc_out sc_lv 2 signal 21 } 
	{ m_axi_gmem2_5_AWLOCK sc_out sc_lv 2 signal 21 } 
	{ m_axi_gmem2_5_AWCACHE sc_out sc_lv 4 signal 21 } 
	{ m_axi_gmem2_5_AWPROT sc_out sc_lv 3 signal 21 } 
	{ m_axi_gmem2_5_AWQOS sc_out sc_lv 4 signal 21 } 
	{ m_axi_gmem2_5_AWREGION sc_out sc_lv 4 signal 21 } 
	{ m_axi_gmem2_5_AWUSER sc_out sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_WVALID sc_out sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_WREADY sc_in sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_WDATA sc_out sc_lv 32 signal 21 } 
	{ m_axi_gmem2_5_WSTRB sc_out sc_lv 4 signal 21 } 
	{ m_axi_gmem2_5_WLAST sc_out sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_WID sc_out sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_WUSER sc_out sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_ARVALID sc_out sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_ARREADY sc_in sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_ARADDR sc_out sc_lv 64 signal 21 } 
	{ m_axi_gmem2_5_ARID sc_out sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_ARLEN sc_out sc_lv 8 signal 21 } 
	{ m_axi_gmem2_5_ARSIZE sc_out sc_lv 3 signal 21 } 
	{ m_axi_gmem2_5_ARBURST sc_out sc_lv 2 signal 21 } 
	{ m_axi_gmem2_5_ARLOCK sc_out sc_lv 2 signal 21 } 
	{ m_axi_gmem2_5_ARCACHE sc_out sc_lv 4 signal 21 } 
	{ m_axi_gmem2_5_ARPROT sc_out sc_lv 3 signal 21 } 
	{ m_axi_gmem2_5_ARQOS sc_out sc_lv 4 signal 21 } 
	{ m_axi_gmem2_5_ARREGION sc_out sc_lv 4 signal 21 } 
	{ m_axi_gmem2_5_ARUSER sc_out sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_RVALID sc_in sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_RREADY sc_out sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_RDATA sc_in sc_lv 32 signal 21 } 
	{ m_axi_gmem2_5_RLAST sc_in sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_RID sc_in sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_RUSER sc_in sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_RRESP sc_in sc_lv 2 signal 21 } 
	{ m_axi_gmem2_5_BVALID sc_in sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_BREADY sc_out sc_logic 1 signal 21 } 
	{ m_axi_gmem2_5_BRESP sc_in sc_lv 2 signal 21 } 
	{ m_axi_gmem2_5_BID sc_in sc_lv 1 signal 21 } 
	{ m_axi_gmem2_5_BUSER sc_in sc_lv 1 signal 21 } 
	{ m_axi_gmem2_6_AWVALID sc_out sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_AWREADY sc_in sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_AWADDR sc_out sc_lv 64 signal 22 } 
	{ m_axi_gmem2_6_AWID sc_out sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_AWLEN sc_out sc_lv 8 signal 22 } 
	{ m_axi_gmem2_6_AWSIZE sc_out sc_lv 3 signal 22 } 
	{ m_axi_gmem2_6_AWBURST sc_out sc_lv 2 signal 22 } 
	{ m_axi_gmem2_6_AWLOCK sc_out sc_lv 2 signal 22 } 
	{ m_axi_gmem2_6_AWCACHE sc_out sc_lv 4 signal 22 } 
	{ m_axi_gmem2_6_AWPROT sc_out sc_lv 3 signal 22 } 
	{ m_axi_gmem2_6_AWQOS sc_out sc_lv 4 signal 22 } 
	{ m_axi_gmem2_6_AWREGION sc_out sc_lv 4 signal 22 } 
	{ m_axi_gmem2_6_AWUSER sc_out sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_WVALID sc_out sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_WREADY sc_in sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_WDATA sc_out sc_lv 32 signal 22 } 
	{ m_axi_gmem2_6_WSTRB sc_out sc_lv 4 signal 22 } 
	{ m_axi_gmem2_6_WLAST sc_out sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_WID sc_out sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_WUSER sc_out sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_ARVALID sc_out sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_ARREADY sc_in sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_ARADDR sc_out sc_lv 64 signal 22 } 
	{ m_axi_gmem2_6_ARID sc_out sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_ARLEN sc_out sc_lv 8 signal 22 } 
	{ m_axi_gmem2_6_ARSIZE sc_out sc_lv 3 signal 22 } 
	{ m_axi_gmem2_6_ARBURST sc_out sc_lv 2 signal 22 } 
	{ m_axi_gmem2_6_ARLOCK sc_out sc_lv 2 signal 22 } 
	{ m_axi_gmem2_6_ARCACHE sc_out sc_lv 4 signal 22 } 
	{ m_axi_gmem2_6_ARPROT sc_out sc_lv 3 signal 22 } 
	{ m_axi_gmem2_6_ARQOS sc_out sc_lv 4 signal 22 } 
	{ m_axi_gmem2_6_ARREGION sc_out sc_lv 4 signal 22 } 
	{ m_axi_gmem2_6_ARUSER sc_out sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_RVALID sc_in sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_RREADY sc_out sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_RDATA sc_in sc_lv 32 signal 22 } 
	{ m_axi_gmem2_6_RLAST sc_in sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_RID sc_in sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_RUSER sc_in sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_RRESP sc_in sc_lv 2 signal 22 } 
	{ m_axi_gmem2_6_BVALID sc_in sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_BREADY sc_out sc_logic 1 signal 22 } 
	{ m_axi_gmem2_6_BRESP sc_in sc_lv 2 signal 22 } 
	{ m_axi_gmem2_6_BID sc_in sc_lv 1 signal 22 } 
	{ m_axi_gmem2_6_BUSER sc_in sc_lv 1 signal 22 } 
	{ m_axi_gmem2_7_AWVALID sc_out sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_AWREADY sc_in sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_AWADDR sc_out sc_lv 64 signal 23 } 
	{ m_axi_gmem2_7_AWID sc_out sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_AWLEN sc_out sc_lv 8 signal 23 } 
	{ m_axi_gmem2_7_AWSIZE sc_out sc_lv 3 signal 23 } 
	{ m_axi_gmem2_7_AWBURST sc_out sc_lv 2 signal 23 } 
	{ m_axi_gmem2_7_AWLOCK sc_out sc_lv 2 signal 23 } 
	{ m_axi_gmem2_7_AWCACHE sc_out sc_lv 4 signal 23 } 
	{ m_axi_gmem2_7_AWPROT sc_out sc_lv 3 signal 23 } 
	{ m_axi_gmem2_7_AWQOS sc_out sc_lv 4 signal 23 } 
	{ m_axi_gmem2_7_AWREGION sc_out sc_lv 4 signal 23 } 
	{ m_axi_gmem2_7_AWUSER sc_out sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_WVALID sc_out sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_WREADY sc_in sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_WDATA sc_out sc_lv 32 signal 23 } 
	{ m_axi_gmem2_7_WSTRB sc_out sc_lv 4 signal 23 } 
	{ m_axi_gmem2_7_WLAST sc_out sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_WID sc_out sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_WUSER sc_out sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_ARVALID sc_out sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_ARREADY sc_in sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_ARADDR sc_out sc_lv 64 signal 23 } 
	{ m_axi_gmem2_7_ARID sc_out sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_ARLEN sc_out sc_lv 8 signal 23 } 
	{ m_axi_gmem2_7_ARSIZE sc_out sc_lv 3 signal 23 } 
	{ m_axi_gmem2_7_ARBURST sc_out sc_lv 2 signal 23 } 
	{ m_axi_gmem2_7_ARLOCK sc_out sc_lv 2 signal 23 } 
	{ m_axi_gmem2_7_ARCACHE sc_out sc_lv 4 signal 23 } 
	{ m_axi_gmem2_7_ARPROT sc_out sc_lv 3 signal 23 } 
	{ m_axi_gmem2_7_ARQOS sc_out sc_lv 4 signal 23 } 
	{ m_axi_gmem2_7_ARREGION sc_out sc_lv 4 signal 23 } 
	{ m_axi_gmem2_7_ARUSER sc_out sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_RVALID sc_in sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_RREADY sc_out sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_RDATA sc_in sc_lv 32 signal 23 } 
	{ m_axi_gmem2_7_RLAST sc_in sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_RID sc_in sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_RUSER sc_in sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_RRESP sc_in sc_lv 2 signal 23 } 
	{ m_axi_gmem2_7_BVALID sc_in sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_BREADY sc_out sc_logic 1 signal 23 } 
	{ m_axi_gmem2_7_BRESP sc_in sc_lv 2 signal 23 } 
	{ m_axi_gmem2_7_BID sc_in sc_lv 1 signal 23 } 
	{ m_axi_gmem2_7_BUSER sc_in sc_lv 1 signal 23 } 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 9 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 9 signal -1 } 
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
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"kernel","role":"start","value":"0","valid_bit":"0"},{"name":"kernel","role":"continue","value":"0","valid_bit":"4"},{"name":"kernel","role":"auto_start","value":"0","valid_bit":"7"},{"name":"a_0","role":"data","value":"16"},{"name":"a_1","role":"data","value":"28"},{"name":"a_2","role":"data","value":"40"},{"name":"a_3","role":"data","value":"52"},{"name":"a_4","role":"data","value":"64"},{"name":"a_5","role":"data","value":"76"},{"name":"a_6","role":"data","value":"88"},{"name":"a_7","role":"data","value":"100"},{"name":"b_0","role":"data","value":"112"},{"name":"b_1","role":"data","value":"124"},{"name":"b_2","role":"data","value":"136"},{"name":"b_3","role":"data","value":"148"},{"name":"b_4","role":"data","value":"160"},{"name":"b_5","role":"data","value":"172"},{"name":"b_6","role":"data","value":"184"},{"name":"b_7","role":"data","value":"196"},{"name":"c_0","role":"data","value":"208"},{"name":"c_1","role":"data","value":"220"},{"name":"c_2","role":"data","value":"232"},{"name":"c_3","role":"data","value":"244"},{"name":"c_4","role":"data","value":"256"},{"name":"c_5","role":"data","value":"268"},{"name":"c_6","role":"data","value":"280"},{"name":"c_7","role":"data","value":"292"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"kernel","role":"start","value":"0","valid_bit":"0"},{"name":"kernel","role":"done","value":"0","valid_bit":"1"},{"name":"kernel","role":"idle","value":"0","valid_bit":"2"},{"name":"kernel","role":"ready","value":"0","valid_bit":"3"},{"name":"kernel","role":"auto_start","value":"0","valid_bit":"7"}] },
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
 	{ "name": "m_axi_gmem0_4_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem0_4_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem0_4_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem0_4_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem0_4_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem0_4_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem0_4_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem0_4_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem0_4_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem0_4_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem0_4_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem0_4_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem0_4_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem0_4_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem0_4_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem0_4_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_4", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_4_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_4", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem0_4_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem0_4_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "WID" }} , 
 	{ "name": "m_axi_gmem0_4_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem0_4_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem0_4_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem0_4_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem0_4_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem0_4_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem0_4_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem0_4_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem0_4_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem0_4_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem0_4_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem0_4_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem0_4_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem0_4_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem0_4_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem0_4_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem0_4_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_4", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_4_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_4_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_4_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_4_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_4", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_4_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_4_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_4_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_4", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_4_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_4_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_4", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem0_5_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem0_5_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem0_5_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem0_5_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem0_5_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem0_5_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem0_5_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem0_5_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem0_5_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem0_5_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem0_5_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem0_5_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem0_5_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem0_5_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem0_5_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem0_5_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_5", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_5_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_5", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem0_5_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem0_5_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "WID" }} , 
 	{ "name": "m_axi_gmem0_5_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem0_5_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem0_5_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem0_5_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem0_5_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem0_5_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem0_5_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem0_5_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem0_5_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem0_5_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem0_5_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem0_5_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem0_5_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem0_5_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem0_5_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem0_5_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem0_5_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_5", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_5_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_5_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_5_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_5_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_5", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_5_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_5_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_5_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_5", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_5_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_5_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_5", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem0_6_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem0_6_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem0_6_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem0_6_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem0_6_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem0_6_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem0_6_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem0_6_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem0_6_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem0_6_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem0_6_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem0_6_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem0_6_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem0_6_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem0_6_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem0_6_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_6", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_6_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_6", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem0_6_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem0_6_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "WID" }} , 
 	{ "name": "m_axi_gmem0_6_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem0_6_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem0_6_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem0_6_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem0_6_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem0_6_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem0_6_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem0_6_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem0_6_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem0_6_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem0_6_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem0_6_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem0_6_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem0_6_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem0_6_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem0_6_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem0_6_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_6", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_6_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_6_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_6_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_6_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_6", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_6_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_6_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_6_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_6", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_6_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_6_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_6", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem0_7_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem0_7_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem0_7_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem0_7_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem0_7_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem0_7_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem0_7_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem0_7_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem0_7_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem0_7_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem0_7_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem0_7_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem0_7_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem0_7_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem0_7_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem0_7_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_7", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem0_7_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_7", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem0_7_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem0_7_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "WID" }} , 
 	{ "name": "m_axi_gmem0_7_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem0_7_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem0_7_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem0_7_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem0_7_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem0_7_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem0_7_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem0_7_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem0_7_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem0_7_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem0_7_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem0_7_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem0_7_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem0_7_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem0_7_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem0_7_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem0_7_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem0_7", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem0_7_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem0_7_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "RID" }} , 
 	{ "name": "m_axi_gmem0_7_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem0_7_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_7", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem0_7_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem0_7_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem0_7_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem0_7", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem0_7_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "BID" }} , 
 	{ "name": "m_axi_gmem0_7_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem0_7", "role": "BUSER" }} , 
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
 	{ "name": "m_axi_gmem1_4_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem1_4_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem1_4_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem1_4_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem1_4_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem1_4_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem1_4_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem1_4_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem1_4_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem1_4_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem1_4_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem1_4_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem1_4_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem1_4_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem1_4_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem1_4_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_4", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_4_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_4", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem1_4_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem1_4_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "WID" }} , 
 	{ "name": "m_axi_gmem1_4_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem1_4_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem1_4_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem1_4_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem1_4_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem1_4_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem1_4_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem1_4_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem1_4_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem1_4_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem1_4_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem1_4_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem1_4_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem1_4_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem1_4_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem1_4_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem1_4_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_4", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_4_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_4_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_4_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_4_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_4", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_4_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_4_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_4_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_4", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_4_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_4_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_4", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem1_5_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem1_5_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem1_5_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem1_5_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem1_5_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem1_5_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem1_5_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem1_5_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem1_5_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem1_5_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem1_5_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem1_5_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem1_5_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem1_5_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem1_5_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem1_5_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_5", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_5_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_5", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem1_5_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem1_5_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "WID" }} , 
 	{ "name": "m_axi_gmem1_5_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem1_5_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem1_5_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem1_5_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem1_5_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem1_5_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem1_5_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem1_5_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem1_5_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem1_5_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem1_5_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem1_5_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem1_5_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem1_5_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem1_5_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem1_5_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem1_5_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_5", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_5_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_5_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_5_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_5_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_5", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_5_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_5_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_5_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_5", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_5_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_5_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_5", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem1_6_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem1_6_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem1_6_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem1_6_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem1_6_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem1_6_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem1_6_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem1_6_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem1_6_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem1_6_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem1_6_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem1_6_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem1_6_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem1_6_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem1_6_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem1_6_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_6", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_6_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_6", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem1_6_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem1_6_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "WID" }} , 
 	{ "name": "m_axi_gmem1_6_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem1_6_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem1_6_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem1_6_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem1_6_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem1_6_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem1_6_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem1_6_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem1_6_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem1_6_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem1_6_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem1_6_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem1_6_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem1_6_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem1_6_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem1_6_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem1_6_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_6", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_6_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_6_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_6_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_6_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_6", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_6_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_6_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_6_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_6", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_6_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_6_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_6", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem1_7_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem1_7_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem1_7_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem1_7_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem1_7_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem1_7_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem1_7_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem1_7_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem1_7_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem1_7_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem1_7_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem1_7_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem1_7_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem1_7_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem1_7_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem1_7_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_7", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem1_7_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_7", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem1_7_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem1_7_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "WID" }} , 
 	{ "name": "m_axi_gmem1_7_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem1_7_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem1_7_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem1_7_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem1_7_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem1_7_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem1_7_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem1_7_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem1_7_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem1_7_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem1_7_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem1_7_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem1_7_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem1_7_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem1_7_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem1_7_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem1_7_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem1_7", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem1_7_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem1_7_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "RID" }} , 
 	{ "name": "m_axi_gmem1_7_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem1_7_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_7", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem1_7_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem1_7_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem1_7_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem1_7", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem1_7_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "BID" }} , 
 	{ "name": "m_axi_gmem1_7_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem1_7", "role": "BUSER" }} , 
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
 	{ "name": "m_axi_gmem2_0_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_0_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_0", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem2_0_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_0", "role": "RDATA" }} , 
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
 	{ "name": "m_axi_gmem2_1_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_1_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_1", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem2_1_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_1", "role": "RDATA" }} , 
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
 	{ "name": "m_axi_gmem2_2_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_2_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_2", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem2_2_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_2", "role": "RDATA" }} , 
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
 	{ "name": "m_axi_gmem2_3_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_3_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_3", "role": "WSTRB" }} , 
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
 	{ "name": "m_axi_gmem2_3_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_3_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_3_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_3_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_3_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_3", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_3_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_3_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_3_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_3_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_3_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_3", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem2_4_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem2_4_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem2_4_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem2_4_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem2_4_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem2_4_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem2_4_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem2_4_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem2_4_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem2_4_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem2_4_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem2_4_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem2_4_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem2_4_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem2_4_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem2_4_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_4", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_4_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_4", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem2_4_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem2_4_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "WID" }} , 
 	{ "name": "m_axi_gmem2_4_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem2_4_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem2_4_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem2_4_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem2_4_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem2_4_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem2_4_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem2_4_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem2_4_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem2_4_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem2_4_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem2_4_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem2_4_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem2_4_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem2_4_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem2_4_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem2_4_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_4", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_4_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_4_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_4_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_4_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_4", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_4_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_4_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_4_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_4", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_4_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_4_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_4", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem2_5_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem2_5_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem2_5_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem2_5_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem2_5_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem2_5_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem2_5_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem2_5_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem2_5_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem2_5_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem2_5_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem2_5_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem2_5_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem2_5_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem2_5_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem2_5_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_5", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_5_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_5", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem2_5_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem2_5_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "WID" }} , 
 	{ "name": "m_axi_gmem2_5_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem2_5_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem2_5_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem2_5_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem2_5_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem2_5_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem2_5_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem2_5_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem2_5_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem2_5_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem2_5_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem2_5_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem2_5_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem2_5_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem2_5_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem2_5_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem2_5_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_5", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_5_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_5_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_5_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_5_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_5", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_5_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_5_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_5_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_5", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_5_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_5_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_5", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem2_6_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem2_6_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem2_6_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem2_6_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem2_6_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem2_6_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem2_6_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem2_6_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem2_6_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem2_6_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem2_6_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem2_6_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem2_6_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem2_6_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem2_6_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem2_6_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_6", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_6_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_6", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem2_6_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem2_6_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "WID" }} , 
 	{ "name": "m_axi_gmem2_6_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem2_6_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem2_6_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem2_6_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem2_6_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem2_6_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem2_6_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem2_6_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem2_6_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem2_6_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem2_6_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem2_6_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem2_6_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem2_6_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem2_6_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem2_6_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem2_6_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_6", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_6_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_6_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_6_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_6_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_6", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_6_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_6_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_6_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_6", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_6_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_6_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_6", "role": "BUSER" }} , 
 	{ "name": "m_axi_gmem2_7_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem2_7_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem2_7_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem2_7_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem2_7_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem2_7_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem2_7_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem2_7_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem2_7_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem2_7_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem2_7_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem2_7_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem2_7_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem2_7_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem2_7_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem2_7_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_7", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem2_7_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_7", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem2_7_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem2_7_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "WID" }} , 
 	{ "name": "m_axi_gmem2_7_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem2_7_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem2_7_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem2_7_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem2_7_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem2_7_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem2_7_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem2_7_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem2_7_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem2_7_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem2_7_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem2_7_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem2_7_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem2_7_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem2_7_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem2_7_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem2_7_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem2_7", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem2_7_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem2_7_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "RID" }} , 
 	{ "name": "m_axi_gmem2_7_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem2_7_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_7", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem2_7_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem2_7_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem2_7_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem2_7", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem2_7_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "BID" }} , 
 	{ "name": "m_axi_gmem2_7_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem2_7", "role": "BUSER" }}  ]}

set ArgLastReadFirstWriteLatency {
	kernel {
		gmem0_0 {Type I LastRead 72 FirstWrite -1}
		gmem0_1 {Type I LastRead 72 FirstWrite -1}
		gmem0_2 {Type I LastRead 72 FirstWrite -1}
		gmem0_3 {Type I LastRead 72 FirstWrite -1}
		gmem0_4 {Type I LastRead 72 FirstWrite -1}
		gmem0_5 {Type I LastRead 72 FirstWrite -1}
		gmem0_6 {Type I LastRead 72 FirstWrite -1}
		gmem0_7 {Type I LastRead 72 FirstWrite -1}
		gmem1_0 {Type I LastRead 72 FirstWrite -1}
		gmem1_1 {Type I LastRead 72 FirstWrite -1}
		gmem1_2 {Type I LastRead 72 FirstWrite -1}
		gmem1_3 {Type I LastRead 72 FirstWrite -1}
		gmem1_4 {Type I LastRead 72 FirstWrite -1}
		gmem1_5 {Type I LastRead 72 FirstWrite -1}
		gmem1_6 {Type I LastRead 72 FirstWrite -1}
		gmem1_7 {Type I LastRead 72 FirstWrite -1}
		gmem2_0 {Type O LastRead 77 FirstWrite 76}
		gmem2_1 {Type O LastRead 77 FirstWrite 76}
		gmem2_2 {Type O LastRead 77 FirstWrite 76}
		gmem2_3 {Type O LastRead 77 FirstWrite 76}
		gmem2_4 {Type O LastRead 77 FirstWrite 76}
		gmem2_5 {Type O LastRead 77 FirstWrite 76}
		gmem2_6 {Type O LastRead 77 FirstWrite 76}
		gmem2_7 {Type O LastRead 77 FirstWrite 76}
		a_0 {Type I LastRead 0 FirstWrite -1}
		a_1 {Type I LastRead 0 FirstWrite -1}
		a_2 {Type I LastRead 0 FirstWrite -1}
		a_3 {Type I LastRead 0 FirstWrite -1}
		a_4 {Type I LastRead 0 FirstWrite -1}
		a_5 {Type I LastRead 0 FirstWrite -1}
		a_6 {Type I LastRead 0 FirstWrite -1}
		a_7 {Type I LastRead 0 FirstWrite -1}
		b_0 {Type I LastRead 0 FirstWrite -1}
		b_1 {Type I LastRead 0 FirstWrite -1}
		b_2 {Type I LastRead 0 FirstWrite -1}
		b_3 {Type I LastRead 0 FirstWrite -1}
		b_4 {Type I LastRead 0 FirstWrite -1}
		b_5 {Type I LastRead 0 FirstWrite -1}
		b_6 {Type I LastRead 0 FirstWrite -1}
		b_7 {Type I LastRead 0 FirstWrite -1}
		c_0 {Type I LastRead 0 FirstWrite -1}
		c_1 {Type I LastRead 0 FirstWrite -1}
		c_2 {Type I LastRead 0 FirstWrite -1}
		c_3 {Type I LastRead 0 FirstWrite -1}
		c_4 {Type I LastRead 0 FirstWrite -1}
		c_5 {Type I LastRead 0 FirstWrite -1}
		c_6 {Type I LastRead 0 FirstWrite -1}
		c_7 {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "145", "Max" : "145"}
	, {"Name" : "Interval", "Min" : "146", "Max" : "146"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	gmem0_0 { m_axi {  { m_axi_gmem0_0_AWVALID VALID 1 1 }  { m_axi_gmem0_0_AWREADY READY 0 1 }  { m_axi_gmem0_0_AWADDR ADDR 1 64 }  { m_axi_gmem0_0_AWID ID 1 1 }  { m_axi_gmem0_0_AWLEN SIZE 1 8 }  { m_axi_gmem0_0_AWSIZE BURST 1 3 }  { m_axi_gmem0_0_AWBURST LOCK 1 2 }  { m_axi_gmem0_0_AWLOCK CACHE 1 2 }  { m_axi_gmem0_0_AWCACHE PROT 1 4 }  { m_axi_gmem0_0_AWPROT QOS 1 3 }  { m_axi_gmem0_0_AWQOS REGION 1 4 }  { m_axi_gmem0_0_AWREGION USER 1 4 }  { m_axi_gmem0_0_AWUSER DATA 1 1 }  { m_axi_gmem0_0_WVALID VALID 1 1 }  { m_axi_gmem0_0_WREADY READY 0 1 }  { m_axi_gmem0_0_WDATA FIFONUM 1 32 }  { m_axi_gmem0_0_WSTRB STRB 1 4 }  { m_axi_gmem0_0_WLAST LAST 1 1 }  { m_axi_gmem0_0_WID ID 1 1 }  { m_axi_gmem0_0_WUSER DATA 1 1 }  { m_axi_gmem0_0_ARVALID VALID 1 1 }  { m_axi_gmem0_0_ARREADY READY 0 1 }  { m_axi_gmem0_0_ARADDR ADDR 1 64 }  { m_axi_gmem0_0_ARID ID 1 1 }  { m_axi_gmem0_0_ARLEN SIZE 1 8 }  { m_axi_gmem0_0_ARSIZE BURST 1 3 }  { m_axi_gmem0_0_ARBURST LOCK 1 2 }  { m_axi_gmem0_0_ARLOCK CACHE 1 2 }  { m_axi_gmem0_0_ARCACHE PROT 1 4 }  { m_axi_gmem0_0_ARPROT QOS 1 3 }  { m_axi_gmem0_0_ARQOS REGION 1 4 }  { m_axi_gmem0_0_ARREGION USER 1 4 }  { m_axi_gmem0_0_ARUSER DATA 1 1 }  { m_axi_gmem0_0_RVALID VALID 0 1 }  { m_axi_gmem0_0_RREADY READY 1 1 }  { m_axi_gmem0_0_RDATA FIFONUM 0 32 }  { m_axi_gmem0_0_RLAST LAST 0 1 }  { m_axi_gmem0_0_RID ID 0 1 }  { m_axi_gmem0_0_RUSER DATA 0 1 }  { m_axi_gmem0_0_RRESP RESP 0 2 }  { m_axi_gmem0_0_BVALID VALID 0 1 }  { m_axi_gmem0_0_BREADY READY 1 1 }  { m_axi_gmem0_0_BRESP RESP 0 2 }  { m_axi_gmem0_0_BID ID 0 1 }  { m_axi_gmem0_0_BUSER DATA 0 1 } } }
	gmem0_1 { m_axi {  { m_axi_gmem0_1_AWVALID VALID 1 1 }  { m_axi_gmem0_1_AWREADY READY 0 1 }  { m_axi_gmem0_1_AWADDR ADDR 1 64 }  { m_axi_gmem0_1_AWID ID 1 1 }  { m_axi_gmem0_1_AWLEN SIZE 1 8 }  { m_axi_gmem0_1_AWSIZE BURST 1 3 }  { m_axi_gmem0_1_AWBURST LOCK 1 2 }  { m_axi_gmem0_1_AWLOCK CACHE 1 2 }  { m_axi_gmem0_1_AWCACHE PROT 1 4 }  { m_axi_gmem0_1_AWPROT QOS 1 3 }  { m_axi_gmem0_1_AWQOS REGION 1 4 }  { m_axi_gmem0_1_AWREGION USER 1 4 }  { m_axi_gmem0_1_AWUSER DATA 1 1 }  { m_axi_gmem0_1_WVALID VALID 1 1 }  { m_axi_gmem0_1_WREADY READY 0 1 }  { m_axi_gmem0_1_WDATA FIFONUM 1 32 }  { m_axi_gmem0_1_WSTRB STRB 1 4 }  { m_axi_gmem0_1_WLAST LAST 1 1 }  { m_axi_gmem0_1_WID ID 1 1 }  { m_axi_gmem0_1_WUSER DATA 1 1 }  { m_axi_gmem0_1_ARVALID VALID 1 1 }  { m_axi_gmem0_1_ARREADY READY 0 1 }  { m_axi_gmem0_1_ARADDR ADDR 1 64 }  { m_axi_gmem0_1_ARID ID 1 1 }  { m_axi_gmem0_1_ARLEN SIZE 1 8 }  { m_axi_gmem0_1_ARSIZE BURST 1 3 }  { m_axi_gmem0_1_ARBURST LOCK 1 2 }  { m_axi_gmem0_1_ARLOCK CACHE 1 2 }  { m_axi_gmem0_1_ARCACHE PROT 1 4 }  { m_axi_gmem0_1_ARPROT QOS 1 3 }  { m_axi_gmem0_1_ARQOS REGION 1 4 }  { m_axi_gmem0_1_ARREGION USER 1 4 }  { m_axi_gmem0_1_ARUSER DATA 1 1 }  { m_axi_gmem0_1_RVALID VALID 0 1 }  { m_axi_gmem0_1_RREADY READY 1 1 }  { m_axi_gmem0_1_RDATA FIFONUM 0 32 }  { m_axi_gmem0_1_RLAST LAST 0 1 }  { m_axi_gmem0_1_RID ID 0 1 }  { m_axi_gmem0_1_RUSER DATA 0 1 }  { m_axi_gmem0_1_RRESP RESP 0 2 }  { m_axi_gmem0_1_BVALID VALID 0 1 }  { m_axi_gmem0_1_BREADY READY 1 1 }  { m_axi_gmem0_1_BRESP RESP 0 2 }  { m_axi_gmem0_1_BID ID 0 1 }  { m_axi_gmem0_1_BUSER DATA 0 1 } } }
	gmem0_2 { m_axi {  { m_axi_gmem0_2_AWVALID VALID 1 1 }  { m_axi_gmem0_2_AWREADY READY 0 1 }  { m_axi_gmem0_2_AWADDR ADDR 1 64 }  { m_axi_gmem0_2_AWID ID 1 1 }  { m_axi_gmem0_2_AWLEN SIZE 1 8 }  { m_axi_gmem0_2_AWSIZE BURST 1 3 }  { m_axi_gmem0_2_AWBURST LOCK 1 2 }  { m_axi_gmem0_2_AWLOCK CACHE 1 2 }  { m_axi_gmem0_2_AWCACHE PROT 1 4 }  { m_axi_gmem0_2_AWPROT QOS 1 3 }  { m_axi_gmem0_2_AWQOS REGION 1 4 }  { m_axi_gmem0_2_AWREGION USER 1 4 }  { m_axi_gmem0_2_AWUSER DATA 1 1 }  { m_axi_gmem0_2_WVALID VALID 1 1 }  { m_axi_gmem0_2_WREADY READY 0 1 }  { m_axi_gmem0_2_WDATA FIFONUM 1 32 }  { m_axi_gmem0_2_WSTRB STRB 1 4 }  { m_axi_gmem0_2_WLAST LAST 1 1 }  { m_axi_gmem0_2_WID ID 1 1 }  { m_axi_gmem0_2_WUSER DATA 1 1 }  { m_axi_gmem0_2_ARVALID VALID 1 1 }  { m_axi_gmem0_2_ARREADY READY 0 1 }  { m_axi_gmem0_2_ARADDR ADDR 1 64 }  { m_axi_gmem0_2_ARID ID 1 1 }  { m_axi_gmem0_2_ARLEN SIZE 1 8 }  { m_axi_gmem0_2_ARSIZE BURST 1 3 }  { m_axi_gmem0_2_ARBURST LOCK 1 2 }  { m_axi_gmem0_2_ARLOCK CACHE 1 2 }  { m_axi_gmem0_2_ARCACHE PROT 1 4 }  { m_axi_gmem0_2_ARPROT QOS 1 3 }  { m_axi_gmem0_2_ARQOS REGION 1 4 }  { m_axi_gmem0_2_ARREGION USER 1 4 }  { m_axi_gmem0_2_ARUSER DATA 1 1 }  { m_axi_gmem0_2_RVALID VALID 0 1 }  { m_axi_gmem0_2_RREADY READY 1 1 }  { m_axi_gmem0_2_RDATA FIFONUM 0 32 }  { m_axi_gmem0_2_RLAST LAST 0 1 }  { m_axi_gmem0_2_RID ID 0 1 }  { m_axi_gmem0_2_RUSER DATA 0 1 }  { m_axi_gmem0_2_RRESP RESP 0 2 }  { m_axi_gmem0_2_BVALID VALID 0 1 }  { m_axi_gmem0_2_BREADY READY 1 1 }  { m_axi_gmem0_2_BRESP RESP 0 2 }  { m_axi_gmem0_2_BID ID 0 1 }  { m_axi_gmem0_2_BUSER DATA 0 1 } } }
	gmem0_3 { m_axi {  { m_axi_gmem0_3_AWVALID VALID 1 1 }  { m_axi_gmem0_3_AWREADY READY 0 1 }  { m_axi_gmem0_3_AWADDR ADDR 1 64 }  { m_axi_gmem0_3_AWID ID 1 1 }  { m_axi_gmem0_3_AWLEN SIZE 1 8 }  { m_axi_gmem0_3_AWSIZE BURST 1 3 }  { m_axi_gmem0_3_AWBURST LOCK 1 2 }  { m_axi_gmem0_3_AWLOCK CACHE 1 2 }  { m_axi_gmem0_3_AWCACHE PROT 1 4 }  { m_axi_gmem0_3_AWPROT QOS 1 3 }  { m_axi_gmem0_3_AWQOS REGION 1 4 }  { m_axi_gmem0_3_AWREGION USER 1 4 }  { m_axi_gmem0_3_AWUSER DATA 1 1 }  { m_axi_gmem0_3_WVALID VALID 1 1 }  { m_axi_gmem0_3_WREADY READY 0 1 }  { m_axi_gmem0_3_WDATA FIFONUM 1 32 }  { m_axi_gmem0_3_WSTRB STRB 1 4 }  { m_axi_gmem0_3_WLAST LAST 1 1 }  { m_axi_gmem0_3_WID ID 1 1 }  { m_axi_gmem0_3_WUSER DATA 1 1 }  { m_axi_gmem0_3_ARVALID VALID 1 1 }  { m_axi_gmem0_3_ARREADY READY 0 1 }  { m_axi_gmem0_3_ARADDR ADDR 1 64 }  { m_axi_gmem0_3_ARID ID 1 1 }  { m_axi_gmem0_3_ARLEN SIZE 1 8 }  { m_axi_gmem0_3_ARSIZE BURST 1 3 }  { m_axi_gmem0_3_ARBURST LOCK 1 2 }  { m_axi_gmem0_3_ARLOCK CACHE 1 2 }  { m_axi_gmem0_3_ARCACHE PROT 1 4 }  { m_axi_gmem0_3_ARPROT QOS 1 3 }  { m_axi_gmem0_3_ARQOS REGION 1 4 }  { m_axi_gmem0_3_ARREGION USER 1 4 }  { m_axi_gmem0_3_ARUSER DATA 1 1 }  { m_axi_gmem0_3_RVALID VALID 0 1 }  { m_axi_gmem0_3_RREADY READY 1 1 }  { m_axi_gmem0_3_RDATA FIFONUM 0 32 }  { m_axi_gmem0_3_RLAST LAST 0 1 }  { m_axi_gmem0_3_RID ID 0 1 }  { m_axi_gmem0_3_RUSER DATA 0 1 }  { m_axi_gmem0_3_RRESP RESP 0 2 }  { m_axi_gmem0_3_BVALID VALID 0 1 }  { m_axi_gmem0_3_BREADY READY 1 1 }  { m_axi_gmem0_3_BRESP RESP 0 2 }  { m_axi_gmem0_3_BID ID 0 1 }  { m_axi_gmem0_3_BUSER DATA 0 1 } } }
	gmem0_4 { m_axi {  { m_axi_gmem0_4_AWVALID VALID 1 1 }  { m_axi_gmem0_4_AWREADY READY 0 1 }  { m_axi_gmem0_4_AWADDR ADDR 1 64 }  { m_axi_gmem0_4_AWID ID 1 1 }  { m_axi_gmem0_4_AWLEN SIZE 1 8 }  { m_axi_gmem0_4_AWSIZE BURST 1 3 }  { m_axi_gmem0_4_AWBURST LOCK 1 2 }  { m_axi_gmem0_4_AWLOCK CACHE 1 2 }  { m_axi_gmem0_4_AWCACHE PROT 1 4 }  { m_axi_gmem0_4_AWPROT QOS 1 3 }  { m_axi_gmem0_4_AWQOS REGION 1 4 }  { m_axi_gmem0_4_AWREGION USER 1 4 }  { m_axi_gmem0_4_AWUSER DATA 1 1 }  { m_axi_gmem0_4_WVALID VALID 1 1 }  { m_axi_gmem0_4_WREADY READY 0 1 }  { m_axi_gmem0_4_WDATA FIFONUM 1 32 }  { m_axi_gmem0_4_WSTRB STRB 1 4 }  { m_axi_gmem0_4_WLAST LAST 1 1 }  { m_axi_gmem0_4_WID ID 1 1 }  { m_axi_gmem0_4_WUSER DATA 1 1 }  { m_axi_gmem0_4_ARVALID VALID 1 1 }  { m_axi_gmem0_4_ARREADY READY 0 1 }  { m_axi_gmem0_4_ARADDR ADDR 1 64 }  { m_axi_gmem0_4_ARID ID 1 1 }  { m_axi_gmem0_4_ARLEN SIZE 1 8 }  { m_axi_gmem0_4_ARSIZE BURST 1 3 }  { m_axi_gmem0_4_ARBURST LOCK 1 2 }  { m_axi_gmem0_4_ARLOCK CACHE 1 2 }  { m_axi_gmem0_4_ARCACHE PROT 1 4 }  { m_axi_gmem0_4_ARPROT QOS 1 3 }  { m_axi_gmem0_4_ARQOS REGION 1 4 }  { m_axi_gmem0_4_ARREGION USER 1 4 }  { m_axi_gmem0_4_ARUSER DATA 1 1 }  { m_axi_gmem0_4_RVALID VALID 0 1 }  { m_axi_gmem0_4_RREADY READY 1 1 }  { m_axi_gmem0_4_RDATA FIFONUM 0 32 }  { m_axi_gmem0_4_RLAST LAST 0 1 }  { m_axi_gmem0_4_RID ID 0 1 }  { m_axi_gmem0_4_RUSER DATA 0 1 }  { m_axi_gmem0_4_RRESP RESP 0 2 }  { m_axi_gmem0_4_BVALID VALID 0 1 }  { m_axi_gmem0_4_BREADY READY 1 1 }  { m_axi_gmem0_4_BRESP RESP 0 2 }  { m_axi_gmem0_4_BID ID 0 1 }  { m_axi_gmem0_4_BUSER DATA 0 1 } } }
	gmem0_5 { m_axi {  { m_axi_gmem0_5_AWVALID VALID 1 1 }  { m_axi_gmem0_5_AWREADY READY 0 1 }  { m_axi_gmem0_5_AWADDR ADDR 1 64 }  { m_axi_gmem0_5_AWID ID 1 1 }  { m_axi_gmem0_5_AWLEN SIZE 1 8 }  { m_axi_gmem0_5_AWSIZE BURST 1 3 }  { m_axi_gmem0_5_AWBURST LOCK 1 2 }  { m_axi_gmem0_5_AWLOCK CACHE 1 2 }  { m_axi_gmem0_5_AWCACHE PROT 1 4 }  { m_axi_gmem0_5_AWPROT QOS 1 3 }  { m_axi_gmem0_5_AWQOS REGION 1 4 }  { m_axi_gmem0_5_AWREGION USER 1 4 }  { m_axi_gmem0_5_AWUSER DATA 1 1 }  { m_axi_gmem0_5_WVALID VALID 1 1 }  { m_axi_gmem0_5_WREADY READY 0 1 }  { m_axi_gmem0_5_WDATA FIFONUM 1 32 }  { m_axi_gmem0_5_WSTRB STRB 1 4 }  { m_axi_gmem0_5_WLAST LAST 1 1 }  { m_axi_gmem0_5_WID ID 1 1 }  { m_axi_gmem0_5_WUSER DATA 1 1 }  { m_axi_gmem0_5_ARVALID VALID 1 1 }  { m_axi_gmem0_5_ARREADY READY 0 1 }  { m_axi_gmem0_5_ARADDR ADDR 1 64 }  { m_axi_gmem0_5_ARID ID 1 1 }  { m_axi_gmem0_5_ARLEN SIZE 1 8 }  { m_axi_gmem0_5_ARSIZE BURST 1 3 }  { m_axi_gmem0_5_ARBURST LOCK 1 2 }  { m_axi_gmem0_5_ARLOCK CACHE 1 2 }  { m_axi_gmem0_5_ARCACHE PROT 1 4 }  { m_axi_gmem0_5_ARPROT QOS 1 3 }  { m_axi_gmem0_5_ARQOS REGION 1 4 }  { m_axi_gmem0_5_ARREGION USER 1 4 }  { m_axi_gmem0_5_ARUSER DATA 1 1 }  { m_axi_gmem0_5_RVALID VALID 0 1 }  { m_axi_gmem0_5_RREADY READY 1 1 }  { m_axi_gmem0_5_RDATA FIFONUM 0 32 }  { m_axi_gmem0_5_RLAST LAST 0 1 }  { m_axi_gmem0_5_RID ID 0 1 }  { m_axi_gmem0_5_RUSER DATA 0 1 }  { m_axi_gmem0_5_RRESP RESP 0 2 }  { m_axi_gmem0_5_BVALID VALID 0 1 }  { m_axi_gmem0_5_BREADY READY 1 1 }  { m_axi_gmem0_5_BRESP RESP 0 2 }  { m_axi_gmem0_5_BID ID 0 1 }  { m_axi_gmem0_5_BUSER DATA 0 1 } } }
	gmem0_6 { m_axi {  { m_axi_gmem0_6_AWVALID VALID 1 1 }  { m_axi_gmem0_6_AWREADY READY 0 1 }  { m_axi_gmem0_6_AWADDR ADDR 1 64 }  { m_axi_gmem0_6_AWID ID 1 1 }  { m_axi_gmem0_6_AWLEN SIZE 1 8 }  { m_axi_gmem0_6_AWSIZE BURST 1 3 }  { m_axi_gmem0_6_AWBURST LOCK 1 2 }  { m_axi_gmem0_6_AWLOCK CACHE 1 2 }  { m_axi_gmem0_6_AWCACHE PROT 1 4 }  { m_axi_gmem0_6_AWPROT QOS 1 3 }  { m_axi_gmem0_6_AWQOS REGION 1 4 }  { m_axi_gmem0_6_AWREGION USER 1 4 }  { m_axi_gmem0_6_AWUSER DATA 1 1 }  { m_axi_gmem0_6_WVALID VALID 1 1 }  { m_axi_gmem0_6_WREADY READY 0 1 }  { m_axi_gmem0_6_WDATA FIFONUM 1 32 }  { m_axi_gmem0_6_WSTRB STRB 1 4 }  { m_axi_gmem0_6_WLAST LAST 1 1 }  { m_axi_gmem0_6_WID ID 1 1 }  { m_axi_gmem0_6_WUSER DATA 1 1 }  { m_axi_gmem0_6_ARVALID VALID 1 1 }  { m_axi_gmem0_6_ARREADY READY 0 1 }  { m_axi_gmem0_6_ARADDR ADDR 1 64 }  { m_axi_gmem0_6_ARID ID 1 1 }  { m_axi_gmem0_6_ARLEN SIZE 1 8 }  { m_axi_gmem0_6_ARSIZE BURST 1 3 }  { m_axi_gmem0_6_ARBURST LOCK 1 2 }  { m_axi_gmem0_6_ARLOCK CACHE 1 2 }  { m_axi_gmem0_6_ARCACHE PROT 1 4 }  { m_axi_gmem0_6_ARPROT QOS 1 3 }  { m_axi_gmem0_6_ARQOS REGION 1 4 }  { m_axi_gmem0_6_ARREGION USER 1 4 }  { m_axi_gmem0_6_ARUSER DATA 1 1 }  { m_axi_gmem0_6_RVALID VALID 0 1 }  { m_axi_gmem0_6_RREADY READY 1 1 }  { m_axi_gmem0_6_RDATA FIFONUM 0 32 }  { m_axi_gmem0_6_RLAST LAST 0 1 }  { m_axi_gmem0_6_RID ID 0 1 }  { m_axi_gmem0_6_RUSER DATA 0 1 }  { m_axi_gmem0_6_RRESP RESP 0 2 }  { m_axi_gmem0_6_BVALID VALID 0 1 }  { m_axi_gmem0_6_BREADY READY 1 1 }  { m_axi_gmem0_6_BRESP RESP 0 2 }  { m_axi_gmem0_6_BID ID 0 1 }  { m_axi_gmem0_6_BUSER DATA 0 1 } } }
	gmem0_7 { m_axi {  { m_axi_gmem0_7_AWVALID VALID 1 1 }  { m_axi_gmem0_7_AWREADY READY 0 1 }  { m_axi_gmem0_7_AWADDR ADDR 1 64 }  { m_axi_gmem0_7_AWID ID 1 1 }  { m_axi_gmem0_7_AWLEN SIZE 1 8 }  { m_axi_gmem0_7_AWSIZE BURST 1 3 }  { m_axi_gmem0_7_AWBURST LOCK 1 2 }  { m_axi_gmem0_7_AWLOCK CACHE 1 2 }  { m_axi_gmem0_7_AWCACHE PROT 1 4 }  { m_axi_gmem0_7_AWPROT QOS 1 3 }  { m_axi_gmem0_7_AWQOS REGION 1 4 }  { m_axi_gmem0_7_AWREGION USER 1 4 }  { m_axi_gmem0_7_AWUSER DATA 1 1 }  { m_axi_gmem0_7_WVALID VALID 1 1 }  { m_axi_gmem0_7_WREADY READY 0 1 }  { m_axi_gmem0_7_WDATA FIFONUM 1 32 }  { m_axi_gmem0_7_WSTRB STRB 1 4 }  { m_axi_gmem0_7_WLAST LAST 1 1 }  { m_axi_gmem0_7_WID ID 1 1 }  { m_axi_gmem0_7_WUSER DATA 1 1 }  { m_axi_gmem0_7_ARVALID VALID 1 1 }  { m_axi_gmem0_7_ARREADY READY 0 1 }  { m_axi_gmem0_7_ARADDR ADDR 1 64 }  { m_axi_gmem0_7_ARID ID 1 1 }  { m_axi_gmem0_7_ARLEN SIZE 1 8 }  { m_axi_gmem0_7_ARSIZE BURST 1 3 }  { m_axi_gmem0_7_ARBURST LOCK 1 2 }  { m_axi_gmem0_7_ARLOCK CACHE 1 2 }  { m_axi_gmem0_7_ARCACHE PROT 1 4 }  { m_axi_gmem0_7_ARPROT QOS 1 3 }  { m_axi_gmem0_7_ARQOS REGION 1 4 }  { m_axi_gmem0_7_ARREGION USER 1 4 }  { m_axi_gmem0_7_ARUSER DATA 1 1 }  { m_axi_gmem0_7_RVALID VALID 0 1 }  { m_axi_gmem0_7_RREADY READY 1 1 }  { m_axi_gmem0_7_RDATA FIFONUM 0 32 }  { m_axi_gmem0_7_RLAST LAST 0 1 }  { m_axi_gmem0_7_RID ID 0 1 }  { m_axi_gmem0_7_RUSER DATA 0 1 }  { m_axi_gmem0_7_RRESP RESP 0 2 }  { m_axi_gmem0_7_BVALID VALID 0 1 }  { m_axi_gmem0_7_BREADY READY 1 1 }  { m_axi_gmem0_7_BRESP RESP 0 2 }  { m_axi_gmem0_7_BID ID 0 1 }  { m_axi_gmem0_7_BUSER DATA 0 1 } } }
	gmem1_0 { m_axi {  { m_axi_gmem1_0_AWVALID VALID 1 1 }  { m_axi_gmem1_0_AWREADY READY 0 1 }  { m_axi_gmem1_0_AWADDR ADDR 1 64 }  { m_axi_gmem1_0_AWID ID 1 1 }  { m_axi_gmem1_0_AWLEN SIZE 1 8 }  { m_axi_gmem1_0_AWSIZE BURST 1 3 }  { m_axi_gmem1_0_AWBURST LOCK 1 2 }  { m_axi_gmem1_0_AWLOCK CACHE 1 2 }  { m_axi_gmem1_0_AWCACHE PROT 1 4 }  { m_axi_gmem1_0_AWPROT QOS 1 3 }  { m_axi_gmem1_0_AWQOS REGION 1 4 }  { m_axi_gmem1_0_AWREGION USER 1 4 }  { m_axi_gmem1_0_AWUSER DATA 1 1 }  { m_axi_gmem1_0_WVALID VALID 1 1 }  { m_axi_gmem1_0_WREADY READY 0 1 }  { m_axi_gmem1_0_WDATA FIFONUM 1 32 }  { m_axi_gmem1_0_WSTRB STRB 1 4 }  { m_axi_gmem1_0_WLAST LAST 1 1 }  { m_axi_gmem1_0_WID ID 1 1 }  { m_axi_gmem1_0_WUSER DATA 1 1 }  { m_axi_gmem1_0_ARVALID VALID 1 1 }  { m_axi_gmem1_0_ARREADY READY 0 1 }  { m_axi_gmem1_0_ARADDR ADDR 1 64 }  { m_axi_gmem1_0_ARID ID 1 1 }  { m_axi_gmem1_0_ARLEN SIZE 1 8 }  { m_axi_gmem1_0_ARSIZE BURST 1 3 }  { m_axi_gmem1_0_ARBURST LOCK 1 2 }  { m_axi_gmem1_0_ARLOCK CACHE 1 2 }  { m_axi_gmem1_0_ARCACHE PROT 1 4 }  { m_axi_gmem1_0_ARPROT QOS 1 3 }  { m_axi_gmem1_0_ARQOS REGION 1 4 }  { m_axi_gmem1_0_ARREGION USER 1 4 }  { m_axi_gmem1_0_ARUSER DATA 1 1 }  { m_axi_gmem1_0_RVALID VALID 0 1 }  { m_axi_gmem1_0_RREADY READY 1 1 }  { m_axi_gmem1_0_RDATA FIFONUM 0 32 }  { m_axi_gmem1_0_RLAST LAST 0 1 }  { m_axi_gmem1_0_RID ID 0 1 }  { m_axi_gmem1_0_RUSER DATA 0 1 }  { m_axi_gmem1_0_RRESP RESP 0 2 }  { m_axi_gmem1_0_BVALID VALID 0 1 }  { m_axi_gmem1_0_BREADY READY 1 1 }  { m_axi_gmem1_0_BRESP RESP 0 2 }  { m_axi_gmem1_0_BID ID 0 1 }  { m_axi_gmem1_0_BUSER DATA 0 1 } } }
	gmem1_1 { m_axi {  { m_axi_gmem1_1_AWVALID VALID 1 1 }  { m_axi_gmem1_1_AWREADY READY 0 1 }  { m_axi_gmem1_1_AWADDR ADDR 1 64 }  { m_axi_gmem1_1_AWID ID 1 1 }  { m_axi_gmem1_1_AWLEN SIZE 1 8 }  { m_axi_gmem1_1_AWSIZE BURST 1 3 }  { m_axi_gmem1_1_AWBURST LOCK 1 2 }  { m_axi_gmem1_1_AWLOCK CACHE 1 2 }  { m_axi_gmem1_1_AWCACHE PROT 1 4 }  { m_axi_gmem1_1_AWPROT QOS 1 3 }  { m_axi_gmem1_1_AWQOS REGION 1 4 }  { m_axi_gmem1_1_AWREGION USER 1 4 }  { m_axi_gmem1_1_AWUSER DATA 1 1 }  { m_axi_gmem1_1_WVALID VALID 1 1 }  { m_axi_gmem1_1_WREADY READY 0 1 }  { m_axi_gmem1_1_WDATA FIFONUM 1 32 }  { m_axi_gmem1_1_WSTRB STRB 1 4 }  { m_axi_gmem1_1_WLAST LAST 1 1 }  { m_axi_gmem1_1_WID ID 1 1 }  { m_axi_gmem1_1_WUSER DATA 1 1 }  { m_axi_gmem1_1_ARVALID VALID 1 1 }  { m_axi_gmem1_1_ARREADY READY 0 1 }  { m_axi_gmem1_1_ARADDR ADDR 1 64 }  { m_axi_gmem1_1_ARID ID 1 1 }  { m_axi_gmem1_1_ARLEN SIZE 1 8 }  { m_axi_gmem1_1_ARSIZE BURST 1 3 }  { m_axi_gmem1_1_ARBURST LOCK 1 2 }  { m_axi_gmem1_1_ARLOCK CACHE 1 2 }  { m_axi_gmem1_1_ARCACHE PROT 1 4 }  { m_axi_gmem1_1_ARPROT QOS 1 3 }  { m_axi_gmem1_1_ARQOS REGION 1 4 }  { m_axi_gmem1_1_ARREGION USER 1 4 }  { m_axi_gmem1_1_ARUSER DATA 1 1 }  { m_axi_gmem1_1_RVALID VALID 0 1 }  { m_axi_gmem1_1_RREADY READY 1 1 }  { m_axi_gmem1_1_RDATA FIFONUM 0 32 }  { m_axi_gmem1_1_RLAST LAST 0 1 }  { m_axi_gmem1_1_RID ID 0 1 }  { m_axi_gmem1_1_RUSER DATA 0 1 }  { m_axi_gmem1_1_RRESP RESP 0 2 }  { m_axi_gmem1_1_BVALID VALID 0 1 }  { m_axi_gmem1_1_BREADY READY 1 1 }  { m_axi_gmem1_1_BRESP RESP 0 2 }  { m_axi_gmem1_1_BID ID 0 1 }  { m_axi_gmem1_1_BUSER DATA 0 1 } } }
	gmem1_2 { m_axi {  { m_axi_gmem1_2_AWVALID VALID 1 1 }  { m_axi_gmem1_2_AWREADY READY 0 1 }  { m_axi_gmem1_2_AWADDR ADDR 1 64 }  { m_axi_gmem1_2_AWID ID 1 1 }  { m_axi_gmem1_2_AWLEN SIZE 1 8 }  { m_axi_gmem1_2_AWSIZE BURST 1 3 }  { m_axi_gmem1_2_AWBURST LOCK 1 2 }  { m_axi_gmem1_2_AWLOCK CACHE 1 2 }  { m_axi_gmem1_2_AWCACHE PROT 1 4 }  { m_axi_gmem1_2_AWPROT QOS 1 3 }  { m_axi_gmem1_2_AWQOS REGION 1 4 }  { m_axi_gmem1_2_AWREGION USER 1 4 }  { m_axi_gmem1_2_AWUSER DATA 1 1 }  { m_axi_gmem1_2_WVALID VALID 1 1 }  { m_axi_gmem1_2_WREADY READY 0 1 }  { m_axi_gmem1_2_WDATA FIFONUM 1 32 }  { m_axi_gmem1_2_WSTRB STRB 1 4 }  { m_axi_gmem1_2_WLAST LAST 1 1 }  { m_axi_gmem1_2_WID ID 1 1 }  { m_axi_gmem1_2_WUSER DATA 1 1 }  { m_axi_gmem1_2_ARVALID VALID 1 1 }  { m_axi_gmem1_2_ARREADY READY 0 1 }  { m_axi_gmem1_2_ARADDR ADDR 1 64 }  { m_axi_gmem1_2_ARID ID 1 1 }  { m_axi_gmem1_2_ARLEN SIZE 1 8 }  { m_axi_gmem1_2_ARSIZE BURST 1 3 }  { m_axi_gmem1_2_ARBURST LOCK 1 2 }  { m_axi_gmem1_2_ARLOCK CACHE 1 2 }  { m_axi_gmem1_2_ARCACHE PROT 1 4 }  { m_axi_gmem1_2_ARPROT QOS 1 3 }  { m_axi_gmem1_2_ARQOS REGION 1 4 }  { m_axi_gmem1_2_ARREGION USER 1 4 }  { m_axi_gmem1_2_ARUSER DATA 1 1 }  { m_axi_gmem1_2_RVALID VALID 0 1 }  { m_axi_gmem1_2_RREADY READY 1 1 }  { m_axi_gmem1_2_RDATA FIFONUM 0 32 }  { m_axi_gmem1_2_RLAST LAST 0 1 }  { m_axi_gmem1_2_RID ID 0 1 }  { m_axi_gmem1_2_RUSER DATA 0 1 }  { m_axi_gmem1_2_RRESP RESP 0 2 }  { m_axi_gmem1_2_BVALID VALID 0 1 }  { m_axi_gmem1_2_BREADY READY 1 1 }  { m_axi_gmem1_2_BRESP RESP 0 2 }  { m_axi_gmem1_2_BID ID 0 1 }  { m_axi_gmem1_2_BUSER DATA 0 1 } } }
	gmem1_3 { m_axi {  { m_axi_gmem1_3_AWVALID VALID 1 1 }  { m_axi_gmem1_3_AWREADY READY 0 1 }  { m_axi_gmem1_3_AWADDR ADDR 1 64 }  { m_axi_gmem1_3_AWID ID 1 1 }  { m_axi_gmem1_3_AWLEN SIZE 1 8 }  { m_axi_gmem1_3_AWSIZE BURST 1 3 }  { m_axi_gmem1_3_AWBURST LOCK 1 2 }  { m_axi_gmem1_3_AWLOCK CACHE 1 2 }  { m_axi_gmem1_3_AWCACHE PROT 1 4 }  { m_axi_gmem1_3_AWPROT QOS 1 3 }  { m_axi_gmem1_3_AWQOS REGION 1 4 }  { m_axi_gmem1_3_AWREGION USER 1 4 }  { m_axi_gmem1_3_AWUSER DATA 1 1 }  { m_axi_gmem1_3_WVALID VALID 1 1 }  { m_axi_gmem1_3_WREADY READY 0 1 }  { m_axi_gmem1_3_WDATA FIFONUM 1 32 }  { m_axi_gmem1_3_WSTRB STRB 1 4 }  { m_axi_gmem1_3_WLAST LAST 1 1 }  { m_axi_gmem1_3_WID ID 1 1 }  { m_axi_gmem1_3_WUSER DATA 1 1 }  { m_axi_gmem1_3_ARVALID VALID 1 1 }  { m_axi_gmem1_3_ARREADY READY 0 1 }  { m_axi_gmem1_3_ARADDR ADDR 1 64 }  { m_axi_gmem1_3_ARID ID 1 1 }  { m_axi_gmem1_3_ARLEN SIZE 1 8 }  { m_axi_gmem1_3_ARSIZE BURST 1 3 }  { m_axi_gmem1_3_ARBURST LOCK 1 2 }  { m_axi_gmem1_3_ARLOCK CACHE 1 2 }  { m_axi_gmem1_3_ARCACHE PROT 1 4 }  { m_axi_gmem1_3_ARPROT QOS 1 3 }  { m_axi_gmem1_3_ARQOS REGION 1 4 }  { m_axi_gmem1_3_ARREGION USER 1 4 }  { m_axi_gmem1_3_ARUSER DATA 1 1 }  { m_axi_gmem1_3_RVALID VALID 0 1 }  { m_axi_gmem1_3_RREADY READY 1 1 }  { m_axi_gmem1_3_RDATA FIFONUM 0 32 }  { m_axi_gmem1_3_RLAST LAST 0 1 }  { m_axi_gmem1_3_RID ID 0 1 }  { m_axi_gmem1_3_RUSER DATA 0 1 }  { m_axi_gmem1_3_RRESP RESP 0 2 }  { m_axi_gmem1_3_BVALID VALID 0 1 }  { m_axi_gmem1_3_BREADY READY 1 1 }  { m_axi_gmem1_3_BRESP RESP 0 2 }  { m_axi_gmem1_3_BID ID 0 1 }  { m_axi_gmem1_3_BUSER DATA 0 1 } } }
	gmem1_4 { m_axi {  { m_axi_gmem1_4_AWVALID VALID 1 1 }  { m_axi_gmem1_4_AWREADY READY 0 1 }  { m_axi_gmem1_4_AWADDR ADDR 1 64 }  { m_axi_gmem1_4_AWID ID 1 1 }  { m_axi_gmem1_4_AWLEN SIZE 1 8 }  { m_axi_gmem1_4_AWSIZE BURST 1 3 }  { m_axi_gmem1_4_AWBURST LOCK 1 2 }  { m_axi_gmem1_4_AWLOCK CACHE 1 2 }  { m_axi_gmem1_4_AWCACHE PROT 1 4 }  { m_axi_gmem1_4_AWPROT QOS 1 3 }  { m_axi_gmem1_4_AWQOS REGION 1 4 }  { m_axi_gmem1_4_AWREGION USER 1 4 }  { m_axi_gmem1_4_AWUSER DATA 1 1 }  { m_axi_gmem1_4_WVALID VALID 1 1 }  { m_axi_gmem1_4_WREADY READY 0 1 }  { m_axi_gmem1_4_WDATA FIFONUM 1 32 }  { m_axi_gmem1_4_WSTRB STRB 1 4 }  { m_axi_gmem1_4_WLAST LAST 1 1 }  { m_axi_gmem1_4_WID ID 1 1 }  { m_axi_gmem1_4_WUSER DATA 1 1 }  { m_axi_gmem1_4_ARVALID VALID 1 1 }  { m_axi_gmem1_4_ARREADY READY 0 1 }  { m_axi_gmem1_4_ARADDR ADDR 1 64 }  { m_axi_gmem1_4_ARID ID 1 1 }  { m_axi_gmem1_4_ARLEN SIZE 1 8 }  { m_axi_gmem1_4_ARSIZE BURST 1 3 }  { m_axi_gmem1_4_ARBURST LOCK 1 2 }  { m_axi_gmem1_4_ARLOCK CACHE 1 2 }  { m_axi_gmem1_4_ARCACHE PROT 1 4 }  { m_axi_gmem1_4_ARPROT QOS 1 3 }  { m_axi_gmem1_4_ARQOS REGION 1 4 }  { m_axi_gmem1_4_ARREGION USER 1 4 }  { m_axi_gmem1_4_ARUSER DATA 1 1 }  { m_axi_gmem1_4_RVALID VALID 0 1 }  { m_axi_gmem1_4_RREADY READY 1 1 }  { m_axi_gmem1_4_RDATA FIFONUM 0 32 }  { m_axi_gmem1_4_RLAST LAST 0 1 }  { m_axi_gmem1_4_RID ID 0 1 }  { m_axi_gmem1_4_RUSER DATA 0 1 }  { m_axi_gmem1_4_RRESP RESP 0 2 }  { m_axi_gmem1_4_BVALID VALID 0 1 }  { m_axi_gmem1_4_BREADY READY 1 1 }  { m_axi_gmem1_4_BRESP RESP 0 2 }  { m_axi_gmem1_4_BID ID 0 1 }  { m_axi_gmem1_4_BUSER DATA 0 1 } } }
	gmem1_5 { m_axi {  { m_axi_gmem1_5_AWVALID VALID 1 1 }  { m_axi_gmem1_5_AWREADY READY 0 1 }  { m_axi_gmem1_5_AWADDR ADDR 1 64 }  { m_axi_gmem1_5_AWID ID 1 1 }  { m_axi_gmem1_5_AWLEN SIZE 1 8 }  { m_axi_gmem1_5_AWSIZE BURST 1 3 }  { m_axi_gmem1_5_AWBURST LOCK 1 2 }  { m_axi_gmem1_5_AWLOCK CACHE 1 2 }  { m_axi_gmem1_5_AWCACHE PROT 1 4 }  { m_axi_gmem1_5_AWPROT QOS 1 3 }  { m_axi_gmem1_5_AWQOS REGION 1 4 }  { m_axi_gmem1_5_AWREGION USER 1 4 }  { m_axi_gmem1_5_AWUSER DATA 1 1 }  { m_axi_gmem1_5_WVALID VALID 1 1 }  { m_axi_gmem1_5_WREADY READY 0 1 }  { m_axi_gmem1_5_WDATA FIFONUM 1 32 }  { m_axi_gmem1_5_WSTRB STRB 1 4 }  { m_axi_gmem1_5_WLAST LAST 1 1 }  { m_axi_gmem1_5_WID ID 1 1 }  { m_axi_gmem1_5_WUSER DATA 1 1 }  { m_axi_gmem1_5_ARVALID VALID 1 1 }  { m_axi_gmem1_5_ARREADY READY 0 1 }  { m_axi_gmem1_5_ARADDR ADDR 1 64 }  { m_axi_gmem1_5_ARID ID 1 1 }  { m_axi_gmem1_5_ARLEN SIZE 1 8 }  { m_axi_gmem1_5_ARSIZE BURST 1 3 }  { m_axi_gmem1_5_ARBURST LOCK 1 2 }  { m_axi_gmem1_5_ARLOCK CACHE 1 2 }  { m_axi_gmem1_5_ARCACHE PROT 1 4 }  { m_axi_gmem1_5_ARPROT QOS 1 3 }  { m_axi_gmem1_5_ARQOS REGION 1 4 }  { m_axi_gmem1_5_ARREGION USER 1 4 }  { m_axi_gmem1_5_ARUSER DATA 1 1 }  { m_axi_gmem1_5_RVALID VALID 0 1 }  { m_axi_gmem1_5_RREADY READY 1 1 }  { m_axi_gmem1_5_RDATA FIFONUM 0 32 }  { m_axi_gmem1_5_RLAST LAST 0 1 }  { m_axi_gmem1_5_RID ID 0 1 }  { m_axi_gmem1_5_RUSER DATA 0 1 }  { m_axi_gmem1_5_RRESP RESP 0 2 }  { m_axi_gmem1_5_BVALID VALID 0 1 }  { m_axi_gmem1_5_BREADY READY 1 1 }  { m_axi_gmem1_5_BRESP RESP 0 2 }  { m_axi_gmem1_5_BID ID 0 1 }  { m_axi_gmem1_5_BUSER DATA 0 1 } } }
	gmem1_6 { m_axi {  { m_axi_gmem1_6_AWVALID VALID 1 1 }  { m_axi_gmem1_6_AWREADY READY 0 1 }  { m_axi_gmem1_6_AWADDR ADDR 1 64 }  { m_axi_gmem1_6_AWID ID 1 1 }  { m_axi_gmem1_6_AWLEN SIZE 1 8 }  { m_axi_gmem1_6_AWSIZE BURST 1 3 }  { m_axi_gmem1_6_AWBURST LOCK 1 2 }  { m_axi_gmem1_6_AWLOCK CACHE 1 2 }  { m_axi_gmem1_6_AWCACHE PROT 1 4 }  { m_axi_gmem1_6_AWPROT QOS 1 3 }  { m_axi_gmem1_6_AWQOS REGION 1 4 }  { m_axi_gmem1_6_AWREGION USER 1 4 }  { m_axi_gmem1_6_AWUSER DATA 1 1 }  { m_axi_gmem1_6_WVALID VALID 1 1 }  { m_axi_gmem1_6_WREADY READY 0 1 }  { m_axi_gmem1_6_WDATA FIFONUM 1 32 }  { m_axi_gmem1_6_WSTRB STRB 1 4 }  { m_axi_gmem1_6_WLAST LAST 1 1 }  { m_axi_gmem1_6_WID ID 1 1 }  { m_axi_gmem1_6_WUSER DATA 1 1 }  { m_axi_gmem1_6_ARVALID VALID 1 1 }  { m_axi_gmem1_6_ARREADY READY 0 1 }  { m_axi_gmem1_6_ARADDR ADDR 1 64 }  { m_axi_gmem1_6_ARID ID 1 1 }  { m_axi_gmem1_6_ARLEN SIZE 1 8 }  { m_axi_gmem1_6_ARSIZE BURST 1 3 }  { m_axi_gmem1_6_ARBURST LOCK 1 2 }  { m_axi_gmem1_6_ARLOCK CACHE 1 2 }  { m_axi_gmem1_6_ARCACHE PROT 1 4 }  { m_axi_gmem1_6_ARPROT QOS 1 3 }  { m_axi_gmem1_6_ARQOS REGION 1 4 }  { m_axi_gmem1_6_ARREGION USER 1 4 }  { m_axi_gmem1_6_ARUSER DATA 1 1 }  { m_axi_gmem1_6_RVALID VALID 0 1 }  { m_axi_gmem1_6_RREADY READY 1 1 }  { m_axi_gmem1_6_RDATA FIFONUM 0 32 }  { m_axi_gmem1_6_RLAST LAST 0 1 }  { m_axi_gmem1_6_RID ID 0 1 }  { m_axi_gmem1_6_RUSER DATA 0 1 }  { m_axi_gmem1_6_RRESP RESP 0 2 }  { m_axi_gmem1_6_BVALID VALID 0 1 }  { m_axi_gmem1_6_BREADY READY 1 1 }  { m_axi_gmem1_6_BRESP RESP 0 2 }  { m_axi_gmem1_6_BID ID 0 1 }  { m_axi_gmem1_6_BUSER DATA 0 1 } } }
	gmem1_7 { m_axi {  { m_axi_gmem1_7_AWVALID VALID 1 1 }  { m_axi_gmem1_7_AWREADY READY 0 1 }  { m_axi_gmem1_7_AWADDR ADDR 1 64 }  { m_axi_gmem1_7_AWID ID 1 1 }  { m_axi_gmem1_7_AWLEN SIZE 1 8 }  { m_axi_gmem1_7_AWSIZE BURST 1 3 }  { m_axi_gmem1_7_AWBURST LOCK 1 2 }  { m_axi_gmem1_7_AWLOCK CACHE 1 2 }  { m_axi_gmem1_7_AWCACHE PROT 1 4 }  { m_axi_gmem1_7_AWPROT QOS 1 3 }  { m_axi_gmem1_7_AWQOS REGION 1 4 }  { m_axi_gmem1_7_AWREGION USER 1 4 }  { m_axi_gmem1_7_AWUSER DATA 1 1 }  { m_axi_gmem1_7_WVALID VALID 1 1 }  { m_axi_gmem1_7_WREADY READY 0 1 }  { m_axi_gmem1_7_WDATA FIFONUM 1 32 }  { m_axi_gmem1_7_WSTRB STRB 1 4 }  { m_axi_gmem1_7_WLAST LAST 1 1 }  { m_axi_gmem1_7_WID ID 1 1 }  { m_axi_gmem1_7_WUSER DATA 1 1 }  { m_axi_gmem1_7_ARVALID VALID 1 1 }  { m_axi_gmem1_7_ARREADY READY 0 1 }  { m_axi_gmem1_7_ARADDR ADDR 1 64 }  { m_axi_gmem1_7_ARID ID 1 1 }  { m_axi_gmem1_7_ARLEN SIZE 1 8 }  { m_axi_gmem1_7_ARSIZE BURST 1 3 }  { m_axi_gmem1_7_ARBURST LOCK 1 2 }  { m_axi_gmem1_7_ARLOCK CACHE 1 2 }  { m_axi_gmem1_7_ARCACHE PROT 1 4 }  { m_axi_gmem1_7_ARPROT QOS 1 3 }  { m_axi_gmem1_7_ARQOS REGION 1 4 }  { m_axi_gmem1_7_ARREGION USER 1 4 }  { m_axi_gmem1_7_ARUSER DATA 1 1 }  { m_axi_gmem1_7_RVALID VALID 0 1 }  { m_axi_gmem1_7_RREADY READY 1 1 }  { m_axi_gmem1_7_RDATA FIFONUM 0 32 }  { m_axi_gmem1_7_RLAST LAST 0 1 }  { m_axi_gmem1_7_RID ID 0 1 }  { m_axi_gmem1_7_RUSER DATA 0 1 }  { m_axi_gmem1_7_RRESP RESP 0 2 }  { m_axi_gmem1_7_BVALID VALID 0 1 }  { m_axi_gmem1_7_BREADY READY 1 1 }  { m_axi_gmem1_7_BRESP RESP 0 2 }  { m_axi_gmem1_7_BID ID 0 1 }  { m_axi_gmem1_7_BUSER DATA 0 1 } } }
	gmem2_0 { m_axi {  { m_axi_gmem2_0_AWVALID VALID 1 1 }  { m_axi_gmem2_0_AWREADY READY 0 1 }  { m_axi_gmem2_0_AWADDR ADDR 1 64 }  { m_axi_gmem2_0_AWID ID 1 1 }  { m_axi_gmem2_0_AWLEN SIZE 1 8 }  { m_axi_gmem2_0_AWSIZE BURST 1 3 }  { m_axi_gmem2_0_AWBURST LOCK 1 2 }  { m_axi_gmem2_0_AWLOCK CACHE 1 2 }  { m_axi_gmem2_0_AWCACHE PROT 1 4 }  { m_axi_gmem2_0_AWPROT QOS 1 3 }  { m_axi_gmem2_0_AWQOS REGION 1 4 }  { m_axi_gmem2_0_AWREGION USER 1 4 }  { m_axi_gmem2_0_AWUSER DATA 1 1 }  { m_axi_gmem2_0_WVALID VALID 1 1 }  { m_axi_gmem2_0_WREADY READY 0 1 }  { m_axi_gmem2_0_WDATA FIFONUM 1 32 }  { m_axi_gmem2_0_WSTRB STRB 1 4 }  { m_axi_gmem2_0_WLAST LAST 1 1 }  { m_axi_gmem2_0_WID ID 1 1 }  { m_axi_gmem2_0_WUSER DATA 1 1 }  { m_axi_gmem2_0_ARVALID VALID 1 1 }  { m_axi_gmem2_0_ARREADY READY 0 1 }  { m_axi_gmem2_0_ARADDR ADDR 1 64 }  { m_axi_gmem2_0_ARID ID 1 1 }  { m_axi_gmem2_0_ARLEN SIZE 1 8 }  { m_axi_gmem2_0_ARSIZE BURST 1 3 }  { m_axi_gmem2_0_ARBURST LOCK 1 2 }  { m_axi_gmem2_0_ARLOCK CACHE 1 2 }  { m_axi_gmem2_0_ARCACHE PROT 1 4 }  { m_axi_gmem2_0_ARPROT QOS 1 3 }  { m_axi_gmem2_0_ARQOS REGION 1 4 }  { m_axi_gmem2_0_ARREGION USER 1 4 }  { m_axi_gmem2_0_ARUSER DATA 1 1 }  { m_axi_gmem2_0_RVALID VALID 0 1 }  { m_axi_gmem2_0_RREADY READY 1 1 }  { m_axi_gmem2_0_RDATA FIFONUM 0 32 }  { m_axi_gmem2_0_RLAST LAST 0 1 }  { m_axi_gmem2_0_RID ID 0 1 }  { m_axi_gmem2_0_RUSER DATA 0 1 }  { m_axi_gmem2_0_RRESP RESP 0 2 }  { m_axi_gmem2_0_BVALID VALID 0 1 }  { m_axi_gmem2_0_BREADY READY 1 1 }  { m_axi_gmem2_0_BRESP RESP 0 2 }  { m_axi_gmem2_0_BID ID 0 1 }  { m_axi_gmem2_0_BUSER DATA 0 1 } } }
	gmem2_1 { m_axi {  { m_axi_gmem2_1_AWVALID VALID 1 1 }  { m_axi_gmem2_1_AWREADY READY 0 1 }  { m_axi_gmem2_1_AWADDR ADDR 1 64 }  { m_axi_gmem2_1_AWID ID 1 1 }  { m_axi_gmem2_1_AWLEN SIZE 1 8 }  { m_axi_gmem2_1_AWSIZE BURST 1 3 }  { m_axi_gmem2_1_AWBURST LOCK 1 2 }  { m_axi_gmem2_1_AWLOCK CACHE 1 2 }  { m_axi_gmem2_1_AWCACHE PROT 1 4 }  { m_axi_gmem2_1_AWPROT QOS 1 3 }  { m_axi_gmem2_1_AWQOS REGION 1 4 }  { m_axi_gmem2_1_AWREGION USER 1 4 }  { m_axi_gmem2_1_AWUSER DATA 1 1 }  { m_axi_gmem2_1_WVALID VALID 1 1 }  { m_axi_gmem2_1_WREADY READY 0 1 }  { m_axi_gmem2_1_WDATA FIFONUM 1 32 }  { m_axi_gmem2_1_WSTRB STRB 1 4 }  { m_axi_gmem2_1_WLAST LAST 1 1 }  { m_axi_gmem2_1_WID ID 1 1 }  { m_axi_gmem2_1_WUSER DATA 1 1 }  { m_axi_gmem2_1_ARVALID VALID 1 1 }  { m_axi_gmem2_1_ARREADY READY 0 1 }  { m_axi_gmem2_1_ARADDR ADDR 1 64 }  { m_axi_gmem2_1_ARID ID 1 1 }  { m_axi_gmem2_1_ARLEN SIZE 1 8 }  { m_axi_gmem2_1_ARSIZE BURST 1 3 }  { m_axi_gmem2_1_ARBURST LOCK 1 2 }  { m_axi_gmem2_1_ARLOCK CACHE 1 2 }  { m_axi_gmem2_1_ARCACHE PROT 1 4 }  { m_axi_gmem2_1_ARPROT QOS 1 3 }  { m_axi_gmem2_1_ARQOS REGION 1 4 }  { m_axi_gmem2_1_ARREGION USER 1 4 }  { m_axi_gmem2_1_ARUSER DATA 1 1 }  { m_axi_gmem2_1_RVALID VALID 0 1 }  { m_axi_gmem2_1_RREADY READY 1 1 }  { m_axi_gmem2_1_RDATA FIFONUM 0 32 }  { m_axi_gmem2_1_RLAST LAST 0 1 }  { m_axi_gmem2_1_RID ID 0 1 }  { m_axi_gmem2_1_RUSER DATA 0 1 }  { m_axi_gmem2_1_RRESP RESP 0 2 }  { m_axi_gmem2_1_BVALID VALID 0 1 }  { m_axi_gmem2_1_BREADY READY 1 1 }  { m_axi_gmem2_1_BRESP RESP 0 2 }  { m_axi_gmem2_1_BID ID 0 1 }  { m_axi_gmem2_1_BUSER DATA 0 1 } } }
	gmem2_2 { m_axi {  { m_axi_gmem2_2_AWVALID VALID 1 1 }  { m_axi_gmem2_2_AWREADY READY 0 1 }  { m_axi_gmem2_2_AWADDR ADDR 1 64 }  { m_axi_gmem2_2_AWID ID 1 1 }  { m_axi_gmem2_2_AWLEN SIZE 1 8 }  { m_axi_gmem2_2_AWSIZE BURST 1 3 }  { m_axi_gmem2_2_AWBURST LOCK 1 2 }  { m_axi_gmem2_2_AWLOCK CACHE 1 2 }  { m_axi_gmem2_2_AWCACHE PROT 1 4 }  { m_axi_gmem2_2_AWPROT QOS 1 3 }  { m_axi_gmem2_2_AWQOS REGION 1 4 }  { m_axi_gmem2_2_AWREGION USER 1 4 }  { m_axi_gmem2_2_AWUSER DATA 1 1 }  { m_axi_gmem2_2_WVALID VALID 1 1 }  { m_axi_gmem2_2_WREADY READY 0 1 }  { m_axi_gmem2_2_WDATA FIFONUM 1 32 }  { m_axi_gmem2_2_WSTRB STRB 1 4 }  { m_axi_gmem2_2_WLAST LAST 1 1 }  { m_axi_gmem2_2_WID ID 1 1 }  { m_axi_gmem2_2_WUSER DATA 1 1 }  { m_axi_gmem2_2_ARVALID VALID 1 1 }  { m_axi_gmem2_2_ARREADY READY 0 1 }  { m_axi_gmem2_2_ARADDR ADDR 1 64 }  { m_axi_gmem2_2_ARID ID 1 1 }  { m_axi_gmem2_2_ARLEN SIZE 1 8 }  { m_axi_gmem2_2_ARSIZE BURST 1 3 }  { m_axi_gmem2_2_ARBURST LOCK 1 2 }  { m_axi_gmem2_2_ARLOCK CACHE 1 2 }  { m_axi_gmem2_2_ARCACHE PROT 1 4 }  { m_axi_gmem2_2_ARPROT QOS 1 3 }  { m_axi_gmem2_2_ARQOS REGION 1 4 }  { m_axi_gmem2_2_ARREGION USER 1 4 }  { m_axi_gmem2_2_ARUSER DATA 1 1 }  { m_axi_gmem2_2_RVALID VALID 0 1 }  { m_axi_gmem2_2_RREADY READY 1 1 }  { m_axi_gmem2_2_RDATA FIFONUM 0 32 }  { m_axi_gmem2_2_RLAST LAST 0 1 }  { m_axi_gmem2_2_RID ID 0 1 }  { m_axi_gmem2_2_RUSER DATA 0 1 }  { m_axi_gmem2_2_RRESP RESP 0 2 }  { m_axi_gmem2_2_BVALID VALID 0 1 }  { m_axi_gmem2_2_BREADY READY 1 1 }  { m_axi_gmem2_2_BRESP RESP 0 2 }  { m_axi_gmem2_2_BID ID 0 1 }  { m_axi_gmem2_2_BUSER DATA 0 1 } } }
	gmem2_3 { m_axi {  { m_axi_gmem2_3_AWVALID VALID 1 1 }  { m_axi_gmem2_3_AWREADY READY 0 1 }  { m_axi_gmem2_3_AWADDR ADDR 1 64 }  { m_axi_gmem2_3_AWID ID 1 1 }  { m_axi_gmem2_3_AWLEN SIZE 1 8 }  { m_axi_gmem2_3_AWSIZE BURST 1 3 }  { m_axi_gmem2_3_AWBURST LOCK 1 2 }  { m_axi_gmem2_3_AWLOCK CACHE 1 2 }  { m_axi_gmem2_3_AWCACHE PROT 1 4 }  { m_axi_gmem2_3_AWPROT QOS 1 3 }  { m_axi_gmem2_3_AWQOS REGION 1 4 }  { m_axi_gmem2_3_AWREGION USER 1 4 }  { m_axi_gmem2_3_AWUSER DATA 1 1 }  { m_axi_gmem2_3_WVALID VALID 1 1 }  { m_axi_gmem2_3_WREADY READY 0 1 }  { m_axi_gmem2_3_WDATA FIFONUM 1 32 }  { m_axi_gmem2_3_WSTRB STRB 1 4 }  { m_axi_gmem2_3_WLAST LAST 1 1 }  { m_axi_gmem2_3_WID ID 1 1 }  { m_axi_gmem2_3_WUSER DATA 1 1 }  { m_axi_gmem2_3_ARVALID VALID 1 1 }  { m_axi_gmem2_3_ARREADY READY 0 1 }  { m_axi_gmem2_3_ARADDR ADDR 1 64 }  { m_axi_gmem2_3_ARID ID 1 1 }  { m_axi_gmem2_3_ARLEN SIZE 1 8 }  { m_axi_gmem2_3_ARSIZE BURST 1 3 }  { m_axi_gmem2_3_ARBURST LOCK 1 2 }  { m_axi_gmem2_3_ARLOCK CACHE 1 2 }  { m_axi_gmem2_3_ARCACHE PROT 1 4 }  { m_axi_gmem2_3_ARPROT QOS 1 3 }  { m_axi_gmem2_3_ARQOS REGION 1 4 }  { m_axi_gmem2_3_ARREGION USER 1 4 }  { m_axi_gmem2_3_ARUSER DATA 1 1 }  { m_axi_gmem2_3_RVALID VALID 0 1 }  { m_axi_gmem2_3_RREADY READY 1 1 }  { m_axi_gmem2_3_RDATA FIFONUM 0 32 }  { m_axi_gmem2_3_RLAST LAST 0 1 }  { m_axi_gmem2_3_RID ID 0 1 }  { m_axi_gmem2_3_RUSER DATA 0 1 }  { m_axi_gmem2_3_RRESP RESP 0 2 }  { m_axi_gmem2_3_BVALID VALID 0 1 }  { m_axi_gmem2_3_BREADY READY 1 1 }  { m_axi_gmem2_3_BRESP RESP 0 2 }  { m_axi_gmem2_3_BID ID 0 1 }  { m_axi_gmem2_3_BUSER DATA 0 1 } } }
	gmem2_4 { m_axi {  { m_axi_gmem2_4_AWVALID VALID 1 1 }  { m_axi_gmem2_4_AWREADY READY 0 1 }  { m_axi_gmem2_4_AWADDR ADDR 1 64 }  { m_axi_gmem2_4_AWID ID 1 1 }  { m_axi_gmem2_4_AWLEN SIZE 1 8 }  { m_axi_gmem2_4_AWSIZE BURST 1 3 }  { m_axi_gmem2_4_AWBURST LOCK 1 2 }  { m_axi_gmem2_4_AWLOCK CACHE 1 2 }  { m_axi_gmem2_4_AWCACHE PROT 1 4 }  { m_axi_gmem2_4_AWPROT QOS 1 3 }  { m_axi_gmem2_4_AWQOS REGION 1 4 }  { m_axi_gmem2_4_AWREGION USER 1 4 }  { m_axi_gmem2_4_AWUSER DATA 1 1 }  { m_axi_gmem2_4_WVALID VALID 1 1 }  { m_axi_gmem2_4_WREADY READY 0 1 }  { m_axi_gmem2_4_WDATA FIFONUM 1 32 }  { m_axi_gmem2_4_WSTRB STRB 1 4 }  { m_axi_gmem2_4_WLAST LAST 1 1 }  { m_axi_gmem2_4_WID ID 1 1 }  { m_axi_gmem2_4_WUSER DATA 1 1 }  { m_axi_gmem2_4_ARVALID VALID 1 1 }  { m_axi_gmem2_4_ARREADY READY 0 1 }  { m_axi_gmem2_4_ARADDR ADDR 1 64 }  { m_axi_gmem2_4_ARID ID 1 1 }  { m_axi_gmem2_4_ARLEN SIZE 1 8 }  { m_axi_gmem2_4_ARSIZE BURST 1 3 }  { m_axi_gmem2_4_ARBURST LOCK 1 2 }  { m_axi_gmem2_4_ARLOCK CACHE 1 2 }  { m_axi_gmem2_4_ARCACHE PROT 1 4 }  { m_axi_gmem2_4_ARPROT QOS 1 3 }  { m_axi_gmem2_4_ARQOS REGION 1 4 }  { m_axi_gmem2_4_ARREGION USER 1 4 }  { m_axi_gmem2_4_ARUSER DATA 1 1 }  { m_axi_gmem2_4_RVALID VALID 0 1 }  { m_axi_gmem2_4_RREADY READY 1 1 }  { m_axi_gmem2_4_RDATA FIFONUM 0 32 }  { m_axi_gmem2_4_RLAST LAST 0 1 }  { m_axi_gmem2_4_RID ID 0 1 }  { m_axi_gmem2_4_RUSER DATA 0 1 }  { m_axi_gmem2_4_RRESP RESP 0 2 }  { m_axi_gmem2_4_BVALID VALID 0 1 }  { m_axi_gmem2_4_BREADY READY 1 1 }  { m_axi_gmem2_4_BRESP RESP 0 2 }  { m_axi_gmem2_4_BID ID 0 1 }  { m_axi_gmem2_4_BUSER DATA 0 1 } } }
	gmem2_5 { m_axi {  { m_axi_gmem2_5_AWVALID VALID 1 1 }  { m_axi_gmem2_5_AWREADY READY 0 1 }  { m_axi_gmem2_5_AWADDR ADDR 1 64 }  { m_axi_gmem2_5_AWID ID 1 1 }  { m_axi_gmem2_5_AWLEN SIZE 1 8 }  { m_axi_gmem2_5_AWSIZE BURST 1 3 }  { m_axi_gmem2_5_AWBURST LOCK 1 2 }  { m_axi_gmem2_5_AWLOCK CACHE 1 2 }  { m_axi_gmem2_5_AWCACHE PROT 1 4 }  { m_axi_gmem2_5_AWPROT QOS 1 3 }  { m_axi_gmem2_5_AWQOS REGION 1 4 }  { m_axi_gmem2_5_AWREGION USER 1 4 }  { m_axi_gmem2_5_AWUSER DATA 1 1 }  { m_axi_gmem2_5_WVALID VALID 1 1 }  { m_axi_gmem2_5_WREADY READY 0 1 }  { m_axi_gmem2_5_WDATA FIFONUM 1 32 }  { m_axi_gmem2_5_WSTRB STRB 1 4 }  { m_axi_gmem2_5_WLAST LAST 1 1 }  { m_axi_gmem2_5_WID ID 1 1 }  { m_axi_gmem2_5_WUSER DATA 1 1 }  { m_axi_gmem2_5_ARVALID VALID 1 1 }  { m_axi_gmem2_5_ARREADY READY 0 1 }  { m_axi_gmem2_5_ARADDR ADDR 1 64 }  { m_axi_gmem2_5_ARID ID 1 1 }  { m_axi_gmem2_5_ARLEN SIZE 1 8 }  { m_axi_gmem2_5_ARSIZE BURST 1 3 }  { m_axi_gmem2_5_ARBURST LOCK 1 2 }  { m_axi_gmem2_5_ARLOCK CACHE 1 2 }  { m_axi_gmem2_5_ARCACHE PROT 1 4 }  { m_axi_gmem2_5_ARPROT QOS 1 3 }  { m_axi_gmem2_5_ARQOS REGION 1 4 }  { m_axi_gmem2_5_ARREGION USER 1 4 }  { m_axi_gmem2_5_ARUSER DATA 1 1 }  { m_axi_gmem2_5_RVALID VALID 0 1 }  { m_axi_gmem2_5_RREADY READY 1 1 }  { m_axi_gmem2_5_RDATA FIFONUM 0 32 }  { m_axi_gmem2_5_RLAST LAST 0 1 }  { m_axi_gmem2_5_RID ID 0 1 }  { m_axi_gmem2_5_RUSER DATA 0 1 }  { m_axi_gmem2_5_RRESP RESP 0 2 }  { m_axi_gmem2_5_BVALID VALID 0 1 }  { m_axi_gmem2_5_BREADY READY 1 1 }  { m_axi_gmem2_5_BRESP RESP 0 2 }  { m_axi_gmem2_5_BID ID 0 1 }  { m_axi_gmem2_5_BUSER DATA 0 1 } } }
	gmem2_6 { m_axi {  { m_axi_gmem2_6_AWVALID VALID 1 1 }  { m_axi_gmem2_6_AWREADY READY 0 1 }  { m_axi_gmem2_6_AWADDR ADDR 1 64 }  { m_axi_gmem2_6_AWID ID 1 1 }  { m_axi_gmem2_6_AWLEN SIZE 1 8 }  { m_axi_gmem2_6_AWSIZE BURST 1 3 }  { m_axi_gmem2_6_AWBURST LOCK 1 2 }  { m_axi_gmem2_6_AWLOCK CACHE 1 2 }  { m_axi_gmem2_6_AWCACHE PROT 1 4 }  { m_axi_gmem2_6_AWPROT QOS 1 3 }  { m_axi_gmem2_6_AWQOS REGION 1 4 }  { m_axi_gmem2_6_AWREGION USER 1 4 }  { m_axi_gmem2_6_AWUSER DATA 1 1 }  { m_axi_gmem2_6_WVALID VALID 1 1 }  { m_axi_gmem2_6_WREADY READY 0 1 }  { m_axi_gmem2_6_WDATA FIFONUM 1 32 }  { m_axi_gmem2_6_WSTRB STRB 1 4 }  { m_axi_gmem2_6_WLAST LAST 1 1 }  { m_axi_gmem2_6_WID ID 1 1 }  { m_axi_gmem2_6_WUSER DATA 1 1 }  { m_axi_gmem2_6_ARVALID VALID 1 1 }  { m_axi_gmem2_6_ARREADY READY 0 1 }  { m_axi_gmem2_6_ARADDR ADDR 1 64 }  { m_axi_gmem2_6_ARID ID 1 1 }  { m_axi_gmem2_6_ARLEN SIZE 1 8 }  { m_axi_gmem2_6_ARSIZE BURST 1 3 }  { m_axi_gmem2_6_ARBURST LOCK 1 2 }  { m_axi_gmem2_6_ARLOCK CACHE 1 2 }  { m_axi_gmem2_6_ARCACHE PROT 1 4 }  { m_axi_gmem2_6_ARPROT QOS 1 3 }  { m_axi_gmem2_6_ARQOS REGION 1 4 }  { m_axi_gmem2_6_ARREGION USER 1 4 }  { m_axi_gmem2_6_ARUSER DATA 1 1 }  { m_axi_gmem2_6_RVALID VALID 0 1 }  { m_axi_gmem2_6_RREADY READY 1 1 }  { m_axi_gmem2_6_RDATA FIFONUM 0 32 }  { m_axi_gmem2_6_RLAST LAST 0 1 }  { m_axi_gmem2_6_RID ID 0 1 }  { m_axi_gmem2_6_RUSER DATA 0 1 }  { m_axi_gmem2_6_RRESP RESP 0 2 }  { m_axi_gmem2_6_BVALID VALID 0 1 }  { m_axi_gmem2_6_BREADY READY 1 1 }  { m_axi_gmem2_6_BRESP RESP 0 2 }  { m_axi_gmem2_6_BID ID 0 1 }  { m_axi_gmem2_6_BUSER DATA 0 1 } } }
	gmem2_7 { m_axi {  { m_axi_gmem2_7_AWVALID VALID 1 1 }  { m_axi_gmem2_7_AWREADY READY 0 1 }  { m_axi_gmem2_7_AWADDR ADDR 1 64 }  { m_axi_gmem2_7_AWID ID 1 1 }  { m_axi_gmem2_7_AWLEN SIZE 1 8 }  { m_axi_gmem2_7_AWSIZE BURST 1 3 }  { m_axi_gmem2_7_AWBURST LOCK 1 2 }  { m_axi_gmem2_7_AWLOCK CACHE 1 2 }  { m_axi_gmem2_7_AWCACHE PROT 1 4 }  { m_axi_gmem2_7_AWPROT QOS 1 3 }  { m_axi_gmem2_7_AWQOS REGION 1 4 }  { m_axi_gmem2_7_AWREGION USER 1 4 }  { m_axi_gmem2_7_AWUSER DATA 1 1 }  { m_axi_gmem2_7_WVALID VALID 1 1 }  { m_axi_gmem2_7_WREADY READY 0 1 }  { m_axi_gmem2_7_WDATA FIFONUM 1 32 }  { m_axi_gmem2_7_WSTRB STRB 1 4 }  { m_axi_gmem2_7_WLAST LAST 1 1 }  { m_axi_gmem2_7_WID ID 1 1 }  { m_axi_gmem2_7_WUSER DATA 1 1 }  { m_axi_gmem2_7_ARVALID VALID 1 1 }  { m_axi_gmem2_7_ARREADY READY 0 1 }  { m_axi_gmem2_7_ARADDR ADDR 1 64 }  { m_axi_gmem2_7_ARID ID 1 1 }  { m_axi_gmem2_7_ARLEN SIZE 1 8 }  { m_axi_gmem2_7_ARSIZE BURST 1 3 }  { m_axi_gmem2_7_ARBURST LOCK 1 2 }  { m_axi_gmem2_7_ARLOCK CACHE 1 2 }  { m_axi_gmem2_7_ARCACHE PROT 1 4 }  { m_axi_gmem2_7_ARPROT QOS 1 3 }  { m_axi_gmem2_7_ARQOS REGION 1 4 }  { m_axi_gmem2_7_ARREGION USER 1 4 }  { m_axi_gmem2_7_ARUSER DATA 1 1 }  { m_axi_gmem2_7_RVALID VALID 0 1 }  { m_axi_gmem2_7_RREADY READY 1 1 }  { m_axi_gmem2_7_RDATA FIFONUM 0 32 }  { m_axi_gmem2_7_RLAST LAST 0 1 }  { m_axi_gmem2_7_RID ID 0 1 }  { m_axi_gmem2_7_RUSER DATA 0 1 }  { m_axi_gmem2_7_RRESP RESP 0 2 }  { m_axi_gmem2_7_BVALID VALID 0 1 }  { m_axi_gmem2_7_BREADY READY 1 1 }  { m_axi_gmem2_7_BRESP RESP 0 2 }  { m_axi_gmem2_7_BID ID 0 1 }  { m_axi_gmem2_7_BUSER DATA 0 1 } } }
}

set maxi_interface_dict [dict create]
dict set maxi_interface_dict gmem0_0 { CHANNEL_NUM 0 BUNDLE gmem0_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_1 { CHANNEL_NUM 0 BUNDLE gmem0_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_2 { CHANNEL_NUM 0 BUNDLE gmem0_2 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_3 { CHANNEL_NUM 0 BUNDLE gmem0_3 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_4 { CHANNEL_NUM 0 BUNDLE gmem0_4 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_5 { CHANNEL_NUM 0 BUNDLE gmem0_5 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_6 { CHANNEL_NUM 0 BUNDLE gmem0_6 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem0_7 { CHANNEL_NUM 0 BUNDLE gmem0_7 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_0 { CHANNEL_NUM 0 BUNDLE gmem1_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_1 { CHANNEL_NUM 0 BUNDLE gmem1_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_2 { CHANNEL_NUM 0 BUNDLE gmem1_2 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_3 { CHANNEL_NUM 0 BUNDLE gmem1_3 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_4 { CHANNEL_NUM 0 BUNDLE gmem1_4 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_5 { CHANNEL_NUM 0 BUNDLE gmem1_5 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_6 { CHANNEL_NUM 0 BUNDLE gmem1_6 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem1_7 { CHANNEL_NUM 0 BUNDLE gmem1_7 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_ONLY}
dict set maxi_interface_dict gmem2_0 { CHANNEL_NUM 0 BUNDLE gmem2_0 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_1 { CHANNEL_NUM 0 BUNDLE gmem2_1 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_2 { CHANNEL_NUM 0 BUNDLE gmem2_2 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_3 { CHANNEL_NUM 0 BUNDLE gmem2_3 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_4 { CHANNEL_NUM 0 BUNDLE gmem2_4 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_5 { CHANNEL_NUM 0 BUNDLE gmem2_5 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_6 { CHANNEL_NUM 0 BUNDLE gmem2_6 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}
dict set maxi_interface_dict gmem2_7 { CHANNEL_NUM 0 BUNDLE gmem2_7 NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE WRITE_ONLY}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ gmem0_0 64 }
	{ gmem0_1 64 }
	{ gmem0_2 64 }
	{ gmem0_3 64 }
	{ gmem0_4 64 }
	{ gmem0_5 64 }
	{ gmem0_6 64 }
	{ gmem0_7 64 }
	{ gmem1_0 64 }
	{ gmem1_1 64 }
	{ gmem1_2 64 }
	{ gmem1_3 64 }
	{ gmem1_4 64 }
	{ gmem1_5 64 }
	{ gmem1_6 64 }
	{ gmem1_7 64 }
	{ gmem2_0 64 }
	{ gmem2_1 64 }
	{ gmem2_2 64 }
	{ gmem2_3 64 }
	{ gmem2_4 64 }
	{ gmem2_5 64 }
	{ gmem2_6 64 }
	{ gmem2_7 64 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ gmem0_0 64 }
	{ gmem0_1 64 }
	{ gmem0_2 64 }
	{ gmem0_3 64 }
	{ gmem0_4 64 }
	{ gmem0_5 64 }
	{ gmem0_6 64 }
	{ gmem0_7 64 }
	{ gmem1_0 64 }
	{ gmem1_1 64 }
	{ gmem1_2 64 }
	{ gmem1_3 64 }
	{ gmem1_4 64 }
	{ gmem1_5 64 }
	{ gmem1_6 64 }
	{ gmem1_7 64 }
	{ gmem2_0 64 }
	{ gmem2_1 64 }
	{ gmem2_2 64 }
	{ gmem2_3 64 }
	{ gmem2_4 64 }
	{ gmem2_5 64 }
	{ gmem2_6 64 }
	{ gmem2_7 64 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
