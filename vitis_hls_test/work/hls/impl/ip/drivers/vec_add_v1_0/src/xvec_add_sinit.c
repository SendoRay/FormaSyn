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
#include "xvec_add.h"

extern XVec_add_Config XVec_add_ConfigTable[];

#ifdef SDT
XVec_add_Config *XVec_add_LookupConfig(UINTPTR BaseAddress) {
	XVec_add_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XVec_add_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XVec_add_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XVec_add_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XVec_add_Initialize(XVec_add *InstancePtr, UINTPTR BaseAddress) {
	XVec_add_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XVec_add_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XVec_add_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XVec_add_Config *XVec_add_LookupConfig(u16 DeviceId) {
	XVec_add_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XVEC_ADD_NUM_INSTANCES; Index++) {
		if (XVec_add_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XVec_add_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XVec_add_Initialize(XVec_add *InstancePtr, u16 DeviceId) {
	XVec_add_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XVec_add_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XVec_add_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

