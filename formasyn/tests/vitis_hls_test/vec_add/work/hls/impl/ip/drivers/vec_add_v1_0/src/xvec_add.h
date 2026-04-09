// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XVEC_ADD_H
#define XVEC_ADD_H

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
#include "xvec_add_hw.h"

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
} XVec_add_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XVec_add;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XVec_add_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XVec_add_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XVec_add_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XVec_add_ReadReg(BaseAddress, RegOffset) \
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
int XVec_add_Initialize(XVec_add *InstancePtr, UINTPTR BaseAddress);
XVec_add_Config* XVec_add_LookupConfig(UINTPTR BaseAddress);
#else
int XVec_add_Initialize(XVec_add *InstancePtr, u16 DeviceId);
XVec_add_Config* XVec_add_LookupConfig(u16 DeviceId);
#endif
int XVec_add_CfgInitialize(XVec_add *InstancePtr, XVec_add_Config *ConfigPtr);
#else
int XVec_add_Initialize(XVec_add *InstancePtr, const char* InstanceName);
int XVec_add_Release(XVec_add *InstancePtr);
#endif

void XVec_add_Start(XVec_add *InstancePtr);
u32 XVec_add_IsDone(XVec_add *InstancePtr);
u32 XVec_add_IsIdle(XVec_add *InstancePtr);
u32 XVec_add_IsReady(XVec_add *InstancePtr);
void XVec_add_Continue(XVec_add *InstancePtr);
void XVec_add_EnableAutoRestart(XVec_add *InstancePtr);
void XVec_add_DisableAutoRestart(XVec_add *InstancePtr);

u32 XVec_add_Get_a_BaseAddress(XVec_add *InstancePtr);
u32 XVec_add_Get_a_HighAddress(XVec_add *InstancePtr);
u32 XVec_add_Get_a_TotalBytes(XVec_add *InstancePtr);
u32 XVec_add_Get_a_BitWidth(XVec_add *InstancePtr);
u32 XVec_add_Get_a_Depth(XVec_add *InstancePtr);
u32 XVec_add_Write_a_Words(XVec_add *InstancePtr, int offset, word_type *data, int length);
u32 XVec_add_Read_a_Words(XVec_add *InstancePtr, int offset, word_type *data, int length);
u32 XVec_add_Write_a_Bytes(XVec_add *InstancePtr, int offset, char *data, int length);
u32 XVec_add_Read_a_Bytes(XVec_add *InstancePtr, int offset, char *data, int length);
u32 XVec_add_Get_b_BaseAddress(XVec_add *InstancePtr);
u32 XVec_add_Get_b_HighAddress(XVec_add *InstancePtr);
u32 XVec_add_Get_b_TotalBytes(XVec_add *InstancePtr);
u32 XVec_add_Get_b_BitWidth(XVec_add *InstancePtr);
u32 XVec_add_Get_b_Depth(XVec_add *InstancePtr);
u32 XVec_add_Write_b_Words(XVec_add *InstancePtr, int offset, word_type *data, int length);
u32 XVec_add_Read_b_Words(XVec_add *InstancePtr, int offset, word_type *data, int length);
u32 XVec_add_Write_b_Bytes(XVec_add *InstancePtr, int offset, char *data, int length);
u32 XVec_add_Read_b_Bytes(XVec_add *InstancePtr, int offset, char *data, int length);
u32 XVec_add_Get_y_BaseAddress(XVec_add *InstancePtr);
u32 XVec_add_Get_y_HighAddress(XVec_add *InstancePtr);
u32 XVec_add_Get_y_TotalBytes(XVec_add *InstancePtr);
u32 XVec_add_Get_y_BitWidth(XVec_add *InstancePtr);
u32 XVec_add_Get_y_Depth(XVec_add *InstancePtr);
u32 XVec_add_Write_y_Words(XVec_add *InstancePtr, int offset, word_type *data, int length);
u32 XVec_add_Read_y_Words(XVec_add *InstancePtr, int offset, word_type *data, int length);
u32 XVec_add_Write_y_Bytes(XVec_add *InstancePtr, int offset, char *data, int length);
u32 XVec_add_Read_y_Bytes(XVec_add *InstancePtr, int offset, char *data, int length);

void XVec_add_InterruptGlobalEnable(XVec_add *InstancePtr);
void XVec_add_InterruptGlobalDisable(XVec_add *InstancePtr);
void XVec_add_InterruptEnable(XVec_add *InstancePtr, u32 Mask);
void XVec_add_InterruptDisable(XVec_add *InstancePtr, u32 Mask);
void XVec_add_InterruptClear(XVec_add *InstancePtr, u32 Mask);
u32 XVec_add_InterruptGetEnabled(XVec_add *InstancePtr);
u32 XVec_add_InterruptGetStatus(XVec_add *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
