// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XCONV_ENCODE_H
#define XCONV_ENCODE_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xconv_encode_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XConv_encode_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XConv_encode;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XConv_encode_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XConv_encode_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XConv_encode_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XConv_encode_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XConv_encode_Initialize(XConv_encode *InstancePtr, UINTPTR BaseAddress);
XConv_encode_Config* XConv_encode_LookupConfig(UINTPTR BaseAddress);
#else
int XConv_encode_Initialize(XConv_encode *InstancePtr, u16 DeviceId);
XConv_encode_Config* XConv_encode_LookupConfig(u16 DeviceId);
#endif
int XConv_encode_CfgInitialize(XConv_encode *InstancePtr, XConv_encode_Config *ConfigPtr);
#else
int XConv_encode_Initialize(XConv_encode *InstancePtr, const char* InstanceName);
int XConv_encode_Release(XConv_encode *InstancePtr);
#endif

void XConv_encode_Start(XConv_encode *InstancePtr);
u32 XConv_encode_IsDone(XConv_encode *InstancePtr);
u32 XConv_encode_IsIdle(XConv_encode *InstancePtr);
u32 XConv_encode_IsReady(XConv_encode *InstancePtr);
void XConv_encode_Continue(XConv_encode *InstancePtr);
void XConv_encode_EnableAutoRestart(XConv_encode *InstancePtr);
void XConv_encode_DisableAutoRestart(XConv_encode *InstancePtr);

void XConv_encode_Set_num_bits(XConv_encode *InstancePtr, u32 Data);
u32 XConv_encode_Get_num_bits(XConv_encode *InstancePtr);

void XConv_encode_InterruptGlobalEnable(XConv_encode *InstancePtr);
void XConv_encode_InterruptGlobalDisable(XConv_encode *InstancePtr);
void XConv_encode_InterruptEnable(XConv_encode *InstancePtr, u32 Mask);
void XConv_encode_InterruptDisable(XConv_encode *InstancePtr, u32 Mask);
void XConv_encode_InterruptClear(XConv_encode *InstancePtr, u32 Mask);
u32 XConv_encode_InterruptGetEnabled(XConv_encode *InstancePtr);
u32 XConv_encode_InterruptGetStatus(XConv_encode *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
