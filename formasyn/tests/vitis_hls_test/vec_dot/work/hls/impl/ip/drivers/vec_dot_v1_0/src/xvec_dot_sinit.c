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
#include "xvec_dot.h"

extern XVec_dot_Config XVec_dot_ConfigTable[];

#ifdef SDT
XVec_dot_Config *XVec_dot_LookupConfig(UINTPTR BaseAddress) {
	XVec_dot_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XVec_dot_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XVec_dot_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XVec_dot_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XVec_dot_Initialize(XVec_dot *InstancePtr, UINTPTR BaseAddress) {
	XVec_dot_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XVec_dot_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XVec_dot_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XVec_dot_Config *XVec_dot_LookupConfig(u16 DeviceId) {
	XVec_dot_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XVEC_DOT_NUM_INSTANCES; Index++) {
		if (XVec_dot_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XVec_dot_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XVec_dot_Initialize(XVec_dot *InstancePtr, u16 DeviceId) {
	XVec_dot_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XVec_dot_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XVec_dot_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

