# Lenguajes de Interfaz - Actividad 22
# Encontrar el máximo en un arreglo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Recorrido de arreglos

# ---------------------
/*
def find_max(arr):
    return max(arr)
*/
# --------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
// find_max.s
.global _start

.data
    array:      .quad   1, 15, 3, 8, 12, 5, 9, 4    // Array de ejemplo
    array_size: .quad   8                           // Tamaño del array
    
.text
_start:
    ldr x0, =array           // Cargar dirección del array
    ldr x1, =array_size     // Cargar tamaño del array
    ldr x1, [x1]           // Obtener valor del tamaño
    bl find_max           // Llamar a la función
    
    // Salir del programa
    mov x8, #93
    mov x0, #0
    svc #0

find_max:
    // Entrada:
    // x0: dirección base del array
    // x1: tamaño del array
    // Salida:
    // x0: valor máximo
    
    ldr x2, [x0]          // Inicializar máximo con primer elemento
    mov x3, #1           // Inicializar índice (i = 1)
    
max_loop:
    cmp x3, x1           // Comparar i con tamaño
    b.ge max_end        // Si i >= tamaño, terminar
    
    ldr x4, [x0, x3, lsl #3]  // Cargar array[i]
    cmp x4, x2          // Comparar con máximo actual
    b.le max_continue   // Si es menor o igual, continuar
    mov x2, x4         // Actualizar máximo
    
max_continue:
    add x3, x3, #1     // i++
    b max_loop
    
max_end:
    mov x0, x2         // Retornar máximo
    ret
