# Lenguajes de Interfaz - Actividad 16
# Factorial de un número
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# --------------------------------------
/*
def factorial(n):
    resultado = 1
    for i in range(1, n + 1):
        resultado *= i
    return resultado
*/
# --------------------------------------

//Gómez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter a number to calculate factorial: "
    buffer:     .skip   20
    result:     .skip   64      // Larger buffer for big results
    newline:    .asciz "\n"
    error_msg:  .asciz "Factorial not defined for numbers > 20\n"

.text
.global _start

_start:
    // Print prompt
    mov     x0, #1              // stdout
    adr     x1, prompt
    mov     x2, #40             // length of prompt
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
    // Check for valid input
    cmp     x2, #20
    bhi     error_case

    // Calculate factorial
    mov     x3, x2              // n
    mov     x4, #1              // result
    cbz     x3, factorial_done  // 0! = 1

factorial_loop:
    mul     x4, x4, x3
    subs    x3, x3, #1
    bne     factorial_loop

factorial_done:
    // Convert result to ASCII
    adr     x1, result
    mov     x3, #10             // Divisor
    mov     x5, #0              // Digit counter

convert_to_ascii:
    udiv    x6, x4, x3          // Divide by 10
    msub    x7, x6, x3, x4      // Get remainder
    add     x7, x7, #'0'        // Convert to ASCII
    strb    w7, [x1, x5]        // Store digit
    add     x5, x5, #1          // Increment counter
    mov     x4, x6              // Update number
    cbnz    x4, convert_to_ascii

    // Reverse the string
    mov     x6, #0              // Start index
    sub     x7, x5, #1          // End index
reverse_loop:
    cmp     x6, x7
    bhs     reverse_done
    ldrb    w8, [x1, x6]
    ldrb    w9, [x1, x7]
    strb    w9, [x1, x6]
    strb    w8, [x1, x7]
    add     x6, x6, #1
    sub     x7, x7, #1
    b       reverse_loop

reverse_done:
    // Add newline
    strb    w3, [x1, x5]
    mov     w3, #'\n'
    strb    w3, [x1, x5]

    // Print result
    mov     x0, #1              // stdout
    adr     x1, result
    add     x2, x5, #1          // Length including newline
    mov     x8, #64             // sys_write
    svc     #0
    b       exit

error_case:
    // Print error message
    mov     x0, #1              // stdout
    adr     x1, error_msg
    mov     x2, #38             // length of error message
    mov     x8, #64             // sys_write
    svc     #0

exit:
    mov     x0, #0              // return 0
    mov     x8, #93             // sys_exit
    svc     #0

ASCIINEMA REC
https://asciinema.org/a/690912
