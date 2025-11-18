#Gabriel Pereira Lima
#1° requisito feito 9 de novembro as 11:30
#2° requisito feito 9 de novembro as 16:50
#3° requisito feito 14 de novembro as 14:30
.data
    numero:.asciiz "Digite um numero inteiro para conversao de base: "
    numero_float:.asciiz "\nDigite um numero real (float) para analise IEEE 754: "
    n:.asciiz "\n"
    binario:.asciiz "Binario: "
    octal:.asciiz "Octal: "
    hexa:.asciiz "Hexadecimal: "
    ca2:.asciiz "Complemento a 2: "
    
    float_header: .asciiz "\n--- Float 32-bit ---\n"
    sinal_msg: .asciiz "Sinal: "
    expoentereal: .asciiz "Expoente Real: "
    expoentemsg: .asciiz "Expoente com Vies: "
    fracao_msg: .asciiz "Fracao: "

.text
.globl main
main:
    #recebe o numero inteiro
    li $v0, 4
    la $a0, numero
    syscall
    li $v0, 5
    syscall
    
    move $s1, $v0
    move $s0, $sp
    
    #binario
    move $t0, $s1
    li $t1, 2
    jal divisao
    li $v0, 4
    la $a0, binario
    syscall
    jal print
    li $v0, 4
    la $a0, n
    syscall

    #octal
    move $t0, $s1
    li $t1, 8
    jal divisao
    li $v0, 4
    la $a0, octal
    syscall
    jal print
    li $v0, 4
    la $a0, n
    syscall

    #hexa
    move $t0, $s1
    li $t1, 16
    jal divisao
    li $v0, 4
    la $a0, hexa
    syscall
    jal printhexa
    li $v0, 4
    la $a0, n
    syscall
    
    #Complemento
    li $v0, 4
    la $a0, ca2
    syscall
    jal printca2
    li $v0, 4
    la $a0, n
    syscall
    
    #recebe o numero float
    li $v0, 4
    la $a0, numero_float
    syscall
    
    li $v0, 6 
    syscall 
    
    jal analisa_float 
    
    j fim
    
divisao:
    div $t0, $t1
    mflo $t2
    mfhi $t3
    
    addi $sp, $sp, -4
    sw $t3, 0($sp)
    
    move $t0, $t2 
    bgtz $t0, divisao

    jr $ra

print:
    beq $sp, $s0, fimprint
    
    lw $a0, 0($sp)
    addi $sp, $sp, 4
    
    li $v0, 1
    syscall
    
    b print

fimprint:
    jr $ra

printhexa:
    beq $sp, $s0, fimhexa

    lw $t5, 0($sp)
    addi $sp, $sp, 4
    
    ble $t5, 9, digito
    
    addi $a0, $t5, -10
    addi $a0, $a0, 'A'
    li $v0, 11
    syscall
    b printhexa

digito:
    move $a0, $t5
    li $v0, 1
    syscall
    b printhexa

fimhexa:
    jr $ra

printca2:
    move $t0, $s1
    sll $t0, $t0, 16
    li $t1, 32

loopca2:
    beq $t1, $zero, fimca2
    srl $a0, $t0, 31 
    li $v0, 1
    syscall
    sll $t0, $t0, 1
    addi $t1, $t1, -1
    b loopca2
    
fimca2:
    jr $ra

analisa_float:
    li $v0, 4
    la $a0, float_header
    syscall
    
    mfc1 $t0, $f0 
    
    # Sinal
    li $v0, 4
    la $a0, sinal_msg
    syscall
    srl $a0, $t0, 31 
    li $v0, 1 
    syscall
    li $v0, 4
    la $a0, n
    syscall

    # Expoente com Viés
    li $v0, 4
    la $a0, expoentemsg
    syscall
    srl $t1, $t0, 23 
    andi $a0, $t1, 0xFF
    li $v0, 1 
    syscall
    
    move $t2, $a0
    li $v0, 4
    la $a0, n
    syscall

    # Expoente Real
    li $v0, 4
    la $a0, expoentereal
    syscall
    addi $a0, $t2, -127
    li $v0, 1 
    syscall
    li $v0, 4
    la $a0, n
    syscall

    # Fração
    li $v0, 4
    la $a0, fracao_msg
    syscall
    
    andi $t4, $t0, 0x7FFFFF
    li $t5, 23
    
    fracaoloop:
        beq $t5, $zero, fimloop
        
        srl $a0, $t4, 22 
        andi $a0, $a0, 1 
        
        li $v0, 1
        syscall
        
        sll $t4, $t4, 1
        addi $t5, $t5, -1
        
        j fracaoloop
    
    fimloop:
    li $v0, 4
    la $a0, n
    syscall
    
    jr $ra 

fim:
    li $v0, 10
    syscall
