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
b: 	.quad 10
d: 	.quad 5
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
	sub $40, %rsp
	and $-32, %rsp
	push $5
	pop %rax
	mov %rax, -8(%rbp)
	push $1
	pop %rax
	mov %rax, -16(%rbp)
	push $2
	pop %rax
	mov %rax, -24(%rbp)
	push $10
	pop %rax
	mov %rax, -32(%rbp)
	mov a(%rip), %rax
	push %rax
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, a(%rip)
	push $5
	pop %rax
	mov %rax, -40(%rbp)
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

