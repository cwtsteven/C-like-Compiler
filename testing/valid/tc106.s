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
a: 	.double 0.123

	.section __TEXT,__text,regular,pure_instructions

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

