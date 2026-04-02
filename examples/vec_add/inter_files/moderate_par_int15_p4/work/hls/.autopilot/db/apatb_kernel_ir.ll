; ModuleID = '/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_int<8>" = type { %"struct.ap_int_base<8, true>" }
%"struct.ap_int_base<8, true>" = type { %"struct.ssdm_int<8, true>" }
%"struct.ssdm_int<8, true>" = type { i8 }
%"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>" = type { %"struct.ap_fixed_base<16, 7, true, AP_TRN, AP_WRAP, 0>" }
%"struct.ap_fixed_base<16, 7, true, AP_TRN, AP_WRAP, 0>" = type { %"struct.ssdm_int<16, true>" }
%"struct.ssdm_int<16, true>" = type { i16 }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_kernel_ir(%"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" "partition" %a, %"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" "partition" %b, %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"* noalias nocapture nonnull "fpga.decayed.dim.hint"="16" "maxi" "partition" %c) local_unnamed_addr #1 {
entry:
  %0 = bitcast %"struct.ap_int<8>"* %a to [16 x %"struct.ap_int<8>"]*
  %a_copy_0 = alloca [4 x i8], align 512
  %a_copy_1 = alloca [4 x i8], align 512
  %a_copy_2 = alloca [4 x i8], align 512
  %a_copy_3 = alloca [4 x i8], align 512
  %_0 = getelementptr [4 x i8], [4 x i8]* %a_copy_0, i64 0, i64 0
  %_1 = getelementptr [4 x i8], [4 x i8]* %a_copy_1, i64 0, i64 0
  %_2 = getelementptr [4 x i8], [4 x i8]* %a_copy_2, i64 0, i64 0
  %_3 = getelementptr [4 x i8], [4 x i8]* %a_copy_3, i64 0, i64 0
  %1 = bitcast %"struct.ap_int<8>"* %b to [16 x %"struct.ap_int<8>"]*
  %b_copy_0 = alloca [4 x i8], align 512
  %b_copy_1 = alloca [4 x i8], align 512
  %b_copy_2 = alloca [4 x i8], align 512
  %b_copy_3 = alloca [4 x i8], align 512
  %_04 = getelementptr [4 x i8], [4 x i8]* %b_copy_0, i64 0, i64 0
  %_15 = getelementptr [4 x i8], [4 x i8]* %b_copy_1, i64 0, i64 0
  %_26 = getelementptr [4 x i8], [4 x i8]* %b_copy_2, i64 0, i64 0
  %_37 = getelementptr [4 x i8], [4 x i8]* %b_copy_3, i64 0, i64 0
  %2 = bitcast %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"* %c to [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]*
  %c_copy_0 = alloca [4 x i16], align 512
  %c_copy_1 = alloca [4 x i16], align 512
  %c_copy_2 = alloca [4 x i16], align 512
  %c_copy_3 = alloca [4 x i16], align 512
  %_08 = getelementptr [4 x i16], [4 x i16]* %c_copy_0, i64 0, i64 0
  %_19 = getelementptr [4 x i16], [4 x i16]* %c_copy_1, i64 0, i64 0
  %_210 = getelementptr [4 x i16], [4 x i16]* %c_copy_2, i64 0, i64 0
  %_311 = getelementptr [4 x i16], [4 x i16]* %c_copy_3, i64 0, i64 0
  call void @copy_in([16 x %"struct.ap_int<8>"]* nonnull %0, [4 x i8]* nonnull align 512 %a_copy_0, [4 x i8]* nonnull align 512 %a_copy_1, [4 x i8]* nonnull align 512 %a_copy_2, [4 x i8]* nonnull align 512 %a_copy_3, [16 x %"struct.ap_int<8>"]* nonnull %1, [4 x i8]* nonnull align 512 %b_copy_0, [4 x i8]* nonnull align 512 %b_copy_1, [4 x i8]* nonnull align 512 %b_copy_2, [4 x i8]* nonnull align 512 %b_copy_3, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* nonnull %2, [4 x i16]* nonnull align 512 %c_copy_0, [4 x i16]* nonnull align 512 %c_copy_1, [4 x i16]* nonnull align 512 %c_copy_2, [4 x i16]* nonnull align 512 %c_copy_3)
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_0, i32 999, i32 1, i32 1, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_1, i32 999, i32 1, i32 1, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_2, i32 999, i32 1, i32 1, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_3, i32 999, i32 1, i32 1, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_0, i32 998, i32 1, i32 0, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_1, i32 998, i32 1, i32 0, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_2, i32 998, i32 1, i32 0, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_3, i32 998, i32 1, i32 0, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_04, i32 999, i32 1, i32 1, i1 false) ], !dbg !161
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_15, i32 999, i32 1, i32 1, i1 false) ], !dbg !161
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_26, i32 999, i32 1, i32 1, i1 false) ], !dbg !161
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_37, i32 999, i32 1, i32 1, i1 false) ], !dbg !161
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_04, i32 998, i32 1, i32 0, i1 false) ], !dbg !161
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_15, i32 998, i32 1, i32 0, i1 false) ], !dbg !161
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_26, i32 998, i32 1, i32 0, i1 false) ], !dbg !161
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_37, i32 998, i32 1, i32 0, i1 false) ], !dbg !161
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_08, i32 999, i32 1, i32 1, i1 false) ], !dbg !162
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_19, i32 999, i32 1, i32 1, i1 false) ], !dbg !162
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_210, i32 999, i32 1, i32 1, i1 false) ], !dbg !162
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_311, i32 999, i32 1, i32 1, i1 false) ], !dbg !162
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_08, i32 998, i32 1, i32 0, i1 false) ], !dbg !162
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_19, i32 998, i32 1, i32 0, i1 false) ], !dbg !162
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_210, i32 998, i32 1, i32 0, i1 false) ], !dbg !162
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i16* %_311, i32 998, i32 1, i32 0, i1 false) ], !dbg !162
  call void @apatb_kernel_hw([4 x i8]* %a_copy_0, [4 x i8]* %a_copy_1, [4 x i8]* %a_copy_2, [4 x i8]* %a_copy_3, [4 x i8]* %b_copy_0, [4 x i8]* %b_copy_1, [4 x i8]* %b_copy_2, [4 x i8]* %b_copy_3, [4 x i16]* %c_copy_0, [4 x i16]* %c_copy_1, [4 x i16]* %c_copy_2, [4 x i16]* %c_copy_3)
  call void @copy_back([16 x %"struct.ap_int<8>"]* %0, [4 x i8]* %a_copy_0, [4 x i8]* %a_copy_1, [4 x i8]* %a_copy_2, [4 x i8]* %a_copy_3, [16 x %"struct.ap_int<8>"]* %1, [4 x i8]* %b_copy_0, [4 x i8]* %b_copy_1, [4 x i8]* %b_copy_2, [4 x i8]* %b_copy_3, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %2, [4 x i16]* %c_copy_0, [4 x i16]* %c_copy_1, [4 x i16]* %c_copy_2, [4 x i16]* %c_copy_3)
  ret void
}

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #2

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>.18"([4 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [4 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [4 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [4 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [16 x %"struct.ap_int<8>"]* readonly "orig.arg.no"="1" "unpacked"="1" %src, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
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
  %1 = udiv i64 %for.loop.idx2, 4
  %2 = urem i64 %for.loop.idx2, 4
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [4 x i8], [4 x i8]* %dst_0, i64 0, i64 %1
  %dst.addr.0.0.06_1 = getelementptr [4 x i8], [4 x i8]* %dst_1, i64 0, i64 %1
  %dst.addr.0.0.06_2 = getelementptr [4 x i8], [4 x i8]* %dst_2, i64 0, i64 %1
  %dst.addr.0.0.06_3 = getelementptr [4 x i8], [4 x i8]* %dst_3, i64 0, i64 %1
  %3 = load i8, i8* %src.addr.0.0.05, align 1
  switch i64 %2, label %dst.addr.0.0.06.case.3 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
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
  %4 = icmp eq i64 %2, 3
  call void @llvm.assume(i1 %4)
  store i8 %3, i8* %dst.addr.0.0.06_3, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.3, %dst.addr.0.0.06.case.2, %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([4 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="1" "unpacked"="1" %src) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<8>.18"([4 x i8]* %dst_0, [4 x i8]* %dst_1, [4 x i8]* %dst_2, [4 x i8]* %dst_3, [16 x %"struct.ap_int<8>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"([4 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [4 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [4 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [4 x i16]* nocapture "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* readonly "orig.arg.no"="1" "unpacked"="1" %src, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %1 = udiv i64 %for.loop.idx2, 4
  %2 = urem i64 %for.loop.idx2, 4
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"], [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [4 x i16], [4 x i16]* %dst_0, i64 0, i64 %1
  %dst.addr.0.0.06_1 = getelementptr [4 x i16], [4 x i16]* %dst_1, i64 0, i64 %1
  %dst.addr.0.0.06_2 = getelementptr [4 x i16], [4 x i16]* %dst_2, i64 0, i64 %1
  %dst.addr.0.0.06_3 = getelementptr [4 x i16], [4 x i16]* %dst_3, i64 0, i64 %1
  %3 = load i16, i16* %src.addr.0.0.05, align 2
  switch i64 %2, label %dst.addr.0.0.06.case.3 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
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
  %4 = icmp eq i64 %2, 3
  call void @llvm.assume(i1 %4)
  store i16 %3, i16* %dst.addr.0.0.06_3, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.3, %dst.addr.0.0.06.case.2, %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"([4 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [4 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [4 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [4 x i16]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* noalias readonly "orig.arg.no"="1" "unpacked"="1" %src) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"([4 x i16]* %dst_0, [4 x i16]* %dst_1, [4 x i16]* %dst_2, [4 x i16]* %dst_3, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_in([16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="0" "unpacked"="0", [4 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="2" "unpacked"="2", [4 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* noalias readonly "orig.arg.no"="4" "unpacked"="4", [4 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_05, [4 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_16, [4 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_27, [4 x i16]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_38) #5 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([4 x i8]* align 512 %_0, [4 x i8]* align 512 %_1, [4 x i8]* align 512 %_2, [4 x i8]* align 512 %_3, [16 x %"struct.ap_int<8>"]* %0)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([4 x i8]* align 512 %_01, [4 x i8]* align 512 %_12, [4 x i8]* align 512 %_23, [4 x i8]* align 512 %_34, [16 x %"struct.ap_int<8>"]* %1)
  call void @"onebyonecpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"([4 x i16]* align 512 %_05, [4 x i16]* align 512 %_16, [4 x i16]* align 512 %_27, [4 x i16]* align 512 %_38, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %2)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>.25"([16 x %"struct.ap_int<8>"]* "orig.arg.no"="0" "unpacked"="0" %dst, [4 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [4 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [4 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [4 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.3" %src_3, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
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
  %1 = udiv i64 %for.loop.idx2, 4
  %2 = urem i64 %for.loop.idx2, 4
  %src.addr.0.0.05_0 = getelementptr [4 x i8], [4 x i8]* %src_0, i64 0, i64 %1
  %src.addr.0.0.05_1 = getelementptr [4 x i8], [4 x i8]* %src_1, i64 0, i64 %1
  %src.addr.0.0.05_2 = getelementptr [4 x i8], [4 x i8]* %src_2, i64 0, i64 %1
  %src.addr.0.0.05_3 = getelementptr [4 x i8], [4 x i8]* %src_3, i64 0, i64 %1
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %2, label %src.addr.0.0.05.case.3 [
    i64 0, label %src.addr.0.0.05.case.0
    i64 1, label %src.addr.0.0.05.case.1
    i64 2, label %src.addr.0.0.05.case.2
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
  %3 = icmp eq i64 %2, 3
  call void @llvm.assume(i1 %3)
  %_3 = load i8, i8* %src.addr.0.0.05_3, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %4 = phi i8 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ], [ %_2, %src.addr.0.0.05.case.2 ], [ %_3, %src.addr.0.0.05.case.3 ]
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
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0" %dst, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %src_3) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<8>.25"([16 x %"struct.ap_int<8>"]* nonnull %dst, [4 x i8]* %src_0, [4 x i8]* %src_1, [4 x i8]* %src_2, [4 x i8]* %src_3, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.8"([16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* "orig.arg.no"="0" "unpacked"="0" %dst, [4 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [4 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [4 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [4 x i16]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.3" %src_3, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %1 = udiv i64 %for.loop.idx2, 4
  %2 = urem i64 %for.loop.idx2, 4
  %src.addr.0.0.05_0 = getelementptr [4 x i16], [4 x i16]* %src_0, i64 0, i64 %1
  %src.addr.0.0.05_1 = getelementptr [4 x i16], [4 x i16]* %src_1, i64 0, i64 %1
  %src.addr.0.0.05_2 = getelementptr [4 x i16], [4 x i16]* %src_2, i64 0, i64 %1
  %src.addr.0.0.05_3 = getelementptr [4 x i16], [4 x i16]* %src_3, i64 0, i64 %1
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"], [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %2, label %src.addr.0.0.05.case.3 [
    i64 0, label %src.addr.0.0.05.case.0
    i64 1, label %src.addr.0.0.05.case.1
    i64 2, label %src.addr.0.0.05.case.2
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
  %3 = icmp eq i64 %2, 3
  call void @llvm.assume(i1 %3)
  %_3 = load i16, i16* %src.addr.0.0.05_3, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %4 = phi i16 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ], [ %_2, %src.addr.0.0.05.case.2 ], [ %_3, %src.addr.0.0.05.case.3 ]
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
define internal void @"onebyonecpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"([16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* noalias "orig.arg.no"="0" "unpacked"="0" %dst, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %src_3) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.8"([16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* nonnull %dst, [4 x i16]* %src_0, [4 x i16]* %src_1, [4 x i16]* %src_2, [4 x i16]* %src_3, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_out([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0", [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="2" "unpacked"="2", [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* noalias "orig.arg.no"="4" "unpacked"="4", [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_05, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_16, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_27, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_38) #6 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %0, [4 x i8]* align 512 %_0, [4 x i8]* align 512 %_1, [4 x i8]* align 512 %_2, [4 x i8]* align 512 %_3)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %1, [4 x i8]* align 512 %_01, [4 x i8]* align 512 %_12, [4 x i8]* align 512 %_23, [4 x i8]* align 512 %_34)
  call void @"onebyonecpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"([16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %2, [4 x i16]* align 512 %_05, [4 x i16]* align 512 %_16, [4 x i16]* align 512 %_27, [4 x i16]* align 512 %_38)
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_kernel_hw([4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i16]*, [4 x i16]*, [4 x i16]*, [4 x i16]*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_back([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0", [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="2" "unpacked"="2", [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* noalias "orig.arg.no"="4" "unpacked"="4", [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_05, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_16, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_27, [4 x i16]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_38) #6 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"([16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %2, [4 x i16]* align 512 %_05, [4 x i16]* align 512 %_16, [4 x i16]* align 512 %_27, [4 x i16]* align 512 %_38)
  ret void
}

declare void @kernel_hw_stub(%"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"* noalias nocapture nonnull)

define void @kernel_hw_stub_wrapper([4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i16]*, [4 x i16]*, [4 x i16]*, [4 x i16]*) #7 {
entry:
  %12 = call i8* @malloc(i64 16)
  %13 = bitcast i8* %12 to [16 x %"struct.ap_int<8>"]*
  %14 = call i8* @malloc(i64 16)
  %15 = bitcast i8* %14 to [16 x %"struct.ap_int<8>"]*
  %16 = call i8* @malloc(i64 32)
  %17 = bitcast i8* %16 to [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]*
  call void @copy_out([16 x %"struct.ap_int<8>"]* %13, [4 x i8]* %0, [4 x i8]* %1, [4 x i8]* %2, [4 x i8]* %3, [16 x %"struct.ap_int<8>"]* %15, [4 x i8]* %4, [4 x i8]* %5, [4 x i8]* %6, [4 x i8]* %7, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %17, [4 x i16]* %8, [4 x i16]* %9, [4 x i16]* %10, [4 x i16]* %11)
  %18 = bitcast [16 x %"struct.ap_int<8>"]* %13 to %"struct.ap_int<8>"*
  %19 = bitcast [16 x %"struct.ap_int<8>"]* %15 to %"struct.ap_int<8>"*
  %20 = bitcast [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %17 to %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"*
  call void @kernel_hw_stub(%"struct.ap_int<8>"* %18, %"struct.ap_int<8>"* %19, %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"* %20)
  call void @copy_in([16 x %"struct.ap_int<8>"]* %13, [4 x i8]* %0, [4 x i8]* %1, [4 x i8]* %2, [4 x i8]* %3, [16 x %"struct.ap_int<8>"]* %15, [4 x i8]* %4, [4 x i8]* %5, [4 x i8]* %6, [4 x i8]* %7, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>"]* %17, [4 x i16]* %8, [4 x i16]* %9, [4 x i16]* %10, [4 x i16]* %11)
  call void @free(i8* %12)
  call void @free(i8* %14)
  call void @free(i8* %16)
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
!datalayout.transforms.on.top = !{!5, !15, !23}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
!5 = !{!6, !8, !10}
!6 = !{!7}
!7 = !{!"0.0", [16 x i8]* null}
!8 = !{!9}
!9 = !{!"array_partition", !"type=Cyclic", !"dim=1", !"factor=4"}
!10 = !{!11, !12, !13, !14}
!11 = !{!"0.0.0", [4 x i8]* null}
!12 = !{!"0.0.1", [4 x i8]* null}
!13 = !{!"0.0.2", [4 x i8]* null}
!14 = !{!"0.0.3", [4 x i8]* null}
!15 = !{!16, !8, !18}
!16 = !{!17}
!17 = !{!"1.0", [16 x i8]* null}
!18 = !{!19, !20, !21, !22}
!19 = !{!"1.0.0", [4 x i8]* null}
!20 = !{!"1.0.1", [4 x i8]* null}
!21 = !{!"1.0.2", [4 x i8]* null}
!22 = !{!"1.0.3", [4 x i8]* null}
!23 = !{!24, !8, !26}
!24 = !{!25}
!25 = !{!"2.0", [16 x i16]* null}
!26 = !{!27, !28, !29, !30}
!27 = !{!"2.0.0", [4 x i16]* null}
!28 = !{!"2.0.1", [4 x i16]* null}
!29 = !{!"2.0.2", [4 x i16]* null}
!30 = !{!"2.0.3", [4 x i16]* null}
!31 = !DILocation(line: 14, column: 9, scope: !32)
!32 = distinct !DISubprogram(name: "kernel", linkageName: "_Z6kernelP6ap_intILi8EES1_P8ap_fixedILi16ELi7EL9ap_q_mode5EL9ap_o_mode3ELi0EE", scope: !33, file: !33, line: 5, type: !34, isLocal: false, isDefinition: true, scopeLine: 5, flags: DIFlagPrototyped, isOptimized: false, unit: !155, variables: !4)
!33 = !DIFile(filename: "kernel.cpp", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4")
!34 = !DISubroutineType(types: !35)
!35 = !{null, !36, !36, !96}
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int<8>", file: !38, line: 18, size: 8, flags: DIFlagTypePassByValue, elements: !39, templateParams: !95, identifier: "_ZTS6ap_intILi8EE")
!38 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/ap_int.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4")
!39 = !{!40, !75, !80, !84, !89}
!40 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !37, baseType: !41)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<8, true>", file: !42, line: 124, size: 8, flags: DIFlagTypePassByValue, elements: !43, templateParams: !73, identifier: "_ZTS11ap_int_baseILi8ELb1EE")
!42 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_int_base.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4")
!43 = !{!44, !62, !64, !66}
!44 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !41, baseType: !45)
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<8, true>", file: !46, line: 530, size: 8, flags: DIFlagTypePassByValue, elements: !47, templateParams: !57, identifier: "_ZTS8ssdm_intILi8ELb1EE")
!46 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_common.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4")
!47 = !{!48, !50, !54}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !45, file: !46, line: 532, baseType: !49, size: 8)
!49 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!50 = !DISubprogram(name: "ssdm_int", scope: !45, file: !46, line: 533, type: !51, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!51 = !DISubroutineType(types: !52)
!52 = !{null, !53}
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!54 = !DISubprogram(name: "ssdm_int", scope: !45, file: !46, line: 534, type: !55, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!55 = !DISubroutineType(types: !56)
!56 = !{null, !53, !49}
!57 = !{!58, !60}
!58 = !DITemplateValueParameter(name: "_AP_N", type: !59, value: i32 8)
!59 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!60 = !DITemplateValueParameter(name: "_AP_S", type: !61, value: i8 1)
!61 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !41, file: !42, line: 148, baseType: !63, flags: DIFlagStaticMember, extraData: i32 8)
!63 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !59)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !41, file: !42, line: 149, baseType: !65, flags: DIFlagStaticMember, extraData: i1 true)
!65 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !61)
!66 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi8ELb1EEaSERKS0_", scope: !41, file: !42, line: 479, type: !67, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!67 = !DISubroutineType(types: !68)
!68 = !{!69, !70, !71}
!69 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !41, size: 64)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!71 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !72, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !41)
!73 = !{!74, !60}
!74 = !DITemplateValueParameter(name: "_AP_W", type: !59, value: i32 8)
!75 = !DISubprogram(name: "ap_int", scope: !37, file: !38, line: 142, type: !76, isLocal: false, isDefinition: false, scopeLine: 142, flags: DIFlagPrototyped, isOptimized: false)
!76 = !DISubroutineType(types: !77)
!77 = !{null, !78, !79}
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!79 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!80 = !DISubprogram(name: "ap_int", scope: !37, file: !38, line: 143, type: !81, isLocal: false, isDefinition: false, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !78, !83}
!83 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!84 = !DISubprogram(name: "ap_int", scope: !37, file: !38, line: 144, type: !85, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!85 = !DISubroutineType(types: !86)
!86 = !{null, !78, !87}
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "half", file: !46, line: 632, baseType: !88)
!88 = !DIBasicType(name: "__fp16", size: 16, encoding: DW_ATE_float)
!89 = !DISubprogram(name: "operator=", linkageName: "_ZN6ap_intILi8EEaSERKS0_", scope: !37, file: !38, line: 154, type: !90, isLocal: false, isDefinition: false, scopeLine: 154, flags: DIFlagPrototyped, isOptimized: false)
!90 = !DISubroutineType(types: !91)
!91 = !{!92, !78, !93}
!92 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !37, size: 64)
!93 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !94, size: 64)
!94 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !37)
!95 = !{!74}
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>", file: !98, line: 18, size: 16, flags: DIFlagTypePassByValue, elements: !99, templateParams: !154, identifier: "_ZTS8ap_fixedILi16ELi7EL9ap_q_mode5EL9ap_o_mode3ELi0EE")
!98 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/ap_fixed.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4")
!99 = !{!100, !147}
!100 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !97, baseType: !101)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_fixed_base<16, 7, true, AP_TRN, AP_WRAP, 0>", file: !102, line: 110, size: 16, flags: DIFlagTypePassByValue, elements: !103, templateParams: !141, identifier: "_ZTS13ap_fixed_baseILi16ELi7ELb1EL9ap_q_mode5EL9ap_o_mode3ELi0EE")
!102 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_fixed_base.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4")
!103 = !{!104, !118, !119, !120, !132}
!104 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !101, baseType: !105)
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<16, true>", file: !46, line: 530, size: 16, flags: DIFlagTypePassByValue, elements: !106, templateParams: !116, identifier: "_ZTS8ssdm_intILi16ELb1EE")
!106 = !{!107, !109, !113}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !105, file: !46, line: 532, baseType: !108, size: 16)
!108 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!109 = !DISubprogram(name: "ssdm_int", scope: !105, file: !46, line: 533, type: !110, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!110 = !DISubroutineType(types: !111)
!111 = !{null, !112}
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!113 = !DISubprogram(name: "ssdm_int", scope: !105, file: !46, line: 534, type: !114, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!114 = !DISubroutineType(types: !115)
!115 = !{null, !112, !108}
!116 = !{!117, !60}
!117 = !DITemplateValueParameter(name: "_AP_N", type: !59, value: i32 16)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !101, file: !102, line: 115, baseType: !63, flags: DIFlagStaticMember, extraData: i32 16)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "iwidth", scope: !101, file: !102, line: 116, baseType: !63, flags: DIFlagStaticMember, extraData: i32 7)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "qmode", scope: !101, file: !102, line: 117, baseType: !121, flags: DIFlagStaticMember, extraData: i32 5)
!121 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !122)
!122 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "ap_q_mode", file: !123, line: 54, size: 32, elements: !124, identifier: "_ZTS9ap_q_mode")
!123 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_decl.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4")
!124 = !{!125, !126, !127, !128, !129, !130, !131}
!125 = !DIEnumerator(name: "AP_RND", value: 0)
!126 = !DIEnumerator(name: "AP_RND_ZERO", value: 1)
!127 = !DIEnumerator(name: "AP_RND_MIN_INF", value: 2)
!128 = !DIEnumerator(name: "AP_RND_INF", value: 3)
!129 = !DIEnumerator(name: "AP_RND_CONV", value: 4)
!130 = !DIEnumerator(name: "AP_TRN", value: 5)
!131 = !DIEnumerator(name: "AP_TRN_ZERO", value: 6)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "omode", scope: !101, file: !102, line: 118, baseType: !133, flags: DIFlagStaticMember, extraData: i32 3)
!133 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !134)
!134 = distinct !DICompositeType(tag: DW_TAG_enumeration_type, name: "ap_o_mode", file: !123, line: 76, size: 32, elements: !135, identifier: "_ZTS9ap_o_mode")
!135 = !{!136, !137, !138, !139, !140}
!136 = !DIEnumerator(name: "AP_SAT", value: 0)
!137 = !DIEnumerator(name: "AP_SAT_ZERO", value: 1)
!138 = !DIEnumerator(name: "AP_SAT_SYM", value: 2)
!139 = !DIEnumerator(name: "AP_WRAP", value: 3)
!140 = !DIEnumerator(name: "AP_WRAP_SM", value: 4)
!141 = !{!142, !143, !60, !144, !145, !146}
!142 = !DITemplateValueParameter(name: "_AP_W", type: !59, value: i32 16)
!143 = !DITemplateValueParameter(name: "_AP_I", type: !59, value: i32 7)
!144 = !DITemplateValueParameter(name: "_AP_Q", type: !122, value: i32 5)
!145 = !DITemplateValueParameter(name: "_AP_O", type: !134, value: i32 3)
!146 = !DITemplateValueParameter(name: "_AP_N", type: !59, value: i32 0)
!147 = !DISubprogram(name: "operator=", linkageName: "_ZN8ap_fixedILi16ELi7EL9ap_q_mode5EL9ap_o_mode3ELi0EEaSERKS2_", scope: !97, file: !98, line: 161, type: !148, isLocal: false, isDefinition: false, scopeLine: 161, flags: DIFlagPrototyped, isOptimized: false)
!148 = !DISubroutineType(types: !149)
!149 = !{!150, !151, !152}
!150 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !97, size: 64)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!152 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !153, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !97)
!154 = !{!142, !143, !144, !145, !146}
!155 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !156, producer: "clang version 7.0.0 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !157, retainedTypes: !158)
!156 = !DIFile(filename: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4/work/hls/.autopilot/db/kernel.pp.0.cpp", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/moderate_par_int15_p4")
!157 = !{!122, !134}
!158 = !{!159, !160}
!159 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!160 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!161 = !DILocation(line: 15, column: 9, scope: !32)
!162 = !DILocation(line: 16, column: 9, scope: !32)
