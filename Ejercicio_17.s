# Lenguajes de Interfaz - Actividad 17
# Suma de los N primeros números naturales
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# -----------------------------------------
/*
def suma_numeros_naturales(n):
    return n * (n + 1) // 2
*/
# -----------------------------------------

//Gomez Aguilar Jared Emmanuel
//22210309
.data
    prompt:     .asciz "Enter N (number of natural numbers to sum): "
    outfmt:     .asciz "Sum of first %ld numbers is: %ld\n"
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

    // Load number and initialize sum
    adrp    x19, number
    add     x19, x19, :lo12:number
    ldr     x19, [x19]            // N value
    mov     x20, #0               // Sum
    mov     x21, #1               // Counter

sum_loop:
    cmp     x21, x19
    b.gt    print_result          // If counter > N, we're done
    add     x20, x20, x21         // Add counter to sum
    add     x21, x21, #1          // Increment counter
    b       sum_loop

print_result:
    // Print result
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x19               // N value
    mov     x2, x20               // Sum
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
