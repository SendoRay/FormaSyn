// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XOFDM_BASE_H
#define XOFDM_BASE_H

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
#include "xofdm_base_hw.h"

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
} XOfdm_base_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XOfdm_base;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XOfdm_base_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XOfdm_base_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XOfdm_base_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XOfdm_base_ReadReg(BaseAddress, RegOffset) \
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
int XOfdm_base_Initialize(XOfdm_base *InstancePtr, UINTPTR BaseAddress);
XOfdm_base_Config* XOfdm_base_LookupConfig(UINTPTR BaseAddress);
#else
int XOfdm_base_Initialize(XOfdm_base *InstancePtr, u16 DeviceId);
XOfdm_base_Config* XOfdm_base_LookupConfig(u16 DeviceId);
#endif
int XOfdm_base_CfgInitialize(XOfdm_base *InstancePtr, XOfdm_base_Config *ConfigPtr);
#else
int XOfdm_base_Initialize(XOfdm_base *InstancePtr, const char* InstanceName);
int XOfdm_base_Release(XOfdm_base *InstancePtr);
#endif

void XOfdm_base_Start(XOfdm_base *InstancePtr);
u32 XOfdm_base_IsDone(XOfdm_base *InstancePtr);
u32 XOfdm_base_IsIdle(XOfdm_base *InstancePtr);
u32 XOfdm_base_IsReady(XOfdm_base *InstancePtr);
void XOfdm_base_Continue(XOfdm_base *InstancePtr);
void XOfdm_base_EnableAutoRestart(XOfdm_base *InstancePtr);
void XOfdm_base_DisableAutoRestart(XOfdm_base *InstancePtr);

u32 XOfdm_base_Get_in_r_BaseAddress(XOfdm_base *InstancePtr);
u32 XOfdm_base_Get_in_r_HighAddress(XOfdm_base *InstancePtr);
u32 XOfdm_base_Get_in_r_TotalBytes(XOfdm_base *InstancePtr);
u32 XOfdm_base_Get_in_r_BitWidth(XOfdm_base *InstancePtr);
u32 XOfdm_base_Get_in_r_Depth(XOfdm_base *InstancePtr);
u32 XOfdm_base_Write_in_r_Words(XOfdm_base *InstancePtr, int offset, word_type *data, int length);
u32 XOfdm_base_Read_in_r_Words(XOfdm_base *InstancePtr, int offset, word_type *data, int length);
u32 XOfdm_base_Write_in_r_Bytes(XOfdm_base *InstancePtr, int offset, char *data, int length);
u32 XOfdm_base_Read_in_r_Bytes(XOfdm_base *InstancePtr, int offset, char *data, int length);
u32 XOfdm_base_Get_out_r_BaseAddress(XOfdm_base *InstancePtr);
u32 XOfdm_base_Get_out_r_HighAddress(XOfdm_base *InstancePtr);
u32 XOfdm_base_Get_out_r_TotalBytes(XOfdm_base *InstancePtr);
u32 XOfdm_base_Get_out_r_BitWidth(XOfdm_base *InstancePtr);
u32 XOfdm_base_Get_out_r_Depth(XOfdm_base *InstancePtr);
u32 XOfdm_base_Write_out_r_Words(XOfdm_base *InstancePtr, int offset, word_type *data, int length);
u32 XOfdm_base_Read_out_r_Words(XOfdm_base *InstancePtr, int offset, word_type *data, int length);
u32 XOfdm_base_Write_out_r_Bytes(XOfdm_base *InstancePtr, int offset, char *data, int length);
u32 XOfdm_base_Read_out_r_Bytes(XOfdm_base *InstancePtr, int offset, char *data, int length);

void XOfdm_base_InterruptGlobalEnable(XOfdm_base *InstancePtr);
void XOfdm_base_InterruptGlobalDisable(XOfdm_base *InstancePtr);
void XOfdm_base_InterruptEnable(XOfdm_base *InstancePtr, u32 Mask);
void XOfdm_base_InterruptDisable(XOfdm_base *InstancePtr, u32 Mask);
void XOfdm_base_InterruptClear(XOfdm_base *InstancePtr, u32 Mask);
u32 XOfdm_base_InterruptGetEnabled(XOfdm_base *InstancePtr);
u32 XOfdm_base_InterruptGetStatus(XOfdm_base *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
