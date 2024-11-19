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
.data
    msgSize:    .ascii "Ingrese el tamaño del arreglo: "
    lenSize = . - msgSize
    msgInput:   .ascii "Ingrese el número "
    lenInput = . - msgInput
    msgColon:   .ascii ": "
    lenColon = . - msgColon
    msgSort:    .ascii "\nArreglo ordenado: "
    lenSort = . - msgSort
    msgBuscar:  .ascii "\nIngrese el número a buscar: "
    lenBuscar = . - msgBuscar
    msgEncontrado: .ascii "El número se encontró en la posición: "
    lenEncontrado = . - msgEncontrado
    msgNoEncontrado: .ascii "El número no se encontró en el arreglo\n"
    lenNoEncontrado = . - msgNoEncontrado
    msgComa:    .ascii ", "
    lenComa = . - msgComa
    buffer:     .skip 20        // Buffer para entrada
    array:      .skip 800       // Espacio para 100 números (8 bytes cada uno)
    newline:    .ascii "\n"

.text
.global _start

_start:
    // Solicitar tamaño del arreglo
    mov x0, #1
    ldr x1, =msgSize
    mov x2, lenSize
    mov x8, #64
    svc #0

    // Leer tamaño
    mov x0, #0
    ldr x1, =buffer
    mov x2, #20
    mov x8, #63
    svc #0

    // Convertir string a número
    ldr x1, =buffer
    bl string_to_number
    mov x19, x0             // x19 = tamaño del arreglo

    // Leer números del arreglo
    mov x20, #0            // x20 = índice actual
    ldr x21, =array        // x21 = dirección base del arreglo

input_loop:
    cmp x20, x19
    beq input_done

    // Mostrar "Ingrese el número X: "
    mov x0, #1
    ldr x1, =msgInput
    mov x2, lenInput
    mov x8, #64
    svc #0

    mov x0, x20
    add x0, x0, #1
    ldr x1, =buffer
    bl numero_a_string
    
    mov x0, #1
    ldr x1, =buffer
    mov x8, #64
    svc #0

    mov x0, #1
    ldr x1, =msgColon
    mov x2, lenColon
    mov x8, #64
    svc #0

    // Leer número
    mov x0, #0
    ldr x1, =buffer
    mov x2, #20
    mov x8, #63
    svc #0

    // Convertir y guardar
    ldr x1, =buffer
    bl string_to_number
    str x0, [x21, x20, lsl #3]

    add x20, x20, #1
    b input_loop

input_done:
    // Ordenar el arreglo (bubble sort)
    ldr x0, =array
    mov x1, x19
    bl bubble_sort

    // Mostrar arreglo ordenado
    mov x0, #1
    ldr x1, =msgSort
    mov x2, lenSort
    mov x8, #64
    svc #0

    // Mostrar elementos ordenados
    mov x20, #0        // índice actual
print_loop:
    cmp x20, x19
    beq print_done

    ldr x0, [x21, x20, lsl #3]
    ldr x1, =buffer
    bl numero_a_string

    mov x0, #1
    ldr x1, =buffer
    mov x8, #64
    svc #0

    // Mostrar coma si no es el último
    add x22, x20, #1
    cmp x22, x19
    beq skip_comma
    
    mov x0, #1
    ldr x1, =msgComa
    mov x2, lenComa
    mov x8, #64
    svc #0

skip_comma:
    add x20, x20, #1
    b print_loop

print_done:
    // Pedir número a buscar
    mov x0, #1
    ldr x1, =msgBuscar
    mov x2, lenBuscar
    mov x8, #64
    svc #0

    mov x0, #0
    ldr x1, =buffer
    mov x2, #20
    mov x8, #63
    svc #0

    ldr x1, =buffer
    bl string_to_number
    mov x22, x0        // número a buscar

    // Realizar búsqueda binaria
    ldr x0, =array
    mov x1, x19
    mov x2, x22
    bl binary_search
    
    // Verificar resultado
    cmp x0, #-1
    beq no_encontrado

encontrado:
    mov x19, x0
    mov x0, #1
    ldr x1, =msgEncontrado
    mov x2, lenEncontrado
    mov x8, #64
    svc #0

    mov x0, x19
    ldr x1, =buffer
    bl numero_a_string

    mov x0, #1
    ldr x1, =buffer
    mov x8, #64
    svc #0

    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0
    b salir

no_encontrado:
    mov x0, #1
    ldr x1, =msgNoEncontrado
    mov x2, lenNoEncontrado
    mov x8, #64
    svc #0

salir:
    mov x0, #0
    mov x8, #93
    svc #0

bubble_sort:
    // x0 = dirección base, x1 = tamaño
    mov x2, #0          // i
outer_loop:
    sub x3, x1, #1
    cmp x2, x3
    bge sort_done

    mov x3, #0          // j
inner_loop:
    sub x4, x1, x2
    sub x4, x4, #1
    cmp x3, x4
    bge next_outer

    ldr x5, [x0, x3, lsl #3]           // arr[j]
    add x6, x3, #1
    ldr x7, [x0, x6, lsl #3]           // arr[j+1]
    cmp x5, x7
    ble next_inner

    // Intercambiar elementos
    str x7, [x0, x3, lsl #3]
    str x5, [x0, x6, lsl #3]

next_inner:
    add x3, x3, #1
    b inner_loop

next_outer:
    add x2, x2, #1
    b outer_loop

sort_done:
    ret

binary_search:
    // x0 = dirección base, x1 = tamaño, x2 = valor a buscar
    mov x3, #0          // left = 0
    sub x4, x1, #1      // right = size - 1

search_loop:
    cmp x3, x4
    bgt not_found

    // mid = (left + right) / 2
    add x5, x3, x4
    lsr x5, x5, #1

    // Cargar arr[mid]
    ldr x6, [x0, x5, lsl #3]

    // Comparar con valor buscado
    cmp x6, x2
    beq found
    bgt search_right
    
    // Buscar en mitad izquierda
    add x3, x5, #1
    b search_loop

search_right:
    // Buscar en mitad derecha
    sub x4, x5, #1
    b search_loop

found:
    mov x0, x5          // Retornar índice
    ret

not_found:
    mov x0, #-1         // Retornar -1
    ret

string_to_number:
    mov x0, #0
    mov x2, #10

convert_loop:
    ldrb w3, [x1], #1
    cmp w3, #'\n'
    beq convert_done
    cmp w3, #0
    beq convert_done
    
    sub w3, w3, #'0'
    mul x0, x0, x2
    add x0, x0, x3
    b convert_loop

convert_done:
    ret

numero_a_string:
    mov x2, #10
    mov x3, x1

toString_loop:
    udiv x4, x0, x2
    msub x5, x4, x2, x0
    add x5, x5, #'0'
    strb w5, [x1], #1
    mov x0, x4
    cbnz x0, toString_loop

    // Invertir string
    mov x4, x3
    sub x5, x1, #1

reverse_loop:
    cmp x4, x5
    bge reverse_done
    ldrb w6, [x4]
    ldrb w7, [x5]
    strb w7, [x4], #1
    strb w6, [x5], #-1
    b reverse_loop

reverse_done:
    sub x0, x1, x3
    mov x2, x0
    ret
