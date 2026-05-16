; ModuleID = '/home/chengzhy/FormaSyn/examples/vec_add/inter_files/resource_efficient_int12_p4/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_int<8>" = type { %"struct.ap_int_base<8, true>" }
%"struct.ap_int_base<8, true>" = type { %"struct.ssdm_int<8, true>" }
%"struct.ssdm_int<8, true>" = type { i8 }
%"struct.ap_int<12>" = type { %"struct.ap_int_base<12, true>" }
%"struct.ap_int_base<12, true>" = type { %"struct.ssdm_int<12, true>" }
%"struct.ssdm_int<12, true>" = type { i12 }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_kernel_ir(%"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" "partition" %a, %"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" "partition" %b, %"struct.ap_int<12>"* noalias nocapture nonnull "fpga.decayed.dim.hint"="16" "maxi" "partition" %c) local_unnamed_addr #1 {
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
  %2 = bitcast %"struct.ap_int<12>"* %c to [16 x %"struct.ap_int<12>"]*
  %c_copy_0 = alloca [4 x i12], align 512
  %c_copy_1 = alloca [4 x i12], align 512
  %c_copy_2 = alloca [4 x i12], align 512
  %c_copy_3 = alloca [4 x i12], align 512
  %_08 = getelementptr [4 x i12], [4 x i12]* %c_copy_0, i64 0, i64 0
  %_19 = getelementptr [4 x i12], [4 x i12]* %c_copy_1, i64 0, i64 0
  %_210 = getelementptr [4 x i12], [4 x i12]* %c_copy_2, i64 0, i64 0
  %_311 = getelementptr [4 x i12], [4 x i12]* %c_copy_3, i64 0, i64 0
  call void @copy_in([16 x %"struct.ap_int<8>"]* nonnull %0, [4 x i8]* nonnull align 512 %a_copy_0, [4 x i8]* nonnull align 512 %a_copy_1, [4 x i8]* nonnull align 512 %a_copy_2, [4 x i8]* nonnull align 512 %a_copy_3, [16 x %"struct.ap_int<8>"]* nonnull %1, [4 x i8]* nonnull align 512 %b_copy_0, [4 x i8]* nonnull align 512 %b_copy_1, [4 x i8]* nonnull align 512 %b_copy_2, [4 x i8]* nonnull align 512 %b_copy_3, [16 x %"struct.ap_int<12>"]* nonnull %2, [4 x i12]* nonnull align 512 %c_copy_0, [4 x i12]* nonnull align 512 %c_copy_1, [4 x i12]* nonnull align 512 %c_copy_2, [4 x i12]* nonnull align 512 %c_copy_3)
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_0, i32 999, i32 1, i32 1, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_1, i32 999, i32 1, i32 1, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_2, i32 999, i32 1, i32 1, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_3, i32 999, i32 1, i32 1, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_0, i32 998, i32 1, i32 0, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_1, i32 998, i32 1, i32 0, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_2, i32 998, i32 1, i32 0, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_3, i32 998, i32 1, i32 0, i1 false) ], !dbg !31
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_04, i32 999, i32 1, i32 1, i1 false) ], !dbg !174
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_15, i32 999, i32 1, i32 1, i1 false) ], !dbg !174
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_26, i32 999, i32 1, i32 1, i1 false) ], !dbg !174
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_37, i32 999, i32 1, i32 1, i1 false) ], !dbg !174
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_04, i32 998, i32 1, i32 0, i1 false) ], !dbg !174
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_15, i32 998, i32 1, i32 0, i1 false) ], !dbg !174
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_26, i32 998, i32 1, i32 0, i1 false) ], !dbg !174
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_37, i32 998, i32 1, i32 0, i1 false) ], !dbg !174
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i12* %_08, i32 999, i32 1, i32 1, i1 false) ], !dbg !175
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i12* %_19, i32 999, i32 1, i32 1, i1 false) ], !dbg !175
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i12* %_210, i32 999, i32 1, i32 1, i1 false) ], !dbg !175
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i12* %_311, i32 999, i32 1, i32 1, i1 false) ], !dbg !175
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i12* %_08, i32 998, i32 1, i32 0, i1 false) ], !dbg !175
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i12* %_19, i32 998, i32 1, i32 0, i1 false) ], !dbg !175
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i12* %_210, i32 998, i32 1, i32 0, i1 false) ], !dbg !175
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i12* %_311, i32 998, i32 1, i32 0, i1 false) ], !dbg !175
  call void @apatb_kernel_hw([4 x i8]* %a_copy_0, [4 x i8]* %a_copy_1, [4 x i8]* %a_copy_2, [4 x i8]* %a_copy_3, [4 x i8]* %b_copy_0, [4 x i8]* %b_copy_1, [4 x i8]* %b_copy_2, [4 x i8]* %b_copy_3, [4 x i12]* %c_copy_0, [4 x i12]* %c_copy_1, [4 x i12]* %c_copy_2, [4 x i12]* %c_copy_3)
  call void @copy_back([16 x %"struct.ap_int<8>"]* %0, [4 x i8]* %a_copy_0, [4 x i8]* %a_copy_1, [4 x i8]* %a_copy_2, [4 x i8]* %a_copy_3, [16 x %"struct.ap_int<8>"]* %1, [4 x i8]* %b_copy_0, [4 x i8]* %b_copy_1, [4 x i8]* %b_copy_2, [4 x i8]* %b_copy_3, [16 x %"struct.ap_int<12>"]* %2, [4 x i12]* %c_copy_0, [4 x i12]* %c_copy_1, [4 x i12]* %c_copy_2, [4 x i12]* %c_copy_3)
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
define void @"arraycpy_hls.p0a16struct.ap_int<12>"([4 x i12]* nocapture "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [4 x i12]* nocapture "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [4 x i12]* nocapture "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [4 x i12]* nocapture "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [16 x %"struct.ap_int<12>"]* readonly "orig.arg.no"="1" "unpacked"="1" %src, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<12>"]* %src, null
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
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<12>"], [16 x %"struct.ap_int<12>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [4 x i12], [4 x i12]* %dst_0, i64 0, i64 %1
  %dst.addr.0.0.06_1 = getelementptr [4 x i12], [4 x i12]* %dst_1, i64 0, i64 %1
  %dst.addr.0.0.06_2 = getelementptr [4 x i12], [4 x i12]* %dst_2, i64 0, i64 %1
  %dst.addr.0.0.06_3 = getelementptr [4 x i12], [4 x i12]* %dst_3, i64 0, i64 %1
  %3 = bitcast i12* %src.addr.0.0.05 to i16*
  %4 = load i16, i16* %3
  %5 = trunc i16 %4 to i12
  switch i64 %2, label %dst.addr.0.0.06.case.3 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
  ]

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i12 %5, i12* %dst.addr.0.0.06_0, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  store i12 %5, i12* %dst.addr.0.0.06_1, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.2:                           ; preds = %for.loop
  store i12 %5, i12* %dst.addr.0.0.06_2, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.3:                           ; preds = %for.loop
  %6 = icmp eq i64 %2, 3
  call void @llvm.assume(i1 %6)
  store i12 %5, i12* %dst.addr.0.0.06_3, align 2
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
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<12>"([4 x i12]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [4 x i12]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [4 x i12]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.2" %dst_2, [4 x i12]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.3" %dst_3, [16 x %"struct.ap_int<12>"]* noalias readonly "orig.arg.no"="1" "unpacked"="1" %src) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<12>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<12>"([4 x i12]* %dst_0, [4 x i12]* %dst_1, [4 x i12]* %dst_2, [4 x i12]* %dst_3, [16 x %"struct.ap_int<12>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_in([16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="0" "unpacked"="0", [4 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="2" "unpacked"="2", [4 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [4 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [16 x %"struct.ap_int<12>"]* noalias readonly "orig.arg.no"="4" "unpacked"="4", [4 x i12]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_05, [4 x i12]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_16, [4 x i12]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_27, [4 x i12]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_38) #5 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([4 x i8]* align 512 %_0, [4 x i8]* align 512 %_1, [4 x i8]* align 512 %_2, [4 x i8]* align 512 %_3, [16 x %"struct.ap_int<8>"]* %0)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([4 x i8]* align 512 %_01, [4 x i8]* align 512 %_12, [4 x i8]* align 512 %_23, [4 x i8]* align 512 %_34, [16 x %"struct.ap_int<8>"]* %1)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<12>"([4 x i12]* align 512 %_05, [4 x i12]* align 512 %_16, [4 x i12]* align 512 %_27, [4 x i12]* align 512 %_38, [16 x %"struct.ap_int<12>"]* %2)
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
define void @"arraycpy_hls.p0a16struct.ap_int<12>.8"([16 x %"struct.ap_int<12>"]* "orig.arg.no"="0" "unpacked"="0" %dst, [4 x i12]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [4 x i12]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [4 x i12]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [4 x i12]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.3" %src_3, i64 "orig.arg.no"="2" "unpacked"="2" %num) #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<12>"]* %dst, null
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
  %src.addr.0.0.05_0 = getelementptr [4 x i12], [4 x i12]* %src_0, i64 0, i64 %1
  %src.addr.0.0.05_1 = getelementptr [4 x i12], [4 x i12]* %src_1, i64 0, i64 %1
  %src.addr.0.0.05_2 = getelementptr [4 x i12], [4 x i12]* %src_2, i64 0, i64 %1
  %src.addr.0.0.05_3 = getelementptr [4 x i12], [4 x i12]* %src_3, i64 0, i64 %1
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<12>"], [16 x %"struct.ap_int<12>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %2, label %src.addr.0.0.05.case.3 [
    i64 0, label %src.addr.0.0.05.case.0
    i64 1, label %src.addr.0.0.05.case.1
    i64 2, label %src.addr.0.0.05.case.2
  ]

src.addr.0.0.05.case.0:                           ; preds = %for.loop
  %3 = bitcast i12* %src.addr.0.0.05_0 to i16*
  %4 = load i16, i16* %3
  %5 = trunc i16 %4 to i12
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.1:                           ; preds = %for.loop
  %6 = bitcast i12* %src.addr.0.0.05_1 to i16*
  %7 = load i16, i16* %6
  %8 = trunc i16 %7 to i12
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.2:                           ; preds = %for.loop
  %9 = bitcast i12* %src.addr.0.0.05_2 to i16*
  %10 = load i16, i16* %9
  %11 = trunc i16 %10 to i12
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.3:                           ; preds = %for.loop
  %12 = icmp eq i64 %2, 3
  call void @llvm.assume(i1 %12)
  %13 = bitcast i12* %src.addr.0.0.05_3 to i16*
  %14 = load i16, i16* %13
  %15 = trunc i16 %14 to i12
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %16 = phi i12 [ %5, %src.addr.0.0.05.case.0 ], [ %8, %src.addr.0.0.05.case.1 ], [ %11, %src.addr.0.0.05.case.2 ], [ %15, %src.addr.0.0.05.case.3 ]
  store i12 %16, i12* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<12>.5"([16 x %"struct.ap_int<12>"]* noalias "orig.arg.no"="0" "unpacked"="0" %dst, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %src_2, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %src_3) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<12>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<12>.8"([16 x %"struct.ap_int<12>"]* nonnull %dst, [4 x i12]* %src_0, [4 x i12]* %src_1, [4 x i12]* %src_2, [4 x i12]* %src_3, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_out([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0", [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="2" "unpacked"="2", [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [16 x %"struct.ap_int<12>"]* noalias "orig.arg.no"="4" "unpacked"="4", [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_05, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_16, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_27, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_38) #6 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %0, [4 x i8]* align 512 %_0, [4 x i8]* align 512 %_1, [4 x i8]* align 512 %_2, [4 x i8]* align 512 %_3)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %1, [4 x i8]* align 512 %_01, [4 x i8]* align 512 %_12, [4 x i8]* align 512 %_23, [4 x i8]* align 512 %_34)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<12>.5"([16 x %"struct.ap_int<12>"]* %2, [4 x i12]* align 512 %_05, [4 x i12]* align 512 %_16, [4 x i12]* align 512 %_27, [4 x i12]* align 512 %_38)
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_kernel_hw([4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i12]*, [4 x i12]*, [4 x i12]*, [4 x i12]*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_back([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0", [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.2" %_2, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.3" %_3, [16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="2" "unpacked"="2", [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.2" %_23, [4 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.3" %_34, [16 x %"struct.ap_int<12>"]* noalias "orig.arg.no"="4" "unpacked"="4", [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_05, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_16, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.2" %_27, [4 x i12]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.3" %_38) #6 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<12>.5"([16 x %"struct.ap_int<12>"]* %2, [4 x i12]* align 512 %_05, [4 x i12]* align 512 %_16, [4 x i12]* align 512 %_27, [4 x i12]* align 512 %_38)
  ret void
}

declare void @kernel_hw_stub(%"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<12>"* noalias nocapture nonnull)

define void @kernel_hw_stub_wrapper([4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i12]*, [4 x i12]*, [4 x i12]*, [4 x i12]*) #7 {
entry:
  %12 = call i8* @malloc(i64 16)
  %13 = bitcast i8* %12 to [16 x %"struct.ap_int<8>"]*
  %14 = call i8* @malloc(i64 16)
  %15 = bitcast i8* %14 to [16 x %"struct.ap_int<8>"]*
  %16 = call i8* @malloc(i64 32)
  %17 = bitcast i8* %16 to [16 x %"struct.ap_int<12>"]*
  call void @copy_out([16 x %"struct.ap_int<8>"]* %13, [4 x i8]* %0, [4 x i8]* %1, [4 x i8]* %2, [4 x i8]* %3, [16 x %"struct.ap_int<8>"]* %15, [4 x i8]* %4, [4 x i8]* %5, [4 x i8]* %6, [4 x i8]* %7, [16 x %"struct.ap_int<12>"]* %17, [4 x i12]* %8, [4 x i12]* %9, [4 x i12]* %10, [4 x i12]* %11)
  %18 = bitcast [16 x %"struct.ap_int<8>"]* %13 to %"struct.ap_int<8>"*
  %19 = bitcast [16 x %"struct.ap_int<8>"]* %15 to %"struct.ap_int<8>"*
  %20 = bitcast [16 x %"struct.ap_int<12>"]* %17 to %"struct.ap_int<12>"*
  call void @kernel_hw_stub(%"struct.ap_int<8>"* %18, %"struct.ap_int<8>"* %19, %"struct.ap_int<12>"* %20)
  call void @copy_in([16 x %"struct.ap_int<8>"]* %13, [4 x i8]* %0, [4 x i8]* %1, [4 x i8]* %2, [4 x i8]* %3, [16 x %"struct.ap_int<8>"]* %15, [4 x i8]* %4, [4 x i8]* %5, [4 x i8]* %6, [4 x i8]* %7, [16 x %"struct.ap_int<12>"]* %17, [4 x i12]* %8, [4 x i12]* %9, [4 x i12]* %10, [4 x i12]* %11)
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
!25 = !{!"2.0", [16 x i12]* null}
!26 = !{!27, !28, !29, !30}
!27 = !{!"2.0.0", [4 x i12]* null}
!28 = !{!"2.0.1", [4 x i12]* null}
!29 = !{!"2.0.2", [4 x i12]* null}
!30 = !{!"2.0.3", [4 x i12]* null}
!31 = !DILocation(line: 14, column: 9, scope: !32)
!32 = distinct !DISubprogram(name: "kernel", linkageName: "_Z6kernelP6ap_intILi8EES1_PS_ILi12EE", scope: !33, file: !33, line: 5, type: !34, isLocal: false, isDefinition: true, scopeLine: 5, flags: DIFlagPrototyped, isOptimized: false, unit: !144, variables: !4)
!33 = !DIFile(filename: "kernel.cpp", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/resource_efficient_int12_p4")
!34 = !DISubroutineType(types: !35)
!35 = !{null, !36, !36, !96}
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int<8>", file: !38, line: 18, size: 8, flags: DIFlagTypePassByValue, elements: !39, templateParams: !95, identifier: "_ZTS6ap_intILi8EE")
!38 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/ap_int.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/resource_efficient_int12_p4")
!39 = !{!40, !75, !80, !84, !89}
!40 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !37, baseType: !41)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<8, true>", file: !42, line: 124, size: 8, flags: DIFlagTypePassByValue, elements: !43, templateParams: !73, identifier: "_ZTS11ap_int_baseILi8ELb1EE")
!42 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_int_base.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/resource_efficient_int12_p4")
!43 = !{!44, !62, !64, !66}
!44 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !41, baseType: !45)
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<8, true>", file: !46, line: 530, size: 8, flags: DIFlagTypePassByValue, elements: !47, templateParams: !57, identifier: "_ZTS8ssdm_intILi8ELb1EE")
!46 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_common.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/resource_efficient_int12_p4")
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
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int<12>", file: !38, line: 18, size: 16, flags: DIFlagTypePassByValue, elements: !98, templateParams: !143, identifier: "_ZTS6ap_intILi12EE")
!98 = !{!99, !127, !131, !134, !137}
!99 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !97, baseType: !100)
!100 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<12, true>", file: !42, line: 124, size: 16, flags: DIFlagTypePassByValue, elements: !101, templateParams: !125, identifier: "_ZTS11ap_int_baseILi12ELb1EE")
!101 = !{!102, !116, !117, !118}
!102 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !100, baseType: !103)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<12, true>", file: !46, line: 530, size: 16, flags: DIFlagTypePassByValue, elements: !104, templateParams: !114, identifier: "_ZTS8ssdm_intILi12ELb1EE")
!104 = !{!105, !107, !111}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !103, file: !46, line: 532, baseType: !106, size: 12, align: 16)
!106 = !DIBasicType(name: "int12", size: 12, encoding: DW_ATE_signed)
!107 = !DISubprogram(name: "ssdm_int", scope: !103, file: !46, line: 533, type: !108, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!108 = !DISubroutineType(types: !109)
!109 = !{null, !110}
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!111 = !DISubprogram(name: "ssdm_int", scope: !103, file: !46, line: 534, type: !112, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!112 = !DISubroutineType(types: !113)
!113 = !{null, !110, !106}
!114 = !{!115, !60}
!115 = !DITemplateValueParameter(name: "_AP_N", type: !59, value: i32 12)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !100, file: !42, line: 148, baseType: !63, flags: DIFlagStaticMember, extraData: i32 12)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !100, file: !42, line: 149, baseType: !65, flags: DIFlagStaticMember, extraData: i1 true)
!118 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi12ELb1EEaSERKS0_", scope: !100, file: !42, line: 479, type: !119, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!119 = !DISubroutineType(types: !120)
!120 = !{!121, !122, !123}
!121 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !100, size: 64)
!122 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!123 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !124, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !100)
!125 = !{!126, !60}
!126 = !DITemplateValueParameter(name: "_AP_W", type: !59, value: i32 12)
!127 = !DISubprogram(name: "ap_int", scope: !97, file: !38, line: 142, type: !128, isLocal: false, isDefinition: false, scopeLine: 142, flags: DIFlagPrototyped, isOptimized: false)
!128 = !DISubroutineType(types: !129)
!129 = !{null, !130, !79}
!130 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!131 = !DISubprogram(name: "ap_int", scope: !97, file: !38, line: 143, type: !132, isLocal: false, isDefinition: false, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false)
!132 = !DISubroutineType(types: !133)
!133 = !{null, !130, !83}
!134 = !DISubprogram(name: "ap_int", scope: !97, file: !38, line: 144, type: !135, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!135 = !DISubroutineType(types: !136)
!136 = !{null, !130, !87}
!137 = !DISubprogram(name: "operator=", linkageName: "_ZN6ap_intILi12EEaSERKS0_", scope: !97, file: !38, line: 154, type: !138, isLocal: false, isDefinition: false, scopeLine: 154, flags: DIFlagPrototyped, isOptimized: false)
!138 = !DISubroutineType(types: !139)
!139 = !{!140, !130, !141}
!140 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !97, size: 64)
!141 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !142, size: 64)
!142 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !97)
!143 = !{!126}
!144 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !145, producer: "clang version 7.0.0 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !146)
!145 = !DIFile(filename: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/resource_efficient_int12_p4/work/hls/.autopilot/db/kernel.pp.0.cpp", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/resource_efficient_int12_p4")
!146 = !{!147}
!147 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<9, true>", file: !42, line: 124, size: 16, flags: DIFlagTypePassByValue, elements: !148, templateParams: !172, identifier: "_ZTS11ap_int_baseILi9ELb1EE")
!148 = !{!149, !163, !164, !165}
!149 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !147, baseType: !150)
!150 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<9, true>", file: !46, line: 530, size: 16, flags: DIFlagTypePassByValue, elements: !151, templateParams: !161, identifier: "_ZTS8ssdm_intILi9ELb1EE")
!151 = !{!152, !154, !158}
!152 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !150, file: !46, line: 532, baseType: !153, size: 9, align: 16)
!153 = !DIBasicType(name: "int9", size: 9, encoding: DW_ATE_signed)
!154 = !DISubprogram(name: "ssdm_int", scope: !150, file: !46, line: 533, type: !155, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!155 = !DISubroutineType(types: !156)
!156 = !{null, !157}
!157 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!158 = !DISubprogram(name: "ssdm_int", scope: !150, file: !46, line: 534, type: !159, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!159 = !DISubroutineType(types: !160)
!160 = !{null, !157, !153}
!161 = !{!162, !60}
!162 = !DITemplateValueParameter(name: "_AP_N", type: !59, value: i32 9)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !147, file: !42, line: 148, baseType: !63, flags: DIFlagStaticMember, extraData: i32 9)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !147, file: !42, line: 149, baseType: !65, flags: DIFlagStaticMember, extraData: i1 true)
!165 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi9ELb1EEaSERKS0_", scope: !147, file: !42, line: 479, type: !166, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!166 = !DISubroutineType(types: !167)
!167 = !{!168, !169, !170}
!168 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !147, size: 64)
!169 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!170 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !171, size: 64)
!171 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !147)
!172 = !{!173, !60}
!173 = !DITemplateValueParameter(name: "_AP_W", type: !59, value: i32 9)
!174 = !DILocation(line: 15, column: 9, scope: !32)
!175 = !DILocation(line: 16, column: 9, scope: !32)
