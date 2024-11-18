# Lenguajes de Interfaz - Actividad 14
# Conversión de decimal a hexadecimal
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# -----------------------------------------
/*
def decimal_a_hexadecimal(decimal):
    return hex(decimal)[2:]
*/
# -----------------------------------------

//Gómez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter a decimal number: "
    outfmt:     .asciz "Hexadecimal: %s\n"
    scanfmt:    .asciz "%ld"
    number:     .quad 0
    hexchars:   .asciz "0123456789ABCDEF"
    buffer:     .skip 17            // Buffer for hex result (16 chars + null)

.text
    .global main
    .align 2

main:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Print prompt
    adrp    x0, prompt
    add     x0, x0, :lo12:prompt
    bl      printf

    // Read input
    adrp    x0, scanfmt
    add     x0, x0, :lo12:scanfmt
    adrp    x1, number
    add     x1, x1, :lo12:number
    bl      scanf

    // Load number and prepare buffer
    adrp    x19, number
    add     x19, x19, :lo12:number
    ldr     x19, [x19]            // Number to convert
    
    adrp    x20, buffer
    add     x20, x20, :lo12:buffer
    add     x20, x20, #16         // Go to end of buffer
    mov     w21, #0
    strb    w21, [x20]            // Null terminator
    sub     x20, x20, #1

    adrp    x23, hexchars
    add     x23, x23, :lo12:hexchars

convert_loop:
    and     x21, x19, #15         // Get least significant 4 bits
    ldr     x22, [x23, x21]       // Load corresponding hex char
    strb    w22, [x20], #-1       // Store char
    lsr     x19, x19, #4          // Shift right by 4
    cbnz    x19, convert_loop     // Continue if number not zero

    // Print result
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    add     x1, x20, #1           // Point to start of string
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
