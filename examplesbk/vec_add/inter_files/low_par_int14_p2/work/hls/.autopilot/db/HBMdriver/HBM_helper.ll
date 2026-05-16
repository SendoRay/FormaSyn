; ModuleID = 'HBM_helper'
source_filename = "HBM_helper"

%"struct.ap_int<14>.5" = type { %"struct.ap_int_base<14, true>.4" }
%"struct.ap_int_base<14, true>.4" = type { %"struct.ssdm_int<14, true>.3" }
%"struct.ssdm_int<14, true>.3" = type { i14 }
%"struct.ap_int<8>.2" = type { %"struct.ap_int_base<8, true>.1" }
%"struct.ap_int_base<8, true>.1" = type { %"struct.ssdm_int<8, true>.0" }
%"struct.ssdm_int<8, true>.0" = type { i8 }

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #0

define void @_kernel_Set_c([8 x i14]*, [8 x i14]*, [16 x %"struct.ap_int<14>.5"]*, i64) {
entry:
  %4 = icmp eq [16 x %"struct.ap_int<14>.5"]* %2, null
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %3, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %5 = udiv i64 %for.loop.idx2, 2
  %6 = urem i64 %for.loop.idx2, 2
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<14>.5"], [16 x %"struct.ap_int<14>.5"]* %2, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [8 x i14], [8 x i14]* %0, i64 0, i64 %5
  %dst.addr.0.0.06_1 = getelementptr [8 x i14], [8 x i14]* %1, i64 0, i64 %5
  %7 = bitcast i14* %src.addr.0.0.05 to i16*
  %8 = load i16, i16* %7
  %9 = trunc i16 %8 to i14
  %cond = icmp eq i64 %6, 0
  br i1 %cond, label %dst.addr.0.0.06.case.0, label %dst.addr.0.0.06.case.1

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i14 %9, i14* %dst.addr.0.0.06_0, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  %10 = icmp eq i64 %6, 1
  call void @llvm.assume(i1 %10)
  store i14 %9, i14* %dst.addr.0.0.06_1, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %3
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Set_c([2 x [8 x i14]*]*, [16 x %"struct.ap_int<14>.5"]*, i64) {
entry:
  %3 = getelementptr [2 x [8 x i14]*], [2 x [8 x i14]*]* %0, i64 0, i64 0
  %4 = load [8 x i14]*, [8 x i14]** %3
  %5 = getelementptr [2 x [8 x i14]*], [2 x [8 x i14]*]* %0, i64 0, i64 1
  %6 = load [8 x i14]*, [8 x i14]** %5
  call void @_kernel_Set_c([8 x i14]* %4, [8 x i14]* %6, [16 x %"struct.ap_int<14>.5"]* %1, i64 %2)
  ret void
}

define void @_kernel_Get_c([16 x %"struct.ap_int<14>.5"]*, [8 x i14]*, [8 x i14]*, i64) {
entry:
  %4 = icmp eq [16 x %"struct.ap_int<14>.5"]* %0, null
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %3, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %5 = udiv i64 %for.loop.idx2, 2
  %6 = urem i64 %for.loop.idx2, 2
  %src.addr.0.0.05_0 = getelementptr [8 x i14], [8 x i14]* %1, i64 0, i64 %5
  %src.addr.0.0.05_1 = getelementptr [8 x i14], [8 x i14]* %2, i64 0, i64 %5
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<14>.5"], [16 x %"struct.ap_int<14>.5"]* %0, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %cond = icmp eq i64 %6, 0
  br i1 %cond, label %src.addr.0.0.05.case.0, label %src.addr.0.0.05.case.1

src.addr.0.0.05.case.0:                           ; preds = %for.loop
  %7 = bitcast i14* %src.addr.0.0.05_0 to i16*
  %8 = load i16, i16* %7
  %9 = trunc i16 %8 to i14
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.1:                           ; preds = %for.loop
  %10 = icmp eq i64 %6, 1
  call void @llvm.assume(i1 %10)
  %11 = bitcast i14* %src.addr.0.0.05_1 to i16*
  %12 = load i16, i16* %11
  %13 = trunc i16 %12 to i14
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %14 = phi i14 [ %9, %src.addr.0.0.05.case.0 ], [ %13, %src.addr.0.0.05.case.1 ]
  store i14 %14, i14* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %3
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Get_c([16 x %"struct.ap_int<14>.5"]*, [2 x [8 x i14]*]*, i64) {
entry:
  %3 = getelementptr [2 x [8 x i14]*], [2 x [8 x i14]*]* %1, i64 0, i64 0
  %4 = load [8 x i14]*, [8 x i14]** %3
  %5 = getelementptr [2 x [8 x i14]*], [2 x [8 x i14]*]* %1, i64 0, i64 1
  %6 = load [8 x i14]*, [8 x i14]** %5
  call void @_kernel_Get_c([16 x %"struct.ap_int<14>.5"]* %0, [8 x i14]* %4, [8 x i14]* %6, i64 %2)
  ret void
}

define void @_kernel_Set_a([8 x i8]*, [8 x i8]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %4 = icmp eq [16 x %"struct.ap_int<8>.2"]* %2, null
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %3, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %5 = udiv i64 %for.loop.idx2, 2
  %6 = urem i64 %for.loop.idx2, 2
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<8>.2"], [16 x %"struct.ap_int<8>.2"]* %2, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [8 x i8], [8 x i8]* %0, i64 0, i64 %5
  %dst.addr.0.0.06_1 = getelementptr [8 x i8], [8 x i8]* %1, i64 0, i64 %5
  %7 = load i8, i8* %src.addr.0.0.05, align 1
  %cond = icmp eq i64 %6, 0
  br i1 %cond, label %dst.addr.0.0.06.case.0, label %dst.addr.0.0.06.case.1

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i8 %7, i8* %dst.addr.0.0.06_0, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  %8 = icmp eq i64 %6, 1
  call void @llvm.assume(i1 %8)
  store i8 %7, i8* %dst.addr.0.0.06_1, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %3
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Set_b([2 x [8 x i8]*]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %3 = getelementptr [2 x [8 x i8]*], [2 x [8 x i8]*]* %0, i64 0, i64 0
  %4 = load [8 x i8]*, [8 x i8]** %3
  %5 = getelementptr [2 x [8 x i8]*], [2 x [8 x i8]*]* %0, i64 0, i64 1
  %6 = load [8 x i8]*, [8 x i8]** %5
  call void @_kernel_Set_a([8 x i8]* %4, [8 x i8]* %6, [16 x %"struct.ap_int<8>.2"]* %1, i64 %2)
  ret void
}

define void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]*, [8 x i8]*, [8 x i8]*, i64) {
entry:
  %4 = icmp eq [16 x %"struct.ap_int<8>.2"]* %0, null
  br i1 %4, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %3, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %5 = udiv i64 %for.loop.idx2, 2
  %6 = urem i64 %for.loop.idx2, 2
  %src.addr.0.0.05_0 = getelementptr [8 x i8], [8 x i8]* %1, i64 0, i64 %5
  %src.addr.0.0.05_1 = getelementptr [8 x i8], [8 x i8]* %2, i64 0, i64 %5
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<8>.2"], [16 x %"struct.ap_int<8>.2"]* %0, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %cond = icmp eq i64 %6, 0
  br i1 %cond, label %src.addr.0.0.05.case.0, label %src.addr.0.0.05.case.1

src.addr.0.0.05.case.0:                           ; preds = %for.loop
  %_0 = load i8, i8* %src.addr.0.0.05_0, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.1:                           ; preds = %for.loop
  %7 = icmp eq i64 %6, 1
  call void @llvm.assume(i1 %7)
  %_1 = load i8, i8* %src.addr.0.0.05_1, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %8 = phi i8 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ]
  store i8 %8, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %3
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Get_b([16 x %"struct.ap_int<8>.2"]*, [2 x [8 x i8]*]*, i64) {
entry:
  %3 = getelementptr [2 x [8 x i8]*], [2 x [8 x i8]*]* %1, i64 0, i64 0
  %4 = load [8 x i8]*, [8 x i8]** %3
  %5 = getelementptr [2 x [8 x i8]*], [2 x [8 x i8]*]* %1, i64 0, i64 1
  %6 = load [8 x i8]*, [8 x i8]** %5
  call void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]* %0, [8 x i8]* %4, [8 x i8]* %6, i64 %2)
  ret void
}

define void @kernel_Set_a([2 x [8 x i8]*]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %3 = getelementptr [2 x [8 x i8]*], [2 x [8 x i8]*]* %0, i64 0, i64 0
  %4 = load [8 x i8]*, [8 x i8]** %3
  %5 = getelementptr [2 x [8 x i8]*], [2 x [8 x i8]*]* %0, i64 0, i64 1
  %6 = load [8 x i8]*, [8 x i8]** %5
  call void @_kernel_Set_a([8 x i8]* %4, [8 x i8]* %6, [16 x %"struct.ap_int<8>.2"]* %1, i64 %2)
  ret void
}

define void @kernel_Get_a([16 x %"struct.ap_int<8>.2"]*, [2 x [8 x i8]*]*, i64) {
entry:
  %3 = getelementptr [2 x [8 x i8]*], [2 x [8 x i8]*]* %1, i64 0, i64 0
  %4 = load [8 x i8]*, [8 x i8]** %3
  %5 = getelementptr [2 x [8 x i8]*], [2 x [8 x i8]*]* %1, i64 0, i64 1
  %6 = load [8 x i8]*, [8 x i8]** %5
  call void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]* %0, [8 x i8]* %4, [8 x i8]* %6, i64 %2)
  ret void
}

attributes #0 = { nounwind willreturn }
