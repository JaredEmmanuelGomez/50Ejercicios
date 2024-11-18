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
    outfmt:     .asciz "Factorial: %ld\n"
    scanfmt:    .asciz "%ld"
    number:     .quad 0

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

    // Load number and initialize result
    adrp    x19, number
    add     x19, x19, :lo12:number
    ldr     x19, [x19]            // Number to calculate factorial
    mov     x20, #1               // Result

factorial_loop:
    cbz     x19, print_result     // If counter is zero, we're done
    mul     x20, x20, x19         // Multiply result by counter
    sub     x19, x19, #1          // Decrement counter
    b       factorial_loop

print_result:
    // Print result
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x20
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
