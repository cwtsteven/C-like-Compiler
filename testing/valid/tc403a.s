	.section __TEXT,__cstring,cstring_literals
int.str:
	.string "%d\0"
char.str:
	.string "%c\0"
true.str:
	.string "true"
false.str:
	.string "false"

	.data
a: 	.long 5
b: 	.long 10
d: 	.long 5

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
	movabsq (a), %rax
	push %rax
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
	movabsq (a), %rax
	push %rax
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	movabsq %rax, (a)
	push -8(%rbp)
	pop %rax
	mov %rax, -40(%rbp)
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

