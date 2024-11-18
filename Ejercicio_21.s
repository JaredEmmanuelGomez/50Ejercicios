# Lenguajes de Interfaz - Actividad 21
# Serie de Fibonacci
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Bucles y manejo de memoria

# -------------------------------
/*
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        print(a, end=' ')
        a, b = b, a + b
*/
# -------------------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    prompt:     .asciz "Enter number of Fibonacci terms to generate: "
    outfmt:     .asciz "Term %d: %ld\n"
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

    // Initialize Fibonacci
    mov     x19, #0              // First number
    mov     x20, #1              // Second number
    mov     x21, #1              // Counter
    adrp    x22, number
    add     x22, x22, :lo12:number
    ldr     x22, [x22]          // Number of terms

    // Print first term if n > 0
    cmp     x22, #0
    b.le    exit
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x21
    mov     x2, x19
    bl      printf

fib_loop:
    add     x21, x21, #1         // Increment counter
    cmp     x21, x22
    b.gt    exit                // If counter > n, exit

    // Print current term
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x21
    mov     x2, x20
    bl      printf

    // Calculate next term
    add     x23, x19, x20        // Next = first + second
    mov     x19, x20             // First = second
    mov     x20, x23             // Second = next
    b       fib_loop

exit:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
