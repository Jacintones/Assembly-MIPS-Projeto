#################### DOCUMENTACAO ####################
# reg $s0 -> Endereco para o acervo de livros
# reg $s1 -> Endereco para a lista com os usuarios
# reg $s2 -> Endereco para a lista de emprestimos
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
	msg_dia: .asciiz "Dia: "
	msg_mes: .asciiz "M�s: "
	msg_ano: .asciiz "Ano: "
	msg_minuto: .asciiz "Minuto: "
	msg_segundo: .asciiz "Segundo: "
	msg_pedir_isbn:  .asciiz "Digite o ISBN do livro a ser removido: "
	msg_sucesso:  .asciiz "Livro removido com sucesso!\n"
	msg_debug: .asciiz "Conteúdo do arquivo carregado:\n"
	filename: .asciiz "C:\Users\thiag\Documents\assembly\Assembly-MIPS-Projeto\acervo.txt"

	# Mensagem temporaria de depuração
	msg_em_breve: .asciiz "Ainda não implementado.\n"
	msg_erro_arquivo: .asciiz "Erro ao abrir o arquivo!\n"
	
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
    beq $t0, 1, print_data_hora  # Opção 1: Ver Data e Hora
    beq $t0, 2, inserir_livro  # Opção 2: Cadastrar Livro
    beq $t0, 3, listar_livros  # Opção 3: Listar Livros
    beq $t0, 4, inserir_usuarios  # Opção 4: Cadastrar Usuário
    beq $t0, 5, registrar_emprestimo  # Opção 5: Registrar Empréstimo
    beq $t0, 6, gerar_relatorio  # Opção 6: Gerar Relatório
    beq $t0, 7, remover_livro  # Opção 7: Remover Livro
    beq $t0, 9, salvar_dados  # Opção 9: Salvar Dados
    beq $t0, 10, ajustar_data  # Opção 10: Ajustar Data e Hora
    beq $t0, 11, registrar_devolucao  # Opção 11: Registrar Devolução
    beq $t0, 12, sair  # Opção 12: Sair    
    beq $t0, 13, truncate_livros 
    
    # Mensagem de opção invalida
    li $v0, 4
    la $a0, msg_error
    syscall
    
    j main  # Volta para o menu se a opção for inválida


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
	

# ============================== USUÁRIOS ==============================
inserir_usuarios:
    # Encontrar posição vazia no acervo
    la $t1, conteudo_contas_usuarios  # Início do armazenamento de usuários
    li $t2, 0       # Contador de usuários
    
loop_usuarios:
    lb $t3, 0($t1)  # Verifica se o primeiro byte é 0 (espaço vazio)
    beqz $t3, inserir_dados_usuarios  # Se for 0, encontrou espaço livre

    addi $t1, $t1, 192   # Avança para o próximo usuario
    addi $t2, $t2, 1    # Incrementa contador de usuarios
    
    li $t4, 10          # Máximo de 10 usuarios
    blt $t2, $t4, loop_usuarios  
    j espaco_cheio      # Se chegou no limite, sai   
    
inserir_dados_usuarios:
    # Ler e armazenar Nome (offset 0)
    li $v0, 4
    la $a0, msg_nome
    syscall
    li $v0, 8            # Syscall para ler string
    la $a0, input_buffer # Buffer de entrada
    li $a1, 64           # Tamanho máximo
    syscall
    la $t6, input_buffer
    move $t7, $t1        # Destino correto no acervo
    jal copiar_string

    # Ler e armazenar Matricula (offset 64)
    li $v0, 4
    la $a0, msg_matricula
    syscall
    li $v0, 8
    la $a0, input_buffer
    li $a1, 64
    syscall
    la $t6, input_buffer
    addi $t7, $t1, 64   
    jal copiar_string

    # Ler e armazenar Curso (offset 128)
    li $v0, 4
    la $a0, msg_curso
    syscall
    li $v0, 8
    la $a0, input_buffer
    li $a1, 64
    syscall
    la $t6, input_buffer
    addi $t7, $t1, 128  # Offset do curso
    jal copiar_string

    # Mensagem de sucesso
    li $v0, 4
    la $a0, msg_cadastrado
    syscall
 
    jal salvar_usuario_em_arquivo  # Salva no arquivo
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
lw $a2, 4($t0) #parte baixa
lw $t2, 0($t0) #parte alta

bgtu $a0, $a2, sem_underflow
subi $a1, $a1, 1
sem_underflow:
sub $a0, $a0, $a2
sub $a1, $a1, $t2

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

mfhi $t1 
li $t0, 60 
div $t1, $t0 
mflo $s1              #s1 = Minute
mfhi $s2              #s2 = Second

jal tratar_horas

add $t3, $t3, $t1

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
	# s0 = horas
	# s1 = minutos
	# s2 = segundos
	li $t1, 0

ajustar_horas_negativas:
   	bge $s0,  $zero, somar_offset
   	addi $s0, $s0, 24

somar_offset:
   	la $s3, tempo_base
	lw $t0, 20($s3)
	add $s2, $s2, $t0
	
	lw $t0, 16($s3)
	add $s1, $s1, $t0
	
	lw $t0, 12($s3)
	add $s0, $s0, $t0
	
ajustar_segundos:
	li $t0, 60
	blt $s2, $t0, ajustar_minutos
	sub $s2, $s2, $t0
	addi $s1, $s1, 1
	
ajustar_minutos:
	li $t0, 60
	blt $s1, $t0, ajustar_horas
	sub $s1, $s1, $t0
	addi $s0, $s0, 1
	
ajustar_horas:
	li $t0, 24
	blt $s0, $t0, horas_certas
	sub $s0, $s0, $t0
	li $t1, 1
   
horas_certas:
	jr $ra
         
         
#sub

pegar_data:

subu $sp, $sp, 4   # Reserva espa�o na pilha
sw $ra, 0($sp)     # Salva o endere�o de retorno

la $s3, tempo_base
lw $t0, 4($s3) #m�s
lw $t1, 0($s3) #ano
lw $t2, 8($s3) #dias
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
                  
#dataHora   
imprimir_data_hora:
	
	la $t0, tempo    # Carrega o endereço base de 'tempo'
	
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
    	
    	j main
	
ajustar_data:
	la $t0, tempo_base    # Carrega o endereço base de 'tempo'

	dia:
	li $v0, 4
	la $a0, msg_dia
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 8($t0)
	
	mes:
	li $v0, 4
	la $a0, msg_mes
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 4($t0)
	
	ano:
	li $v0, 4
	la $a0, msg_ano
	syscall
	
	
	li $v0, 5
	syscall
	
	sw $v0, 0($t0)
	
	horas:
	li $v0, 4
	la $a0, msg_hora
	syscall
	
	li $v0, 5
	syscall
	
	addi $v0, $v0, 3
	li $t1, 24
	div $v0, $t1
	mfhi $v0
	sw $v0, 12($t0)
	
	minutos:
	li $v0, 4
	la $a0, msg_minuto
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 16($t0)
	
	segundos:
	li $v0, 4
	la $a0, msg_segundo
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 20($t0)
	
	li $v0, 30
	syscall
	
	la $t0, milisegundos_offset
	sw $a0, 4($t0)
	sw $a1, 0($t0)
	
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
