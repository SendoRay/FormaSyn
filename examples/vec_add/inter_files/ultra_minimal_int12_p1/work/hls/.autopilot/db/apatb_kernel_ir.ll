; ModuleID = '/home/chengzhy/FormaSyn/examples/vec_add/inter_files/ultra_minimal_int12_p1/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_int<8>" = type { %"struct.ap_int_base<8, true>" }
%"struct.ap_int_base<8, true>" = type { %"struct.ssdm_int<8, true>" }
%"struct.ssdm_int<8, true>" = type { i8 }
%"struct.ap_int<12>" = type { %"struct.ap_int_base<12, true>" }
%"struct.ap_int_base<12, true>" = type { %"struct.ssdm_int<12, true>" }
%"struct.ssdm_int<12, true>" = type { i12 }

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_kernel_ir(%"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" %a, %"struct.ap_int<8>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" "maxi" %b, %"struct.ap_int<12>"* noalias nocapture nonnull "fpga.decayed.dim.hint"="16" "maxi" %c) local_unnamed_addr #0 {
entry:
  %0 = bitcast %"struct.ap_int<8>"* %a to [16 x %"struct.ap_int<8>"]*
  %a_copy = alloca [16 x i8], align 512
  %1 = bitcast %"struct.ap_int<8>"* %b to [16 x %"struct.ap_int<8>"]*
  %b_copy = alloca [16 x i8], align 512
  %2 = bitcast %"struct.ap_int<12>"* %c to [16 x %"struct.ap_int<12>"]*
  %c_copy = alloca [16 x i12], align 512
  call fastcc void @copy_in([16 x %"struct.ap_int<8>"]* nonnull %0, [16 x i8]* nonnull align 512 %a_copy, [16 x %"struct.ap_int<8>"]* nonnull %1, [16 x i8]* nonnull align 512 %b_copy, [16 x %"struct.ap_int<12>"]* nonnull %2, [16 x i12]* nonnull align 512 %c_copy)
  call void @apatb_kernel_hw([16 x i8]* %a_copy, [16 x i8]* %b_copy, [16 x i12]* %c_copy)
  call void @copy_back([16 x %"struct.ap_int<8>"]* %0, [16 x i8]* %a_copy, [16 x %"struct.ap_int<8>"]* %1, [16 x i8]* %b_copy, [16 x %"struct.ap_int<12>"]* %2, [16 x i12]* %c_copy)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_in([16 x %"struct.ap_int<8>"]* noalias readonly "unpacked"="0", [16 x i8]* noalias nocapture align 512 "unpacked"="1.0", [16 x %"struct.ap_int<8>"]* noalias readonly "unpacked"="2", [16 x i8]* noalias nocapture align 512 "unpacked"="3.0", [16 x %"struct.ap_int<12>"]* noalias readonly "unpacked"="4", [16 x i12]* noalias nocapture align 512 "unpacked"="5.0") unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([16 x i8]* align 512 %1, [16 x %"struct.ap_int<8>"]* %0)
  call fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([16 x i8]* align 512 %3, [16 x %"struct.ap_int<8>"]* %2)
  call fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<12>"([16 x i12]* align 512 %5, [16 x %"struct.ap_int<12>"]* %4)
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

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<12>"([16 x i12]* noalias nocapture align 512 "unpacked"="0.0" %dst, [16 x %"struct.ap_int<12>"]* noalias readonly "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<12>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<12>"([16 x i12]* %dst, [16 x %"struct.ap_int<12>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<12>"([16 x i12]* nocapture "unpacked"="0.0" %dst, [16 x %"struct.ap_int<12>"]* readonly "unpacked"="1" %src, i64 "unpacked"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<12>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<12>"], [16 x %"struct.ap_int<12>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06 = getelementptr [16 x i12], [16 x i12]* %dst, i64 0, i64 %for.loop.idx2
  %1 = bitcast i12* %src.addr.0.0.05 to i16*
  %2 = load i16, i16* %1
  %3 = trunc i16 %2 to i12
  store i12 %3, i12* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_out([16 x %"struct.ap_int<8>"]* noalias "unpacked"="0", [16 x i8]* noalias nocapture readonly align 512 "unpacked"="1.0", [16 x %"struct.ap_int<8>"]* noalias "unpacked"="2", [16 x i8]* noalias nocapture readonly align 512 "unpacked"="3.0", [16 x %"struct.ap_int<12>"]* noalias "unpacked"="4", [16 x i12]* noalias nocapture readonly align 512 "unpacked"="5.0") unnamed_addr #4 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %0, [16 x i8]* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* %2, [16 x i8]* align 512 %3)
  call fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<12>.5"([16 x %"struct.ap_int<12>"]* %4, [16 x i12]* align 512 %5)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<12>.5"([16 x %"struct.ap_int<12>"]* noalias "unpacked"="0" %dst, [16 x i12]* noalias nocapture readonly align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<12>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<12>.8"([16 x %"struct.ap_int<12>"]* nonnull %dst, [16 x i12]* %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<12>.8"([16 x %"struct.ap_int<12>"]* "unpacked"="0" %dst, [16 x i12]* nocapture readonly "unpacked"="1.0" %src, i64 "unpacked"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<12>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [16 x i12], [16 x i12]* %src, i64 0, i64 %for.loop.idx2
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<12>"], [16 x %"struct.ap_int<12>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %1 = bitcast i12* %src.addr.0.0.05 to i16*
  %2 = load i16, i16* %1
  %3 = trunc i16 %2 to i12
  store i12 %3, i12* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<8>"([16 x i8]* noalias nocapture align 512 "unpacked"="0.0" %dst, [16 x %"struct.ap_int<8>"]* noalias readonly "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<8>.18"([16 x i8]* %dst, [16 x %"struct.ap_int<8>"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>.18"([16 x i8]* nocapture "unpacked"="0.0" %dst, [16 x %"struct.ap_int<8>"]* readonly "unpacked"="1" %src, i64 "unpacked"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06 = getelementptr [16 x i8], [16 x i8]* %dst, i64 0, i64 %for.loop.idx2
  %1 = load i8, i8* %src.addr.0.0.05, align 1
  store i8 %1, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<8>.22"([16 x %"struct.ap_int<8>"]* noalias "unpacked"="0" %dst, [16 x i8]* noalias nocapture readonly align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16struct.ap_int<8>.25"([16 x %"struct.ap_int<8>"]* nonnull %dst, [16 x i8]* %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16struct.ap_int<8>.25"([16 x %"struct.ap_int<8>"]* "unpacked"="0" %dst, [16 x i8]* nocapture readonly "unpacked"="1.0" %src, i64 "unpacked"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [16 x %"struct.ap_int<8>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [16 x i8], [16 x i8]* %src, i64 0, i64 %for.loop.idx2
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<8>"], [16 x %"struct.ap_int<8>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %1 = load i8, i8* %src.addr.0.0.05, align 1
  store i8 %1, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_kernel_hw([16 x i8]*, [16 x i8]*, [16 x i12]*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_back([16 x %"struct.ap_int<8>"]* noalias "unpacked"="0", [16 x i8]* noalias nocapture readonly align 512 "unpacked"="1.0", [16 x %"struct.ap_int<8>"]* noalias "unpacked"="2", [16 x i8]* noalias nocapture readonly align 512 "unpacked"="3.0", [16 x %"struct.ap_int<12>"]* noalias "unpacked"="4", [16 x i12]* noalias nocapture readonly align 512 "unpacked"="5.0") unnamed_addr #4 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a16struct.ap_int<12>.5"([16 x %"struct.ap_int<12>"]* %4, [16 x i12]* align 512 %5)
  ret void
}

declare void @kernel_hw_stub(%"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<8>"* noalias nocapture nonnull readonly, %"struct.ap_int<12>"* noalias nocapture nonnull)

define void @kernel_hw_stub_wrapper([16 x i8]*, [16 x i8]*, [16 x i12]*) #5 {
entry:
  %3 = call i8* @malloc(i64 16)
  %4 = bitcast i8* %3 to [16 x %"struct.ap_int<8>"]*
  %5 = call i8* @malloc(i64 16)
  %6 = bitcast i8* %5 to [16 x %"struct.ap_int<8>"]*
  %7 = call i8* @malloc(i64 32)
  %8 = bitcast i8* %7 to [16 x %"struct.ap_int<12>"]*
  call void @copy_out([16 x %"struct.ap_int<8>"]* %4, [16 x i8]* %0, [16 x %"struct.ap_int<8>"]* %6, [16 x i8]* %1, [16 x %"struct.ap_int<12>"]* %8, [16 x i12]* %2)
  %9 = bitcast [16 x %"struct.ap_int<8>"]* %4 to %"struct.ap_int<8>"*
  %10 = bitcast [16 x %"struct.ap_int<8>"]* %6 to %"struct.ap_int<8>"*
  %11 = bitcast [16 x %"struct.ap_int<12>"]* %8 to %"struct.ap_int<12>"*
  call void @kernel_hw_stub(%"struct.ap_int<8>"* %9, %"struct.ap_int<8>"* %10, %"struct.ap_int<12>"* %11)
  call void @copy_in([16 x %"struct.ap_int<8>"]* %4, [16 x i8]* %0, [16 x %"struct.ap_int<8>"]* %6, [16 x i8]* %1, [16 x %"struct.ap_int<12>"]* %8, [16 x i12]* %2)
  call void @free(i8* %3)
  call void @free(i8* %5)
  call void @free(i8* %7)
  ret void
}

attributes #0 = { inaccessiblemem_or_argmemonly noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
attributes #3 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #4 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyout" }
attributes #5 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
