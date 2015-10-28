	.section __TEXT,__cstring,cstring_literals
format_int:
	.string "%d\0"

	.data
a: 	.long 5
b: 
d: 
	.section __TEXT,__text,regular,pure_instructions
	.globl _main
_main:
	push $0
	movabsq (a), %rax
	push %rax
	push $1
	pop %r8
	pop %rax
	add %r8, %rax
	push %rax
	pop %rax
	movabsq %rax, (a)
	mov $0, %rdi
	call _exit
