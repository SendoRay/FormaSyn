	.text
	.file	"HBM_helper"
	.globl	_kernel_Set_c           # -- Begin function _kernel_Set_c
	.p2align	4, 0x90
	.type	_kernel_Set_c,@function
_kernel_Set_c:                          # @_kernel_Set_c
	.cfi_startproc
# %bb.0:                                # %entry
	testq	%rdx, %rdx
	je	.LBB0_7
# %bb.1:                                # %copy
	testq	%rcx, %rcx
	jle	.LBB0_7
# %bb.2:                                # %for.loop.lr.ph
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%rax, %r8
	shrq	%r8
	movl	%eax, %r10d
	andl	$1, %r10d
	movzwl	(%rdx,%rax,2), %r9d
	andl	$16383, %r9d            # imm = 0x3FFF
	testq	%r10, %r10
	je	.LBB0_4
# %bb.5:                                # %dst.addr.0.0.06.case.1
                                        #   in Loop: Header=BB0_3 Depth=1
	movw	%r9w, (%rsi,%r8,2)
	jmp	.LBB0_6
	.p2align	4, 0x90
.LBB0_4:                                # %dst.addr.0.0.06.case.0
                                        #   in Loop: Header=BB0_3 Depth=1
	movw	%r9w, (%rdi,%r8,2)
.LBB0_6:                                # %dst.addr.0.0.06.exit
                                        #   in Loop: Header=BB0_3 Depth=1
	incq	%rax
	cmpq	%rcx, %rax
	jne	.LBB0_3
.LBB0_7:                                # %ret
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
	movq	%rdx, %rax
	movq	%rsi, %rcx
	movq	(%rdi), %rdx
	movq	8(%rdi), %rsi
	movq	%rdx, %rdi
	movq	%rcx, %rdx
	movq	%rax, %rcx
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
	je	.LBB2_7
# %bb.1:                                # %copy
	testq	%rcx, %rcx
	jle	.LBB2_7
# %bb.2:                                # %for.loop.lr.ph
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB2_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%r9, %r8
	shrq	%r8
	movl	%r9d, %eax
	andl	$1, %eax
	testq	%rax, %rax
	je	.LBB2_4
# %bb.5:                                # %src.addr.0.0.05.case.1
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%rdx,%r8,2), %r8d
	jmp	.LBB2_6
	.p2align	4, 0x90
.LBB2_4:                                # %src.addr.0.0.05.case.0
                                        #   in Loop: Header=BB2_3 Depth=1
	movzwl	(%rsi,%r8,2), %r8d
.LBB2_6:                                # %src.addr.0.0.05.exit
                                        #   in Loop: Header=BB2_3 Depth=1
	andl	$16383, %r8d            # imm = 0x3FFF
	movw	%r8w, (%rdi,%r9,2)
	incq	%r9
	cmpq	%rcx, %r9
	jne	.LBB2_3
.LBB2_7:                                # %ret
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
	movq	%rdx, %rax
	movq	(%rsi), %rcx
	movq	8(%rsi), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rcx
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
	testq	%rdx, %rdx
	je	.LBB4_7
# %bb.1:                                # %copy
	testq	%rcx, %rcx
	jle	.LBB4_7
# %bb.2:                                # %for.loop.lr.ph
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB4_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%rax, %r8
	shrq	%r8
	movl	%eax, %r10d
	andl	$1, %r10d
	movzbl	(%rdx,%rax), %r9d
	testq	%r10, %r10
	je	.LBB4_4
# %bb.5:                                # %dst.addr.0.0.06.case.1
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r9b, (%rsi,%r8)
	jmp	.LBB4_6
	.p2align	4, 0x90
.LBB4_4:                                # %dst.addr.0.0.06.case.0
                                        #   in Loop: Header=BB4_3 Depth=1
	movb	%r9b, (%rdi,%r8)
.LBB4_6:                                # %dst.addr.0.0.06.exit
                                        #   in Loop: Header=BB4_3 Depth=1
	incq	%rax
	cmpq	%rcx, %rax
	jne	.LBB4_3
.LBB4_7:                                # %ret
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
	movq	%rdx, %rax
	movq	%rsi, %rcx
	movq	(%rdi), %rdx
	movq	8(%rdi), %rsi
	movq	%rdx, %rdi
	movq	%rcx, %rdx
	movq	%rax, %rcx
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
	je	.LBB6_7
# %bb.1:                                # %copy
	testq	%rcx, %rcx
	jle	.LBB6_7
# %bb.2:                                # %for.loop.lr.ph
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB6_3:                                # %for.loop
                                        # =>This Inner Loop Header: Depth=1
	movq	%r9, %r8
	shrq	%r8
	movl	%r9d, %eax
	andl	$1, %eax
	testq	%rax, %rax
	je	.LBB6_4
# %bb.5:                                # %src.addr.0.0.05.case.1
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%rdx,%r8), %r8d
	jmp	.LBB6_6
	.p2align	4, 0x90
.LBB6_4:                                # %src.addr.0.0.05.case.0
                                        #   in Loop: Header=BB6_3 Depth=1
	movzbl	(%rsi,%r8), %r8d
.LBB6_6:                                # %src.addr.0.0.05.exit
                                        #   in Loop: Header=BB6_3 Depth=1
	movb	%r8b, (%rdi,%r9)
	incq	%r9
	cmpq	%rcx, %r9
	jne	.LBB6_3
.LBB6_7:                                # %ret
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
	movq	%rdx, %rax
	movq	(%rsi), %rcx
	movq	8(%rsi), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rcx
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
	movq	%rdx, %rax
	movq	%rsi, %rcx
	movq	(%rdi), %rdx
	movq	8(%rdi), %rsi
	movq	%rdx, %rdi
	movq	%rcx, %rdx
	movq	%rax, %rcx
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
	movq	%rdx, %rax
	movq	(%rsi), %rcx
	movq	8(%rsi), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rcx
	callq	_kernel_Get_a
	popq	%rax
	retq
.Lfunc_end9:
	.size	kernel_Get_a, .Lfunc_end9-kernel_Get_a
	.cfi_endproc
                                        # -- End function

	.section	".note.GNU-stack","",@progbits
