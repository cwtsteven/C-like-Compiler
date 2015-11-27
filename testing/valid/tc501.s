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
Read_int: .long

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
	pop %r8
	add %rax, %r8
	push %r8
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

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $0, %rsp
	and $-32, %rsp
	push $10
	pop %rax
	mov %rax, %rdi
	call _fibonacci
	add $0, %rsp
	lea int.str(%rip), %rdi
	mov %rax, %rsi
	call _printf
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

