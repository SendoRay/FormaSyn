; ModuleID = '/home/chengzhy/FormaSyn/examples/vec_add/inter_files/low_par_int14_p2/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_int<8>" = type { %"struct.ap_int_base<8, true>" }
%"struct.ap_int_base<8, true>" = type { %"struct.ssdm_int<8, true>" }
%"struct.ssdm_int<8, true>" = type { i8 }
%"struct.ap_int<14>" = type { %"struct.ap_int_base<14, true>" }
%"struct.ap_int_base<14, true>" = type { %"struct.ssdm_int<14, true>" }
%"struct.ssdm_int<14, true>" = type { i14 }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_kernel_ir(%"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" "partition" %a, %"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" "partition" %b, %"struct.ap_int<14>"* noalias nocapture nonnull "fpga.decayed.dim.hint"="16" "maxi" "partition" %c) local_unnamed_addr #1 {
entry:
  %0 = bitcast %"struct.ap_int<8>"* %a to [16 x %"struct.ap_int<8>"]*
  %a_copy_0 = alloca [8 x i8], align 512
  %a_copy_1 = alloca [8 x i8], align 512
  %_0 = getelementptr [8 x i8], [8 x i8]* %a_copy_0, i64 0, i64 0
  %_1 = getelementptr [8 x i8], [8 x i8]* %a_copy_1, i64 0, i64 0
  %1 = bitcast %"struct.ap_int<8>"* %b to [16 x %"struct.ap_int<8>"]*
  %b_copy_0 = alloca [8 x i8], align 512
  %b_copy_1 = alloca [8 x i8], align 512
  %_04 = getelementptr [8 x i8], [8 x i8]* %b_copy_0, i64 0, i64 0
  %_15 = getelementptr [8 x i8], [8 x i8]* %b_copy_1, i64 0, i64 0
  %2 = bitcast %"struct.ap_int<14>"* %c to [16 x %"struct.ap_int<14>"]*
  %c_copy_0 = alloca [8 x i14], align 512
  %c_copy_1 = alloca [8 x i14], align 512
  %_06 = getelementptr [8 x i14], [8 x i14]* %c_copy_0, i64 0, i64 0
  %_17 = getelementptr [8 x i14], [8 x i14]* %c_copy_1, i64 0, i64 0
  call void @copy_in([16 x %"struct.ap_int<8>"]* nonnull %0, [8 x i8]* nonnull align 512 %a_copy_0, [8 x i8]* nonnull align 512 %a_copy_1, [16 x %"struct.ap_int<8>"]* nonnull %1, [8 x i8]* nonnull align 512 %b_copy_0, [8 x i8]* nonnull align 512 %b_copy_1, [16 x %"struct.ap_int<14>"]* nonnull %2, [8 x i14]* nonnull align 512 %c_copy_0, [8 x i14]* nonnull align 512 %c_copy_1)
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_0, i32 999, i32 1, i32 1, i1 false) ], !dbg !25
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_1, i32 999, i32 1, i32 1, i1 false) ], !dbg !25
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_0, i32 998, i32 1, i32 0, i1 false) ], !dbg !25
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_1, i32 998, i32 1, i32 0, i1 false) ], !dbg !25
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_04, i32 999, i32 1, i32 1, i1 false) ], !dbg !168
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_15, i32 999, i32 1, i32 1, i1 false) ], !dbg !168
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_04, i32 998, i32 1, i32 0, i1 false) ], !dbg !168
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i8* %_15, i32 998, i32 1, i32 0, i1 false) ], !dbg !168
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i14* %_06, i32 999, i32 1, i32 1, i1 false) ], !dbg !169
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i14* %_17, i32 999, i32 1, i32 1, i1 false) ], !dbg !169
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i14* %_06, i32 998, i32 1, i32 0, i1 false) ], !dbg !169
  call void @llvm.sideeffect() #8 [ "xlx_array_partition"(i14* %_17, i32 998, i32 1, i32 0, i1 false) ], !dbg !169
  call void @apatb_kernel_hw([8 x i8]* %a_copy_0, [8 x i8]* %a_copy_1, [8 x i8]* %b_copy_0, [8 x i8]* %b_copy_1, [8 x i14]* %c_copy_0, [8 x i14]* %c_copy_1)
  call void @copy_back([16 x %"struct.ap_int<8>"]* %0, [8 x i8]* %a_copy_0, [8 x i8]* %a_copy_1, [16 x %"struct.ap_int<8>"]* %1, [8 x i8]* %b_copy_0, [8 x i8]* %b_copy_1, [16 x %"struct.ap_int<14>"]* %2, [8 x i14]* %c_copy_0, [8 x i14]* %c_copy_1)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>"([16 x %"struct.ap_int<8>"]* %dst, [16 x %"struct.ap_int<8>"]* readonly %src, i64 %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %src, null
  %1 = icmp eq [16 x %"struct.ap_int<8>"]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond7 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond7, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx8 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %src, i64 0, i64 %for.loop.idx8, i32 0, i32 0, i32 0
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %dst, i64 0, i64 %for.loop.idx8, i32 0, i32 0, i32 0
  %3 = load i8, i8* %src.addr.0.0.05, align 1
  store i8 %3, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx8, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #3

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>.18"([8 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [8 x i8]* nocapture "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [16 x %"struct.ap_int<8>"]* readonly "orig.arg.no"="1" "unpacked"="1" %src, i64 "orig.arg.no"="2" "unpacked"="2" %num) #2 {
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
  %1 = udiv i64 %for.loop.idx2, 2
  %2 = urem i64 %for.loop.idx2, 2
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [8 x i8], [8 x i8]* %dst_0, i64 0, i64 %1
  %dst.addr.0.0.06_1 = getelementptr [8 x i8], [8 x i8]* %dst_1, i64 0, i64 %1
  %3 = load i8, i8* %src.addr.0.0.05, align 1
  %cond = icmp eq i64 %2, 0
  br i1 %cond, label %dst.addr.0.0.06.case.0, label %dst.addr.0.0.06.case.1

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i8 %3, i8* %dst.addr.0.0.06_0, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  %4 = icmp eq i64 %2, 1
  call void @llvm.assume(i1 %4)
  store i8 %3, i8* %dst.addr.0.0.06_1, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([8 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [8 x i8]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="1" "unpacked"="1" %src) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<8>.18"([8 x i8]* %dst_0, [8 x i8]* %dst_1, [16 x %"struct.ap_int<8>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<14>"([8 x i14]* nocapture "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [8 x i14]* nocapture "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [16 x %"struct.ap_int<14>"]* readonly "orig.arg.no"="1" "unpacked"="1" %src, i64 "orig.arg.no"="2" "unpacked"="2" %num) #2 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<14>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %1 = udiv i64 %for.loop.idx2, 2
  %2 = urem i64 %for.loop.idx2, 2
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<14>"], [16 x %"struct.ap_int<14>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [8 x i14], [8 x i14]* %dst_0, i64 0, i64 %1
  %dst.addr.0.0.06_1 = getelementptr [8 x i14], [8 x i14]* %dst_1, i64 0, i64 %1
  %3 = bitcast i14* %src.addr.0.0.05 to i16*
  %4 = load i16, i16* %3
  %5 = trunc i16 %4 to i14
  %cond = icmp eq i64 %2, 0
  br i1 %cond, label %dst.addr.0.0.06.case.0, label %dst.addr.0.0.06.case.1

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i14 %5, i14* %dst.addr.0.0.06_0, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  %6 = icmp eq i64 %2, 1
  call void @llvm.assume(i1 %6)
  store i14 %5, i14* %dst.addr.0.0.06_1, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<14>"([8 x i14]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.0" %dst_0, [8 x i14]* noalias nocapture align 512 "orig.arg.no"="0" "unpacked"="0.0.1" %dst_1, [16 x %"struct.ap_int<14>"]* noalias readonly "orig.arg.no"="1" "unpacked"="1" %src) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<14>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<14>"([8 x i14]* %dst_0, [8 x i14]* %dst_1, [16 x %"struct.ap_int<14>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_in([16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="0" "unpacked"="0", [8 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [8 x i8]* noalias nocapture align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [16 x %"struct.ap_int<8>"]* noalias readonly "orig.arg.no"="2" "unpacked"="2", [8 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [8 x i8]* noalias nocapture align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [16 x %"struct.ap_int<14>"]* noalias readonly "orig.arg.no"="4" "unpacked"="4", [8 x i14]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_03, [8 x i14]* noalias nocapture align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_14) #5 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([8 x i8]* align 512 %_0, [8 x i8]* align 512 %_1, [16 x %"struct.ap_int<8>"]* %0)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([8 x i8]* align 512 %_01, [8 x i8]* align 512 %_12, [16 x %"struct.ap_int<8>"]* %1)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<14>"([8 x i14]* align 512 %_03, [8 x i14]* align 512 %_14, [16 x %"struct.ap_int<14>"]* %2)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>.25"([16 x %"struct.ap_int<8>"]* "orig.arg.no"="0" "unpacked"="0" %dst, [8 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [8 x i8]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, i64 "orig.arg.no"="2" "unpacked"="2" %num) #2 {
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
  %1 = udiv i64 %for.loop.idx2, 2
  %2 = urem i64 %for.loop.idx2, 2
  %src.addr.0.0.05_0 = getelementptr [8 x i8], [8 x i8]* %src_0, i64 0, i64 %1
  %src.addr.0.0.05_1 = getelementptr [8 x i8], [8 x i8]* %src_1, i64 0, i64 %1
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %cond = icmp eq i64 %2, 0
  br i1 %cond, label %src.addr.0.0.05.case.0, label %src.addr.0.0.05.case.1

src.addr.0.0.05.case.0:                           ; preds = %for.loop
  %_0 = load i8, i8* %src.addr.0.0.05_0, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.1:                           ; preds = %for.loop
  %3 = icmp eq i64 %2, 1
  call void @llvm.assume(i1 %3)
  %_1 = load i8, i8* %src.addr.0.0.05_1, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %4 = phi i8 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ]
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
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0" %dst, [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %src_1) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<8>.25"([16 x %"struct.ap_int<8>"]* nonnull %dst, [8 x i8]* %src_0, [8 x i8]* %src_1, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<14>.8"([16 x %"struct.ap_int<14>"]* "orig.arg.no"="0" "unpacked"="0" %dst, [8 x i14]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [8 x i14]* nocapture readonly "orig.arg.no"="1" "unpacked"="1.0.1" %src_1, i64 "orig.arg.no"="2" "unpacked"="2" %num) #2 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<14>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %1 = udiv i64 %for.loop.idx2, 2
  %2 = urem i64 %for.loop.idx2, 2
  %src.addr.0.0.05_0 = getelementptr [8 x i14], [8 x i14]* %src_0, i64 0, i64 %1
  %src.addr.0.0.05_1 = getelementptr [8 x i14], [8 x i14]* %src_1, i64 0, i64 %1
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<14>"], [16 x %"struct.ap_int<14>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %cond = icmp eq i64 %2, 0
  br i1 %cond, label %src.addr.0.0.05.case.0, label %src.addr.0.0.05.case.1

src.addr.0.0.05.case.0:                           ; preds = %for.loop
  %3 = bitcast i14* %src.addr.0.0.05_0 to i16*
  %4 = load i16, i16* %3
  %5 = trunc i16 %4 to i14
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.1:                           ; preds = %for.loop
  %6 = icmp eq i64 %2, 1
  call void @llvm.assume(i1 %6)
  %7 = bitcast i14* %src.addr.0.0.05_1 to i16*
  %8 = load i16, i16* %7
  %9 = trunc i16 %8 to i14
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %10 = phi i14 [ %5, %src.addr.0.0.05.case.0 ], [ %9, %src.addr.0.0.05.case.1 ]
  store i14 %10, i14* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @"onebyonecpy_hls.p0a16struct.ap_int<14>.5"([16 x %"struct.ap_int<14>"]* noalias "orig.arg.no"="0" "unpacked"="0" %dst, [8 x i14]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %src_0, [8 x i14]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %src_1) #4 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<14>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<14>.8"([16 x %"struct.ap_int<14>"]* nonnull %dst, [8 x i14]* %src_0, [8 x i14]* %src_1, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_out([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0", [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="2" "unpacked"="2", [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [16 x %"struct.ap_int<14>"]* noalias "orig.arg.no"="4" "unpacked"="4", [8 x i14]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_03, [8 x i14]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_14) #6 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %0, [8 x i8]* align 512 %_0, [8 x i8]* align 512 %_1)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %1, [8 x i8]* align 512 %_01, [8 x i8]* align 512 %_12)
  call void @"onebyonecpy_hls.p0a16struct.ap_int<14>.5"([16 x %"struct.ap_int<14>"]* %2, [8 x i14]* align 512 %_03, [8 x i14]* align 512 %_14)
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_kernel_hw([8 x i8]*, [8 x i8]*, [8 x i8]*, [8 x i8]*, [8 x i14]*, [8 x i14]*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal void @copy_back([16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="0" "unpacked"="0", [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.0" %_0, [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="1" "unpacked"="1.0.1" %_1, [16 x %"struct.ap_int<8>"]* noalias "orig.arg.no"="2" "unpacked"="2", [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.0" %_01, [8 x i8]* noalias nocapture readonly align 512 "orig.arg.no"="3" "unpacked"="3.0.1" %_12, [16 x %"struct.ap_int<14>"]* noalias "orig.arg.no"="4" "unpacked"="4", [8 x i14]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.0" %_03, [8 x i14]* noalias nocapture readonly align 512 "orig.arg.no"="5" "unpacked"="5.0.1" %_14) #6 {
entry:
  call void @"onebyonecpy_hls.p0a16struct.ap_int<14>.5"([16 x %"struct.ap_int<14>"]* %2, [8 x i14]* align 512 %_03, [8 x i14]* align 512 %_14)
  ret void
}

declare void @kernel_hw_stub(%"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<14>"* noalias nocapture nonnull)

define void @kernel_hw_stub_wrapper([8 x i8]*, [8 x i8]*, [8 x i8]*, [8 x i8]*, [8 x i14]*, [8 x i14]*) #7 {
entry:
  %6 = call i8* @malloc(i64 16)
  %7 = bitcast i8* %6 to [16 x %"struct.ap_int<8>"]*
  %8 = call i8* @malloc(i64 16)
  %9 = bitcast i8* %8 to [16 x %"struct.ap_int<8>"]*
  %10 = call i8* @malloc(i64 32)
  %11 = bitcast i8* %10 to [16 x %"struct.ap_int<14>"]*
  call void @copy_out([16 x %"struct.ap_int<8>"]* %7, [8 x i8]* %0, [8 x i8]* %1, [16 x %"struct.ap_int<8>"]* %9, [8 x i8]* %2, [8 x i8]* %3, [16 x %"struct.ap_int<14>"]* %11, [8 x i14]* %4, [8 x i14]* %5)
  %12 = bitcast [16 x %"struct.ap_int<8>"]* %7 to %"struct.ap_int<8>"*
  %13 = bitcast [16 x %"struct.ap_int<8>"]* %9 to %"struct.ap_int<8>"*
  %14 = bitcast [16 x %"struct.ap_int<14>"]* %11 to %"struct.ap_int<14>"*
  call void @kernel_hw_stub(%"struct.ap_int<8>"* %12, %"struct.ap_int<8>"* %13, %"struct.ap_int<14>"* %14)
  call void @copy_in([16 x %"struct.ap_int<8>"]* %7, [8 x i8]* %0, [8 x i8]* %1, [16 x %"struct.ap_int<8>"]* %9, [8 x i8]* %2, [8 x i8]* %3, [16 x %"struct.ap_int<14>"]* %11, [8 x i14]* %4, [8 x i14]* %5)
  call void @free(i8* %6)
  call void @free(i8* %8)
  call void @free(i8* %10)
  ret void
}

attributes #0 = { inaccessiblememonly nounwind willreturn }
attributes #1 = { inaccessiblemem_or_argmemonly noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #2 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
attributes #3 = { nounwind willreturn }
attributes #4 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #5 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyin" }
attributes #6 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyout" }
attributes #7 = { "fpga.wrapper.func"="stub" }
attributes #8 = { inaccessiblememonly nounwind willreturn "xlx.source"="infer-from-pragma" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}
!datalayout.transforms.on.top = !{!5, !13, !19}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
!5 = !{!6, !8, !10}
!6 = !{!7}
!7 = !{!"0.0", [16 x i8]* null}
!8 = !{!9}
!9 = !{!"array_partition", !"type=Cyclic", !"dim=1", !"factor=2"}
!10 = !{!11, !12}
!11 = !{!"0.0.0", [8 x i8]* null}
!12 = !{!"0.0.1", [8 x i8]* null}
!13 = !{!14, !8, !16}
!14 = !{!15}
!15 = !{!"1.0", [16 x i8]* null}
!16 = !{!17, !18}
!17 = !{!"1.0.0", [8 x i8]* null}
!18 = !{!"1.0.1", [8 x i8]* null}
!19 = !{!20, !8, !22}
!20 = !{!21}
!21 = !{!"2.0", [16 x i14]* null}
!22 = !{!23, !24}
!23 = !{!"2.0.0", [8 x i14]* null}
!24 = !{!"2.0.1", [8 x i14]* null}
!25 = !DILocation(line: 14, column: 9, scope: !26)
!26 = distinct !DISubprogram(name: "kernel", linkageName: "_Z6kernelP6ap_intILi8EES1_PS_ILi14EE", scope: !27, file: !27, line: 5, type: !28, isLocal: false, isDefinition: true, scopeLine: 5, flags: DIFlagPrototyped, isOptimized: false, unit: !138, variables: !4)
!27 = !DIFile(filename: "kernel.cpp", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/low_par_int14_p2")
!28 = !DISubroutineType(types: !29)
!29 = !{null, !30, !30, !90}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int<8>", file: !32, line: 18, size: 8, flags: DIFlagTypePassByValue, elements: !33, templateParams: !89, identifier: "_ZTS6ap_intILi8EE")
!32 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/ap_int.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/low_par_int14_p2")
!33 = !{!34, !69, !74, !78, !83}
!34 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !31, baseType: !35)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<8, true>", file: !36, line: 124, size: 8, flags: DIFlagTypePassByValue, elements: !37, templateParams: !67, identifier: "_ZTS11ap_int_baseILi8ELb1EE")
!36 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_int_base.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/low_par_int14_p2")
!37 = !{!38, !56, !58, !60}
!38 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !35, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<8, true>", file: !40, line: 530, size: 8, flags: DIFlagTypePassByValue, elements: !41, templateParams: !51, identifier: "_ZTS8ssdm_intILi8ELb1EE")
!40 = !DIFile(filename: "/tools/Xilinx/2025.1/Vitis/common/technology/autopilot/etc/ap_common.h", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/low_par_int14_p2")
!41 = !{!42, !44, !48}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !39, file: !40, line: 532, baseType: !43, size: 8)
!43 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!44 = !DISubprogram(name: "ssdm_int", scope: !39, file: !40, line: 533, type: !45, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!45 = !DISubroutineType(types: !46)
!46 = !{null, !47}
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!48 = !DISubprogram(name: "ssdm_int", scope: !39, file: !40, line: 534, type: !49, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!49 = !DISubroutineType(types: !50)
!50 = !{null, !47, !43}
!51 = !{!52, !54}
!52 = !DITemplateValueParameter(name: "_AP_N", type: !53, value: i32 8)
!53 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!54 = !DITemplateValueParameter(name: "_AP_S", type: !55, value: i8 1)
!55 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !35, file: !36, line: 148, baseType: !57, flags: DIFlagStaticMember, extraData: i32 8)
!57 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !53)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !35, file: !36, line: 149, baseType: !59, flags: DIFlagStaticMember, extraData: i1 true)
!59 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !55)
!60 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi8ELb1EEaSERKS0_", scope: !35, file: !36, line: 479, type: !61, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!61 = !DISubroutineType(types: !62)
!62 = !{!63, !64, !65}
!63 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !35, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!65 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !66, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !35)
!67 = !{!68, !54}
!68 = !DITemplateValueParameter(name: "_AP_W", type: !53, value: i32 8)
!69 = !DISubprogram(name: "ap_int", scope: !31, file: !32, line: 142, type: !70, isLocal: false, isDefinition: false, scopeLine: 142, flags: DIFlagPrototyped, isOptimized: false)
!70 = !DISubroutineType(types: !71)
!71 = !{null, !72, !73}
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!73 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!74 = !DISubprogram(name: "ap_int", scope: !31, file: !32, line: 143, type: !75, isLocal: false, isDefinition: false, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false)
!75 = !DISubroutineType(types: !76)
!76 = !{null, !72, !77}
!77 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!78 = !DISubprogram(name: "ap_int", scope: !31, file: !32, line: 144, type: !79, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!79 = !DISubroutineType(types: !80)
!80 = !{null, !72, !81}
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "half", file: !40, line: 632, baseType: !82)
!82 = !DIBasicType(name: "__fp16", size: 16, encoding: DW_ATE_float)
!83 = !DISubprogram(name: "operator=", linkageName: "_ZN6ap_intILi8EEaSERKS0_", scope: !31, file: !32, line: 154, type: !84, isLocal: false, isDefinition: false, scopeLine: 154, flags: DIFlagPrototyped, isOptimized: false)
!84 = !DISubroutineType(types: !85)
!85 = !{!86, !72, !87}
!86 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !31, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !88, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !31)
!89 = !{!68}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int<14>", file: !32, line: 18, size: 16, flags: DIFlagTypePassByValue, elements: !92, templateParams: !137, identifier: "_ZTS6ap_intILi14EE")
!92 = !{!93, !121, !125, !128, !131}
!93 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !91, baseType: !94)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<14, true>", file: !36, line: 124, size: 16, flags: DIFlagTypePassByValue, elements: !95, templateParams: !119, identifier: "_ZTS11ap_int_baseILi14ELb1EE")
!95 = !{!96, !110, !111, !112}
!96 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !94, baseType: !97)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<14, true>", file: !40, line: 530, size: 16, flags: DIFlagTypePassByValue, elements: !98, templateParams: !108, identifier: "_ZTS8ssdm_intILi14ELb1EE")
!98 = !{!99, !101, !105}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !97, file: !40, line: 532, baseType: !100, size: 14, align: 16)
!100 = !DIBasicType(name: "int14", size: 14, encoding: DW_ATE_signed)
!101 = !DISubprogram(name: "ssdm_int", scope: !97, file: !40, line: 533, type: !102, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!102 = !DISubroutineType(types: !103)
!103 = !{null, !104}
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!105 = !DISubprogram(name: "ssdm_int", scope: !97, file: !40, line: 534, type: !106, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!106 = !DISubroutineType(types: !107)
!107 = !{null, !104, !100}
!108 = !{!109, !54}
!109 = !DITemplateValueParameter(name: "_AP_N", type: !53, value: i32 14)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !94, file: !36, line: 148, baseType: !57, flags: DIFlagStaticMember, extraData: i32 14)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !94, file: !36, line: 149, baseType: !59, flags: DIFlagStaticMember, extraData: i1 true)
!112 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi14ELb1EEaSERKS0_", scope: !94, file: !36, line: 479, type: !113, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!113 = !DISubroutineType(types: !114)
!114 = !{!115, !116, !117}
!115 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !94, size: 64)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!117 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !118, size: 64)
!118 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !94)
!119 = !{!120, !54}
!120 = !DITemplateValueParameter(name: "_AP_W", type: !53, value: i32 14)
!121 = !DISubprogram(name: "ap_int", scope: !91, file: !32, line: 142, type: !122, isLocal: false, isDefinition: false, scopeLine: 142, flags: DIFlagPrototyped, isOptimized: false)
!122 = !DISubroutineType(types: !123)
!123 = !{null, !124, !73}
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!125 = !DISubprogram(name: "ap_int", scope: !91, file: !32, line: 143, type: !126, isLocal: false, isDefinition: false, scopeLine: 143, flags: DIFlagPrototyped, isOptimized: false)
!126 = !DISubroutineType(types: !127)
!127 = !{null, !124, !77}
!128 = !DISubprogram(name: "ap_int", scope: !91, file: !32, line: 144, type: !129, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!129 = !DISubroutineType(types: !130)
!130 = !{null, !124, !81}
!131 = !DISubprogram(name: "operator=", linkageName: "_ZN6ap_intILi14EEaSERKS0_", scope: !91, file: !32, line: 154, type: !132, isLocal: false, isDefinition: false, scopeLine: 154, flags: DIFlagPrototyped, isOptimized: false)
!132 = !DISubroutineType(types: !133)
!133 = !{!134, !124, !135}
!134 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !91, size: 64)
!135 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !136, size: 64)
!136 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !91)
!137 = !{!120}
!138 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !139, producer: "clang version 7.0.0 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !140)
!139 = !DIFile(filename: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/low_par_int14_p2/work/hls/.autopilot/db/kernel.pp.0.cpp", directory: "/home/chengzhy/FormaSyn/examples/vec_add/inter_files/low_par_int14_p2")
!140 = !{!141}
!141 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ap_int_base<9, true>", file: !36, line: 124, size: 16, flags: DIFlagTypePassByValue, elements: !142, templateParams: !166, identifier: "_ZTS11ap_int_baseILi9ELb1EE")
!142 = !{!143, !157, !158, !159}
!143 = !DIDerivedType(tag: DW_TAG_inheritance, scope: !141, baseType: !144)
!144 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ssdm_int<9, true>", file: !40, line: 530, size: 16, flags: DIFlagTypePassByValue, elements: !145, templateParams: !155, identifier: "_ZTS8ssdm_intILi9ELb1EE")
!145 = !{!146, !148, !152}
!146 = !DIDerivedType(tag: DW_TAG_member, name: "V", scope: !144, file: !40, line: 532, baseType: !147, size: 9, align: 16)
!147 = !DIBasicType(name: "int9", size: 9, encoding: DW_ATE_signed)
!148 = !DISubprogram(name: "ssdm_int", scope: !144, file: !40, line: 533, type: !149, isLocal: false, isDefinition: false, scopeLine: 533, flags: DIFlagPrototyped, isOptimized: false)
!149 = !DISubroutineType(types: !150)
!150 = !{null, !151}
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !144, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!152 = !DISubprogram(name: "ssdm_int", scope: !144, file: !40, line: 534, type: !153, isLocal: false, isDefinition: false, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: false)
!153 = !DISubroutineType(types: !154)
!154 = !{null, !151, !147}
!155 = !{!156, !54}
!156 = !DITemplateValueParameter(name: "_AP_N", type: !53, value: i32 9)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !141, file: !36, line: 148, baseType: !57, flags: DIFlagStaticMember, extraData: i32 9)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "sign_flag", scope: !141, file: !36, line: 149, baseType: !59, flags: DIFlagStaticMember, extraData: i1 true)
!159 = !DISubprogram(name: "operator=", linkageName: "_ZN11ap_int_baseILi9ELb1EEaSERKS0_", scope: !141, file: !36, line: 479, type: !160, isLocal: false, isDefinition: false, scopeLine: 479, flags: DIFlagPrototyped, isOptimized: false)
!160 = !DISubroutineType(types: !161)
!161 = !{!162, !163, !164}
!162 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !141, size: 64)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !141, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!164 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !165, size: 64)
!165 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !141)
!166 = !{!167, !54}
!167 = !DITemplateValueParameter(name: "_AP_W", type: !53, value: i32 9)
!168 = !DILocation(line: 15, column: 9, scope: !26)
!169 = !DILocation(line: 16, column: 9, scope: !26)
