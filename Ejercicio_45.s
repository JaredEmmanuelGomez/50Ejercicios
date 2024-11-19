# Lenguajes de Interfaz - Actividad 45
# Generación de números aleatorios (con semilla)
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Generación de números pseudoaleatorios

# --------------------------------------
/*
import random

def random_number(seed=None):
    random.seed(seed)
    return random.randint(0, 100)
*/
# --------------------------------------


.data
    header:     .asciz "\n\n"
                .asciz "     Generador de Números Aleatorios   \n"
                .asciz "\n"
    msg_seed:   .asciz "\n→ Ingrese la semilla (número): "
    msg_cant:   .asciz "→ Cantidad de números a generar: "
    msg_result: .asciz "\n═══ Números Generados ═══\n\n"
    msg_num:    .ascii "  ⚀ Número generado: "            // Cambiado a .ascii
    buffer:     .skip 16
    newline:    .asciz "\n"
    footer:     .asciz "\n\n"

.bss
    num_buffer: .skip 12

.text
.global _start

// Constantes
.equ MULT, 1597
.equ INC,  51
.equ MOD,  1000

_start:
    // Mostrar header
    mov x0, #1              // stdout
    ldr x1, =header        // mensaje
    mov x2, #150           // longitud
    mov x8, #64            // syscall write
    svc #0

    // Pedir semilla
    mov x0, #1
    ldr x1, =msg_seed
    mov x2, #29
    mov x8, #64
    svc #0

    // Leer semilla
    mov x0, #0             // stdin
    ldr x1, =buffer
    mov x2, #16
    mov x8, #63            // syscall read
    svc #0

    // Convertir semilla a número
    bl str_to_int
    mov x19, x0

    // Pedir cantidad
    mov x0, #1
    ldr x1, =msg_cant
    mov x2, #31
    mov x8, #64
    svc #0

    // Leer cantidad
    mov x0, #0
    ldr x1, =buffer
    mov x2, #16
    mov x8, #63
    svc #0

    // Convertir cantidad a número
    bl str_to_int
    mov x20, x0

    // Mostrar título de resultados
    mov x0, #1
    ldr x1, =msg_result
    mov x2, #30
    mov x8, #64
    svc #0

generate_loop:
    // Verificar si terminamos
    cmp x20, #0
    beq print_footer
    sub x20, x20, #1

    // Generar número aleatorio
    mov x1, #MULT
    mul x19, x19, x1
    add x19, x19, #INC
    mov x1, #MOD
    udiv x2, x19, x1
    msub x19, x2, x1, x19

    // Imprimir prefijo del mensaje
    mov x0, #1
    ldr x1, =msg_num
    mov x2, #22            // Longitud exacta del prefijo
    mov x8, #64
    svc #0

    // Convertir y mostrar número
    mov x0, x19
    bl int_to_str

    // Nueva línea
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    b generate_loop

str_to_int:
    mov x3, #0              // resultado
    ldr x1, =buffer         // puntero al buffer
    mov x4, #10             // base 10

convert_loop:
    ldrb w2, [x1], #1      // cargar byte
    cmp w2, #'\n'          // verificar fin
    beq convert_done
    sub w2, w2, #'0'       // convertir a número
    mul x3, x3, x4         // multiplicar por 10
    add x3, x3, x2         // añadir dígito
    b convert_loop

convert_done:
    mov x0, x3             // retornar resultado
    ret

int_to_str:
    // Guardar número original
    mov x3, x0
    
    // Preparar buffer
    ldr x4, =num_buffer
    mov x2, #0             // contador de dígitos
    mov x5, #10            // divisor

    // Convertir a string
convert_digits:
    udiv x6, x3, x5        // dividir por 10
    msub x7, x6, x5, x3    // obtener residuo
    add w7, w7, #'0'       // convertir a ASCII
    strb w7, [x4, x2]      // guardar dígito
    add x2, x2, #1         // incrementar contador
    mov x3, x6             // actualizar para siguiente división
    cbnz x3, convert_digits

    // Invertir dígitos
    mov x6, #0             // índice inicio
    sub x7, x2, #1         // índice final

reverse_loop:
    cmp x6, x7
    bge print_result
    ldrb w8, [x4, x6]      // cargar byte inicio
    ldrb w9, [x4, x7]      // cargar byte final
    strb w9, [x4, x6]      // intercambiar bytes
    strb w8, [x4, x7]
    add x6, x6, #1
    sub x7, x7, #1
    b reverse_loop

print_result:
    mov x0, #1             // stdout
    mov x1, x4             // buffer con número
    mov x8, #64            // syscall write
    svc #0
    ret

print_footer:
    mov x0, #1
    ldr x1, =footer
    mov x2, #22
    mov x8, #64
    svc #0
    b exit

exit:
    mov x0, #0
    mov x8, #93
    svc #0
