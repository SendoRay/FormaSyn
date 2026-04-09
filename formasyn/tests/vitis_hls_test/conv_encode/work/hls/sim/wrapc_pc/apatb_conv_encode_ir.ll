; ModuleID = '/home/chengzhy/FormaSyn/formasyn/tests/vitis_hls_test/conv_encode/work/hls/.autopilot/db/a.g.ld.5.gdce.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-i128:128-i256:256-i512:512-i1024:1024-i2048:2048-i4096:4096-n8:16:32:64-S128-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "fpga64-xilinx-none"

%"class.hls::stream<ap_uint<1>, 0>" = type { %"struct.ap_uint<1>" }
%"struct.ap_uint<1>" = type { %"struct.ap_int_base<1, false>" }
%"struct.ap_int_base<1, false>" = type { %"struct.ssdm_int<1, false>" }
%"struct.ssdm_int<1, false>" = type { i1 }
%"class.hls::stream<ap_uint<2>, 0>" = type { %"struct.ap_uint<2>" }
%"struct.ap_uint<2>" = type { %"struct.ap_int_base<2, false>" }
%"struct.ap_int_base<2, false>" = type { %"struct.ssdm_int<2, false>" }
%"struct.ssdm_int<2, false>" = type { i2 }
%"struct.ap_uint<32>" = type { %"struct.ap_int_base<32, false>" }
%"struct.ap_int_base<32, false>" = type { %"struct.ssdm_int<32, false>" }
%"struct.ssdm_int<32, false>" = type { i32 }

; Function Attrs: inaccessiblememonly nounwind willreturn
declare void @llvm.sideeffect() #0

; Function Attrs: inaccessiblemem_or_argmemonly noinline willreturn
define void @apatb_conv_encode_ir(%"class.hls::stream<ap_uint<1>, 0>"* noalias nocapture nonnull dereferenceable(1) %bit_in_stream, %"class.hls::stream<ap_uint<2>, 0>"* noalias nocapture nonnull dereferenceable(1) %y_out_stream, %"struct.ap_uint<32>"* nocapture readonly %num_bits) local_unnamed_addr #1 {
entry:
  %bit_in_stream_copy = alloca i1, align 512
  call void @llvm.sideeffect() #7 [ "stream_interface"(i1* %bit_in_stream_copy, i32 0) ]
  %y_out_stream_copy = alloca i2, align 512
  call void @llvm.sideeffect() #7 [ "stream_interface"(i2* %y_out_stream_copy, i32 0) ]
  call fastcc void @copy_in(%"class.hls::stream<ap_uint<1>, 0>"* nonnull %bit_in_stream, i1* nonnull align 512 %bit_in_stream_copy, %"class.hls::stream<ap_uint<2>, 0>"* nonnull %y_out_stream, i2* nonnull align 512 %y_out_stream_copy)
  call void @apatb_conv_encode_hw(i1* %bit_in_stream_copy, i2* %y_out_stream_copy, %"struct.ap_uint<32>"* %num_bits)
  call void @copy_back(%"class.hls::stream<ap_uint<1>, 0>"* %bit_in_stream, i1* %bit_in_stream_copy, %"class.hls::stream<ap_uint<2>, 0>"* %y_out_stream, i2* %y_out_stream_copy)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_in(%"class.hls::stream<ap_uint<1>, 0>"* noalias "unpacked"="0", i1* noalias nocapture align 512 "unpacked"="1.0", %"class.hls::stream<ap_uint<2>, 0>"* noalias "unpacked"="2", i2* noalias nocapture align 512 "unpacked"="3.0") unnamed_addr #2 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<1>, 0>.16"(i1* align 512 %1, %"class.hls::stream<ap_uint<1>, 0>"* %0)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<2>, 0>"(i2* align 512 %3, %"class.hls::stream<ap_uint<2>, 0>"* %2)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<1>, 0>"(%"class.hls::stream<ap_uint<1>, 0>"* noalias "unpacked"="0" %dst, i1* noalias nocapture align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_uint<1>, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<1>, 0>"(%"class.hls::stream<ap_uint<1>, 0>"* nonnull %dst, i1* align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<1>, 0>"(%"class.hls::stream<ap_uint<1>, 0>"* noalias nocapture "unpacked"="0", i1* noalias nocapture align 512 "unpacked"="1.0") unnamed_addr #4 {
entry:
  %2 = alloca i1
  %3 = alloca %"class.hls::stream<ap_uint<1>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i1* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_1(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i1* %2 to i8*
  %7 = bitcast i1* %1 to i8*
  call void @fpga_fifo_pop_1(i8* %6, i8* %7)
  %8 = bitcast i1* %2 to i8*
  %9 = load i8, i8* %8
  %10 = trunc i8 %9 to i1
  %.ivi = insertvalue %"class.hls::stream<ap_uint<1>, 0>" undef, i1 %10, 0, 0, 0, 0
  store %"class.hls::stream<ap_uint<1>, 0>" %.ivi, %"class.hls::stream<ap_uint<1>, 0>"* %3
  %11 = bitcast %"class.hls::stream<ap_uint<1>, 0>"* %3 to i8*
  %12 = bitcast %"class.hls::stream<ap_uint<1>, 0>"* %0 to i8*
  call void @fpga_fifo_push_1(i8* %11, i8* %12)
  br label %empty, !llvm.loop !5

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<2>, 0>"(i2* noalias nocapture align 512 "unpacked"="0.0" %dst, %"class.hls::stream<ap_uint<2>, 0>"* noalias "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_uint<2>, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<2>, 0>"(i2* align 512 %dst, %"class.hls::stream<ap_uint<2>, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<2>, 0>"(i2* noalias nocapture align 512 "unpacked"="0.0", %"class.hls::stream<ap_uint<2>, 0>"* noalias nocapture "unpacked"="1") unnamed_addr #4 {
entry:
  %2 = alloca %"class.hls::stream<ap_uint<2>, 0>"
  %3 = alloca i2
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<ap_uint<2>, 0>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_1(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<ap_uint<2>, 0>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<ap_uint<2>, 0>"* %1 to i8*
  call void @fpga_fifo_pop_1(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<ap_uint<2>, 0>", %"class.hls::stream<ap_uint<2>, 0>"* %2
  %.evi = extractvalue %"class.hls::stream<ap_uint<2>, 0>" %8, 0, 0, 0, 0
  store i2 %.evi, i2* %3
  %9 = bitcast i2* %3 to i8*
  %10 = bitcast i2* %0 to i8*
  call void @fpga_fifo_push_1(i8* %9, i8* %10)
  br label %empty, !llvm.loop !7

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_out(%"class.hls::stream<ap_uint<1>, 0>"* noalias "unpacked"="0", i1* noalias nocapture align 512 "unpacked"="1.0", %"class.hls::stream<ap_uint<2>, 0>"* noalias "unpacked"="2", i2* noalias nocapture align 512 "unpacked"="3.0") unnamed_addr #5 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<1>, 0>"(%"class.hls::stream<ap_uint<1>, 0>"* %0, i1* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<2>, 0>.5"(%"class.hls::stream<ap_uint<2>, 0>"* %2, i2* align 512 %3)
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<2>, 0>.5"(%"class.hls::stream<ap_uint<2>, 0>"* noalias "unpacked"="0" %dst, i2* noalias nocapture align 512 "unpacked"="1.0" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_uint<2>, 0>"* %dst, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<2>, 0>.8"(%"class.hls::stream<ap_uint<2>, 0>"* nonnull %dst, i2* align 512 %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<2>, 0>.8"(%"class.hls::stream<ap_uint<2>, 0>"* noalias nocapture "unpacked"="0", i2* noalias nocapture align 512 "unpacked"="1.0") unnamed_addr #4 {
entry:
  %2 = alloca i2
  %3 = alloca %"class.hls::stream<ap_uint<2>, 0>"
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast i2* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_1(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast i2* %2 to i8*
  %7 = bitcast i2* %1 to i8*
  call void @fpga_fifo_pop_1(i8* %6, i8* %7)
  %8 = bitcast i2* %2 to i8*
  %9 = load i8, i8* %8
  %10 = trunc i8 %9 to i2
  %.ivi = insertvalue %"class.hls::stream<ap_uint<2>, 0>" undef, i2 %10, 0, 0, 0, 0
  store %"class.hls::stream<ap_uint<2>, 0>" %.ivi, %"class.hls::stream<ap_uint<2>, 0>"* %3
  %11 = bitcast %"class.hls::stream<ap_uint<2>, 0>"* %3 to i8*
  %12 = bitcast %"class.hls::stream<ap_uint<2>, 0>"* %0 to i8*
  call void @fpga_fifo_push_1(i8* %11, i8* %12)
  br label %empty, !llvm.loop !8

ret:                                              ; preds = %empty
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<1>, 0>.16"(i1* noalias nocapture align 512 "unpacked"="0.0" %dst, %"class.hls::stream<ap_uint<1>, 0>"* noalias "unpacked"="1" %src) unnamed_addr #3 {
entry:
  %0 = icmp eq %"class.hls::stream<ap_uint<1>, 0>"* %src, null
  br i1 %0, label %ret, label %copy

copy:                                             ; preds = %entry
  call fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<1>, 0>.19"(i1* align 512 %dst, %"class.hls::stream<ap_uint<1>, 0>"* nonnull %src)
  br label %ret

ret:                                              ; preds = %copy, %entry
  ret void
}

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @"streamcpy_hls.p0class.hls::stream<ap_uint<1>, 0>.19"(i1* noalias nocapture align 512 "unpacked"="0.0", %"class.hls::stream<ap_uint<1>, 0>"* noalias nocapture "unpacked"="1") unnamed_addr #4 {
entry:
  %2 = alloca %"class.hls::stream<ap_uint<1>, 0>"
  %3 = alloca i1
  br label %empty

empty:                                            ; preds = %push, %entry
  %4 = bitcast %"class.hls::stream<ap_uint<1>, 0>"* %1 to i8*
  %5 = call i1 @fpga_fifo_not_empty_1(i8* %4)
  br i1 %5, label %push, label %ret

push:                                             ; preds = %empty
  %6 = bitcast %"class.hls::stream<ap_uint<1>, 0>"* %2 to i8*
  %7 = bitcast %"class.hls::stream<ap_uint<1>, 0>"* %1 to i8*
  call void @fpga_fifo_pop_1(i8* %6, i8* %7)
  %8 = load volatile %"class.hls::stream<ap_uint<1>, 0>", %"class.hls::stream<ap_uint<1>, 0>"* %2
  %.evi = extractvalue %"class.hls::stream<ap_uint<1>, 0>" %8, 0, 0, 0, 0
  store i1 %.evi, i1* %3
  %9 = bitcast i1* %3 to i8*
  %10 = bitcast i1* %0 to i8*
  call void @fpga_fifo_push_1(i8* %9, i8* %10)
  br label %empty, !llvm.loop !9

ret:                                              ; preds = %empty
  ret void
}

declare i8* @malloc(i64)

declare void @free(i8*)

declare void @apatb_conv_encode_hw(i1*, i2*, %"struct.ap_uint<32>"*)

; Function Attrs: argmemonly noinline willreturn
define internal fastcc void @copy_back(%"class.hls::stream<ap_uint<1>, 0>"* noalias "unpacked"="0", i1* noalias nocapture align 512 "unpacked"="1.0", %"class.hls::stream<ap_uint<2>, 0>"* noalias "unpacked"="2", i2* noalias nocapture align 512 "unpacked"="3.0") unnamed_addr #5 {
entry:
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<1>, 0>"(%"class.hls::stream<ap_uint<1>, 0>"* %0, i1* align 512 %1)
  call fastcc void @"onebyonecpy_hls.p0class.hls::stream<ap_uint<2>, 0>.5"(%"class.hls::stream<ap_uint<2>, 0>"* %2, i2* align 512 %3)
  ret void
}

declare void @conv_encode_hw_stub(%"class.hls::stream<ap_uint<1>, 0>"* noalias nocapture nonnull, %"class.hls::stream<ap_uint<2>, 0>"* noalias nocapture nonnull, %"struct.ap_uint<32>"* nocapture readonly)

define void @conv_encode_hw_stub_wrapper(i1*, i2*, %"struct.ap_uint<32>"*) #6 {
entry:
  %3 = call i8* @malloc(i64 1)
  %4 = bitcast i8* %3 to %"class.hls::stream<ap_uint<1>, 0>"*
  %5 = call i8* @malloc(i64 1)
  %6 = bitcast i8* %5 to %"class.hls::stream<ap_uint<2>, 0>"*
  call void @copy_out(%"class.hls::stream<ap_uint<1>, 0>"* %4, i1* %0, %"class.hls::stream<ap_uint<2>, 0>"* %6, i2* %1)
  call void @conv_encode_hw_stub(%"class.hls::stream<ap_uint<1>, 0>"* %4, %"class.hls::stream<ap_uint<2>, 0>"* %6, %"struct.ap_uint<32>"* %2)
  call void @copy_in(%"class.hls::stream<ap_uint<1>, 0>"* %4, i1* %0, %"class.hls::stream<ap_uint<2>, 0>"* %6, i2* %1)
  call void @free(i8* %3)
  call void @free(i8* %5)
  ret void
}

declare i1 @fpga_fifo_not_empty_1(i8*)

declare void @fpga_fifo_pop_1(i8*, i8*)

declare void @fpga_fifo_push_1(i8*, i8*)

attributes #0 = { inaccessiblememonly nounwind willreturn }
attributes #1 = { inaccessiblemem_or_argmemonly noinline willreturn "fpga.wrapper.func"="wrapper" }
attributes #2 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyin" }
attributes #3 = { argmemonly noinline willreturn "fpga.wrapper.func"="onebyonecpy_hls" }
attributes #4 = { argmemonly noinline willreturn "fpga.wrapper.func"="streamcpy_hls" }
attributes #5 = { argmemonly noinline willreturn "fpga.wrapper.func"="copyout" }
attributes #6 = { "fpga.wrapper.func"="stub" }
attributes #7 = { inaccessiblememonly nounwind willreturn "xlx.port.bitwidth"="8" "xlx.source"="user" }

!llvm.dbg.cu = !{}
!llvm.ident = !{!0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!blackbox_cfg = !{!4}

!0 = !{!"clang version 7.0.0 "}
!1 = !{i32 2, !"Dwarf Version", i32 4}
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = !{i32 1, !"wchar_size", i32 4}
!4 = !{}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.rotate.disable"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
!9 = distinct !{!9, !6}
