# Lenguajes de Interfaz - Actividad 24
# Búsqueda binaria
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Recursión y saltos

# ---------------------------------------
/*
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

*/
# -------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
// binary_search.s
.global _start

.data
    array:      .quad   1, 3, 5, 7, 9, 11, 13, 15   // Array ordenado
    array_size: .quad   8                           // Tamaño del array
    
.text
_start:
    ldr x0, =array           // Cargar dirección del array
    mov x1, #11             // Elemento a buscar
    ldr x2, =array_size    // Cargar tamaño del array
    ldr x2, [x2]          // Obtener valor del tamaño
    bl binary_search     // Llamar a la función
    
    // Salir del programa
    mov x8, #93
    mov x0, #0
    svc #0

binary_search:
    // Entrada:
    // x0: dirección base del array
    // x1: elemento a buscar
    // x2: tamaño del array
    // Salida:
    // x0: índice encontrado (-1 si no se encuentra)
    
    mov x3, #0              // left = 0
    sub x4, x2, #1         // right = size - 1
    
search_loop:
    cmp x3, x4             // Comparar left con right
    b.gt not_found        // Si left > right, no encontrado
    
    // Calcular mid = (left + right) / 2
    add x5, x3, x4        // x5 = left + right
    lsr x5, x5, #1       // x5 = (left + right) / 2
    
    // Cargar array[mid]
    ldr x6, [x0, x5, lsl #3]
    
    // Comparar array[mid] con target
    cmp x6, x1
    b.eq found           // Si son iguales, encontrado
    b.gt search_right   // Si array[mid] > target, buscar en mitad derecha
    
    // Buscar en mitad izquierda
    add x3, x5, #1      // left = mid + 1
    b search_loop
    
search_right:
    sub x4, x5, #1      // right = mid - 1
    b search_loop
    
not_found:
    mov x0, #-1         // Retornar -1
    ret
    
found:
    mov x0, x5          // Retornar mid
    ret
