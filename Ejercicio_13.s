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
    prompt:     .string "Enter a decimal number: "
    prompt_len: .quad   . - prompt
    buffer:     .skip   20
    result:     .skip   33          // 32 bits + newline
    newline:    .string "\n"

.text
.global _start

_start:
    // Print prompt
    mov     x0, #1              // stdout
    adr     x1, prompt          // message to print
    ldr     x2, =prompt_len     // message length
    mov     x8, #64             // sys_write
    svc     #0

    // Read input
    mov     x0, #0              // stdin
    adr     x1, buffer          // buffer address
    mov     x2, #20             // buffer size
    mov     x8, #63             // sys_read
    svc     #0

    // Convert ASCII to integer
    adr     x1, buffer          // buffer address
    mov     x2, #0              // result
    mov     x3, #10             // multiplier

convert_loop:
    ldrb    w4, [x1]           // load character
    cmp     w4, #'\n'          // check for newline
    beq     convert_done
    sub     w4, w4, #'0'       // convert to number
    mul     x2, x2, x3         // multiply by 10
    add     x2, x2, x4         // add digit
    add     x1, x1, #1         // next character
    b       convert_loop

convert_done:
    // Convert to binary string
    adr     x1, result         // result buffer
    mov     x3, #32            // counter

binary_loop:
    sub     x3, x3, #1         // decrease counter
    lsr     x4, x2, x3         // shift right
    and     x4, x4, #1         // get last bit
    add     x4, x4, #'0'       // convert to ASCII
    strb    w4, [x1]           // store character
    add     x1, x1, #1         // next position
    cmp     x3, #0             // check if done
    bne     binary_loop

    // Add newline
    mov     w4, #'\n'
    strb    w4, [x1]

    // Print result
    mov     x0, #1             // stdout
    adr     x1, result         // result buffer
    mov     x2, #33            // length (32 + newline)
    mov     x8, #64            // sys_write
    svc     #0

exit:
    mov     x0, #0             // return 0
    mov     x8, #93            // sys_exit
    svc     #0

    
ASCIINEMA REC
https://asciinema.org/a/690687
