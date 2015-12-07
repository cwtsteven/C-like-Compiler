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
	push $2
	push $3
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -8(%rbp)
	push $2
	push $2
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	sete %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L0
	push -8(%rbp)
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	jmp L1
L0: 
	push $'b'
	lea char.str(%rip), %rdi
	pop %rsi
	call _printf
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

