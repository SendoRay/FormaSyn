// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xconv_encode.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XConv_encode_CfgInitialize(XConv_encode *InstancePtr, XConv_encode_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XConv_encode_Start(XConv_encode *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL) & 0x80;
    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XConv_encode_IsDone(XConv_encode *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XConv_encode_IsIdle(XConv_encode *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XConv_encode_IsReady(XConv_encode *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XConv_encode_Continue(XConv_encode *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL) & 0x80;
    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL, Data | 0x10);
}

void XConv_encode_EnableAutoRestart(XConv_encode *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XConv_encode_DisableAutoRestart(XConv_encode *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_AP_CTRL, 0);
}

void XConv_encode_Set_num_bits(XConv_encode *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_NUM_BITS_DATA, Data);
}

u32 XConv_encode_Get_num_bits(XConv_encode *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_NUM_BITS_DATA);
    return Data;
}

void XConv_encode_InterruptGlobalEnable(XConv_encode *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_GIE, 1);
}

void XConv_encode_InterruptGlobalDisable(XConv_encode *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_GIE, 0);
}

void XConv_encode_InterruptEnable(XConv_encode *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_IER);
    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_IER, Register | Mask);
}

void XConv_encode_InterruptDisable(XConv_encode *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_IER);
    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_IER, Register & (~Mask));
}

void XConv_encode_InterruptClear(XConv_encode *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XConv_encode_WriteReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_ISR, Mask);
}

u32 XConv_encode_InterruptGetEnabled(XConv_encode *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_IER);
}

u32 XConv_encode_InterruptGetStatus(XConv_encode *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XConv_encode_ReadReg(InstancePtr->Control_BaseAddress, XCONV_ENCODE_CONTROL_ADDR_ISR);
}

