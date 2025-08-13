.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    blez a1, length_error
    j start
length_error:
    li a1, 78
    j exit2
start:
    # Prologue
    
    j loop_end
loop_start:
    lw t0, 0(a0)
    bgez t0, loop_continue
    mv t0, zero

loop_continue:
    sw t0, 0(a0)
    addi a0, a0, 4
    addi a1, a1, -1

loop_end:
    bgtz a1, loop_start

    # Epilogue

    
	ret
