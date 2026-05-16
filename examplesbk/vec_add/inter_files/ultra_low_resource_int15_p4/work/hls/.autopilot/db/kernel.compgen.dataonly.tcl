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
a_2 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 40
	offset_end 51
}
a_3 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 52
	offset_end 63
}
b_0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 64
	offset_end 75
}
b_1 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 76
	offset_end 87
}
b_2 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 88
	offset_end 99
}
b_3 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 100
	offset_end 111
}
c_0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 112
	offset_end 123
}
c_1 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 124
	offset_end 135
}
c_2 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 136
	offset_end 147
}
c_3 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 148
	offset_end 159
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


