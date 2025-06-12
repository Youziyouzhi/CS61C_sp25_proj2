.globl matmul 

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    li t0 1
    blt a1 t0 exception_38
    blt a2 t0 exception_38
    blt a4 t0 exception_38
    blt a5 t0 exception_38
    blt a2 a4 exception_38
    
    # Prologue 
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    
    mv s0 a0 # s0 -> address of the matrix m0   
    mv s1 a3 # s1 -> address of the matrix m1
    mv s4 a1 # number of the row of m0
    mv t2 a2 # number of the array m0 / m1
    mv t4 a5 # stride of the array m1   
    li t1 1 # stride of the array m0    
    li s2 0  # counter m0   

    
outer_loop_start: # loop matrix A row

    li t0 4
    mul t0 t0 s2
    mul t0 t0 t2
    add t0 t0 s0
    li s3 0 # counter m1
    
inner_loop_start: # loop matrix B column , dot and store  

    li t3 4
    mul t3 t3 s3
    add t3 t3 s1
    
    # Prolugue
    addi sp sp -28
    sw t0 0(sp)
    sw t1 4(sp)
    sw t2 8(sp)
    sw t3 12(sp)
    sw t4 16(sp)
    sw a5 20(sp)
    sw a6 24(sp)
    
    mv a0 t0
    mv a1 t3
    mv a2 t2
    mv a3 t1
    mv a4 t4
    
    jal ra dot
    
    # Epilogue
    lw t0 0(sp)
    lw t1 4(sp)
    lw t2 8(sp)
    lw t3 12(sp)
    lw t4 16(sp)    
    lw a5 20(sp)
    lw a6 24(sp)
    addi sp sp 28
    
    sw a0 0(a6) # store value
    addi a6 a6 4

    addi s3 s3 1
    bne s3 a5 inner_loop_start
    
inner_loop_end:
    addi s2 s2 1
    bne s2 s4 outer_loop_start

outer_loop_end:
    
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    
    addi sp sp 24
    jr ra
    
exception_38:
    li a0 38
    jal x0 exit
