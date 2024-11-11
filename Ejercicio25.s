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
// bubble_sort.s
.global _start

.data
    array:      .quad   64, 34, 25, 12, 22, 11, 90   // Array a ordenar
    array_size: .quad   7                            // Tamaño del array
    
.text
_start:
    ldr x0, =array           // Cargar dirección del array
    ldr x1, =array_size     // Cargar tamaño del array
    ldr x1, [x1]           // Obtener valor del tamaño
    bl bubble_sort        // Llamar a la función
    
    // Salir del programa
    mov x8, #93
    mov x0, #0
    svc #0

bubble_sort:
    // Entrada:
    // x0: dirección base del array
    // x1: tamaño del array
    
    sub x2, x1, #1          // n-1 para el bucle exterior
    mov x3, #0             // i = 0 (bucle exterior)
    
outer_loop:
    cmp x3, x2             // Comparar i con n-1
    b.ge sort_end         // Si i >= n-1, terminar
    
    mov x4, #0            // j = 0 (bucle interior)
    sub x5, x2, x3       // límite = n-1-i
    
inner_loop:
    cmp x4, x5           // Comparar j con límite
    b.ge outer_continue  // Si j >= límite, siguiente iteración exterior
    
    // Cargar array[j] y array[j+1]
    ldr x6, [x0, x4, lsl #3]
    add x7, x4, #1
    ldr x8, [x0, x7, lsl #3]
    
    // Comparar y intercambiar si necesario
    cmp x6, x8
    b.le inner_continue  // Si array[j] <= array[j+1], continuar
    
    // Intercambiar elementos
    str x8, [x0, x4, lsl #3]
    str x6, [x0, x7, lsl #3]
    
inner_continue:
    add x4, x4, #1      // j++
    b inner_loop
    
outer_continue:
    add x3, x3, #1      // i++
    b outer_loop
    
sort_end:
    ret
