// 0x000 : Control signals
//         bit 0  - ap_start (Read/Write/COH)
//         bit 1  - ap_done (Read)
//         bit 2  - ap_idle (Read)
//         bit 3  - ap_ready (Read/COR)
//         bit 4  - ap_continue (Read/Write/SC)
//         bit 7  - auto_restart (Read/Write)
//         bit 9  - interrupt (Read)
//         others - reserved
// 0x004 : Global Interrupt Enable Register
//         bit 0  - Global Interrupt Enable (Read/Write)
//         others - reserved
// 0x008 : IP Interrupt Enable Register (Read/Write)
//         bit 0 - enable ap_done interrupt (Read/Write)
//         bit 1 - enable ap_ready interrupt (Read/Write)
//         others - reserved
// 0x00c : IP Interrupt Status Register (Read/TOW)
//         bit 0 - ap_done (Read/TOW)
//         bit 1 - ap_ready (Read/TOW)
//         others - reserved
// 0x010 : Data signal of a_0
//         bit 31~0 - a_0[31:0] (Read/Write)
// 0x014 : Data signal of a_0
//         bit 31~0 - a_0[63:32] (Read/Write)
// 0x018 : reserved
// 0x01c : Data signal of a_1
//         bit 31~0 - a_1[31:0] (Read/Write)
// 0x020 : Data signal of a_1
//         bit 31~0 - a_1[63:32] (Read/Write)
// 0x024 : reserved
// 0x028 : Data signal of a_2
//         bit 31~0 - a_2[31:0] (Read/Write)
// 0x02c : Data signal of a_2
//         bit 31~0 - a_2[63:32] (Read/Write)
// 0x030 : reserved
// 0x034 : Data signal of a_3
//         bit 31~0 - a_3[31:0] (Read/Write)
// 0x038 : Data signal of a_3
//         bit 31~0 - a_3[63:32] (Read/Write)
// 0x03c : reserved
// 0x040 : Data signal of a_4
//         bit 31~0 - a_4[31:0] (Read/Write)
// 0x044 : Data signal of a_4
//         bit 31~0 - a_4[63:32] (Read/Write)
// 0x048 : reserved
// 0x04c : Data signal of a_5
//         bit 31~0 - a_5[31:0] (Read/Write)
// 0x050 : Data signal of a_5
//         bit 31~0 - a_5[63:32] (Read/Write)
// 0x054 : reserved
// 0x058 : Data signal of a_6
//         bit 31~0 - a_6[31:0] (Read/Write)
// 0x05c : Data signal of a_6
//         bit 31~0 - a_6[63:32] (Read/Write)
// 0x060 : reserved
// 0x064 : Data signal of a_7
//         bit 31~0 - a_7[31:0] (Read/Write)
// 0x068 : Data signal of a_7
//         bit 31~0 - a_7[63:32] (Read/Write)
// 0x06c : reserved
// 0x070 : Data signal of b_0
//         bit 31~0 - b_0[31:0] (Read/Write)
// 0x074 : Data signal of b_0
//         bit 31~0 - b_0[63:32] (Read/Write)
// 0x078 : reserved
// 0x07c : Data signal of b_1
//         bit 31~0 - b_1[31:0] (Read/Write)
// 0x080 : Data signal of b_1
//         bit 31~0 - b_1[63:32] (Read/Write)
// 0x084 : reserved
// 0x088 : Data signal of b_2
//         bit 31~0 - b_2[31:0] (Read/Write)
// 0x08c : Data signal of b_2
//         bit 31~0 - b_2[63:32] (Read/Write)
// 0x090 : reserved
// 0x094 : Data signal of b_3
//         bit 31~0 - b_3[31:0] (Read/Write)
// 0x098 : Data signal of b_3
//         bit 31~0 - b_3[63:32] (Read/Write)
// 0x09c : reserved
// 0x0a0 : Data signal of b_4
//         bit 31~0 - b_4[31:0] (Read/Write)
// 0x0a4 : Data signal of b_4
//         bit 31~0 - b_4[63:32] (Read/Write)
// 0x0a8 : reserved
// 0x0ac : Data signal of b_5
//         bit 31~0 - b_5[31:0] (Read/Write)
// 0x0b0 : Data signal of b_5
//         bit 31~0 - b_5[63:32] (Read/Write)
// 0x0b4 : reserved
// 0x0b8 : Data signal of b_6
//         bit 31~0 - b_6[31:0] (Read/Write)
// 0x0bc : Data signal of b_6
//         bit 31~0 - b_6[63:32] (Read/Write)
// 0x0c0 : reserved
// 0x0c4 : Data signal of b_7
//         bit 31~0 - b_7[31:0] (Read/Write)
// 0x0c8 : Data signal of b_7
//         bit 31~0 - b_7[63:32] (Read/Write)
// 0x0cc : reserved
// 0x0d0 : Data signal of c_0
//         bit 31~0 - c_0[31:0] (Read/Write)
// 0x0d4 : Data signal of c_0
//         bit 31~0 - c_0[63:32] (Read/Write)
// 0x0d8 : reserved
// 0x0dc : Data signal of c_1
//         bit 31~0 - c_1[31:0] (Read/Write)
// 0x0e0 : Data signal of c_1
//         bit 31~0 - c_1[63:32] (Read/Write)
// 0x0e4 : reserved
// 0x0e8 : Data signal of c_2
//         bit 31~0 - c_2[31:0] (Read/Write)
// 0x0ec : Data signal of c_2
//         bit 31~0 - c_2[63:32] (Read/Write)
// 0x0f0 : reserved
// 0x0f4 : Data signal of c_3
//         bit 31~0 - c_3[31:0] (Read/Write)
// 0x0f8 : Data signal of c_3
//         bit 31~0 - c_3[63:32] (Read/Write)
// 0x0fc : reserved
// 0x100 : Data signal of c_4
//         bit 31~0 - c_4[31:0] (Read/Write)
// 0x104 : Data signal of c_4
//         bit 31~0 - c_4[63:32] (Read/Write)
// 0x108 : reserved
// 0x10c : Data signal of c_5
//         bit 31~0 - c_5[31:0] (Read/Write)
// 0x110 : Data signal of c_5
//         bit 31~0 - c_5[63:32] (Read/Write)
// 0x114 : reserved
// 0x118 : Data signal of c_6
//         bit 31~0 - c_6[31:0] (Read/Write)
// 0x11c : Data signal of c_6
//         bit 31~0 - c_6[63:32] (Read/Write)
// 0x120 : reserved
// 0x124 : Data signal of c_7
//         bit 31~0 - c_7[31:0] (Read/Write)
// 0x128 : Data signal of c_7
//         bit 31~0 - c_7[63:32] (Read/Write)
// 0x12c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define CONTROL_ADDR_AP_CTRL  0x000
#define CONTROL_ADDR_GIE      0x004
#define CONTROL_ADDR_IER      0x008
#define CONTROL_ADDR_ISR      0x00c
#define CONTROL_ADDR_A_0_DATA 0x010
#define CONTROL_BITS_A_0_DATA 64
#define CONTROL_ADDR_A_1_DATA 0x01c
#define CONTROL_BITS_A_1_DATA 64
#define CONTROL_ADDR_A_2_DATA 0x028
#define CONTROL_BITS_A_2_DATA 64
#define CONTROL_ADDR_A_3_DATA 0x034
#define CONTROL_BITS_A_3_DATA 64
#define CONTROL_ADDR_A_4_DATA 0x040
#define CONTROL_BITS_A_4_DATA 64
#define CONTROL_ADDR_A_5_DATA 0x04c
#define CONTROL_BITS_A_5_DATA 64
#define CONTROL_ADDR_A_6_DATA 0x058
#define CONTROL_BITS_A_6_DATA 64
#define CONTROL_ADDR_A_7_DATA 0x064
#define CONTROL_BITS_A_7_DATA 64
#define CONTROL_ADDR_B_0_DATA 0x070
#define CONTROL_BITS_B_0_DATA 64
#define CONTROL_ADDR_B_1_DATA 0x07c
#define CONTROL_BITS_B_1_DATA 64
#define CONTROL_ADDR_B_2_DATA 0x088
#define CONTROL_BITS_B_2_DATA 64
#define CONTROL_ADDR_B_3_DATA 0x094
#define CONTROL_BITS_B_3_DATA 64
#define CONTROL_ADDR_B_4_DATA 0x0a0
#define CONTROL_BITS_B_4_DATA 64
#define CONTROL_ADDR_B_5_DATA 0x0ac
#define CONTROL_BITS_B_5_DATA 64
#define CONTROL_ADDR_B_6_DATA 0x0b8
#define CONTROL_BITS_B_6_DATA 64
#define CONTROL_ADDR_B_7_DATA 0x0c4
#define CONTROL_BITS_B_7_DATA 64
#define CONTROL_ADDR_C_0_DATA 0x0d0
#define CONTROL_BITS_C_0_DATA 64
#define CONTROL_ADDR_C_1_DATA 0x0dc
#define CONTROL_BITS_C_1_DATA 64
#define CONTROL_ADDR_C_2_DATA 0x0e8
#define CONTROL_BITS_C_2_DATA 64
#define CONTROL_ADDR_C_3_DATA 0x0f4
#define CONTROL_BITS_C_3_DATA 64
#define CONTROL_ADDR_C_4_DATA 0x100
#define CONTROL_BITS_C_4_DATA 64
#define CONTROL_ADDR_C_5_DATA 0x10c
#define CONTROL_BITS_C_5_DATA 64
#define CONTROL_ADDR_C_6_DATA 0x118
#define CONTROL_BITS_C_6_DATA 64
#define CONTROL_ADDR_C_7_DATA 0x124
#define CONTROL_BITS_C_7_DATA 64
