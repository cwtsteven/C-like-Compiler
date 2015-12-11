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
	sub $40, %rsp
	and $-32, %rsp
	push $10
	pop %rax
	mov %rax, -8(%rbp)
	push $0
	pop %rax
	mov %rax, -16(%rbp)
L0: 
	push -16(%rbp)
	push -8(%rbp)
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setl %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L1
	push $0
	pop %rax
	mov %rax, -24(%rbp)
L2: 
	push -24(%rbp)
	push -8(%rbp)
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setl %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L3
	push $0
	pop %rax
	mov %rax, -32(%rbp)
L4: 
	push -32(%rbp)
	push -8(%rbp)
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setl %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L5
	push $10
	pop %rax
	mov %rax, -40(%rbp)
	push -32(%rbp)
	push -8(%rbp)
	push $2
	pop %r8
	pop %rax
	cqto
	idiv %r8
	push %rax
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setg %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L6
	push -24(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -24(%rbp)
	jmp L2
	jmp L7
L6: 
L7: 
	push -32(%rbp)
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	push -16(%rbp)
	push -8(%rbp)
	push $2
	pop %r8
	pop %rax
	cqto
	idiv %r8
	push %rax
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setg %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L8
	jmp L1
	jmp L9
L8: 
L9: 
	push -32(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -32(%rbp)
	jmp L4
L5: 
	push -24(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -24(%rbp)
	jmp L2
L3: 
	push -16(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -16(%rbp)
	jmp L0
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

