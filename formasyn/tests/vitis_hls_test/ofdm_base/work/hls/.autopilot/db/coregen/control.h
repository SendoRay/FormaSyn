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
// 0x40 ~
// 0x7f : Memory 'in_r' (16 * 32b)
//        Word n : bit [31:0] - in_r[n]
// 0x80 ~
// 0xff : Memory 'out_r' (20 * 32b)
//        Word n : bit [31:0] - out_r[n]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define CONTROL_ADDR_AP_CTRL    0x00
#define CONTROL_ADDR_GIE        0x04
#define CONTROL_ADDR_IER        0x08
#define CONTROL_ADDR_ISR        0x0c
#define CONTROL_ADDR_IN_R_BASE  0x40
#define CONTROL_ADDR_IN_R_HIGH  0x7f
#define CONTROL_WIDTH_IN_R      32
#define CONTROL_DEPTH_IN_R      16
#define CONTROL_ADDR_OUT_R_BASE 0x80
#define CONTROL_ADDR_OUT_R_HIGH 0xff
#define CONTROL_WIDTH_OUT_R     32
#define CONTROL_DEPTH_OUT_R     20
