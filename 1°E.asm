.data

destination: .asciiz "Olá"   # String inicial para concatenar
source:      .asciiz " mundo!"  # String a ser concatenada


.text
.globl main

main:
    # Endereço da string destino e source
    la $a0, destination    # Carrega o endereço de destino em $a0
    la $a1, source         # Carrega o endereço de source em $a1
    jal strcat             # Chama a função strcat para concatenar

    # Exibe o resultado (string concatenada)
    li $v0, 4              # Syscall para imprimir string
    la $a0, destination    # Endereço da string concatenada
    syscall
	
    # Finaliza o programa
    li $v0, 10              # Syscall para encerrar
    syscall
    
# Função strcat - Concatena source em destination
# Parâmetros:
#   $a0 - Endereço da string destino
#   $a1 - Endereço da string source
strcat:
    # Localiza o final da string destino
    move $t0, $a0          # Copia o endereço de destino para $t0
find_end:
    lb $t1, 0($t0)         # Carrega o próximo byte da string destino
    beq $t1, $zero, copy   # Se for '\0', encontrou o final
    addi $t0, $t0, 1       # Avança para o próximo byte
    j find_end             # Continua buscando o final

copy:
    # Copia a string source para o final de destination
    lb $t1, 0($a1)         # Carrega o próximo byte da source
    sb $t1, 0($t0)         # Armazena o byte no destino
    beq $t1, $zero, done   # Se for '\0', termina a cópia
    addi $t0, $t0, 1       # Avança para o próximo byte no destino
    addi $a1, $a1, 1       # Avança para o próximo byte na source
    j copy                 # Continua copiando

done:
    jr $ra                 # Retorna ao chamador

