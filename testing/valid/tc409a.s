	.section __TEXT,__cstring,cstring_literals
int.str:
	.string "%d\0"
char.str:
	.string "%c\0"
true.str:
	.string "true"
false.str:
	.string "false"


	.section __TEXT,__text,regular,pure_instructions

_plus: 
	push %rbp
	mov %rsp, %rbp
	sub $16, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	mov %rsi, -16(%rbp)
	push -8(%rbp)
	push -16(%rbp)
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
	sub $16, %rsp
	and $-32, %rsp
	push $1
	pop %rax
	mov %rax, -8(%rbp)
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -16(%rbp)
	push $3
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

