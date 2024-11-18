# Lenguajes de Interfaz - Actividad 29
# Multiplicación de matrices
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Bucles anidados, operaciones en memoria

# ------------------------------------------------
/*
def multiply_matrices(A, B):
    result = [[0] * len(B[0]) for _ in range(len(A))]
    for i in range(len(A)):
        for j in range(len(B[0])):
            for k in range(len(B)):
                result[i][j] += A[i][k] * B[k][j]
    return result
*/
# -------------------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    prompt_size: .asciz "Enter matrix size (N for NxN): "
    input_mat1: .asciz "Enter elements for first matrix:\n"
    input_mat2: .asciz "Enter elements for second matrix:\n"
    input_element: .asciz "Enter element [%d][%d]: "
    output_msg: .asciz "Result matrix:\n"
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

    // Input matrices (similar to addition program)
    // ... [Input code same as matrix addition] ...

multiply_matrices:
    mov w21, #0    // i counter
mult_i_loop:
    ldr w0, [size]
    cmp w21, w0
    b.ge print_result

    mov w22, #0    // j counter
mult_j_loop:
    ldr w0, [size]
    cmp w22, w0
    b.ge next_mult_i

    // Initialize result[i][j] to 0
    adrp x0, result
    add x0, x0, :lo12:result
    ldr w3, [size]
    mul w4, w21, w3
    add w4, w4, w22
    lsl w4, w4, #2
    mov w5, #0
    str w5, [x0, x4]

    mov w23, #0    // k counter
mult_k_loop:
    ldr w0, [size]
    cmp w23, w0
    b.ge next_mult_j

    // Calculate indices
    ldr w3, [size]
    mul w4, w21, w3    // i * n
    add w4, w4, w23    // i * n + k
    lsl w4, w4, #2     // (i * n + k) * 4

    mul w5, w23, w3    // k * n
    add w5, w5, w22    // k * n + j
    lsl w5, w5, #2     // (k * n + j) * 4

    // Load elements
    adrp x0, matrix1
    add x0, x0, :lo12:matrix1
    ldr w6, [x0, x4]    // matrix1[i][k]

    adrp x0, matrix2
    add x0, x0, :lo12:matrix2
    ldr w7, [x0, x5]    // matrix2[k][j]

    // Multiply and add to result
    mul w6, w6, w7
    
    adrp x0, result
    add x0, x0, :lo12:result
    mul w8, w21, w3
    add w8, w8, w22
    lsl w8, w8, #2
    ldr w9, [x0, x8]
    add w9, w9, w6
    str w9, [x0, x8]

    add w23, w23, #1
    b mult_k_loop

next_mult_j:
    add w22, w22, #1
    b mult_j_loop

next_mult_i:
    add w21, w21, #1
    b mult_i_loop

print_result:
    // Print result (similar to addition program)
    // ... [Print code same as matrix addition] ...

exit:
    ldr lr, [sp], #16
    mov w0, #0
    ret
