// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XVEC_MAX_H
#define XVEC_MAX_H

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
#include "xvec_max_hw.h"

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
} XVec_max_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XVec_max;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XVec_max_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XVec_max_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XVec_max_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XVec_max_ReadReg(BaseAddress, RegOffset) \
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
int XVec_max_Initialize(XVec_max *InstancePtr, UINTPTR BaseAddress);
XVec_max_Config* XVec_max_LookupConfig(UINTPTR BaseAddress);
#else
int XVec_max_Initialize(XVec_max *InstancePtr, u16 DeviceId);
XVec_max_Config* XVec_max_LookupConfig(u16 DeviceId);
#endif
int XVec_max_CfgInitialize(XVec_max *InstancePtr, XVec_max_Config *ConfigPtr);
#else
int XVec_max_Initialize(XVec_max *InstancePtr, const char* InstanceName);
int XVec_max_Release(XVec_max *InstancePtr);
#endif

void XVec_max_Start(XVec_max *InstancePtr);
u32 XVec_max_IsDone(XVec_max *InstancePtr);
u32 XVec_max_IsIdle(XVec_max *InstancePtr);
u32 XVec_max_IsReady(XVec_max *InstancePtr);
void XVec_max_Continue(XVec_max *InstancePtr);
void XVec_max_EnableAutoRestart(XVec_max *InstancePtr);
void XVec_max_DisableAutoRestart(XVec_max *InstancePtr);

u32 XVec_max_Get_y(XVec_max *InstancePtr);
u32 XVec_max_Get_y_vld(XVec_max *InstancePtr);
u32 XVec_max_Get_idx(XVec_max *InstancePtr);
u32 XVec_max_Get_idx_vld(XVec_max *InstancePtr);
u32 XVec_max_Get_a_BaseAddress(XVec_max *InstancePtr);
u32 XVec_max_Get_a_HighAddress(XVec_max *InstancePtr);
u32 XVec_max_Get_a_TotalBytes(XVec_max *InstancePtr);
u32 XVec_max_Get_a_BitWidth(XVec_max *InstancePtr);
u32 XVec_max_Get_a_Depth(XVec_max *InstancePtr);
u32 XVec_max_Write_a_Words(XVec_max *InstancePtr, int offset, word_type *data, int length);
u32 XVec_max_Read_a_Words(XVec_max *InstancePtr, int offset, word_type *data, int length);
u32 XVec_max_Write_a_Bytes(XVec_max *InstancePtr, int offset, char *data, int length);
u32 XVec_max_Read_a_Bytes(XVec_max *InstancePtr, int offset, char *data, int length);

void XVec_max_InterruptGlobalEnable(XVec_max *InstancePtr);
void XVec_max_InterruptGlobalDisable(XVec_max *InstancePtr);
void XVec_max_InterruptEnable(XVec_max *InstancePtr, u32 Mask);
void XVec_max_InterruptDisable(XVec_max *InstancePtr, u32 Mask);
void XVec_max_InterruptClear(XVec_max *InstancePtr, u32 Mask);
u32 XVec_max_InterruptGetEnabled(XVec_max *InstancePtr);
u32 XVec_max_InterruptGetStatus(XVec_max *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
