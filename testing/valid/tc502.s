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
	jne L0
	push $1
	pop %rax
	jmp RETURN
	jmp L1
L0: 
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
L1: 

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $32, %rsp
	and $-32, %rsp
	push $10
	pop %rax
	mov %rax, -8(%rbp)
	push -8(%rbp)
	push $2
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	sete %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L2
	push $'c'
	pop %rax
	mov %rax, -16(%rbp)
	push -16(%rbp)
	lea char.str(%rip), %rdi
	pop %rsi
	call _printf
	jmp L3
L2: 
	push $'b'
	pop %rax
	mov %rax, -24(%rbp)
	push -24(%rbp)
	lea char.str(%rip), %rdi
	pop %rsi
	call _printf
L3: 
L4: 
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
	jne L5
	push $1
	pop %rax
	mov %rax, -32(%rbp)
L6: 
	push -32(%rbp)
	push -8(%rbp)
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L7
	push -8(%rbp)
	pop %rax
	mov %rax, %rdi
	call _factorial
	add $0, %rsp
	lea int.str(%rip), %rdi
	mov %rax, %rsi
	call _printf
	push -32(%rbp)
	push $1
	pop %rax
	pop %r8
	add %rax, %r8
	push %r8
	pop %rax
	mov %rax, -32(%rbp)
	jmp L6
L7: 
	push $1
	pop %rax
	mov %rax, -32(%rbp)
	push -8(%rbp)
	push $1
	pop %rax
	pop %r8
	sub %rax, %r8
	push %r8
	pop %rax
	mov %rax, -8(%rbp)
	jmp L4
L5: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

