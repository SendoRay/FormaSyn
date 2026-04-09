// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xofdm_base.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XOfdm_base_CfgInitialize(XOfdm_base *InstancePtr, XOfdm_base_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XOfdm_base_Start(XOfdm_base *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL) & 0x80;
    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XOfdm_base_IsDone(XOfdm_base *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XOfdm_base_IsIdle(XOfdm_base *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XOfdm_base_IsReady(XOfdm_base *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XOfdm_base_Continue(XOfdm_base *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL) & 0x80;
    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL, Data | 0x10);
}

void XOfdm_base_EnableAutoRestart(XOfdm_base *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XOfdm_base_DisableAutoRestart(XOfdm_base *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_AP_CTRL, 0);
}

u32 XOfdm_base_Get_in_r_BaseAddress(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_IN_R_BASE);
}

u32 XOfdm_base_Get_in_r_HighAddress(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_IN_R_HIGH);
}

u32 XOfdm_base_Get_in_r_TotalBytes(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XOFDM_BASE_CONTROL_ADDR_IN_R_HIGH - XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + 1);
}

u32 XOfdm_base_Get_in_r_BitWidth(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XOFDM_BASE_CONTROL_WIDTH_IN_R;
}

u32 XOfdm_base_Get_in_r_Depth(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XOFDM_BASE_CONTROL_DEPTH_IN_R;
}

u32 XOfdm_base_Write_in_r_Words(XOfdm_base *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XOFDM_BASE_CONTROL_ADDR_IN_R_HIGH - XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XOfdm_base_Read_in_r_Words(XOfdm_base *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XOFDM_BASE_CONTROL_ADDR_IN_R_HIGH - XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + (offset + i)*4);
    }
    return length;
}

u32 XOfdm_base_Write_in_r_Bytes(XOfdm_base *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XOFDM_BASE_CONTROL_ADDR_IN_R_HIGH - XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XOfdm_base_Read_in_r_Bytes(XOfdm_base *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XOFDM_BASE_CONTROL_ADDR_IN_R_HIGH - XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_IN_R_BASE + offset + i);
    }
    return length;
}

u32 XOfdm_base_Get_out_r_BaseAddress(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE);
}

u32 XOfdm_base_Get_out_r_HighAddress(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_OUT_R_HIGH);
}

u32 XOfdm_base_Get_out_r_TotalBytes(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XOFDM_BASE_CONTROL_ADDR_OUT_R_HIGH - XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + 1);
}

u32 XOfdm_base_Get_out_r_BitWidth(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XOFDM_BASE_CONTROL_WIDTH_OUT_R;
}

u32 XOfdm_base_Get_out_r_Depth(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XOFDM_BASE_CONTROL_DEPTH_OUT_R;
}

u32 XOfdm_base_Write_out_r_Words(XOfdm_base *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XOFDM_BASE_CONTROL_ADDR_OUT_R_HIGH - XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XOfdm_base_Read_out_r_Words(XOfdm_base *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XOFDM_BASE_CONTROL_ADDR_OUT_R_HIGH - XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + (offset + i)*4);
    }
    return length;
}

u32 XOfdm_base_Write_out_r_Bytes(XOfdm_base *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XOFDM_BASE_CONTROL_ADDR_OUT_R_HIGH - XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XOfdm_base_Read_out_r_Bytes(XOfdm_base *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XOFDM_BASE_CONTROL_ADDR_OUT_R_HIGH - XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XOFDM_BASE_CONTROL_ADDR_OUT_R_BASE + offset + i);
    }
    return length;
}

void XOfdm_base_InterruptGlobalEnable(XOfdm_base *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_GIE, 1);
}

void XOfdm_base_InterruptGlobalDisable(XOfdm_base *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_GIE, 0);
}

void XOfdm_base_InterruptEnable(XOfdm_base *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_IER);
    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_IER, Register | Mask);
}

void XOfdm_base_InterruptDisable(XOfdm_base *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_IER);
    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_IER, Register & (~Mask));
}

void XOfdm_base_InterruptClear(XOfdm_base *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XOfdm_base_WriteReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_ISR, Mask);
}

u32 XOfdm_base_InterruptGetEnabled(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_IER);
}

u32 XOfdm_base_InterruptGetStatus(XOfdm_base *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XOfdm_base_ReadReg(InstancePtr->Control_BaseAddress, XOFDM_BASE_CONTROL_ADDR_ISR);
}

