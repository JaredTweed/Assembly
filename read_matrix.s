.globl read_matrix


.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
# Returns:
#   a0 is the pointer to the matrix in memory
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# ==============================================================================
read_matrix:
    # prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s2, 4(sp)
    sw s3, 8(sp)
    sw s4, 12(sp)
    sw s5, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)

    # check file path
    mv a1, a0 # setting the filepath arguments for fopen
    li a2,0 # setting the permissions for fopen
    jal fopen # sets a0 to file descriptor
    mv s2, a0 
    mv a1, a0 # sets ferror arguments
    jal ferror # returns 0 if there are no errors
    bne a0,zero, eof_or_error # branches if there is an error.

#

    # malloc row pointer
    li a0,4
    jal malloc # allocates a0 bytes, and returns a ptr to those bytes in a0
    mv s3,a0

    # Malloc col pointer
    li a0,4
    jal malloc # allocates a0 bytes, and returns a ptr to those bytes in a0
    mv s7,a0
    
    # Read number of rows
    mv a1,s2 # fopen file descriptor
    mv a2,s3 # malloc ptr
    li a3,4 # sets number of bytes to read from the file
    # Put the first a3 bytes of a1 into a2 (this data has the number of ints in the file).
    jal fread # adds an offset to a0 equal to the number of bytes read

    #TESTING prints number of rows
    # lw a1, 0(s3)
    # jal print_int
    #TESTING

    # Read number of cols
    mv a1,s2 # fopen file descriptor
    # addi a1, a1, 0
    mv a2,s7 # malloc ptr
    li a3,4 # sets number of bytes to read from the file
    # Put the first a3 bytes of a1 into a2 (this data has the number of ints in the file).
    jal fread # adds an offset to a0 equal to the number of bytes read

    #TESTING prints number of columns
    # lw a1, 0(s7)
    # jal print_int
    #TESTING

# My code is good after this

    # Calculate bytes
    lw s3, 0(s3) # s5 has number of ints in s3
    lw s7, 0(s7) # t0 has number of ints in s7
    mul s5, s3, s7 # total number of ints in the matrix
    slli s5, s5, 2 # s5 has number of bytes in the matrix

    #TESTING
    # mv a1, s5
    # jal print_int
    #TESTING

    # Allocate space for matrix and read it.
    mv a0, s5
    jal malloc
    mv s6, a0 #a0 now has a pointer to the matrix

    mv a1, s2
    mv a2, s6
    mv a3, s5
    # Put the first a3 (9*4) bytes of a1 (file descriptor) into the a2 ptr.
    jal fread 
    #mv a0, s6

    

    #TESTING
    # mv a1, s3
    # jal print_int
    #TESTING

    #TESTING
    # mv a1, s7
    # jal print_int
    #TESTING

    # Closing the file
    mv a1, s2
    jal fclose
    bne a0, x0, eof_or_error

    

    #TESTING
    # mv a1, s3
    # jal print_int
    #TESTING

    #TESTING
    # mv a1, s7
    # jal print_int
    #TESTING

    # Return value
    mv a0, s6

    #TESTING
    # lw a1, 0(s6)
    # jal print_int
    # lw a1, 4(s6)
    # jal print_int
    # lw a1, 8(s6)
    # jal print_int
    # lw a1, 12(s6)
    # jal print_int
    # lw a1, 16(s6)
    # jal print_int
    # lw a1, 20(s6)
    # jal print_int
    # lw a1, 24(s6)
    # jal print_int
    # lw a1, 28(s6)
    # jal print_int
    # lw a1, 32(s6)
    # jal print_int
    #TESTING

    #TESTING
    # lw a1, 0(a0)
    # jal print_int
    # lw a1, 4(a0)
    # jal print_int
    # lw a1, 8(a0)
    # jal print_int
    # lw a1, 12(a0)
    # jal print_int
    # lw a1, 16(a0)
    # jal print_int
    # lw a1, 20(a0)
    # jal print_int
    # lw a1, 24(a0)
    # jal print_int
    # lw a1, 28(a0)
    # jal print_int
    # lw a1, 32(a0)
    # jal print_int
    #TESTING

    mv a1, s3
    mv a2, s7
    # lw a1, 0(s3)
    # lw a2, 0(s7)

    #TESTING
    # mv a1, a1
    # jal print_int
    #TESTING

    # Epilogue
    lw ra, 0 (sp)
    lw s2, 4 (sp)
    lw s3, 8 (sp)
    lw s4, 12 (sp)
    lw s5, 16 (sp)
    lw s6, 20 (sp)
    lw s7, 24 (sp)
    addi sp, sp, 28
    
    ret

eof_or_error:
    li a1 1
    jal exit2
