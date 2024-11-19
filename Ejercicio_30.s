# Lenguajes de Interfaz - Actividad 30
# Transposición de una matriz
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Manipulación de arreglos

# ------------------------------------------------------------------------------------
/*
def transpose_matrix(matrix):
    return [[matrix[j][i] for j in range(len(matrix))] for i in range(len(matrix[0]))]
*/
# -------------------------------------------------------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    prompt_size: .asciz "Enter matrix size (N for NxN): "
    input_msg: .asciz "Enter matrix elements:\n"
    input_element: .asciz "Enter element [%d][%d]: "
    output_msg: .asciz "Transposed matrix:\n"
    element_fmt: .asciz "%d\t"
    scan_format: .asciz "%d"
    newline: .asciz "\n"

.bss
    .align 4
    matrix: .skip 400     // Space for input matrix
    result: .skip 400     // Space for transposed matrix
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

    // Input matrix
    adrp x0, input_msg
    add x0, x0, :lo12:input_msg
    bl printf

    mov w21, #0    // row counter
input_row_loop:
    ldr w0, [size]
    cmp w21, w0
    b.ge transpose_matrix

    mov w22, #0    // column counter
input_col_loop:
    ldr w0, [size]
    cmp w22, w0
    b.ge next_input_row

    // Print prompt
    adrp x0, input_element
    add x0, x0, :lo12:input_element
    mov w1, w21
    mov w2, w22
    bl printf

    // Read element
    adrp x0, scan_format
    add x0, x0, :lo12:scan_format
    adrp x1, matrix
    add x1, x1, :lo12:matrix
    ldr w3, [size]
    mul w4, w21, w3
    add w4, w4, w22
    lsl w4, w4, #2
    add x1, x1, x4
    bl scanf

    add w22, w22, #1
    b input_col_loop

next_input_row:
    add w21, w21, #1
    b input_row_loop

transpose_matrix:
    mov w21, #0    // row counter
trans_row_loop:
    ldr w0, [size]
    cmp w21, w0
    b.ge print_result

    mov w22, #0    // column counter
trans_col_loop:
    ldr w0, [size]
    cmp w22, w0
    b.ge next_trans_row

    // Calculate indices
    ldr w3, [size]
    mul w4, w21, w3    // i * n
    add w4, w4, w22    // i * n + j
    lsl w4, w4, #2     // (i * n + j) * 4

    mul w5, w22, w3    // j * n
    add w5, w5, w21    // j * n + i
    lsl w5, w5, #2     // (j * n + i) * 4

    // Load and store transposed element
    adrp x0, matrix
    add x0, x0, :lo12:matrix
    ldr w6, [x0, x4]    // matrix[i][j]

    adrp x1, result
    add x1, x1, :lo12:result
    str w6, [x1, x5]    // result[j][i]

    add w22, w22, #1
    b trans_col_loop

next_trans_row:
    add w21, w21, #1
    b trans_row_loop

print_result:
    // Print result matrix
    adrp x0, output_msg
    add x0, x0, :lo12:output_msg
    bl printf

    mov w21, #0    // row counter
print_row_loop:
    ldr w0, [size]
    cmp w21, w0


ASCIINEMA REC
https://asciinema.org/a/690723
