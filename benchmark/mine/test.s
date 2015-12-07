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


_fibonacci: 
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L0
	push -8(%rbp)
	pop %rax
	jmp RETURN
	jmp L1
L0: 
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	sub %rax, %r8
	push %r8
	pop %rax
	mov %rax, %rdi
	call _fibonacci
	add $0, %rsp
	push %rax
	push -8(%rbp)
	push $2
	pop %rax
	pop %r8
	sub %rax, %r8
	push %r8
	pop %rax
	mov %rax, %rdi
	call _fibonacci
	add $0, %rsp
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	jmp RETURN
L1: 

_factorial: 
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L2
	push $1
	pop %rax
	jmp RETURN
	jmp L3
L2: 
	push -8(%rbp)
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	sub %rax, %r8
	push %r8
	pop %rax
	mov %rax, %rdi
	call _factorial
	add $0, %rsp
	pop %r8
	imul %rax, %r8
	push %r8
	pop %rax
	jmp RETURN
L3: 

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $32, %rsp
	and $-32, %rsp
	push $100
	pop %rax
	mov %rax, -8(%rbp)
	push $0
	pop %rax
	mov %rax, -16(%rbp)
L4: 
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
	jne L5
	push $0
	pop %rax
	mov %rax, -24(%rbp)
L6: 
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
	jne L7
	push $0
	pop %rax
	mov %rax, -32(%rbp)
L8: 
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
	jne L9
	push -32(%rbp)
	push $50
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setg %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L10
	push -24(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -24(%rbp)
	jmp L6
	jmp L11
L10: 
L11: 
	push -16(%rbp)
	pop %rax
	mov %rax, %rdi
	call _fibonacci
	add $0, %rsp
	push %rax
	push -16(%rbp)
	pop %rax
	mov %rax, %rdi
	call _factorial
	add $0, %rsp
	pop %r8
	add %rax, %r8
	push %r8
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	push -16(%rbp)
	push $25
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	sete %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L12
	jmp L5
	jmp L13
L12: 
L13: 
	push -32(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -32(%rbp)
	jmp L8
L9: 
	push -24(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -24(%rbp)
	jmp L6
L7: 
	push -16(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -16(%rbp)
	jmp L4
L5: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

