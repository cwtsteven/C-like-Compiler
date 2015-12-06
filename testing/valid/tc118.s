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
a: 	.quad 5
Read_int: .quad

	.section __TEXT,__text,regular,pure_instructions


	.globl _main
_main:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp
	and $-32, %rsp
	push $2
	pop %rax
	mov %rax, -8(%rbp)
L0: 
	push -8(%rbp)
	mov a(%rip), %rax
	push %rax
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L1
	lea int.str(%rip), %rdi
	lea Read_int(%rip), %rsi
	call _scanf
	mov Read_int(%rip), %rax
	push %rax
	pop %rax
	mov %rax, -8(%rbp)
	push -8(%rbp)
	mov a(%rip), %rax
	push %rax
	pop %rax
	pop %r8
	cmp %rax, %r8
	mov $0, %rax
	setle %al
	push %rax
	pop %rax
	cmp $1, %rax
	jne L2
	mov a(%rip), %rax
	push %rax
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
	jmp L3
L2: 
	push -8(%rbp)
	lea int.str(%rip), %rdi
	pop %rsi
	call _printf
L3: 
	jmp L0
L1: 
	mov $0, %rdi
	call _exit

RETURN: 
	mov %rbp, %rsp
	pop %rbp
	ret

