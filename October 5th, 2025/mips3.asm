.data
.text
.globl main

main:
    li   $a0, 5         
    jal  factorial     # Jump to factorial
    move $a0, $v0
    li   $v0, 1         
    syscall
    li   $a0, 10
    li   $v0, 11       
    syscall

    li   $v0, 10
    syscall


factorial:
    addi $sp, $sp, -8  # allocate 8 bytes for the stack
    sw   $ra, 4($sp)   # [SP+4] = return address
    sw   $a0, 0($sp)   # [SP+0] = argument n

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

# Example: Factorial(5) call chain
# factorial(5) top -> n=5, ra=main
# factorial(4) top -> [n=4, ra=fact(5)]
# factorial(3) top -> [n=3, ra=fact(4)]
# factorial(2) top -> [n=2, ra=fact(3)]
# factorial(1) top-> [n=1, ra=fact(2)]

factorial_base:
    li   $v0, 1
    lw   $ra, 4($sp)
    addi $sp, $sp, 8
    jr   $ra