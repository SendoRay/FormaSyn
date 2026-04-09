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
// 0x20 : Data signal of y
//        bit 15~0 - y[15:0] (Read)
//        others   - reserved
// 0x24 : Control signal of y
//        bit 0  - y_ap_vld (Read/COR)
//        others - reserved
// 0x30 : Data signal of idx
//        bit 2~0 - idx[2:0] (Read)
//        others  - reserved
// 0x34 : Control signal of idx
//        bit 0  - idx_ap_vld (Read/COR)
//        others - reserved
// 0x10 ~
// 0x1f : Memory 'a' (8 * 16b)
//        Word n : bit [15: 0] - a[2n]
//                 bit [31:16] - a[2n+1]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XVEC_MAX_CONTROL_ADDR_AP_CTRL  0x00
#define XVEC_MAX_CONTROL_ADDR_GIE      0x04
#define XVEC_MAX_CONTROL_ADDR_IER      0x08
#define XVEC_MAX_CONTROL_ADDR_ISR      0x0c
#define XVEC_MAX_CONTROL_ADDR_Y_DATA   0x20
#define XVEC_MAX_CONTROL_BITS_Y_DATA   16
#define XVEC_MAX_CONTROL_ADDR_Y_CTRL   0x24
#define XVEC_MAX_CONTROL_ADDR_IDX_DATA 0x30
#define XVEC_MAX_CONTROL_BITS_IDX_DATA 3
#define XVEC_MAX_CONTROL_ADDR_IDX_CTRL 0x34
#define XVEC_MAX_CONTROL_ADDR_A_BASE   0x10
#define XVEC_MAX_CONTROL_ADDR_A_HIGH   0x1f
#define XVEC_MAX_CONTROL_WIDTH_A       16
#define XVEC_MAX_CONTROL_DEPTH_A       8

