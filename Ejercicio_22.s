# Lenguajes de Interfaz - Actividad 22
# Encontrar el máximo en un arreglo
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador
# Recorrido de arreglos

# ---------------------
/*
def find_max(arr):
    return max(arr)
*/
# --------------------

// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    size_prompt:    .asciz "Enter the size of array: "
    elem_prompt:    .asciz "Enter element %d: "
    outfmt:         .asciz "Maximum element is: %ld\n"
    scanfmt:        .asciz "%ld"
    array:          .skip 400       // Space for 50 long integers
    size:           .quad 0

.text
    .global main
    .align 2

main:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Print size prompt
    adrp    x0, size_prompt
    add     x0, x0, :lo12:size_prompt
    bl      printf

    // Read size
    adrp    x0, scanfmt
    add     x0, x0, :lo12:scanfmt
    adrp    x1, size
    add     x1, x1, :lo12:size
    bl      scanf

    // Initialize array input
    mov     x19, #0               // Counter
    adrp    x20, array           // Array base address
    add     x20, x20, :lo12:array
    adrp    x21, size
    add     x21, x21, :lo12:size
    ldr     x21, [x21]           // Size value

input_loop:
    cmp     x19, x21
    b.ge    find_max            // If counter >= size, find maximum

    // Print element prompt
    adrp    x0, elem_prompt
    add     x0, x0, :lo12:elem_prompt
    add     x1, x19, #1          // Element number (1-based)
    bl      printf

    // Read element
    adrp    x0, scanfmt
    add     x0, x0, :lo12:scanfmt
    mov     x1, x20              // Current array position
    bl      scanf

    add     x20, x20, #8         // Move to next array position
    add     x19, x19, #1         // Increment counter
    b       input_loop

find_max:
    // Initialize max with first element
    adrp    x20, array
    add     x20, x20, :lo12:array
    ldr     x22, [x20]           // Maximum value
    mov     x19, #1              // Start counter from 1
    add     x20, x20, #8         // Move to second element

max_loop:
    cmp     x19, x21
    b.ge    print_result         // If counter >= size, print result
    
    ldr     x23, [x20], #8       // Load value and increment pointer
    cmp     x23, x22
    b.le    next_iter            // If current <= max, continue
    mov     x22, x23             // Update max if current > max

next_iter:
    add     x19, x19, #1         // Increment counter
    b       max_loop

print_result:
    // Print maximum
    adrp    x0, outfmt
    add     x0, x0, :lo12:outfmt
    mov     x1, x22
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
