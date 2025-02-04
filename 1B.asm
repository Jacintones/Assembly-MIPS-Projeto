        .data
source: .asciiz "Escrevi isso. A partir daqui não será mais exibido"  # Origem da string
destination: .space 13           # Espaço reservado para a string copiada (12 + '\0')

        .text
        .globl main

main:
    la $a0, destination    # Endereço de destino
    la $a1, source         # Endereço da origem
    li $a2, 13             # Número de bytes corretos a copiar (12 caracteres + '\0')

    # Chama memcpy
    jal memcpy

    # Imprime o conteúdo copiado
    li $v0, 4              # Syscall para imprimir string
    la $a0, destination    # Endereço do destino
    syscall

    # Termina o programa
    li $v0, 10             # Syscall para sair
    syscall

# Função memcpy
memcpy:
    move $v0, $a0          # Retorna endereço de destino

memcpy_loop:
    beqz $a2, memcpy_end   # Se $a2 == 0, termina

    lb $t0, 0($a1)         # Carrega byte da origem
    sb $t0, 0($a0)         # Armazena no destino

    addi $a1, $a1, 1       # Avança a origem
    addi $a0, $a0, 1       # Avança o destino
    addi $a2, $a2, -1      # Decrementa contador

    j memcpy_loop          # Repete

memcpy_end:
    jr $ra                 # Retorna
