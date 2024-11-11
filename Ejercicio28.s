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
// matrix_add.s
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
    bl add_matrices
    
    mov x8, #93            // exit syscall
    mov x0, #0
    svc #0

add_matrices:
    // x0: matriz A
    // x1: matriz B
    // x2: matriz resultado
    // x3: tamaño (n)
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x4, #0              // i = 0
outer_loop_add:
    cmp x4, x3
    b.ge add_end
    
    mov x5, #0              // j = 0
inner_loop_add:
    cmp x5, x3
    b.ge outer_continue_add
    
    // Calcular offset = (i * n + j) * 8
    mul x6, x4, x3
    add x6, x6, x5
    lsl x6, x6, #3
    
    // Cargar elementos
    ldr x7, [x0, x6]       // A[i][j]
    ldr x8, [x1, x6]       // B[i][j]
    
    // Sumar y guardar
    add x9, x7, x8
    str x9, [x2, x6]
    
    add x5, x5, #1
    b inner_loop_add
    
outer_continue_add:
    add x4, x4, #1
    b outer_loop_add
    
add_end:
    ldp x29, x30, [sp], #16
    ret
