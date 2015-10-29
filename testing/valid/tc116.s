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
a: 	.long 1
	.section __TEXT,__text,regular,pure_instructions
	.globl _main
_main:
	push $0
L0: 
	movabsq (a), %rax
	push %rax
	push $2
	pop %r8
	pop %rax
	cmp %r8, %rax
	mov $0, %rax
	setle %al
	push %rax
	pop %r8
	cmp $1, %r8
	jne L1
	movabsq (a), %rax
	push %rax
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	movabsq (a), %rax
	push %rax
	push $1
	pop %r8
	pop %rax
	add %r8, %rax
	push %rax
	pop %rax
	movabsq %rax, (a)
	jmp L0
L1: 
	mov $0, %rdi
	call _exit
