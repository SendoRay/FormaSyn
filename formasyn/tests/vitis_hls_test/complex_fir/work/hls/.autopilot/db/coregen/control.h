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
// 0x10 : Data signal of x_real
//        bit 15~0 - x_real[15:0] (Read/Write)
//        others   - reserved
// 0x14 : reserved
// 0x18 : Data signal of x_imag
//        bit 15~0 - x_imag[15:0] (Read/Write)
//        others   - reserved
// 0x1c : reserved
// 0x20 : Data signal of y_real
//        bit 15~0 - y_real[15:0] (Read)
//        others   - reserved
// 0x24 : reserved
// 0x30 : Data signal of y_imag
//        bit 15~0 - y_imag[15:0] (Read)
//        others   - reserved
// 0x34 : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define CONTROL_ADDR_AP_CTRL     0x00
#define CONTROL_ADDR_GIE         0x04
#define CONTROL_ADDR_IER         0x08
#define CONTROL_ADDR_ISR         0x0c
#define CONTROL_ADDR_X_REAL_DATA 0x10
#define CONTROL_BITS_X_REAL_DATA 16
#define CONTROL_ADDR_X_IMAG_DATA 0x18
#define CONTROL_BITS_X_IMAG_DATA 16
#define CONTROL_ADDR_Y_REAL_DATA 0x20
#define CONTROL_BITS_Y_REAL_DATA 16
#define CONTROL_ADDR_Y_IMAG_DATA 0x30
#define CONTROL_BITS_Y_IMAG_DATA 16
