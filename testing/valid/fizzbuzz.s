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
	sub $8, %rsp
	and $-32, %rsp
	push $1
	pop %rax
	mov %rax, -8(%rbp)
L0: 
	push -8(%rbp)
	push $30
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L1
	push -8(%rbp)
	push $3
	pop %r8
	pop %rax
	cqto
	idiv %r8
	push %rdx
	push $0
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	sete %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L2
	push $1
	pop %rax
	neg %rax
	push %rax
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	jmp L3
L2: 
L3: 
	push -8(%rbp)
	push $5
	pop %r8
	pop %rax
	cqto
	idiv %r8
	push %rdx
	push $0
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	sete %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L4
	push $2
	pop %rax
	neg %rax
	push %rax
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	jmp L5
L4: 
L5: 
	push -8(%rbp)
	push $3
	pop %r8
	pop %rax
	cqto
	idiv %r8
	push %rdx
	push $0
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setne %al
	push %rax
	push -8(%rbp)
	push $5
	pop %r8
	pop %rax
	cqto
	idiv %r8
	push %rdx
	push $0
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setne %al
	push %rax
	pop %rax
	pop %r8
	and %r8, %rax
	push %rax
	pop %rax
	cmp $1, %rax
	jne L6
	push -8(%rbp)
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	jmp L7
L6: 
L7: 
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
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

