.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:


    addi t0 x0 5
    bne a0 t0 Exception_argc

    # Prologue
    addi sp sp -48
    sw ra 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)

    mv s1 a1
    mv s2 a2

    # Read pretrained m0
    addi t0 x0 8
    mv a0 t0

    jal malloc

    beq a0 x0 Exception_malloc
    mv s3 a0 # store  rows and columns

    lw a0 4(s1)
    mv a1 s3 # rows
    addi t0 s3 4
    mv a2 t0

    jal read_matrix

    mv s4 a0 #store m0 matrix

    # Read pretrained m1
    addi t0 x0 8
    mv a0 t0

    jal malloc

    beq a0 x0 Exception_malloc
    mv s5 a0 # store  rows and columns

    lw a0 8(s1)
    mv a1 s5 # rows
    addi t0 s5 4
    mv a2 t0

    jal read_matrix

    mv s6 a0 #store m1 matrix

    # lw a0 0(s5)
    # jal print_int
    # li t0 '\n'
    # mv a0 t0
    # jal print_char
    # lw a0 4(s5)
    # jal print_int

    # Read input matrix
    addi t0 x0 8
    mv a0 t0

    jal malloc

    beq a0 x0 Exception_malloc
    mv s7 a0 # store  rows and columns


    lw a0 12(s1)
    mv a1 s7 # rows
    addi t0 s7 4
    mv a2 t0

    jal read_matrix
    mv s8 a0 #store input matrix

    # Compute h = matmul(m0, input)
    lw t0 0(s3)
    lw t1 4(s7)
    mul t0 t0 t1
    slli t0 t0 2
    mv a0 t0

    jal malloc

    beq a0 x0 Exception_malloc
    mv s9 a0 # store h

    mv a0 s4
    lw a1 0(s3)
    lw a2 4(s3)
    mv a3 s8
    lw a4 0(s7)
    lw a5 4(s7)
    mv a6 s9

    jal matmul


    # Compute h = relu(h)
    mv a0 s9
    lw t0 0(s3)
    lw t1 4(s7)
    mul t0 t0 t1
    mv a1 t0

    jal relu

    # Compute o = matmul(m1, h)
    lw t0 0(s5)
    lw t1 4(s7)
    mul t0 t0 t1
    slli t0 t0 2
    mv a0 t0

    jal malloc

    beq a0 x0 Exception_malloc
    mv s10 a0 # store o   

    mv a0 s6
    lw a1 0(s5)
    lw a2 4(s5)
    mv a3 s9
    lw a4 0(s3) # the row of m0
    lw a5 4(s7) 
    mv a6 s10

    jal matmul

    # Write output matrix o
    lw a0 16(s1)
    mv a1 s10
    lw a2 0(s5)
    lw a3 4(s7)

    jal write_matrix

    # Compute and return argmax(o)
    mv a0 s10
    lw t0 0(s5) 
    lw t1 4(s7)
    mul a1 t0 t1

    jal argmax

    mv s11 a0

    # If enabled, print argmax(o) and newline

    addi t0 x0 1
    beq t0 s2 End
    mv a0 s11
    jal print_int


    li t0 '\n'
    mv a0 t0
    jal print_char

End:
    # free memory

    mv a0 s3 # rows and columns of m0
    jal free

    mv a0 s4 # matrix of m0
    jal free

    mv a0 s5 # rows and columns of m1
    jal free

    mv a0 s6 # matrix of m1
    jal free

    mv a0 s7 # rows and columns of input
    jal free

    mv a0 s8 # matrix of input
    jal free

    mv a0 s9 # matrix of h
    jal free

    mv a0 s10 # matrix of o
    jal free 

    mv a0 s11


    lw ra 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    addi sp sp 48
    jr ra

Exception_malloc:
    li a0 26
    j exit
Exception_argc:
    li a0 31
    j exit
