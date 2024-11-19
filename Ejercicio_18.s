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
    buffer:     .skip   33      // 32 bits + newline
    result:     .skip   33
    newline:    .asciz "\n"
    error_msg:  .asciz "Invalid binary number\n"

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
    mov     x2, #33             // buffer size
    mov     x8, #63             // sys_read
    svc     #0

    // Convert binary to decimal
    adr     x1, buffer
    mov     x2, #0              // result
    mov     x3, #0              // counter

convert_loop:
    ldrb    w4, [x1]
    cmp     w4, #'\n'
    beq     convert_done

    // Validate binary digit
    cmp     w4, #'0'
    blo     error
    cmp     w4, #'1'
    bhi     error

    // Convert binary digit
    sub     w4, w4, #'0'
    lsl     x2, x2, #1          // Shift left
    orr     x2, x2, x4          // Add current bit
    
    add     x1, x1, #1
    add     x3, x3, #1
    b       convert_loop

convert_done:
    // Convert decimal to ASCII
    adr     x1, result
    mov     x3, #10             // Divisor
    mov     x4, #0              // Digit counter

convert_to_ascii:
    udiv    x5, x2, x3          // Divide by 10
    msub    x6, x5, x3, x2      // Get remainder
    add     x6, x6, #'0'        // Convert to ASCII
    strb    w6, [x1, x4]        // Store digit
    add     x4, x4, #1          // Increment counter
    mov     x2, x5              // Update number
    cbnz    x2, convert_to_ascii

    // Reverse the string
    mov     x5, #0              // Start index
    sub     x6, x4, #1          // End index
reverse_loop:
    cmp     x5, x6
    bhs     reverse_done
    ldrb    w7, [x1, x5]
    ldrb    w8, [x1, x6]
    strb    w8, [x1, x5]
    strb    w7, [x1, x6]
    add     x5, x5, #1
    sub     x6, x6, #1
    b       reverse_loop

reverse_done:
    // Add newline
    strb    w3, [x1, x4]
    mov     w3, #'\n'
    strb    w3, [x1, x4]

    // Print result
    mov     x0, #1              // stdout
    adr     x1, result
    add     x2, x4, #1          // Length including newline
    mov     x8, #64             // sys_write
    svc     #0
    b       exit

error:
    // Print error message
    mov     x0, #1              // stdout
    adr     x1, error_msg
    mov     x2, #24             // length of error message
    mov     x8, #64             // sys_write
    svc     #0

exit:
    mov     x0, #0              // return 0
    mov     x8, #93             // sys_exit
    svc     #0


ASCIINEMA REC
https://asciinema.org/a/690920
