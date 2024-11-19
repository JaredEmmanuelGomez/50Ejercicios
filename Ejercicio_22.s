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
.data
    msgSize:    .ascii "Ingrese el tamaño del arreglo: "
    lenSize = . - msgSize
    msgInput:   .ascii "Ingrese el número "
    lenInput = . - msgInput
    msgColon:   .ascii ": "
    lenColon = . - msgColon
    msgMax:     .ascii "\nEl valor máximo es: "
    lenMax = . - msgMax
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

// Mostrar número de elemento
mov x0, x20
add x0, x0, #1         // Mostrar índice + 1 para ser más amigable
ldr x1, =buffer
bl numero_a_string

mov x0, #1
ldr x1, =buffer
mov x8, #64
svc #0

// Mostrar ": "
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

// Convertir y guardar en el arreglo
ldr x1, =buffer
bl string_to_number
str x0, [x21, x20, lsl #3]  // Guardar en array[i]

add x20, x20, #1
b input_loop

input_done:
    // Encontrar el máximo
    ldr x0, =array         // Dirección base del arreglo
    mov x1, x19           // Tamaño del arreglo
    bl find_maximum
    mov x19, x0           // Guardar el máximo

// Mostrar mensaje del máximo
mov x0, #1
ldr x1, =msgMax
mov x2, lenMax
mov x8, #64
svc #0

// Mostrar el valor máximo
mov x0, x19
ldr x1, =buffer
bl numero_a_string

mov x0, #1
ldr x1, =buffer
mov x8, #64
svc #0

// Nueva línea
mov x0, #1
ldr x1, =newline
mov x2, #1
mov x8, #64
svc #0

salir:
    mov x0, #0
    mov x8, #93
    svc #0

find_maximum:
    // x0 = dirección base del arreglo
    // x1 = tamaño del arreglo
    ldr x2, [x0]           // x2 = primer elemento (máximo inicial)
    mov x3, #1             // x3 = índice actual

max_loop:
    cmp x3, x1
    beq max_done

ldr x4, [x0, x3, lsl #3]
cmp x4, x2
ble next_element
mov x2, x4             // Actualizar máximo si encontramos uno mayor

next_element:
    add x3, x3, #1
    b max_loop

max_done:
    mov x0, x2             // Retornar el máximo
    ret

string_to_number:
    // x1 = dirección del string
    mov x0, #0              // Resultado
    mov x2, #10             // Base 10

convert_loop:
    ldrb w3, [x1], #1      // Cargar siguiente carácter
    cmp w3, #'\n'
    beq convert_done
    cmp w3, #0
    beq convert_done

sub w3, w3, #'0'       // Convertir ASCII a número
mul x0, x0, x2         // Multiplicar resultado por 10
add x0, x0, x3         // Añadir nuevo dígito
b convert_loop

convert_done:
    ret

numero_a_string:
    // x0 = número a convertir
    // x1 = dirección del buffer
    mov x2, #10            // Divisor
    mov x3, x1             // Guardar inicio del buffer
    
toString_loop:
    udiv x4, x0, x2        // x4 = x0 / 10
    msub x5, x4, x2, x0    // x5 = x0 - (x4 * 10) = residuo
    add x5, x5, #'0'       // Convertir a ASCII
    strb w5, [x1], #1      // Guardar dígito y avanzar
    mov x0, x4             // Preparar para siguiente división
    cbnz x0, toString_loop // Continuar si el cociente no es cero

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
https://asciinema.org/a/690690
