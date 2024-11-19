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
.text
.global _start

// Primero definimos las constantes para las longitudes
.equ len1, 16        // Longitud de "Matriz Original:\n"
.equ len2, 19        // Longitud de "Matriz Transpuesta:\n"

_start:
    // Mostrar mensaje "Matriz Original:"
    mov x0, #1
    ldr x1, =msg1
    mov x2, len1
    mov x8, #64
    svc #0
    
    // Mostrar matriz original
    ldr x0, =matriz
    bl imprimir_matriz
    
    // Realizar transposición
    bl transponer_matriz
    
    // Mostrar mensaje "Matriz Transpuesta:"
    mov x0, #1
    ldr x1, =msg2
    mov x2, len2
    mov x8, #64
    svc #0
    
    // Mostrar matriz transpuesta
    ldr x0, =matriz_t
    bl imprimir_matriz
    
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc #0

transponer_matriz:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x9, #0              // i = 0
bucle_ext:
    cmp x9, #3
    bge fin_trans
    
    mov x10, #0            // j = 0
bucle_int:
    cmp x10, #3
    bge sig_fila
    
    // Calcular índices
    // índice_origen = (i * 3 + j) * 8
    mov x11, x9            // x11 = i
    mov x12, #3
    mul x11, x11, x12      // x11 = i * 3
    add x11, x11, x10      // x11 = i * 3 + j
    lsl x11, x11, #3       // x11 *= 8
    
    // índice_destino = (j * 3 + i) * 8
    mov x12, x10           // x12 = j
    mov x13, #3
    mul x12, x12, x13      // x12 = j * 3
    add x12, x12, x9       // x12 = j * 3 + i
    lsl x12, x12, #3       // x12 *= 8
    
    // Realizar transposición
    ldr x0, =matriz
    ldr x1, =matriz_t
    ldr x13, [x0, x11]     // Cargar elemento
    str x13, [x1, x12]     // Guardar elemento transpuesto
    
    add x10, x10, #1       // j++
    b bucle_int
    
sig_fila:
    add x9, x9, #1         // i++
    b bucle_ext
    
fin_trans:
    ldp x29, x30, [sp], #16
    ret

imprimir_matriz:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x19, x0            // Guardar dirección matriz
    mov x20, #0            // Contador elementos
bucle_impresion:
    cmp x20, #9            // 9 elementos total
    bge fin_impresion
    
    // Imprimir número actual
    ldr x0, [x19, x20, lsl #3]
    bl imprimir_numero
    
    // Imprimir espacio
    mov x0, #1
    ldr x1, =espacio
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Nueva línea cada 3 elementos
    add x20, x20, #1
    mov x0, x20
    mov x1, #3
    udiv x2, x0, x1
    msub x2, x2, x1, x0    // x2 = x0 % 3
    cbnz x2, bucle_impresion
    
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0
    b bucle_impresion

fin_impresion:
    ldp x29, x30, [sp], #16
    ret

imprimir_numero:
    // Convertir número a string
    mov x1, #10
    ldr x2, =buffer
    add x2, x2, #19
    mov x3, #0
    strb w3, [x2]
convertir:
    sub x2, x2, #1
    udiv x3, x0, x1
    msub x4, x3, x1, x0
    add x4, x4, #'0'
    strb w4, [x2]
    mov x0, x3
    cbnz x0, convertir
    
    // Imprimir número
    mov x0, #1
    mov x1, x2
    ldr x2, =buffer
    add x2, x2, #19
    sub x2, x2, x1
    mov x8, #64
    svc #0
    ret

.data
matriz:     .quad 1, 2, 3, 4, 5, 6, 7, 8, 9
matriz_t:   .quad 0, 0, 0, 0, 0, 0, 0, 0, 0
msg1:       .ascii "Matriz Original:\n"
msg2:       .ascii "Matriz Transpuesta:\n"
espacio:    .ascii " "
newline:    .ascii "\n"
buffer:     .skip 20

ASCIINEMA REC
https://asciinema.org/a/690723
