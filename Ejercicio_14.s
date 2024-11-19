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
    hex_prefix: .asciz "0x"
    buffer:     .skip   20
    result:     .skip   33
    newline:    .asciz "\n"

.text
.global _start

_start:
    // Print prompt
    mov     x0, #1              // stdout
    adr     x1, prompt
    mov     x2, #24             // length of prompt
    mov     x8, #64             // sys_write
    svc     #0

    // Read input
    mov     x0, #0              // stdin
    adr     x1, buffer
    mov     x2, #20             // buffer size
    mov     x8, #63             // sys_read
    svc     #0

    // Convert ASCII to integer
    adr     x1, buffer
    mov     x2, #0              // result
    mov     x3, #10             // multiplier
convert_loop:
    ldrb    w4, [x1]
    cmp     w4, #'\n'
    beq     convert_done
    sub     w4, w4, #'0'
    mul     x2, x2, x3
    add     x2, x2, x4
    add     x1, x1, #1
    b       convert_loop

convert_done:
    // Convert to hexadecimal
    adr     x1, result
    
    // Add hex prefix
    mov     x4, #'0'
    strb    w4, [x1]
    add     x1, x1, #1
    mov     x4, #'x'
    strb    w4, [x1]
    add     x1, x1, #1

    // Conversion loop
    mov     x3, #28             // Start from most significant nibble
hex_loop:
    lsr     x4, x2, x3          // Shift right
    and     x4, x4, #0xF        // Mask to get 4 bits
    
    // Convert to hex digit
    cmp     x4, #10
    blo     digit
    add     x4, x4, #('A' - 10)
    b       store_hex
digit:
    add     x4, x4, #'0'
store_hex:
    strb    w4, [x1]
    add     x1, x1, #1
    
    // Check if done
    subs    x3, x3, #4
    bhs     hex_loop

    // Add newline
    mov     w4, #'\n'
    strb    w4, [x1]

    // Print result
    mov     x0, #1              // stdout
    adr     x1, result
    sub     x2, x1, x1          // Calculate length
    add     x2, x2, #10         // Add length manually
    mov     x8, #64             // sys_write
    svc     #0

exit:
    mov     x0, #0              // return 0
    mov     x8, #93             // sys_exit
    svc     #0

ASCIINEMA REC

