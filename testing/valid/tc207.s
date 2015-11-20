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
b: 	.byte 0

	.section __TEXT,__text,regular,pure_instructions

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	push $2
	pop %rax
	mov %rax, -8(%rbp)
	push $2
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

