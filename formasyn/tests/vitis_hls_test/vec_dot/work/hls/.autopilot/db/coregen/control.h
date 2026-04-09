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
// 0x30 : Data signal of y
//        bit 31~0 - y[31:0] (Read)
// 0x34 : Data signal of y
//        bit 7~0 - y[39:32] (Read)
//        others  - reserved
// 0x38 : Control signal of y
//        bit 0  - y_ap_vld (Read/COR)
//        others - reserved
// 0x10 ~
// 0x1f : Memory 'a' (8 * 16b)
//        Word n : bit [15: 0] - a[2n]
//                 bit [31:16] - a[2n+1]
// 0x20 ~
// 0x2f : Memory 'b' (8 * 16b)
//        Word n : bit [15: 0] - b[2n]
//                 bit [31:16] - b[2n+1]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define CONTROL_ADDR_AP_CTRL 0x00
#define CONTROL_ADDR_GIE     0x04
#define CONTROL_ADDR_IER     0x08
#define CONTROL_ADDR_ISR     0x0c
#define CONTROL_ADDR_Y_DATA  0x30
#define CONTROL_BITS_Y_DATA  40
#define CONTROL_ADDR_Y_CTRL  0x38
#define CONTROL_ADDR_A_BASE  0x10
#define CONTROL_ADDR_A_HIGH  0x1f
#define CONTROL_WIDTH_A      16
#define CONTROL_DEPTH_A      8
#define CONTROL_ADDR_B_BASE  0x20
#define CONTROL_ADDR_B_HIGH  0x2f
#define CONTROL_WIDTH_B      16
#define CONTROL_DEPTH_B      8
