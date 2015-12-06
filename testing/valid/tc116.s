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
a: 	.quad 1
Read_int: .quad

	.section __TEXT,__text,regular,pure_instructions


	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $0, %rsp
	and $-32, %rsp
L0: 
	mov a(%rip), %rax
	push %rax
	push $2
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L1
	mov a(%rip), %rax
	push %rax
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	mov a(%rip), %rax
	push %rax
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, a(%rip)
	jmp L0
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

