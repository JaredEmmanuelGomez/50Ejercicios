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
.global main
.text

main:
    // Guardamos el link register
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializamos un número para manipular sus bits
    mov     x19, #10         // x19 = 10 (1010 en binario)

    // Imprimir valor original
    adr     x0, msg1
    mov     x1, x19
    bl      printf

    // ESTABLECER BIT (Usando OR)
    // Establecemos el bit 1 (segundo bit)
    // 1010 OR 0010 = 1010 (no cambia porque ya estaba en 1)
    mov     x20, x19        // Copiamos el valor original
    mov     x4, #2          // Creamos la máscara para el bit 1
    orr     x20, x20, x4    // Establecer bit 1
    
    // Imprimir resultado después de establecer bit
    adr     x0, msg2
    mov     x1, x20
    bl      printf

    // BORRAR BIT (Usando AND con máscara invertida)
    // Borramos el bit 1 (segundo bit)
    mov     x21, x19        // Copiamos el valor original
    mov     x4, #2          // Bit que queremos borrar
    mvn     x4, x4          // Invertimos la máscara
    and     x21, x21, x4    // Borrar bit 1
    
    // Imprimir resultado después de borrar bit
    adr     x0, msg3
    mov     x1, x21
    bl      printf

    // ALTERNAR BIT (Usando XOR)
    // Alternamos el bit 3 (cuarto bit)
    // 1010 XOR 1000 = 0010
    mov     x22, x19        // Copiamos el valor original
    mov     x4, #8          // Creamos la máscara para el bit 3
    eor     x22, x22, x4    // Alternar bit 3
    
    // Imprimir resultado después de alternar bit
    adr     x0, msg4
    mov     x1, x22
    bl      printf

    // Restauramos el stack y retornamos
    ldp     x29, x30, [sp], #16
    mov     w0, #0
    ret

.section .rodata
msg1:
    .string "Valor original en decimal (binario 1010): %d\n"
msg2:
    .string "Después de establecer bit 1: %d\n"
msg3:
    .string "Después de borrar bit 1: %d\n"
msg4:
    .string "Después de alternar bit 3: %d\n"


ASCIINEMA
https://asciinema.org/a/688635

