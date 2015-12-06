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


_manyParams: 
	push %rbp
	mov %rsp, %rbp
	sub $64, %rsp
	and $-32, %rsp
	mov %rdi, -8(%rbp)
	mov %rsi, -16(%rbp)
	mov %rdx, -24(%rbp)
	mov %rcx, -32(%rbp)
	mov %r8, -40(%rbp)
	mov %r9, -48(%rbp)
	push $1
	pop %rax
	mov %rax, -56(%rbp)
	push $2
	pop %rax
	mov %rax, -64(%rbp)
	push 24(%rbp)
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	push -8(%rbp)
	pop %rax
	jmp RETURN

	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $0, %rsp
	and $-32, %rsp
	push $8
	push $7
	push $6
	pop %rax
	mov %rax, %r9
	push $5
	pop %rax
	mov %rax, %r8
	push $4
	pop %rax
	mov %rax, %rcx
	push $3
	pop %rax
	mov %rax, %rdx
	push $2
	pop %rax
	mov %rax, %rsi
	push $1
	pop %rax
	mov %rax, %rdi
	call _manyParams
	add $16, %rsp
	lea int.str(%rip), %rdi
	mov %rax, %rsi
	call _printf
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

