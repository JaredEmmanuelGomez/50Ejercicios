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
// matrix_transpose.s
.global _start

.data
    // Matriz de ejemplo 3x3
    matrix:     .quad   1, 2, 3
                .quad   4, 5, 6
                .quad   7, 8, 9
                
    result:     .space  72      // Espacio para matriz transpuesta
    matrix_size:.quad   3       // Tamaño de la matriz (3x3)
    
.text
_start:
    ldr x0, =matrix
    ldr x1, =result
    ldr x2, =matrix_size
    ldr x2, [x2]
    bl transpose_matrix
    
    mov x8, #93            // exit syscall
    mov x0, #0
    svc #0

transpose_matrix:
    // x0: matriz original
    // x1: matriz resultado
    // x2: tamaño (n)
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x3, #0              // i = 0
outer_loop_trans:
    cmp x3, x2
    b.ge trans_end
    
    mov x4, #0              // j = 0
inner_loop_trans:
    cmp x4, x2
    b.ge outer_continue_trans
    
    // Calcular offset origen = (i * n + j) * 8
    mul x5, x3, x2
    add x5, x5, x4
    lsl x5, x5, #3
    
    // Calcular offset destino = (j * n + i) * 8
    mul x6, x4, x2
    add x6, x6, x3
    lsl x6, x6, #3
    
    // Transponer elemento
    ldr x7, [x0, x5]
    str x7, [x1, x6]
    
    add x4, x4, #1
    b inner_loop_trans
    
outer_continue_trans:
    add x3, x3, #1
    b outer_loop_trans
    
trans_end:
    ldp x29, x30, [sp], #16
    ret

// Función auxiliar para imprimir matriz (opcional)
print_matrix:
    // x0: dirección de la matriz
    // x1: tamaño
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x2, #0              // i = 0
print_outer:
    cmp x2, x1
    b.ge print_end
    
    mov x3, #0              // j = 0
print_inner:
    cmp x3, x1
    b.ge print_newline
    
    // Calcular offset
    mul x4, x2, x1
    add x4, x4, x3
    lsl x4, x4, #3
    
    // Cargar y guardar valor para imprimir
    ldr x0, [x0, x4]
    bl print_num
    
    mov x0, #32            // Imprimir espacio
    bl print_char
    
    add x3, x3, #1
    b print_inner
    
print_newline:
    mov x0, #10            // Imprimir nueva línea
    bl print_char
    
    add x2, x2, #1
    b print_outer
    
print_end:
    ldp x29, x30, [sp], #16
    ret
