.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    blez a1, m0_error
    blez a2, m0_error
    blez a4, m1_error
    blez a5, m1_error
    bne a2, a4, mismatch_error
    j start
m0_error:
    li a1, 72
    j exit2
m1_error:
    li a1, 73
    j exit2
mismatch_error:
    li a1, 74
    j exit2
 
start:
    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    
    li s7, 0
    j outer_loop_end
outer_loop_start:
    li s8, 0
    j inner_loop_end

inner_loop_start:
    mv a0, s0
    mv a1, s3
    mv a2, s2
    li a3, 1
    mv a4, s5
    jal dot
    sw a0, 0(s6)
    
    addi s6, s6, 4
    addi s8, s8, 1
    addi s3, s3, 4


inner_loop_end:
    blt s8, s5, inner_loop_start
    addi s7, s7, 1
    
    slli t2, s5, 2
    sub s3, s3, t2
    
    slli t3, s2, 2
    add s0, s0, t3

outer_loop_end:
    blt s7, s1, outer_loop_start
    
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
    
    ret
