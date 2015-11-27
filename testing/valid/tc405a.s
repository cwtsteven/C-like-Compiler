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
a: 	.long 1
Read_int: .long

	.section __TEXT,__text,regular,pure_instructions


_side_effect: 
	push %rbp
	mov %rsp, %rbp
	sub $0, %rsp
	and $-32, %rsp
	push $5
	pop %rax
	movabsq %rax, (a)
	jmp RETURN

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $24, %rsp
	and $-32, %rsp
	push $'a'
	pop %rax
	mov %rax, -8(%rbp)
	push $1
	pop %rax
	cmp $1, %rax
	jne L0
	push $1
	pop %rax
	mov %rax, -16(%rbp)
	call _side_effect
	add $0, %rsp
	push -16(%rbp)
	pop %rax
	mov %rax, -24(%rbp)
	jmp L1
L0: 
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

