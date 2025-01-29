.data
	source: .asciiz "Frase teste que sera copiada."
	destination: .space 50 #Espaço separado para a copia da string, limitado a 50 caracteres

.text

main:
	#Carrega os endereços das memórias nos registradores
	la $a0, destination #Carrega o endereço do destination no reg a0
	la $a1, source #Carrega o endereço da source no reg a1
	
#Função strcpy
strcpy:
	move $v0, $a0 #Guarda o parâmetro do reg a0 (Endereço de memoria) no reg v0
	lb $t0, 0($a1) #Carrega o primeiro byte da source no t1
	beq $t0, 0, end_strcpy #Caso o primeiro byte seja um caracter nulo (ou seja, string vazia) ele vai direto para o final do código
		
#Loop utilizado para percorrer a frase da source
loop_strcpy:
	sb $t0, 0($a0) #Guarda no endereço de memória do destination o último caracter carregado
	
	#Acrecimos dos Contadores/Marcadores
	addi $a1, $a1, 1  #Adiciona mais um no reg da source para que possamos ler o próximo caractere
	addi $a0, $a0, 1  #Adiciona mais um no reg da destination para que possamos inserir o próximo caractere
	
	lb $t0, 0($a1) #Faz a leitura do caracter na nova posição
	bne  $t0, 0, loop_strcpy #Caso o valor seja diferente do caracter nulo ('\0') ele continua a copiar o byte reiniciando o loop

#Final do método de strcpy
end_strcpy:
	sb $t0, 0($a0) #Copia o caracter nulo
