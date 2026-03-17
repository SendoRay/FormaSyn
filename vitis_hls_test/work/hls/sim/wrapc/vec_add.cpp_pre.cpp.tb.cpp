// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
# 1 "/home/chengzhy/vitis_hls_test/vec_add.cpp"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 401 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "/home/chengzhy/vitis_hls_test/vec_add.cpp" 2
void vec_add(const int a[16], const int b[16], int c[16]) {
#pragma HLS PIPELINE II=1
        for (int i = 0; i < 16; i++) {
            c[i] = a[i] + b[i];
        }
    }
#ifndef HLS_FASTSIM
#ifdef __cplusplus
extern "C"
#endif
void apatb_vec_add_ir(const int *, const int *, int *);
#ifdef __cplusplus
extern "C"
#endif
void vec_add_hw_stub(const int *a, const int *b, int *c){
vec_add(a, b, c);
return ;
}
#ifdef __cplusplus
extern "C"
#endif
void refine_signal_handler();
#ifdef __cplusplus
extern "C"
#endif
void apatb_vec_add_sw(const int *a, const int *b, int *c){
refine_signal_handler();
apatb_vec_add_ir(a, b, c);
return ;
}
#endif
# 6 "/home/chengzhy/vitis_hls_test/vec_add.cpp"

