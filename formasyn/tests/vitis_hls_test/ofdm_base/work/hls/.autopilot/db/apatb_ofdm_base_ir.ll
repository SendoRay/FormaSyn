; ModuleID = '/home/chengzhy/FormaSyn/formasyn/tests/vitis_hls_test/ofdm_base/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >" = type { %"struct.ap_fixed<16, 3, AP_TRN, AP_WRAP, 0>", %"struct.ap_fixed<16, 3, AP_TRN, AP_WRAP, 0>" }
%"struct.ap_fixed<16, 3, AP_TRN, AP_WRAP, 0>" = type { %"struct.ap_fixed_base<16, 3, true, AP_TRN, AP_WRAP, 0>" }
%"struct.ap_fixed_base<16, 3, true, AP_TRN, AP_WRAP, 0>" = type { %"struct.ssdm_int<16, true>" }
%"struct.ssdm_int<16, true>" = type { i16 }

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_ofdm_base_ir(%"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"* noalias nocapture nonnull readonly "fpga.decayed.dim.hint"="16" %in, %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"* noalias nocapture nonnull "fpga.decayed.dim.hint"="20" %out) local_unnamed_addr #0 {
entry:
  %0 = bitcast %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"* %in to [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]*
  %in_copy = alloca [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], align 512
  %1 = bitcast %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"* %out to [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]*
  %out_copy = alloca [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], align 512
  call fastcc void @copy_in([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* nonnull %0, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* nonnull align 512 %in_copy, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* nonnull %1, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* nonnull align 512 %out_copy)
  call void @apatb_ofdm_base_hw([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %in_copy, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %out_copy)
  call void @copy_back([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %0, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %in_copy, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %1, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %out_copy)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_in([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias readonly, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias align 512, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias readonly, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias align 512) unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a16class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* align 512 %1, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %0)
  call fastcc void @"onebyonecpy_hls.p0a20class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* align 512 %3, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %2)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a16class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias align 512 %dst, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias readonly %src) unnamed_addr #2 {
entry:
  %0 = icmp eq [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, null
  %1 = icmp eq [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a16class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* nonnull %dst, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* nonnull %src, i64 16)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a16class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* readonly %src, i64 %num) local_unnamed_addr #3 {
entry:
  %0 = icmp eq [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %src, null
  %1 = icmp eq [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond17 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond17, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx18 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.0.07 = getelementptr [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %src, i64 0, i64 %for.loop.idx18, i32 0, i32 0, i32 0, i32 0
  %dst.addr.0.0.0.08 = getelementptr [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, i64 0, i64 %for.loop.idx18, i32 0, i32 0, i32 0, i32 0
  %3 = load i16, i16* %src.addr.0.0.0.07, align 2
  store i16 %3, i16* %dst.addr.0.0.0.08, align 2
  %src.addr.1.0.0.015 = getelementptr [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %src, i64 0, i64 %for.loop.idx18, i32 1, i32 0, i32 0, i32 0
  %dst.addr.1.0.0.016 = getelementptr [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, i64 0, i64 %for.loop.idx18, i32 1, i32 0, i32 0, i32 0
  %4 = load i16, i16* %src.addr.1.0.0.015, align 2
  store i16 %4, i16* %dst.addr.1.0.0.016, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx18, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0a20class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias align 512 %dst, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias readonly %src) unnamed_addr #2 {
entry:
  %0 = icmp eq [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, null
  %1 = icmp eq [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %src, null
  %2 = or i1 %0, %1
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  call void @"arraycpy_hls.p0a20class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* nonnull %dst, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* nonnull %src, i64 20)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define void @"arraycpy_hls.p0a20class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* readonly %src, i64 %num) local_unnamed_addr #3 {
entry:
  %0 = icmp eq [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %src, null
  %1 = icmp eq [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, null
  %2 = or i1 %1, %0
  br i1 %2, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond17 = icmp sgt i64 %num, 0
  br i1 %for.loop.cond17, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %for.loop, %for.loop.lr.ph
  %for.loop.idx18 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %for.loop ]
  %src.addr.0.0.0.07 = getelementptr [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %src, i64 0, i64 %for.loop.idx18, i32 0, i32 0, i32 0, i32 0
  %dst.addr.0.0.0.08 = getelementptr [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, i64 0, i64 %for.loop.idx18, i32 0, i32 0, i32 0, i32 0
  %3 = load i16, i16* %src.addr.0.0.0.07, align 2
  store i16 %3, i16* %dst.addr.0.0.0.08, align 2
  %src.addr.1.0.0.015 = getelementptr [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %src, i64 0, i64 %for.loop.idx18, i32 1, i32 0, i32 0, i32 0
  %dst.addr.1.0.0.016 = getelementptr [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"], [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %dst, i64 0, i64 %for.loop.idx18, i32 1, i32 0, i32 0, i32 0
  %4 = load i16, i16* %src.addr.1.0.0.015, align 2
  store i16 %4, i16* %dst.addr.1.0.0.016, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx18, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %num
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %for.loop, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_out([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias readonly align 512, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias readonly align 512) unnamed_addr #4 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a16class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %0, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0a20class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %2, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* align 512 %3)
  ret void
}

declare void @apatb_ofdm_base_hw([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]*, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_back([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias readonly align 512, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* noalias readonly align 512) unnamed_addr #4 {
entry:
  call fastcc void @"onebyonecpy_hls.p0a20class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"([20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %2, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* align 512 %3)
  ret void
}

declare void @ofdm_base_hw_stub(%"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"* noalias nocapture nonnull readonly, %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"* noalias nocapture nonnull)

define void @ofdm_base_hw_stub_wrapper([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]*, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]*) #5 {
entry:
  call void @copy_out([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* null, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %0, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* null, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %1)
  %2 = bitcast [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %0 to %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"*
  %3 = bitcast [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %1 to %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"*
  call void @ofdm_base_hw_stub(%"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"* %2, %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"* %3)
  call void @copy_in([16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* null, [16 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %0, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* null, [20 x %"class.std::complex<ap_fixed<16, 3, AP_TRN, AP_WRAP, 0> >"]* %1)
  ret void
}

attributes #0 = { inaccessiblemem_or_argmemonly noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #3 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="arraycpy_hls" }
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
