.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    addi sp sp -12
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    
    li t0 1
    blt a2 t0 exception_36
    blt a3 t0 exception_37
    blt a4 t0 exception_37
    
loop_start:
    mv t0 a0 
    mv t1 a1
    mv t2 a2
    li t5 4
    mul t3 a3 t5
    mul t4 a4 t5
    mv t5 x0 # cur_res
    mv t6 x0 # res
 
loop_continue:
    lw s0 0(a0)
    lw s1 0(a1)
    mul t5 s0 s1
    add t6 t6 t5
    
    addi t2 t2 -1
    beq t2 x0 loop_end
    add a0 a0 t3
    add a1 a1 t4
    j loop_continue

exception_36:
    li a0 36
    j exit

exception_37:
    li a0 37
    j exit

loop_end:
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    addi sp sp 12
    mv a0 t6
    jr ra
