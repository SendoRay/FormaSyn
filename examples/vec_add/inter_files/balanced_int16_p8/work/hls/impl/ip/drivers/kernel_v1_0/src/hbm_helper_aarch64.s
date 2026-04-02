	.text
	.file	"HBM_helper"
	.globl	_kernel_Set_c           // -- Begin function _kernel_Set_c
	.p2align	2
	.type	_kernel_Set_c,@function
_kernel_Set_c:                          // @_kernel_Set_c
	.cfi_startproc
// %bb.0:                               // %entry
	ldr	x8, [sp]
	cbz	x8, .LBB0_13
// %bb.1:                               // %entry
	ldr	x9, [sp, #8]
	cmp	x9, #1                  // =1
	b.lt	.LBB0_13
// %bb.2:                               // %for.loop.preheader
	adrp	x11, JTI0_0
	mov	x10, xzr
	add	x11, x11, :lo12:JTI0_0
.LBB0_3:                                // %for.loop
                                        // =>This Inner Loop Header: Depth=1
	ldrh	w12, [x8, x10, lsl #1]
	lsr	x14, x10, #2
	and	x13, x10, #0x7
	cmp	x13, #6                 // =6
	and	x14, x14, #0x3ffffffffffffffe
	b.hi	.LBB0_9
// %bb.4:                               // %for.loop
                                        //   in Loop: Header=BB0_3 Depth=1
	ldr	x15, [x11, x13, lsl #3]
	add	x13, x0, x14
	br	x15
.LBB0_5:                                // %dst.addr.0.0.06.case.1
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x13, x1, x14
	b	.LBB0_12
.LBB0_6:                                // %dst.addr.0.0.06.case.2
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x13, x2, x14
	b	.LBB0_12
.LBB0_7:                                // %dst.addr.0.0.06.case.3
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x13, x3, x14
	b	.LBB0_12
.LBB0_8:                                // %dst.addr.0.0.06.case.4
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x13, x4, x14
	b	.LBB0_12
.LBB0_9:                                // %dst.addr.0.0.06.case.7
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x13, x7, x14
	b	.LBB0_12
.LBB0_10:                               // %dst.addr.0.0.06.case.5
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x13, x5, x14
	b	.LBB0_12
.LBB0_11:                               // %dst.addr.0.0.06.case.6
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x13, x6, x14
.LBB0_12:                               // %dst.addr.0.0.06.exit
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x10, x10, #1            // =1
	cmp	x10, x9
	strh	w12, [x13]
	b.ne	.LBB0_3
.LBB0_13:                               // %ret
	ret
.Lfunc_end0:
	.size	_kernel_Set_c, .Lfunc_end0-_kernel_Set_c
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
JTI0_0:
	.xword	.LBB0_12
	.xword	.LBB0_5
	.xword	.LBB0_6
	.xword	.LBB0_7
	.xword	.LBB0_8
	.xword	.LBB0_10
	.xword	.LBB0_11
                                        // -- End function
	.text
	.globl	kernel_Set_c            // -- Begin function kernel_Set_c
	.p2align	2
	.type	kernel_Set_c,@function
kernel_Set_c:                           // @kernel_Set_c
	.cfi_startproc
// %bb.0:                               // %entry
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -16
	ldp	x8, x9, [x0]
	ldp	x10, x3, [x0, #16]
	ldp	x4, x5, [x0, #32]
	ldp	x6, x7, [x0, #48]
	str	x1, [sp, #-32]!
	stp	x2, x30, [sp, #8]       // 8-byte Folded Spill
	mov	x0, x8
	mov	x1, x9
	mov	x2, x10
	bl	_kernel_Set_c
	ldr	x30, [sp, #16]          // 8-byte Folded Reload
	add	sp, sp, #32             // =32
	ret
.Lfunc_end1:
	.size	kernel_Set_c, .Lfunc_end1-kernel_Set_c
	.cfi_endproc
                                        // -- End function
	.globl	_kernel_Get_c           // -- Begin function _kernel_Get_c
	.p2align	2
	.type	_kernel_Get_c,@function
_kernel_Get_c:                          // @_kernel_Get_c
	.cfi_startproc
// %bb.0:                               // %entry
	cbz	x0, .LBB2_13
// %bb.1:                               // %entry
	ldr	x8, [sp, #8]
	cmp	x8, #1                  // =1
	b.lt	.LBB2_13
// %bb.2:                               // %for.loop.preheader
	ldr	x10, [sp]
	adrp	x11, JTI2_0
	mov	x9, xzr
	add	x11, x11, :lo12:JTI2_0
.LBB2_3:                                // %for.loop
                                        // =>This Inner Loop Header: Depth=1
	lsr	x13, x9, #2
	and	x12, x9, #0x7
	cmp	x12, #6                 // =6
	and	x13, x13, #0x3ffffffffffffffe
	b.hi	.LBB2_9
// %bb.4:                               // %for.loop
                                        //   in Loop: Header=BB2_3 Depth=1
	ldr	x14, [x11, x12, lsl #3]
	add	x12, x1, x13
	br	x14
.LBB2_5:                                // %src.addr.0.0.05.case.1
                                        //   in Loop: Header=BB2_3 Depth=1
	add	x12, x2, x13
	b	.LBB2_12
.LBB2_6:                                // %src.addr.0.0.05.case.2
                                        //   in Loop: Header=BB2_3 Depth=1
	add	x12, x3, x13
	b	.LBB2_12
.LBB2_7:                                // %src.addr.0.0.05.case.3
                                        //   in Loop: Header=BB2_3 Depth=1
	add	x12, x4, x13
	b	.LBB2_12
.LBB2_8:                                // %src.addr.0.0.05.case.4
                                        //   in Loop: Header=BB2_3 Depth=1
	add	x12, x5, x13
	b	.LBB2_12
.LBB2_9:                                // %src.addr.0.0.05.case.7
                                        //   in Loop: Header=BB2_3 Depth=1
	add	x12, x10, x13
	b	.LBB2_12
.LBB2_10:                               // %src.addr.0.0.05.case.5
                                        //   in Loop: Header=BB2_3 Depth=1
	add	x12, x6, x13
	b	.LBB2_12
.LBB2_11:                               // %src.addr.0.0.05.case.6
                                        //   in Loop: Header=BB2_3 Depth=1
	add	x12, x7, x13
.LBB2_12:                               // %src.addr.0.0.05.exit
                                        //   in Loop: Header=BB2_3 Depth=1
	ldrh	w12, [x12]
	strh	w12, [x0, x9, lsl #1]
	add	x9, x9, #1              // =1
	cmp	x9, x8
	b.ne	.LBB2_3
.LBB2_13:                               // %ret
	ret
.Lfunc_end2:
	.size	_kernel_Get_c, .Lfunc_end2-_kernel_Get_c
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
JTI2_0:
	.xword	.LBB2_12
	.xword	.LBB2_5
	.xword	.LBB2_6
	.xword	.LBB2_7
	.xword	.LBB2_8
	.xword	.LBB2_10
	.xword	.LBB2_11
                                        // -- End function
	.text
	.globl	kernel_Get_c            // -- Begin function kernel_Get_c
	.p2align	2
	.type	kernel_Get_c,@function
kernel_Get_c:                           // @kernel_Get_c
	.cfi_startproc
// %bb.0:                               // %entry
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -16
	ldp	x7, x10, [x1, #48]
	ldp	x8, x9, [x1]
	ldp	x3, x4, [x1, #16]
	ldp	x5, x6, [x1, #32]
	str	x10, [sp, #-32]!
	stp	x2, x30, [sp, #8]       // 8-byte Folded Spill
	mov	x1, x8
	mov	x2, x9
	bl	_kernel_Get_c
	ldr	x30, [sp, #16]          // 8-byte Folded Reload
	add	sp, sp, #32             // =32
	ret
.Lfunc_end3:
	.size	kernel_Get_c, .Lfunc_end3-kernel_Get_c
	.cfi_endproc
                                        // -- End function
	.globl	_kernel_Set_a           // -- Begin function _kernel_Set_a
	.p2align	2
	.type	_kernel_Set_a,@function
_kernel_Set_a:                          // @_kernel_Set_a
	.cfi_startproc
// %bb.0:                               // %entry
	ldr	x8, [sp]
	cbz	x8, .LBB4_13
// %bb.1:                               // %entry
	ldr	x9, [sp, #8]
	cmp	x9, #1                  // =1
	b.lt	.LBB4_13
// %bb.2:                               // %for.loop.preheader
	adrp	x11, JTI4_0
	mov	x10, xzr
	add	x11, x11, :lo12:JTI4_0
.LBB4_3:                                // %for.loop
                                        // =>This Inner Loop Header: Depth=1
	ldrb	w12, [x8, x10]
	and	x13, x10, #0x7
	cmp	x13, #6                 // =6
	lsr	x14, x10, #3
	b.hi	.LBB4_9
// %bb.4:                               // %for.loop
                                        //   in Loop: Header=BB4_3 Depth=1
	ldr	x15, [x11, x13, lsl #3]
	add	x13, x0, x14
	br	x15
.LBB4_5:                                // %dst.addr.0.0.06.case.1
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x13, x1, x14
	b	.LBB4_12
.LBB4_6:                                // %dst.addr.0.0.06.case.2
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x13, x2, x14
	b	.LBB4_12
.LBB4_7:                                // %dst.addr.0.0.06.case.3
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x13, x3, x14
	b	.LBB4_12
.LBB4_8:                                // %dst.addr.0.0.06.case.4
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x13, x4, x14
	b	.LBB4_12
.LBB4_9:                                // %dst.addr.0.0.06.case.7
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x13, x7, x14
	b	.LBB4_12
.LBB4_10:                               // %dst.addr.0.0.06.case.5
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x13, x5, x14
	b	.LBB4_12
.LBB4_11:                               // %dst.addr.0.0.06.case.6
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x13, x6, x14
.LBB4_12:                               // %dst.addr.0.0.06.exit
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x10, x10, #1            // =1
	cmp	x10, x9
	strb	w12, [x13]
	b.ne	.LBB4_3
.LBB4_13:                               // %ret
	ret
.Lfunc_end4:
	.size	_kernel_Set_a, .Lfunc_end4-_kernel_Set_a
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
JTI4_0:
	.xword	.LBB4_12
	.xword	.LBB4_5
	.xword	.LBB4_6
	.xword	.LBB4_7
	.xword	.LBB4_8
	.xword	.LBB4_10
	.xword	.LBB4_11
                                        // -- End function
	.text
	.globl	kernel_Set_b            // -- Begin function kernel_Set_b
	.p2align	2
	.type	kernel_Set_b,@function
kernel_Set_b:                           // @kernel_Set_b
	.cfi_startproc
// %bb.0:                               // %entry
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -16
	ldp	x8, x9, [x0]
	ldp	x10, x3, [x0, #16]
	ldp	x4, x5, [x0, #32]
	ldp	x6, x7, [x0, #48]
	str	x1, [sp, #-32]!
	stp	x2, x30, [sp, #8]       // 8-byte Folded Spill
	mov	x0, x8
	mov	x1, x9
	mov	x2, x10
	bl	_kernel_Set_a
	ldr	x30, [sp, #16]          // 8-byte Folded Reload
	add	sp, sp, #32             // =32
	ret
.Lfunc_end5:
	.size	kernel_Set_b, .Lfunc_end5-kernel_Set_b
	.cfi_endproc
                                        // -- End function
	.globl	_kernel_Get_a           // -- Begin function _kernel_Get_a
	.p2align	2
	.type	_kernel_Get_a,@function
_kernel_Get_a:                          // @_kernel_Get_a
	.cfi_startproc
// %bb.0:                               // %entry
	cbz	x0, .LBB6_13
// %bb.1:                               // %entry
	ldr	x8, [sp, #8]
	cmp	x8, #1                  // =1
	b.lt	.LBB6_13
// %bb.2:                               // %for.loop.preheader
	ldr	x10, [sp]
	adrp	x11, JTI6_0
	mov	x9, xzr
	add	x11, x11, :lo12:JTI6_0
.LBB6_3:                                // %for.loop
                                        // =>This Inner Loop Header: Depth=1
	and	x12, x9, #0x7
	cmp	x12, #6                 // =6
	lsr	x13, x9, #3
	b.hi	.LBB6_9
// %bb.4:                               // %for.loop
                                        //   in Loop: Header=BB6_3 Depth=1
	ldr	x14, [x11, x12, lsl #3]
	add	x12, x1, x13
	br	x14
.LBB6_5:                                // %src.addr.0.0.05.case.1
                                        //   in Loop: Header=BB6_3 Depth=1
	add	x12, x2, x13
	b	.LBB6_12
.LBB6_6:                                // %src.addr.0.0.05.case.2
                                        //   in Loop: Header=BB6_3 Depth=1
	add	x12, x3, x13
	b	.LBB6_12
.LBB6_7:                                // %src.addr.0.0.05.case.3
                                        //   in Loop: Header=BB6_3 Depth=1
	add	x12, x4, x13
	b	.LBB6_12
.LBB6_8:                                // %src.addr.0.0.05.case.4
                                        //   in Loop: Header=BB6_3 Depth=1
	add	x12, x5, x13
	b	.LBB6_12
.LBB6_9:                                // %src.addr.0.0.05.case.7
                                        //   in Loop: Header=BB6_3 Depth=1
	add	x12, x10, x13
	b	.LBB6_12
.LBB6_10:                               // %src.addr.0.0.05.case.5
                                        //   in Loop: Header=BB6_3 Depth=1
	add	x12, x6, x13
	b	.LBB6_12
.LBB6_11:                               // %src.addr.0.0.05.case.6
                                        //   in Loop: Header=BB6_3 Depth=1
	add	x12, x7, x13
.LBB6_12:                               // %src.addr.0.0.05.exit
                                        //   in Loop: Header=BB6_3 Depth=1
	ldrb	w12, [x12]
	strb	w12, [x0, x9]
	add	x9, x9, #1              // =1
	cmp	x9, x8
	b.ne	.LBB6_3
.LBB6_13:                               // %ret
	ret
.Lfunc_end6:
	.size	_kernel_Get_a, .Lfunc_end6-_kernel_Get_a
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
JTI6_0:
	.xword	.LBB6_12
	.xword	.LBB6_5
	.xword	.LBB6_6
	.xword	.LBB6_7
	.xword	.LBB6_8
	.xword	.LBB6_10
	.xword	.LBB6_11
                                        // -- End function
	.text
	.globl	kernel_Get_b            // -- Begin function kernel_Get_b
	.p2align	2
	.type	kernel_Get_b,@function
kernel_Get_b:                           // @kernel_Get_b
	.cfi_startproc
// %bb.0:                               // %entry
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -16
	ldp	x7, x10, [x1, #48]
	ldp	x8, x9, [x1]
	ldp	x3, x4, [x1, #16]
	ldp	x5, x6, [x1, #32]
	str	x10, [sp, #-32]!
	stp	x2, x30, [sp, #8]       // 8-byte Folded Spill
	mov	x1, x8
	mov	x2, x9
	bl	_kernel_Get_a
	ldr	x30, [sp, #16]          // 8-byte Folded Reload
	add	sp, sp, #32             // =32
	ret
.Lfunc_end7:
	.size	kernel_Get_b, .Lfunc_end7-kernel_Get_b
	.cfi_endproc
                                        // -- End function
	.globl	kernel_Set_a            // -- Begin function kernel_Set_a
	.p2align	2
	.type	kernel_Set_a,@function
kernel_Set_a:                           // @kernel_Set_a
	.cfi_startproc
// %bb.0:                               // %entry
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -16
	ldp	x8, x9, [x0]
	ldp	x10, x3, [x0, #16]
	ldp	x4, x5, [x0, #32]
	ldp	x6, x7, [x0, #48]
	str	x1, [sp, #-32]!
	stp	x2, x30, [sp, #8]       // 8-byte Folded Spill
	mov	x0, x8
	mov	x1, x9
	mov	x2, x10
	bl	_kernel_Set_a
	ldr	x30, [sp, #16]          // 8-byte Folded Reload
	add	sp, sp, #32             // =32
	ret
.Lfunc_end8:
	.size	kernel_Set_a, .Lfunc_end8-kernel_Set_a
	.cfi_endproc
                                        // -- End function
	.globl	kernel_Get_a            // -- Begin function kernel_Get_a
	.p2align	2
	.type	kernel_Get_a,@function
kernel_Get_a:                           // @kernel_Get_a
	.cfi_startproc
// %bb.0:                               // %entry
	.cfi_def_cfa_offset 32
	.cfi_offset w30, -16
	ldp	x7, x10, [x1, #48]
	ldp	x8, x9, [x1]
	ldp	x3, x4, [x1, #16]
	ldp	x5, x6, [x1, #32]
	str	x10, [sp, #-32]!
	stp	x2, x30, [sp, #8]       // 8-byte Folded Spill
	mov	x1, x8
	mov	x2, x9
	bl	_kernel_Get_a
	ldr	x30, [sp, #16]          // 8-byte Folded Reload
	add	sp, sp, #32             // =32
	ret
.Lfunc_end9:
	.size	kernel_Get_a, .Lfunc_end9-kernel_Get_a
	.cfi_endproc
                                        // -- End function

	.section	".note.GNU-stack","",@progbits
