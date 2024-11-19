# Lenguajes de Interfaz - Actividad 32
# Operaciones AND, OR, XOR a nivel de bits
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Operaciones a nivel de bits

# -----------------------------------
/*
def bitwise_operations(a, b):
    return a & b, a | b, a ^ b
*/
# -----------------------------------

// Gómez Aguilar Jared Emmanuek
// 22210309
.data
    msg1:    .ascii "Primer número:  "
    len1 = . - msg1
    msg2:    .ascii "\nSegundo número: "
    len2 = . - msg2
    msg_and: .ascii "\nOperación AND: "
    len_and = . - msg_and
    msg_or:  .ascii "\nOperación OR:  "
    len_or = . - msg_or
    msg_xor: .ascii "\nOperación XOR: "
    len_xor = . - msg_xor
    newline: .ascii "\n"
    
    // Números de ejemplo (puedes cambiarlos)
    num1:    .quad 12    // 1100 en binario
    num2:    .quad 10    // 1010 en binario

.text
.global _start

_start:
    // Mostrar mensaje para primer número
    mov x0, #1
    adr x1, msg1
    mov x2, len1
    mov x8, #64
    svc #0
    
    // Mostrar primer número
    adr x0, num1
    ldr x0, [x0]
    bl imprimir_binario
    
    // Mostrar mensaje para segundo número
    mov x0, #1
    adr x1, msg2
    mov x2, len2
    mov x8, #64
    svc #0
    
    // Mostrar segundo número
    adr x0, num2
    ldr x0, [x0]
    bl imprimir_binario
    
    // Realizar operación AND
    mov x0, #1
    adr x1, msg_and
    mov x2, len_and
    mov x8, #64
    svc #0
    
    adr x0, num1
    ldr x0, [x0]
    adr x1, num2
    ldr x1, [x1]
    and x0, x0, x1
    bl imprimir_binario
    
    // Realizar operación OR
    mov x0, #1
    adr x1, msg_or
    mov x2, len_or
    mov x8, #64
    svc #0
    
    adr x0, num1
    ldr x0, [x0]
    adr x1, num2
    ldr x1, [x1]
    orr x0, x0, x1
    bl imprimir_binario
    
    // Realizar operación XOR
    mov x0, #1
    adr x1, msg_xor
    mov x2, len_xor
    mov x8, #64
    svc #0
    
    adr x0, num1
    ldr x0, [x0]
    adr x1, num2
    ldr x1, [x1]
    eor x0, x0, x1
    bl imprimir_binario
    
    // Nueva línea final
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc #0

imprimir_binario:
    // x0 = número a imprimir
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0           // Guardar número
    mov x20, #63          // Contador de bits (64-1)
    
    // Reservar espacio en el stack para el string binario
    sub sp, sp, #70       // 64 bits + algunos extras
    mov x2, sp           // Puntero al buffer
    
print_bits:
    lsr x1, x19, x20     // Desplazar a la derecha
    and x1, x1, #1       // Obtener el bit menos significativo
    add w1, w1, #'0'     // Convertir a ASCII
    strb w1, [x2]        // Guardar el carácter
    add x2, x2, #1       // Siguiente posición
    
    sub x20, x20, #1     // Decrementar contador
    cmp x20, #-1         // Verificar si terminamos
    bge print_bits
    
    // Imprimir el número binario
    mov x0, #1           // stdout
    mov x1, sp           // buffer
    mov x2, #64          // longitud
    mov x8, #64          // write syscall
    svc #0
    
    // Restaurar stack y registros
    add sp, sp, #70
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret


ASCIINEMA REC
https://asciinema.org/a/690732
