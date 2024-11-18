# Lenguajes de Interfaz - Actividad 15
# Conversión de hexadecimal a decimal
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# ---------------------------------------
/*
def hexadecimal_a_decimal(hexadecimal):
    return int(hexadecimal, 16)
*/
# ---------------------------------------

//Gómez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter a hexadecimal number: "
    outfmt:     .asciz "Decimal: %ld\n"
    scanfmt:    .asciz "%s"
    buffer:     .skip 17            // Buffer for hex input (16 chars + null)

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

    // Shift result left by 4
    lsl     x19, x19, #4

    // Convert hex character to value
    cmp     w21, #'9'
    b.gt    letter
    sub     w21, w21, #'0'
    b       add_digit

letter:
    and     w21, w21, #0xDF      // Convert to uppercase
    sub     w21, w21, #'A'
    add     w21, w21, #10

add_digit:
    add     x19, x19, x21
    b       convert_loop

done:
    // Print result
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x19
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
