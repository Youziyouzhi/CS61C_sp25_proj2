.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:


    # step1: fopen + test fopen fail
    # step2: fread + test fread fail
    # step3: malloc + test malloc fail
    # step4：refread + test fread fail 
    # step4: fclose + test fclose fail

    # Prologue
    addi sp sp -20
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)

    # store Arguments
    mv t0 a0
    mv s0 a1 # number of rows
    mv s1 a2 # number of columns

    # fopen
    mv a0 t0
    mv a1 x0

    jal fopen

    addi t1 x0 -1
    beq a0 t1 exception_fopen
    mv s2 a0 # store the file descriptor 

    # fread rows
    mv a0 s2

    mv a1 s0
    addi t0 x0 4
    mv a2 t0

    addi sp sp -4
    sw t0 0(sp)

    jal fread

    lw t0 0(sp)
    addi sp sp 4

    bne a0 t0 exception_fread 

    # fread columns
    mv a0 s2

    mv a1 s1
    addi t0 x0 4
    mv a2 t0

    addi sp sp -4
    sw t0 0(sp)

    jal fread

    lw t0 0(sp)
    addi sp sp 4

    bne a0 t0 exception_fread 

    # malloc 

    mul t0 s0 s1 
    slli t0 t0 2
    mv a0 t0

    jal malloc

    beq a0 x0 exception_malloc
    mv s3 a0 # store the first address of the matrix

    # fread matrix

    mv a0 s2
    mv a1 s3

    lw t0 0(s0)
    lw t1 0(s1)
    mul t0 t0 t1
    slli t0 t0 2

    mv a2 t0

    addi sp sp -4
    sw t0 0(sp)

    jal fread

    lw t0 0(sp)
    addi sp sp 4

    bne a0 t0 exception_malloc

    # fclose

    mv a0 s2

    jal fclose

    bne a0 x0 exception_fclose

    mv a0 s3

    # Epilogue

    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    addi sp sp 20

    jr ra

exception_malloc:
    li a0 26
    j exit
exception_fopen:
    li a0 27
    j exit
exception_fread:
    li a0 29
    j exit
exception_fclose:
    li a0 28
    j exit