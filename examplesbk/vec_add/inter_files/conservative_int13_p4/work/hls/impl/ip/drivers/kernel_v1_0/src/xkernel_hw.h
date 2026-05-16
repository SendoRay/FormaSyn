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
// 0x10 : Data signal of a_0
//        bit 31~0 - a_0[31:0] (Read/Write)
// 0x14 : Data signal of a_0
//        bit 31~0 - a_0[63:32] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of a_1
//        bit 31~0 - a_1[31:0] (Read/Write)
// 0x20 : Data signal of a_1
//        bit 31~0 - a_1[63:32] (Read/Write)
// 0x24 : reserved
// 0x28 : Data signal of a_2
//        bit 31~0 - a_2[31:0] (Read/Write)
// 0x2c : Data signal of a_2
//        bit 31~0 - a_2[63:32] (Read/Write)
// 0x30 : reserved
// 0x34 : Data signal of a_3
//        bit 31~0 - a_3[31:0] (Read/Write)
// 0x38 : Data signal of a_3
//        bit 31~0 - a_3[63:32] (Read/Write)
// 0x3c : reserved
// 0x40 : Data signal of b_0
//        bit 31~0 - b_0[31:0] (Read/Write)
// 0x44 : Data signal of b_0
//        bit 31~0 - b_0[63:32] (Read/Write)
// 0x48 : reserved
// 0x4c : Data signal of b_1
//        bit 31~0 - b_1[31:0] (Read/Write)
// 0x50 : Data signal of b_1
//        bit 31~0 - b_1[63:32] (Read/Write)
// 0x54 : reserved
// 0x58 : Data signal of b_2
//        bit 31~0 - b_2[31:0] (Read/Write)
// 0x5c : Data signal of b_2
//        bit 31~0 - b_2[63:32] (Read/Write)
// 0x60 : reserved
// 0x64 : Data signal of b_3
//        bit 31~0 - b_3[31:0] (Read/Write)
// 0x68 : Data signal of b_3
//        bit 31~0 - b_3[63:32] (Read/Write)
// 0x6c : reserved
// 0x70 : Data signal of c_0
//        bit 31~0 - c_0[31:0] (Read/Write)
// 0x74 : Data signal of c_0
//        bit 31~0 - c_0[63:32] (Read/Write)
// 0x78 : reserved
// 0x7c : Data signal of c_1
//        bit 31~0 - c_1[31:0] (Read/Write)
// 0x80 : Data signal of c_1
//        bit 31~0 - c_1[63:32] (Read/Write)
// 0x84 : reserved
// 0x88 : Data signal of c_2
//        bit 31~0 - c_2[31:0] (Read/Write)
// 0x8c : Data signal of c_2
//        bit 31~0 - c_2[63:32] (Read/Write)
// 0x90 : reserved
// 0x94 : Data signal of c_3
//        bit 31~0 - c_3[31:0] (Read/Write)
// 0x98 : Data signal of c_3
//        bit 31~0 - c_3[63:32] (Read/Write)
// 0x9c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XKERNEL_CONTROL_ADDR_AP_CTRL  0x00
#define XKERNEL_CONTROL_ADDR_GIE      0x04
#define XKERNEL_CONTROL_ADDR_IER      0x08
#define XKERNEL_CONTROL_ADDR_ISR      0x0c
#define XKERNEL_CONTROL_ADDR_A_0_DATA 0x10
#define XKERNEL_CONTROL_BITS_A_0_DATA 64
#define XKERNEL_CONTROL_ADDR_A_1_DATA 0x1c
#define XKERNEL_CONTROL_BITS_A_1_DATA 64
#define XKERNEL_CONTROL_ADDR_A_2_DATA 0x28
#define XKERNEL_CONTROL_BITS_A_2_DATA 64
#define XKERNEL_CONTROL_ADDR_A_3_DATA 0x34
#define XKERNEL_CONTROL_BITS_A_3_DATA 64
#define XKERNEL_CONTROL_ADDR_B_0_DATA 0x40
#define XKERNEL_CONTROL_BITS_B_0_DATA 64
#define XKERNEL_CONTROL_ADDR_B_1_DATA 0x4c
#define XKERNEL_CONTROL_BITS_B_1_DATA 64
#define XKERNEL_CONTROL_ADDR_B_2_DATA 0x58
#define XKERNEL_CONTROL_BITS_B_2_DATA 64
#define XKERNEL_CONTROL_ADDR_B_3_DATA 0x64
#define XKERNEL_CONTROL_BITS_B_3_DATA 64
#define XKERNEL_CONTROL_ADDR_C_0_DATA 0x70
#define XKERNEL_CONTROL_BITS_C_0_DATA 64
#define XKERNEL_CONTROL_ADDR_C_1_DATA 0x7c
#define XKERNEL_CONTROL_BITS_C_1_DATA 64
#define XKERNEL_CONTROL_ADDR_C_2_DATA 0x88
#define XKERNEL_CONTROL_BITS_C_2_DATA 64
#define XKERNEL_CONTROL_ADDR_C_3_DATA 0x94
#define XKERNEL_CONTROL_BITS_C_3_DATA 64

