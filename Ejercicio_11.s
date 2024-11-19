# Lenguajes de Interfaz - Actividad 11
# Invertir una cadena
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ------------------------
/*
def invertir_cadena(cadena):
    return cadena[::-1]
*/
# --------------------------


//Alumno: Gómez Aguilar Jared Emmanuel 
//Número de Control: 22210309 
.data
    prompt:     .asciz "Enter a string: "
    scanfmt:    .asciz "%s"
    outfmt:     .asciz "Reversed: %s\n"
    buffer:     .skip 100           // Buffer for input string

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
    adrp    x1, buffer
    add     x1, x1, :lo12:buffer
    bl      scanf

    // Get string length
    adrp    x19, buffer
    add     x19, x19, :lo12:buffer   // Start of string
    mov     x20, x19                 // Copy start address

strlen_loop:
    ldrb    w21, [x20], #1
    cbnz    w21, strlen_loop
    sub     x20, x20, x19           // Length in x20
    sub     x20, x20, #2            // Adjust for null terminator

    // Now reverse the string
    mov     x21, x19                // Start pointer
    add     x22, x19, x20          // End pointer

reverse_loop:
    cmp     x21, x22
    b.hs    done
    
    // Swap characters
    ldrb    w23, [x21]
    ldrb    w24, [x22]
    strb    w24, [x21], #1
    strb    w23, [x22], #-1
    b       reverse_loop

done:
    // Print result
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x19
    bl      printf

    // Exit
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main

ASCIINEMA
https://asciinema.org/a/690670
