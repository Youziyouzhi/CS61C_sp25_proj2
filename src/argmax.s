.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue

    addi sp sp -4
    sw ra 0(sp)

    li t1 1
    blt a1 t1 exception
    
loop_start:    

    mv t0 a0
    mv t1 a1
    mv t2 x0 # index 
    mv t5 x0 # max_index
    lw t3 0(t0) # max = array[0]
    
loop_continue:

    addi t0 t0 4
    addi t1 t1 -1

    beq t1 x0 loop_end
    addi t2 t2 1
    lw t4 0(t0)
    bge t3 t4 loop_continue
    mv t3 t4
    mv t5 t2
    j loop_continue

loop_end:
    # Epilogue

    lw ra 0(sp)
    addi sp sp 4

    mv a0 t5
    jr ra
    
exception:

    li a0 36
    j exit
