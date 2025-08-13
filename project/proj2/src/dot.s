.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    blez a2, length_error
    blez a3, stride_error
    blez a4, stride_error
    j start
length_error:
    li a1, 75
    j exit2
stride_error:
    li a1, 76
    j exit2
    
start:
    # Prologue

    li t0, 0
    li t4, 0
    slli a3, a3, 2
    slli a4, a4, 2
    j loop_end
loop_start:
    lw t1, 0(a0)
    lw t2, 0(a1)
    mul t3, t1, t2
    add t0, t0, t3
    add a0, a0, a3
    add a1, a1, a4
    addi t4, t4, 1

loop_end:
    blt t4, a2, loop_start
    mv a0, t0
    # Epilogue
    
    
    ret
