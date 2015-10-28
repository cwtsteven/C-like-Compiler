	.section __TEXT,__cstring,cstring_literals
format_int:
	.string "%d\0"

	.data
a: 	.long 5
b: 	.long 5
	.section __TEXT,__text,regular,pure_instructions
	.globl _main
_main:
	push $0
	mov $0, %rdi
	call _exit
