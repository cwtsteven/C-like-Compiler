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
a: 	.string "I am so excited!"
	.section __TEXT,__text,regular,pure_instructions
	.globl _main
_main:
	push $0
	mov $0, %rdi
	call _exit
