# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_control {
a { 
	dir I
	width 16
	depth 8
	mode ap_memory
	offset 16
	offset_end 31
	core_op ram_1p
	core_impl auto
	core_latency 1
	byte_write 0
}
b { 
	dir I
	width 16
	depth 8
	mode ap_memory
	offset 32
	offset_end 47
	core_op ram_1p
	core_impl auto
	core_latency 1
	byte_write 0
}
y { 
	dir O
	width 40
	depth 1
	mode ap_vld
	offset 48
	offset_end 59
}
ap_start { }
ap_done { }
ap_ready { }
ap_continue { }
ap_idle { }
interrupt {
}
}
dict set axilite_register_dict control $port_control


