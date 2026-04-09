; ModuleID = '/home/chengzhy/FormaSyn/formasyn/tests/vitis_hls_test/vec_dot/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_int<16>" = type { %"struct.ap_int_base<16, true>" }
%"struct.ap_int_base<16, true>" = type { %"struct.ssdm_int<16, true>" }
%"struct.ssdm_int<16, true>" = type { i16 }
%"struct.ap_int<40>" = type { %"struct.ap_int_base<40, true>" }
%"struct.ap_int_base<40, true>" = type { %"struct.ssdm_int<40, true>" }
%"struct.ssdm_int<40, true>" = type { i40 }

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_vec_dot_ir(%"struct.ap_int<16>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="8" %a, %"struct.ap_int<16>"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="8" %b, %"struct.ap_int<40>"* noalias nocapture nonnull %y) local_unnamed_addr #0 {
entry:
  %0 = bitcast %"struct.ap_int<16>"* %a to [8 x %"struct.ap_int<16>"]*
  %a_copy = alloca [8 x i16], align 512
  %1 = bitcast %"struct.ap_int<16>"* %b to [8 x %"struct.ap_int<16>"]*
  %b_copy = alloca [8 x i16], align 512
  %y_copy = alloca i40, align 512
  call fastcc void @copy_in([8 x %"struct.ap_int<16>"]* nonnull %0, [8 x i16]* nonnull align 512 %a_copy, [8 x %"struct.ap_int<16>"]* nonnull %1, [8 x i16]* nonnull align 512 %b_copy, %"struct.ap_int<40>"* nonnull %y, i40* nonnull align 512 %y_copy)
  call void @apatb_vec_dot_hw([8 x i16]* %a_copy, [8 x i16]* %b_copy, i40* %y_copy)
  call void @copy_back([8 x %"struct.ap_int<16>"]* %0, [8 x i16]* %a_copy, [8 x %"struct.ap_int<16>"]* %1, [8 x i16]* %b_copy, %"struct.ap_int<40>"* %y, i40* %y_copy)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_in([8 x %"struct.ap_int<16>"]* noalias readonly "unpacked"="0", [8 x i16]* noalias nocapture align 512 "unpacked"="1.0", [8 x %"struct.ap_int<16>"]* noalias readonly "unpacked"="2", [8 x i16]* noalias nocapture align 512 "unpacked"="3.0", %"struct.ap_int<40>"* noalias readonly "unpacked"="4", i40* noalias nocapture align 512 "unpacked"="5.0") unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a8struct.ap_int<16>"([8 x i16]* align 512 %1, [8 x %"struct.ap_int<16>"]* %0)
  call fastcc void @"onebyonecpy_hls.p0a8struct.ap_int<16>"([8 x i16]* align 512 %3, [8 x %"struct.ap_int<16>"]* %2)
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<40>"(i40* align 512 %5, %"struct.ap_int<40>"* %4)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a8struct.ap_int<16>"([8 x %"struct.ap_int<16>"]* %dst, [8 x %"struct.ap_int<16>"]* readonly %src, i64 %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [8 x %"struct.ap_int<16>"]* %src, null
  %1 = icmp eq [8 x %"struct.ap_int<16>"]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond7 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond7, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx8 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [8 x %"struct.ap_int<16>"], [8 x %"struct.ap_int<16>"]* %src, i64 0, i64 %for.loop.idx8, i32 0, i32 0, i32 0
  %dst.addr.0.0.06 = getelementptr [8 x %"struct.ap_int<16>"], [8 x %"struct.ap_int<16>"]* %dst, i64 0, i64 %for.loop.idx8, i32 0, i32 0, i32 0
  %3 = load i16, i16* %src.addr.0.0.05, align 2
  store i16 %3, i16* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx8, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0struct.ap_int<40>"(i40* noalias nocapture align 512 "unpacked"="0.0" %dst, %"struct.ap_int<40>"* noalias readonly "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"struct.ap_int<40>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %src.0.0.03 = getelementptr %"struct.ap_int<40>", %"struct.ap_int<40>"* %src, i64 0, i32 0, i32 0, i32 0
  %1 = load i40, i40* %src.0.0.03, align 8
  store i40 %1, i40* %dst, align 512
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_out([8 x %"struct.ap_int<16>"]* noalias "unpacked"="0", [8 x i16]* noalias nocapture readonly align 512 "unpacked"="1.0", [8 x %"struct.ap_int<16>"]* noalias "unpacked"="2", [8 x i16]* noalias nocapture readonly align 512 "unpacked"="3.0", %"struct.ap_int<40>"* noalias "unpacked"="4", i40* noalias nocapture readonly align 512 "unpacked"="5.0") unnamed_addr #4 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a8struct.ap_int<16>.18"([8 x %"struct.ap_int<16>"]* %0, [8 x i16]* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0a8struct.ap_int<16>.18"([8 x %"struct.ap_int<16>"]* %2, [8 x i16]* align 512 %3)
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<40>.4"(%"struct.ap_int<40>"* %4, i40* align 512 %5)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0struct.ap_int<40>.4"(%"struct.ap_int<40>"* noalias "unpacked"="0" %dst, i40* noalias nocapture readonly align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"struct.ap_int<40>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %dst.0.0.04 = getelementptr %"struct.ap_int<40>", %"struct.ap_int<40>"* %dst, i64 0, i32 0, i32 0, i32 0
  %1 = load i40, i40* %src, align 512
  store i40 %1, i40* %dst.0.0.04, align 8
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a8struct.ap_int<16>"([8 x i16]* noalias nocapture align 512 "unpacked"="0.0" %dst, [8 x %"struct.ap_int<16>"]* noalias readonly "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq [8 x %"struct.ap_int<16>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a8struct.ap_int<16>.14"([8 x i16]* %dst, [8 x %"struct.ap_int<16>"]* nonnull %src, i64 8)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a8struct.ap_int<16>.14"([8 x i16]* nocapture "unpacked"="0.0" %dst, [8 x %"struct.ap_int<16>"]* readonly "unpacked"="1" %src, i64 "unpacked"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [8 x %"struct.ap_int<16>"]* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [8 x %"struct.ap_int<16>"], [8 x %"struct.ap_int<16>"]* %src, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06 = getelementptr [8 x i16], [8 x i16]* %dst, i64 0, i64 %for.loop.idx2
  %1 = load i16, i16* %src.addr.0.0.05, align 2
  store i16 %1, i16* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a8struct.ap_int<16>.18"([8 x %"struct.ap_int<16>"]* noalias "unpacked"="0" %dst, [8 x i16]* noalias nocapture readonly align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq [8 x %"struct.ap_int<16>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a8struct.ap_int<16>.21"([8 x %"struct.ap_int<16>"]* nonnull %dst, [8 x i16]* %src, i64 8)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a8struct.ap_int<16>.21"([8 x %"struct.ap_int<16>"]* "unpacked"="0" %dst, [8 x i16]* nocapture readonly "unpacked"="1.0" %src, i64 "unpacked"="2" %num) local_unnamed_addr #2 {
entry:
  %0 = icmp eq [8 x %"struct.ap_int<16>"]* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.05 = getelementptr [8 x i16], [8 x i16]* %src, i64 0, i64 %for.loop.idx2
  %dst.addr.0.0.06 = getelementptr [8 x %"struct.ap_int<16>"], [8 x %"struct.ap_int<16>"]* %dst, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %1 = load i16, i16* %src.addr.0.0.05, align 2
  store i16 %1, i16* %dst.addr.0.0.06, align 2
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

declare void @apatb_vec_dot_hw([8 x i16]*, [8 x i16]*, i40*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_back([8 x %"struct.ap_int<16>"]* noalias "unpacked"="0", [8 x i16]* noalias nocapture readonly align 512 "unpacked"="1.0", [8 x %"struct.ap_int<16>"]* noalias "unpacked"="2", [8 x i16]* noalias nocapture readonly align 512 "unpacked"="3.0", %"struct.ap_int<40>"* noalias "unpacked"="4", i40* noalias nocapture readonly align 512 "unpacked"="5.0") unnamed_addr #4 {
entry:
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<40>.4"(%"struct.ap_int<40>"* %4, i40* align 512 %5)
  ret void
}

declare void @vec_dot_hw_stub(%"struct.ap_int<16>"* noalias nocapture nonnull readonly, %"struct.ap_int<16>"* noalias nocapture nonnull readonly, %"struct.ap_int<40>"* noalias nocapture nonnull)

define void @vec_dot_hw_stub_wrapper([8 x i16]*, [8 x i16]*, i40*) #5 {
entry:
  %3 = call i8* @malloc(i64 16)
  %4 = bitcast i8* %3 to [8 x %"struct.ap_int<16>"]*
  %5 = call i8* @malloc(i64 16)
  %6 = bitcast i8* %5 to [8 x %"struct.ap_int<16>"]*
  %7 = call i8* @malloc(i64 8)
  %8 = bitcast i8* %7 to %"struct.ap_int<40>"*
  call void @copy_out([8 x %"struct.ap_int<16>"]* %4, [8 x i16]* %0, [8 x %"struct.ap_int<16>"]* %6, [8 x i16]* %1, %"struct.ap_int<40>"* %8, i40* %2)
  %9 = bitcast [8 x %"struct.ap_int<16>"]* %4 to %"struct.ap_int<16>"*
  %10 = bitcast [8 x %"struct.ap_int<16>"]* %6 to %"struct.ap_int<16>"*
  call void @vec_dot_hw_stub(%"struct.ap_int<16>"* %9, %"struct.ap_int<16>"* %10, %"struct.ap_int<40>"* %8)
  call void @copy_in([8 x %"struct.ap_int<16>"]* %4, [8 x i16]* %0, [8 x %"struct.ap_int<16>"]* %6, [8 x i16]* %1, %"struct.ap_int<40>"* %8, i40* %2)
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
