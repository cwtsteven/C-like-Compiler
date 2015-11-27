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
a: 	.byte 1
Read_int: .long

	.section __TEXT,__text,regular,pure_instructions


_f: 
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	push -8(%rbp)
	pop %rax
	cmp $1, %rax
	jne L0
	push $1
	pop %rax
	jmp RETURN
	jmp L1
L0: 
L1: 

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
	push $1
	pop %rax
	mov %rax, %rdi
	call _f
	add $0, %rsp
	mov %rax, -24(%rbp)
	push -8(%rbp)
	pop %rax
	mov %rax, -32(%rbp)
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

