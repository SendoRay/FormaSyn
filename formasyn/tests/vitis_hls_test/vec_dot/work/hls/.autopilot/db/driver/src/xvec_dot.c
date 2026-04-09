// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xvec_dot.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XVec_dot_CfgInitialize(XVec_dot *InstancePtr, XVec_dot_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XVec_dot_Start(XVec_dot *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL) & 0x80;
    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XVec_dot_IsDone(XVec_dot *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XVec_dot_IsIdle(XVec_dot *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XVec_dot_IsReady(XVec_dot *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XVec_dot_Continue(XVec_dot *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL) & 0x80;
    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL, Data | 0x10);
}

void XVec_dot_EnableAutoRestart(XVec_dot *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XVec_dot_DisableAutoRestart(XVec_dot *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_AP_CTRL, 0);
}

u64 XVec_dot_Get_y(XVec_dot *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_Y_DATA);
    Data += (u64)XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_Y_DATA + 4) << 32;
    return Data;
}

u32 XVec_dot_Get_y_vld(XVec_dot *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_Y_CTRL);
    return Data & 0x1;
}

u32 XVec_dot_Get_a_BaseAddress(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_A_BASE);
}

u32 XVec_dot_Get_a_HighAddress(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_A_HIGH);
}

u32 XVec_dot_Get_a_TotalBytes(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XVEC_DOT_CONTROL_ADDR_A_HIGH - XVEC_DOT_CONTROL_ADDR_A_BASE + 1);
}

u32 XVec_dot_Get_a_BitWidth(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_DOT_CONTROL_WIDTH_A;
}

u32 XVec_dot_Get_a_Depth(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_DOT_CONTROL_DEPTH_A;
}

u32 XVec_dot_Write_a_Words(XVec_dot *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_DOT_CONTROL_ADDR_A_HIGH - XVEC_DOT_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_A_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XVec_dot_Read_a_Words(XVec_dot *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_DOT_CONTROL_ADDR_A_HIGH - XVEC_DOT_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_A_BASE + (offset + i)*4);
    }
    return length;
}

u32 XVec_dot_Write_a_Bytes(XVec_dot *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_DOT_CONTROL_ADDR_A_HIGH - XVEC_DOT_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_A_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XVec_dot_Read_a_Bytes(XVec_dot *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_DOT_CONTROL_ADDR_A_HIGH - XVEC_DOT_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_A_BASE + offset + i);
    }
    return length;
}

u32 XVec_dot_Get_b_BaseAddress(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_B_BASE);
}

u32 XVec_dot_Get_b_HighAddress(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_B_HIGH);
}

u32 XVec_dot_Get_b_TotalBytes(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XVEC_DOT_CONTROL_ADDR_B_HIGH - XVEC_DOT_CONTROL_ADDR_B_BASE + 1);
}

u32 XVec_dot_Get_b_BitWidth(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_DOT_CONTROL_WIDTH_B;
}

u32 XVec_dot_Get_b_Depth(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_DOT_CONTROL_DEPTH_B;
}

u32 XVec_dot_Write_b_Words(XVec_dot *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_DOT_CONTROL_ADDR_B_HIGH - XVEC_DOT_CONTROL_ADDR_B_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_B_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XVec_dot_Read_b_Words(XVec_dot *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_DOT_CONTROL_ADDR_B_HIGH - XVEC_DOT_CONTROL_ADDR_B_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_B_BASE + (offset + i)*4);
    }
    return length;
}

u32 XVec_dot_Write_b_Bytes(XVec_dot *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_DOT_CONTROL_ADDR_B_HIGH - XVEC_DOT_CONTROL_ADDR_B_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_B_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XVec_dot_Read_b_Bytes(XVec_dot *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_DOT_CONTROL_ADDR_B_HIGH - XVEC_DOT_CONTROL_ADDR_B_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XVEC_DOT_CONTROL_ADDR_B_BASE + offset + i);
    }
    return length;
}

void XVec_dot_InterruptGlobalEnable(XVec_dot *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_GIE, 1);
}

void XVec_dot_InterruptGlobalDisable(XVec_dot *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_GIE, 0);
}

void XVec_dot_InterruptEnable(XVec_dot *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_IER);
    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_IER, Register | Mask);
}

void XVec_dot_InterruptDisable(XVec_dot *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_IER);
    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_IER, Register & (~Mask));
}

void XVec_dot_InterruptClear(XVec_dot *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_dot_WriteReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_ISR, Mask);
}

u32 XVec_dot_InterruptGetEnabled(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_IER);
}

u32 XVec_dot_InterruptGetStatus(XVec_dot *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVec_dot_ReadReg(InstancePtr->Control_BaseAddress, XVEC_DOT_CONTROL_ADDR_ISR);
}

