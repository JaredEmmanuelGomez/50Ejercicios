# Lenguajes de Interfaz - Actividad 28
# Suma de matrices
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Operaciones con arreglos 2D

# -------------------------------------------------------------------------------
/*
def add_matrices(A, B):
    return [[A[i][j] + B[i][j] for j in range(len(A[0]))] for i in range(len(A))]
*/
# -------------------------------------------------------------------------------


// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    prompt_size: .asciz "Enter matrix size (N for NxN): "
    input_mat1: .asciz "Enter elements for first matrix:\n"
    input_mat2: .asciz "Enter elements for second matrix:\n"
    input_element: .asciz "Enter element [%d][%d]: "
    output_msg: .asciz "Resultant matrix:\n"
    element_fmt: .asciz "%d\t"
    scan_format: .asciz "%d"
    newline: .asciz "\n"

.bss
    .align 4
    matrix1: .skip 400    // Space for up to 10x10 matrix
    matrix2: .skip 400    // Space for up to 10x10 matrix
    result:  .skip 400    // Space for result matrix
    size: .skip 4         // Matrix size (N for NxN)

.text
.global main
main:
    // Save link register
    str lr, [sp, -16]!

    // Get matrix size
    adrp x0, prompt_size
    add x0, x0, :lo12:prompt_size
    bl printf

    adrp x0, scan_format
    add x0, x0, :lo12:scan_format
    adrp x1, size
    add x1, x1, :lo12:size
    bl scanf

    // Input first matrix
    adrp x0, input_mat1
    add x0, x0, :lo12:input_mat1
    bl printf

    mov w21, #0    // row counter
row1_loop:
    ldr w0, [size]
    cmp w21, w0
    b.ge input_matrix2

    mov w22, #0    // column counter
col1_loop:
    ldr w0, [size]
    cmp w22, w0
    b.ge next_row1

    // Print prompt
    adrp x0, input_element
    add x0, x0, :lo12:input_element
    mov w1, w21
    mov w2, w22
    bl printf

    // Read element
    adrp x0, scan_format
    add x0, x0, :lo12:scan_format
    adrp x1, matrix1
    add x1, x1, :lo12:matrix1
    ldr w3, [size]
    mul w4, w21, w3
    add w4, w4, w22
    lsl w4, w4, #2
    add x1, x1, x4
    bl scanf

    add w22, w22, #1
    b col1_loop

next_row1:
    add w21, w21, #1
    b row1_loop

input_matrix2:
    // Input second matrix
    adrp x0, input_mat2
    add x0, x0, :lo12:input_mat2
    bl printf

    mov w21, #0    // row counter
row2_loop:
    ldr w0, [size]
    cmp w21, w0
    b.ge add_matrices

    mov w22, #0    // column counter
col2_loop:
    ldr w0, [size]
    cmp w22, w0
    b.ge next_row2

    // Print prompt
    adrp x0, input_element
    add x0, x0, :lo12:input_element
    mov w1, w21
    mov w2, w22
    bl printf

    // Read element
    adrp x0, scan_format
    add x0, x0, :lo12:scan_format
    adrp x1, matrix2
    add x1, x1, :lo12:matrix2
    ldr w3, [size]
    mul w4, w21, w3
    add w4, w4, w22
    lsl w4, w4, #2
    add x1, x1, x4
    bl scanf

    add w22, w22, #1
    b col2_loop

next_row2:
    add w21, w21, #1
    b row2_loop

add_matrices:
    // Add matrices
    mov w21, #0    // row counter
add_row_loop:
    ldr w0, [size]
    cmp w21, w0
    b.ge print_result

    mov w22, #0    // column counter
add_col_loop:
    ldr w0, [size]
    cmp w22, w0
    b.ge next_add_row

    // Calculate offset
    ldr w3, [size]
    mul w4, w21, w3
    add w4, w4, w22
    lsl w4, w4, #2

    // Load elements and add
    adrp x0, matrix1
    add x0, x0, :lo12:matrix1
    adrp x1, matrix2
    add x1, x1, :lo12:matrix2
    adrp x2, result
    add x2, x2, :lo12:result

    ldr w5, [x0, x4]    // matrix1[i][j]
    ldr w6, [x1, x4]    // matrix2[i][j]
    add w7, w5, w6      // sum
    str w7, [x2, x4]    // result[i][j]

    add w22, w22, #1
    b add_col_loop

next_add_row:
    add w21, w21, #1
    b add_row_loop

print_result:
    // Print result matrix
    adrp x0, output_msg
    add x0, x0, :lo12:output_msg
    bl printf

    mov w21, #0    // row counter
print_row_loop:
    ldr w0, [size]
    cmp w21, w0
    b.ge exit

    mov w22, #0    // column counter
print_col_loop:
    ldr w0, [size]
    cmp w22, w0
    b.ge print_newline

    // Print element
    adrp x0, element_fmt
    add x0, x0, :lo12:element_fmt
    adrp x2, result
    add x2, x2, :lo12:result
    ldr w3, [size]
    mul w4, w21, w3
    add w4, w4, w22
    lsl w4, w4, #2
    ldr w1, [x2, x4]
    bl printf

    add w22, w22, #1
    b print_col_loop

print_newline:
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf
    add w21, w21, #1
    b print_row_loop

exit:
    ldr lr, [sp], #16
    mov w0, #0
    ret
