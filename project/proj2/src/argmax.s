.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    blez a1, length_error
    j start
length_error:
    li a1, 77
    j exit2
start:
    # Prologue

    li t0, 0
    li t1, 0
    lw t2, 0(a0)
    j loop_end
loop_start:
    lw t3, 0(a0)
    ble t3, t2, loop_continue
    mv t2, t3
    mv t1, t0
loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
loop_end:
    blt t0, a1, loop_start
    mv a0, t1

    # Epilogue


    ret
