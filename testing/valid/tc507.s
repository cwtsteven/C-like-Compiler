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


	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $16, %rsp
	and $-32, %rsp
	push $20
	pop %rax
	mov %rax, -8(%rbp)
	push $1
	pop %rax
	mov %rax, -16(%rbp)
L0: 
	push -16(%rbp)
	push $10
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setl %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L1
	push -16(%rbp)
	push $2
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -16(%rbp)
	jmp L0
L1: 
	push $20
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

