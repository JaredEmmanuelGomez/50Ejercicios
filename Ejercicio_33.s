# Lenguajes de Interfaz - Actividad 33
# Desplazamientos a la izquierda y derecha
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Operaciones de desplazamiento

# ----------------------------
/*
def bit_shifts(n, shift):
    return n << shift, n >> shift
*/
# ----------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    msg1:    .ascii "Número original: "
    len1 = . - msg1
    msg2:    .ascii "\nDesplazamiento a la izquierda por "
    len2 = . - msg2
    msg3:    .ascii " posiciones: "
    len3 = . - msg3
    msg4:    .ascii "\nDesplazamiento a la derecha por "
    len4 = . - msg4
    numero:  .quad 12            // Número de ejemplo
    pos:     .quad 2             // Posiciones a desplazar
    buffer:  .skip 65            // Buffer para string binario
    newline: .ascii "\n"

.text
.global _start

_start:
    // Mostrar mensaje inicial
    mov x0, #1
    adr x1, msg1
    mov x2, len1
    mov x8, #64
    svc #0
    
    // Mostrar número original en binario
    adr x0, numero
    ldr x0, [x0]
    bl imprimir_binario
    
    // Nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Desplazamiento a la izquierda
    mov x0, #1
    adr x1, msg2
    mov x2, len2
    mov x8, #64
    svc #0
    
    // Mostrar cantidad de posiciones
    adr x0, pos
    ldr x0, [x0]
    bl imprimir_numero
    
    mov x0, #1
    adr x1, msg3
    mov x2, len3
    mov x8, #64
    svc #0
    
    // Realizar y mostrar LSL
    adr x0, numero
    ldr x0, [x0]
    adr x1, pos
    ldr x1, [x1]
    lsl x0, x0, x1
    bl imprimir_binario
    
    // Nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Desplazamiento a la derecha
    mov x0, #1
    adr x1, msg4
    mov x2, len4
    mov x8, #64
    svc #0
    
    // Mostrar cantidad de posiciones
    adr x0, pos
    ldr x0, [x0]
    bl imprimir_numero
    
    mov x0, #1
    adr x1, msg3
    mov x2, len3
    mov x8, #64
    svc #0
    
    // Realizar y mostrar LSR
    adr x0, numero
    ldr x0, [x0]
    adr x1, pos
    ldr x1, [x1]
    lsr x0, x0, x1
    bl imprimir_binario
    
    // Nueva línea final
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Salir
    mov x0, #0
    mov x8, #93
    svc #0

imprimir_binario:
    // x0 = número a imprimir
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0           // Guardar número
    mov x20, #31          // 32 bits
    
    // Reservar espacio para el string binario
    sub sp, sp, #40
    mov x2, sp           // Puntero al buffer
    mov x3, x2           // Guardar inicio del buffer
    
print_bits:
    lsr x1, x19, x20
    and x1, x1, #1
    add w1, w1, #'0'
    strb w1, [x2], #1    // Almacenar y avanzar puntero
    
    // Espacio cada 4 bits
    mov x4, x20
    add x4, x4, #1
    and x4, x4, #3
    cbnz x4, skip_space
    mov w1, #' '
    strb w1, [x2], #1
    
skip_space:
    sub x20, x20, #1
    cmp x20, #-1
    bge print_bits
    
    // Calcular longitud
    sub x2, x2, x3       // Longitud = posición actual - inicio
    
    // Imprimir
    mov x0, #1
    mov x1, x3           // Usar el inicio del buffer
    mov x8, #64
    svc #0
    
    add sp, sp, #40
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

imprimir_numero:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    
    mov x19, x0          // Guardar número original
    mov x20, #0          // Contador de dígitos
    mov x21, #10         // Divisor
    
    // Si es 0, imprimir directamente
    cbnz x19, not_zero
    mov w4, #'0'
    sub sp, sp, #1
    strb w4, [sp]
    mov x1, sp
    mov x2, #1
    mov x0, #1
    mov x8, #64
    svc #0
    add sp, sp, #1
    b imprimir_numero_fin
    
not_zero:
    // Contar dígitos
    mov x0, x19
count_loop:
    cbz x0, convert_start
    udiv x0, x0, x21     // División por 10 usando registro
    add x20, x20, #1
    b count_loop
    
convert_start:
    // Convertir a ASCII
    sub sp, sp, x20      // Reservar espacio para los dígitos
    mov x2, sp           // Puntero al buffer
    mov x0, x19          // Recuperar número original
    mov x1, x20          // Contador de dígitos
    
convert_loop:
    udiv x3, x0, x21     // División por 10 usando registro
    msub x4, x3, x21, x0 // Residuo
    add w4, w4, #'0'
    sub x1, x1, #1
    strb w4, [x2, x1]
    mov x0, x3
    cbnz x1, convert_loop
    
    // Imprimir número
    mov x0, #1
    mov x1, sp
    mov x2, x20
    mov x8, #64
    svc #0
    
    add sp, sp, x20
    
imprimir_numero_fin:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

ASCIINEMA REC
https://asciinema.org/a/690734
