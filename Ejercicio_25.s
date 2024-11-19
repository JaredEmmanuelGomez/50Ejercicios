# Lenguajes de Interfaz - Actividad 25
# Ordenamiento burbuja
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Algoritmos de ordenamiento

# -------------------------------------------------------
/*
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
*/
# -------------------------------------------------------


// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    msg1:    .ascii "Los elementos del arreglo son: 45, 23, 78, 12, 67, 34, 89, 9\n"
    len1 = . - msg1
    msgOrd:  .ascii "El arreglo ordenado es: "
    lenOrd = . - msgOrd
    array:   .quad 45, 23, 78, 12, 67, 34, 89, 9
    buffer:  .skip 20        // Buffer para convertir número a string
    space:   .ascii " "
    newline: .ascii "\n"

.text
.global _start

_start:
    // Mostrar los elementos del arreglo original
    mov x0, #1              // stdout
    ldr x1, =msg1          // mensaje
    mov x2, len1           // longitud
    mov x8, #64            // syscall write
    svc #0

    // Inicializar para ordenamiento burbuja
    ldr x0, =array         // Dirección base del arreglo
    mov x1, #8             // Tamaño del arreglo
    
    // Llamar a la función de ordenamiento burbuja
    bl bubble_sort

    // Mostrar mensaje "El arreglo ordenado es: "
    mov x0, #1
    ldr x1, =msgOrd
    mov x2, lenOrd
    mov x8, #64
    svc #0

    // Mostrar el arreglo ordenado
    ldr x0, =array
    mov x1, #8
    bl print_array

    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc #0

bubble_sort:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x2, #0                  // i = 0
outer_loop:
    cmp x2, x1                  // Comparar i con tamaño
    bge bubble_sort_end         // Si i >= tamaño, terminar
    
    mov x3, #0                  // j = 0
inner_loop:
    sub x4, x1, #1             // tamaño - 1
    sub x4, x4, x2             // (tamaño - 1) - i
    cmp x3, x4                 // Comparar j con (tamaño - 1) - i
    bge outer_increment        // Si j >= (tamaño - 1) - i, siguiente iteración
    
    // Cargar elementos a comparar
    ldr x5, [x0, x3, lsl #3]   // array[j]
    add x6, x3, #1             // j + 1
    ldr x7, [x0, x6, lsl #3]   // array[j + 1]
    
    // Comparar elementos
    cmp x5, x7                 // Comparar array[j] con array[j + 1]
    ble inner_increment        // Si array[j] <= array[j + 1], no intercambiar
    
    // Intercambiar elementos
    str x7, [x0, x3, lsl #3]   // array[j] = array[j + 1]
    str x5, [x0, x6, lsl #3]   // array[j + 1] = temp
    
inner_increment:
    add x3, x3, #1             // j++
    b inner_loop
    
outer_increment:
    add x2, x2, #1             // i++
    b outer_loop

bubble_sort_end:
    ldp x29, x30, [sp], #16
    ret

print_array:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x19, x0                // Guardar dirección del array
    mov x20, x1                // Guardar tamaño
    mov x21, #0                // Índice actual

print_loop:
    cmp x21, x20
    bge print_end
    
    // Convertir número actual a string
    ldr x0, [x19, x21, lsl #3]
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
    mov x2, #1
    mov x8, #64
    svc #0
    
    add x21, x21, #1
    b print_loop

print_end:
    // Imprimir nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    ldp x29, x30, [sp], #16
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

ASCIINEMA REC
https://asciinema.org/a/690703
