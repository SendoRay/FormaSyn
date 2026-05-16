; ModuleID = '/home/chengzhy/FormaSyn/examples/vec_add/inter_files/balanced_int16_p8/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_int<8>" = type { %"struct.ap_int_base<8, true>" }
%"struct.ap_int_base<8, true>" = type { %"struct.ssdm_int<8, true>" }
%"struct.ssdm_int<8, true>" = type { i8 }
%"struct.ap_int<16>" = type { %"struct.ap_int_base<16, true>" }
%"struct.ap_int_base<16, true>" = type { %"struct.ssdm_int<16, true>" }
%"struct.ssdm_int<16, true>" = type { i16 }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_kernel_ir(%"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" "partition" %a, %"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" "partition" %b, %"struct.ap_int<16>"* noalias nocapture nonnull "fpga.decayed.dim.hint"="16" "maxi" "partition" %c) local_unnamed_addr #1 {
entry:
  %0 = bitcast %"struct.ap_int<8>"* %a to [16 x %"struct.ap_int<8>"]*
  %a_copy_0 = alloca [2 x i8], align 512
  %a_copy_1 = alloca [2 x i8], align 512
  %a_copy_2 = alloca [2 x i8], align 512
  %a_copy_3 = alloca [2 x i8], align 512
  %a_copy_4 = alloca [2 x i8], align 512
  %a_copy_5 = alloca [2 x i8], align 512
  %a_copy_6 = alloca [2 x i8], align 512
  %a_copy_7 = alloca [2 x i8], align 512
  %_0 = getelementptr [2 x i8], [2 x i8]* %a_copy_0, i64 0, i64 0
  %_1 = getelementptr [2 x i8], [2 x i8]* %a_copy_1, i64 0, i64 0
  %_2 = getelementptr [2 x i8], [2 x i8]* %a_copy_2, i64 0, i64 0
  %_3 = getelementptr [2 x i8], [2 x i8]* %a_copy_3, i64 0, i64 0
  %_4 = getelementptr [2 x i8], [2 x i8]* %a_copy_4, i64 0, i64 0
  %_5 = getelementptr [2 x i8], [2 x i8]* %a_copy_5, i64 0, i64 0
  %_6 = getelementptr [2 x i8], [2 x i8]* %a_copy_6, i64 0, i64 0
  %_7 = getelementptr [2 x i8], [2 x i8]* %a_copy_7, i64 0, i64 0
  %1 = bitcast %"struct.ap_int<8>"* %b to [16 x %"struct.ap_int<8>"]*
  %b_copy_0 = alloca [2 x i8], align 512
  %b_copy_1 = alloca [2 x i8], align 512
  %b_copy_2 = alloca [2 x i8], align 512
  %b_copy_3 = alloca [2 x i8], align 512
  %b_copy_4 = alloca [2 x i8], align 512
  %b_copy_5 = alloca [2 x i8], align 512
  %b_copy_6 = alloca [2 x i8], align 512
  %b_copy_7 = alloca [2 x i8], align 512
  %_04 = getelementptr [2 x i8], [2 x i8]* %b_copy_0, i64 0, i64 0
  %_15 = getelementptr [2 x i8], [2 x i8]* %b_copy_1, i64 0, i64 0
  %_26 = getelementptr [2 x i8], [2 x i8]* %b_copy_2, i64 0, i64 0
  %_37 = getelementptr [2 x i8], [2 x i8]* %b_copy_3, i64 0, i64 0
  %_48 = getelementptr [2 x i8], [2 x i8]* %b_copy_4, i64 0, i64 0
  %_59 = getelementptr [2 x i8], [2 x i8]* %b_copy_5, i64 0, i64 0
  %_610 = getelementptr [2 x i8], [2 x i8]* %b_copy_6, i64 0, i64 0
  %_711 = getelementptr [2 x i8], [2 x i8]* %b_copy_7, i64 0, i64 0
  %2 = bitcast %"struct.ap_int<16>"* %c to [16 x %"struct.ap_int<16>"]*
  %c_copy_0 = alloca [2 x i16], align 512
  %c_copy_1 = alloca [2 x i16], align 512
  %c_copy_2 = alloca [2 x i16], align 512
  %c_copy_3 = alloca [2 x i16], align 512
  %c_copy_4 = alloca [2 x i16], align 512
  %c_copy_5 = alloca [2 x i16], align 512
  %c_copy_6 = alloca [2 x i16], align 512
  %c_copy_7 = alloca [2 x i16], align 512
  %_012 = getelementptr [2 x i16], [2 x i16]* %c_copy_0, i64 0, i64 0
  %_113 = getelementptr [2 x i16], [2 x i16]* %c_copy_1, i64 0, i64 0
  %_214 = getelementptr [2 x i16], [2 x i16]* %c_copy_2, i64 0, i64 0
  %_315 = getelementptr [2 x i16], [2 x i16]* %c_copy_3, i64 0, i64 0
  %_416 = getelementptr [2 x i16], [2 x i16]* %c_copy_4, i64 0, i64 0
  %_517 = getelementptr [2 x i16], [2 x i16]* %c_copy_5, i64 0, i64 0
  %_618 = getelementptr [2 x i16], [2 x i16]* %c_copy_6, i64 0, i64 0
  %_719 = getelementptr [2 x i16], [2 x i16]* %c_copy_7, i64 0, i64 0
  call void @copy_in([16 x %"struct.ap_int<8>"]* nonnull %0, [2 x i8]* nonnull align 512 %a_copy_0, [2 x i8]* nonnull align 512 %a_copy_1, [2 x i8]* nonnull align 512 %a_copy_2, [2 x i8]* nonnull align 512 %a_copy_3, [2 x i8]* nonnull align 512 %a_copy_4, [2 x i8]* nonnull align 512 %a_copy_5, [2 x i8]* nonnull align 512 %a_copy_6, [2 x i8]* nonnull align 512 %a_copy_7, [16 x %"struct.ap_int<8>"]* nonnull %1, [2 x i8]* nonnull align 512 %b_copy_0, [2 x i8]* nonnull align 512 %b_copy_1, [2 x i8]* nonnull align 512 %b_copy_2, [2 x i8]* nonnull align 512 %b_copy_3, [2 x i8]* nonnull align 512 %b_copy_4, [2 x i8]* nonnull align 512 %b_copy_5, [2 x i8]* nonnull align 512 %b_copy_6, [2 x i8]* nonnull align 512 %b_copy_7, [16 x %"struct.ap_int<16>"]* nonnull %2, [2 x i16]* nonnull align 512 %c_copy_0, [2 x i16]* nonnull align 512 %c_copy_1, [2 x i16]* nonnull align 512 %c_copy_2, [2 x i16]* nonnull align 512 %c_copy_3, [2 x i16]* nonnull align 512 %c_copy_4, [2 x i16]* nonnull align 512 %c_copy_5, [2 x i16]* nonnull align 512 %c_copy_6, [2 x i16]* nonnull align 512 %c_copy_7)
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_0, i32 999, i32 1, i32 1, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_1, i32 999, i32 1, i32 1, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_2, i32 999, i32 1, i32 1, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_3, i32 999, i32 1, i32 1, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_4, i32 999, i32 1, i32 1, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_5, i32 999, i32 1, i32 1, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_6, i32 999, i32 1, i32 1, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_7, i32 999, i32 1, i32 1, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_0, i32 998, i32 1, i32 0, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_1, i32 998, i32 1, i32 0, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_2, i32 998, i32 1, i32 0, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_3, i32 998, i32 1, i32 0, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_4, i32 998, i32 1, i32 0, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_5, i32 998, i32 1, i32 0, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_6, i32 998, i32 1, i32 0, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_7, i32 998, i32 1, i32 0, i1 false) ], !dbg !43
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_04, i32 999, i32 1, i32 1, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_15, i32 999, i32 1, i32 1, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_26, i32 999, i32 1, i32 1, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_37, i32 999, i32 1, i32 1, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_48, i32 999, i32 1, i32 1, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_59, i32 999, i32 1, i32 1, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_610, i32 999, i32 1, i32 1, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_711, i32 999, i32 1, i32 1, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_04, i32 998, i32 1, i32 0, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_15, i32 998, i32 1, i32 0, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_26, i32 998, i32 1, i32 0, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_37, i32 998, i32 1, i32 0, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_48, i32 998, i32 1, i32 0, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_59, i32 998, i32 1, i32 0, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_610, i32 998, i32 1, i32 0, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_711, i32 998, i32 1, i32 0, i1 false) ], !dbg !186
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_012, i32 999, i32 1, i32 1, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_113, i32 999, i32 1, i32 1, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_214, i32 999, i32 1, i32 1, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_315, i32 999, i32 1, i32 1, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_416, i32 999, i32 1, i32 1, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_517, i32 999, i32 1, i32 1, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_618, i32 999, i32 1, i32 1, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_719, i32 999, i32 1, i32 1, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_012, i32 998, i32 1, i32 0, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_113, i32 998, i32 1, i32 0, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_214, i32 998, i32 1, i32 0, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_315, i32 998, i32 1, i32 0, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_416, i32 998, i32 1, i32 0, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_517, i32 998, i32 1, i32 0, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_618, i32 998, i32 1, i32 0, i1 false) ], !dbg !187
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_719, i32 998, i32 1, i32 0, i1 false) ], !dbg !187
  call void @apatb_kernel_hw([2 x i8]* %a_copy_0, [2 x i8]* %a_copy_1, [2 x i8]* %a_copy_2, [2 x i8]* %a_copy_3, [2 x i8]* %a_copy_4, [2 x i8]* %a_copy_5, [2 x i8]* %a_copy_6, [2 x i8]* %a_copy_7, [2 x i8]* %b_copy_0, [2 x i8]* %b_copy_1, [2 x i8]* %b_copy_2, [2 x i8]* %b_copy_3, [2 x i8]* %b_copy_4, [2 x i8]* %b_copy_5, [2 x i8]* %b_copy_6, [2 x i8]* %b_copy_7, [2 x i16]* %c_copy_0, [2 x i16]* %c_copy_1, [2 x i16]* %c_copy_2, [2 x i16]* %c_copy_3, [2 x i16]* %c_copy_4, [2 x i16]* %c_copy_5, [2 x i16]* %c_copy_6, [2 x i16]* %c_copy_7)
  call void @copy_back([16 x %"struct.ap_int<8>"]* %0, [2 x i8]* %a_copy_0, [2 x i8]* %a_copy_1, [2 x i8]* %a_copy_2, [2 x i8]* %a_copy_3, [2 x i8]* %a_copy_4, [2 x i8]* %a_copy_5, [2 x i8]* %a_copy_6, [2 x i8]* %a_copy_7, [16 x %"struct.ap_int<8>"]* %1, [2 x i8]* %b_copy_0, [2 x i8]* %b_copy_1, [2 x i8]* %b_copy_2, [2 x i8]* %b_copy_3, [2 x i8]* %b_copy_4, [2 x i8]* %b_copy_5, [2 x i8]* %b_copy_6, [2 x i8]* %b_copy_7, [16 x %"struct.ap_int<16>"]* %2, [2 x i16]* %c_copy_0, [2 x i16]* %c_copy_1, [2 x i16]* %c_copy_2, [2 x i16]* %c_copy_3, [2 x i16]* %c_copy_4, [2 x i16]* %c_copy_5, [2 x i16]* %c_copy_6, [2 x i16]* %c_copy_7)
  ret void
}

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #2

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>.18"([2 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [2 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [2 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [2 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [2 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.4" %dst_4, [2 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.5" %dst_5, [2 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.6" %dst_6, [2 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.7" %dst_7, [16 x %"struct.ap_int<8>"]* readonly "orig.arg.no"="1" "unpacked"="1" %src, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %1 = udiv i64 %for.loop.idx2, 8
  %2 = urem i64 %for.loop.idx2, 8
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [2 x i8], [2 x i8]* %dst_0, i64 0, i64 %1
  %dst.addr.0.0.06_1 = getelementptr [2 x i8], [2 x i8]* %dst_1, i64 0, i64 %1
  %dst.addr.0.0.06_2 = getelementptr [2 x i8], [2 x i8]* %dst_2, i64 0, i64 %1
  %dst.addr.0.0.06_3 = getelementptr [2 x i8], [2 x i8]* %dst_3, i64 0, i64 %1
  %dst.addr.0.0.06_4 = getelementptr [2 x i8], [2 x i8]* %dst_4, i64 0, i64 %1
  %dst.addr.0.0.06_5 = getelementptr [2 x i8], [2 x i8]* %dst_5, i64 0, i64 %1
  %dst.addr.0.0.06_6 = getelementptr [2 x i8], [2 x i8]* %dst_6, i64 0, i64 %1
  %dst.addr.0.0.06_7 = getelementptr [2 x i8], [2 x i8]* %dst_7, i64 0, i64 %1
  %3 = load i8, i8* %src.addr.0.0.05, align 1
  switch i64 %2, label %dst.addr.0.0.06.case.7 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
    i64 3, label %dst.addr.0.0.06.case.3
    i64 4, label %dst.addr.0.0.06.case.4
    i64 5, label %dst.addr.0.0.06.case.5
    i64 6, label %dst.addr.0.0.06.case.6
  ]

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i8 %3, i8* %dst.addr.0.0.06_0, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  store i8 %3, i8* %dst.addr.0.0.06_1, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.2:                           ; preds = %for.loop
  store i8 %3, i8* %dst.addr.0.0.06_2, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.3:                           ; preds = %for.loop
  store i8 %3, i8* %dst.addr.0.0.06_3, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.4:                           ; preds = %for.loop
  store i8 %3, i8* %dst.addr.0.0.06_4, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.5:                           ; preds = %for.loop
  store i8 %3, i8* %dst.addr.0.0.06_5, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.6:                           ; preds = %for.loop
  store i8 %3, i8* %dst.addr.0.0.06_6, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.7:                           ; preds = %for.loop
  %4 = icmp eq i64 %2, 7
  call void @llvm.assume(i1 %4)
  store i8 %3, i8* %dst.addr.0.0.06_7, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.7, %dst.addr.0.0.06.case.6, %dst.addr.0.0.06.case.5, %dst.addr.0.0.06.case.4, %dst.addr.0.0.06.case.3, %dst.addr.0.0.06.case.2, %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([2 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.4" %dst_4, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.5" %dst_5, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.6" %dst_6, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.7" %dst_7, [16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="1" "unpacked"="1" %src) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<8>.18"([2 x i8]* %dst_0, [2 x i8]* %dst_1, [2 x i8]* %dst_2, [2 x i8]* %dst_3, [2 x i8]* %dst_4, [2 x i8]* %dst_5, [2 x i8]* %dst_6, [2 x i8]* %dst_7, [16 x %"struct.ap_int<8>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<16>"([2 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [2 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [2 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [2 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [2 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.4" %dst_4, [2 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.5" %dst_5, [2 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.6" %dst_6, [2 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.7" %dst_7, [16 x %"struct.ap_int<16>"]* readonly "orig.arg.no"="1" "unpacked"="1" %src, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<16>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %1 = udiv i64 %for.loop.idx2, 8
  %2 = urem i64 %for.loop.idx2, 8
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<16>"], [16 x %"struct.ap_int<16>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [2 x i16], [2 x i16]* %dst_0, i64 0, i64 %1
  %dst.addr.0.0.06_1 = getelementptr [2 x i16], [2 x i16]* %dst_1, i64 0, i64 %1
  %dst.addr.0.0.06_2 = getelementptr [2 x i16], [2 x i16]* %dst_2, i64 0, i64 %1
  %dst.addr.0.0.06_3 = getelementptr [2 x i16], [2 x i16]* %dst_3, i64 0, i64 %1
  %dst.addr.0.0.06_4 = getelementptr [2 x i16], [2 x i16]* %dst_4, i64 0, i64 %1
  %dst.addr.0.0.06_5 = getelementptr [2 x i16], [2 x i16]* %dst_5, i64 0, i64 %1
  %dst.addr.0.0.06_6 = getelementptr [2 x i16], [2 x i16]* %dst_6, i64 0, i64 %1
  %dst.addr.0.0.06_7 = getelementptr [2 x i16], [2 x i16]* %dst_7, i64 0, i64 %1
  %3 = load i16, i16* %src.addr.0.0.05, align 2
  switch i64 %2, label %dst.addr.0.0.06.case.7 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
    i64 3, label %dst.addr.0.0.06.case.3
    i64 4, label %dst.addr.0.0.06.case.4
    i64 5, label %dst.addr.0.0.06.case.5
    i64 6, label %dst.addr.0.0.06.case.6
  ]

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i16 %3, i16* %dst.addr.0.0.06_0, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  store i16 %3, i16* %dst.addr.0.0.06_1, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.2:                           ; preds = %for.loop
  store i16 %3, i16* %dst.addr.0.0.06_2, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.3:                           ; preds = %for.loop
  store i16 %3, i16* %dst.addr.0.0.06_3, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.4:                           ; preds = %for.loop
  store i16 %3, i16* %dst.addr.0.0.06_4, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.5:                           ; preds = %for.loop
  store i16 %3, i16* %dst.addr.0.0.06_5, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.6:                           ; preds = %for.loop
  store i16 %3, i16* %dst.addr.0.0.06_6, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.7:                           ; preds = %for.loop
  %4 = icmp eq i64 %2, 7
  call void @llvm.assume(i1 %4)
  store i16 %3, i16* %dst.addr.0.0.06_7, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.7, %dst.addr.0.0.06.case.6, %dst.addr.0.0.06.case.5, %dst.addr.0.0.06.case.4, %dst.addr.0.0.06.case.3, %dst.addr.0.0.06.case.2, %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<16>"([2 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.4" %dst_4, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.5" %dst_5, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.6" %dst_6, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.7" %dst_7, [16 x %"struct.ap_int<16>"]* noalias readonly "orig.arg.no"="1" "unpacked"="1" %src) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<16>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<16>"([2 x i16]* %dst_0, [2 x i16]* %dst_1, [2 x i16]* %dst_2, [2 x i16]* %dst_3, [2 x i16]* %dst_4, [2 x i16]* %dst_5, [2 x i16]* %dst_6, [2 x i16]* %dst_7, [16 x %"struct.ap_int<16>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_in([16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="0" "unpacked"="0", [2 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.4" %_4, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.5" %_5, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.6" %_6, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.7" %_7, [16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="2" "unpacked"="2", [2 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.4" %_45, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.5" %_56, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.6" %_67, [2 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.7" %_78, [16 x %"struct.ap_int<16>"]* noalias readonly "orig.arg.no"="4" "unpacked"="4", [2 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_09, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_110, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_211, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_312, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.4" %_413, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.5" %_514, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.6" %_615, [2 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.7" %_716) #5 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([2 x i8]* align 512 %_0, [2 x i8]* align 512 %_1, [2 x i8]* align 512 %_2, [2 x i8]* align 512 %_3, [2 x i8]* align 512 %_4, [2 x i8]* align 512 %_5, [2 x i8]* align 512 %_6, [2 x i8]* align 512 %_7, [16 x %"struct.ap_int<8>"]* %0)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([2 x i8]* align 512 %_01, [2 x i8]* align 512 %_12, [2 x i8]* align 512 %_23, [2 x i8]* align 512 %_34, [2 x i8]* align 512 %_45, [2 x i8]* align 512 %_56, [2 x i8]* align 512 %_67, [2 x i8]* align 512 %_78, [16 x %"struct.ap_int<8>"]* %1)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<16>"([2 x i16]* align 512 %_09, [2 x i16]* align 512 %_110, [2 x i16]* align 512 %_211, [2 x i16]* align 512 %_312, [2 x i16]* align 512 %_413, [2 x i16]* align 512 %_514, [2 x i16]* align 512 %_615, [2 x i16]* align 512 %_716, [16 x %"struct.ap_int<16>"]* %2)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>.25"([16 x %"struct.ap_int<8>"]* "orig.arg.no"="0" "unpacked"="0" %dst, [2 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [2 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [2 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [2 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.3" %src_3, [2 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.4" %src_4, [2 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.5" %src_5, [2 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.6" %src_6, [2 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.7" %src_7, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %1 = udiv i64 %for.loop.idx2, 8
  %2 = urem i64 %for.loop.idx2, 8
  %src.addr.0.0.05_0 = getelementptr [2 x i8], [2 x i8]* %src_0, i64 0, i64 %1
  %src.addr.0.0.05_1 = getelementptr [2 x i8], [2 x i8]* %src_1, i64 0, i64 %1
  %src.addr.0.0.05_2 = getelementptr [2 x i8], [2 x i8]* %src_2, i64 0, i64 %1
  %src.addr.0.0.05_3 = getelementptr [2 x i8], [2 x i8]* %src_3, i64 0, i64 %1
  %src.addr.0.0.05_4 = getelementptr [2 x i8], [2 x i8]* %src_4, i64 0, i64 %1
  %src.addr.0.0.05_5 = getelementptr [2 x i8], [2 x i8]* %src_5, i64 0, i64 %1
  %src.addr.0.0.05_6 = getelementptr [2 x i8], [2 x i8]* %src_6, i64 0, i64 %1
  %src.addr.0.0.05_7 = getelementptr [2 x i8], [2 x i8]* %src_7, i64 0, i64 %1
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %2, label %src.addr.0.0.05.case.7 [
    i64 0, label %src.addr.0.0.05.case.0
    i64 1, label %src.addr.0.0.05.case.1
    i64 2, label %src.addr.0.0.05.case.2
    i64 3, label %src.addr.0.0.05.case.3
    i64 4, label %src.addr.0.0.05.case.4
    i64 5, label %src.addr.0.0.05.case.5
    i64 6, label %src.addr.0.0.05.case.6
  ]

src.addr.0.0.05.case.0:                           ; preds = %for.loop
  %_0 = load i8, i8* %src.addr.0.0.05_0, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.1:                           ; preds = %for.loop
  %_1 = load i8, i8* %src.addr.0.0.05_1, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.2:                           ; preds = %for.loop
  %_2 = load i8, i8* %src.addr.0.0.05_2, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.3:                           ; preds = %for.loop
  %_3 = load i8, i8* %src.addr.0.0.05_3, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.4:                           ; preds = %for.loop
  %_4 = load i8, i8* %src.addr.0.0.05_4, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.5:                           ; preds = %for.loop
  %_5 = load i8, i8* %src.addr.0.0.05_5, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.6:                           ; preds = %for.loop
  %_6 = load i8, i8* %src.addr.0.0.05_6, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.7:                           ; preds = %for.loop
  %3 = icmp eq i64 %2, 7
  call void @llvm.assume(i1 %3)
  %_7 = load i8, i8* %src.addr.0.0.05_7, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.7, %src.addr.0.0.05.case.6, %src.addr.0.0.05.case.5, %src.addr.0.0.05.case.4, %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %4 = phi i8 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ], [ %_2, %src.addr.0.0.05.case.2 ], [ %_3, %src.addr.0.0.05.case.3 ], [ %_4, %src.addr.0.0.05.case.4 ], [ %_5, %src.addr.0.0.05.case.5 ], [ %_6, %src.addr.0.0.05.case.6 ], [ %_7, %src.addr.0.0.05.case.7 ]
  store i8 %4, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0" %dst, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %src_3, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.4" %src_4, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.5" %src_5, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.6" %src_6, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.7" %src_7) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<8>.25"([16 x %"struct.ap_int<8>"]* nonnull %dst, [2 x i8]* %src_0, [2 x i8]* %src_1, [2 x i8]* %src_2, [2 x i8]* %src_3, [2 x i8]* %src_4, [2 x i8]* %src_5, [2 x i8]* %src_6, [2 x i8]* %src_7, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<16>.8"([16 x %"struct.ap_int<16>"]* "orig.arg.no"="0" "unpacked"="0" %dst, [2 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [2 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [2 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [2 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.3" %src_3, [2 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.4" %src_4, [2 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.5" %src_5, [2 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.6" %src_6, [2 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.7" %src_7, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<16>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %1 = udiv i64 %for.loop.idx2, 8
  %2 = urem i64 %for.loop.idx2, 8
  %src.addr.0.0.05_0 = getelementptr [2 x i16], [2 x i16]* %src_0, i64 0, i64 %1
  %src.addr.0.0.05_1 = getelementptr [2 x i16], [2 x i16]* %src_1, i64 0, i64 %1
  %src.addr.0.0.05_2 = getelementptr [2 x i16], [2 x i16]* %src_2, i64 0, i64 %1
  %src.addr.0.0.05_3 = getelementptr [2 x i16], [2 x i16]* %src_3, i64 0, i64 %1
  %src.addr.0.0.05_4 = getelementptr [2 x i16], [2 x i16]* %src_4, i64 0, i64 %1
  %src.addr.0.0.05_5 = getelementptr [2 x i16], [2 x i16]* %src_5, i64 0, i64 %1
  %src.addr.0.0.05_6 = getelementptr [2 x i16], [2 x i16]* %src_6, i64 0, i64 %1
  %src.addr.0.0.05_7 = getelementptr [2 x i16], [2 x i16]* %src_7, i64 0, i64 %1
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<16>"], [16 x %"struct.ap_int<16>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %2, label %src.addr.0.0.05.case.7 [
    i64 0, label %src.addr.0.0.05.case.0
    i64 1, label %src.addr.0.0.05.case.1
    i64 2, label %src.addr.0.0.05.case.2
    i64 3, label %src.addr.0.0.05.case.3
    i64 4, label %src.addr.0.0.05.case.4
    i64 5, label %src.addr.0.0.05.case.5
    i64 6, label %src.addr.0.0.05.case.6
  ]

src.addr.0.0.05.case.0:                           ; preds = %for.loop
  %_0 = load i16, i16* %src.addr.0.0.05_0, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.1:                           ; preds = %for.loop
  %_1 = load i16, i16* %src.addr.0.0.05_1, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.2:                           ; preds = %for.loop
  %_2 = load i16, i16* %src.addr.0.0.05_2, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.3:                           ; preds = %for.loop
  %_3 = load i16, i16* %src.addr.0.0.05_3, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.4:                           ; preds = %for.loop
  %_4 = load i16, i16* %src.addr.0.0.05_4, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.5:                           ; preds = %for.loop
  %_5 = load i16, i16* %src.addr.0.0.05_5, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.6:                           ; preds = %for.loop
  %_6 = load i16, i16* %src.addr.0.0.05_6, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.7:                           ; preds = %for.loop
  %3 = icmp eq i64 %2, 7
  call void @llvm.assume(i1 %3)
  %_7 = load i16, i16* %src.addr.0.0.05_7, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.7, %src.addr.0.0.05.case.6, %src.addr.0.0.05.case.5, %src.addr.0.0.05.case.4, %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %4 = phi i16 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ], [ %_2, %src.addr.0.0.05.case.2 ], [ %_3, %src.addr.0.0.05.case.3 ], [ %_4, %src.addr.0.0.05.case.4 ], [ %_5, %src.addr.0.0.05.case.5 ], [ %_6, %src.addr.0.0.05.case.6 ], [ %_7, %src.addr.0.0.05.case.7 ]
  store i16 %4, i16* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<16>.5"([16 x %"struct.ap_int<16>"]* noalias "orig.arg.no"="0" "unpacked"="0" %dst, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %src_3, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.4" %src_4, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.5" %src_5, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.6" %src_6, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.7" %src_7) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<16>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<16>.8"([16 x %"struct.ap_int<16>"]* nonnull %dst, [2 x i16]* %src_0, [2 x i16]* %src_1, [2 x i16]* %src_2, [2 x i16]* %src_3, [2 x i16]* %src_4, [2 x i16]* %src_5, [2 x i16]* %src_6, [2 x i16]* %src_7, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_out([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0", [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.4" %_4, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.5" %_5, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.6" %_6, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.7" %_7, [16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="2" "unpacked"="2", [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.4" %_45, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.5" %_56, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.6" %_67, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.7" %_78, [16 x %"struct.ap_int<16>"]* noalias "orig.arg.no"="4" "unpacked"="4", [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_09, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_110, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_211, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_312, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.4" %_413, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.5" %_514, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.6" %_615, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.7" %_716) #6 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %0, [2 x i8]* align 512 %_0, [2 x i8]* align 512 %_1, [2 x i8]* align 512 %_2, [2 x i8]* align 512 %_3, [2 x i8]* align 512 %_4, [2 x i8]* align 512 %_5, [2 x i8]* align 512 %_6, [2 x i8]* align 512 %_7)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %1, [2 x i8]* align 512 %_01, [2 x i8]* align 512 %_12, [2 x i8]* align 512 %_23, [2 x i8]* align 512 %_34, [2 x i8]* align 512 %_45, [2 x i8]* align 512 %_56, [2 x i8]* align 512 %_67, [2 x i8]* align 512 %_78)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<16>.5"([16 x %"struct.ap_int<16>"]* %2, [2 x i16]* align 512 %_09, [2 x i16]* align 512 %_110, [2 x i16]* align 512 %_211, [2 x i16]* align 512 %_312, [2 x i16]* align 512 %_413, [2 x i16]* align 512 %_514, [2 x i16]* align 512 %_615, [2 x i16]* align 512 %_716)
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_kernel_hw([2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_back([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0", [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.4" %_4, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.5" %_5, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.6" %_6, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.7" %_7, [16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="2" "unpacked"="2", [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.4" %_45, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.5" %_56, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.6" %_67, [2 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.7" %_78, [16 x %"struct.ap_int<16>"]* noalias "orig.arg.no"="4" "unpacked"="4", [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_09, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_110, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_211, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_312, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.4" %_413, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.5" %_514, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.6" %_615, [2 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.7" %_716) #6 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<16>.5"([16 x %"struct.ap_int<16>"]* %2, [2 x i16]* align 512 %_09, [2 x i16]* align 512 %_110, [2 x i16]* align 512 %_211, [2 x i16]* align 512 %_312, [2 x i16]* align 512 %_413, [2 x i16]* align 512 %_514, [2 x i16]* align 512 %_615, [2 x i16]* align 512 %_716)
  ret void
}

declare void @kernel_hw_stub(%"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<16>"* noalias nocapture nonnull)

define void @kernel_hw_stub_wrapper([2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*, [2 x i16]*) #7 {
entry:
  %24 = call i8* @malloc(i64 16)
  %25 = bitcast i8* %24 to [16 x %"struct.ap_int<8>"]*
  %26 = call i8* @malloc(i64 16)
  %27 = bitcast i8* %26 to [16 x %"struct.ap_int<8>"]*
  %28 = call i8* @malloc(i64 32)
  %29 = bitcast i8* %28 to [16 x %"struct.ap_int<16>"]*
  call void @copy_out([16 x %"struct.ap_int<8>"]* %25, [2 x i8]* %0, [2 x i8]* %1, [2 x i8]* %2, [2 x i8]* %3, [2 x i8]* %4, [2 x i8]* %5, [2 x i8]* %6, [2 x i8]* %7, [16 x %"struct.ap_int<8>"]* %27, [2 x i8]* %8, [2 x i8]* %9, [2 x i8]* %10, [2 x i8]* %11, [2 x i8]* %12, [2 x i8]* %13, [2 x i8]* %14, [2 x i8]* %15, [16 x %"struct.ap_int<16>"]* %29, [2 x i16]* %16, [2 x i16]* %17, [2 x i16]* %18, [2 x i16]* %19, [2 x i16]* %20, [2 x i16]* %21, [2 x i16]* %22, [2 x i16]* %23)
  %30 = bitcast [16 x %"struct.ap_int<8>"]* %25 to %"struct.ap_int<8>"*
  %31 = bitcast [16 x %"struct.ap_int<8>"]* %27 to %"struct.ap_int<8>"*
  %32 = bitcast [16 x %"struct.ap_int<16>"]* %29 to %"struct.ap_int<16>"*
  call void @kernel_hw_stub(%"struct.ap_int<8>"* %30, %"struct.ap_int<8>"* %31, %"struct.ap_int<16>"* %32)
  call void @copy_in([16 x %"struct.ap_int<8>"]* %25, [2 x i8]* %0, [2 x i8]* %1, [2 x i8]* %2, [2 x i8]* %3, [2 x i8]* %4, [2 x i8]* %5, [2 x i8]* %6, [2 x i8]* %7, [16 x %"struct.ap_int<8>"]* %27, [2 x i8]* %8, [2 x i8]* %9, [2 x i8]* %10, [2 x i8]* %11, [2 x i8]* %12, [2 x i8]* %13, [2 x i8]* %14, [2 x i8]* %15, [16 x %"struct.ap_int<16>"]* %29, [2 x i16]* %16, [2 x i16]* %17, [2 x i16]* %18, [2 x i16]* %19, [2 x i16]* %20, [2 x i16]* %21, [2 x i16]* %22, [2 x i16]* %23)
  call void @free(i8* %24)
  call void @free(i8* %26)
  call void @free(i8* %28)
  ret void
}

attributes #0 = { inaccessiblememonly nounwind willreturn }
attributes #1 = { inaccessiblemem_or_argmemonly noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #2 = { nounwind willreturn }
attributes #3 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
attributes #4 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #5 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyin" }
attributes #6 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyout" }
attributes #7 = { "fpga.wrapper.func"="stub" }
attributes #8 = { inaccessiblememonly nounwind willreturn "xlx.source"="infer-from-pragma" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}
!datalayout.transforms.on.top = !{!5, !19, !31}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
!5 = !{!6, !8, !10}
!6 = !{!7}
!7 = !{!"0.0", [16 x i8]* null}
!8 = !{!9}
!9 = !{!"array_partition", !"type=Cyclic", !"dim=1", !"factor=8"}
!10 = !{!11, !12, !13, !14, !15, !16, !17, !18}
!11 = !{!"0.0.0", [2 x i8]* null}
!12 = !{!"0.0.1", [2 x i8]* null}
!13 = !{!"0.0.2", [2 x i8]* null}
!14 = !{!"0.0.3", [2 x i8]* null}
!15 = !{!"0.0.4", [2 x i8]* null}
!16 = !{!"0.0.5", [2 x i8]* null}
!17 = !{!"0.0.6", [2 x i8]* null}
!18 = !{!"0.0.7", [2 x i8]* null}
!19 = !{!20, !8, !22}
!20 = !{!21}
!21 = !{!"1.0", [16 x i8]* null}
!22 = !{!23, !24, !25, !26, !27, !28, !29, !30}
!23 = !{!"1.0.0", [2 x i8]* null}
!24 = !{!"1.0.1", [2 x i8]* null}
!25 = !{!"1.0.2", [2 x i8]* null}
!26 = !{!"1.0.3", [2 x i8]* null}
!27 = !{!"1.0.4", [2 x i8]* null}
!28 = !{!"1.0.5", [2 x i8]* null}
!29 = !{!"1.0.6", [2 x i8]* null}
!30 = !{!"1.0.7", [2 x i8]* null}
!31 = !{!32, !8, !34}
!32 = !{!33}
!33 = !{!"2.0", [16 x i16]* null}
!34 = !{!35, !36, !37, !38, !39, !40, !41, !42}
!35 = !{!"2.0.0", [2 x i16]* null}
!36 = !{!"2.0.1", [2 x i16]* null}
!37 = !{!"2.0.2", [2 x i16]* null}
!38 = !{!"2.0.3", [2 x i16]* null}
!39 = !{!"2.0.4", [2 x i16]* null}
!40 = !{!"2.0.5", [2 x i16]* null}
!41 = !{!"2.0.6", [2 x i16]* null}
!42 = !{!"2.0.7", [2 x i16]* null}
!43 = !DILocation(line: 14, column: 9, scope: !44)
!44 = distinct !DISubprogram(name: "kernel", linkageName: "_Z6kernelP6ap_intILi8EES1_PS_ILi16EE", scope: !45, file: !45, line: 5, type: !46, isLocal: false, isDefinition: true, scopeLine: 5, flags: DIFlagPrototyped, isOptimized: false, unit: !156, variables: !4)
!45 = !DIFile(filename: "kernel.cpp", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/balanced_int16_p8")
!46 = !DISubroutineType(types: !47)
!47 = !{null, !48, !48, !108}
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int<8>", file: !50, line: 18, size: 8, flags: DIFlagTypePassByValue, elements: !51, templateParams: !107, identifier: "_ZTS6ap_intILi8EE")
!50 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/ap_int.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/balanced_int16_p8")
!51 = !{!52, !87, !92, !96, !101}
!52 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !49, baseType: !53)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<8, true>", file: !54, line: 124, size: 8, flags: DIFlagTypePassByValue, elements: !55, templateParams: !85, identifier: "_ZTS11ap_int_baseILi8ELb1EE")
!54 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_int_base.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/balanced_int16_p8")
!55 = !{!56, !74, !76, !78}
!56 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !53, baseType: !57)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<8, true>", file: !58, line: 530, size: 8, flags: DIFlagTypePassByValue, elements: !59, templateParams: !69, identifier: "_ZTS8ssdm_intILi8ELb1EE")
!58 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_common.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/balanced_int16_p8")
!59 = !{!60, !62, !66}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !57, file: !58, line: 532, baseType: !61, size: 8)
!61 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!62 = !DISubprogram(name: "ssdm_int", scope: !57, file: !58, line: 533, type: !63, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!63 = !DISubroutineType(types: !64)
!64 = !{null, !65}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!66 = !DISubprogram(name: "ssdm_int", scope: !57, file: !58, line: 534, type: !67, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!67 = !DISubroutineType(types: !68)
!68 = !{null, !65, !61}
!69 = !{!70, !72}
!70 = !DITemplateValueParameter(name: "_AP_N", type: !71, value: i32 8)
!71 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!72 = !DITemplateValueParameter(name: "_AP_S", type: !73, value: i8 1)
!73 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !53, file: !54, line: 148, baseType: !75, flags: DIFlagStaticMember, extraData: i32 8)
!75 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !71)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !53, file: !54, line: 149, baseType: !77, flags: DIFlagStaticMember, extraData: i1 true)
!77 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !73)
!78 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi8ELb1EEaSERKS0_", scope: !53, file: !54, line: 479, type: !79, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!79 = !DISubroutineType(types: !80)
!80 = !{!81, !82, !83}
!81 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !53, size: 64)
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!83 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !84, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !53)
!85 = !{!86, !72}
!86 = !DITemplateValueParameter(name: "_AP_W", type: !71, value: i32 8)
!87 = !DISubprogram(name: "ap_int", scope: !49, file: !50, line: 142, type: !88, isLocal: false, isDefinition: false, scopeLine: 142, flags: DIFlagPrototyped, isOptimized: false)
!88 = !DISubroutineType(types: !89)
!89 = !{null, !90, !91}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!91 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!92 = !DISubprogram(name: "ap_int", scope: !49, file: !50, line: 143, type: !93, isLocal: false, isDefinition: false, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false)
!93 = !DISubroutineType(types: !94)
!94 = !{null, !90, !95}
!95 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!96 = !DISubprogram(name: "ap_int", scope: !49, file: !50, line: 144, type: !97, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!97 = !DISubroutineType(types: !98)
!98 = !{null, !90, !99}
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "half", file: !58, line: 632, baseType: !100)
!100 = !DIBasicType(name: "__fp16", size: 16, encoding: DW_ATE_float)
!101 = !DISubprogram(name: "operator=", linkageName: "_ZN6ap_intILi8EEaSERKS0_", scope: !49, file: !50, line: 154, type: !102, isLocal: false, isDefinition: false, scopeLine: 154, flags: DIFlagPrototyped, isOptimized: false)
!102 = !DISubroutineType(types: !103)
!103 = !{!104, !90, !105}
!104 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !49, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !106, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !49)
!107 = !{!86}
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int<16>", file: !50, line: 18, size: 16, flags: DIFlagTypePassByValue, elements: !110, templateParams: !155, identifier: "_ZTS6ap_intILi16EE")
!110 = !{!111, !139, !143, !146, !149}
!111 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !109, baseType: !112)
!112 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<16, true>", file: !54, line: 124, size: 16, flags: DIFlagTypePassByValue, elements: !113, templateParams: !137, identifier: "_ZTS11ap_int_baseILi16ELb1EE")
!113 = !{!114, !128, !129, !130}
!114 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !112, baseType: !115)
!115 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<16, true>", file: !58, line: 530, size: 16, flags: DIFlagTypePassByValue, elements: !116, templateParams: !126, identifier: "_ZTS8ssdm_intILi16ELb1EE")
!116 = !{!117, !119, !123}
!117 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !115, file: !58, line: 532, baseType: !118, size: 16)
!118 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!119 = !DISubprogram(name: "ssdm_int", scope: !115, file: !58, line: 533, type: !120, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!120 = !DISubroutineType(types: !121)
!121 = !{null, !122}
!122 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!123 = !DISubprogram(name: "ssdm_int", scope: !115, file: !58, line: 534, type: !124, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!124 = !DISubroutineType(types: !125)
!125 = !{null, !122, !118}
!126 = !{!127, !72}
!127 = !DITemplateValueParameter(name: "_AP_N", type: !71, value: i32 16)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !112, file: !54, line: 148, baseType: !75, flags: DIFlagStaticMember, extraData: i32 16)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !112, file: !54, line: 149, baseType: !77, flags: DIFlagStaticMember, extraData: i1 true)
!130 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi16ELb1EEaSERKS0_", scope: !112, file: !54, line: 479, type: !131, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!131 = !DISubroutineType(types: !132)
!132 = !{!133, !134, !135}
!133 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !112, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!135 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !136, size: 64)
!136 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !112)
!137 = !{!138, !72}
!138 = !DITemplateValueParameter(name: "_AP_W", type: !71, value: i32 16)
!139 = !DISubprogram(name: "ap_int", scope: !109, file: !50, line: 142, type: !140, isLocal: false, isDefinition: false, scopeLine: 142, flags: DIFlagPrototyped, isOptimized: false)
!140 = !DISubroutineType(types: !141)
!141 = !{null, !142, !91}
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!143 = !DISubprogram(name: "ap_int", scope: !109, file: !50, line: 143, type: !144, isLocal: false, isDefinition: false, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false)
!144 = !DISubroutineType(types: !145)
!145 = !{null, !142, !95}
!146 = !DISubprogram(name: "ap_int", scope: !109, file: !50, line: 144, type: !147, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!147 = !DISubroutineType(types: !148)
!148 = !{null, !142, !99}
!149 = !DISubprogram(name: "operator=", linkageName: "_ZN6ap_intILi16EEaSERKS0_", scope: !109, file: !50, line: 154, type: !150, isLocal: false, isDefinition: false, scopeLine: 154, flags: DIFlagPrototyped, isOptimized: false)
!150 = !DISubroutineType(types: !151)
!151 = !{!152, !142, !153}
!152 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !109, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !154, size: 64)
!154 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !109)
!155 = !{!138}
!156 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !157, producer: "clang version 7.0.0 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !158)
!157 = !DIFile(filename: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/balanced_int16_p8/work/hls/.autopilot/db/kernel.pp.0.cpp", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/balanced_int16_p8")
!158 = !{!159}
!159 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<9, true>", file: !54, line: 124, size: 16, flags: DIFlagTypePassByValue, elements: !160, templateParams: !184, identifier: "_ZTS11ap_int_baseILi9ELb1EE")
!160 = !{!161, !175, !176, !177}
!161 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !159, baseType: !162)
!162 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<9, true>", file: !58, line: 530, size: 16, flags: DIFlagTypePassByValue, elements: !163, templateParams: !173, identifier: "_ZTS8ssdm_intILi9ELb1EE")
!163 = !{!164, !166, !170}
!164 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !162, file: !58, line: 532, baseType: !165, size: 9, align: 16)
!165 = !DIBasicType(name: "int9", size: 9, encoding: DW_ATE_signed)
!166 = !DISubprogram(name: "ssdm_int", scope: !162, file: !58, line: 533, type: !167, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!167 = !DISubroutineType(types: !168)
!168 = !{null, !169}
!169 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!170 = !DISubprogram(name: "ssdm_int", scope: !162, file: !58, line: 534, type: !171, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!171 = !DISubroutineType(types: !172)
!172 = !{null, !169, !165}
!173 = !{!174, !72}
!174 = !DITemplateValueParameter(name: "_AP_N", type: !71, value: i32 9)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !159, file: !54, line: 148, baseType: !75, flags: DIFlagStaticMember, extraData: i32 9)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !159, file: !54, line: 149, baseType: !77, flags: DIFlagStaticMember, extraData: i1 true)
!177 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi9ELb1EEaSERKS0_", scope: !159, file: !54, line: 479, type: !178, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!178 = !DISubroutineType(types: !179)
!179 = !{!180, !181, !182}
!180 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !159, size: 64)
!181 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!182 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !183, size: 64)
!183 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !159)
!184 = !{!185, !72}
!185 = !DITemplateValueParameter(name: "_AP_W", type: !71, value: i32 9)
!186 = !DILocation(line: 15, column: 9, scope: !44)
!187 = !DILocation(line: 16, column: 9, scope: !44)
