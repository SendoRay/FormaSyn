// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XVEC_MUL_H
#define XVEC_MUL_H

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
#include "xvec_mul_hw.h"

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
} XVec_mul_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XVec_mul;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XVec_mul_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XVec_mul_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XVec_mul_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XVec_mul_ReadReg(BaseAddress, RegOffset) \
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
int XVec_mul_Initialize(XVec_mul *InstancePtr, UINTPTR BaseAddress);
XVec_mul_Config* XVec_mul_LookupConfig(UINTPTR BaseAddress);
#else
int XVec_mul_Initialize(XVec_mul *InstancePtr, u16 DeviceId);
XVec_mul_Config* XVec_mul_LookupConfig(u16 DeviceId);
#endif
int XVec_mul_CfgInitialize(XVec_mul *InstancePtr, XVec_mul_Config *ConfigPtr);
#else
int XVec_mul_Initialize(XVec_mul *InstancePtr, const char* InstanceName);
int XVec_mul_Release(XVec_mul *InstancePtr);
#endif

void XVec_mul_Start(XVec_mul *InstancePtr);
u32 XVec_mul_IsDone(XVec_mul *InstancePtr);
u32 XVec_mul_IsIdle(XVec_mul *InstancePtr);
u32 XVec_mul_IsReady(XVec_mul *InstancePtr);
void XVec_mul_Continue(XVec_mul *InstancePtr);
void XVec_mul_EnableAutoRestart(XVec_mul *InstancePtr);
void XVec_mul_DisableAutoRestart(XVec_mul *InstancePtr);

u32 XVec_mul_Get_a_BaseAddress(XVec_mul *InstancePtr);
u32 XVec_mul_Get_a_HighAddress(XVec_mul *InstancePtr);
u32 XVec_mul_Get_a_TotalBytes(XVec_mul *InstancePtr);
u32 XVec_mul_Get_a_BitWidth(XVec_mul *InstancePtr);
u32 XVec_mul_Get_a_Depth(XVec_mul *InstancePtr);
u32 XVec_mul_Write_a_Words(XVec_mul *InstancePtr, int offset, word_type *data, int length);
u32 XVec_mul_Read_a_Words(XVec_mul *InstancePtr, int offset, word_type *data, int length);
u32 XVec_mul_Write_a_Bytes(XVec_mul *InstancePtr, int offset, char *data, int length);
u32 XVec_mul_Read_a_Bytes(XVec_mul *InstancePtr, int offset, char *data, int length);
u32 XVec_mul_Get_b_BaseAddress(XVec_mul *InstancePtr);
u32 XVec_mul_Get_b_HighAddress(XVec_mul *InstancePtr);
u32 XVec_mul_Get_b_TotalBytes(XVec_mul *InstancePtr);
u32 XVec_mul_Get_b_BitWidth(XVec_mul *InstancePtr);
u32 XVec_mul_Get_b_Depth(XVec_mul *InstancePtr);
u32 XVec_mul_Write_b_Words(XVec_mul *InstancePtr, int offset, word_type *data, int length);
u32 XVec_mul_Read_b_Words(XVec_mul *InstancePtr, int offset, word_type *data, int length);
u32 XVec_mul_Write_b_Bytes(XVec_mul *InstancePtr, int offset, char *data, int length);
u32 XVec_mul_Read_b_Bytes(XVec_mul *InstancePtr, int offset, char *data, int length);
u32 XVec_mul_Get_y_BaseAddress(XVec_mul *InstancePtr);
u32 XVec_mul_Get_y_HighAddress(XVec_mul *InstancePtr);
u32 XVec_mul_Get_y_TotalBytes(XVec_mul *InstancePtr);
u32 XVec_mul_Get_y_BitWidth(XVec_mul *InstancePtr);
u32 XVec_mul_Get_y_Depth(XVec_mul *InstancePtr);
u32 XVec_mul_Write_y_Words(XVec_mul *InstancePtr, int offset, word_type *data, int length);
u32 XVec_mul_Read_y_Words(XVec_mul *InstancePtr, int offset, word_type *data, int length);
u32 XVec_mul_Write_y_Bytes(XVec_mul *InstancePtr, int offset, char *data, int length);
u32 XVec_mul_Read_y_Bytes(XVec_mul *InstancePtr, int offset, char *data, int length);

void XVec_mul_InterruptGlobalEnable(XVec_mul *InstancePtr);
void XVec_mul_InterruptGlobalDisable(XVec_mul *InstancePtr);
void XVec_mul_InterruptEnable(XVec_mul *InstancePtr, u32 Mask);
void XVec_mul_InterruptDisable(XVec_mul *InstancePtr, u32 Mask);
void XVec_mul_InterruptClear(XVec_mul *InstancePtr, u32 Mask);
u32 XVec_mul_InterruptGetEnabled(XVec_mul *InstancePtr);
u32 XVec_mul_InterruptGetStatus(XVec_mul *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
