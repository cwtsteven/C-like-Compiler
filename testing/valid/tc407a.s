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
a: 	.quad 5
b: 	.quad 6
Read_int: .quad

	.section __TEXT,__text,regular,pure_instructions


_double: 
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	push -8(%rbp)
	push -8(%rbp)
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	jmp RETURN

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $24, %rsp
	and $-32, %rsp
	push $3
	pop %rax
	mov %rax, -8(%rbp)
	push $5
	pop %rax
	mov %rax, -16(%rbp)
	push $1
	pop %rax
	cmp $1, %rax
	jne L0
	push $20
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	jmp L1
L0: 
L1: 
	push -16(%rbp)
	pop %rax
	mov %rax, -24(%rbp)
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

