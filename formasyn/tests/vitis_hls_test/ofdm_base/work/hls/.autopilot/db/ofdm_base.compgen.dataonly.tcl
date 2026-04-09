# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_control {
in_r { 
	dir I
	width 32
	depth 16
	mode ap_memory
	offset 64
	offset_end 127
	core_op ram_1p
	core_impl auto
	core_latency 1
	byte_write 0
}
out_r { 
	dir O
	width 32
	depth 20
	mode ap_memory
	offset 128
	offset_end 255
	core_op ram_1p
	core_impl auto
	core_latency 1
	byte_write 0
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


