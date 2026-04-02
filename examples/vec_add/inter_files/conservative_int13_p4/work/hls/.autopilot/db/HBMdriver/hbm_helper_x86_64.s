	.text
	.file	"HBM_helper"
	.globl	_kernel_Set_c           # -- Begin function _kernel_Set_c
	.p2align	4, 0x90
	.type	_kernel_Set_c,@function
_kernel_Set_c:                          # @_kernel_Set_c
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	testq	%r8, %r8
	je	.LBB0_11
# %bb.1:                                # %copy
	testq	%r9, %r9
	jle	.LBB0_11
# %bb.2:                                # %for.loop.lr.ph
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%rax, %r10
	shrq	$2, %r10
	movl	%eax, %ebx
	andl	$3, %ebx
	movzwl	(%r8,%rax,2), %r11d
	andl	$8191, %r11d            # imm = 0x1FFF
	cmpq	$2, %rbx
	je	.LBB0_8
# %bb.4:                                # %for.loop
                                        #   in Loop: Header=BB0_3 Depth=1
	cmpq	$1, %rbx
	je	.LBB0_7
# %bb.5:                                # %for.loop
                                        #   in Loop: Header=BB0_3 Depth=1
	testq	%rbx, %rbx
	jne	.LBB0_9
# %bb.6:                                # %dst.addr.0.0.06.case.0
                                        #   in Loop: Header=BB0_3 Depth=1
	movw	%r11w, (%rdi,%r10,2)
	jmp	.LBB0_10
	.p2align	4, 0x90
.LBB0_7:                                # %dst.addr.0.0.06.case.1
                                        #   in Loop: Header=BB0_3 Depth=1
	movw	%r11w, (%rsi,%r10,2)
	jmp	.LBB0_10
	.p2align	4, 0x90
.LBB0_8:                                # %dst.addr.0.0.06.case.2
                                        #   in Loop: Header=BB0_3 Depth=1
	movw	%r11w, (%rdx,%r10,2)
	jmp	.LBB0_10
	.p2align	4, 0x90
.LBB0_9:                                # %dst.addr.0.0.06.case.3
                                        #   in Loop: Header=BB0_3 Depth=1
	movw	%r11w, (%rcx,%r10,2)
.LBB0_10:                               # %dst.addr.0.0.06.exit
                                        #   in Loop: Header=BB0_3 Depth=1
	incq	%rax
	cmpq	%r9, %rax
	jne	.LBB0_3
.LBB0_11:                               # %ret
	popq	%rbx
	retq
.Lfunc_end0:
	.size	_kernel_Set_c, .Lfunc_end0-_kernel_Set_c
	.cfi_endproc
                                        # -- End function
	.globl	kernel_Set_c            # -- Begin function kernel_Set_c
	.p2align	4, 0x90
	.type	kernel_Set_c,@function
kernel_Set_c:                           # @kernel_Set_c
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r9
	movq	%rsi, %r8
	movq	(%rdi), %rax
	movq	8(%rdi), %rsi
	movq	16(%rdi), %rdx
	movq	24(%rdi), %rcx
	movq	%rax, %rdi
	callq	_kernel_Set_c
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
	testq	%rdi, %rdi
	je	.LBB2_11
# %bb.1:                                # %copy
	testq	%r9, %r9
	jle	.LBB2_11
# %bb.2:                                # %for.loop.lr.ph
	xorl	%r11d, %r11d
	.p2align	4, 0x90
.LBB2_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%r11, %r10
	shrq	$2, %r10
	movl	%r11d, %eax
	andl	$3, %eax
	cmpq	$2, %rax
	je	.LBB2_8
# %bb.4:                                # %for.loop
                                        #   in Loop: Header=BB2_3 Depth=1
	cmpq	$1, %rax
	je	.LBB2_7
# %bb.5:                                # %for.loop
                                        #   in Loop: Header=BB2_3 Depth=1
	testq	%rax, %rax
	jne	.LBB2_9
# %bb.6:                                # %src.addr.0.0.05.case.0
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%rsi,%r10,2), %r10d
	jmp	.LBB2_10
	.p2align	4, 0x90
.LBB2_7:                                # %src.addr.0.0.05.case.1
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%rdx,%r10,2), %r10d
	jmp	.LBB2_10
	.p2align	4, 0x90
.LBB2_8:                                # %src.addr.0.0.05.case.2
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%rcx,%r10,2), %r10d
	jmp	.LBB2_10
	.p2align	4, 0x90
.LBB2_9:                                # %src.addr.0.0.05.case.3
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%r8,%r10,2), %r10d
.LBB2_10:                               # %src.addr.0.0.05.exit
                                        #   in Loop: Header=BB2_3 Depth=1
	andl	$8191, %r10d            # imm = 0x1FFF
	movw	%r10w, (%rdi,%r11,2)
	incq	%r11
	cmpq	%r9, %r11
	jne	.LBB2_3
.LBB2_11:                               # %ret
	retq
.Lfunc_end2:
	.size	_kernel_Get_c, .Lfunc_end2-_kernel_Get_c
	.cfi_endproc
                                        # -- End function
	.globl	kernel_Get_c            # -- Begin function kernel_Get_c
	.p2align	4, 0x90
	.type	kernel_Get_c,@function
kernel_Get_c:                           # @kernel_Get_c
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r9
	movq	(%rsi), %rax
	movq	8(%rsi), %rdx
	movq	16(%rsi), %rcx
	movq	24(%rsi), %r8
	movq	%rax, %rsi
	callq	_kernel_Get_c
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
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	testq	%r8, %r8
	je	.LBB4_11
# %bb.1:                                # %copy
	testq	%r9, %r9
	jle	.LBB4_11
# %bb.2:                                # %for.loop.lr.ph
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB4_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%rax, %r10
	shrq	$2, %r10
	movl	%eax, %ebx
	andl	$3, %ebx
	movzbl	(%r8,%rax), %r11d
	cmpq	$2, %rbx
	je	.LBB4_8
# %bb.4:                                # %for.loop
                                        #   in Loop: Header=BB4_3 Depth=1
	cmpq	$1, %rbx
	je	.LBB4_7
# %bb.5:                                # %for.loop
                                        #   in Loop: Header=BB4_3 Depth=1
	testq	%rbx, %rbx
	jne	.LBB4_9
# %bb.6:                                # %dst.addr.0.0.06.case.0
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r11b, (%rdi,%r10)
	jmp	.LBB4_10
	.p2align	4, 0x90
.LBB4_7:                                # %dst.addr.0.0.06.case.1
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r11b, (%rsi,%r10)
	jmp	.LBB4_10
	.p2align	4, 0x90
.LBB4_8:                                # %dst.addr.0.0.06.case.2
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r11b, (%rdx,%r10)
	jmp	.LBB4_10
	.p2align	4, 0x90
.LBB4_9:                                # %dst.addr.0.0.06.case.3
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r11b, (%rcx,%r10)
.LBB4_10:                               # %dst.addr.0.0.06.exit
                                        #   in Loop: Header=BB4_3 Depth=1
	incq	%rax
	cmpq	%r9, %rax
	jne	.LBB4_3
.LBB4_11:                               # %ret
	popq	%rbx
	retq
.Lfunc_end4:
	.size	_kernel_Set_a, .Lfunc_end4-_kernel_Set_a
	.cfi_endproc
                                        # -- End function
	.globl	kernel_Set_b            # -- Begin function kernel_Set_b
	.p2align	4, 0x90
	.type	kernel_Set_b,@function
kernel_Set_b:                           # @kernel_Set_b
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r9
	movq	%rsi, %r8
	movq	(%rdi), %rax
	movq	8(%rdi), %rsi
	movq	16(%rdi), %rdx
	movq	24(%rdi), %rcx
	movq	%rax, %rdi
	callq	_kernel_Set_a
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
	testq	%rdi, %rdi
	je	.LBB6_11
# %bb.1:                                # %copy
	testq	%r9, %r9
	jle	.LBB6_11
# %bb.2:                                # %for.loop.lr.ph
	xorl	%r11d, %r11d
	.p2align	4, 0x90
.LBB6_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%r11, %r10
	shrq	$2, %r10
	movl	%r11d, %eax
	andl	$3, %eax
	cmpq	$2, %rax
	je	.LBB6_8
# %bb.4:                                # %for.loop
                                        #   in Loop: Header=BB6_3 Depth=1
	cmpq	$1, %rax
	je	.LBB6_7
# %bb.5:                                # %for.loop
                                        #   in Loop: Header=BB6_3 Depth=1
	testq	%rax, %rax
	jne	.LBB6_9
# %bb.6:                                # %src.addr.0.0.05.case.0
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%rsi,%r10), %r10d
	jmp	.LBB6_10
	.p2align	4, 0x90
.LBB6_7:                                # %src.addr.0.0.05.case.1
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%rdx,%r10), %r10d
	jmp	.LBB6_10
	.p2align	4, 0x90
.LBB6_8:                                # %src.addr.0.0.05.case.2
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%rcx,%r10), %r10d
	jmp	.LBB6_10
	.p2align	4, 0x90
.LBB6_9:                                # %src.addr.0.0.05.case.3
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%r8,%r10), %r10d
.LBB6_10:                               # %src.addr.0.0.05.exit
                                        #   in Loop: Header=BB6_3 Depth=1
	movb	%r10b, (%rdi,%r11)
	incq	%r11
	cmpq	%r9, %r11
	jne	.LBB6_3
.LBB6_11:                               # %ret
	retq
.Lfunc_end6:
	.size	_kernel_Get_a, .Lfunc_end6-_kernel_Get_a
	.cfi_endproc
                                        # -- End function
	.globl	kernel_Get_b            # -- Begin function kernel_Get_b
	.p2align	4, 0x90
	.type	kernel_Get_b,@function
kernel_Get_b:                           # @kernel_Get_b
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdx, %r9
	movq	(%rsi), %rax
	movq	8(%rsi), %rdx
	movq	16(%rsi), %rcx
	movq	24(%rsi), %r8
	movq	%rax, %rsi
	callq	_kernel_Get_a
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
	movq	%rdx, %r9
	movq	%rsi, %r8
	movq	(%rdi), %rax
	movq	8(%rdi), %rsi
	movq	16(%rdi), %rdx
	movq	24(%rdi), %rcx
	movq	%rax, %rdi
	callq	_kernel_Set_a
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
	movq	%rdx, %r9
	movq	(%rsi), %rax
	movq	8(%rsi), %rdx
	movq	16(%rsi), %rcx
	movq	24(%rsi), %r8
	movq	%rax, %rsi
	callq	_kernel_Get_a
	popq	%rax
	retq
.Lfunc_end9:
	.size	kernel_Get_a, .Lfunc_end9-kernel_Get_a
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
