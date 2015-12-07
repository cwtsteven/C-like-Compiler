	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 10
	.globl	_fibonacci
	.align	4, 0x90
_fibonacci:                             ## @fibonacci
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp0:
	.cfi_def_cfa_offset 16
Ltmp1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp2:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -8(%rbp)
	cmpl	$1, -8(%rbp)
	jg	LBB0_2
## BB#1:
	movl	-8(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	LBB0_3
LBB0_2:
	movl	-8(%rbp), %eax
	subl	$1, %eax
	movl	%eax, %edi
	callq	_fibonacci
	movl	-8(%rbp), %edi
	subl	$2, %edi
	movl	%eax, -12(%rbp)         ## 4-byte Spill
	callq	_fibonacci
	movl	-12(%rbp), %edi         ## 4-byte Reload
	addl	%eax, %edi
	movl	%edi, -4(%rbp)
LBB0_3:
	movl	-4(%rbp), %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_factorial
	.align	4, 0x90
_factorial:                             ## @factorial
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp3:
	.cfi_def_cfa_offset 16
Ltmp4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp5:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -8(%rbp)
	cmpl	$1, -8(%rbp)
	jg	LBB1_2
## BB#1:
	movl	$1, -4(%rbp)
	jmp	LBB1_3
LBB1_2:
	movl	-8(%rbp), %eax
	movl	-8(%rbp), %ecx
	subl	$1, %ecx
	movl	%ecx, %edi
	movl	%eax, -12(%rbp)         ## 4-byte Spill
	callq	_factorial
	movl	-12(%rbp), %ecx         ## 4-byte Reload
	imull	%eax, %ecx
	movl	%ecx, -4(%rbp)
LBB1_3:
	movl	-4(%rbp), %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_main
	.align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp6:
	.cfi_def_cfa_offset 16
Ltmp7:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp8:
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movl	$0, -4(%rbp)
	movl	$100, -8(%rbp)
	movl	$0, -12(%rbp)
LBB2_1:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB2_3 Depth 2
                                        ##       Child Loop BB2_5 Depth 3
	movl	-12(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jge	LBB2_17
## BB#2:                                ##   in Loop: Header=BB2_1 Depth=1
	movl	$0, -16(%rbp)
LBB2_3:                                 ##   Parent Loop BB2_1 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB2_5 Depth 3
	movl	-16(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jge	LBB2_15
## BB#4:                                ##   in Loop: Header=BB2_3 Depth=2
	movl	$0, -20(%rbp)
LBB2_5:                                 ##   Parent Loop BB2_1 Depth=1
                                        ##     Parent Loop BB2_3 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movl	-20(%rbp), %eax
	cmpl	-8(%rbp), %eax
	jge	LBB2_12
## BB#6:                                ##   in Loop: Header=BB2_5 Depth=3
	cmpl	$50, -20(%rbp)
	jle	LBB2_8
## BB#7:                                ##   in Loop: Header=BB2_3 Depth=2
	jmp	LBB2_13
LBB2_8:                                 ##   in Loop: Header=BB2_5 Depth=3
	movl	-12(%rbp), %edi
	callq	_fibonacci
	movl	-12(%rbp), %edi
	movl	%eax, -24(%rbp)         ## 4-byte Spill
	callq	_factorial
	leaq	L_.str(%rip), %rdi
	movl	-24(%rbp), %ecx         ## 4-byte Reload
	addl	%eax, %ecx
	movl	%ecx, %esi
	movb	$0, %al
	callq	_printf
	cmpl	$25, -12(%rbp)
	movl	%eax, -28(%rbp)         ## 4-byte Spill
	jne	LBB2_10
## BB#9:
	jmp	LBB2_18
LBB2_10:                                ##   in Loop: Header=BB2_5 Depth=3
	jmp	LBB2_11
LBB2_11:                                ##   in Loop: Header=BB2_5 Depth=3
	movl	-20(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -20(%rbp)
	jmp	LBB2_5
LBB2_12:                                ##   in Loop: Header=BB2_3 Depth=2
	jmp	LBB2_13
LBB2_13:                                ##   in Loop: Header=BB2_3 Depth=2
	jmp	LBB2_14
LBB2_14:                                ##   in Loop: Header=BB2_3 Depth=2
	movl	-16(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -16(%rbp)
	jmp	LBB2_3
LBB2_15:                                ##   in Loop: Header=BB2_1 Depth=1
	jmp	LBB2_16
LBB2_16:                                ##   in Loop: Header=BB2_1 Depth=1
	movl	-12(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -12(%rbp)
	jmp	LBB2_1
LBB2_17:
	jmp	LBB2_18
LBB2_18:
	xorl	%eax, %eax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d"


.subsections_via_symbols
