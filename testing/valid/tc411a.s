	.section __TEXT,__cstring,cstring_literals
int.str:
	.string "%ld\0"
char.str:
	.string "%c\0"
true.str:
	.string "true"
false.str:
	.string "false"

	.data
Read_int: .quad

	.section __TEXT,__text,regular,pure_instructions


_pure_f: 
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	push -8(%rbp)
	pop %rax
	jmp RETURN

_side_effect: 
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	push -8(%rbp)
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	push -8(%rbp)
	pop %rax
	jmp RETURN

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $48, %rsp
	and $-32, %rsp
	push $1
	pop %rax
	mov %rax, -8(%rbp)
L0: 
	push -8(%rbp)
	push $10
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L1
	push $6
	pop %rax
	mov %rax, -16(%rbp)
	push $8
	pop %rax
	mov %rax, -24(%rbp)
	push $14
	pop %rax
	mov %rax, -32(%rbp)
	push $1
	pop %rax
	mov %rax, %rdi
	call _side_effect
	add $0, %rsp
	mov %rax, -40(%rbp)
	push $8
	pop %rax
	mov %rax, -48(%rbp)
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -8(%rbp)
	jmp L0
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

