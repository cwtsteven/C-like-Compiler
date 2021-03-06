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
a: 	.quad 3
Read_int: .quad

	.section __TEXT,__text,regular,pure_instructions


_f: 
	push %rbp
	mov %rsp, %rbp
	sub $0, %rsp
	and $-32, %rsp
	mov a(%rip), %rax
	push %rax
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, a(%rip)
	jmp RETURN

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $32, %rsp
	and $-32, %rsp
	push $1
	pop %rax
	mov %rax, -8(%rbp)
	push -8(%rbp)
	pop %rax
	mov %rax, -16(%rbp)
	call _f
	add $0, %rsp
	push -8(%rbp)
	pop %rax
	mov %rax, -24(%rbp)
	mov a(%rip), %rax
	push %rax
	pop %rax
	mov %rax, -32(%rbp)
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

