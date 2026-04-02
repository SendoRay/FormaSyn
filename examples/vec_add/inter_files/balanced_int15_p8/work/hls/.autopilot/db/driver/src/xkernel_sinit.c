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
#include "xkernel.h"

extern XKernel_Config XKernel_ConfigTable[];

#ifdef SDT
XKernel_Config *XKernel_LookupConfig(UINTPTR BaseAddress) {
	XKernel_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XKernel_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XKernel_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XKernel_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XKernel_Initialize(XKernel *InstancePtr, UINTPTR BaseAddress) {
	XKernel_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XKernel_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XKernel_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XKernel_Config *XKernel_LookupConfig(u16 DeviceId) {
	XKernel_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XKERNEL_NUM_INSTANCES; Index++) {
		if (XKernel_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XKernel_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XKernel_Initialize(XKernel *InstancePtr, u16 DeviceId) {
	XKernel_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XKernel_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XKernel_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

