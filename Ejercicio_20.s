# Lenguajes de Interfaz - Actividad 20
# Búsqueda lineal
# Alumno: Gómez Aguilar Jared Emmanuel  
# Número de Control: 22210309  
# Python y Ensamblador

# -------------------------------------------
/*
def busqueda_lineal(arreglo, elemento):
    for i in range(len(arreglo)):
        if arreglo[i] == elemento:
            return i
    return -1
*/
# -------------------------------------------


// Gómez Aguilar Jared Emmanuel
// 22210309
.data
    size_prompt:    .asciz "Enter the size of array: "
    elem_prompt:    .asciz "Enter element %d: "
    search_prompt:  .asciz "Enter number to search: "
    found_msg:      .asciz "Number found at position: %d\n"
    not_found_msg:  .asciz "Number not found in array\n"
    scanfmt:        .asciz "%ld"
    array:          .skip 400       // Space for 50 long integers
    size:           .quad 0
    search_num:     .quad 0

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
    b.ge    get_search_num       // If counter >= size, get search number

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

get_search_num:
    // Print search prompt
    adrp    x0, search_prompt
    add     x0, x0, :lo12:search_prompt
    bl      printf

    // Read search number
    adrp    x0, scanfmt
    add     x0, x0, :lo12:scanfmt
    adrp    x1, search_num
    add     x1, x1, :lo12:search_num
    bl      scanf

    // Linear search
    mov     x19, #0              // Counter
    adrp    x20, array          // Reset array pointer
    add     x20, x20, :lo12:array
    adrp    x22, search_num
    add     x22, x22, :lo12:search_num
    ldr     x22, [x22]          // Number to search

search_loop:
    cmp     x19, x21
    b.ge    not_found           // If counter >= size, number not found
    
    ldr     x23, [x20], #8      // Load value and increment pointer
    cmp     x23, x22
    b.eq    found              // If equal, number found
    add     x19, x19, #1        // Increment counter
    b       search_loop

found:
    adrp    x0, found_msg
    add     x0, x0, :lo12:found_msg
    add     x1, x19, #1         // Position (1-based)
    bl      printf
    b       exit

not_found:
    adrp    x0, not_found_msg
    add     x0, x0, :lo12:not_found_msg
    bl      printf

exit:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

.size main, .-main
