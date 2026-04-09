; ModuleID = '/home/chengzhy/FormaSyn/formasyn/tests/vitis_hls_test/complex_fir/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"struct.ap_int<16>" = type { %"struct.ap_int_base<16, true>" }
%"struct.ap_int_base<16, true>" = type { %"struct.ssdm_int<16, true>" }
%"struct.ssdm_int<16, true>" = type { i16 }

; Function Attrs: noinline willreturn
define void @apatb_kernel_ir(%"struct.ap_int<16>"* nocapture readonly %x_real, %"struct.ap_int<16>"* nocapture readonly %x_imag, %"struct.ap_int<16>"* noalias nocapture nonnull dereferenceable(2) %y_real, %"struct.ap_int<16>"* noalias nocapture nonnull dereferenceable(2) %y_imag) local_unnamed_addr #0 {
entry:
  %y_real_copy = alloca i16, align 512
  %y_imag_copy = alloca i16, align 512
  call fastcc void @copy_in(%"struct.ap_int<16>"* nonnull %y_real, i16* nonnull align 512 %y_real_copy, %"struct.ap_int<16>"* nonnull %y_imag, i16* nonnull align 512 %y_imag_copy)
  call void @apatb_kernel_hw(%"struct.ap_int<16>"* %x_real, %"struct.ap_int<16>"* %x_imag, i16* %y_real_copy, i16* %y_imag_copy)
  call void @copy_back(%"struct.ap_int<16>"* %y_real, i16* %y_real_copy, %"struct.ap_int<16>"* %y_imag, i16* %y_imag_copy)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_in(%"struct.ap_int<16>"* noalias readonly "unpacked"="0", i16* noalias nocapture align 512 "unpacked"="1.0", %"struct.ap_int<16>"* noalias readonly "unpacked"="2", i16* noalias nocapture align 512 "unpacked"="3.0") unnamed_addr #1 {
entry:
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<16>.13"(i16* align 512 %1, %"struct.ap_int<16>"* %0)
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<16>.13"(i16* align 512 %3, %"struct.ap_int<16>"* %2)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_out(%"struct.ap_int<16>"* noalias "unpacked"="0", i16* noalias nocapture readonly align 512 "unpacked"="1.0", %"struct.ap_int<16>"* noalias "unpacked"="2", i16* noalias nocapture readonly align 512 "unpacked"="3.0") unnamed_addr #2 {
entry:
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<16>"(%"struct.ap_int<16>"* %0, i16* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<16>"(%"struct.ap_int<16>"* %2, i16* align 512 %3)
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0struct.ap_int<16>"(%"struct.ap_int<16>"* noalias "unpacked"="0" %dst, i16* noalias nocapture readonly align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"struct.ap_int<16>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %dst.0.0.04 = getelementptr %"struct.ap_int<16>", %"struct.ap_int<16>"* %dst, i64 0, i32 0, i32 0, i32 0
  %1 = load i16, i16* %src, align 512
  store i16 %1, i16* %dst.0.0.04, align 2
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @"onebyonecpy_hls.p0struct.ap_int<16>.13"(i16* noalias nocapture align 512 "unpacked"="0.0" %dst, %"struct.ap_int<16>"* noalias readonly "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"struct.ap_int<16>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  %src.0.0.03 = getelementptr %"struct.ap_int<16>", %"struct.ap_int<16>"* %src, i64 0, i32 0, i32 0, i32 0
  %1 = load i16, i16* %src.0.0.03, align 2
  store i16 %1, i16* %dst, align 512
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_kernel_hw(%"struct.ap_int<16>"*, %"struct.ap_int<16>"*, i16*, i16*)

; Function Attrs: argmemonly noinline norecurse willreturn
define internal fastcc void @copy_back(%"struct.ap_int<16>"* noalias "unpacked"="0", i16* noalias nocapture readonly align 512 "unpacked"="1.0", %"struct.ap_int<16>"* noalias "unpacked"="2", i16* noalias nocapture readonly align 512 "unpacked"="3.0") unnamed_addr #2 {
entry:
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<16>"(%"struct.ap_int<16>"* %0, i16* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0struct.ap_int<16>"(%"struct.ap_int<16>"* %2, i16* align 512 %3)
  ret void
}

declare void @kernel_hw_stub(%"struct.ap_int<16>"* nocapture readonly, %"struct.ap_int<16>"* nocapture readonly, %"struct.ap_int<16>"* noalias nocapture nonnull, %"struct.ap_int<16>"* noalias nocapture nonnull)

define void @kernel_hw_stub_wrapper(%"struct.ap_int<16>"*, %"struct.ap_int<16>"*, i16*, i16*) #4 {
entry:
  %4 = call i8* @malloc(i64 2)
  %5 = bitcast i8* %4 to %"struct.ap_int<16>"*
  %6 = call i8* @malloc(i64 2)
  %7 = bitcast i8* %6 to %"struct.ap_int<16>"*
  call void @copy_out(%"struct.ap_int<16>"* %5, i16* %2, %"struct.ap_int<16>"* %7, i16* %3)
  call void @kernel_hw_stub(%"struct.ap_int<16>"* %0, %"struct.ap_int<16>"* %1, %"struct.ap_int<16>"* %5, %"struct.ap_int<16>"* %7)
  call void @copy_in(%"struct.ap_int<16>"* %5, i16* %2, %"struct.ap_int<16>"* %7, i16* %3)
  call void @free(i8* %4)
  call void @free(i8* %6)
  ret void
}

attributes #0 = { noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #1 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyin" }
attributes #2 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="copyout" }
attributes #3 = { argmemonly noinline norecurse willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #4 = { "fpga.wrapper.func"="stub" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
