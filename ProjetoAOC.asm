#################### DOCUMENTACAO ####################
# reg $s0 -> Endereco para o acervo de livros
# reg $s1 -> Endereco para a lista com os usuarios
# reg $s2 -> Endereco para a lista de emprestimos
# reg $s3 -> Endereco para o comando inserido pelo user
######################################################

.data
	#Enderecos dos arquivos
	#************************** MODIFICAR DIRETORIO DAS PASTAS *********************************
	endereco_acervo_livros:  .asciiz "C:/Users/thiag/Documents/assembly/Assembly-MIPS-Projeto/acervo.txt"
	endereco_contas_usuarios: .asciiz "C:/Users/thiag/Documents/assembly/Assembly-MIPS-Projeto/usuarios.txt"
	endereco_emprestimos: .asciiz "C:\Users\thiag\Documents\assembly\Assembly-MIPS-Projeto\emprestimos.txt"
	
	#Endereco do conteudo salvo na memoria (Definindo o tamanho MAX dos arquivos: 10Kb, aproximadamente 100 livros)
	conteudo_acervo_livro: .space 10240
	conteudo_contas_usuarios: .space 1024
	conteudo_emprestimos: .space 10240

	# Buffer para entrada de dados
	input_buffer: .space 256

	# Estrutura para armazenar os livros e usuários
	acervo: .space 1024           
	usuarios: .space 512          

	# Mensagens
	msg_shell: .asciiz "Diginomicon-shell>>"
	msg_titulo: .asciiz "Digite o título: "
	msg_autor: .asciiz "Digite o autor: "
	msg_isbn: .asciiz "Digite o ISBN: "
	msg_qtd: .asciiz "Digite a quantidade: "

	msg_erro_argumento_em_falta: .asciiz "Falta o argumento "

	msg_nome: .asciiz "Digite o nome do usuário: "
	msg_matricula: .asciiz "Digite o número de matrícula: "
	msg_curso: .asciiz "Digite o curso do usuário: "
	msg_cadastrado: .asciiz "Cadastro realizado com sucesso!\n"
	msg_erro_nao_encontrado: .asciiz "ISBN não encontrado"
	msg_error_armazenamento: .asciiz "Erro: espaço cheio!\n"
	msg_error: .asciiz "Comando inválido! Tente novamente.\n"
	msg_opcao: .asciiz "Escolha uma opção: (1) Ver Data e Hora, (2) Cadastrar Livro, (3) Listar Livros, (4) Cadastrar Usuário, (5) Registrar Empréstimo, (6) Gerar Relatório, (7) Remover Livro, (8) Remover Usuário, (9) Salvar Dados, (10) Ajustar Data e Hora, (11) Registrar Devolução, (12) Sair: \n"
	msg_campo_obrigatorio: .asciiz "Erro: Este campo é obrigatório!\n"
	nome_arquivo: .asciiz "C:/Users/thiag/Documents/assembly/Assembly-MIPS-Projeto/acervo.txt"
	msg_newline: .asciiz "\n"  # Nova linha
	msg_linha:   .asciiz "---------------------\n"  # Linha separadora entre livros
	msg_titulo_txt: .asciiz "Titulo: "
	msg_autor_txt:  .asciiz "Autor: "
	msg_isbn_txt:   .asciiz "ISBN: "
	msg_qtd_txt:    .asciiz "Quantidade: "
	msg_erro: .asciiz "Erro ao abrir o arquivo!\n"
	msg_ponto_virgula: .asciiz ";"
        buffer: .space 256
	# Mensagens de data e hora
	msg_data: .asciiz "Data: "
	msg_hora: .asciiz "Hora: "
	msg_barra: .asciiz "/"
	msg_dois_pontos: .asciiz ":"
	msg_quebra_de_linha: .asciiz "\n"
        newline: .asciiz "\n"
	tempo: .word 0, 0, 0, 0, 0, 0 #Ano, Mês, Dia, Hora, Minuto, Segundo
	tempo_base: .word 1970, 1, 1, 0, 0, 0 #Ano, M�s, Dia, Hora, Minuto, Segundo
	milisegundos_offset: 0, 0
	tempo_reset: .word 1970, 1, 1, 0, 0, 0 #Ano, M�s, Dia, Hora, Minuto, Segundo
	meses_bissexto: .word 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	meses_normais: .word 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	buffer_date_time: .space 20
	
	msg_erro_data: .asciiz "A data deve estar no formato DD/MM/AAAA"
	msg_erro_hora: .asciiz "A hora deve estar no formato HH/MM/SS"
	msg_erro_minuto: .asciiz "O limite de minutos � 60"
	msg_erro_segundos: .asciiz "O limite de segundos � 60"
	msg_erro_horas: .asciiz "O limite de horas � 23"
	msg_erro_dias: .asciiz "Dia n�o existe no m�s e/ou ano escolhido"
	msg_erro_mes: .asciiz "O limite de meses � 12"
	
	msg_dia: .asciiz "Dia: "
	msg_mes: .asciiz "Mes: "
	msg_ano: .asciiz "Ano: "
	msg_minuto: .asciiz "Minuto: "
	msg_segundo: .asciiz "Segundo: "
	msg_pedir_isbn:  .asciiz "Digite o ISBN do livro a ser removido: "
	msg_sucesso:  .asciiz "Livro removido com sucesso!\n"
	msg_debug: .asciiz "Conteúdo do arquivo carregado:\n"
	filename: .asciiz "C:\Users\thiag\Documents\assembly\Assembly-MIPS-Projeto\acervo.txt"

	buffer_argumento: .space 100
	buffer_linha: .space 300

	# Mensagem temporaria de depuração
	msg_em_breve: .asciiz "Ainda não implementado.\n"
	msg_erro_arquivo: .asciiz "Erro ao abrir o arquivo!\n"
	
	comando_usuario: .space 300 #Espaco na memoria 
	funcao_usuario: .space 30 #Buffer para a funcao escrita pelo usuario
	
	#Comandos utilizados para indicar a funcao escolhida pelo o usuario
	comando_data_hora: .asciiz "data_hora"
	comando_cadastrar_livro: .asciiz "cadastrar_livro"
	comando_listar_livros: .asciiz "listar_livros"
	comando_cadastrar_usuario: .asciiz "cadastrar_usuario"
	comando_registrar_emprestimo: .asciiz "registrar_emprestimo"
	comando_gerar_relatorio: .asciiz "gerar_relatorio"
	comando_remover_usuario: .asciiz "remover_usuario"
	comando_remover_livro: .asciiz "remover_livro"
	comando_salvar_dados: .asciiz "salvar_dados"
	comando_ajustar_data: .asciiz "ajustar_data"
	comando_registrar_devolucao: .asciiz "registrar_devolusao"
	
	arg_data: .asciiz "--data"
	arg_hora: .asciiz "--hora"
	
	arg_nome: .asciiz "--nome"
	arg_matricula: .asciiz "--matricula"
	arg_curso: .asciiz "--curso"
	
	msg_erro_nome: .asciiz "--nome e obrigatorio"
	msg_erro_matricula: .asciiz "--matricula e obrigatorio"
	msg_erro_curso: .asciiz "--curso e obrigatorio"
	
	conc_divisoria: .asciiz ";"
	conc_quebra_de_linha: .asciiz "\n"
	
	texto_shell : .asciiz "xxxxxx-shell>>"
	
#Fecha um arquivo aberto
.macro fechar_arquivo
	addi $v0, $zero 16 #Codigo para fechar o arquivo com o descritor
	move $a0, $t0 #Copia o descritor para reg a0
	syscall #Fecha o arquivo
.end_macro
	
#Abrer arquivo no modo de leitura
.macro ler_arquivo
	addi $v0, $zero, 13 #Codigo para abrir arquivos
	addi $a1, $zero, 0 #Define a flag como 0, modo de leitura
	syscall #Descritor do arquivo vai para o reg v0 (Descritor -> é o registrador que vai possuir a referência do arquivo)
	
	move $t0, $v0 #Copia o descritor para o reg s0
	
	addi $v0, $zero, 14 #carrega o cod de leitura de arquivo
	move $a0, $t0 #copia o descritor para o reg a0
	la $a1, ($t1) #Buffer do armazenamento do conteudo
	addi $a2, $zero 10240 #Tamanho do arquivo
	syscall #Chama a leitura de arquivo
.end_macro
	
.macro salvar_dado
    imprimir_shell
    li $v0, 8                  # Lê a entrada do usuário
    la $a0, input_buffer
    li $a1, 100                # Tamanho máximo da entrada
    syscall
    
    # Verifica se o primeiro caractere não é apenas um ENTER
    la $t7, input_buffer       
    lb $t6, 0($t7)             # Lê o primeiro caractere
    
    beq $t6, 10, campo_obrigatorio    # 10 representa '\n' (ENTER)

    la $t5, input_buffer       # Endereço da entrada do usuário
    
    # Garantir alinhamento de $t1 para múltiplos de 4
    andi $t2, $t1, 3           
    beqz $t2, salvar_dado_ok  

    addi $t1, $t1, 4
    andi $t1, $t1, 0xFFFFFFFC  # Ajusta para o próximo múltiplo de 4

salvar_dado_ok:
    sw $t5, 0($t1)  # Agora armazenando corretamente o ponteiro para a string
    
.end_macro




.macro imprimir_shell
    # Imprime a emnsagem do shell
    li $v0, 4
    la $a0, msg_shell
    syscall
.end_macro

#Macro utilizado para isolar o função do comando digitado pelo usuario
.macro isolar_comando
	la $a3, funcao_usuario
	move $t2, $a3 #Salva o enderco do inicio da funcao usuario
	lb $t0, 0($a2) #Carrega o primeiro byte da source no t1
		
	#Loop utilizado para percorrer a frase da source
	loop_strcpy:
		sb $t0, 0($a3) #Guarda no endereço de memória do destination o último caracter carregado
	
		#Acrecimos dos Contadores/Marcadores
		addi $a2, $a2, 1  #Adiciona mais um no reg da source para que possamos ler o próximo caractere
		addi $a3, $a3, 1  #Adiciona mais um no reg da destination para que possamos inserir o próximo caractere
	
		lb $t0, 0($a2) #Faz a leitura do caracter na nova posição
		
		#Caso o valor seja diferente do caracter nulo ('\0') e seja diferente de espaco (' ')ele continua a copiar o byte reiniciando o loop
		beq $t0, 32, end_loop_strcpy #Espaco
		beq $t0, 0, end_loop_strcpy #Nulo
		
		j loop_strcpy
		
	end_loop_strcpy:
.end_macro

.macro escolher_funcao
	# Verifica a opcao do usuario
    	beq $t3, 0, print_data_hora  # Opcao 1: Ver Data e Hora
    	beq $t3, 1, inserir_livro  # Opcao 2: Cadastrar Livro
    	beq $t3, 2, listar_livros  # Opcao 3: Listar Livros
    	beq $t3, 3, inserir_usuarios  # Opcao 4: Cadastrar Usuário
    	beq $t3, 4, registrar_emprestimo  # Opcao 5: Registrar Emprestimo
    	beq $t3, 5, gerar_relatorio  # Opcao 6: Gerar Relatório
    	beq $t3, 6, remover_livro  # Opcao 7: Remover Livro
    	#beq $t3, 7, remover_usuario  # Opcao 8: Remover Usuario
    	beq $t3, 8, salvar_dados  # Opcao 9: Salvar Dados
    	beq $t3, 9, ajustar_data  # Opcao 10: Ajustar Data e Hora
    	beq $t3, 10, registrar_devolucao  # Opcao 11: Registrar Devolucao
	j main
	
.end_macro

.text

.globl main

main:
	#Contador para espcificar a funcao
	addi $t3, $zero, 0
	
	# Escreve o texto-shell
	li $v0, 4
	la $a0, texto_shell
	syscall 
	
	li $v0, 8
	la $a0, comando_usuario
	la $a1, 100
	syscall 
	
	#Faz um backup do enedereco do comando do usario para ser utilizado no isolador e nas funcoes mais tarde
	move $a2, $a0 
	move $s3, $a0 
	
	isolar_comando
	
	#Checa se é para mostrar a hora
	move $a0, $t2
	la $a1, comando_data_hora
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para cadastrar livros
	move $a0, $t2
	la $a1, comando_cadastrar_livro
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para listar os livros
	move $a0, $t2
	la $a1, comando_listar_livros
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para cadastrar usuarios
	move $a0, $t2
	la $a1, comando_cadastrar_usuario
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para registrar emprestimo
	move $a0, $t2
	la $a1, comando_registrar_emprestimo
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para gerar relatorios
	move $a0, $t2
	la $a1, comando_gerar_relatorio
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para remover usuario
	move $a0, $t2
	la $a1, comando_remover_usuario
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para remover o livro
	move $a0, $t2
	la $a1, comando_remover_livro
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para salvar os dados
	move $a0, $t2
	la $a1, comando_salvar_dados
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para ajustar a data
	move $a0, $t2
	la $a1, comando_ajustar_data
	jal strcmp_loop
	addi $t3, $t3, 1
	
	#Checa se é para registrar devolucao
	move $a0, $t2
	la $a1, comando_registrar_devolucao
	jal strcmp_loop
	addi $t3, $t3, 1
	
    	# Mensagem de opção invalida
    	li $v0, 4
    	la $a0, msg_error
    	syscall
		
	j main
	
# Função strcmp para o menu
strcmp_loop:
	lb $t0, 0($a0)          # Carrega o próximo caractere de str1 em $t0
	lb $t1, 0($a1)          # Carrega o próximo caractere de str2 em $t1

	beq $t0, $t1, verificar_null # Se forem iguais, verifica o próximo caractere
	blt $t0, $t1, str1_menor     # Se for menor, retorna -1
	j str1_maior


verificar_null:
	beqz $t0, strings_iguais  # Se $t0 for '\0', as strings são iguais
	addi $a0, $a0, 1         # Incrementa o ponteiro de str1
	addi $a1, $a1, 1         # Incrementa o ponteiro de str2
	escolher_funcao         # Continua o loop

strings_iguais:
	li $v0, 0                # Ambas as strings são iguais (retorna 0)
	escolher_funcao                   # Retorna ao chamador
	
str1_menor:
	li $v0, -1
	jr $ra 
str1_maior:
	li $v0, 1
	jr $ra
	
fim: 
	# Finaliza o programa
    	li $v0, 10             # Syscall para sair
    	syscall

# ============================== LIVROS ==============================
inserir_livro:
    # Encontrar posição vazia no acervo
    la $t1, acervo  # Início do acervo
    li $t2, 0       # Contador de livros

loop_acervo:
    lb $t3, 0($t1)  # Verifica se o primeiro byte é 0 (espaço vazio)
    beqz $t3, inserir_dados  # Se for 0, encontrou espaço livre

    addi $t1, $t1, 152  # Avança para o próximo livro
    addi $t2, $t2, 1    # Incrementa contador de livros
    
    li $t4, 10          # Máximo de 10 livros
    blt $t2, $t4, loop_acervo
    j espaco_cheio      # Se chegou no limite, sai

inserir_dados:
    # Ler e armazenar Título (offset 0)
    li $v0, 4
    la $a0, msg_titulo
    syscall
    li $v0, 8            # Syscall para ler string
    la $a0, input_buffer # Buffer de entrada
    li $a1, 64           # Tamanho máximo
    syscall
    la $t6, input_buffer
    move $t7, $t1        # Destino correto no acervo
    jal copiar_string

    # DEBUG: Imprimir Título Armazenado
    li $v0, 4
    move $a0, $t1
    syscall

    # Ler e armazenar Autor (offset 64)
    li $v0, 4
    la $a0, msg_autor
    syscall
    li $v0, 8
    la $a0, input_buffer
    li $a1, 64
    syscall
    la $t6, input_buffer
    addi $t7, $t1, 64   # Offset do autor
    jal copiar_string

    # DEBUG: Imprimir Autor Armazenado
    li $v0, 4
    move $a0, $t7
    syscall

    # Ler e armazenar ISBN (offset 128)
    li $v0, 4
    la $a0, msg_isbn
    syscall
    li $v0, 8
    la $a0, input_buffer
    li $a1, 16
    syscall
    la $t6, input_buffer
    addi $t7, $t1, 128  # Offset do ISBN
    jal copiar_string

    # DEBUG: Imprimir ISBN Armazenado
    li $v0, 4
    move $a0, $t7
    syscall

    # Ler e armazenar Quantidade (offset 144) como STRING
    li $v0, 4
    la $a0, msg_qtd
    syscall

    li $v0, 8            # Syscall para ler string
    la $a0, input_buffer # Buffer de entrada
    li $a1, 16           # Tamanho máximo 16 bytes
    syscall

    la $t6, input_buffer
    addi $t7, $t1, 144   # Endereço correto da quantidade no acervo
    jal copiar_string    # Copia a string da quantidade para o acervo
    # Mensagem de sucesso
    li $v0, 4
    la $a0, msg_cadastrado
    syscall
 
    jal salvar_acervo_em_arquivo  # Salva no arquivo
    j main

listar_livros:
    # Abrir o arquivo  
    li $v0, 13           # syscall para abrir arquivo  
    la $a0, endereco_acervo_livros     # nome do arquivo  
    li $a1, 0            # modo leitura  
    syscall  
    
    # Verifica se o arquivo foi aberto corretamente
    bltz $v0, error_open_file # Se $v0 for negativo, erro ao abrir
    
    # Salvar o descritor de arquivo  
    move $t0, $v0        # $t0 agora contém o descritor do arquivo  

read_loop:  
    # Ler o arquivo  
    li $v0, 14           # syscall para ler o arquivo  
    move $a0, $t0        # descritor do arquivo  
    la $a1, buffer       # buffer para armazenar dados  
    li $a2, 256          # número de bytes a ler  
    syscall  
    
    # Checar se chegou ao final do arquivo  
    beqz $v0, close_file # se nada for lido, fecha o arquivo  

    # Salvar quantidade de bytes lidos
    move $t1, $v0  

    # Imprimir o conteúdo lido byte a byte
    la $t2, buffer   # Ponteiro para o buffer
    li $t3, 0        # Contador de bytes

print_loop:
    lb $t4, 0($t2)  # Carrega um byte do buffer

    beqz $t4, next_read  # Se for NULL, termina a impressão

    li $v0, 11  # Syscall para imprimir caractere (inclui espaços)
    move $a0, $t4
    syscall

    addi $t2, $t2, 1  # Avança para o próximo byte
    addi $t3, $t3, 1  # Incrementa contador

    blt $t3, $t1, print_loop  # Continua imprimindo até ler todos os bytes

next_read:
    j read_loop          # Loop para ler mais dados  

close_file:  
    # Fechar o arquivo  
    li $v0, 16           # syscall para fechar o arquivo  
    move $a0, $t0        # descritor do arquivo  
    syscall  
    j listar_fim

error_open_file:
    li $v0, 4
    la $a0, msg_erro_arquivo
    syscall
    j listar_fim

listar_fim:
    j main  # Retorna ao menu principal
       	
remover_livro:
    # Abrir arquivo para leitura e carregar no acervo
    li $v0, 13  # Syscall: Open File
    la $a0, nome_arquivo
    li $a1, 0   # O_RDONLY (somente leitura)
    syscall

    move $t0, $v0  # Salvar descritor do arquivo

    # Ler o conteúdo do arquivo para a memória (acervo)
    li $v0, 14  # Syscall: Read File
    move $a0, $t0
    la $a1, acervo  # Memória onde os livros serão carregados
    li $a2, 1520  # Tamanho total (152 bytes * 10 livros)
    syscall

    # Fechar arquivo após leitura
    li $v0, 16
    move $a0, $t0
    syscall

    # Mensagem indicando o debug
    li $v0, 4
    la $a0, msg_debug
    syscall

    # Loop para printar todo o conteúdo do acervo carregado na memória
    la $t1, acervo  # Ponteiro para o início do acervo
    li $t2, 1520    # Total de bytes a serem lidos

printar_acervo:
    lb $a0, 0($t1)  # Carrega um byte do acervo
    beqz $a0, fim_printar_acervo  # Se encontrar um NULL, para a impressão
    li $v0, 11      # Syscall: Printar caractere
    syscall

    addi $t1, $t1, 1  # Avança para o próximo byte
    subi $t2, $t2, 1  # Decrementa contador
    bgtz $t2, printar_acervo  # Continua imprimindo até acabar

fim_printar_acervo:
    # Nova linha após imprimir o acervo
    li $v0, 4
    la $a0, msg_newline
    syscall

    # Pedir ISBN ao usuário
    li $v0, 4
    la $a0, msg_pedir_isbn
    syscall

    # Ler o ISBN digitado
    li $v0, 8
    la $a0, input_buffer
    li $a1, 16   # ISBN tem 16 bytes
    syscall

    # Percorrer os livros armazenados no acervo
    la $t1, acervo  # Início da lista de livros
    li $t2, 0       # Contador de livros
    li $t3, 10      # Máximo de livros armazenados

loop_busca_livro:
    addi $t4, $t1, 128  # O ISBN fica no offset 128 do livro

    # Comparar ISBN do usuário com ISBN armazenado
    li $t5, 16   # Tamanho do ISBN
    move $t6, $t4  # Ponteiro para ISBN no acervo
    la $t7, input_buffer  # Ponteiro para ISBN digitado

compara_isbn:
    lb $t8, 0($t6)  # Carrega um byte do ISBN no acervo
    lb $t9, 0($t7)  # Carrega um byte do ISBN digitado
    bne $t8, $t9, proximo_livro  # Se for diferente, passa para o próximo livro

    addi $t6, $t6, 1  # Avança no ISBN do acervo
    addi $t7, $t7, 1  # Avança no ISBN digitado
    subi $t5, $t5, 1  # Decrementa o contador de bytes
    bgtz $t5, compara_isbn  # Continua comparando enquanto não terminar

    # Se chegou aqui, o ISBN foi encontrado -> Apagar o livro
    li $t5, 152  # Tamanho do registro do livro
    move $t6, $t1  # Ponteiro para o início do livro

zera_livro:
    sb $zero, 0($t6)  # Substitui byte por zero
    addi $t6, $t6, 1  # Avança para o próximo byte
    subi $t5, $t5, 1  # Decrementa contador
    bgtz $t5, zera_livro  # Continua apagando até zerar tudo

    # Mensagem de sucesso
    li $v0, 4
    la $a0, msg_sucesso
    syscall

    # Chamar a função para salvar o acervo atualizado
    jal salvar_acervo_em_arquivo
    j main  # Retorna ao menu

proximo_livro:
    addi $t1, $t1, 152  # Avança para o próximo livro
    addi $t2, $t2, 1
    blt $t2, $t3, loop_busca_livro  # Continua buscando se ainda há livros

    # Se chegou aqui, o ISBN não foi encontrado
    li $v0, 4
    la $a0, msg_erro
    syscall
    j main  # Retorna ao menu
    
    
truncate_livros:
    # Abrir arquivo para escrita
    li $v0, 13
    la $a0, nome_arquivo
    li $a1, 1  # Modo de escrita (O_WRONLY)
    syscall

    bltz $v0, erro_arquivo  # Se falhar, sai

    fechar_arquivo
	

# ============================== USU�?RIOS ==============================

#Inserir o usuario no sistema
inserir_usuarios:
	limpar_buffer #Prepara para o proximo argumento

	#Carrega os usuarios atulizados no s1
	ler_arquivo_usuarios
	#Carrega nos reg t6 e t7 com informacoes necessarias para a formatacao do dado
	la $t6, conc_divisoria        # (';')
	la $t7, conc_quebra_de_linha  # ('\n')
	la $t8, buffer_linha
	
	#Passagem de parametros, adicionar uma quebra de linha no final do arquivo para receber o proximo arquivo
	move $a0, $s3
    	move $a1, $t7
    	strcat
	
	#Separa o nome do usuario
    	move $a0, $s3
    	la $a1, arg_nome
    	extrator_de_argumentos
    	
    	beq $v0, 4, erro_nome
    	
    	#Passagem de parametros para afuncao concatenadora, adiciona o nome
    	move $a0, $t8
    	move $a1, $a2
    	strcat
    	
    	#Passagem de parametros para afuncao concatenadora, adiciona o divisor
    	move $a0, $t8
    	move $a1, $t6 
    	strcat
    	
    	limpar_buffer #Prepara para o proximo argumento
    	
    	#Separa a mtricula
    	move $a0, $s3
    	la $a1,arg_matricula
    	extrator_de_argumentos
    	
    	beq $v0, 4, erro_matricula
    	
    	#Passagem de parametros para afuncao concatenadora, adiciona a matricula
    	move $a0, $t8
    	move $a1, $a2
    	strcat
    	
    	#Passagem de parametros para afuncao concatenadora, adiciona o divisor
    	move $a0, $t8
    	move $a1, $t6 
    	strcat
    
	limpar_buffer #Prepara para o proximo argumento
    
    	#Separa o curso
    	move $a0, $s3
    	la $a1, arg_curso
    	extrator_de_argumentos
    	
    	beq $v0, 4, erro_curso
	
	#Passagem de parametros para afuncao concatenadora, adiciona o curso
    	move $a0, $t8
    	move $a1, $a2
    	strcat
    	
    	#Passagem de parametros para afuncao concatenadora, adiciona a quebra de linha
    	move $a0, $t8
    	move $a1, $t7 
    	strcat
    	
    	#Passagem de parametros para afuncao concatenadora, adiciona as informacoes do novo usuario no reg s3 (registrador que contem os dados do arquivo txt)
	move $a0, $s3
	move $a1, $t8
	strcat
	
	j main        

#Imprime a mesnagem de erro caso o nome não tenha sido inserido
erro_nome:
	li $v0, 4
	la $a0, msg_erro_nome
	syscall
	
	j main

#Imprime a mesnagem de erro caso a matricula nao tenha sido inserida
erro_matricula:
	li $v0, 4
	la $a0, msg_erro_matricula
	syscall
	
	j main

#Imprime a mesnagem de erro caso o curso não tenha sido inserido
erro_curso:
	li $v0, 4
	la $a0, msg_erro_curso
	syscall
	
	j main
	
	
	

# ============================== EMPRESTIMO E DEVOLUÇÃO ==============================
registrar_emprestimo:
	li $v0, 4
    	la $a0, msg_em_breve
    	syscall
    	j main

registrar_devolucao:
	li $v0, 4
    	la $a0, msg_em_breve
    	syscall
    	j main
    	
# ============================== DATA_HORA ==============================
print_data_hora:
	jal data_hora
	j imprimir_data_hora

data_hora:

subu $sp, $sp, 4   # Reserva espa�o na pilha
sw $ra, 0($sp)     # Salva o endere�o de retorno

	li $v0, 30
	syscall

	la $t0, milisegundos_offset
	lw $t1, 4($t0) #parte baixa
	lw $t2, 0($t0) #parte alta

	bgtu $a0, $t1, sem_underflow
	subi $a1, $a1, 1
	sem_underflow:
	sub $a0, $a0, $t1
	sub $a1, $a1, $t2

	li $a2, 1000
	jal div64x16  

	#a0:a1 = seconds since epoch

	li $a2, 43200
	jal div64x16

	#a0:a1 = half-days since epoch
	#hi = seconds in half-day

	mfhi $t0              #Seconds in the half-day

	move $t6, $a0 # menos significante
	move $t7, $a1 # mais significante

	andi $a0, $t6, 1      #a0 = 1 if odd half-day number (otherwise 0)
	ror $a0, $a0, 1       #a0 < 0 if odd half-day number (otherwise 0)
	sra $a0, $a0, 31      #a0 = 0xffffffff if odd half-day number (otherwise 0)
	andi $a0, $a0, 43200  #a0 = 43200  if odd half-day number (otherwise 0)

	add $t0, $t0, $a0     #t0 = seconds in the day

	li $t1, 3600
	div $t0, $t1         
	mflo $t0              #t0 = Hour

	subi $t0, $t0, 3

	mfhi $t1 
	li $t2, 60 
	div $t1, $t2 
	mflo $t1              #t1 = Minute
	mfhi $t2              #t2 = Second

	jal tratar_horas

	add $t6, $t6, $t3
	

	la $t4, tempo
	sw $t0, 12($t4)
	sw $t1, 16($t4)
	sw $t2, 20($t4)

	move $a0, $t6 # menos significante
	move $a1, $t7 # mais significante

	li $a2, 2
	jal div64x16

	jal pegar_data

	lw $ra, 0($sp)     # Restaura o endere�o de retorno
	addu $sp, $sp, 4   # Libera espa�o na pilha
	jr $ra             # Retorna para quem chamou


div64x16:
 	subu $sp, $sp, 16

 	sw $a0, ($sp)
 	sw $a1, 4($sp)

 	add $t0, $sp, 8     # Pointer to digits (N)
 	add $t3, $sp, 16    # Pointer to result (M)
 	xor $t1, $t1, $t1   # Remainder

loop: 
  	subu $t3, $t3, 2
  	subu $t0, $t0, 2

  	sll $t1, $t1, 16   # t1 = R * 65536
  	lhu $t2, ($t0)     # t2 = N[i]
  	addu $t2, $t2, $t1 # t2 = N[i] + R * 65536

  	div $t2, $a2

  	mflo $t1           # t1 = (N[i] + R * 65536) / K
  	sh $t1, ($t3)      # M[i] = (N[i] + R * 65536) / K

  	mfhi $t1           # t1 =  (N[i] + R * 65536) % K

 	bne $t0, $sp, loop

 	mthi $t1

 	lw $a0, 8($sp) 
 	lw $a1, 12($sp)

 	addu $sp, $sp, 16
 	jr $ra 


tratar_horas:
	# t0 = horas
	# t1 = minutos
	# t2 = segundos
	li $t3, 0

ajustar_horas_negativas:
   bge $t0,  $zero, somar_offset
   addi $t0, $t0, 24
   subi $t3, $t3, 1

somar_offset:
   	la $t4, tempo_base
	lw $t5, 20($t4)
	add $t2, $t2, $t5
	
	lw $t5, 16($t4)
	add $t1, $t1, $t5
	
	lw $t5, 12($t4)
	add $t0, $t0, $t5
	
ajustar_segundos:
	li $t5, 60
	blt $t2, $t5, ajustar_minutos
	sub $t2, $t2, $t5
	addi $t1, $t1, 1
	
ajustar_minutos:
	li $t5, 60
	blt $t1, $t5, ajustar_horas
	sub $t1, $t1, $t5
	addi $t0, $t0, 1
	
ajustar_horas:
	li $t5, 24
	blt $t0, $t5, horas_certas
	sub $t0, $t0, $t5
	li $t3, 1
   
horas_certas:
	jr $ra
         
         
#sub

pegar_data:

subu $sp, $sp, 4   # Reserva espa�o na pilha
sw $ra, 0($sp)     # Salva o endere�o de retorno

la $t3, tempo_base
lw $t0, 4($t3) #m�s
lw $t1, 0($t3) #ano
lw $t2, 8($t3) #dias
addu $a0, $a0, $t2 #dias_restantes

li $t2, 2
beq $t0, $t2, qual_fevereiro

li $t2, 3
beq $t0, $t2, marco

li $t2, 4
beq $t0, $t2, abril

li $t2, 5
beq $t0, $t2, maio

li $t2, 6
beq $t0, $t2, junho

li $t2, 7
beq $t0, $t2, julho

li $t2, 8
beq $t0, $t2, agosto

li $t2, 9
beq $t0, $t2, setembro

li $t2, 10
beq $t0, $t2, outubro

li $t2, 11
beq $t0, $t2, novembro

li $t2, 12
beq $t0, $t2, dezembro

j loop_data

qual_fevereiro:
	andi $t2, $t1, 3  # Verifica os dois �ltimos bits de $t0
	beq $t2, $zero, fevereiro_bissexto
	j fevereiro_normal
loop_data:
    	
    	janeiro:
		#janeiro
		li $a2, 31
		jal subtrair
	
		li $t0, 2
		
		j qual_fevereiro
	
	fevereiro_normal:
	 	#fevereiro
	 	li $a2, 28
	 	jal subtrair
	
		li $t0, 3
		
		j marco
	
	fevereiro_bissexto:
	 	#fevereiro
	 	li $a2, 29
	 	jal subtrair
	
		li $t0, 3
	
	marco:
		#mar�o
		li $a2, 31
		jal subtrair
	
		li $t0, 4
	
	abril:
		#abril
		li $a2, 30
		jal subtrair
	
		li $t0, 5
	
	maio:
		#maio
		li $a2, 31
		jal subtrair
	
		li $t0, 6
	
	junho:
		#junho
		li $a2, 30
		jal subtrair
	
		li $t0, 7
	
	julho:
		#julho
		li $a2, 31
		jal subtrair
	
		li $t0, 8
	
	agosto:
		#agosto
		li $a2, 31
		jal subtrair
	
		li $t0, 9
	
	setembro:
		#setembo
		li $a2, 30
		jal subtrair
	
		li $t0, 10
	
	outubro:
		#outubro
		li $a2, 31
		jal subtrair
	
		li $t0, 11
	
	novembro:
		#novembro
		li $a2, 30
		jal subtrair
	
		li $t0, 12
	
	dezembro:
		#dezembro
		li $a2, 31
		jal subtrair
	
		li $t0, 1
		addi $t1, $t1, 1
	
		j loop_data
subtrair:
	#a0:a1 dias | a2 = subtrator
	bgt $a1, $zero, subtrair_com_underflow
	j subtrair_sem_underflow

subtrair_com_underflow:
	sub $a0, $a0, $a2
	blt $a0, $zero, ajuste
	jr $ra
subtrair_sem_underflow:
	blt $a0, $a2, finalizar
	sub $a0, $a0, $a2
	jr $ra
ajuste:
	sub $a1, $a1, 1
	jr $ra
finalizar:
	la $t3, tempo
	sw $t1, 0($t3)
	sw $t0, 4($t3)
	sw $a0, 8($t3)
    	lw $ra, 0($sp)     # Restaura o endere�o de retorno
    	addu $sp, $sp, 4   # Libera espa�o na pilha
    	jr $ra             # Retorna para quem chamou   
                  
#dataHora   
imprimir_data_hora:
	
	la $t0, tempo    # Carrega o endereço base de 'tempo'
	
	# Mostra a data
	li $v0, 4
	la $a0, msg_data
	syscall
	
    	li $v0, 36
    	lw $a0, 8($t0)  # Carrega o dia
    	bgt $a0, 9, dia_dois_digitos
	li $a0, 0
	syscall
	lw $a0, 8($t0)  # Carrega o dia
	dia_dois_digitos:
    	syscall
	
	li $v0, 4
	la $a0, msg_barra
	syscall
	
	li $v0, 36
	lw $a0, 4($t0)  # Carrega o mês
	bgt $a0, 9, mes_dois_digitos
	li $a0, 0
	syscall
	lw $a0, 4($t0)  # Carrega o mês
	mes_dois_digitos:
    	syscall
	
	li $v0, 4
	la $a0, msg_barra
	syscall
	
    	li $v0, 36
	lw $a0, 0($t0)  # Carrega o ano
    	syscall
	
    	li $v0, 4
	la $a0, msg_quebra_de_linha
	syscall
	
	# Mostra as horas
	
	li $v0, 4
	la $a0, msg_hora
	syscall
	
    	li $v0, 36
	lw $a0, 12($t0)  # Carrega as horas
	bgt $a0, 9, hora_dois_digitos
	li $a0, 0
	syscall
	lw $a0, 12($t0)  # Carrega as horas
	hora_dois_digitos:
    	syscall
	
	li $v0, 4
	la $a0, msg_dois_pontos
	syscall
	
    	li $v0, 36
	lw $a0, 16($t0)  # Carrega o minuto
	bgt $a0, 9, minutos_dois_digitos
	li $a0, 0
	syscall
	lw $a0, 16($t0)  # Carrega o minuto
	minutos_dois_digitos:
    	syscall
	
	li $v0, 4
	la $a0, msg_dois_pontos
	syscall
	
    	li $v0, 36
	lw $a0, 20($t0)  # Carrega o sgundo
	bgt $a0, 9, segundos_dois_digitos
	li $a0, 0
	syscall
	lw $a0, 20($t0)  # Carrega o segundo
	segundos_dois_digitos:
    	syscall
    	
    	li $v0, 4
	la $a0, msg_quebra_de_linha
	syscall
    	
    	j main
	
ajustar_data:
	move $a0, $s3
	la $a1, arg_data
	jal extrator_de_argumentos
	la $a0, buffer_argumento
	li $a1, '/'
	li $a2, 1
	jal split
	move $t7, $t3
	move $t6, $t2
	move $t5, $t1
	
	la $a1, buffer_argumento
	jal limpar_buffer
	move $a0, $s3
	la $a1, arg_hora
	jal extrator_de_argumentos
	la $a0, buffer_argumento
	li $a1, ':'
	li $a2, 0
	jal split
	
	la $t0, tempo_base    # Carrega o endereço base de 'tempo'
	
	sw $t7, 0($t0) 
	sw $t6, 4($t0)
	sw $t5, 8($t0)
	sw $t1, 12($t0)
	sw $t2, 16($t0)
	sw $t3, 20($t0)
	
	li $v0, 30
	syscall
	
	la $t0, milisegundos_offset
	sw $a0, 4($t0)
	sw $a1, 0($t0)
	
	j main

split:
	subu $sp, $sp, 4   # Reserva espa輟 na pilha
	sw $ra, 0($sp)     # Salva o endere輟 de retorno
	#a0 = string
	#a1 = character separador
	#a2 = 1 data, 0 hora
	#t0 = nova string
	#t1 = dias/horas
	#t2 = meses/minutos
	#t3 = ano/segundos
	#t4 = ponteiro
	la $t0, buffer_date_time
	beq $a2, 1, validar_estrutura_data
	beq $a2, 0, validar_estrutura_hora
split_loop:
	lb $t4, 0($a0)    # Carrega o próximo caractere de str1 em $a0
	beq $t4, $a1, proximo_char
	
split_validar_digito:
	beqz $t4, pegar_valor
	li $t2, '0'
        li $t3, '9'
        blt $t4, $t2, data_ou_hora_incorreta
        bgt $t4, $t3, data_ou_hora_incorreta
        sb $t4, 0($t0)       # Store the character in the buffer
    	addi $t0, $t0, 1     # Move to the next position in the buffer

proximo_char:
	addi $a0, $a0, 1         # Incrementa o ponteiro de str1
	j split_loop
	
pegar_valor:
	li $t1, 0
	li $t2, 0
	li $t3, 0
	beq $a2, 1, pegar_data_split
	beq $a2, 0, pegar_hora_split
	
pegar_data_split:
	#pegar dia/hora
	la $a0, buffer_date_time
	lb $t1, 0($a0)
	subi $t1, $t1, 48
	mul $t1, $t1, 10
	lb $t4, 1($a0)
	subi $t4, $t4, 48
	add $t1, $t1, $t4
	
	#pegar mes/minuto
	lb $t2, 2($a0)
	subi $t2, $t2, 48
	mul $t2, $t2, 10
	lb $t4, 3($a0)
	subi $t4, $t4, 48
	add $t2, $t2, $t4
	
	#pegar ano/segundo
	lb $t3, 4($a0)
	subi $t3, $t3, 48
	mul $t3, $t3, 1000
	lb $t4, 5($a0)
	subi $t4, $t4, 48
	mul $t4, $t4, 100
	add $t3, $t3, $t4
	lb $t4, 6($a0)
	subi $t4, $t4, 48
	mul $t4, $t4, 10
	add $t3, $t3, $t4
	lb $t4, 7($a0)
	subi $t4, $t4, 48
	add $t3, $t3, $t4
	
	andi $t4, $t3, 3  # Verifica se o ano e bissexto
	beq $t4, $zero, validar_ano_bissexto
	
	validar_ano_normal:
		la $t4, meses_normais
		sll $t0, $t2, 2
		add $t4, $t4, $t0
		lw $t4, 0($t4)
		bgt $t1, $t4, dias_grandes
		j continuar_validacao
	validar_ano_bissexto:
		la $t4, meses_bissexto
		sll $t0, $t2, 2
		add $t4, $t4, $t0
		lw $t4, 0($t4)
		bgt $t1, $t4, dias_grandes
		
	continuar_validacao:
	bgt $t2, 12, mes_grande
	
	lw $ra, 0($sp)     # Restaura o endere�o de retorno
	addu $sp, $sp, 4   # Libera espa�o na pilha
	jr $ra             # Retorna para quem chamou
	
pegar_hora_split:
	#pegar dia/hora
	la $a0, buffer_date_time
	lb $t1, 0($a0)
	subi $t1, $t1, 48
	mul $t1, $t1, 10
	lb $t4, 1($a0)
	subi $t4, $t4, 48
	add $t1, $t1, $t4
	
	#pegar mes/minuto
	lb $t2, 2($a0)
	subi $t2, $t2, 48
	mul $t2, $t2, 10
	lb $t4, 3($a0)
	subi $t4, $t4, 48
	add $t2, $t2, $t4
	
	#pegar ano/segundo
	lb $t3, 4($a0)
	subi $t3, $t3, 48
	mul $t3, $t3, 10
	lb $t4, 5($a0)
	subi $t4, $t4, 48
	add $t3, $t3, $t4
	
	bgt $t1, 23, horas_grandes
	bgt $t2, 59, minutos_grandes
	bgt $t3, 59, segundos_grandes
	
	addi $t1, $t1, 3
	li $v0, 24
	div $t1, $v0
	mfhi $t1
	
	lw $ra, 0($sp)     # Restaura o endere�o de retorno
	addu $sp, $sp, 4   # Libera espa�o na pilha
	jr $ra             # Retorna para quem chamou

validar_estrutura_data:
	move $a3, $a1
	la $a1, buffer_argumento
	jal calcular_tamanho_string
	blt $v0, 10, data_ou_hora_incorreta
	la $a1, buffer_argumento
	lb $t1, 2($a1)
	bne $t1, $a3, data_ou_hora_incorreta
	lb $t1, 5($a1)
	bne $t1, $a3, data_ou_hora_incorreta
	move $a1, $a3
	j split_loop
	
validar_estrutura_hora:
	move $a3, $a1
	la $a1, buffer_argumento
	jal calcular_tamanho_string
	blt $v0, 8, data_ou_hora_incorreta
	la $a1, buffer_argumento
	lb $t1, 2($a1)
	bne $t1, $a3, data_ou_hora_incorreta
	lb $t1, 5($a1)
	bne $t1, $a3, data_ou_hora_incorreta
	move $a1, $a3
	j split_loop
	
data_ou_hora_incorreta:
	beq $a2, 1, data_incorreta
	beq $a2, 0, hora_incorreta
data_incorreta:
	li $v0, 4
	la $a0, msg_erro_data
	syscall
	la $a0, msg_quebra_de_linha
	syscall
	j main
hora_incorreta:
	li $v0, 4
	la $a0, msg_erro_data
	syscall
	la $a0, msg_quebra_de_linha
	syscall
	j main

minutos_grandes:
	li $v0, 4
	la $a0, msg_erro_minuto
	syscall
	la $a0, msg_quebra_de_linha
	syscall
	j main
segundos_grandes:
	li $v0, 4
	la $a0, msg_erro_segundos
	syscall
	la $a0, msg_quebra_de_linha
	syscall
	j main
horas_grandes:
	li $v0, 4
	la $a0, msg_erro_horas
	syscall
	la $a0, msg_quebra_de_linha
	syscall
	j main
dias_grandes:
	li $v0, 4
	la $a0, msg_erro_dias
	syscall
	la $a0, msg_quebra_de_linha
	syscall
	j main
mes_grande:
	li $v0, 4
	la $a0, msg_erro_mes
	syscall
	la $a0, msg_quebra_de_linha
	syscall
	j main

# ============================== DADOS ==============================
gerar_relatorio:
	li $v0, 4
    	la $a0, msg_em_breve
    	syscall
    	j main
    	
salvar_dados:
	li $v0, 4
    	la $a0, msg_em_breve
    	syscall
    	j main

############## MANIPULACAO DOS ARQUIVOS ##############

################### ARQUIVOS ACERVO ##################
ler_arquivo_livros:
	la $a0, endereco_acervo_livros #Carrega o endereço do arquivo no reg a0
	la $t1, conteudo_acervo_livro
	ler_arquivo #Abre o arquivo que está no endereco a0
	move $s0, $a1 #Salva o endereco de memoria com os conteudos do arquivo
	#Fechando o arquivo
	fechar_arquivo


################## ARQUIVOS USUARIOS #################
ler_arquivo_usuarios:
	#Abrindo arquivo no modo de leitura
	la $a0, endereco_contas_usuarios #Carrega o endereço do arquivo no reg a0
	la $t1, conteudo_contas_usuarios
	ler_arquivo #Abre o arquivo que está no endereco a0
	move $s1, $a1 #Salva o endereco de memoria com os conteudos do arquivo
	#Fechando o arquivo
	fechar_arquivo


################ ARQUIVOS EMPRESTIMOS ################
ler_arquivo_emprestimos:
	#Abrindo arquivo no modo de leitura
	la $a0, endereco_emprestimos #Carrega o endereço do arquivo no reg a0
	la $t1, conteudo_emprestimos
	ler_arquivo #Abre o arquivo que está no endereco a0
	move $s2, $a1 #Salva o endereco de memoria com os conteudos do arquivo
	#Fechando o arquivo
	fechar_arquivo



erro_arquivo:
    # Exibe mensagem de erro e encerra
    li $v0, 4
    la $a0, msg_erro
    syscall
    j main                # Volta ao menu principal

salvar_acervo_em_arquivo:
    # Abrir arquivo para escrita
    li $v0, 13
    la $a0, nome_arquivo
    li $a1, 1  # Modo de escrita
    syscall

    bltz $v0, erro_arquivo  # Se falhar, sai

    move $t0, $v0  # Salva o descritor do arquivo

    la $t1, acervo  # Início do acervo
    li $t2, 0  # Contador de livros

loop_salvar:
    lb $t3, 0($t1)  # Verifica se há livro cadastrado
    beqz $t3, fim_salvar  # Se não há mais livros, sai do loop

    ####### Escrever Título #######
    move $a1, $t1  # Passa o endereço do título para a função
    jal calcular_tamanho_string  # Calcula o tamanho do título
    li $v0, 15
    move $a0, $t0
    move $a1, $t1  # Endereço do título
    move $a2, $v0  # Tamanho real do título
    syscall

    # Escrever ";"
    li $v0, 15
    move $a0, $t0
    la $a1, msg_ponto_virgula
    li $a2, 1
    syscall

    ####### Escrever Autor #######
    addi $t4, $t1, 64  # Endereço do autor
    move $a1, $t4  # Passa o endereço do autor para a função
    jal calcular_tamanho_string  # Calcula o tamanho do autor
    li $v0, 15
    move $a0, $t0
    move $a1, $t4  # Endereço do autor
    move $a2, $v0  # Tamanho real do autor
    syscall

    # Escrever ";"
    li $v0, 15
    move $a0, $t0
    la $a1, msg_ponto_virgula
    li $a2, 1
    syscall

    ####### Escrever ISBN #######
    addi $t5, $t1, 128  # Endereço do ISBN
    move $a1, $t5  # Passa o endereço do ISBN para a função
    jal calcular_tamanho_string  # Calcula o tamanho do ISBN
    li $v0, 15
    move $a0, $t0
    move $a1, $t5  # Endereço do ISBN
    move $a2, $v0  # Tamanho real do ISBN
    syscall

    # Escrever ";"
    li $v0, 15
    move $a0, $t0
    la $a1, msg_ponto_virgula
    li $a2, 1
    syscall

    ####### Escrever Quantidade #######
    addi $t6, $t1, 144  # Endereço da quantidade
    move $a1, $t6  # Passa o endereço da quantidade para a função
    jal calcular_tamanho_string  # Calcula o tamanho da quantidade
    li $v0, 15
    move $a0, $t0
    move $a1, $t6  # Endereço da quantidade
    move $a2, $v0  # Tamanho real da quantidade
    syscall

    # Escrever ";"
    li $v0, 15
    move $a0, $t0
    la $a1, msg_ponto_virgula
    li $a2, 1
    syscall

    # Avançar para o próximo livro
    addi $t1, $t1, 152  # Avança para o próximo livro
    addi $t2, $t2, 1
    li $t4, 10
    blt $t2, $t4, loop_salvar  # Continua enquanto não atingir 10 livros

salvar_usuario_em_arquivo:
    # Abrir arquivo para escrita
    li $v0, 13
    la $a0, endereco_contas_usuarios
    li $a1, 1  # Modo de escrita (O_WRONLY)
    syscall

    bltz $v0, erro_arquivo  # Se falhar, sai

    move $t0, $v0  # Salva o descritor do arquivo

    la $t1, conteudo_contas_usuarios  # Início 
    li $t2, 0  # Contador de usuarios

loop_salvar_usuario:
    lb $t3, 0($t1)  # Verifica se há usuarios cadastrado
    beqz $t3, fim_salvar  # Se não há mais usuarios, sai do loop

    ####### Escrever Nome #######
    move $a1, $t1
    jal calcular_tamanho_string  # Retorna comprimento em $v0
    li $v0, 15
    move $a0, $t0
    move $a1, $t1  # Nome
    move $a2, $v0  # Tamanho real da string (sem espaços extras)
    syscall

    # Escrever ";"
    li $v0, 15
    move $a0, $t0
    la $a1, msg_ponto_virgula
    li $a2, 1
    syscall

    ####### Escrever Matricula #######
    addi $t4, $t1, 64  # Ponteiro para matricula
    move $a1, $t4
    jal calcular_tamanho_string  # Retorna comprimento em $v0
    li $v0, 15
    move $a0, $t0
    move $a1, $t4
    move $a2, $v0  # Usa o tamanho real da string
    syscall

    # Escrever ";"
    li $v0, 15
    move $a0, $t0
    la $a1, msg_ponto_virgula
    li $a2, 1
    syscall

    ####### Escrever Curso #######
    addi $t5, $t1, 128  # Ponteiro para curso
    move $a1, $t5
    jal calcular_tamanho_string  # Retorna comprimento em $v0
    li $v0, 15
    move $a0, $t0
    move $a1, $t5
    move $a2, $v0  # Usa o tamanho real da string
    syscall

    # Escrever ";"
    li $v0, 15
    move $a0, $t0
    la $a1, msg_ponto_virgula
    li $a2, 1
    syscall

    # Escrever nova linha "\n" para finalizar o registro
    li $v0, 15
    move $a0, $t0
    la $a1, msg_newline
    li $a2, 1
    syscall

    # Avançar para o próximo usuario
    addi $t1, $t1, 192  # Avança para o próximo usuario
    addi $t2, $t2, 1
    li $t4, 10
    blt $t2, $t4, loop_salvar_usuario  # Continua enquanto não atingir 10 usuarios

fim_salvar:
    # Fechar arquivo
    li $v0, 16
    move $a0, $t0
    syscall
    j main

calcular_tamanho_string:
    li $v0, 0  # Inicializa o contador de tamanho
loop_tamanho:
    lb $t9, 0($a1)  # Lê um byte da string
    beqz $t9, fim_tamanho  # Se for NULL ('\0'), terminou
    addi $a1, $a1, 1  # Avança na string
    addi $v0, $v0, 1  # Incrementa o tamanho
    j loop_tamanho
fim_tamanho:
    jr $ra  # Retorna o tamanho em $v0


copiar_string:
    lb $t8, 0($t6)  # Lê um byte da string de origem
    beqz $t8, fim_copiar  # Se for NULL, terminou
    beq $t8, 10, fim_copiar  # Se for nova linha, terminou
    sb $t8, 0($t7)  # Copia o byte para o destino
    addi $t6, $t6, 1  # Avança na string de origem
    addi $t7, $t7, 1  # Avança na string de destino
    j copiar_string
fim_copiar:
    sb $zero, 0($t7)  # Adiciona NULL no final da string de destino
    jr $ra


# ============================== ERRO E SAIDA ==============================
espaco_cheio:
    li $v0, 4
    la $a0, msg_error_armazenamento
    syscall
    j main  # Retorna ao menu principal

sair:
    li $v0, 10  # Finaliza o programa
    syscall
    
campo_obrigatorio:
    li $v0, 4
    la $a0, msg_campo_obrigatorio
    syscall
    j main
    
#================================UTILIDADES===============================

######### Documentacao Extrator ###########
# a0 -> recebe o comando                  #
# a1 ->  recebe o argumento buscado       #
# a2 -> buffer do argumento               #
###########################################

extrator_de_argumentos:
	subu $sp, $sp, 4   # Reserva espaco na pilha
	sw $ra, 0($sp)     # Salva o endereco de retorno
	
	la $a2, buffer_argumento
	jal strstr
	beq $v0, 0, finalizado_loop_fracasso

pular_argumento:
    lb $t1, 0($t0)      # Carrega caractere
    beqz $t1, finalizado_loop_fracasso # Se chegou no fim da string, erro
    li $t4, 39      # Codigo ASCII da aspa simples (')
    li $t5, 34      # Codigo ASCII da aspa dupla (")
    beq $t1, $t4, finalizado_loop_sucesso # Se for ', pode ser o separador
    beq $t1, $t5, finalizado_loop_sucesso # Se for ", pode ser o separador
    addi $t0, $t0, 1    # Avanca na string
    j pular_argumento   # Continua verificando

finalizado_loop_sucesso:
	move $a0, $t0
	addi $a0, $a0, 1 # Pular o espaco e as aspas
	jal extrair_str_aspas
	
	li $v0, 4
	la $a0, buffer_argumento
	syscall
	
	lw $ra, 0($sp)     # Restaura o enderecco de retorno
	addu $sp, $sp, 4   # Libera espaco na pilha
	jr $ra             # Retorna para quem chamou
	
finalizado_loop_fracasso:
	li $v0, 4
	la $a0, msg_erro_argumento_em_falta
	syscall
	move $a0, $a1
	syscall
	lw $ra, 0($sp)     # Restaura o endereco de retorno
	addu $sp, $sp, 4   # Libera espaco na pilha
	j main


extrair_str_aspas:
loop_aspas:
    lb $t3, 0($a0)  # Carrega um caractere
    beqz $t3, end   # Se for NULL, finaliza

    li $t4, 39      # Codigo ASCII da aspa simples (')
    li $t5, 34      # Codigo ASCII da aspa dupla (")

    beq $t3, $t4, end # Se for uma aspa, finaliza
    beq $t3, $t5, end # Se for uma aspa dupla, finaliza

    sb $t3, 0($a2)  # Salva no buffer de saida
    addi $a0, $a0, 1 # Avanca na string de entrada
    addi $a2, $a2, 1 # Avanca no buffer de saida
    j loop_aspas          # Continua processando

end:
    sb $zero, 0($a2) # Adiciona NULL para finalizar a string
    jr $ra          # Retorna

strstr:
    move $t0, $a0       # Salva inicio da string principal
loop_outer:
    lb $t1, 0($t0)      # Carrega um caractere da string principal
    beqz $t1, not_found # Se chegou ao fim, nao encontrou a substring

    move $t2, $t0       # Ponteiro temporario para a posicao na string principal
    move $t3, $a1       # Ponteiro para a substring

loop_inner:
    lb $t4, 0($t3)      # Carrega um caractere da substring
    beqz $t4, found_str # Se chegou ao fim da substring, encontramos!

    lb $t5, 0($t2)      # Carrega um caractere da string principal
    beqz $t5, not_found # Se chegou ao fim da string principal, nao encontrou
    bne $t4, $t5, next_outer # Se caracteres nao coincidem, tenta praxima posicao

    addi $t2, $t2, 1    # Avanca na string principal
    addi $t3, $t3, 1    # Avanca na substring
    j loop_inner        # Continua verificando

found_str:
    move $v0, $t0       # Retorna o endereco da primeira ocorrcncia
    jr $ra

next_outer:
    addi $t0, $t0, 1    # Avanca o ponteiro na string principal
    j loop_outer        # Continua procurando

not_found:
    li $v0, 0           # Retorna NULL
    jr $ra
	
limpar_buffer:
    # $a1: Aponta para o inicio do buffer a ser limpo

    li $t0, 0            # Carrega 0 em $t0 (valor para limpar)
    
	loop_limpar:
    	lb $t1, 0($a1)             # Carrega o byte atual do buffer
    	beq $t1, $zero, finalizar_limpeza  # Se encontrar NULL (\0), fim da string
    	sb $t0, 0($a1)             # Substitui o byte por 0
    	addi $a1, $a1, 1           # Avanca o ponteiro de $s0
    	j loop_limpar               # Continua limpando

	finalizar_limpeza:
    	jr $ra               # Retorna

################# Concatenador ##################

########### Documentacao Concatenador ###########
 # a0 -> Endereço da string destino		#
 # a1 -> Endereço da string source		#
 #################################################

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
