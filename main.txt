    .option pic0

    .rdata
    .align 2
    
outputFormat:
    .asciz "gcd(%d,%d) = %d\n"

numerator:
    .align 2
    .word 1
    
denominator:    
    .align 2
    .word 2
    
    .text
    .align 2

    # This is so that the operating system will "see" the "main" label
    # as the name of the first function to call.
    .global main

main:
    # Here is an example of a call to rat_print()

    la      $t0,numerator
    lw      $a0,($t0)
    la      $t0,denominator
    lw      $a1,($t0)
    jal     rat_print

    # Here is an example of a call to gcd()

    li      $s0,23412
    li      $s1,42352
    
    move    $a0,$s0
    move    $a1,$s1
    jal     gcd

    # and a print() call for the result

    la      $a0,outputFormat
    move    $a1,$s0
    move    $a2,$s1
    move    $a3,$v0  # gcd result
    jal     printf

    # ------ Test code begins here.
    li      $a0, 4
    li      $a1, 2
    li      $a2, 6
    li      $a3, 9

    move    $a0, $v0
    move    $a1, $v1
    jal     rat_mul
    jal     rat_print

    move    $a0, $v0
    move    $a1, $v1
    jal     rat_div
    jal     rat_print

    move    $a0, $v0
    move    $a1, $v1
    jal     rat_add
    jal     rat_print

    move    $a0, $v0
    move    $a1, $v1
    jal rat_sub
    jal rat_print

    # Put some test code here for your rat_* routines. (The instructor
    # will have a different test "main", but you'll want to test your
    # code for yourself.)
    
    # If you wanted to test rat_mul(), say, you would do something
    # like this (double-commented out):

    ## # call rat_mul() to compute a test result
    # li      $a0,1
    # li      $a1,2
    # li      $a2,2
    # li      $a3,7
    # jal     rat_mul # i.e. rat_mul(1/2, 2/7)
    ## # result:
    ## # $v0: numerator
    ## # $v1: denominator
    
    ## # call rat_print() to print the result on standard output
    # move    $a0, $v0  # move result numerator to $a0
    # move    $a1, $v1  # move result denominator to $a1
    # jal     rat_print # i.e. rat_mul(34/19, 4/20)

    # in this case, the result should be "(1/7)"

    # ------ Test code ends here.

    # li      $a0,0
    jal     exit
