#This file will contain all of your rat_*() functions (and nothing
# else). As an example, we've included rat_print() below.

    .option pic0
    
    .rdata # read-only data
    
    .align  2
resultFormat:
    .asciz  "(%d/%u)\n"
    
    .text
    .align  2

    # You need to put a ".global" assembler directive for every
    # function you expect to call from outside this file. (Why doesn't
    # "resultFormat" need a ".global"?
    .global rat_print
    .global rat_mul
    .global rat_div
    .global rat_add
    .global rat_sub
    .global rat_simplify

rat_print:
    # ($a0, $a1) -> () (no output registers)
    # prints "(i/j)" on stdout, where i = $a0 and j = $a1
    addiu $sp, $sp, -4  # create space on the stack for $sp (why?)
    sw    $ra, ($sp)    # save $sp on the stack (why?)
    
    # call printf() with the appropriate format and arguments
    # (Why not do it in $a0, $a1, $a2 order?)
    move $a2, $a1    
    move $a1, $a0
    la   $a0, resultFormat
    jal  printf
    
    lw    $ra, ($sp)    # restore $sp from the stack (why?)
    addiu $sp, $sp, +4  # release the stack space used for $sp

    jr    $ra

# put your additional rat_* functions here

rat_mul:
    addi $sp, $sp, -4   #move the stac pointer down one register
    sw   $ra, 0($sp)    #storing register in the stack pointer
    mul  $v0, $a0, $a2  #multiplies numerators from rational number
    mul  $v1, $a1, $a3  #multiplies denominators from rational number
    lw   $ra, 0($sp)    #loading the value of the previous value of $ra
    addi $sp, $sp, 4    #move $sp back to origninal location 
   jal  rat_simplify
    jr   $ra

rat_div:
    addi $sp, $sp, -4   #move the stac pointer down one register
    sw   $ra, 0($sp)    #storing register in the stack pointer
    add  $t0, $0, $a2   #move $a2 numerator to temp
    add  $a2, $0, $a3   #move $a3 denominator to $a2 numerator
    add  $a3, $0, $t0   #move $a2 numerator in $a3 denominator 
    jal  rat_mul
    jal  rat_simplify
    lw   $ra, 0($sp)    #loading the value of the previous value of $ra
    addi $sp, $sp, 4    #move $sp back to origninal location
    jr   $ra            


rat_add:
    addi $sp, $sp, -4 
    sw   $ra, 0($sp)
    bne $a1, $a3, else  #if $a1 != $a3, branch to else
    add $v0, $a0, $a2   #add numerators
    add $v1, $a1, $a3   #add denominators
    jal rat_simplify
    jr  $ra
    
else:
    jal  gcd            #use the function to find the greatest common denominator
    move $t0, $v1       #move demoninator to $t0 
    mul  $t1, $t0, $a3  #mulitply denominator and second numerator
    mul  $t1, $t0, $a1  #mulitple denominator and (den * 2nd num)
    div  $t1, $t1, $t0  #divide (new denominator) / gcd denominator

    div  $t2, $t0, $a3  #divide the gcd denominator / 2nd denominator
    mul  $t2, $a0, $t2  #multiply first numerator * (gcd / 2nd den)
    div  $t3, $t0, $a3  #divide gcd / 2nd denominator 
    mul  $t3, $a2, $t3  #multiply 2nd numerator * (gcd / 2nd den)

    add  $v1, $t2, $a3  #add (gcd / 2nd den) + 2nd den
    add  $v0, $0, $t1   #add 0 + (new den / gcd) 
    
    lw   $ra, 4($sp)
    addi $sp, $sp, 8 
    jr   $ra

rat_sub:
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    bne  $a1, $a3, else1 #if den1 is not equal to den 2
    sub  $v0, $a0, $a2  #subtract num1 - num 2
    sub  $v0, $a1, $a3  #subtract den 1 - den 2
    jal  rat_simplify
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jal  rat_simplify
    jr   $ra

else1:
    mul $t0, $a0, $a3   #multiply num1 by den2
    mul $t1, $a2, $a1   #multiply num2 by den1
    add $v0, $t0, $t1   #add (num1 *den2) + (num2 * den1)
    mul $v1, $a1, $a3   #multiply den1 by den2 

    lw   $ra, 0($sp)
    addi $sp, $sp, 4
    jr   $ra

rat_simplify:
    addi $sp, $sp,-12
    sw   $ra, 8($sp)
    mul  $t0, $a0, $a1  #multiply the numerator and demoninator to $t0

forloop: 
    bgt  $t0, 1, exit    # (den * num) > 1
    sub  $t0, $t0, 1     # subtract i--
    bgt  $v0, $v1, else3 #if numerator > denoinatory

else3:
   div   $v0, $v0, $v1    #divide numerator / denominator 
    
    lw   $ra, 8($sp)
    addi $sp, $sp, 12 
    jr $ra
exit:    
