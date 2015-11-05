	.section __TEXT,__cstring,cstring_literals
int.str:
	.string "%d\0"
char.str:
	.string "%c\0"
true.str:
	.string "true"
false.str:
	.string "false"


	.section __TEXT,__text,regular,pure_instructions

_double: 
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	push -8(%rbp)
	push -8(%rbp)
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	jmp RETURN

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $16, %rsp
	and $-32, %rsp
	push $10
	pop %rax
	mov %rax, -8(%rbp)
L0: 
	push -8(%rbp)
	push $0
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setge %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L1
	push $1
	pop %rax
	mov %rax, -16(%rbp)
L2: 
	push -16(%rbp)
	push -8(%rbp)
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L3
	push -16(%rbp)
	push -8(%rbp)
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L4
	push -8(%rbp)
	pop %rax
	mov %rax, %rdi
	call _double
	add $0, %rsp
	lea int.str(%rip), %rdi
	mov %rax, %rsi
	call _printf
	push -16(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -16(%rbp)
	jmp L5
L4: 
L5: 
	jmp L2
L3: 
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	sub %rax, %r8
	push %r8
	pop %rax
	mov %rax, -8(%rbp)
	jmp L0
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

