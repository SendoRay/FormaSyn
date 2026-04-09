// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 4  - ap_continue (Read/Write/SC)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0 - ap_done (Read/TOW)
//        bit 1 - ap_ready (Read/TOW)
//        others - reserved
// 0x10 : Data signal of x_in
//        bit 31~0 - x_in[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of bits
//        bit 4~0 - bits[4:0] (Read/Write)
//        others  - reserved
// 0x1c : reserved
// 0x20 : Data signal of frac
//        bit 4~0 - frac[4:0] (Read/Write)
//        others  - reserved
// 0x24 : reserved
// 0x28 : Data signal of y_out
//        bit 31~0 - y_out[31:0] (Read)
// 0x2c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XKERNEL_CONTROL_ADDR_AP_CTRL    0x00
#define XKERNEL_CONTROL_ADDR_GIE        0x04
#define XKERNEL_CONTROL_ADDR_IER        0x08
#define XKERNEL_CONTROL_ADDR_ISR        0x0c
#define XKERNEL_CONTROL_ADDR_X_IN_DATA  0x10
#define XKERNEL_CONTROL_BITS_X_IN_DATA  32
#define XKERNEL_CONTROL_ADDR_BITS_DATA  0x18
#define XKERNEL_CONTROL_BITS_BITS_DATA  5
#define XKERNEL_CONTROL_ADDR_FRAC_DATA  0x20
#define XKERNEL_CONTROL_BITS_FRAC_DATA  5
#define XKERNEL_CONTROL_ADDR_Y_OUT_DATA 0x28
#define XKERNEL_CONTROL_BITS_Y_OUT_DATA 32

