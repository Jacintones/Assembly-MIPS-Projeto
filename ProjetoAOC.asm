#################### DOCUMENTACAO ####################
# reg $s0 -> Endereco para o acervo de livros
# reg $s1 -> Endereco para a lista com os usuarios
# reg $s2 -> Endereco para a lista de emprestimos
######################################################

.data
	#Enderecos dos arquivos
	#************************** MODIFICAR DIRETORIO DAS PASTAS *********************************
	endereco_acervo_livros: .asciiz "D:/Faculdade/Quarto Periodo/Arquitetura/Testes/livros.txt"
	endereco_contas_usuarios: .asciiz "D:/Faculdade/Quarto Periodo/Arquitetura/Testes/usuarios.txt"
	endereco_emprestimos: .asciiz "D:/Faculdade/Quarto Periodo/Arquitetura/Testes/emprestimos.txt"
	
	#Endereco do conteudo salvo na memoria (Definindo o tamanho MAX dos arquivos: 10Kb, aproximadamente 100 livros)
	conteudo_acervo_livro: .space 10240
	conteudo_contas_usuarios: .space 10240
	conteudo_emprestimos: .space 10240

	# Buffer para entrada de dados
	input_buffer: .space 256

	# Estrutura para armazenar os livros e usuários
	acervo: .space 1024           
	usuarios: .space 512          

	# Mensagens
	msg_shell: .asciiz "Diginomicon-shell>>"
	msg_titulo: .asciiz "Digite o título do livro: "
	msg_autor: .asciiz "Digite o autor do livro: "
	msg_isbn: .asciiz "Digite o ISBN do livro: "
	msg_qtd: .asciiz "Digite a quantidade de exemplares disponíveis: "
	msg_nome: .asciiz "Digite o nome do usuário: "
	msg_matricula: .asciiz "Digite o número de matrícula: "
	msg_curso: .asciiz "Digite o curso do usuário: "
	msg_cadastrado: .asciiz "Cadastro realizado com sucesso!\n"
	msg_error_armazenamento: .asciiz "Erro: espaço cheio!\n"
	msg_error: .asciiz "Comando inválido! Tente novamente.\n"
	msg_opcao: .asciiz "Escolha uma opção: (1) Ver Data e Hora, (2) Cadastrar Livro, (3) Listar Livros, (4) Cadastrar Usuário, (5) Registrar Empréstimo, (6) Gerar Relatório, (7) Remover Livro, (8) Remover Usuário, (9) Salvar Dados, (10) Ajustar Data e Hora, (11) Registrar Devolução, (12) Sair: \n"
	msg_campo_obrigatorio: .asciiz "Erro: Este campo é obrigatório!\n"

	# Mensagens de data e hora
	msg_data: .asciiz "Data: "
	msg_hora: .asciiz "Hora: "
	msg_barra: .asciiz "/"
	msg_dois_pontos: .asciiz ":"
	msg_quebra_de_linha: .asciiz "\n"
	
	tempo: .word 0, 0, 0, 0, 0, 0 #Ano, Mês, Dia, Hora, Minuto, Segundo
	
	# Mensagem temporaria de depuração
	msg_em_breve: .asciiz "Ainda não implementado.\n"
	
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

    la $t5, input_buffer       # Move os dados para o buffer do livro ou usuário
    sw $t5, 0($t1)
.end_macro



.macro imprimir_shell
    # Imprime a emnsagem do shell
    li $v0, 4
    la $a0, msg_shell
    syscall
.end_macro

.text

.globl main

main:
    # Imprime o menu inicial
    li $v0, 4
    la $a0, msg_opcao
    syscall

    imprimir_shell

    # Lê a opção do usuário
    li $v0, 5
    syscall
    move $t0, $v0  # Guarda a opção em $t0

    # Verifica a opção do usuário
    beq $t0, 1, data_hora  # Opção 1: Ver Data e Hora
    beq $t0, 2, cadastrar_livro  # Opção 2: Cadastrar Livro
    beq $t0, 3, listar_livros  # Opção 3: Listar Livros
    beq $t0, 4, cadastrar_usuario  # Opção 4: Cadastrar Usuário
    beq $t0, 5, registrar_emprestimo  # Opção 5: Registrar Empréstimo
    beq $t0, 6, gerar_relatorio  # Opção 6: Gerar Relatório
    beq $t0, 7, remover_livro  # Opção 7: Remover Livro
    beq $t0, 8, remover_usuario  # Opção 8: Remover Usuário
    beq $t0, 9, salvar_dados  # Opção 9: Salvar Dados
    beq $t0, 10, ajustar_data  # Opção 10: Ajustar Data e Hora
    beq $t0, 11, registrar_devolucao  # Opção 11: Registrar Devolução
    beq $t0, 12, sair  # Opção 12: Sair    
    
    # Mensagem de opção invalida
    li $v0, 4
    la $a0, msg_error
    syscall
    
    j main  # Volta para o menu se a opção for inválida


# ============================== LIVROS ==============================
cadastrar_livro:
    # Calcular o próximo espaço disponível na acervo
    la $t1, acervo
    li $t2, 0  # �?ndice para livros

    loop_acervo:
        lb $t3, 0($t1)  # Verifica se há espaço
        beqz $t3, inserir_livro  # Se espaço vazio, cadastrar
        addi $t1, $t1, 100  # Avança para o próximo espaço (tamanho fixo)
        addi $t2, $t2, 1  # Incrementa índice
        li $t4, 10  # Máximo de 10 livros
        bge $t2, $t4, espaco_cheio
        j loop_acervo

inserir_livro:
    # Salvar título
    li $v0, 4
    la $a0, msg_titulo
    syscall
    salvar_dado
    sw $t5, 0($t1)  

    # Salvar autor
    li $v0, 4
    la $a0, msg_autor
    syscall
    salvar_dado
    sw $t5, 4($t1)

    # Salvar ISBN
    li $v0, 4
    la $a0, msg_isbn
    syscall
    salvar_dado
    sw $t5, 8($t1)

    # Salvar quantidade de exemplares (`qtd`)
    li $v0, 4
    la $a0, msg_qtd
    syscall
    salvar_dado
    sw $t5, 12($t1)

    # Mensagem de sucesso
    li $v0, 4
    la $a0, msg_cadastrado
    syscall

    j main



listar_livros:
	li $v0, 4
    	la $a0, msg_em_breve
    	syscall
    	j main
    	
remover_livro:
	li $v0, 4
    	la $a0, msg_em_breve
    	syscall
    	j main

# ============================== USU�?RIOS ==============================
cadastrar_usuario:
    # Calcular o próximo espaço disponível em usuários
    la $t1, usuarios
    li $t2, 0  # �?ndice para usuários

    loop_usuarios:
        lb $t3, 0($t1)  # Verifica se há espaço
        beqz $t3, inserir_usuario  # Se espaço vazio, cadastrar
        addi $t1, $t1, 50  # Avança para o próximo espaço (tamanho fixo)
        addi $t2, $t2, 1  # Incrementa índice
        li $t4, 5  # Máximo de 5 usuários
        bge $t2, $t4, espaco_cheio
        j loop_usuarios

inserir_usuario:
    # Salvar nome
    li $v0, 4
    la $a0, msg_nome
    syscall
    salvar_dado
    sw $t5, 0($t1)

    # Salvar matrícula
    li $v0, 4
    la $a0, msg_matricula
    syscall
    salvar_dado
    sw $t5, 4($t1)

    # Salvar curso
    li $v0, 4
    la $a0, msg_curso
    syscall
    salvar_dado
    sw $t5, 8($t1)

    # Mensagem de sucesso
    li $v0, 4
    la $a0, msg_cadastrado
    syscall

    j main


remover_usuario:
	li $v0, 4
    	la $a0, msg_em_breve
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
data_hora:
    li $v0, 30
syscall

li $a2, 1000 
jal div64x16  

#a0:a1 = seconds since epoch

li $a2, 43200
jal div64x16

#a0:a1 = half-days since epoch
#hi = seconds in half-day

mfhi $s0              #Seconds in the half-day

move $t3, $a0 # menos significante
move $t4, $a1 # mais significante

andi $a0, $t3, 1      #a0 = 1 if odd half-day number (otherwise 0)
ror $a0, $a0, 1       #a0 < 0 if odd half-day number (otherwise 0)
sra $a0, $a0, 31      #a0 = 0xffffffff if odd half-day number (otherwise 0)
andi $a0, $a0, 43200  #a0 = 43200  if odd half-day number (otherwise 0)

add $s0, $s0, $a0     #s0 = seconds in the day

li $t0, 3600
div $s0, $t0         
mflo $s0              #s0 = Hour

subi $s0, $s0, 3

jal tratar_horas

mfhi $t1 
li $t0, 60 
div $t1, $t0 
mflo $s1              #s1 = Minute
mfhi $s2              #s2 = Second

la $s3, tempo
sw $s0, 12($s3)
sw $s1, 16($s3)
sw $s2, 20($s3)

move $a0, $t3 # menos significante
move $a1, $t4 # mais significante

li $a2, 2
jal div64x16

move $s6, $a0
move $s7, $a1

jal pegar_data

#Print the time
jal imprimir_data_hora

j main


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
   li $t0, 0
   bge $s0,  $t0, horasCertas
   addi $s0, $s0, 24
   j tratar_horas
   
horasCertas:
   jr $ra
         
         
#sub

pegar_data:

subu $sp, $sp, 4   # Reserva espa�o na pilha
sw $ra, 0($sp)     # Salva o endere�o de retorno

li $t0, 1 #m�s
li $t1, 1970 #ano

loop_data:
    	andi $t2, $t1, 3  # Verifica os dois �ltimos bits de $t0
   	beq $t2, $zero, ano_bissexto  # Se for 0, o n�mero � divis�vel por 4

ano_normal:
	#janeiro
	li $a2, 31
	jal subtrair
	
	li $t0, 2
	
	#fevereiro
	li $a2, 28
	jal subtrair
	
	li $t0, 3
	
	#mar�o
	li $a2, 31
	jal subtrair
	
	li $t0, 4
	
	#abril
	li $a2, 30
	jal subtrair
	
	li $t0, 5
	
	#maio
	li $a2, 31
	jal subtrair
	
	li $t0, 6
	
	#junho
	li $a2, 30
	jal subtrair
	
	li $t0, 7
	
	#julho
	li $a2, 31
	jal subtrair
	
	li $t0, 8
	
	#agosto
	li $a2, 31
	jal subtrair
	
	li $t0, 9
	
	#setembo
	li $a2, 30
	jal subtrair
	
	li $t0, 10
	
	#outubro
	li $a2, 31
	jal subtrair
	
	li $t0, 11
	
	#novembro
	li $a2, 30
	jal subtrair
	
	li $t0, 12
	
	#dezembro
	li $a2, 31
	jal subtrair
	
	li $t0, 1
	addi $t1, $t1, 1
	
	j loop_data
ano_bissexto:
	#janeiro
	li $a2, 31
	jal subtrair
	
	li $t0, 2
	
	#fevereiro
	li $a2, 29
	jal subtrair
	
	li $t0, 3
	
	#mar�o
	li $a2, 31
	jal subtrair
	
	li $t0, 4
	
	#abril
	li $a2, 30
	jal subtrair
	
	li $t0, 5
	
	#maio
	li $a2, 31
	jal subtrair
	
	li $t0, 6
	
	#junho
	li $a2, 30
	jal subtrair
	
	li $t0, 7
	
	#julho
	li $a2, 31
	jal subtrair
	
	li $t0, 8
	
	#agosto
	li $a2, 31
	jal subtrair
	
	li $t0, 9
	
	#setembo
	li $a2, 30
	jal subtrair
	
	li $t0, 10
	
	#outubro
	li $a2, 31
	jal subtrair
	
	li $t0, 11
	
	#novembro
	li $a2, 30
	jal subtrair
	
	li $t0, 12
	
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
	sub $s0, $s0, 1
	jr $ra
finalizar:
	la $s3, tempo
	sw $t1, 0($s3)
	sw $t0, 4($s3)
	sw $a0, 8($s3)
    	lw $ra, 0($sp)     # Restaura o endere�o de retorno
    	addu $sp, $sp, 4   # Libera espa�o na pilha
    	jr $ra             # Retorna para quem chamou   
    		
imprimir_data_hora:
	
	la $t0, tempo    # Carrega o endere�o base de 'tempo'
	
	# Mostra a data
	li $v0, 4
	la $a0, msg_data
	syscall
	
	lw $a0, 8($t0)  # Carrega o ano
    	li $v0, 1
    	syscall
	
	li $v0, 4
	la $a0, msg_barra
	syscall
	
	lw $a0, 4($t0)  # Carrega o mês
    	li $v0, 1
    	syscall
	
	li $v0, 4
	la $a0, msg_barra
	syscall
	
	lw $a0, 0($t0)  # Carrega o dia
    	li $v0, 1
    	syscall
	
    	li $v0, 4
	la $a0, msg_quebra_de_linha
	syscall
	
	# Mostra as horas
	
	li $v0, 4
	la $a0, msg_hora
	syscall
	
	lw $a0, 12($t0)  # Carrega a hora
    	li $v0, 1
    	syscall
	
	li $v0, 4
	la $a0, msg_dois_pontos
	syscall
	
	lw $a0, 16($t0)  # Carrega o minuto
    	li $v0, 1
    	syscall
	
	li $v0, 4
	la $a0, msg_dois_pontos
	syscall
	
	lw $a0, 20($t0)  # Carrega o segundo
    	li $v0, 1
    	syscall
    	
    	li $v0, 4
	la $a0, msg_quebra_de_linha
	syscall
    	
    	jr $ra
	
ajustar_data:
	li $v0, 4
    	la $a0, msg_em_breve
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

# ============================== ERRO E SA�?DA ==============================
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
