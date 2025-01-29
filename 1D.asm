.data 
	pergunta1: .asciiz "Escreva a primeira string: "
	pergunta2: .asciiz "Escreva a segunda string: "
	pergunta3: .asciiz "Quantos caracteres deseja comparar: "
	str1: .space 25
	str2: .space 25
	num: .word 0
	result_msg: .asciiz "Resultado: "  # Mensagem para exibir o resultado
.text
	# Pega o valor da str1
	li $v0, 4
	la $a0, pergunta1
	syscall 
	
	li $v0, 8
	la $a0, str1
	la $a1, 25
	syscall 
	
	# Pega o valor da str2
	li $v0, 4
	la $a0, pergunta2
	syscall 
	
	li $v0, 8
	la $a0, str2
	la $a1, 25
	syscall 
	
	# Pega o valor de num
	li $v0, 4
	la $a0, pergunta3
	syscall 
	
	li $v0, 5
	syscall 
	sw $v0, num
	
	jal strcmp #Chama a função strcmp
	
	move $t0, $v0 #Move o resultado
	
	#Imprime o resultado
	li $v0, 4
	la $a0, result_msg
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	# Finaliza o programa
    	li $v0, 10             # Syscall para sair
    	syscall
	
	# Função strcmp
	strcmp:
		# Loop para comparar os caracteres
		la $a0, str1
		la $a1, str2
		lw $a2, num
	strcmp_loop:
		beqz $a2, strings_iguais # Verifica se atingiu o número de iterações
		subi $a2, $a2, 1          # Subtrai em 1 a quantidade de loops restantes
    		lb $t0, 0($a0)          # Carrega o próximo caractere de str1 em $t0
    		lb $t1, 0($a1)          # Carrega o próximo caractere de str2 em $t1

    		beq $t0, $t1, verificar_null # Se forem iguais, verifica o próximo caractere
    		blt $t0, $t1, str1_menor     # Se for menor, retorna -1
    		j str1_maior

	verificar_null:
    		beqz $t0, strings_iguais  # Se $t0 for '\0', as strings são iguais
    		addi $a0, $a0, 1         # Incrementa o ponteiro de str1
    		addi $a1, $a1, 1         # Incrementa o ponteiro de str2
    		j strcmp_loop            # Continua o loop

	strings_iguais:
    		li $v0, 0                # Ambas as strings são iguais (retorna 0)
    		jr $ra                   # Retorna ao chamador
    	str1_menor:
    		li $v0, -1
    		jr $ra 
    	str1_maior:
    		li $v0, 1
    		jr $ra
