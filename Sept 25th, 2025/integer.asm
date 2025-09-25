        .data
array:  .word 5, 12, 7, 3, 9, 6, 15, 8, 4, 10   
sum:    .word 0                                 

        .text
        .globl main
main:
        la   $t0, array        
        li   $t1, 10           
        li   $t2, 0           
        li   $t3, 0            

loop:
        beq  $t2, $t1, done    

        lw   $t4, 0($t0)       
        add  $t3, $t3, $t4     

        addi $t0, $t0, 4       
        addi $t2, $t2, 1      
        j    loop

done:
        sw   $t3, sum         


        li   $v0, 1           
        move $a0, $t3         
        syscall


        li   $v0, 11           
        li   $a0, 10           
        syscall


        li   $v0, 10           
        syscall
