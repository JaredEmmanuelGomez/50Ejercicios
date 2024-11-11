# Lenguajes de Interfaz - Actividad 20
# Búsqueda lineal
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# -------------------------------------------
/*
def busqueda_lineal(arreglo, elemento):
    for i in range(len(arreglo)):
        if arreglo[i] == elemento:
            return i
    return -1
*/
# -------------------------------------------


// Gómez Aguilar Jared Emmanuel
// 22210309
// búsqueda_lineal.s
.global main

.data
    array:      .quad   1, 3, 5, 7, 9, 11, 13, 15    // Array de ejemplo
    array_size: .quad   8                            // Tamaño del array
    
.text
_start:
    // Ejemplo de uso
    ldr x0, =array           // Cargar dirección del array
    mov x1, #7              // Elemento a buscar
    ldr x2, =array_size     // Cargar tamaño del array
    ldr x2, [x2]           // Obtener valor del tamaño
    bl linear_search       // Llamar a la función

    // Salir del programa
    mov x8, #93           // Syscall exit
    mov x0, #0           // Código de retorno
    svc #0              // Llamada al sistema

linear_search:
    // Entrada:
    // x0: dirección base del array
    // x1: elemento a buscar
    // x2: tamaño del array
    // Salida:
    // x0: índice encontrado (-1 si no se encuentra)
    
    mov x3, #0              // Inicializar índice (i = 0)
    
loop_linear:
    cmp x3, x2              // Comparar i con tamaño
    b.ge not_found         // Si i >= tamaño, no encontrado
    
    ldr x4, [x0, x3, lsl #3]  // Cargar array[i]
    cmp x4, x1              // Comparar con elemento buscado
    b.eq found             // Si son iguales, encontrado
    
    add x3, x3, #1         // i++
    b loop_linear         // Siguiente iteración
    
not_found:
    mov x0, #-1            // Retornar -1
    ret
    
found:
    mov x0, x3             // Retornar índice
    ret
