	.file	"params.c"
	.text
	.globl	add
	.type	add, @function
add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	add, .-add
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	%gs:20, %eax
	movl	%eax, -4(%ebp)
	xorl	%eax, %eax
	movl	$4, %eax
	subl	$1, %eax
	addl	$32, %eax
	movl	$4, %ecx
	movl	$0, %edx
	divl	%ecx
	sall	$2, %eax
	subl	%eax, %esp
	movl	%esp, %eax
	addl	$15, %eax
	shrl	$4, %eax
	sall	$4, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	addl	$5, %eax
	movb	$-86, (%eax)
	movl	$0, %eax
	movl	-4(%ebp), %edx
	subl	%gs:20, %edx
	je	.L5
	call	__stack_chk_fail
.L5:
	leave
	ret
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
