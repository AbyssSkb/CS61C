.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0, 5
    bne a0, t0, incorrect_number_error
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)
    
    
    mv s1, a1 # argv
    mv s0, a2 # print_classification

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    addi sp, sp, -8
    lw a0, 4(s1)
    mv a1, sp
    addi a2, sp, 4
    jal read_matrix
    mv s2, a0 # address of m0
    lw s3, 0(sp) # rows of m0
    lw s4, 4(sp) # cols of m0 
    addi sp, sp, 8
    
    # Load pretrained m1
    addi sp, sp, -8
    lw a0, 8(s1)
    mv a1, sp
    addi a2, sp, 4
    jal read_matrix
    mv s5, a0 # address of m1
    lw s6, 0(sp) # rows of m1
    lw s7, 4(sp) # cols of m1 
    addi sp, sp, 8

    # Load input matrix
    addi sp, sp, -8
    lw a0, 12(s1)
    mv a1, sp
    addi a2, sp, 4
    jal read_matrix
    mv s8, a0 # address of input
    lw s9, 0(sp) # rows of input
    lw s10, 4(sp) # cols of input
    addi sp, sp, 8
    
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    # allocate memory for m0 * input
    mul a0, s3, s10
    slli a0, a0, 2
    jal malloc
    beqz a0, malloc_error
    mv s11, a0 # address of m0 * input
    
    # calc m0 * input
    mv a0, s2
    mv a1, s3
    mv a2, s4
    mv a3, s8
    mv a4, s9
    mv a5, s10
    mv a6, s11
    jal matmul
    
    # calc ReLU(m0 * input)
    mv a0, s11
    mul a1, s3, s10
    jal relu
    
    # allocate memory for ouput
    mul a0, s6, s10
    slli a0, a0, 2
    jal malloc
    beqz a0, malloc_error
    mv s9, a0 # address of output matrix
    
    # calc m1 * ReLU(m0 * input)
    mv a0, s5
    mv a1, s6
    mv a2, s7
    mv a3, s11
    mv a4, s3
    mv a5, s10
    mv a6, s9
    jal matmul
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s9
    mv a2, s6
    mv a3, s10
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s9
    mul a1, s6, s10
    jal argmax
    mv s1, a0
    
    bnez s0, finally
    # Print classification
    mv a1, s1
    jal print_int

    # Print newline afterwards for clarity
    li a1, 10
    jal print_char

finally:
    mv a0, s2
    jal free
    mv a0, s5
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    mv a0, s11
    jal free
    
    mv a0, s1
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    
    ret

incorrect_number_error:
    li a1, 89
    j exit2
    
malloc_error:
    li a1, 88
    j exit2