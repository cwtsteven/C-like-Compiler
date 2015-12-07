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


_side_effect: 
	push %rbp
	mov %rsp, %rbp
	sub $16, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	mov %rsi, -16(%rbp)
	push -8(%rbp)
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	push -16(%rbp)
	pop %rax
	jmp RETURN

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $16, %rsp
	and $-32, %rsp
	push $2
	pop %rax
	mov %rax, -8(%rbp)
	push -8(%rbp)
	pop %rax
	mov %rax, -16(%rbp)
	push -16(%rbp)
	pop %rax
	mov %rax, %rsi
	push -8(%rbp)
	pop %rax
	mov %rax, %rdi
	call _side_effect
	add $0, %rsp
	lea int.str(%rip), %rdi
	mov %rax, %rsi
	call _printf
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

