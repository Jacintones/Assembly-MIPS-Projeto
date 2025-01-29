.macro salvar_dado
    li $v0, 8                  # Lê a entrada do usuário
    la $a0, input_buffer
    li $a1, 100                # Tamanho máximo da entrada
    syscall

    la $t5, input_buffer       # Move os dados para o buffer do livro ou usuário
    sw $t5, 0($t1)
.end_macro

.data
# Buffer para entrada de dados
input_buffer: .space 256

# Estrutura para armazenar os livros e usuários
biblioteca: .space 1024           
usuarios: .space 512          

# Mensagens
msg_titulo: .asciiz "Digite o título do livro: "
msg_autor: .asciiz "Digite o autor do livro: "
msg_isbn: .asciiz "Digite o ISBN do livro: "
msg_nome: .asciiz "Digite o nome do usuário: "
msg_email: .asciiz "Digite o email do usuário: "
msg_cadastrado: .asciiz "Cadastro realizado com sucesso!\n"
msg_error: .asciiz "Erro: espaço cheio!\n"
msg_opcao: .asciiz "Escolha uma opção: (1) Cadastrar Livro, (2) Cadastrar Usuário, (3) Sair: "

.text
.globl main

main:
    # Imprime o menu inicial
    li $v0, 4
    la $a0, msg_opcao
    syscall

    # Lê a opção do usuário
    li $v0, 5
    syscall
    move $t0, $v0  # Guarda a opção em $t0

    # Verifica a opção do usuário
    beq $t0, 1, cadastrar_livro  # Opção 1: Cadastrar Livro
    beq $t0, 2, cadastrar_usuario  # Opção 2: Cadastrar Usuário
    beq $t0, 3, sair  # Opção 3: Sair
    j main  # Volta para o menu se a opção for inválida

# ============================== CADASTRO DE LIVROS ==============================
cadastrar_livro:
    # Calcular o próximo espaço disponível na biblioteca
    la $t1, biblioteca
    li $t2, 0  # Índice para livros

    loop_biblioteca:
        lb $t3, 0($t1)  # Verifica se há espaço
        beqz $t3, inserir_livro  # Se espaço vazio, cadastrar
        addi $t1, $t1, 100  # Avança para o próximo espaço (tamanho fixo)
        addi $t2, $t2, 1  # Incrementa índice
        li $t4, 10  # Máximo de 10 livros
        bge $t2, $t4, espaco_cheio
        j loop_biblioteca

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

    # Mensagem de sucesso
    li $v0, 4
    la $a0, msg_cadastrado
    syscall

    j main  # Retorna ao menu principal

# ============================== CADASTRO DE USUÁRIOS ==============================
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

    # Salvar email
    li $v0, 4
    la $a0, msg_email
    syscall
    salvar_dado
    sw $t5, 4($t1)

    # Mensagem de sucesso
    li $v0, 4
    la $a0, msg_cadastrado
    syscall

    j main  # Retorna ao menu principal

# ============================== ERRO E SAÍDA ==============================
espaco_cheio:
    li $v0, 4
    la $a0, msg_error
    syscall
    j main  # Retorna ao menu principal

sair:
    li $v0, 10  # Finaliza o programa
    syscall
