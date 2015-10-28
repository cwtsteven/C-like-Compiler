	.section __TEXT,__cstring,cstring_literals
format_int:
	.string "%d\0"

	.data
	.section __TEXT,__text,regular,pure_instructions
	.globl _main
_main:
	push $0
	push $1
	push $2
	pop %r8
	pop %rax
	add %r8, %rax
	push %rax
	lea format_int(%rip), %rdi
	pop %rsi
	call _printf
	mov $0, %rdi
	call _exit
