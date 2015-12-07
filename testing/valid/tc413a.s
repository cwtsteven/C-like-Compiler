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
	sub $8, %rsp
	and $-32, %rsp
	push $1
	pop %rax
	mov %rax, -8(%rbp)
	push $1
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	push $2
	pop %rax
	mov %rax, -8(%rbp)
L0: 
	push $0
	pop %rax
	cmp $1, %rax
	jne L1
	jmp L0
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

