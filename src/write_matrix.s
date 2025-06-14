.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -20
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)


    mv t0 a0 
    mv s1 a1
    mv s2 a2
    mv s3 a3

    # fopen
    mv a0 t0 
    addi a1 x0 1

    jal fopen

    addi t0 x0 -1
    beq a0 t0 Exception_fopen
    mv s0 a0 # store file descriptor

    #fwrite rows
    ## malloc memory

    addi a0 x0 4
    jal malloc
    mv t0 a0 

    sw s2 0(t0)

    ## fwrite rows
    mv a0 s0 
    mv a1 t0
    addi a2 x0 1
    addi a3 x0 4

    jal fwrite

    addi t0 x0 1
    bne a0 t0 Exception_fwrite

    #fwrite columns
    ## malloc memory

    addi a0 x0 4
    jal malloc
    mv t0 a0 

    sw s3 0(t0)

    ## fwrite rows
    mv a0 s0 
    mv a1 t0
    addi a2 x0 1
    addi a3 x0 4

    jal fwrite

    addi t0 x0 1
    bne a0 t0 Exception_fwrite

    # fwrite matrix

    mv a0 s0
    mv a1 s1
    mul a2 s2 s3
    addi a3 x0 4

    jal fwrite

    mul t0 s2 s3
    bne t0 a0 Exception_fwrite

    # fclose
    mv a0 s0

    jal fclose

    bne a0 x0 Exception_fclose


    # Epilogue

    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    addi sp sp 20

    jr ra

Exception_fopen:
    li a0 27
    j exit
Exception_fwrite:
    li a0 30
    j exit
Exception_fclose:
    li a0 28
    j exit
