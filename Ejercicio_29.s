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
.text
.global _start

_start:
    // Mostrar mensaje "Matriz A:"
    mov x0, #1
    ldr x1, =msg1
    mov x2, len1
    mov x8, #64
    svc #0

    // Mostrar Matriz A
    ldr x0, =matrizA
    bl print_matrix

    // Mostrar mensaje "Matriz B:"
    mov x0, #1
    ldr x1, =msg2
    mov x2, len2
    mov x8, #64
    svc #0

    // Mostrar Matriz B
    ldr x0, =matrizB
    bl print_matrix

    // Multiplicar matrices
    bl multiply_matrices

    // Mostrar mensaje "Matriz Resultado:"
    mov x0, #1
    ldr x1, =msg3
    mov x2, len3
    mov x8, #64
    svc #0

    // Mostrar Matriz Resultado
    ldr x0, =matrizR
    bl print_matrix

    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc #0

multiply_matrices:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    mov x29, sp

    // Inicializar registros
    ldr x19, =matrizA        // Dirección de matriz A
    ldr x20, =matrizB        // Dirección de matriz B
    ldr x21, =matrizR        // Dirección de matriz resultado
    mov x22, #0              // i = 0 (fila)

outer_loop:
    cmp x22, #3              // Comparar i con size
    bge mult_end             // Si i >= size, terminar
    mov x23, #0              // j = 0 (columna)

middle_loop:
    cmp x23, #3              // Comparar j con size
    bge next_row            // Si j >= size, siguiente fila
    mov x24, #0              // k = 0
    mov x25, xzr            // Acumulador para el resultado

inner_loop:
    cmp x24, #3              // Comparar k con size
    bge store_result         // Si k >= size, almacenar resultado

    // Calcular índices
    mov x0, x22              // i
    mov x1, #3               // size
    mul x0, x0, x1           // i * size
    add x0, x0, x24          // (i * size) + k
    lsl x0, x0, #3           // * 8 (tamaño de quad)
    ldr x1, [x19, x0]        // Cargar A[i][k]

    mov x0, x24              // k
    mov x2, #3               // size
    mul x0, x0, x2           // k * size
    add x0, x0, x23          // (k * size) + j
    lsl x0, x0, #3           // * 8
    ldr x2, [x20, x0]        // Cargar B[k][j]

    // Multiplicar y acumular
    mul x0, x1, x2           // A[i][k] * B[k][j]
    add x25, x25, x0         // Acumular resultado

    add x24, x24, #1         // k++
    b inner_loop

store_result:
    // Calcular índice para almacenar resultado
    mov x0, x22              // i
    mov x1, #3               // size
    mul x0, x0, x1           // i * size
    add x0, x0, x23          // (i * size) + j
    lsl x0, x0, #3           // * 8
    str x25, [x21, x0]       // Almacenar resultado en C[i][j]

    add x23, x23, #1         // j++
    b middle_loop

next_row:
    add x22, x22, #1         // i++
    b outer_loop

mult_end:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

print_matrix:
    // Guardar registros
    stp x29, x30, [sp, #-32]!
    stp x19, x20, [sp, #16]
    mov x29, sp

    mov x19, x0            // Guardar dirección de la matriz
    mov x20, #0            // Contador de elementos

print_matrix_loop:
    cmp x20, #9            // 9 elementos en total
    bge print_matrix_end

    // Convertir número a string
    ldr x0, [x19, x20, lsl #3]
    ldr x1, =buffer
    bl numero_a_string

    // Imprimir número
    mov x0, #1
    ldr x1, =buffer
    mov x8, #64
    svc #0

    // Imprimir espacio
    mov x0, #1
    ldr x1, =space
    mov x2, #2
    mov x8, #64
    svc #0

    // Verificar si necesitamos nueva línea (cada 3 elementos)
    add x20, x20, #1
    mov x0, x20
    mov x1, #3
    udiv x2, x0, x1
    msub x2, x2, x1, x0    // x2 = x0 % 3
    cbnz x2, print_matrix_loop

    // Imprimir nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0
    b print_matrix_loop

print_matrix_end:
    // Imprimir nueva línea extra para separación
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

numero_a_string:
    // x0 = número a convertir
    // x1 = dirección del buffer
    mov x2, #10            // Divisor
    mov x3, x1             // Guardar inicio del buffer
    
convert_loop:
    udiv x4, x0, x2        // x4 = x0 / 10
    msub x5, x4, x2, x0    // x5 = x0 - (x4 * 10) = residuo
    add x5, x5, #'0'       // Convertir a ASCII
    strb w5, [x1], #1      // Guardar dígito y avanzar
    mov x0, x4             // Preparar para siguiente división
    cbnz x0, convert_loop  // Continuar si el cociente no es cero

    // Invertir los caracteres
    mov x4, x3             // x4 = inicio
    sub x5, x1, #1         // x5 = fin
reverse_loop:
    cmp x4, x5
    bge reverse_done
    ldrb w6, [x4]
    ldrb w7, [x5]
    strb w7, [x4], #1
    strb w6, [x5], #-1
    b reverse_loop

reverse_done:
    sub x0, x1, x3         // Calcular longitud
    mov x2, x0             // Guardar longitud para syscall write
    ret
