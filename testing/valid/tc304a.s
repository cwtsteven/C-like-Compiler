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
Read_int: .long

	.section __TEXT,__text,regular,pure_instructions


	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $32, %rsp
	and $-32, %rsp
	push $3
	pop %rax
	mov %rax, -8(%rbp)
	push $3
	pop %rax
	mov %rax, -16(%rbp)
	push $1
	pop %rax
	cmp $1, %rax
	jne L0
	push $5
	pop %rax
	mov %rax, -24(%rbp)
	push $5
	pop %rax
	mov %rax, -32(%rbp)
	jmp L1
L0: 
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

