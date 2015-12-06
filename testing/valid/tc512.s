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


_f: 
	push %rbp
	mov %rsp, %rbp
	sub $0, %rsp
	and $-32, %rsp
	push $123
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	push $10
	pop %rax
	jmp RETURN

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	lea int.str(%rip), %rdi
	lea Read_int(%rip), %rsi
	call _scanf
	mov Read_int(%rip), %rax
	push %rax
	pop %rax
	mov %rax, -8(%rbp)
	push -8(%rbp)
	call _f
	add $0, %rsp
	pop %r8
	add %rax, %r8
	push %r8
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

