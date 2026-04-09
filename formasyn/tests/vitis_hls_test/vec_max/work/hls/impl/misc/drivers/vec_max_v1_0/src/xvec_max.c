// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xvec_max.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XVec_max_CfgInitialize(XVec_max *InstancePtr, XVec_max_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XVec_max_Start(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL) & 0x80;
    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XVec_max_IsDone(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XVec_max_IsIdle(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XVec_max_IsReady(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XVec_max_Continue(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL) & 0x80;
    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL, Data | 0x10);
}

void XVec_max_EnableAutoRestart(XVec_max *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XVec_max_DisableAutoRestart(XVec_max *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_AP_CTRL, 0);
}

u32 XVec_max_Get_y(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_Y_DATA);
    return Data;
}

u32 XVec_max_Get_y_vld(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_Y_CTRL);
    return Data & 0x1;
}

u32 XVec_max_Get_idx(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_IDX_DATA);
    return Data;
}

u32 XVec_max_Get_idx_vld(XVec_max *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_IDX_CTRL);
    return Data & 0x1;
}

u32 XVec_max_Get_a_BaseAddress(XVec_max *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_MAX_CONTROL_ADDR_A_BASE);
}

u32 XVec_max_Get_a_HighAddress(XVec_max *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_MAX_CONTROL_ADDR_A_HIGH);
}

u32 XVec_max_Get_a_TotalBytes(XVec_max *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XVEC_MAX_CONTROL_ADDR_A_HIGH - XVEC_MAX_CONTROL_ADDR_A_BASE + 1);
}

u32 XVec_max_Get_a_BitWidth(XVec_max *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_MAX_CONTROL_WIDTH_A;
}

u32 XVec_max_Get_a_Depth(XVec_max *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_MAX_CONTROL_DEPTH_A;
}

u32 XVec_max_Write_a_Words(XVec_max *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_MAX_CONTROL_ADDR_A_HIGH - XVEC_MAX_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XVEC_MAX_CONTROL_ADDR_A_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XVec_max_Read_a_Words(XVec_max *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_MAX_CONTROL_ADDR_A_HIGH - XVEC_MAX_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XVEC_MAX_CONTROL_ADDR_A_BASE + (offset + i)*4);
    }
    return length;
}

u32 XVec_max_Write_a_Bytes(XVec_max *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_MAX_CONTROL_ADDR_A_HIGH - XVEC_MAX_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XVEC_MAX_CONTROL_ADDR_A_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XVec_max_Read_a_Bytes(XVec_max *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_MAX_CONTROL_ADDR_A_HIGH - XVEC_MAX_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XVEC_MAX_CONTROL_ADDR_A_BASE + offset + i);
    }
    return length;
}

void XVec_max_InterruptGlobalEnable(XVec_max *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_GIE, 1);
}

void XVec_max_InterruptGlobalDisable(XVec_max *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_GIE, 0);
}

void XVec_max_InterruptEnable(XVec_max *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_IER);
    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_IER, Register | Mask);
}

void XVec_max_InterruptDisable(XVec_max *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_IER);
    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_IER, Register & (~Mask));
}

void XVec_max_InterruptClear(XVec_max *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_max_WriteReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_ISR, Mask);
}

u32 XVec_max_InterruptGetEnabled(XVec_max *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_IER);
}

u32 XVec_max_InterruptGetStatus(XVec_max *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVec_max_ReadReg(InstancePtr->Control_BaseAddress, XVEC_MAX_CONTROL_ADDR_ISR);
}

