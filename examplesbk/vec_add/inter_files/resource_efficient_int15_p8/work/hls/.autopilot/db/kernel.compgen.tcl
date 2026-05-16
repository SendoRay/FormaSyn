# This script segment is generated automatically by AutoPilot

if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem0_0_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem0_1_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem0_2_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem0_3_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem0_4_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem0_5_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem0_6_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem0_7_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem1_0_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem1_1_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem1_2_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem1_3_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem1_4_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem1_5_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem1_6_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem1_7_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem2_0_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem2_1_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem2_2_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem2_3_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem2_4_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem2_5_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem2_6_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_gmem2_7_m_axi BINDTYPE {interface} TYPE {adapter} IMPL {m_axi}
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

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
a_4 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 64
	offset_end 75
}
a_5 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 76
	offset_end 87
}
a_6 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 88
	offset_end 99
}
a_7 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 100
	offset_end 111
}
b_0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 112
	offset_end 123
}
b_1 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 124
	offset_end 135
}
b_2 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 136
	offset_end 147
}
b_3 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 148
	offset_end 159
}
b_4 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 160
	offset_end 171
}
b_5 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 172
	offset_end 183
}
b_6 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 184
	offset_end 195
}
b_7 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 196
	offset_end 207
}
c_0 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 208
	offset_end 219
}
c_1 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 220
	offset_end 231
}
c_2 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 232
	offset_end 243
}
c_3 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 244
	offset_end 255
}
c_4 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 256
	offset_end 267
}
c_5 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 268
	offset_end 279
}
c_6 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 280
	offset_end 291
}
c_7 { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 292
	offset_end 303
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


# Native S_AXILite:
if {${::AESL::PGuard_simmodel_gen}} {
	if {[info proc ::AESL_LIB_XILADAPTER::s_axilite_gen] == "::AESL_LIB_XILADAPTER::s_axilite_gen"} {
		eval "::AESL_LIB_XILADAPTER::s_axilite_gen { \
			id 1 \
			corename kernel_control_axilite \
			name kernel_control_s_axi \
			ports {$port_control} \
			op interface \
			interrupt_clear_mode TOW \
			interrupt_trigger_type default \
			is_flushable 0 \
			is_datawidth64 0 \
			is_addrwidth64 1 \
			enable_mem_auto_widen 1 \
		} "
	} else {
		puts "@W \[IMPL-110\] Cannot find AXI Lite interface model in the library. Ignored generation of AXI Lite  interface for 'control'"
	}
}

if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler kernel_control_s_axi BINDTYPE interface TYPE interface_s_axilite
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -1 \
    name ${PortName} \
    reset_level 0 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst_n
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -2 \
    name ${PortName} \
    reset_level 0 \
    sync_rst true \
    corename apif_ap_rst_n \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


