// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xvec_add.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XVec_add_CfgInitialize(XVec_add *InstancePtr, XVec_add_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XVec_add_Start(XVec_add *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL) & 0x80;
    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XVec_add_IsDone(XVec_add *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XVec_add_IsIdle(XVec_add *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XVec_add_IsReady(XVec_add *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XVec_add_Continue(XVec_add *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL) & 0x80;
    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL, Data | 0x10);
}

void XVec_add_EnableAutoRestart(XVec_add *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XVec_add_DisableAutoRestart(XVec_add *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_AP_CTRL, 0);
}

u32 XVec_add_Get_a_BaseAddress(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_A_BASE);
}

u32 XVec_add_Get_a_HighAddress(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_A_HIGH);
}

u32 XVec_add_Get_a_TotalBytes(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XVEC_ADD_CONTROL_ADDR_A_HIGH - XVEC_ADD_CONTROL_ADDR_A_BASE + 1);
}

u32 XVec_add_Get_a_BitWidth(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_ADD_CONTROL_WIDTH_A;
}

u32 XVec_add_Get_a_Depth(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_ADD_CONTROL_DEPTH_A;
}

u32 XVec_add_Write_a_Words(XVec_add *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_ADD_CONTROL_ADDR_A_HIGH - XVEC_ADD_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_A_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XVec_add_Read_a_Words(XVec_add *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_ADD_CONTROL_ADDR_A_HIGH - XVEC_ADD_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_A_BASE + (offset + i)*4);
    }
    return length;
}

u32 XVec_add_Write_a_Bytes(XVec_add *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_ADD_CONTROL_ADDR_A_HIGH - XVEC_ADD_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_A_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XVec_add_Read_a_Bytes(XVec_add *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_ADD_CONTROL_ADDR_A_HIGH - XVEC_ADD_CONTROL_ADDR_A_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_A_BASE + offset + i);
    }
    return length;
}

u32 XVec_add_Get_b_BaseAddress(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_B_BASE);
}

u32 XVec_add_Get_b_HighAddress(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_B_HIGH);
}

u32 XVec_add_Get_b_TotalBytes(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XVEC_ADD_CONTROL_ADDR_B_HIGH - XVEC_ADD_CONTROL_ADDR_B_BASE + 1);
}

u32 XVec_add_Get_b_BitWidth(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_ADD_CONTROL_WIDTH_B;
}

u32 XVec_add_Get_b_Depth(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_ADD_CONTROL_DEPTH_B;
}

u32 XVec_add_Write_b_Words(XVec_add *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_ADD_CONTROL_ADDR_B_HIGH - XVEC_ADD_CONTROL_ADDR_B_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_B_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XVec_add_Read_b_Words(XVec_add *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_ADD_CONTROL_ADDR_B_HIGH - XVEC_ADD_CONTROL_ADDR_B_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_B_BASE + (offset + i)*4);
    }
    return length;
}

u32 XVec_add_Write_b_Bytes(XVec_add *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_ADD_CONTROL_ADDR_B_HIGH - XVEC_ADD_CONTROL_ADDR_B_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_B_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XVec_add_Read_b_Bytes(XVec_add *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_ADD_CONTROL_ADDR_B_HIGH - XVEC_ADD_CONTROL_ADDR_B_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_B_BASE + offset + i);
    }
    return length;
}

u32 XVec_add_Get_y_BaseAddress(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_Y_BASE);
}

u32 XVec_add_Get_y_HighAddress(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_Y_HIGH);
}

u32 XVec_add_Get_y_TotalBytes(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XVEC_ADD_CONTROL_ADDR_Y_HIGH - XVEC_ADD_CONTROL_ADDR_Y_BASE + 1);
}

u32 XVec_add_Get_y_BitWidth(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_ADD_CONTROL_WIDTH_Y;
}

u32 XVec_add_Get_y_Depth(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVEC_ADD_CONTROL_DEPTH_Y;
}

u32 XVec_add_Write_y_Words(XVec_add *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_ADD_CONTROL_ADDR_Y_HIGH - XVEC_ADD_CONTROL_ADDR_Y_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_Y_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XVec_add_Read_y_Words(XVec_add *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XVEC_ADD_CONTROL_ADDR_Y_HIGH - XVEC_ADD_CONTROL_ADDR_Y_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_Y_BASE + (offset + i)*4);
    }
    return length;
}

u32 XVec_add_Write_y_Bytes(XVec_add *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_ADD_CONTROL_ADDR_Y_HIGH - XVEC_ADD_CONTROL_ADDR_Y_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_Y_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XVec_add_Read_y_Bytes(XVec_add *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XVEC_ADD_CONTROL_ADDR_Y_HIGH - XVEC_ADD_CONTROL_ADDR_Y_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XVEC_ADD_CONTROL_ADDR_Y_BASE + offset + i);
    }
    return length;
}

void XVec_add_InterruptGlobalEnable(XVec_add *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_GIE, 1);
}

void XVec_add_InterruptGlobalDisable(XVec_add *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_GIE, 0);
}

void XVec_add_InterruptEnable(XVec_add *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_IER);
    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_IER, Register | Mask);
}

void XVec_add_InterruptDisable(XVec_add *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_IER);
    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_IER, Register & (~Mask));
}

void XVec_add_InterruptClear(XVec_add *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XVec_add_WriteReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_ISR, Mask);
}

u32 XVec_add_InterruptGetEnabled(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_IER);
}

u32 XVec_add_InterruptGetStatus(XVec_add *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XVec_add_ReadReg(InstancePtr->Control_BaseAddress, XVEC_ADD_CONTROL_ADDR_ISR);
}

