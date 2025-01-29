.data

.text
# Endereço do teclado MMIO: 0xFFFF0000 (status), 0xFFFF0004 (dados)
# Endereço do display MMIO: 0xFFFF0008 (status), 0xFFFF000C (dados)
loop:
	# Leitura do status do teclado
    	li $t0, 0xFFFF0000  # Endereço do registrador de status do teclado
    	lw $t1, 0($t0)      # Carregar status do teclado
    	
    	beqz $t1, loop
    	
    	# Leitura do caractere do teclado
    	li $t0, 0xFFFF0004  # Endereço do registrador de dados do teclado
    	lw $t2, 0($t0)      # Carregar o caractere lido
    	
espera_Display:
	# Leitura do status do teclado
    	li $t0, 0xFFFF0008  # Endereço do registrador de status do teclado
    	lw $t1, 0($t0)      # Carregar status do teclado
    	
    	beqz $t1, espera_Display
    	
    	li $t0, 0xFFFF000C
    	sw $t2, 0($t0)
    	
    	j loop
