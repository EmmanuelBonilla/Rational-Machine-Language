    # These are needed to link with glibc.
    .option pic0
    
    .text
    .globl gcd # make gcd externally linkable
    
gcd:
    move $t0, $a0
    move $t1, $a1

loop:
    # This is Euclid's algorithm.
    div     $0, $t0, $t1 # results are in `lo` and `hi` registers
    mfhi    $t2    # copy `c`, the remainder, from the `hi` register to $t2
    beq     $t2, $0, zeroRemainderFound
    move    $t0, $t1 # a = b
    move    $t1, $t2 # b = c
    j       loop

zeroRemainderFound:
    move $v0, $t1
    jr $ra
