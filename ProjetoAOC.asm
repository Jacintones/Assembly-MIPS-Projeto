.data
# Buffer para entrada de dados
input_buffer: .space 256

# Estrutura para armazenar os livros
espaco: .space 1024           # Espaço para até 10 livros 
livro_tamanho: .word 100      # Tamanho fixo para cada livro (título + autor + ISBN)

# Mensagens
msg_titulo: .asciiz "Digite o titulo do livro: "
msg_autor: .asciiz "Digite o autor do livro: "
msg_isbn: .asciiz "Digite o ISBN do livro: "
msg_cadastrado: .asciiz "Livro cadastrado com sucesso!\n"
msg_error: .asciiz "Erro: espaco cheio!\n"
msg_opcao: .asciiz "Escolha uma opcao: (1) Cadastrar Livro, (2) Cadastrar usuário, (3) Sair: "

.text	
# Imprime o menu inicial
    li $v0, 4                 
    la $a0, msg_opcao
    syscall

# Lê a opção do usuário   
    li $v0, 5                 
    syscall
    move $t0, $v0 # Guarda a opção em $t0     
    
#Verifica qual foi a opção do usuário
    beq $t0, 1, cadastrar_livro  # Opção 1: Cadastrar Livro
    beq $t0, 2, cadastrar_usuario # Opção 2: Cadastrar usuário
    beq $t0, 3, sair             # Opção 3: Sair
    
    

   