; ModuleID = 'HBM_helper'
source_filename = "HBM_helper"

%"struct.ap_int<15>.5" = type { %"struct.ap_int_base<15, true>.4" }
%"struct.ap_int_base<15, true>.4" = type { %"struct.ssdm_int<15, true>.3" }
%"struct.ssdm_int<15, true>.3" = type { i15 }
%"struct.ap_int<8>.2" = type { %"struct.ap_int_base<8, true>.1" }
%"struct.ap_int_base<8, true>.1" = type { %"struct.ssdm_int<8, true>.0" }
%"struct.ssdm_int<8, true>.0" = type { i8 }

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #0

define void @_kernel_Set_c([2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [16 x %"struct.ap_int<15>.5"]*, i64) {
entry:
  %10 = icmp eq [16 x %"struct.ap_int<15>.5"]* %8, null
  br i1 %10, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %9, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %11 = udiv i64 %for.loop.idx2, 8
  %12 = urem i64 %for.loop.idx2, 8
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<15>.5"], [16 x %"struct.ap_int<15>.5"]* %8, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [2 x i15], [2 x i15]* %0, i64 0, i64 %11
  %dst.addr.0.0.06_1 = getelementptr [2 x i15], [2 x i15]* %1, i64 0, i64 %11
  %dst.addr.0.0.06_2 = getelementptr [2 x i15], [2 x i15]* %2, i64 0, i64 %11
  %dst.addr.0.0.06_3 = getelementptr [2 x i15], [2 x i15]* %3, i64 0, i64 %11
  %dst.addr.0.0.06_4 = getelementptr [2 x i15], [2 x i15]* %4, i64 0, i64 %11
  %dst.addr.0.0.06_5 = getelementptr [2 x i15], [2 x i15]* %5, i64 0, i64 %11
  %dst.addr.0.0.06_6 = getelementptr [2 x i15], [2 x i15]* %6, i64 0, i64 %11
  %dst.addr.0.0.06_7 = getelementptr [2 x i15], [2 x i15]* %7, i64 0, i64 %11
  %13 = bitcast i15* %src.addr.0.0.05 to i16*
  %14 = load i16, i16* %13
  %15 = trunc i16 %14 to i15
  switch i64 %12, label %dst.addr.0.0.06.case.7 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
    i64 3, label %dst.addr.0.0.06.case.3
    i64 4, label %dst.addr.0.0.06.case.4
    i64 5, label %dst.addr.0.0.06.case.5
    i64 6, label %dst.addr.0.0.06.case.6
  ]

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i15 %15, i15* %dst.addr.0.0.06_0, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  store i15 %15, i15* %dst.addr.0.0.06_1, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.2:                           ; preds = %for.loop
  store i15 %15, i15* %dst.addr.0.0.06_2, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.3:                           ; preds = %for.loop
  store i15 %15, i15* %dst.addr.0.0.06_3, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.4:                           ; preds = %for.loop
  store i15 %15, i15* %dst.addr.0.0.06_4, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.5:                           ; preds = %for.loop
  store i15 %15, i15* %dst.addr.0.0.06_5, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.6:                           ; preds = %for.loop
  store i15 %15, i15* %dst.addr.0.0.06_6, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.7:                           ; preds = %for.loop
  %16 = icmp eq i64 %12, 7
  call void @llvm.assume(i1 %16)
  store i15 %15, i15* %dst.addr.0.0.06_7, align 2
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.7, %dst.addr.0.0.06.case.6, %dst.addr.0.0.06.case.5, %dst.addr.0.0.06.case.4, %dst.addr.0.0.06.case.3, %dst.addr.0.0.06.case.2, %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %9
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Set_c([8 x [2 x i15]*]*, [16 x %"struct.ap_int<15>.5"]*, i64) {
entry:
  %3 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %0, i64 0, i64 0
  %4 = load [2 x i15]*, [2 x i15]** %3
  %5 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %0, i64 0, i64 1
  %6 = load [2 x i15]*, [2 x i15]** %5
  %7 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %0, i64 0, i64 2
  %8 = load [2 x i15]*, [2 x i15]** %7
  %9 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %0, i64 0, i64 3
  %10 = load [2 x i15]*, [2 x i15]** %9
  %11 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %0, i64 0, i64 4
  %12 = load [2 x i15]*, [2 x i15]** %11
  %13 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %0, i64 0, i64 5
  %14 = load [2 x i15]*, [2 x i15]** %13
  %15 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %0, i64 0, i64 6
  %16 = load [2 x i15]*, [2 x i15]** %15
  %17 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %0, i64 0, i64 7
  %18 = load [2 x i15]*, [2 x i15]** %17
  call void @_kernel_Set_c([2 x i15]* %4, [2 x i15]* %6, [2 x i15]* %8, [2 x i15]* %10, [2 x i15]* %12, [2 x i15]* %14, [2 x i15]* %16, [2 x i15]* %18, [16 x %"struct.ap_int<15>.5"]* %1, i64 %2)
  ret void
}

define void @_kernel_Get_c([16 x %"struct.ap_int<15>.5"]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, [2 x i15]*, i64) {
entry:
  %10 = icmp eq [16 x %"struct.ap_int<15>.5"]* %0, null
  br i1 %10, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %9, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %11 = udiv i64 %for.loop.idx2, 8
  %12 = urem i64 %for.loop.idx2, 8
  %src.addr.0.0.05_0 = getelementptr [2 x i15], [2 x i15]* %1, i64 0, i64 %11
  %src.addr.0.0.05_1 = getelementptr [2 x i15], [2 x i15]* %2, i64 0, i64 %11
  %src.addr.0.0.05_2 = getelementptr [2 x i15], [2 x i15]* %3, i64 0, i64 %11
  %src.addr.0.0.05_3 = getelementptr [2 x i15], [2 x i15]* %4, i64 0, i64 %11
  %src.addr.0.0.05_4 = getelementptr [2 x i15], [2 x i15]* %5, i64 0, i64 %11
  %src.addr.0.0.05_5 = getelementptr [2 x i15], [2 x i15]* %6, i64 0, i64 %11
  %src.addr.0.0.05_6 = getelementptr [2 x i15], [2 x i15]* %7, i64 0, i64 %11
  %src.addr.0.0.05_7 = getelementptr [2 x i15], [2 x i15]* %8, i64 0, i64 %11
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<15>.5"], [16 x %"struct.ap_int<15>.5"]* %0, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %12, label %src.addr.0.0.05.case.7 [
    i64 0, label %src.addr.0.0.05.case.0
    i64 1, label %src.addr.0.0.05.case.1
    i64 2, label %src.addr.0.0.05.case.2
    i64 3, label %src.addr.0.0.05.case.3
    i64 4, label %src.addr.0.0.05.case.4
    i64 5, label %src.addr.0.0.05.case.5
    i64 6, label %src.addr.0.0.05.case.6
  ]

src.addr.0.0.05.case.0:                           ; preds = %for.loop
  %13 = bitcast i15* %src.addr.0.0.05_0 to i16*
  %14 = load i16, i16* %13
  %15 = trunc i16 %14 to i15
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.1:                           ; preds = %for.loop
  %16 = bitcast i15* %src.addr.0.0.05_1 to i16*
  %17 = load i16, i16* %16
  %18 = trunc i16 %17 to i15
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.2:                           ; preds = %for.loop
  %19 = bitcast i15* %src.addr.0.0.05_2 to i16*
  %20 = load i16, i16* %19
  %21 = trunc i16 %20 to i15
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.3:                           ; preds = %for.loop
  %22 = bitcast i15* %src.addr.0.0.05_3 to i16*
  %23 = load i16, i16* %22
  %24 = trunc i16 %23 to i15
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.4:                           ; preds = %for.loop
  %25 = bitcast i15* %src.addr.0.0.05_4 to i16*
  %26 = load i16, i16* %25
  %27 = trunc i16 %26 to i15
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.5:                           ; preds = %for.loop
  %28 = bitcast i15* %src.addr.0.0.05_5 to i16*
  %29 = load i16, i16* %28
  %30 = trunc i16 %29 to i15
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.6:                           ; preds = %for.loop
  %31 = bitcast i15* %src.addr.0.0.05_6 to i16*
  %32 = load i16, i16* %31
  %33 = trunc i16 %32 to i15
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.7:                           ; preds = %for.loop
  %34 = icmp eq i64 %12, 7
  call void @llvm.assume(i1 %34)
  %35 = bitcast i15* %src.addr.0.0.05_7 to i16*
  %36 = load i16, i16* %35
  %37 = trunc i16 %36 to i15
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.7, %src.addr.0.0.05.case.6, %src.addr.0.0.05.case.5, %src.addr.0.0.05.case.4, %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %38 = phi i15 [ %15, %src.addr.0.0.05.case.0 ], [ %18, %src.addr.0.0.05.case.1 ], [ %21, %src.addr.0.0.05.case.2 ], [ %24, %src.addr.0.0.05.case.3 ], [ %27, %src.addr.0.0.05.case.4 ], [ %30, %src.addr.0.0.05.case.5 ], [ %33, %src.addr.0.0.05.case.6 ], [ %37, %src.addr.0.0.05.case.7 ]
  store i15 %38, i15* %dst.addr.0.0.06, align 2
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %9
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Get_c([16 x %"struct.ap_int<15>.5"]*, [8 x [2 x i15]*]*, i64) {
entry:
  %3 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %1, i64 0, i64 0
  %4 = load [2 x i15]*, [2 x i15]** %3
  %5 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %1, i64 0, i64 1
  %6 = load [2 x i15]*, [2 x i15]** %5
  %7 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %1, i64 0, i64 2
  %8 = load [2 x i15]*, [2 x i15]** %7
  %9 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %1, i64 0, i64 3
  %10 = load [2 x i15]*, [2 x i15]** %9
  %11 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %1, i64 0, i64 4
  %12 = load [2 x i15]*, [2 x i15]** %11
  %13 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %1, i64 0, i64 5
  %14 = load [2 x i15]*, [2 x i15]** %13
  %15 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %1, i64 0, i64 6
  %16 = load [2 x i15]*, [2 x i15]** %15
  %17 = getelementptr [8 x [2 x i15]*], [8 x [2 x i15]*]* %1, i64 0, i64 7
  %18 = load [2 x i15]*, [2 x i15]** %17
  call void @_kernel_Get_c([16 x %"struct.ap_int<15>.5"]* %0, [2 x i15]* %4, [2 x i15]* %6, [2 x i15]* %8, [2 x i15]* %10, [2 x i15]* %12, [2 x i15]* %14, [2 x i15]* %16, [2 x i15]* %18, i64 %2)
  ret void
}

define void @_kernel_Set_a([2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %10 = icmp eq [16 x %"struct.ap_int<8>.2"]* %8, null
  br i1 %10, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %9, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %dst.addr.0.0.06.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %dst.addr.0.0.06.exit ]
  %11 = udiv i64 %for.loop.idx2, 8
  %12 = urem i64 %for.loop.idx2, 8
  %src.addr.0.0.05 = getelementptr [16 x %"struct.ap_int<8>.2"], [16 x %"struct.ap_int<8>.2"]* %8, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  %dst.addr.0.0.06_0 = getelementptr [2 x i8], [2 x i8]* %0, i64 0, i64 %11
  %dst.addr.0.0.06_1 = getelementptr [2 x i8], [2 x i8]* %1, i64 0, i64 %11
  %dst.addr.0.0.06_2 = getelementptr [2 x i8], [2 x i8]* %2, i64 0, i64 %11
  %dst.addr.0.0.06_3 = getelementptr [2 x i8], [2 x i8]* %3, i64 0, i64 %11
  %dst.addr.0.0.06_4 = getelementptr [2 x i8], [2 x i8]* %4, i64 0, i64 %11
  %dst.addr.0.0.06_5 = getelementptr [2 x i8], [2 x i8]* %5, i64 0, i64 %11
  %dst.addr.0.0.06_6 = getelementptr [2 x i8], [2 x i8]* %6, i64 0, i64 %11
  %dst.addr.0.0.06_7 = getelementptr [2 x i8], [2 x i8]* %7, i64 0, i64 %11
  %13 = load i8, i8* %src.addr.0.0.05, align 1
  switch i64 %12, label %dst.addr.0.0.06.case.7 [
    i64 0, label %dst.addr.0.0.06.case.0
    i64 1, label %dst.addr.0.0.06.case.1
    i64 2, label %dst.addr.0.0.06.case.2
    i64 3, label %dst.addr.0.0.06.case.3
    i64 4, label %dst.addr.0.0.06.case.4
    i64 5, label %dst.addr.0.0.06.case.5
    i64 6, label %dst.addr.0.0.06.case.6
  ]

dst.addr.0.0.06.case.0:                           ; preds = %for.loop
  store i8 %13, i8* %dst.addr.0.0.06_0, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.1:                           ; preds = %for.loop
  store i8 %13, i8* %dst.addr.0.0.06_1, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.2:                           ; preds = %for.loop
  store i8 %13, i8* %dst.addr.0.0.06_2, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.3:                           ; preds = %for.loop
  store i8 %13, i8* %dst.addr.0.0.06_3, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.4:                           ; preds = %for.loop
  store i8 %13, i8* %dst.addr.0.0.06_4, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.5:                           ; preds = %for.loop
  store i8 %13, i8* %dst.addr.0.0.06_5, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.6:                           ; preds = %for.loop
  store i8 %13, i8* %dst.addr.0.0.06_6, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.case.7:                           ; preds = %for.loop
  %14 = icmp eq i64 %12, 7
  call void @llvm.assume(i1 %14)
  store i8 %13, i8* %dst.addr.0.0.06_7, align 1
  br label %dst.addr.0.0.06.exit

dst.addr.0.0.06.exit:                             ; preds = %dst.addr.0.0.06.case.7, %dst.addr.0.0.06.case.6, %dst.addr.0.0.06.case.5, %dst.addr.0.0.06.case.4, %dst.addr.0.0.06.case.3, %dst.addr.0.0.06.case.2, %dst.addr.0.0.06.case.1, %dst.addr.0.0.06.case.0
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %9
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %dst.addr.0.0.06.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Set_b([8 x [2 x i8]*]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %3 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 0
  %4 = load [2 x i8]*, [2 x i8]** %3
  %5 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 1
  %6 = load [2 x i8]*, [2 x i8]** %5
  %7 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 2
  %8 = load [2 x i8]*, [2 x i8]** %7
  %9 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 3
  %10 = load [2 x i8]*, [2 x i8]** %9
  %11 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 4
  %12 = load [2 x i8]*, [2 x i8]** %11
  %13 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 5
  %14 = load [2 x i8]*, [2 x i8]** %13
  %15 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 6
  %16 = load [2 x i8]*, [2 x i8]** %15
  %17 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 7
  %18 = load [2 x i8]*, [2 x i8]** %17
  call void @_kernel_Set_a([2 x i8]* %4, [2 x i8]* %6, [2 x i8]* %8, [2 x i8]* %10, [2 x i8]* %12, [2 x i8]* %14, [2 x i8]* %16, [2 x i8]* %18, [16 x %"struct.ap_int<8>.2"]* %1, i64 %2)
  ret void
}

define void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, [2 x i8]*, i64) {
entry:
  %10 = icmp eq [16 x %"struct.ap_int<8>.2"]* %0, null
  br i1 %10, label %ret, label %copy

copy:                                             ; preds = %entry
  %for.loop.cond1 = icmp sgt i64 %9, 0
  br i1 %for.loop.cond1, label %for.loop.lr.ph, label %copy.split

for.loop.lr.ph:                                   ; preds = %copy
  br label %for.loop

for.loop:                                         ; preds = %src.addr.0.0.05.exit, %for.loop.lr.ph
  %for.loop.idx2 = phi i64 [ 0, %for.loop.lr.ph ], [ %for.loop.idx.next, %src.addr.0.0.05.exit ]
  %11 = udiv i64 %for.loop.idx2, 8
  %12 = urem i64 %for.loop.idx2, 8
  %src.addr.0.0.05_0 = getelementptr [2 x i8], [2 x i8]* %1, i64 0, i64 %11
  %src.addr.0.0.05_1 = getelementptr [2 x i8], [2 x i8]* %2, i64 0, i64 %11
  %src.addr.0.0.05_2 = getelementptr [2 x i8], [2 x i8]* %3, i64 0, i64 %11
  %src.addr.0.0.05_3 = getelementptr [2 x i8], [2 x i8]* %4, i64 0, i64 %11
  %src.addr.0.0.05_4 = getelementptr [2 x i8], [2 x i8]* %5, i64 0, i64 %11
  %src.addr.0.0.05_5 = getelementptr [2 x i8], [2 x i8]* %6, i64 0, i64 %11
  %src.addr.0.0.05_6 = getelementptr [2 x i8], [2 x i8]* %7, i64 0, i64 %11
  %src.addr.0.0.05_7 = getelementptr [2 x i8], [2 x i8]* %8, i64 0, i64 %11
  %dst.addr.0.0.06 = getelementptr [16 x %"struct.ap_int<8>.2"], [16 x %"struct.ap_int<8>.2"]* %0, i64 0, i64 %for.loop.idx2, i32 0, i32 0, i32 0
  switch i64 %12, label %src.addr.0.0.05.case.7 [
    i64 0, label %src.addr.0.0.05.case.0
    i64 1, label %src.addr.0.0.05.case.1
    i64 2, label %src.addr.0.0.05.case.2
    i64 3, label %src.addr.0.0.05.case.3
    i64 4, label %src.addr.0.0.05.case.4
    i64 5, label %src.addr.0.0.05.case.5
    i64 6, label %src.addr.0.0.05.case.6
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
  %_3 = load i8, i8* %src.addr.0.0.05_3, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.4:                           ; preds = %for.loop
  %_4 = load i8, i8* %src.addr.0.0.05_4, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.5:                           ; preds = %for.loop
  %_5 = load i8, i8* %src.addr.0.0.05_5, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.6:                           ; preds = %for.loop
  %_6 = load i8, i8* %src.addr.0.0.05_6, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.case.7:                           ; preds = %for.loop
  %13 = icmp eq i64 %12, 7
  call void @llvm.assume(i1 %13)
  %_7 = load i8, i8* %src.addr.0.0.05_7, align 1
  br label %src.addr.0.0.05.exit

src.addr.0.0.05.exit:                             ; preds = %src.addr.0.0.05.case.7, %src.addr.0.0.05.case.6, %src.addr.0.0.05.case.5, %src.addr.0.0.05.case.4, %src.addr.0.0.05.case.3, %src.addr.0.0.05.case.2, %src.addr.0.0.05.case.1, %src.addr.0.0.05.case.0
  %14 = phi i8 [ %_0, %src.addr.0.0.05.case.0 ], [ %_1, %src.addr.0.0.05.case.1 ], [ %_2, %src.addr.0.0.05.case.2 ], [ %_3, %src.addr.0.0.05.case.3 ], [ %_4, %src.addr.0.0.05.case.4 ], [ %_5, %src.addr.0.0.05.case.5 ], [ %_6, %src.addr.0.0.05.case.6 ], [ %_7, %src.addr.0.0.05.case.7 ]
  store i8 %14, i8* %dst.addr.0.0.06, align 1
  %for.loop.idx.next = add nuw nsw i64 %for.loop.idx2, 1
  %exitcond = icmp ne i64 %for.loop.idx.next, %9
  br i1 %exitcond, label %for.loop, label %copy.split

copy.split:                                       ; preds = %src.addr.0.0.05.exit, %copy
  br label %ret

ret:                                              ; preds = %copy.split, %entry
  ret void
}

define void @kernel_Get_b([16 x %"struct.ap_int<8>.2"]*, [8 x [2 x i8]*]*, i64) {
entry:
  %3 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 0
  %4 = load [2 x i8]*, [2 x i8]** %3
  %5 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 1
  %6 = load [2 x i8]*, [2 x i8]** %5
  %7 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 2
  %8 = load [2 x i8]*, [2 x i8]** %7
  %9 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 3
  %10 = load [2 x i8]*, [2 x i8]** %9
  %11 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 4
  %12 = load [2 x i8]*, [2 x i8]** %11
  %13 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 5
  %14 = load [2 x i8]*, [2 x i8]** %13
  %15 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 6
  %16 = load [2 x i8]*, [2 x i8]** %15
  %17 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 7
  %18 = load [2 x i8]*, [2 x i8]** %17
  call void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]* %0, [2 x i8]* %4, [2 x i8]* %6, [2 x i8]* %8, [2 x i8]* %10, [2 x i8]* %12, [2 x i8]* %14, [2 x i8]* %16, [2 x i8]* %18, i64 %2)
  ret void
}

define void @kernel_Set_a([8 x [2 x i8]*]*, [16 x %"struct.ap_int<8>.2"]*, i64) {
entry:
  %3 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 0
  %4 = load [2 x i8]*, [2 x i8]** %3
  %5 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 1
  %6 = load [2 x i8]*, [2 x i8]** %5
  %7 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 2
  %8 = load [2 x i8]*, [2 x i8]** %7
  %9 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 3
  %10 = load [2 x i8]*, [2 x i8]** %9
  %11 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 4
  %12 = load [2 x i8]*, [2 x i8]** %11
  %13 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 5
  %14 = load [2 x i8]*, [2 x i8]** %13
  %15 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 6
  %16 = load [2 x i8]*, [2 x i8]** %15
  %17 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %0, i64 0, i64 7
  %18 = load [2 x i8]*, [2 x i8]** %17
  call void @_kernel_Set_a([2 x i8]* %4, [2 x i8]* %6, [2 x i8]* %8, [2 x i8]* %10, [2 x i8]* %12, [2 x i8]* %14, [2 x i8]* %16, [2 x i8]* %18, [16 x %"struct.ap_int<8>.2"]* %1, i64 %2)
  ret void
}

define void @kernel_Get_a([16 x %"struct.ap_int<8>.2"]*, [8 x [2 x i8]*]*, i64) {
entry:
  %3 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 0
  %4 = load [2 x i8]*, [2 x i8]** %3
  %5 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 1
  %6 = load [2 x i8]*, [2 x i8]** %5
  %7 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 2
  %8 = load [2 x i8]*, [2 x i8]** %7
  %9 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 3
  %10 = load [2 x i8]*, [2 x i8]** %9
  %11 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 4
  %12 = load [2 x i8]*, [2 x i8]** %11
  %13 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 5
  %14 = load [2 x i8]*, [2 x i8]** %13
  %15 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 6
  %16 = load [2 x i8]*, [2 x i8]** %15
  %17 = getelementptr [8 x [2 x i8]*], [8 x [2 x i8]*]* %1, i64 0, i64 7
  %18 = load [2 x i8]*, [2 x i8]** %17
  call void @_kernel_Get_a([16 x %"struct.ap_int<8>.2"]* %0, [2 x i8]* %4, [2 x i8]* %6, [2 x i8]* %8, [2 x i8]* %10, [2 x i8]* %12, [2 x i8]* %14, [2 x i8]* %16, [2 x i8]* %18, i64 %2)
  ret void
}

attributes #0 = { nounwind willreturn }
