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
// matrix_multiply.s
.global _start

.data
    // Matrices de ejemplo 3x3
    matrix_a:   .quad   1, 2, 3
                .quad   4, 5, 6
                .quad   7, 8, 9
                
    matrix_b:   .quad   9, 8, 7
                .quad   6, 5, 4
                .quad   3, 2, 1
                
    result:     .space  72      // Espacio para matriz resultado 3x3
    matrix_size:.quad   3       // Tamaño de las matrices (3x3)
    
.text
_start:
    ldr x0, =matrix_a
    ldr x1, =matrix_b
    ldr x2, =result
    ldr x3, =matrix_size
    ldr x3, [x3]
    bl multiply_matrices
    
    mov x8, #93            // exit syscall
    mov x0, #0
    svc #0

multiply_matrices:
    // x0: matriz A
    // x1: matriz B
    // x2: matriz resultado
    // x3: tamaño (n)
    stp x29, x30, [sp, #-32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    mov x4, #0              // i = 0
outer_loop_mul:
    cmp x4, x3
    b.ge mul_end
    
    mov x5, #0              // j = 0
inner_loop_mul:
    cmp x5, x3
    b.ge outer_continue_mul
    
    mov x6, #0              // k = 0
    mov x19, #0            // sum = 0
    
sum_loop:
    cmp x6, x3
    b.ge store_result
    
    // Calcular offsets
    mul x7, x4, x3         // i * n
    add x7, x7, x6        // i * n + k
    lsl x7, x7, #3        // offset para A
    
    mul x8, x6, x3        // k * n
    add x8, x8, x5        // k * n + j
    lsl x8, x8, #3        // offset para B
    
    // Multiplicar y acumular
    ldr x9, [x0, x7]      // A[i][k]
    ldr x10, [x1, x8]     // B[k][j]
    mul x20, x9, x10
    add x19, x19, x20     // sum += A[i][k] * B[k][j]
    
    add x6, x6, #1
    b sum_loop
    
store_result:
    // Guardar resultado
    mul x7, x4, x3
    add x7, x7, x5
    lsl x7, x7, #3
    str x19, [x2, x7]
    
    add x5, x5, #1
    b inner_loop_mul
    
outer_continue_mul:
    add x4, x4, #1
    b outer_loop_mul
    
mul_end:
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret