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
    subq $8, %rsp

    movq $1, %rax
    movq $1, %rdi
    movq $TAM1, %rdx
    leaq MSG1(%rip), %rsi
    syscall

    movq %rsp, %rdi
    call ler_int

    movq $1, %rax
    movq $1, %rdi
    movq $TAM2, %rdx
    leaq MSG2(%rip), %rsi
    syscall

    leaq 4(%rsp), %rdi
    call ler_int

    movq $1, %rax
    movq $1, %rdi
    movq $TAM3, %rdx
    leaq MSG3(%rip), %rsi
    syscall

    movl 4(%rsp), %eax
    addl (%rsp), %eax

    movl %eax, %edi
    call escrever_int

    addq $8, %rsp
    popq %rbp

    movq $60, %rax
    xor %rdi, %rdi
    syscall
