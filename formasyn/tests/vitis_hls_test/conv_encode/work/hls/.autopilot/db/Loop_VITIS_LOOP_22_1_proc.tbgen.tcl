set moduleName Loop_VITIS_LOOP_22_1_proc
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set isPipelined_legacy 1
set pipeline_type loop_auto_rewind
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 4
set C_modelName {Loop_VITIS_LOOP_22_1_proc}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ num_bits int 32 regular {ap_stable 0} }
	{ bit_in_stream int 1 regular {fifo 0 volatile }  }
	{ y_out_stream int 2 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "num_bits", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "bit_in_stream", "interface" : "fifo", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "y_out_stream", "interface" : "fifo", "bitwidth" : 2, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 14
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ bit_in_stream_dout sc_in sc_lv 1 signal 1 } 
	{ bit_in_stream_empty_n sc_in sc_logic 1 signal 1 } 
	{ bit_in_stream_read sc_out sc_logic 1 signal 1 } 
	{ y_out_stream_din sc_out sc_lv 2 signal 2 } 
	{ y_out_stream_full_n sc_in sc_logic 1 signal 2 } 
	{ y_out_stream_write sc_out sc_logic 1 signal 2 } 
	{ num_bits sc_in sc_lv 32 signal 0 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "bit_in_stream_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "bit_in_stream", "role": "dout" }} , 
 	{ "name": "bit_in_stream_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "bit_in_stream", "role": "empty_n" }} , 
 	{ "name": "bit_in_stream_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "bit_in_stream", "role": "read" }} , 
 	{ "name": "y_out_stream_din", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "y_out_stream", "role": "din" }} , 
 	{ "name": "y_out_stream_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "y_out_stream", "role": "full_n" }} , 
 	{ "name": "y_out_stream_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "y_out_stream", "role": "write" }} , 
 	{ "name": "num_bits", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "num_bits", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	Loop_VITIS_LOOP_22_1_proc {
		num_bits {Type I LastRead 0 FirstWrite -1}
		bit_in_stream {Type I LastRead 1 FirstWrite -1}
		y_out_stream {Type O LastRead -1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "-1", "Max" : "-1"}
	, {"Name" : "Interval", "Min" : "-1", "Max" : "-1"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	num_bits { ap_none {  { num_bits in_data 0 32 } } }
	bit_in_stream { ap_fifo {  { bit_in_stream_dout fifo_data_in 0 1 }  { bit_in_stream_empty_n fifo_status 0 1 }  { bit_in_stream_read fifo_port_we 1 1 } } }
	y_out_stream { ap_fifo {  { y_out_stream_din fifo_data_in 1 2 }  { y_out_stream_full_n fifo_status 0 1 }  { y_out_stream_write fifo_port_we 1 1 } } }
}
