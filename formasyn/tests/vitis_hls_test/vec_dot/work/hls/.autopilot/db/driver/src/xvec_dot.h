// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XVEC_DOT_H
#define XVEC_DOT_H

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
#include "xvec_dot_hw.h"

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
} XVec_dot_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XVec_dot;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XVec_dot_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XVec_dot_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XVec_dot_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XVec_dot_ReadReg(BaseAddress, RegOffset) \
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
int XVec_dot_Initialize(XVec_dot *InstancePtr, UINTPTR BaseAddress);
XVec_dot_Config* XVec_dot_LookupConfig(UINTPTR BaseAddress);
#else
int XVec_dot_Initialize(XVec_dot *InstancePtr, u16 DeviceId);
XVec_dot_Config* XVec_dot_LookupConfig(u16 DeviceId);
#endif
int XVec_dot_CfgInitialize(XVec_dot *InstancePtr, XVec_dot_Config *ConfigPtr);
#else
int XVec_dot_Initialize(XVec_dot *InstancePtr, const char* InstanceName);
int XVec_dot_Release(XVec_dot *InstancePtr);
#endif

void XVec_dot_Start(XVec_dot *InstancePtr);
u32 XVec_dot_IsDone(XVec_dot *InstancePtr);
u32 XVec_dot_IsIdle(XVec_dot *InstancePtr);
u32 XVec_dot_IsReady(XVec_dot *InstancePtr);
void XVec_dot_Continue(XVec_dot *InstancePtr);
void XVec_dot_EnableAutoRestart(XVec_dot *InstancePtr);
void XVec_dot_DisableAutoRestart(XVec_dot *InstancePtr);

u64 XVec_dot_Get_y(XVec_dot *InstancePtr);
u32 XVec_dot_Get_y_vld(XVec_dot *InstancePtr);
u32 XVec_dot_Get_a_BaseAddress(XVec_dot *InstancePtr);
u32 XVec_dot_Get_a_HighAddress(XVec_dot *InstancePtr);
u32 XVec_dot_Get_a_TotalBytes(XVec_dot *InstancePtr);
u32 XVec_dot_Get_a_BitWidth(XVec_dot *InstancePtr);
u32 XVec_dot_Get_a_Depth(XVec_dot *InstancePtr);
u32 XVec_dot_Write_a_Words(XVec_dot *InstancePtr, int offset, word_type *data, int length);
u32 XVec_dot_Read_a_Words(XVec_dot *InstancePtr, int offset, word_type *data, int length);
u32 XVec_dot_Write_a_Bytes(XVec_dot *InstancePtr, int offset, char *data, int length);
u32 XVec_dot_Read_a_Bytes(XVec_dot *InstancePtr, int offset, char *data, int length);
u32 XVec_dot_Get_b_BaseAddress(XVec_dot *InstancePtr);
u32 XVec_dot_Get_b_HighAddress(XVec_dot *InstancePtr);
u32 XVec_dot_Get_b_TotalBytes(XVec_dot *InstancePtr);
u32 XVec_dot_Get_b_BitWidth(XVec_dot *InstancePtr);
u32 XVec_dot_Get_b_Depth(XVec_dot *InstancePtr);
u32 XVec_dot_Write_b_Words(XVec_dot *InstancePtr, int offset, word_type *data, int length);
u32 XVec_dot_Read_b_Words(XVec_dot *InstancePtr, int offset, word_type *data, int length);
u32 XVec_dot_Write_b_Bytes(XVec_dot *InstancePtr, int offset, char *data, int length);
u32 XVec_dot_Read_b_Bytes(XVec_dot *InstancePtr, int offset, char *data, int length);

void XVec_dot_InterruptGlobalEnable(XVec_dot *InstancePtr);
void XVec_dot_InterruptGlobalDisable(XVec_dot *InstancePtr);
void XVec_dot_InterruptEnable(XVec_dot *InstancePtr, u32 Mask);
void XVec_dot_InterruptDisable(XVec_dot *InstancePtr, u32 Mask);
void XVec_dot_InterruptClear(XVec_dot *InstancePtr, u32 Mask);
u32 XVec_dot_InterruptGetEnabled(XVec_dot *InstancePtr);
u32 XVec_dot_InterruptGetStatus(XVec_dot *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
