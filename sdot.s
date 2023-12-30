.globl sdot

.text
# =======================================================
# FUNCTION: Dot product of 1 sparse vectors and 1 dense vector
# Arguments:
#   a0 is the pointer to the start of v0 (sparse, coo format)
#   a1 is the pointer to the start of v1 (dense)
#   a2 is the number of non-zeros in vector v0
# Returns:
#   a0 is the sparse dot product of v0 and v1
# =======================================================
#
# struct coo {
#   int row;
#   int index;
#   int val;
# };   
# Since these are vectors row = 0 always for v0.
#for (int i = 0 i < nnz; i++) {
#    sum = sum + v0[i].value * v1[coo[i].index];
# }
sdot:
    # Prologue 
    addi sp sp -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    
    # Save arguments
    mv s0 a0
    mv s1 a1
    mv s2 a2

    # Set strides. Note that v0 is struct. v1 is array.
    li s3, 3
    slli s3, s3, 2 # s3 is stride for v0
    li s4, 1
    slli s4, s4, 2 # s4 is stride for v1

    # Set loop index
    li s5, 0

    # Set accumulation to 0
    li s6, 0


loop_start:

    # Check outer loop condition
    beq s5, s2 loop_end

    #TESTING
    # mv a1, s3
    # jal print_int
    #TESTING
    
    # load v0[i].value. The actual value is located at offset  from start of coo entry
    lw s7, 8 (s0)
    
    #TESTING
    # mv a1, s7
    # jal print_int
    #TESTING

    # What is the index of the coo element?
    lw s9, 4 (s0)
    #mul s0, s5, s4 # The pointer is given the offset of the index*stride. 
    
    #TESTING
    # mv a1, s9
    # jal print_int
    #TESTING

    # Lookup corresponding index in dense vector
    mul s9, s9, s4 # The pointer is given the offset of the index*stride. #POSSIBLE ERROR WITH INDEXING WITH MUL #MAYBE RESET S1 TO A0 EACH TIME

    #TESTING
    # mv a1, s9
    # jal print_int
    #TESTING

    # Load v1[coo[i].index]
    add s8, s1, s9
    lw s8, 0(s8)

    #TESTING
    # mv a1, s8
    # jal print_int
    #TESTING

    # Multiply and accumulate
    mul s7,s7,s8 # multiply the element pairs into a variable
    add s6,s6,s7 # add the multiplication to the dot product (not an array)

    # Bump ptr to coo entry
    add s0, s0, s3

    # Increment loop index
    addi s5, s5, 1

    j loop_start

loop_end:

    mv a0, s6

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp sp 44

    ret
