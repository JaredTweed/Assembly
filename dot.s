.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
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
    mv s2 a2
    li a0, 0

    # Set strides
    li s3, 1
    slli s3, s3, 2 # setting s3 to 4 because each element is 4 bytes

    # Set loop index
    li s4, 0

loop_start:
    # End the loop if the index is equal to the number of elements in the loop
    beq s4, s2 loop_end

    lw s5, 0 (s0) # s0 is the first element
    add s0,s0,s3 # move to the next element
    lw s6, 0 (s1) # s1 is the first element
    add s1,s1,s3 # move to the next element
    mul s5,s5,s6 # multiply the element pairs into a variable
    add a0,a0,s5 # add the multiplication to the dot product (not an array) 
    addi s4,s4,1 # increment the index of the for loop
    j loop_start

loop_end:

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp sp 32

    # Epilogue
    ret
