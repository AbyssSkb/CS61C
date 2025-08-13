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
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    mv s0, a0 # pointer to string representing the filename
    mv s1, a1 # pointer to the number of rows
    mv s2, a2 # pointer to the number os cols
    
    # Open file
    mv a1, s0
    li a2, 0
    jal fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s3, a0 # the file descriptor

    # allocate memory for buffer
    li a0, 8
    jal malloc
    beqz a0, malloc_error
    mv s4, a0 # the buffer address
    
    # read height and width of the matrix
    mv a1, s3
    mv a2, s4
    li a3, 8
    jal fread
    li t0, 8
    bne a0, t0, fread_error
    lw t1, 0(s4) # number of rows
    lw t2, 4(s4) # number of cols
    sw t1, 0(s1)
    sw t2, 0(s2)
    mul s6, t1, t2 # number of elements in matrix
    
    # allocate memory for the matrix
    slli a0, s6, 2
    jal malloc
    beqz a0, malloc_error
    mv s5, a0 # pointer to the matrix
    
    # read matrix
    mv a1, s3
    mv a2, s5
    slli a3, s6, 2
    jal fread
    slli t0, s6, 2
    bne a0, t0, fread_error

    # Close file
    mv a1, s3
    jal fclose
    bnez a0, fclose_error

    mv a0, s5

    # Epilogue
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    
    ret
    
fopen_error:
    li a1, 90
    j exit2
    
fread_error:
    li a1, 91
    j exit2
    
fclose_error:
    li a1, 92
    j exit2
    
malloc_error:
    li a1, 88
    j exit2
