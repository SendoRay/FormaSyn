	.text
	.file	"HBM_helper"
	.globl	_kernel_Set_c           # -- Begin function _kernel_Set_c
	.p2align	4, 0x90
	.type	_kernel_Set_c,@function
_kernel_Set_c:                          # @_kernel_Set_c
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	64(%rsp), %r15
	testq	%r15, %r15
	je	.LBB0_14
# %bb.1:                                # %copy
	movq	72(%rsp), %r10
	testq	%r10, %r10
	jle	.LBB0_14
# %bb.2:                                # %for.loop.lr.ph
	movq	56(%rsp), %r11
	movq	48(%rsp), %r14
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%rax, %r12
	shrq	$3, %r12
	movl	%eax, %ebx
	andl	$7, %ebx
	movzwl	(%r15,%rax,2), %ebp
	cmpq	$6, %rbx
	ja	.LBB0_12
# %bb.4:                                # %for.loop
                                        #   in Loop: Header=BB0_3 Depth=1
	jmpq	*JTI0_0(,%rbx,8)
.LBB0_5:                                # %dst.addr.0.0.06.case.0
                                        #   in Loop: Header=BB0_3 Depth=1
	andl	$32767, %ebp            # imm = 0x7FFF
	movw	%bp, (%rdi,%r12,2)
	jmp	.LBB0_13
.LBB0_7:                                # %dst.addr.0.0.06.case.2
                                        #   in Loop: Header=BB0_3 Depth=1
	andl	$32767, %ebp            # imm = 0x7FFF
	movw	%bp, (%rdx,%r12,2)
	jmp	.LBB0_13
.LBB0_8:                                # %dst.addr.0.0.06.case.3
                                        #   in Loop: Header=BB0_3 Depth=1
	andl	$32767, %ebp            # imm = 0x7FFF
	movw	%bp, (%rcx,%r12,2)
	jmp	.LBB0_13
.LBB0_9:                                # %dst.addr.0.0.06.case.4
                                        #   in Loop: Header=BB0_3 Depth=1
	andl	$32767, %ebp            # imm = 0x7FFF
	movw	%bp, (%r8,%r12,2)
	jmp	.LBB0_13
.LBB0_12:                               # %dst.addr.0.0.06.case.7
                                        #   in Loop: Header=BB0_3 Depth=1
	andl	$32767, %ebp            # imm = 0x7FFF
	movw	%bp, (%r11,%r12,2)
	jmp	.LBB0_13
.LBB0_6:                                # %dst.addr.0.0.06.case.1
                                        #   in Loop: Header=BB0_3 Depth=1
	andl	$32767, %ebp            # imm = 0x7FFF
	movw	%bp, (%rsi,%r12,2)
	jmp	.LBB0_13
.LBB0_10:                               # %dst.addr.0.0.06.case.5
                                        #   in Loop: Header=BB0_3 Depth=1
	andl	$32767, %ebp            # imm = 0x7FFF
	movw	%bp, (%r9,%r12,2)
	jmp	.LBB0_13
.LBB0_11:                               # %dst.addr.0.0.06.case.6
                                        #   in Loop: Header=BB0_3 Depth=1
	andl	$32767, %ebp            # imm = 0x7FFF
	movw	%bp, (%r14,%r12,2)
	.p2align	4, 0x90
.LBB0_13:                               # %dst.addr.0.0.06.exit
                                        #   in Loop: Header=BB0_3 Depth=1
	incq	%rax
	cmpq	%r10, %rax
	jne	.LBB0_3
.LBB0_14:                               # %ret
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end0:
	.size	_kernel_Set_c, .Lfunc_end0-_kernel_Set_c
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
JTI0_0:
	.quad	.LBB0_5
	.quad	.LBB0_6
	.quad	.LBB0_7
	.quad	.LBB0_8
	.quad	.LBB0_9
	.quad	.LBB0_10
	.quad	.LBB0_11
                                        # -- End function
	.text
	.globl	kernel_Set_c            # -- Begin function kernel_Set_c
	.p2align	4, 0x90
	.type	kernel_Set_c,@function
kernel_Set_c:                           # @kernel_Set_c
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r11
	movq	%rsi, %r10
	movq	%rdi, %rax
	movq	(%rax), %rdi
	movq	8(%rax), %rsi
	movq	16(%rax), %rdx
	movq	24(%rax), %rcx
	movq	32(%rax), %r8
	movq	40(%rax), %r9
	pushq	%r11
	.cfi_adjust_cfa_offset 8
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	pushq	56(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	48(%rax)
	.cfi_adjust_cfa_offset 8
	callq	_kernel_Set_c
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	popq	%rax
	retq
.Lfunc_end1:
	.size	kernel_Set_c, .Lfunc_end1-kernel_Set_c
	.cfi_endproc
                                        # -- End function
	.globl	_kernel_Get_c           # -- Begin function _kernel_Get_c
	.p2align	4, 0x90
	.type	_kernel_Get_c,@function
_kernel_Get_c:                          # @_kernel_Get_c
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	testq	%rdi, %rdi
	je	.LBB2_14
# %bb.1:                                # %copy
	movq	64(%rsp), %r15
	testq	%r15, %r15
	jle	.LBB2_14
# %bb.2:                                # %for.loop.lr.ph
	movq	56(%rsp), %r10
	movq	48(%rsp), %r11
	movq	40(%rsp), %r14
	xorl	%ebp, %ebp
	.p2align	4, 0x90
.LBB2_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%rbp, %rax
	shrq	$3, %rax
	movl	%ebp, %ebx
	andl	$7, %ebx
	cmpq	$6, %rbx
	ja	.LBB2_12
# %bb.4:                                # %for.loop
                                        #   in Loop: Header=BB2_3 Depth=1
	jmpq	*JTI2_0(,%rbx,8)
.LBB2_5:                                # %src.addr.0.0.05.case.0
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%rsi,%rax,2), %eax
	jmp	.LBB2_13
.LBB2_7:                                # %src.addr.0.0.05.case.2
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%rcx,%rax,2), %eax
	jmp	.LBB2_13
.LBB2_8:                                # %src.addr.0.0.05.case.3
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%r8,%rax,2), %eax
	jmp	.LBB2_13
.LBB2_9:                                # %src.addr.0.0.05.case.4
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%r9,%rax,2), %eax
	jmp	.LBB2_13
.LBB2_12:                               # %src.addr.0.0.05.case.7
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%r10,%rax,2), %eax
	jmp	.LBB2_13
.LBB2_6:                                # %src.addr.0.0.05.case.1
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%rdx,%rax,2), %eax
	jmp	.LBB2_13
.LBB2_10:                               # %src.addr.0.0.05.case.5
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%r14,%rax,2), %eax
	jmp	.LBB2_13
.LBB2_11:                               # %src.addr.0.0.05.case.6
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%r11,%rax,2), %eax
	.p2align	4, 0x90
.LBB2_13:                               # %src.addr.0.0.05.exit
                                        #   in Loop: Header=BB2_3 Depth=1
	andl	$32767, %eax            # imm = 0x7FFF
	movw	%ax, (%rdi,%rbp,2)
	incq	%rbp
	cmpq	%r15, %rbp
	jne	.LBB2_3
.LBB2_14:                               # %ret
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end2:
	.size	_kernel_Get_c, .Lfunc_end2-_kernel_Get_c
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
JTI2_0:
	.quad	.LBB2_5
	.quad	.LBB2_6
	.quad	.LBB2_7
	.quad	.LBB2_8
	.quad	.LBB2_9
	.quad	.LBB2_10
	.quad	.LBB2_11
                                        # -- End function
	.text
	.globl	kernel_Get_c            # -- Begin function kernel_Get_c
	.p2align	4, 0x90
	.type	kernel_Get_c,@function
kernel_Get_c:                           # @kernel_Get_c
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r10
	movq	%rsi, %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	movq	16(%rax), %rcx
	movq	24(%rax), %r8
	movq	32(%rax), %r9
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	pushq	56(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	48(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	40(%rax)
	.cfi_adjust_cfa_offset 8
	callq	_kernel_Get_c
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	popq	%rax
	retq
.Lfunc_end3:
	.size	kernel_Get_c, .Lfunc_end3-kernel_Get_c
	.cfi_endproc
                                        # -- End function
	.globl	_kernel_Set_a           # -- Begin function _kernel_Set_a
	.p2align	4, 0x90
	.type	_kernel_Set_a,@function
_kernel_Set_a:                          # @_kernel_Set_a
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r12
	.cfi_def_cfa_offset 40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	64(%rsp), %r10
	testq	%r10, %r10
	je	.LBB4_14
# %bb.1:                                # %copy
	movq	72(%rsp), %r15
	testq	%r15, %r15
	jle	.LBB4_14
# %bb.2:                                # %for.loop.lr.ph
	movq	56(%rsp), %r11
	movq	48(%rsp), %r14
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB4_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%rax, %rbp
	shrq	$3, %rbp
	movl	%eax, %ebx
	andl	$7, %ebx
	movzbl	(%r10,%rax), %r12d
	cmpq	$6, %rbx
	ja	.LBB4_12
# %bb.4:                                # %for.loop
                                        #   in Loop: Header=BB4_3 Depth=1
	jmpq	*JTI4_0(,%rbx,8)
.LBB4_5:                                # %dst.addr.0.0.06.case.0
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r12b, (%rdi,%rbp)
	jmp	.LBB4_13
.LBB4_7:                                # %dst.addr.0.0.06.case.2
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r12b, (%rdx,%rbp)
	jmp	.LBB4_13
.LBB4_8:                                # %dst.addr.0.0.06.case.3
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r12b, (%rcx,%rbp)
	jmp	.LBB4_13
.LBB4_9:                                # %dst.addr.0.0.06.case.4
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r12b, (%r8,%rbp)
	jmp	.LBB4_13
.LBB4_12:                               # %dst.addr.0.0.06.case.7
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r12b, (%r11,%rbp)
	jmp	.LBB4_13
.LBB4_6:                                # %dst.addr.0.0.06.case.1
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r12b, (%rsi,%rbp)
	jmp	.LBB4_13
.LBB4_10:                               # %dst.addr.0.0.06.case.5
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r12b, (%r9,%rbp)
	jmp	.LBB4_13
.LBB4_11:                               # %dst.addr.0.0.06.case.6
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r12b, (%r14,%rbp)
	.p2align	4, 0x90
.LBB4_13:                               # %dst.addr.0.0.06.exit
                                        #   in Loop: Header=BB4_3 Depth=1
	incq	%rax
	cmpq	%r15, %rax
	jne	.LBB4_3
.LBB4_14:                               # %ret
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end4:
	.size	_kernel_Set_a, .Lfunc_end4-_kernel_Set_a
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
JTI4_0:
	.quad	.LBB4_5
	.quad	.LBB4_6
	.quad	.LBB4_7
	.quad	.LBB4_8
	.quad	.LBB4_9
	.quad	.LBB4_10
	.quad	.LBB4_11
                                        # -- End function
	.text
	.globl	kernel_Set_b            # -- Begin function kernel_Set_b
	.p2align	4, 0x90
	.type	kernel_Set_b,@function
kernel_Set_b:                           # @kernel_Set_b
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r11
	movq	%rsi, %r10
	movq	%rdi, %rax
	movq	(%rax), %rdi
	movq	8(%rax), %rsi
	movq	16(%rax), %rdx
	movq	24(%rax), %rcx
	movq	32(%rax), %r8
	movq	40(%rax), %r9
	pushq	%r11
	.cfi_adjust_cfa_offset 8
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	pushq	56(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	48(%rax)
	.cfi_adjust_cfa_offset 8
	callq	_kernel_Set_a
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	popq	%rax
	retq
.Lfunc_end5:
	.size	kernel_Set_b, .Lfunc_end5-kernel_Set_b
	.cfi_endproc
                                        # -- End function
	.globl	_kernel_Get_a           # -- Begin function _kernel_Get_a
	.p2align	4, 0x90
	.type	_kernel_Get_a,@function
_kernel_Get_a:                          # @_kernel_Get_a
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	testq	%rdi, %rdi
	je	.LBB6_14
# %bb.1:                                # %copy
	movq	64(%rsp), %r15
	testq	%r15, %r15
	jle	.LBB6_14
# %bb.2:                                # %for.loop.lr.ph
	movq	56(%rsp), %r10
	movq	48(%rsp), %r11
	movq	40(%rsp), %r14
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB6_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%rax, %r12
	shrq	$3, %r12
	movl	%eax, %ebx
	andl	$7, %ebx
	cmpq	$6, %rbx
	ja	.LBB6_12
# %bb.4:                                # %for.loop
                                        #   in Loop: Header=BB6_3 Depth=1
	jmpq	*JTI6_0(,%rbx,8)
.LBB6_5:                                # %src.addr.0.0.05.case.0
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%rsi,%r12), %ebx
	jmp	.LBB6_13
.LBB6_7:                                # %src.addr.0.0.05.case.2
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%rcx,%r12), %ebx
	jmp	.LBB6_13
.LBB6_8:                                # %src.addr.0.0.05.case.3
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%r8,%r12), %ebx
	jmp	.LBB6_13
.LBB6_9:                                # %src.addr.0.0.05.case.4
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%r9,%r12), %ebx
	jmp	.LBB6_13
.LBB6_12:                               # %src.addr.0.0.05.case.7
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%r10,%r12), %ebx
	jmp	.LBB6_13
.LBB6_6:                                # %src.addr.0.0.05.case.1
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%rdx,%r12), %ebx
	jmp	.LBB6_13
.LBB6_10:                               # %src.addr.0.0.05.case.5
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%r14,%r12), %ebx
	jmp	.LBB6_13
.LBB6_11:                               # %src.addr.0.0.05.case.6
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%r11,%r12), %ebx
	.p2align	4, 0x90
.LBB6_13:                               # %src.addr.0.0.05.exit
                                        #   in Loop: Header=BB6_3 Depth=1
	movb	%bl, (%rdi,%rax)
	incq	%rax
	cmpq	%r15, %rax
	jne	.LBB6_3
.LBB6_14:                               # %ret
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
.Lfunc_end6:
	.size	_kernel_Get_a, .Lfunc_end6-_kernel_Get_a
	.cfi_endproc
	.section	.rodata,"a",@progbits
	.p2align	3
JTI6_0:
	.quad	.LBB6_5
	.quad	.LBB6_6
	.quad	.LBB6_7
	.quad	.LBB6_8
	.quad	.LBB6_9
	.quad	.LBB6_10
	.quad	.LBB6_11
                                        # -- End function
	.text
	.globl	kernel_Get_b            # -- Begin function kernel_Get_b
	.p2align	4, 0x90
	.type	kernel_Get_b,@function
kernel_Get_b:                           # @kernel_Get_b
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r10
	movq	%rsi, %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	movq	16(%rax), %rcx
	movq	24(%rax), %r8
	movq	32(%rax), %r9
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	pushq	56(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	48(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	40(%rax)
	.cfi_adjust_cfa_offset 8
	callq	_kernel_Get_a
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	popq	%rax
	retq
.Lfunc_end7:
	.size	kernel_Get_b, .Lfunc_end7-kernel_Get_b
	.cfi_endproc
                                        # -- End function
	.globl	kernel_Set_a            # -- Begin function kernel_Set_a
	.p2align	4, 0x90
	.type	kernel_Set_a,@function
kernel_Set_a:                           # @kernel_Set_a
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r11
	movq	%rsi, %r10
	movq	%rdi, %rax
	movq	(%rax), %rdi
	movq	8(%rax), %rsi
	movq	16(%rax), %rdx
	movq	24(%rax), %rcx
	movq	32(%rax), %r8
	movq	40(%rax), %r9
	pushq	%r11
	.cfi_adjust_cfa_offset 8
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	pushq	56(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	48(%rax)
	.cfi_adjust_cfa_offset 8
	callq	_kernel_Set_a
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	popq	%rax
	retq
.Lfunc_end8:
	.size	kernel_Set_a, .Lfunc_end8-kernel_Set_a
	.cfi_endproc
                                        # -- End function
	.globl	kernel_Get_a            # -- Begin function kernel_Get_a
	.p2align	4, 0x90
	.type	kernel_Get_a,@function
kernel_Get_a:                           # @kernel_Get_a
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r10
	movq	%rsi, %rax
	movq	(%rax), %rsi
	movq	8(%rax), %rdx
	movq	16(%rax), %rcx
	movq	24(%rax), %r8
	movq	32(%rax), %r9
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	pushq	56(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	48(%rax)
	.cfi_adjust_cfa_offset 8
	pushq	40(%rax)
	.cfi_adjust_cfa_offset 8
	callq	_kernel_Get_a
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	popq	%rax
	retq
.Lfunc_end9:
	.size	kernel_Get_a, .Lfunc_end9-kernel_Get_a
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
