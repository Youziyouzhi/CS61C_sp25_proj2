.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi sp sp -4
    sw ra 0(sp)

loop_start:
    li t1 1
    blt a1 t1 exception
    mv t0 a0
    mv t1 a1
    mv t3 x0

loop_continue:
    lw t2 0(t0) # arrat[i]
    bge t2 x0 store
    li t2 0
       
store:
    sw t2 0(t0)
    addi t0 t0 4
    addi t3 t3 1
    beq t3 a1 loop_end
    j loop_continue
    


loop_end:


    # Epilogue

    lw ra 0(sp)
    addi sp sp 4

    jr ra

exception:
    li a0 36
    j exit
