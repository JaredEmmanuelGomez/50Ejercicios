# Lenguajes de Interfaz - Actividad 23
# Encontrar el mínimo en un arreglo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Recorrido de arreglos

# ---------------------------------
/*
def find_min(arr):
    return min(arr)
*/
# ---------------------------------

//Gomez Aguilar Jared Emmanuel
//22210309
.data
    msg1:    .ascii "Los elementos del arreglo son: 45, 23, 78, 12, 67, 34, 89, 9\n"
    len1 = . - msg1
    msgMin:  .ascii "El valor mínimo es: "
    lenMin = . - msgMin
    array:   .quad 45, 23, 78, 12, 67, 34, 89, 9
    buffer:  .skip 20        // Buffer para convertir número a string
    newline: .ascii "\n"

.text
.global _start

_start:
    // Mostrar los elementos del arreglo
    mov x0, #1              // stdout
    ldr x1, =msg1          // mensaje
    mov x2, len1           // longitud
    mov x8, #64            // syscall write
    svc #0

// Inicializar para encontrar el mínimo
ldr x0, =array         // Dirección base del arreglo
mov x1, #8             // Tamaño del arreglo

// Llamar a la función para encontrar el mínimo
bl find_minimum
mov x19, x0            // Guardar el mínimo en x19

// Mostrar mensaje "El valor mínimo es: "
mov x0, #1
ldr x1, =msgMin
mov x2, lenMin
mov x8, #64
svc #0

// Convertir el número a string y mostrarlo
mov x0, x19
ldr x1, =buffer
bl numero_a_string

// Mostrar el número
mov x0, #1
ldr x1, =buffer
mov x8, #64
svc #0

// Mostrar nueva línea
mov x0, #1
ldr x1, =newline
mov x2, #1
mov x8, #64
svc #0

// Salir del programa
mov x0, #0
mov x8, #93
svc #0

find_minimum:
    // Inicializar el mínimo con el primer elemento
    ldr x2, [x0]           // x2 = primer elemento
    mov x3, #1             // x3 = índice actual

loop:
    // Comparar si hemos terminado
    cmp x3, x1
    beq end

// Cargar siguiente elemento y comparar
ldr x4, [x0, x3, lsl #3]
cmp x4, x2
bge next
mov x2, x4             // Actualizar mínimo si encontramos uno menor

next:
    add x3, x3, #1
    b loop

end:
    mov x0, x2             // Retornar el mínimo
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
https://asciinema.org/a/690694
