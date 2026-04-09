// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xconv_encode.h"

extern XConv_encode_Config XConv_encode_ConfigTable[];

#ifdef SDT
XConv_encode_Config *XConv_encode_LookupConfig(UINTPTR BaseAddress) {
	XConv_encode_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XConv_encode_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XConv_encode_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XConv_encode_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XConv_encode_Initialize(XConv_encode *InstancePtr, UINTPTR BaseAddress) {
	XConv_encode_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XConv_encode_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XConv_encode_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XConv_encode_Config *XConv_encode_LookupConfig(u16 DeviceId) {
	XConv_encode_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XCONV_ENCODE_NUM_INSTANCES; Index++) {
		if (XConv_encode_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XConv_encode_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XConv_encode_Initialize(XConv_encode *InstancePtr, u16 DeviceId) {
	XConv_encode_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XConv_encode_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XConv_encode_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

