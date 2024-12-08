.section .note.GNU-stack,"",@progbits

.data
    debug: .byte '?'

.section .text

.globl _start

_start:
    push %rbp
    movq %rsp, %rbp
    subq $4, %rsp

    movq %rsp, %rdi
    call ler_int

    movl (%rsp), %edi
    call escrever_int

    addq $4, %rsp
    popq %rbp

    movq $60, %rax
    popq %rbp
    xor %rdi, %rdi
    syscall
