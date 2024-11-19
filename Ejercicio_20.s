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
    array:          .skip   400     // Space for integers
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
    
    // Convert index to ASCII (inlined)
    mov     x3, #10             // Divisor
    mov     x4, #0              // Digit counter
    adr     x1, buffer
index_to_ascii:
    udiv    x5, x2, x3          // Divide by 10
    msub    x6, x5, x3, x2      // Get remainder
    add     x6, x6, #'0'        // Convert to ASCII
    strb    w6, [x1, x4]        // Store digit
    add     x4, x4, #1          // Increment counter
    mov     x2, x5              // Update number
    cbnz    x2, index_to_ascii

    // Reverse the string
    mov     x5, #0              // Start index
    sub     x6, x4, #1          // End index
index_reverse:
    cmp     x5, x6
    bhs     index_reverse_done
    ldrb    w7, [x1, x5]
    ldrb    w8, [x1, x6]
    strb    w8, [x1, x5]
    strb    w7, [x1, x6]
    add     x5, x5, #1
    sub     x6, x6, #1
    b       index_reverse

index_reverse_done:
    mov     x2, #0
    strb    w2, [x1, x4]

    // Print index
    mov     x0, #1
    adr     x1, buffer
    mov     x2, #10             // Max length
    mov     x8, #64
    svc     #0

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
    mov     x2, #0              // result
    mov     x3, #10             // multiplier
convert_search_loop:
    ldrb    w4, [x1]
    cmp     w4, #'\n'
    beq     convert_search_done
    sub     w4, w4, #'0'
    mul     x2, x2, x3
    add     x2, x2, x4
    add     x1, x1, #1
    b       convert_search_loop

convert_search_done:
    // Linear search
    mov     x10, #0             // Index
    adr     x11, array          // Array base address

search_loop:
    cmp     x10, x9
    bge     not_found

    // Load current element
    ldr     x3, [x11, x10, lsl #3]
    cmp     x3, x2
    beq     found

    add     x10, x10, #1
    b       search_loop

found:
    // Print found message
    mov     x0, #1
    adr     x1, result_found
    mov     x2, #23
    mov     x8, #64
    svc     #0

    // Convert index to ASCII (reuse previous conversion)
    adr     x1, buffer
    mov     x2, x10
    add     x2, x2, #1          // 1-based indexing
    
    mov     x3, #10             // Divisor
    mov     x4, #0              // Digit counter
found_to_ascii:
    udiv    x5, x2, x3          // Divide by 10
    msub    x6, x5, x3, x2      // Get remainder
    add     x6, x6, #'0'        // Convert to ASCII
    strb    w6, [x1, x4]        // Store digit
    add     x4, x4, #1          // Increment counter
    mov     x2, x5              // Update number
    cbnz    x2, found_to_ascii

    // Reverse the string
    mov     x5, #0              // Start index
    sub     x6, x4, #1          // End index
found_reverse:
    cmp     x5, x6
    bhs     found_reverse_done
    ldrb    w7, [x1, x5]
    ldrb    w8, [x1, x6]
    strb    w8, [x1, x5]
    strb    w7, [x1, x6]
    add     x5, x5, #1
    sub     x6, x6, #1
    b       found_reverse

found_reverse_done:
    mov     x2, #0
    strb    w2, [x1, x4]

    // Print index
    mov     x0, #1
    adr     x1, buffer
    mov     x2, #10             // Max length
    mov     x8, #64
    svc     #0

    // Print newline
    mov     x0, #1
    adr     x1, newline
    mov     x2, #1
    mov     x8, #64
    svc     #0
    b       exit

not_found:
    // Print not found message
    mov     x0, #1
    adr     x1, result_not_found
    mov     x2, #34
    mov     x8, #64
    svc     #0

exit:
    mov     x0, #0              // return 0
    mov     x8, #93             // sys_exit
    svc     #0

ASCIINEMA REC
https://asciinema.org/a/690927
