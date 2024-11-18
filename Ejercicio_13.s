# Lenguajes de Interfaz - Actividad 13
# Convertir decimal a binario
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador


# ------------------------------------
/*
def decimal_a_binario(decimal):
    return bin(decimal)[2:]
*/
# ------------------------------------

//Gómez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter a decimal number: "
    outfmt:     .asciz "Binary: %s\n"
    scanfmt:    .asciz "%ld"
    number:     .quad 0
    buffer:     .skip 65            // Buffer for binary result (64 bits + null)

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
    add     x20, x20, #64         // Go to end of buffer
    mov     w21, #0
    strb    w21, [x20]            // Null terminator
    sub     x20, x20, #1

convert_loop:
    and     x21, x19, #1          // Get least significant bit
    add     w21, w21, #'0'        // Convert to ASCII
    strb    w21, [x20], #-1       // Store digit
    lsr     x19, x19, #1          // Shift right
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
