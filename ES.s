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
    subq $12, %rsp          # Aumentando a pilha.

    movq %rdi, %r10         # %r10 tem o endereço passado para a função. 
    movq %rsp, %rdi         # %rdi agora tem o endereço para o início do buffer.
    movl $12, %esi          # Colocando o tamanho da string em %esi.
    call leitura

    # O primeiro caractere da string é interpretado como caractere de sinal.
    # Se for igual a ascii 45 (-), o número é negativo, caso contrário, é não negativo.
    movb (%rsp), %al
    movb %al, sinal(%rip)


    # Carregando valores em registradores.
    movl $10, %r9d          # R9d = 10
    xor %ecx, %ecx          #
    dec %ecx                # ECX = -1
    xor %eax, %eax          # EAX (acumulador) = EDX = 0
    xor %edx, %edx          # Para não dar erro na multiplicação.

# Percorrendo a string de caracteres.
.ite:
    inc %ecx
    cmpl $12, %ecx
    jge .out
    movb (%rsp, %rcx), %dil # Colocando o caractere analisado em %dil.
    cmpl %r9d, %edi         # Encerra o laço caso o caractere seja um "ENTER".
    je .out

    cmpb $47, %dil          #
    jle .ite                # Ignora o caractere caso este não seja 
    cmpb $58, %dil          # um caractere numérico.
    jge .ite                #

    mull %r9d               # Multiplica acumulador por 10.
    addl %edi, %eax         # Adiciona novo valor lido
    subl $48, %eax          # do caractere ao acumulador.
    jmp .ite                # Retorna ao início do laço.

.out:
    movl %eax, (%r10)       # Atualiza memória com o valor do acumulador.
    cmpl $12, %ecx          # Caso a interrupção do laço tenha sido causada pela leitura
    jne .sig                # do 'ENTER', vai para 'sig'.

    movq %rsp, %rdi         # 
    movl $12, %esi          # Faz nova leitura da entrada padrão.
    call leitura            # 

    xor %rcx, %rcx          # 
    dec %rcx                # Reseta valores necessários e retorna ao laço
    movl (%r10), %eax       # anterior (ite).
    jmp .ite                # 

.sig:
    cmpb $45, sinal(%rip)   # Caso o byte em 'sinal' seja o caractere '-',
    jne .fim_l              # multiplica o resultado por -1.
    negl (%r10)             # 

.fim_l:
    addq $12, %rsp          # Restaurando o tamanho inicial da pilha.
    ret

# -----------------------------------------------------------------------------------------------

.globl escrever_int

escrever_int:
    pushq %rbp
    movq %rsp, %rbp
    subq $12, %rsp          # 'c' vai de (%rsp) a 11(%rsp).

    movb $10, 11(%rsp)      # Último caractere da string é um 'ENTER'.
    movb $48, 10(%rsp)      # Penúltimo caractere da string é '0'. (Caso o valor a ser escrito seja 0).

    # Carregando valores em registradores.

    movl %edi, %eax         # %eax contém o número a ser escrito.
    movl $10, %r10d         # %r10 = 10 (permanente)
    xor %r13d, %r13d        # %r13d = 0 (permanente)
    movl $45, %r14d         # %r14d = - (permanente)
    xor %esi, %esi          # %esi = sig
    movl %r10d, %ecx        # %ecx contém o valor do deslocamento no buffer.
    
    movl %r10d, %r9d        # %r9d = 9
    dec %r9d                #

    cmpl %eax, %r13d        # Se o número a ser escrito for '0', decrementa 
    cmovel %r9d, %ecx       # o índice em %ecx.
    jle .whi

    negl %eax               # Caso o valor no acumulador seja negativo, torna-o positivo
    movl %r14d, %esi        # e faz %esi receber o caractere '-'.

.whi:
    cmpl %eax, %r13d        # Encerra o laço caso o acumulador
    je .sign                # seja igual a 0.

    xor %edx, %edx          # Zerar %edx para a divisão.
    divl %r10d              # Divide o acumulador por 10.
    addl $48, %edx          # Soma 48 ao resto da divisão e armazena o resultado (caractere)
    movb %dl, (%rsp, %rcx)  # no buffer.
    dec %ecx                # Decrementa o deslocamento no buffer.

    jmp .whi                # Retorna ao laço.

.sign:
    cmpl %r14d, %esi        # Se o valor em %esi não for '-',
    jne .fim_e              # vá para 'fim_e'.

    movb %sil, (%rsp, %rcx) # Caso contrário, acrescente o caractere '-' ao buffer,
    dec %rcx                # e decremente o deslocamento.

.fim_e:
    movq $1, %rax
    movq $1, %rdi
    leaq 1(%rsp, %rcx), %rsi

    movl $11, %edx          # 
    subq %rcx, %rdx         # Escreve o buffer na saída padrão.
    syscall                 # 

    addq $12, %rsp
    popq %rbp
    ret
