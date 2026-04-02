# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_control {
a_0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 16
	offset_end 27
}
a_1 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 28
	offset_end 39
}
b_0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 40
	offset_end 51
}
b_1 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 52
	offset_end 63
}
c_0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 64
	offset_end 75
}
c_1 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 76
	offset_end 87
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


