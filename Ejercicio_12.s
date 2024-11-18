# Lenguajes de Interfaz - Actividad 12
# Verificar si una cadena es palíndromo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

#-------------------------------------------
/*
def es_palindromo(cadena):
    cadena = cadena.replace(" ", "").lower()
    return cadena == cadena[::-1]
*/
#-------------------------------------------

//Gómez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter a string: "
    yes_msg:    .asciz "The string is a palindrome\n"
    no_msg:     .asciz "The string is not a palindrome\n"
    scanfmt:    .asciz "%s"
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

    // Check palindrome
    mov     x21, x19                // Start pointer
    add     x22, x19, x20          // End pointer

check_loop:
    cmp     x21, x22
    b.hs    is_palindrome          // If pointers meet or cross, it's a palindrome
    
    ldrb    w23, [x21]
    ldrb    w24, [x22]
    cmp     w23, w24
    b.ne    not_palindrome         // If characters don't match, not a palindrome
    add     x21, x21, #1
    sub     x22, x22, #1
    b       check_loop

is_palindrome:
    adrp    x0, yes_msg
    add     x0, x0, :lo12:yes_msg
    bl      printf
    b       done

not_palindrome:
    adrp    x0, no_msg
    add     x0, x0, :lo12:no_msg
    bl      printf

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
