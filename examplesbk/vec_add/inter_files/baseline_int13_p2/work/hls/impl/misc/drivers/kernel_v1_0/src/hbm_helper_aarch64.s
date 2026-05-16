	.text
	.file	"HBM_helper"
	.globl	_kernel_Set_c           // -- Begin function _kernel_Set_c
	.p2align	2
	.type	_kernel_Set_c,@function
_kernel_Set_c:                          // @_kernel_Set_c
	.cfi_startproc
// %bb.0:                               // %entry
	cbz	x2, .LBB0_7
// %bb.1:                               // %entry
	cmp	x3, #1                  // =1
	b.lt	.LBB0_7
// %bb.2:                               // %for.loop.preheader
	mov	x8, xzr
.LBB0_3:                                // %for.loop
                                        // =>This Inner Loop Header: Depth=1
	ldrh	w9, [x2, x8, lsl #1]
	and	x10, x8, #0xfffffffffffffffe
	tbz	w8, #0, .LBB0_5
// %bb.4:                               // %dst.addr.0.0.06.case.1
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x10, x1, x10
	b	.LBB0_6
.LBB0_5:                                //   in Loop: Header=BB0_3 Depth=1
	add	x10, x0, x10
.LBB0_6:                                // %dst.addr.0.0.06.exit
                                        //   in Loop: Header=BB0_3 Depth=1
	add	x8, x8, #1              // =1
	and	w9, w9, #0x1fff
	cmp	x8, x3
	strh	w9, [x10]
	b.ne	.LBB0_3
.LBB0_7:                                // %ret
	ret
.Lfunc_end0:
	.size	_kernel_Set_c, .Lfunc_end0-_kernel_Set_c
	.cfi_endproc
                                        // -- End function
	.globl	kernel_Set_c            // -- Begin function kernel_Set_c
	.p2align	2
	.type	kernel_Set_c,@function
kernel_Set_c:                           // @kernel_Set_c
	.cfi_startproc
// %bb.0:                               // %entry
	str	x30, [sp, #-16]!        // 8-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	ldp	x9, x10, [x0]
	mov	x8, x2
	mov	x11, x1
	mov	x2, x11
	mov	x0, x9
	mov	x1, x10
	mov	x3, x8
	bl	_kernel_Set_c
	ldr	x30, [sp], #16          // 8-byte Folded Reload
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
	cbz	x0, .LBB2_7
// %bb.1:                               // %entry
	cmp	x3, #1                  // =1
	b.lt	.LBB2_7
// %bb.2:                               // %for.loop.preheader
	mov	x8, xzr
.LBB2_3:                                // %for.loop
                                        // =>This Inner Loop Header: Depth=1
	and	x10, x8, #0xfffffffffffffffe
	add	x9, x0, x8, lsl #1
	tbz	w8, #0, .LBB2_5
// %bb.4:                               // %src.addr.0.0.05.case.1
                                        //   in Loop: Header=BB2_3 Depth=1
	add	x10, x2, x10
	b	.LBB2_6
.LBB2_5:                                //   in Loop: Header=BB2_3 Depth=1
	add	x10, x1, x10
.LBB2_6:                                // %src.addr.0.0.05.exit
                                        //   in Loop: Header=BB2_3 Depth=1
	ldrh	w10, [x10]
	add	x8, x8, #1              // =1
	cmp	x8, x3
	and	w10, w10, #0x1fff
	strh	w10, [x9]
	b.ne	.LBB2_3
.LBB2_7:                                // %ret
	ret
.Lfunc_end2:
	.size	_kernel_Get_c, .Lfunc_end2-_kernel_Get_c
	.cfi_endproc
                                        // -- End function
	.globl	kernel_Get_c            // -- Begin function kernel_Get_c
	.p2align	2
	.type	kernel_Get_c,@function
kernel_Get_c:                           // @kernel_Get_c
	.cfi_startproc
// %bb.0:                               // %entry
	str	x30, [sp, #-16]!        // 8-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	mov	x8, x2
	ldp	x9, x2, [x1]
	mov	x3, x8
	mov	x1, x9
	bl	_kernel_Get_c
	ldr	x30, [sp], #16          // 8-byte Folded Reload
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
	cbz	x2, .LBB4_7
// %bb.1:                               // %entry
	cmp	x3, #1                  // =1
	b.lt	.LBB4_7
// %bb.2:                               // %for.loop.preheader
	mov	x8, xzr
.LBB4_3:                                // %for.loop
                                        // =>This Inner Loop Header: Depth=1
	ldrb	w9, [x2, x8]
	lsr	x10, x8, #1
	tbz	w8, #0, .LBB4_5
// %bb.4:                               // %dst.addr.0.0.06.case.1
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x10, x1, x10
	b	.LBB4_6
.LBB4_5:                                //   in Loop: Header=BB4_3 Depth=1
	add	x10, x0, x10
.LBB4_6:                                // %dst.addr.0.0.06.exit
                                        //   in Loop: Header=BB4_3 Depth=1
	add	x8, x8, #1              // =1
	cmp	x8, x3
	strb	w9, [x10]
	b.ne	.LBB4_3
.LBB4_7:                                // %ret
	ret
.Lfunc_end4:
	.size	_kernel_Set_a, .Lfunc_end4-_kernel_Set_a
	.cfi_endproc
                                        // -- End function
	.globl	kernel_Set_b            // -- Begin function kernel_Set_b
	.p2align	2
	.type	kernel_Set_b,@function
kernel_Set_b:                           // @kernel_Set_b
	.cfi_startproc
// %bb.0:                               // %entry
	str	x30, [sp, #-16]!        // 8-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	ldp	x9, x10, [x0]
	mov	x8, x2
	mov	x11, x1
	mov	x2, x11
	mov	x0, x9
	mov	x1, x10
	mov	x3, x8
	bl	_kernel_Set_a
	ldr	x30, [sp], #16          // 8-byte Folded Reload
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
	cbz	x0, .LBB6_4
// %bb.1:                               // %entry
	cmp	x3, #1                  // =1
	b.lt	.LBB6_4
// %bb.2:                               // %for.loop.preheader
	mov	x8, xzr
.LBB6_3:                                // %for.loop
                                        // =>This Inner Loop Header: Depth=1
	lsr	x9, x8, #1
	tst	w8, #0x1
	add	x10, x1, x9
	add	x9, x2, x9
	csel	x9, x10, x9, eq
	ldrb	w9, [x9]
	strb	w9, [x0, x8]
	add	x8, x8, #1              // =1
	cmp	x8, x3
	b.ne	.LBB6_3
.LBB6_4:                                // %ret
	ret
.Lfunc_end6:
	.size	_kernel_Get_a, .Lfunc_end6-_kernel_Get_a
	.cfi_endproc
                                        // -- End function
	.globl	kernel_Get_b            // -- Begin function kernel_Get_b
	.p2align	2
	.type	kernel_Get_b,@function
kernel_Get_b:                           // @kernel_Get_b
	.cfi_startproc
// %bb.0:                               // %entry
	str	x30, [sp, #-16]!        // 8-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	mov	x8, x2
	ldp	x9, x2, [x1]
	mov	x3, x8
	mov	x1, x9
	bl	_kernel_Get_a
	ldr	x30, [sp], #16          // 8-byte Folded Reload
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
	str	x30, [sp, #-16]!        // 8-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	ldp	x9, x10, [x0]
	mov	x8, x2
	mov	x11, x1
	mov	x2, x11
	mov	x0, x9
	mov	x1, x10
	mov	x3, x8
	bl	_kernel_Set_a
	ldr	x30, [sp], #16          // 8-byte Folded Reload
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
	str	x30, [sp, #-16]!        // 8-byte Folded Spill
	.cfi_def_cfa_offset 16
	.cfi_offset w30, -16
	mov	x8, x2
	ldp	x9, x2, [x1]
	mov	x3, x8
	mov	x1, x9
	bl	_kernel_Get_a
	ldr	x30, [sp], #16          // 8-byte Folded Reload
	ret
.Lfunc_end9:
	.size	kernel_Get_a, .Lfunc_end9-kernel_Get_a
	.cfi_endproc
                                        // -- End function

	.section	".note.GNU-stack","",@progbits
