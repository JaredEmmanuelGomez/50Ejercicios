# Lenguajes de Interfaz - Actividad 34
# Establecer, borrar y alternar bits
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Manipulación de bits

# -----------------------------------------
/*
def set_clear_toggle_bits(n, pos, action):
    if action == "set":
        return n | (1 << pos)
    elif action == "clear":
        return n & ~(1 << pos)
    elif action == "toggle":
        return n ^ (1 << pos)
*/
# -------------------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    // Mensajes para mostrar las operaciones
    msg_original:  .ascii "Número original: "
    len_orig = . - msg_original
    
    msg_set:       .ascii "\nDespués de establecer bit: "
    len_set = . - msg_set
    
    msg_clear:     .ascii "\nDespués de borrar bit: "
    len_clear = . - msg_clear
    
    msg_toggle:    .ascii "\nDespués de alternar bit: "
    len_toggle = . - msg_toggle
    
    newline:       .ascii "\n"
    
    // Número para realizar las operaciones
    numero: .quad 0x5A    // Valor inicial 01011010 en binario

.text
.global _start

_start:
    // Mostrar número original
    mov x0, #1
    adr x1, msg_original
    mov x2, len_orig
    mov x8, #64
    svc #0
    
    // Cargar y mostrar número original
    adr x19, numero
    ldr x20, [x19]        // x20 contendrá nuestro número de trabajo
    mov x0, x20
    bl print_binary
    
    // Establecer bit 3 (1 << 3 = 8)
    mov x21, #1
    lsl x21, x21, #3      // Desplazar 1 a la posición 3
    orr x20, x20, x21     // OR para establecer el bit
    
    // Mostrar resultado después de establecer
    mov x0, #1
    adr x1, msg_set
    mov x2, len_set
    mov x8, #64
    svc #0
    
    mov x0, x20
    bl print_binary
    
    // Borrar bit 5 (1 << 5 = 32)
    mov x21, #1
    lsl x21, x21, #5      // Desplazar 1 a la posición 5
    mvn x21, x21          // Invertir bits
    and x20, x20, x21     // AND para borrar el bit
    
    // Mostrar resultado después de borrar
    mov x0, #1
    adr x1, msg_clear
    mov x2, len_clear
    mov x8, #64
    svc #0
    
    mov x0, x20
    bl print_binary
    
    // Alternar bit 4 (1 << 4 = 16)
    mov x21, #1
    lsl x21, x21, #4      // Desplazar 1 a la posición 4
    eor x20, x20, x21     // XOR para alternar el bit
    
    // Mostrar resultado después de alternar
    mov x0, #1
    adr x1, msg_toggle
    mov x2, len_toggle
    mov x8, #64
    svc #0
    
    mov x0, x20
    bl print_binary
    
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

// Subrutina para imprimir un número en binario
print_binary:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0           // Guardar número a imprimir
    mov x20, #8           // Contador de bits (imprimiremos 8 bits)
    
print_loop:
    // Verificar el bit más significativo
    mov x0, x19
    and x0, x0, #0x80
    cmp x0, #0
    beq print_zero
    
print_one:
    mov x0, #1            // stdout
    adr x1, one_char
    b print_bit
    
print_zero:
    mov x0, #1            // stdout
    adr x1, zero_char
    
print_bit:
    mov x2, #1            // longitud 1 byte
    mov x8, #64           // write syscall
    svc #0
    
    // Desplazar número a la izquierda
    lsl x19, x19, #1
    
    // Decrementar contador y continuar si no es cero
    subs x20, x20, #1
    bne print_loop
    
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

.data
    one_char:  .ascii "1"
    zero_char: .ascii "0"

ASCIINEMA
https://asciinema.org/a/688635

