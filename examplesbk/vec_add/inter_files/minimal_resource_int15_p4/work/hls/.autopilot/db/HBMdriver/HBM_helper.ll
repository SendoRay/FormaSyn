; ModuleID = 'HBM_helper'
source_filename = "HBM_helper"

%"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5" = type { %"struct.ap_fixed_base<16, 7, true, AP_TRN, AP_WRAP, 0>.4" }
%"struct.ap_fixed_base<16, 7, true, AP_TRN, AP_WRAP, 0>.4" = type { %"struct.ssdm_int<16, true>.3" }
%"struct.ssdm_int<16, true>.3" = type { i16 }
%"struct.ap_int<8>.2" = type { %"struct.ap_int_base<8, true>.1" }
%"struct.ap_int_base<8, true>.1" = type { %"struct.ssdm_int<8, true>.0" }
%"struct.ssdm_int<8, true>.0" = type { i8 }

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #0

define void @_kernel_Set_c([4 x i16]*, [4 x i16]*, [4 x i16]*, [4 x i16]*, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]*, i64) {
entry:
  %6 = icmp eq [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]* %4, null
  br i1 %6, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %5, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %7 = udiv i64 %for.loop.idx2, 4
  %8 = urem i64 %for.loop.idx2, 4
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"], [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]* %4, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [4 x i16], [4 x i16]* %0, i64 0, i64 %7
  %dst.addr.0.0.06_1 = getelementptr [4 x i16], [4 x i16]* %1, i64 0, i64 %7
  %dst.addr.0.0.06_2 = getelementptr [4 x i16], [4 x i16]* %2, i64 0, i64 %7
  %dst.addr.0.0.06_3 = getelementptr [4 x i16], [4 x i16]* %3, i64 0, i64 %7
  %9 = load i16, i16* %src.addr.0.0.05, align 2
  switch i64 %8, label %dst.addr.0.0.06.case.3 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
  ]

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i16 %9, i16* %dst.addr.0.0.06_0, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  store i16 %9, i16* %dst.addr.0.0.06_1, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.2:                           ; preds = %for.loop
  store i16 %9, i16* %dst.addr.0.0.06_2, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.3:                           ; preds = %for.loop
  %10 = icmp eq i64 %8, 3
  call void @llvm.assume(i1 %10)
  store i16 %9, i16* %dst.addr.0.0.06_3, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.3, %dst.addr.0.0.06.case.2, %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %5
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Set_c([4 x [4 x i16]*]*, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]*, i64) {
entry:
  %3 = getelementptr [4 x [4 x i16]*], [4 x [4 x i16]*]* %0, i64 0, i64 0
  %4 = load [4 x i16]*, [4 x i16]** %3
  %5 = getelementptr [4 x [4 x i16]*], [4 x [4 x i16]*]* %0, i64 0, i64 1
  %6 = load [4 x i16]*, [4 x i16]** %5
  %7 = getelementptr [4 x [4 x i16]*], [4 x [4 x i16]*]* %0, i64 0, i64 2
  %8 = load [4 x i16]*, [4 x i16]** %7
  %9 = getelementptr [4 x [4 x i16]*], [4 x [4 x i16]*]* %0, i64 0, i64 3
  %10 = load [4 x i16]*, [4 x i16]** %9
  call void @_kernel_Set_c([4 x i16]* %4, [4 x i16]* %6, [4 x i16]* %8, [4 x i16]* %10, [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]* %1, i64 %2)
  ret void
}

define void @_kernel_Get_c([16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]*, [4 x i16]*, [4 x i16]*, [4 x i16]*, [4 x i16]*, i64) {
entry:
  %6 = icmp eq [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]* %0, null
  br i1 %6, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %5, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %7 = udiv i64 %for.loop.idx2, 4
  %8 = urem i64 %for.loop.idx2, 4
  %src.addr.0.0.05_0 = getelementptr [4 x i16], [4 x i16]* %1, i64 0, i64 %7
  %src.addr.0.0.05_1 = getelementptr [4 x i16], [4 x i16]* %2, i64 0, i64 %7
  %src.addr.0.0.05_2 = getelementptr [4 x i16], [4 x i16]* %3, i64 0, i64 %7
  %src.addr.0.0.05_3 = getelementptr [4 x i16], [4 x i16]* %4, i64 0, i64 %7
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"], [16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]* %0, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %8, label %src.addr.0.0.05.case.3 [
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
  %9 = icmp eq i64 %8, 3
  call void @llvm.assume(i1 %9)
  %_3 = load i16, i16* %src.addr.0.0.05_3, align 2
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %10 = phi i16 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ], [ %_2, %src.addr.0.0.05.case.2 ], [ %_3, %src.addr.0.0.05.case.3 ]
  store i16 %10, i16* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %5
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Get_c([16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]*, [4 x [4 x i16]*]*, i64) {
entry:
  %3 = getelementptr [4 x [4 x i16]*], [4 x [4 x i16]*]* %1, i64 0, i64 0
  %4 = load [4 x i16]*, [4 x i16]** %3
  %5 = getelementptr [4 x [4 x i16]*], [4 x [4 x i16]*]* %1, i64 0, i64 1
  %6 = load [4 x i16]*, [4 x i16]** %5
  %7 = getelementptr [4 x [4 x i16]*], [4 x [4 x i16]*]* %1, i64 0, i64 2
  %8 = load [4 x i16]*, [4 x i16]** %7
  %9 = getelementptr [4 x [4 x i16]*], [4 x [4 x i16]*]* %1, i64 0, i64 3
  %10 = load [4 x i16]*, [4 x i16]** %9
  call void @_kernel_Get_c([16 x %"struct.ap_fixed<16, 7, AP_TRN, AP_WRAP, 0>.5"]* %0, [4 x i16]* %4, [4 x i16]* %6, [4 x i16]* %8, [4 x i16]* %10, i64 %2)
  ret void
}

define void @_kernel_Set_a([4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %6 = icmp eq [16 x %"struct.ap_int<8>.2"]* %4, null
  br i1 %6, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %5, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %7 = udiv i64 %for.loop.idx2, 4
  %8 = urem i64 %for.loop.idx2, 4
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<8>.2"], [16 x %"struct.ap_int<8>.2"]* %4, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [4 x i8], [4 x i8]* %0, i64 0, i64 %7
  %dst.addr.0.0.06_1 = getelementptr [4 x i8], [4 x i8]* %1, i64 0, i64 %7
  %dst.addr.0.0.06_2 = getelementptr [4 x i8], [4 x i8]* %2, i64 0, i64 %7
  %dst.addr.0.0.06_3 = getelementptr [4 x i8], [4 x i8]* %3, i64 0, i64 %7
  %9 = load i8, i8* %src.addr.0.0.05, align 1
  switch i64 %8, label %dst.addr.0.0.06.case.3 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
  ]

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i8 %9, i8* %dst.addr.0.0.06_0, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  store i8 %9, i8* %dst.addr.0.0.06_1, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.2:                           ; preds = %for.loop
  store i8 %9, i8* %dst.addr.0.0.06_2, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.3:                           ; preds = %for.loop
  %10 = icmp eq i64 %8, 3
  call void @llvm.assume(i1 %10)
  store i8 %9, i8* %dst.addr.0.0.06_3, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.3, %dst.addr.0.0.06.case.2, %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %5
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Set_b([4 x [4 x i8]*]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %3 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %0, i64 0, i64 0
  %4 = load [4 x i8]*, [4 x i8]** %3
  %5 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %0, i64 0, i64 1
  %6 = load [4 x i8]*, [4 x i8]** %5
  %7 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %0, i64 0, i64 2
  %8 = load [4 x i8]*, [4 x i8]** %7
  %9 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %0, i64 0, i64 3
  %10 = load [4 x i8]*, [4 x i8]** %9
  call void @_kernel_Set_a([4 x i8]* %4, [4 x i8]* %6, [4 x i8]* %8, [4 x i8]* %10, [16 x %"struct.ap_int<8>.2"]* %1, i64 %2)
  ret void
}

define void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, [4 x i8]*, i64) {
entry:
  %6 = icmp eq [16 x %"struct.ap_int<8>.2"]* %0, null
  br i1 %6, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %5, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %7 = udiv i64 %for.loop.idx2, 4
  %8 = urem i64 %for.loop.idx2, 4
  %src.addr.0.0.05_0 = getelementptr [4 x i8], [4 x i8]* %1, i64 0, i64 %7
  %src.addr.0.0.05_1 = getelementptr [4 x i8], [4 x i8]* %2, i64 0, i64 %7
  %src.addr.0.0.05_2 = getelementptr [4 x i8], [4 x i8]* %3, i64 0, i64 %7
  %src.addr.0.0.05_3 = getelementptr [4 x i8], [4 x i8]* %4, i64 0, i64 %7
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<8>.2"], [16 x %"struct.ap_int<8>.2"]* %0, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %8, label %src.addr.0.0.05.case.3 [
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
  %9 = icmp eq i64 %8, 3
  call void @llvm.assume(i1 %9)
  %_3 = load i8, i8* %src.addr.0.0.05_3, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %10 = phi i8 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ], [ %_2, %src.addr.0.0.05.case.2 ], [ %_3, %src.addr.0.0.05.case.3 ]
  store i8 %10, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %5
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Get_b([16 x %"struct.ap_int<8>.2"]*, [4 x [4 x i8]*]*, i64) {
entry:
  %3 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %1, i64 0, i64 0
  %4 = load [4 x i8]*, [4 x i8]** %3
  %5 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %1, i64 0, i64 1
  %6 = load [4 x i8]*, [4 x i8]** %5
  %7 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %1, i64 0, i64 2
  %8 = load [4 x i8]*, [4 x i8]** %7
  %9 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %1, i64 0, i64 3
  %10 = load [4 x i8]*, [4 x i8]** %9
  call void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]* %0, [4 x i8]* %4, [4 x i8]* %6, [4 x i8]* %8, [4 x i8]* %10, i64 %2)
  ret void
}

define void @kernel_Set_a([4 x [4 x i8]*]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %3 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %0, i64 0, i64 0
  %4 = load [4 x i8]*, [4 x i8]** %3
  %5 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %0, i64 0, i64 1
  %6 = load [4 x i8]*, [4 x i8]** %5
  %7 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %0, i64 0, i64 2
  %8 = load [4 x i8]*, [4 x i8]** %7
  %9 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %0, i64 0, i64 3
  %10 = load [4 x i8]*, [4 x i8]** %9
  call void @_kernel_Set_a([4 x i8]* %4, [4 x i8]* %6, [4 x i8]* %8, [4 x i8]* %10, [16 x %"struct.ap_int<8>.2"]* %1, i64 %2)
  ret void
}

define void @kernel_Get_a([16 x %"struct.ap_int<8>.2"]*, [4 x [4 x i8]*]*, i64) {
entry:
  %3 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %1, i64 0, i64 0
  %4 = load [4 x i8]*, [4 x i8]** %3
  %5 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %1, i64 0, i64 1
  %6 = load [4 x i8]*, [4 x i8]** %5
  %7 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %1, i64 0, i64 2
  %8 = load [4 x i8]*, [4 x i8]** %7
  %9 = getelementptr [4 x [4 x i8]*], [4 x [4 x i8]*]* %1, i64 0, i64 3
  %10 = load [4 x i8]*, [4 x i8]** %9
  call void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]* %0, [4 x i8]* %4, [4 x i8]* %6, [4 x i8]* %8, [4 x i8]* %10, i64 %2)
  ret void
}

attributes #0 = { nounwind willreturn }
