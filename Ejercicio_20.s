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
    prompt_size:    .asciz "Enter the number of elements in the array: "
    prompt_element: .asciz "Enter element #"
    prompt_search:  .asciz "Enter the element to search: "
    buffer:         .skip   20
    array:          .skip   100     // Space for 25 integers (4 bytes each)
    result_found:   .asciz "Element found at index: "
    result_not_found: .asciz "Element not found in the array\n"
    colon:          .asciz ": "
    newline:        .asciz "\n"

.text
.global _start

_start:
    // Print prompt for array size
    mov     x0, #1
    adr     x1, prompt_size
    mov     x2, #44
    mov     x8, #64
    svc     #0

    // Read array size
    mov     x0, #0
    adr     x1, buffer
    mov     x2, #20
    mov     x8, #63
    svc     #0

    // Convert array size to integer
    adr     x1, buffer
    mov     x2, #0              // result
    mov     x3, #10             // multiplier
convert_size_loop:
    ldrb    w4, [x1]
    cmp     w4, #'\n'
    beq     convert_size_done
    sub     w4, w4, #'0'
    mul     x2, x2, x3
    add     x2, x2, x4
    add     x1, x1, #1
    b       convert_size_loop

convert_size_done:
    mov     x9, x2              // Save array size
    mov     x10, #0             // Array index
    adr     x11, array          // Array base address

    // Input array elements
input_loop:
    cmp     x10, x9
    bge     input_done

    // Print prompt for current element
    mov     x0, #1
    adr     x1, prompt_element
    mov     x2, #19
    mov     x8, #64
    svc     #0

    // Print element number
    adr     x1, buffer
    mov     x2, x10
    add     x2, x2, #1          // 1-based indexing
    bl      int_to_ascii
    mov     x0, #1
    adr     x1, buffer
    bl      print_string

    // Print colon
    mov     x0, #1
    adr     x1, colon
    mov     x2, #2
    mov     x8, #64
    svc     #0

    // Read element
    mov     x0, #0
    adr     x1, buffer
    mov     x2, #20
    mov     x8, #63
    svc     #0

    // Convert element to integer
    adr     x1, buffer
    mov     x2, #0              // result
    mov     x3, #10             // multiplier
convert_element_loop:
    ldrb    w4, [x1]
    cmp     w4, #'\n'
    beq     convert_element_done
    sub     w4, w4, #'0'
    mul     x2, x2, x3
    add     x2, x2, x4
    add     x1, x1, #1
    b       convert_element_loop

convert_element_done:
    // Store element in array
    str     x2, [x11, x10, lsl #3]  // 8-byte integers
    add     x10, x10, #1

    b       input_loop

input_done:
    // Print prompt for search element
    mov     x0, #1
    adr     x1, prompt_search
    mov     x2, #35
    mov     x8, #64
    svc     #0

    // Read search element
    mov     x0, #0
    adr     x1, buffer
    mov     x2, #20
    mov     x8, #63
    svc     #0

    // Convert search element to integer
    adr     x1, buffer
    mov     x2, #0
