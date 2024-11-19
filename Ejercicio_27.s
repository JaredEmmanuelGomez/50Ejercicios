# Lenguajes de Interfaz - Actividad 27
# Ordenamiento por mezcla (Merge Sort)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Recursión y manejo de memoria

# -------------------------------------------------------------------------------
/*
def merge_sort(arr):
    if len(arr) > 1:
        mid = len(arr) // 2
        L = arr[:mid]
        R = arr[mid:]
        merge_sort(L)
        merge_sort(R)
        i = j = k = 0
        while i < len(L) and j < len(R):
            if L[i] < R[j]:
                arr[k] = L[i]
                i += 1
            else:
                arr[k] = R[j]
                j += 1
            k += 1
        while i < len(L):
            arr[k] = L[i]
            i += 1
            k += 1
        while j < len(R):
            arr[k] = R[j]
            j += 1
            k += 1

*/
# ---------------------------------------------------------------------------------


// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    msg1:    .ascii "Los elementos del arreglo son: 45, 23, 78, 12, 67, 34, 89, 9\n"
    len1 = . - msg1
    msgOrd:  .ascii "El arreglo ordenado es: "
    lenOrd = . - msgOrd
    array:   .quad 45, 23, 78, 12, 67, 34, 89, 9
    temp:    .skip 64         // Array temporal para mezcla (8 elementos * 8 bytes)
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

    // Inicializar para ordenamiento por mezcla
    ldr x0, =array         // Dirección base del arreglo
    mov x1, #0             // Inicio del rango (left)
    mov x2, #7             // Fin del rango (right)
    
    // Llamar a la función de ordenamiento por mezcla
    bl merge_sort

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

merge_sort:
    // Guardar registros
    stp x29, x30, [sp, #-32]!
    stp x19, x20, [sp, #16]
    mov x29, sp
    
    // Guardar parámetros
    mov x19, x0            // Dirección del array
    mov x20, x2            // right
    
    // Verificar si hay más de un elemento
    cmp x1, x2            // Comparar left con right
    bge merge_sort_end    // Si left >= right, terminar
    
    // Calcular punto medio
    add x3, x1, x2        // x3 = left + right
    lsr x3, x3, #1        // x3 = (left + right) / 2
    
    // Guardar parámetros para llamadas recursivas
    stp x1, x2, [sp, #-16]!  // Guardar left y right
    stp x3, x30, [sp, #-16]! // Guardar mid y link register
    
    // Ordenar primera mitad
    mov x2, x3            // right = mid
    bl merge_sort
    
    // Ordenar segunda mitad
    ldp x3, x30, [sp], #16   // Restaurar mid y link register
    ldp x1, x2, [sp], #16    // Restaurar left y right
    add x1, x3, #1        // left = mid + 1
    bl merge_sort
    
    // Mezclar las mitades ordenadas
    mov x0, x19           // Restaurar dirección del array
    mov x2, x20           // Restaurar right original
    bl merge

merge_sort_end:
    // Restaurar registros
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #32
    ret

merge:
    // Guardar registros
    stp x29, x30, [sp, #-48]!
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    mov x29, sp
    
    // Guardar parámetros
    mov x19, x0           // Dirección del array
    mov x20, x1           // left
    mov x21, x3           // mid
    mov x22, x2           // right
    
    // Copiar elementos al array temporal
    ldr x0, =temp
    mov x1, x19
    mov x2, x20           // left
    mov x3, x22           // right
    bl copy_to_temp
    
    // Inicializar índices
    mov x4, x20           // i = left
    mov x5, x20           // j = left
    add x6, x21, #1       // k = mid + 1
    
merge_loop:
    cmp x5, x21          // if (j > mid)
    bgt copy_remaining_right
    
    cmp x6, x22          // if (k > right)
    bgt copy_remaining_left
    
    // Cargar y comparar elementos
    ldr x7, =temp
    ldr x8, [x7, x5, lsl #3]  // temp[j]
    ldr x9, [x7, x6, lsl #3]  // temp[k]
    
    cmp x8, x9
    bgt copy_right
    
copy_left:
    str x8, [x19, x4, lsl #3] // array[i] = temp[j]
    add x5, x5, #1            // j++
    b next_merge
    
copy_right:
    str x9, [x19, x4, lsl #3] // array[i] = temp[k]
    add x6, x6, #1            // k++
    
next_merge:
    add x4, x4, #1            // i++
    cmp x4, x22               // if (i <= right)
    ble merge_loop
    b merge_end

copy_remaining_left:
    cmp x5, x21
    bgt merge_end
    ldr x7, =temp
    ldr x8, [x7, x5, lsl #3]
    str x8, [x19, x4, lsl #3]
    add x4, x4, #1
    add x5, x5, #1
    b copy_remaining_left

copy_remaining_right:
    cmp x6, x22
    bgt merge_end
    ldr x7, =temp
    ldr x8, [x7, x6, lsl #3]
    str x8, [x19, x4, lsl #3]
    add x4, x4, #1
    add x6, x6, #1
    b copy_remaining_right

merge_end:
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

copy_to_temp:
    // Copiar elementos al array temporal
    mov x4, x2           // i = left
copy_loop:
    cmp x4, x3          // if (i > right)
    bgt copy_end
    ldr x5, [x1, x4, lsl #3]  // array[i]
    str x5, [x0, x4, lsl #3]  // temp[i] = array[i]
    add x4, x4, #1
    b copy_loop
copy_end:
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
