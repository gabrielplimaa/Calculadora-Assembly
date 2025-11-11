.data
    numero:.asciiz "Digite um numero: "
    n:.asciiz "\n"
    binario:.asciiz "Binario: "
    octal:.asciiz "Octal: "
    hexa:.asciiz "Hexadecimal: "
    ca2:.asciiz "Complemento a 2: "

.text
.globl main
main:
    #recebe o numero
    li $v0, 4
    la $a0, numero
    syscall
    li $v0, 5
    syscall
    
    #binario
    move $s1, $v0
    move $s0, $sp
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

printca2:
    move $t0, $s1
    sll $t0, $t0, 16
    li $t1, 16

loopca2:
    beq $t1, $zero, fimca2
    srl $a0, $t0, 31 
    li $v0, 1
    syscall
    sll $t0, $t0, 1
    addi $t1, $t1, -1
    b loopca2
    
digito:
    move $a0, $t5
    li $v0, 1
    syscall
    b printhexa

fimhexa:
    jr $ra
fimca2:
    jr $ra
fim:
