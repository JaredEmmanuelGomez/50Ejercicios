# Lenguajes de Interfaz - Actividad 18
# Convertir binario a decimal
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ----------------------------------------
/*
def binario_a_decimal(binario):
    return int(binario, 2)
*/
# -----------------------------------------

//Gomez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter a binary number: "
    outfmt:     .asciz "Decimal: %ld\n"
    scanfmt:    .asciz "%s"
    error_msg:  .asciz "Invalid binary number\n"
    buffer:     .skip 65            // Buffer for binary input (64 bits + null)

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

    // Initialize result
    mov     x19, #0               // Result
    adrp    x20, buffer
    add     x20, x20, :lo12:buffer

convert_loop:
    ldrb    w21, [x20], #1        // Load next character
    cbz     w21, done             // If null terminator, we're done

    // Check if valid binary digit
    cmp     w21, #'0'
    b.lt    invalid
    cmp     w21, #'1'
    b.gt    invalid

    // Shift result left and add new bit
    lsl     x19, x19, #1
    sub     w21, w21, #'0'
    add     x19, x19, x21
    b       convert_loop

invalid:
    adrp    x0, error_msg
    add     x0, x0, :lo12:error_msg
    bl      printf
    mov     w0, #1
    b       exit

done:
    // Print result
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x19
    bl      printf

    mov     w0, #0

exit:
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
