.section .note.GNU-stack,"",@progbits

.bss
    sinal: .byte

.text

.globl ler_int

# Chamada de sistema para ler uma string de caracteres da entrada padrão.
# Tamanho da string a ser lida deve ser colocado em %rsi.

leitura:
    xor %rax, %rax
    mov %rsi, %rdx
    mov %rdi, %rsi
    xor %rdi, %rdi
    syscall

    ret

ler_int:
    subq $12, %rsp # Aumentando a pilha.

    movq %rdi, %r10
    movq %rsp, %rdi # %rdi agora tem o endereço para o início do buffer.
    movl $12, %esi # Colocando o tamanho da string em %esi.
    call leitura

    # O primeiro caractere da string é interpretado como caractere de sinal.
    # Se for igual a ascii 45 (-), o número é negativo, caso contrário, é não negativo.
    movb (%rsp), %al
    movb %al, sinal(%rip)

    movl $10, %r9d # R9d = 10
    xor %ecx, %ecx
    dec %ecx # ECX = -1
    xor %eax, %eax # EAX = EDX = 0
    xor %edx, %edx # 

.ite:
    inc %ecx
    cmpl $12, %ecx
    jge .out
    movb (%rsp, %rcx), %dil # (%rsp, %ecx) = %dil = buf[i]
    cmpl %r9d, %edi
    je .out

    cmpb $47, %dil
    jle .ite
    cmpb $58, %dil
    jge .ite

    mull %r9d
    addl %edi, %eax
    subl $48, %eax
    jmp .ite

.out:
    movl %eax, (%r10)
    cmpl $12, %ecx
    jne .sig

    movq %rsp, %rdi
    movl $12, %esi
    call leitura

    xor %rcx, %rcx
    dec %rcx
    movl (%r10), %eax
    jmp .ite

.sig:
    cmpb $45, sinal(%rip)
    jne .fim_l
    negl (%r10)

.fim_l:
    addq $12, %rsp # Restaurando o tamanho inicial da pilha.
    ret

# -----------------------------------------------------------------------------------------------

.globl escrever_int

escrever_int:
    pushq %rbp
    movq %rsp, %rbp
    subq $12, %rsp          # 'c' vai de (%rsp) a 11(%rsp).

    movb $10, 11(%rsp)
    movb $48, 10(%rsp)

    movl %edi, %eax         # %eax = a
    movl $10, %r10d         # %r10 = 10 (permanente)
    xor %r13d, %r13d        # %r13d = 0 (permanente)
    movl $45, %r14d         # %r14d = - (permanente)
    xor %esi, %esi          # %esi = sig
    movl %r10d, %ecx        # %ecx = q
    
    movl %r10d, %r9d
    dec %r9d

    cmpl %eax, %r13d
    cmovel %r9d, %ecx
    jle .whi

    negl %eax
    movl %r14d, %esi

.whi:
    cmpl %eax, %r13d
    je .sign

    xor %edx, %edx
    divl %r10d
    addl $48, %edx
    movb %dl, (%rsp, %rcx)
    dec %ecx

    jmp .whi

.sign:
    cmpl %r14d, %esi
    jne .fim_e

    movb %sil, (%rsp, %rcx)
    dec %rcx

.fim_e:
    movq $1, %rax
    movq $1, %rdi
    leaq 1(%rsp, %rcx), %rsi

    movl $11, %edx
    subq %rcx, %rdx
    syscall

    addq $12, %rsp
    popq %rbp
    ret
