.globl gemv

.text
# =======================================================
# FUNCTION: Matrix Vector Multiplication
# 	d = gemv(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of v
# 	a4 is the # of rows (height) of v
#	a5 is the pointer to the the start of d
# Returns:
#	None, sets d = gemv(m0, m1)
# =======================================================
gemv:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions
    
    # Prologue
    addi sp sp -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)


    # Save arguments
    mv s0 a0
    mv s1 a1
    mv s2 a2 # a4 == a2
    mv s3 a3
    mv s4 a5 

    li s5, 0 # Set loop index

outer_loop_start_gemv:
    # End the loop if the index is equal to the number of elements in the input vector
    beq s5, s1 outer_loop_end_gemv
    
    mv a0, s0 # m0 ptr
    mv a1, s3 # v ptr
    mv a2, s2 # v length
 
    jal ra, dot # a0=vector ptr, a1=vector ptr, a2=vector length, output=a0=dot product

    sw a0, 0 (s4) # store the dot product in the output vector
    addi s4,s4,4 # move to the next element of the output vector

    slli t0, s2, 2 # number of bytes per row of our input matrix
    add s0,s0,t0 # increment to the next row or our input matrix

    addi s5,s5,1 # increment the index of the for loop
    j outer_loop_start_gemv # don't jump and link during a loop

#Epilogue
outer_loop_end_gemv:
    mv a0, a5 # s4 doesn't work because the offset is moved

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp sp 32

    ret

mismatched_dimensions:
    li a1 2
    jal exit2