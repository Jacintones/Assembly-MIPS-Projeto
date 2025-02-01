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

.macro ler_string
    li $v0, 8                  # Lê a entrada do usuário
    la $a0, input_buffer
    li $a1, 100                # Tamanho máximo da entrada
    syscall

    la $t7, input_buffer       
    lb $t6, 0($t7)
    beq $t6, 10, campo_obrigatorio
    la $t5, input_buffer       # Coloca o endereço do buffer em $t5
.end_macro


.macro imprimir_shell
    # Imprime a emnsagem do shell
    li $v0, 4
    la $a0, msg_shell
    syscall
.end_macro

.data
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
msg_isbn_emprestimo: .asciiz "Digite o isbn do livro: "
msg_livro_nao_encontrado: .asciiz "Livro não encontrado!"
msg_emprestimo_realizado: .asciiz "Empréstimo realizado com sucesso!"
msg_sem_exemplares: .asciiz "Livro sem exemplares!"

# Mensagens de data e hora
msg_data: .asciiz "Data: "
msg_hora: .asciiz "Hora: "
msg_barra: .asciiz "/"
msg_dois_pontos: .asciiz ":"
msg_quebra_de_linha: .asciiz "\n"

# Mensagem temporaria de depuração
msg_em_breve: .asciiz "Ainda não implementado.\n"

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
    #beq $t0, 11, registrar_devolucao  # Opção 11: Registrar Devolução
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
    li $t2, 0  # Índice para livros

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

# ============================== USUÁRIOS ==============================
cadastrar_usuario:
    # Calcular o próximo espaço disponível em usuários
    la $t1, usuarios
    li $t2, 0  # Índice para usuários

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
    # Exibe mensagem solicitando o ISBN para empréstimo
    li $v0, 4
    la $a0, msg_isbn_emprestimo
    syscall

    # Lê o ISBN digitado pelo usuário usando a macro ler_string.
    # O endereço da string digitada será colocado em $t5.
    ler_string
    addu $a2, $t5, $zero       # $a2 <- ISBN digitado pelo usuário

    # Inicializa ponteiro para o acervo e índice do livro
    la $t1, acervo            # $t1 aponta para o início do acervo
    li $t2, 0                 # Índice do livro (0 até 9)

busca_emprestimo:
    li $t8, 10                # Número máximo de livros = 10
    bge $t2, $t8, livro_nao_encontrado

    # Carrega o endereço do ISBN armazenado para o livro atual.
    # Supondo que no cadastro do livro, o ISBN foi armazenado no offset 8.
    lw $t4, 8($t1)            # $t4 <- ISBN armazenado no livro atual

    # Se o campo ISBN estiver vazio (zero), pula para o próximo registro.
    beqz $t4, proximo_livro

    # Compara o ISBN armazenado (em $t4) com o digitado (em $a2).
    addu $a0, $t4, $zero      # $a0 <- endereço do ISBN armazenado
    addu $a1, $a2, $zero      # $a1 <- endereço do ISBN digitado
    jal string_compare        # Retorna 0 em $v0 se forem iguais

    beq $v0, $zero, livro_encontrado  # Se iguais, encontrou o livro

proximo_livro:
    addi $t1, $t1, 100        # Avança para o próximo livro (100 bytes por livro)
    addi $t2, $t2, 1          # Incrementa índice
    j busca_emprestimo

livro_nao_encontrado:
    li $v0, 4
    la $a0, msg_livro_nao_encontrado
    syscall
    j main

livro_encontrado:
    # Verifica se há exemplares disponíveis
    # Supondo que a quantidade esteja armazenada no offset 12 do registro.
    lw $t7, 12($t1)           # $t7 <- quantidade disponível
    blez $t7, livro_sem_exemplares

    # Decrementa a quantidade disponível e atualiza o acervo
    addi $t7, $t7, -1
    sw $t7, 12($t1)

    # Exibe mensagem de empréstimo realizado com sucesso
    li $v0, 4
    la $a0, msg_emprestimo_realizado
    syscall
    j main

livro_sem_exemplares:
    li $v0, 4
    la $a0, msg_sem_exemplares
    syscall
    j main
    	
# ============================== DATA_HORA ==============================
data_hora:
	# Chama o serviço 30 para obter a data e a hora atual
	li $v0, 30   # Chama o serviço 30 para obter data e hora
	syscall
    	
    	move $t2, $a0  # Ano
	move $t3, $a1  # Mês
	move $t4, $a2  # Dia
	move $t5, $a3  # Hora
	move $t6, $t0  # Minuto
	move $t7, $t1  # Segundo
	
	li $v0, 4   # Chama o serviço 30 para obter data e hora
	la $a0, msg_quebra_de_linha
	syscall
	
	la $a0, msg_data
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
    	
    	li $v0, 4   # Chama o serviço 30 para obter data e hora
	la $a0, msg_quebra_de_linha
	syscall
    	
    	j main
ajustar_data:
	li $v0, 4
    	la $a0, msg_em_breve
    	syscall
    	j main

# ============================== DADOS ==============================
# string_compare:
#   Compara byte a byte as strings apontadas por $a0 e $a1.
#   Retorna $v0 = 0 se forem iguais.
string_compare:
    lb $t0, 0($a0)       # Carrega caractere da primeira string
    lb $t1, 0($a1)       # Carrega caractere da segunda string
    bne $t0, $t1, not_equal
    beqz $t0, equal      # Se $t0 == 0, chegou ao fim e são iguais
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    j string_compare
not_equal:
    # Retorna um valor diferente de zero (pode ser a diferença dos caracteres)
    sub $v0, $t0, $t1
    jr $ra
equal:
    li $v0, 0
    jr $ra


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

# ============================== ERRO E SAÍDA ==============================
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
