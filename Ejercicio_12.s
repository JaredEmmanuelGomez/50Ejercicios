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
    yes_msg:    .asciz "It is a palindrome\n"
    no_msg:     .asciz "It is not a palindrome\n"
    buffer:     .skip 100

.text
.global _start

_start:
    // Print prompt
    mov     x0, #1          // file descriptor: 1 is stdout
    ldr     x1, =prompt     // address of prompt string
    mov     x2, #16         // length of prompt
    mov     x8, #64         // write syscall
    svc     #0

    // Read input
    mov     x0, #0          // file descriptor: 0 is stdin
    ldr     x1, =buffer     // address of buffer
    mov     x2, #100        // maximum length
    mov     x8, #63         // read syscall
    svc     #0

    // Save string length
    sub     x19, x0, #1     // length minus newline
    
    // Setup for palindrome check
    ldr     x20, =buffer    // start pointer
    add     x21, x20, x19   // end pointer
    sub     x21, x21, #1    // adjust end pointer

loop:
    cmp     x20, x21        // compare pointers
    bge     palindrome      // if crossed, it's a palindrome
    
    ldrb    w22, [x20]      // load char from start
    ldrb    w23, [x21]      // load char from end
    
    cmp     w22, w23        // compare characters
    bne     not_palindrome  // if not equal, not a palindrome
    
    add     x20, x20, #1    // move start pointer forward
    sub     x21, x21, #1    // move end pointer backward
    b       loop

palindrome:
    mov     x0, #1          // stdout
    ldr     x1, =yes_msg    // success message
    mov     x2, #19         // length of message
    mov     x8, #64         // write syscall
    svc     #0
    b       exit

not_palindrome:
    mov     x0, #1          // stdout
    ldr     x1, =no_msg     // failure message
    mov     x2, #23         // length of message
    mov     x8, #64         // write syscall
    svc     #0

exit:
    mov     x8, #93         // exit syscall
    mov     x0, #0          // return code 0
    svc     #0

ASCIINEMA REC
https://asciinema.org/a/690685
