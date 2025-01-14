.section .note.GNU-stack,"",@progbits

.data
    MSG1: .ascii "Escreva o primeiro número: "
    TAM1 = . - MSG1
    MSG2: .ascii "Escreva o segundo número: "
    TAM2 = . - MSG2
    MSG3: .ascii "Resultado: "
    TAM3 = . - MSG3

.section .text

.globl _start

_start:
    push %rbp
    movq %rsp, %rbp
    subq $16, %rsp

    movl $1, %eax
    movl $1, %edi
    movl $TAM1, %edx
    leaq MSG1(%rip), %rsi
    syscall

    movq %rsp, %rdi
    call ler_int

    movl $1, %eax
    movl $1, %edi
    movl $TAM2, %edx
    leaq MSG2(%rip), %rsi
    syscall

    leaq 4(%rsp), %rdi
    call ler_int

    movl $1, %eax
    movl $1, %edi
    movl $TAM3, %edx
    leaq MSG3(%rip), %rsi
    syscall

    movl 4(%rsp), %eax
    addl (%rsp), %eax

    movl %eax, %edi
    call escrever_int

    addq $16, %rsp
    popq %rbp

    movl $60, %eax
    xorl %edi, %edi
    syscall
