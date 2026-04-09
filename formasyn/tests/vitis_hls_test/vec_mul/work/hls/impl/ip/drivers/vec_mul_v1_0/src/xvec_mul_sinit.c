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
#include "xvec_mul.h"

extern XVec_mul_Config XVec_mul_ConfigTable[];

#ifdef SDT
XVec_mul_Config *XVec_mul_LookupConfig(UINTPTR BaseAddress) {
	XVec_mul_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XVec_mul_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XVec_mul_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XVec_mul_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XVec_mul_Initialize(XVec_mul *InstancePtr, UINTPTR BaseAddress) {
	XVec_mul_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XVec_mul_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XVec_mul_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XVec_mul_Config *XVec_mul_LookupConfig(u16 DeviceId) {
	XVec_mul_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XVEC_MUL_NUM_INSTANCES; Index++) {
		if (XVec_mul_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XVec_mul_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XVec_mul_Initialize(XVec_mul *InstancePtr, u16 DeviceId) {
	XVec_mul_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XVec_mul_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XVec_mul_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

