.data
.text
.globl main

main:
    li   $a0, 5         
    jal  factorial     
    move $a0, $v0
    li   $v0, 1         
    syscall
    li   $a0, 10
    li   $v0, 11       
    syscall

    li   $v0, 10
    syscall


factorial:
    addi $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $a0, 0($sp)

    li   $t0, 1
    ble  $a0, $t0, factorial_base   
    addi $a0, $a0, -1
    jal  factorial                  

    lw   $t1, 0($sp)                 
    mult $v0, $t1                    
    mflo $v0                        

    lw   $ra, 4($sp)
    addi $sp, $sp, 8
    jr   $ra

factorial_base:
    li   $v0, 1
    lw   $ra, 4($sp)
    addi $sp, $sp, 8
    jr   $ra
