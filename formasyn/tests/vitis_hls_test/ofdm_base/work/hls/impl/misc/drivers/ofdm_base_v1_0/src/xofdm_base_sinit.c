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
#include "xofdm_base.h"

extern XOfdm_base_Config XOfdm_base_ConfigTable[];

#ifdef SDT
XOfdm_base_Config *XOfdm_base_LookupConfig(UINTPTR BaseAddress) {
	XOfdm_base_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XOfdm_base_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XOfdm_base_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XOfdm_base_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XOfdm_base_Initialize(XOfdm_base *InstancePtr, UINTPTR BaseAddress) {
	XOfdm_base_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XOfdm_base_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XOfdm_base_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XOfdm_base_Config *XOfdm_base_LookupConfig(u16 DeviceId) {
	XOfdm_base_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XOFDM_BASE_NUM_INSTANCES; Index++) {
		if (XOfdm_base_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XOfdm_base_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XOfdm_base_Initialize(XOfdm_base *InstancePtr, u16 DeviceId) {
	XOfdm_base_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XOfdm_base_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XOfdm_base_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

